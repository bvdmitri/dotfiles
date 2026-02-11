local lib = require("neotest.lib")

local adapter = {}
local ns = vim.api.nvim_create_namespace("neotest-julia-testitem")

adapter.name = "neotest-julia-testitem"

-- Detect Julia project root
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

-----------------------------------------------------------
-- BUILD SPEC
-----------------------------------------------------------
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

    local test_name = position.name
    -- remove leading and trailing quotes
    test_name = test_name:gsub('^"', ''):gsub('"$', '')

    local command = {
        "julia",
        "--project=" .. root,
        "-e",
        string.format([[
      using TestItemRunner
      @run_package_tests filter=ti->ti.name==%q
    ]], test_name)
    }
    return {
        command = command,
        cwd = root,
        context = {
            test_name = test_name,
            file = position.path,
        },
    }
end

-----------------------------------------------------------
-- RESULTS
-----------------------------------------------------------
function adapter.results(spec, result, tree)
    local output = ""

    -- Read output (integrated strategy writes to file)
    if result.output and vim.fn.filereadable(result.output) == 1 then
        output = table.concat(vim.fn.readfile(result.output), "\n")
    elseif type(result.output) == "string" then
        output = result.output
    end


    -- Strip ANSI
    output = output:gsub("\27%[[0-9;]*[A-Za-z]", "")

    ------------------------------------------------------------
    -- Collect ALL failure locations
    ------------------------------------------------------------
    local failures = {}
    for file, line in output:gmatch("Test Failed at ([^:]+):(%d+)") do
        table.insert(failures, {
            file = file,
            line = tonumber(line) - 1,
        })
    end
    -- Errors during test
    for file, line in output:gmatch("Error During Test at ([^:]+):(%d+)") do
        table.insert(failures, {
            file = file,
            line = tonumber(line) - 1,
        })
    end

    local status = (#failures == 0) and "passed" or "failed"

    -- Collect expressions (in order)
    local expressions = {}
    for expr in output:gmatch("Expression:%s*(.-)\n") do
        table.insert(expressions, expr)
    end

    -- Collect evaluated values (optional)
    local evaluated_vals = {}
    for val in output:gmatch("Evaluated:%s*(.-)\n") do
        table.insert(evaluated_vals, val)
    end

    ------------------------------------------------------------
    -- Set manual diagnostics (grouped per buffer)
    ------------------------------------------------------------
    local diagnostics_by_buf = {}

    for i, failure in ipairs(failures) do
        local file = vim.fn.fnamemodify(failure.file, ":p")
        local bufnr = vim.fn.bufnr(file, true)


        if bufnr ~= -1 then
            diagnostics_by_buf[bufnr] = diagnostics_by_buf[bufnr] or {}

            local message = expressions[i] or "Test failed"
            if evaluated_vals[i] then
                message = message .. "\nEvaluated: " .. evaluated_vals[i]
            end

            table.insert(diagnostics_by_buf[bufnr], {
                lnum = failure.line,
                col = 0,
                message = message,
                severity = vim.diagnostic.severity.ERROR,
                source = "neotest-julia",
            })
        end
    end

    vim.diagnostic.reset(ns)
    for bufnr, diags in pairs(diagnostics_by_buf) do
        vim.diagnostic.set(ns, bufnr, diags)
    end

    ------------------------------------------------------------
    -- Build neotest result table
    ------------------------------------------------------------
    local results = {}

    -- Extract first failure summary for short message
    local failure_line = output:match("([^\n]+: Test Failed[^\n]+)") or
        output:match("([^\n]+: Error During Test at [^\n]+)")

    for _, node in tree:iter_nodes() do
        local data = node:data()

        if data.type == "test"
            and data.name:gsub('^"', ''):gsub('"$', '') == spec.context.test_name:gsub('^"', ''):gsub('"$', '') then
            results[data.id] = {
                status = status,
                output = result.output,
                short = failure_line
                    or (status == "passed" and "Passed" or "Failed"),
                location = (#failures > 0) and {
                    path = vim.fn.fnamemodify(failures[1].file, ":p"),
                    line = failures[1].line,
                } or nil,
            }
        end
    end

    return results
end

return adapter
