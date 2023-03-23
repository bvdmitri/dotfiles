-- This file contains configuration and mappings 
-- for the `Telescope` plugin

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {}

-- To get fzf loaded and working with builtin, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')

function make_opt()
    local current_bufnr = vim.api.nvim_get_current_buf()
    local current_winnr = vim.api.nvim_get_current_win()
    local opt = { 
        layout_strategy = 'vertical', 
        layout_config = { width = 0.80 }, 
        wrap_results = true,
        bufnr = current_bufnr,
        winnr = current_winnr
    }
    return opt
end

function make_opt_config()
    local optconfig = vim.tbl_deep_extend("keep", make_opt(), { cwd = vim.fn.stdpath('config') })
    return optconfig
end

-- Builtin pickers
vim.keymap.set('n', '<space>f', function() builtin.git_files(make_opt()) end)
vim.keymap.set('n', '<space>F', function() builtin.find_files(make_opt()) end)
vim.keymap.set('n', '<space>h', function() builtin.help_tags(make_opt()) end)
vim.keymap.set('n', '<space>g', function() builtin.live_grep(make_opt()) end)
vim.keymap.set('n', '<space>b', function() builtin.buffers(make_opt()) end)
vim.keymap.set('n', '<space>m', function() builtin.marks(make_opt()) end)
vim.keymap.set('n', '<space>c', function() builtin.commands(make_opt()) end)
vim.keymap.set('n', '<space>q', function() builtin.quickfix(make_opt()) end)
vim.keymap.set('n', '<space>l', function() builtin.loclist(make_opt()) end)
vim.keymap.set('n', '<space>r', function() builtin.registers(make_opt()) end)
vim.keymap.set('n', '<space>d', function() builtin.diagnostics(make_opt()) end)
vim.keymap.set('n', '<space>H', function() builtin.colorscheme(make_opt()) end)

vim.keymap.set('n', '<space>V', function() builtin.find_files(make_opt_config()) end)

-- LSP pickers
vim.keymap.set('n', '<space>R', function() builtin.lsp_references(make_opt()) end)
vim.keymap.set('n', '<space>i', function() builtin.lsp_implementations(make_opt()) end)
vim.keymap.set('n', '<space>D', function() builtin.lsp_definitions(make_opt()) end)
vim.keymap.set('n', '<space>s', function() builtin.lsp_document_symbols(make_opt()) end)
vim.keymap.set('n', '<space>S', function() builtin.lsp_workspace_symbols(make_opt()) end)

-- Git pickers
vim.keymap.set('n', '<space>B', function() builtin.git_branches(make_opt()) end)
vim.keymap.set('n', '<space>G', function() builtin.git_status(make_opt()) end)

-- Treesitter pickers
vim.keymap.set('n', '<space>T', function() builtin.treesitter(make_opt()) end)

-- Plugin pickers
vim.keymap.set('n', '<space>t', '<CMD>TodoTelescope<CR>')
