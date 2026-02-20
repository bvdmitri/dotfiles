local dap = require('dap')

local function find_lldb_dap()
    local lldb_dap = vim.fn.exepath('lldb-dap')
    if lldb_dap ~= '' then
        return lldb_dap
    end

    local typical_paths = {
        '/Library/Developer/CommandLineTools/usr/bin/lldb-dap',
        '/usr/bin/lldb-dap',
        '/usr/local/bin/lldb-dap',
        '/usr/lib/llvm/bin/lldb-dap',
    }

    for _, path in ipairs(typical_paths) do
        if vim.uv.fs_stat(path) then
            return path
        end
    end

    return nil
end

local function dap_cpp_pick_program()
    local root = vim.fn.getcwd()
    local filename = vim.fn.expand("%:t:r")

    -- find executable files, excluding .git and .venv
    local files = vim.fn.systemlist({
        "find",
        root,
        "-type", "f",
        "-perm", "+111",
        "-not", "-path", root .. "/.git/*",
        "-not", "-path", root .. "/.venv/*",
    })

    if vim.v.shell_error ~= 0 or #files == 0 then
        vim.notify("No executable files found", vim.log.levels.WARN)
        return
    end

    -- run git check-ignore -v on all files
    local executables = vim.fn.systemlist(
        { "git", "check-ignore", "--stdin" },
        table.concat(files, "\n")
    )

    if #executables == 0 then
        vim.notify("No non-gitignored executables found", vim.log.levels.WARN)
        return
    end

    -- sort: prefer executables containing current filename
    table.sort(executables, function(a, b)
        local a_match = filename ~= "" and a:find(filename, 1, true) ~= nil
        local b_match = filename ~= "" and b:find(filename, 1, true) ~= nil

        if a_match ~= b_match then
            return a_match
        end

        return a < b
    end)

    local coro = assert(coroutine.running())

    -- The vim.ui.select is an async call,
    -- we need to wait for the result until we resume
    vim.schedule(function()
        vim.ui.select(executables, {
            prompt = "Select executable:",
            format_item = function(item)
                return item:gsub("^" .. vim.pesc(root) .. "/", "")
            end,
        }, function(choice)
            if choice then
                print("Selected:", choice)
            end
            coroutine.resume(coro, choice)
        end)
    end)

    return coroutine.yield()
end

local lldb_dap_path = find_lldb_dap()

if not lldb_dap_path then
    vim.notify(
        'lldb-dap not found. C++ debugging may not work.\n' ..
        'Install LLVM or Xcode Command Line Tools.',
        vim.log.levels.WARN
    )
end

dap.adapters.lldb = {
    name = 'lldb',
    type = 'executable',
    command = lldb_dap_path or 'lldb-dap',
}

dap.configurations.cpp = {
    {
        name = "Launch (LLDB)",
        type = "lldb",
        request = "launch",
        program = dap_cpp_pick_program,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    }
}
