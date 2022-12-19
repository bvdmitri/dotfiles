
-- Floating terminal mappings
vim.g.floaterm_keymap_toggle = '<F12>'

-- `F8` minimizes the floating terminal window
vim.keymap.set('t', '<F8>', '<CMD>FloatermUpdate --position=topright --width=0.2 --height=0.2<CR>')

-- `F9` maximizes the floating terminal window
vim.keymap.set('t', '<F9>', '<CMD>FloatermUpdate --position=center --width=0.9 --height=0.9<CR>')

-- `F10` is a compromise between min/max versions
vim.keymap.set('t', '<F10>', '<CMD>FloatermUpdate --position=right --width=0.4 --height=0.9<CR>')

-- Floating terminal mappings for regular terminal
vim.keymap.set('n', '<Leader>tt', '<CMD>FloatermNew! --name=terminal --position=right --wintype=float --disposable=true --title=Terminal --width=0.4 --height=0.9 <CR>')

-- Floating terminal mappings for Julia
-- vim.keymap.set('n', '<Leader>jj', '<CMD>FloatermNew! --name=julia --position=right --wintype=float --disposable=false --title=Julia --width=0.4 --height=0.9 julia<CR>')
-- vim.keymap.set('n', '<Leader>jf', '<CMD>%FloatermSend --name=julia<CR>')
-- vim.keymap.set('n', '<Leader>jl', '<CMD>FloatermSend --name=julia<CR>')
-- vim.keymap.set('n', '<Leader>jv', '<CMD>\'<,\'>FloatermSend --name=julia<CR>')
-- vim.keymap.set('n', '<Leader>jk', '<CMD>FloatermKill --name=julia<CR>')
-- vim.keymap.set('n', '<Leader>jh', '<CMD>FloatermHide --name=julia<CR>')
-- vim.keymap.set('n', '<Leader>js', '<CMD>FloatermShow --name=julia<CR>')
