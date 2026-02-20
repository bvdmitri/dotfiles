local notifications = require('notifications')

local function julia_pkg_command(cmd, action_name)
    local title = "Julia LSP" .. action_name
    local progress_handle = notifications.progress.handle.create({
        title = title,
        message = action_name,
        lsp_client = { name = "Julia LSP Installer" },
        percentage = 0,
    })

    local function on_exit(ret)
        local success = ret.code == 0
        progress_handle:finish({
            success = success,
            message = success and title .. " completed successfully" or
                title .. " failed (exit code: " .. ret.code .. ")"
        })
    end

    vim.system({ "julia", "--project=@nvim-lspconfig", "-e", cmd }, {
        text = true,
        stderr = function(_, data)
            progress_handle:report({ message = data })
        end,
    }, on_exit)

    progress_handle:report({
        message = action_name .. " in progress...",
        percentage = 50,
    })
end

vim.api.nvim_create_user_command("JuliaLSPInstall", function()
    julia_pkg_command([[
        using Pkg
        Pkg.add(url = "https://github.com/julia-vscode/LanguageServer.jl")
        Pkg.add(url = "https://github.com/julia-vscode/SymbolServer.jl")
        Pkg.add(url = "https://github.com/julia-vscode/StaticLint.jl")
        Pkg.add(url = "https://github.com/julia-vscode/DebugAdapter.jl")
    ]], "Install")
end, { desc = "Install Julia language server and dependencies" })

vim.api.nvim_create_user_command("JuliaLSPUpdate", function()
    julia_pkg_command([[
        using Pkg
        Pkg.update()
    ]], "Update")
end, { desc = "Update Julia language server and dependencies" })

vim.lsp.enable("julials")
