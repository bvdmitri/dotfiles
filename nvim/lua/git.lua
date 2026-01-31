vim.pack.add({
    { src = gh('nvim-mini/mini-git') },
    { src = gh('nvim-mini/mini.diff') },
})

local MiniGit = require('mini.git')
local MiniDiff = require('mini.diff')

MiniGit.setup()
MiniDiff.setup()

local keymap = require('keymap')

keymap.add_group('Version Control', '<leader>v')
-- MiniGit related commands
keymap.nmap('<leader>vd', '<CMD>Git diff<CR>', 'Git diff')
keymap.nmap('<leader>vD', '<CMD>Git diff --staged<CR>', 'Git diff staged')
keymap.nmap('<leader>vl', '<CMD>Git log<CR>', 'Git log')
keymap.nmap('<leader>vb', '<CMD>Git blame -- %<CR>', 'Git blame')
keymap.nmap('<leader>vs', '<CMD>Git status -vv<CR>', 'Git status')
keymap.nmap('<leader>va', '<CMD>Git add %<CR>', 'Git add current file')
keymap.nmap('<leader>vA', '<CMD>Git add .<CR>', 'Git add all files')
keymap.nmap('<leader>vc', '<CMD>Git commit -v<CR>', 'Git commit')
keymap.nmap('<leader>vC', '<CMD>Git commit -a -v<CR>', 'Git commit all')
keymap.nmap('<leader>vp', '<CMD>Git push<CR>', 'Git push')
keymap.nmap('<leader>v]', MiniGit.show_at_cursor, 'Show at cursor')
-- MiniDiff related commands
keymap.nmap('<leader>vv', MiniDiff.toggle_overlay, 'Toggle diff overlay')
