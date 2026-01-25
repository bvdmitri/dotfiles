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

keymap.add_group('Go To', '<leader>g')
keymap.nmap('<leader>gr', pick.lsp('references'), 'Go to references')
keymap.nmap('<leader>gi', pick.lsp('implementation'), 'Go to implementations')
keymap.nmap('<leader>gd', pick.lsp('definition'), 'Go to definition')
keymap.nmap('<leader>gD', pick.lsp('declaration'), 'Go to declaration')
keymap.nmap('<leader>gt', pick.lsp('type_definition'), 'Go to type definition')

keymap.add_group('File / Find', '<leader>f')
keymap.nmap('<leader>fa', '<C-^>', 'Open alternative file')
keymap.nmap('<leader>ff', pick.b.files, 'Find files')
keymap.nmap('<leader>fb', pick.b.buffers, 'Find buffers')
keymap.nmap('<leader>fr', pick.b.resume, 'Resume')
keymap.nmap('<leader>fh', pick.b.help, 'Find help')

keymap.add_group('Search', '<leader>s')
keymap.nmap('<leader>ss', pick.lsp('document_symbol'), 'Buffer symbols')
keymap.nmap('<leader>sS', pick.lsp('workspace_symbol_live'), 'Workspace symbols')
keymap.nmap('<leader>sd', pick.diagnostic('current'), 'Buffer diagnostics')
keymap.nmap('<leader>sD', pick.diagnostic('all'), 'Workspace diagnostics')
keymap.nmap('<leader>sG', pick.b.grep_live, 'Grep live')
keymap.nmap('<leader>sR', pick.b.resume, 'Resume')
