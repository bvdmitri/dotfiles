-- This file contains configuration and mappings 
-- for the `Telescope` plugin

local telescope = require('telescope.builtin')

local opt = { 
    layout_strategy = 'vertical', 
    layout_config = { width = 0.95 }, 
    wrap_results = true 
}

-- Builtin pickers
vim.keymap.set('n', '<space>f', function() telescope.git_files(opt) end)
vim.keymap.set('n', '<space>F', function() telescope.find_files(opt) end)
vim.keymap.set('n', '<space>h', function() telescope.help_tags(opt) end)
vim.keymap.set('n', '<space>g', function() telescope.live_grep(opt) end)
vim.keymap.set('n', '<space>b', function() telescope.buffers(opt) end)
vim.keymap.set('n', '<space>m', function() telescope.marks(opt) end)
vim.keymap.set('n', '<space>c', function() telescope.commands(opt) end)
vim.keymap.set('n', '<space>q', function() telescope.quickfix(opt) end)
vim.keymap.set('n', '<space>r', function() telescope.registers(opt) end)
vim.keymap.set('n', '<space>d', function() telescope.diagnostics(opt) end)

-- LSP pickers
vim.keymap.set('n', '<space>R', function() telescope.lsp_references(opt) end)
vim.keymap.set('n', '<space>i', function() telescope.lsp_implementations(opt) end)
vim.keymap.set('n', '<space>D', function() telescope.lsp_definitions(opt) end)
vim.keymap.set('n', '<space>s', function() telescope.lsp_document_symbols(opt) end)
vim.keymap.set('n', '<space>S', function() telescope.lsp_workspace_symbols(opt) end)

-- Git pickers
vim.keymap.set('n', '<space>B', function() telescope.git_branches(opt) end)
vim.keymap.set('n', '<space>G', function() telescope.git_status(opt) end)

-- Treesitter pickers
vim.keymap.set('n', '<space>T', function() telescope.treesitter(opt) end)

-- Plugin pickers
vim.keymap.set('n', '<space>t', '<CMD>TodoTelescope<CR>')
