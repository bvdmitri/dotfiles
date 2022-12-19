-- This file contains configuration and mappings 
-- for the `Telescope` plugin

local telescope = require('telescope.builtin')

vim.keymap.set('n', '<space>f', telescope.find_files)
vim.keymap.set('n', '<space>h', telescope.help_tags)
vim.keymap.set('n', '<space>g', telescope.live_grep)
vim.keymap.set('n', '<space>b', telescope.buffers)
vim.keymap.set('n', '<space>m', telescope.marks)
vim.keymap.set('n', '<space>c', telescope.commands)
vim.keymap.set('n', '<space>r', telescope.registers)
vim.keymap.set('n', '<space>d', telescope.diagnostics)
vim.keymap.set('n', '<space>i', telescope.lsp_implementations)
vim.keymap.set('n', '<space>D', telescope.lsp_definitions)
vim.keymap.set('n', '<space>s', telescope.lsp_document_symbols)
vim.keymap.set('n', '<space>S', telescope.lsp_workspace_symbols)
vim.keymap.set('n', '<space>t', '<CMD>TodoTelescope<CR>')
