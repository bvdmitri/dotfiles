vim.pack.add({
    { src = gh('nvim-mini/mini.pick') },
    { src = gh('nvim-mini/mini.extra') },
})

local MiniPick = require('mini.pick')
MiniPick.setup()

local MiniExtra = require('mini.extra')
MiniExtra.setup()

local keymap = require('keymap')

local pick = {}

pick.b = MiniPick.builtin

function pick.lsp(scope)
    return function() MiniExtra.pickers.lsp({ scope = scope }) end
end

function pick.diagnostic(scope)
    return function() MiniExtra.pickers.diagnostic({ scope = scope }) end
end

function pick.list(scope)
    return function() MiniExtra.pickers.list({ scope = scope }) end
end

keymap.add_group('Go To', '<leader>g')
keymap.nmap('<leader>gr', pick.lsp('references'), 'Go to references')
keymap.nmap('<leader>gi', pick.lsp('implementation'), 'Go to implementations')
keymap.nmap('<leader>gd', pick.lsp('definition'), 'Go to definition')
keymap.nmap('<leader>gD', pick.lsp('declaration'), 'Go to declaration')
keymap.nmap('<leader>gt', pick.lsp('type_definition'), 'Go to type definition')

keymap.add_group('File', '<leader>f')
keymap.nmap('<leader>fa', '<C-^>', 'Open alternative file')

keymap.add_group('Search', '<leader>s')
keymap.nmap('<leader>sf', pick.b.files, 'Files')
keymap.nmap('<leader>sb', pick.b.buffers, 'Buffers')
keymap.nmap('<leader>sh', pick.b.help, 'Find help')
keymap.nmap('<leader>ss', pick.lsp('document_symbol'), 'Buffer symbols')
keymap.nmap('<leader>sS', pick.lsp('workspace_symbol_live'), 'Workspace symbols')
keymap.nmap('<leader>sd', pick.diagnostic('current'), 'Buffer diagnostics')
keymap.nmap('<leader>sD', pick.diagnostic('all'), 'Workspace diagnostics')
keymap.nmap('<leader>sq', pick.list('quickfix'), 'Quickfix list')
keymap.nmap('<leader>sg', pick.b.grep_live, 'Grep live')
keymap.nmap('<leader>sr', pick.b.resume, 'Resume')

return pick
