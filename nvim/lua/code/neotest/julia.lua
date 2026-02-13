local lib = require("neotest.lib")
local notifications = require('notifications')

local adapter = {}
local ns = vim.api.nvim_create_namespace("neotest-julia-testitem")

adapter.name = "neotest-julia-testitem"
adapter.utils = {}

function adapter.utils.strip_quotes(str)
    return str:gsub('^"', ''):gsub('"$', '')
end

function adapter.utils.strip_ansi_codes(str)
    return str:gsub("\27%[[0-9;]*[A-Za-z]", "")
end

function adapter.utils.read_tests_output(file_path_or_plain_string)
    local output = ""
    if file_path_or_plain_string and vim.fn.filereadable(file_path_or_plain_string) == 1 then
        output = table.concat(vim.fn.readfile(file_path_or_plain_string), "\n")
    elseif type(file_path_or_plain_string) == "string" then
        output = file_path_or_plain_string
    end

    return adapter.utils.strip_ansi_codes(output)
end

function adapter.utils.collect_failures(output)
    local failures = {}

    for _, pattern in ipairs({
        "Test Failed at ([^:]+):(%d+)",
        "Error During Test at ([^:]+):(%d+)",
    }) do
        for file, line in output:gmatch(pattern) do
            table.insert(failures, {
                file = file,
                line = tonumber(line) - 1,
            })
        end
    end

    local expressions = {}
    for expr in output:gmatch("Expression:%s*(.-)\n") do
        table.insert(expressions, expr)
    end

    local evaluated = {}
    for val in output:gmatch("Evaluated:%s*(.-)\n") do
        table.insert(evaluated, val)
    end

    return failures, expressions, evaluated
end

function adapter.root(dir)
    return lib.files.match_root_pattern("Project.toml")(dir)
end

function adapter.is_test_file(file_path)
    local filename = file_path:match("([^/\\]+)$")

    if not filename then
        return false
    end

    return
        filename:match("^test_.*%.jl$") or
        filename:match("^tests_.*%.jl$") or
        filename:match(".*_test%.jl$") or
        filename:match(".*_tests%.jl$")
end

function adapter.discover_positions(path)
    local query = [[
    (
      (macrocall_expression
        (macro_identifier
          (identifier) @macro_name
        )
        (macro_argument_list
          (string_literal) @test.name
          (compound_statement)
        )
      )
      (#eq? @macro_name "testitem")
    ) @test.definition
    ]]
    return lib.treesitter.parse_positions(path, query, {
        nested_namespaces = false,
    })
end

function adapter.build_spec(args)
    local position = args.tree:data()

    if position.type ~= "test" then
        return nil
    end

    local file_path = position.path
    local root = adapter.root(file_path)

    if not root then
        error("Could not determine Julia project root")
    end

    local test_name = adapter.utils.strip_quotes(position.name)
    local test_command = {
        "julia",
        "--project=" .. root,
        "--compile=min",
        "--startup-file=no",
        "--threads=2,2",
        "--gcthreads=2,1",
        "-e",
        string.format([[
        using TestItemRunner
        @run_package_tests(
            filter = ti -> ti.name == %q && occursin(ti.filename, %q)
        )
        ]], test_name, file_path)
    }

    local test_progress = notifications.progress.handle.create({
        title = test_name,
        message = "Test",
        lsp_client = { name = "Julia testitem runner" },
        percentage = 0
    })

    return {
        command = test_command,
        cwd = root,
        context = {
            test_name = test_name,
            file = file_path,
            progress = test_progress
        },
    }
end

function adapter.results(spec, result, tree)
    if spec.context.progress ~= nil then
        spec.context.progress:report({
            percentage = 50
        })
    end
    local output = adapter.utils.read_tests_output(result.output)
    local failures, expressions, evaluated =
        adapter.utils.collect_failures(output)
    local status = (#failures == 0) and "passed" or "failed"
    local diagnostics = {}

    for i, failure in ipairs(failures) do
        local file = vim.fn.fnamemodify(failure.file, ":p")
        local bufnr = vim.fn.bufnr(file, true)

        if bufnr ~= -1 then
            diagnostics[bufnr] = diagnostics[bufnr] or {}

            local message = expressions[i] or "Test failed"
            if evaluated[i] then
                message = message .. "\nEvaluated: " .. evaluated[i]
            end

            table.insert(diagnostics[bufnr], {
                lnum = failure.line,
                col = 0,
                message = message,
                severity = vim.diagnostic.severity.ERROR,
                source = "neotest-julia",
            })
        end
    end

    vim.diagnostic.reset(ns)
    for bufnr, diags in pairs(diagnostics) do
        vim.diagnostic.set(ns, bufnr, diags)
    end

    local results = {}
    for _, node in tree:iter_nodes() do
        local data = node:data()
        local is_test = data.type == "test"
        local is_name_matches = adapter.utils.strip_quotes(data.name) ==
            adapter.utils.strip_quotes(spec.context.test_name)

        if is_test and is_name_matches then
            results[data.id] = {
                status = status,
                output = result.output,
                short = output:sub(1, 128),
                location = (#failures > 0) and {
                    path = vim.fn.fnamemodify(failures[1].file, ":p"),
                    line = failures[1].line,
                } or nil,
            }
        end
    end

    if spec.context.progress ~= nil then
        spec.context.progress:finish()
    end

    return results
end

return adapter
