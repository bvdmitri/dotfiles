local keymap = {}

vim.pack.add({
    { src = gh('folke/which-key.nvim') },
    { src = gh('nvim-mini/mini.keymap') },
})

local WhichKey = require('which-key')

-- Shows keymap reminders in a nice window
WhichKey.setup({
    preset = 'helix'
})

function keymap.set(mode, mapping, command, description)
    vim.keymap.set(mode, mapping, command, { desc = description })
end

function keymap.nmap(mapping, command, description)
    keymap.set('n', mapping, command, description)
end

function keymap.ntmap(mapping, command, description)
    keymap.set({ 'n', 't' }, mapping, command, description)
end

function keymap.tmap(mapping, command, description)
    keymap.set('t', mapping, command, description)
end

function keymap.imap(mapping, command, description)
    keymap.set('i', mapping, command, description)
end

function keymap.add_group(group_name, group_prefix)
    WhichKey.add({
        { group_prefix, group = group_name }
    })
end

-- Global group
keymap.ntmap('<C-h>', '<CMD>wincmd h<CR>', 'Move to the left window')
keymap.ntmap('<C-j>', '<CMD>wincmd j<CR>', 'Move to the bottom window')
keymap.ntmap('<C-k>', '<CMD>wincmd k<CR>', 'Move to the top window')
keymap.ntmap('<C-l>', '<CMD>wincmd l<CR>', 'Move to the right window')

keymap.nmap('<A-k>', ':resize -4<CR>', 'Make window smaller horizontally')
keymap.nmap('<A-j>', ':resize +4<CR>', 'Make window larger horizontally')
keymap.nmap('<A-h>', ':vertical resize -4<CR>', 'Make window smaller vertically')
keymap.nmap('<A-l>', ':vertical resize +4<CR>', 'Make window larger vertically')

keymap.tmap('\\d', '<C-\\><C-N>', 'Detach from terminal input mode')
keymap.tmap('<Esc><Esc>', '<C-\\><C-N>', 'Detach from terminal input mode')

keymap.nmap('<leader>-', ':split<CR>', 'Split window below')
keymap.nmap('<leader>|', ':vsplit<CR>', 'Split window right')

-- Utilities group
keymap.add_group('Utilities', '\\')

keymap.nmap('\\]', ':e $MYVIMRC<CR>', 'Edit my Neovim config')
keymap.nmap('\\h', ':noh<CR>', 'Clear search highlight')
keymap.nmap('\\x', ':confirm quit<CR>', 'Confirm quit')


local MiniKeymap = require('mini.keymap')
-- Cycle through popup menu items with <Tab>
-- Cycle through popup menu items backwards with <S-Tab>
-- On `<CR>` try to accept current completion item,
-- fall back to accounting for pairs from 'mini.pairs'
-- On `<BS>` just try to account for pairs from 'mini.pairs'
MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })


return keymap
