vim.pack.add({
    { src = gh('jalvesaq/hlterm') }
})

local hlterm = require('hlterm')
local keymap = require('keymap')

hlterm.setup({
    mappings = {
        start = '<leader>rs',
        send = '<leader>rr',
        quit = '<leader>rq',
    }
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = { '*.jl' },
    callback = function(_)
        keymap.add_group('REPL', '<leader>r')
    end
})

-- Just a note for myself
-- julia -e 'using Pkg; Pkg.Apps.add(; url="https://github.com/aviatesk/JETLS.jl", rev="release")'
vim.lsp.config("jetls", {
    cmd = {
        "jetls",
        "--threads=auto",
        "--",
    },
    filetypes = { "julia" },
    root_markers = { "Project.toml" }
})
vim.lsp.enable("jetls")
