local opt = { noremap = true, silent = true }

-- Remove arrows for now
vim.keymap.set('n', '<Up>', '<Nop>', opt)
vim.keymap.set('n', '<Down>', '<Nop>', opt)
vim.keymap.set('n', '<Left>', '<Nop>', opt)
vim.keymap.set('n', '<Right>', '<Nop>', opt)

-- Toggle search highlithing
vim.keymap.set('n', '<Leader>th', '<CMD>set hlsearch!<CR>', opt)

-- Open a new tab
vim.keymap.set('n', '<Leader>nt', '<CMD>tabnew<CR>', opt)

-- Open & edit vim.lua config
vim.keymap.set('n', '<Leader>ev', '<CMD>edit $MYVIMRC<CR>', opt)

-- Open netrw explorer in the base directory
vim.keymap.set('n', '<Leader>ex', '<CMD>Explore<CR>', opt)

-- Open netrw explorer in the current directory
vim.keymap.set('n', '<Leader>ec', '<CMD>edit.<CR>', opt)

-- Update packages
vim.keymap.set('n', '<Leader>up', '<CMD>PackerSync<CR>', opt)

-- Update treesitter
vim.keymap.set('n', '<Leader>ut', '<CMD>TSUpdate<CR>', opt)

-- Make a window full screen
vim.keymap.set('n', '<C-w>b', '<CMD>vertical resize 1000<CR>z1000<CR>', opt) 

-- Window navigation
-- Requirese: https://stackoverflow.com/questions/60870113/mac-generating-%E2%88%86%CB%9A%C2%AC-characters-instead-of-executing-vscode-shortcuts-that-involve
vim.keymap.set('n', '<M-h>', '<C-w>h', opt)
vim.keymap.set('n', '<M-j>', '<C-w>j', opt)
vim.keymap.set('n', '<M-k>', '<C-w>k', opt)
vim.keymap.set('n', '<M-l>', '<C-w>l', opt)
vim.keymap.set('t', '<M-h>', '<C-\\><C-n><C-w>h', opt)
vim.keymap.set('t', '<M-j>', '<C-\\><C-n><C-w>j', opt)
vim.keymap.set('t', '<M-k>', '<C-\\><C-n><C-w>k', opt)
vim.keymap.set('t', '<M-l>', '<C-\\><C-n><C-w>l', opt)

-- Exit terminal mode on <Esc>, use <C-V><Esc> to actually use <Esc>
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opt)
vim.keymap.set('t', '<C-v><Esc>', '<Esc>', opt)
