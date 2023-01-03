-- Remove arrows for now
vim.keymap.set('n', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Right>', '<Nop>', { noremap = true, silent = true })

-- Toggle search highlithing
vim.keymap.set('n', '<Leader>th', '<CMD>set hlsearch!<CR>')

-- Open a new tab
vim.keymap.set('n', '<Leader>nt', '<CMD>tabnew<CR>')

-- Open & edit vim.lua config
vim.keymap.set('n', '<Leader>ev', '<CMD>edit $MYVIMRC<CR>')

-- Open netrw explorer in the base directory
vim.keymap.set('n', '<Leader>ex', '<CMD>Explore<CR>')

-- Open netrw explorer in the current directory
vim.keymap.set('n', '<Leader>ec', '<CMD>edit.<CR>')

-- Update packages
vim.keymap.set('n', '<Leader>up', '<CMD>PackerSync<CR>')

-- Update treesitter
vim.keymap.set('n', '<Leader>ut', '<CMD>TSUpdate<CR>')

-- Make a window full screen
vim.keymap.set('n', '<C-w>b', '<CMD>vertical resize 1000<CR>z1000<CR>') 
