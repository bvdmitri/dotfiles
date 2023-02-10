-- This file contains configuration and mappings 
-- for the `Telescope` plugin

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {}

-- To get fzf loaded and working with builtin, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')

local opt = { 
    layout_strategy = 'vertical', 
    layout_config = { width = 0.80 }, 
    wrap_results = true 
}

local optconfig = vim.tbl_deep_extend("keep", opt, { cwd = vim.fn.stdpath('config') })

-- Builtin pickers
vim.keymap.set('n', '<space>f', function() builtin.git_files(opt) end)
vim.keymap.set('n', '<space>F', function() builtin.find_files(opt) end)
vim.keymap.set('n', '<space>h', function() builtin.help_tags(opt) end)
vim.keymap.set('n', '<space>g', function() builtin.live_grep(opt) end)
vim.keymap.set('n', '<space>b', function() builtin.buffers(opt) end)
vim.keymap.set('n', '<space>m', function() builtin.marks(opt) end)
vim.keymap.set('n', '<space>c', function() builtin.commands(opt) end)
vim.keymap.set('n', '<space>q', function() builtin.quickfix(opt) end)
vim.keymap.set('n', '<space>l', function() builtin.loclist(opt) end)
vim.keymap.set('n', '<space>r', function() builtin.registers(opt) end)
vim.keymap.set('n', '<space>d', function() builtin.diagnostics(opt) end)
vim.keymap.set('n', '<space>H', function() builtin.colorscheme(opt) end)

vim.keymap.set('n', '<space>V', function() builtin.find_files(optconfig) end)

-- LSP pickers
vim.keymap.set('n', '<space>R', function() builtin.lsp_references(opt) end)
vim.keymap.set('n', '<space>i', function() builtin.lsp_implementations(opt) end)
vim.keymap.set('n', '<space>D', function() builtin.lsp_definitions(opt) end)
vim.keymap.set('n', '<space>s', function() builtin.lsp_document_symbols(opt) end)
vim.keymap.set('n', '<space>S', function() builtin.lsp_workspace_symbols(opt) end)

-- Git pickers
vim.keymap.set('n', '<space>B', function() builtin.git_branches(opt) end)
vim.keymap.set('n', '<space>G', function() builtin.git_status(opt) end)

-- Treesitter pickers
vim.keymap.set('n', '<space>T', function() builtin.treesitter(opt) end)

-- Plugin pickers
vim.keymap.set('n', '<space>t', '<CMD>TodoTelescope<CR>')
