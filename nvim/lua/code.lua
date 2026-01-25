require('code.treesitter')
require('code.lsp')
require('code.dap')
require('code.snippets')
require('code.completion')

local keymap = require('keymap')

keymap.add_group('Code', '<leader>c')

keymap.nmap('<leader>cf', vim.lsp.buf.format, 'Format code')
keymap.nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
keymap.nmap('<leader>cd', vim.diagnostic.open_float, 'Line diagnostic')
keymap.nmap('<leader>cr', vim.lsp.buf.rename, 'Rename symbol under cursor')
keymap.nmap('<leader>ci', vim.lsp.buf.incoming_calls, 'Incoming calls (citations)')
keymap.nmap('<leader>co', vim.lsp.buf.outgoing_calls, 'Outgoing calls (children)')
