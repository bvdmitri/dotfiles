-- This file contains general options/settings for the NeoVIM editor

-- Do not show the mode / it is displayed in the status line
vim.opt.showmode = false

-- No timeout for commands
vim.opt.timeout = false

-- Show line numbers
vim.opt.number = true

-- Show line numbers relative to the current line
vim.opt.relativenumber = true

-- Do not wrap lines
vim.opt.wrap = false

-- Scroll offset
vim.opt.scrolloff = 8

-- Splits windows on right
vim.opt.splitright = true

-- Changes autosuggestions to bash like style
vim.opt.wildmode = { "longest", "list" }

-- Saves more commands in history
vim.opt.history = 1000

-- Highlight the line of the cursor
vim.opt.cursorline = true

-- Highlight the number of the line instead
vim.opt.cursorlineopt = 'number'

-- Write .swap file if nothing happens for 1000ms
vim.opt.updatetime = 1000

-- Hightlight the 120th column
vim.opt.colorcolumn = '120'

-- Make a backup before overwriting a file and keep the backup
vim.opt.backup = false

-- Make a backup before overwriting a file but do not keep the backup
vim.opt.writebackup = true

-- Autoreload files automatically
vim.opt.autoread = true 

-- Show invisible symbols
-- vim.opt.list = true

-- Leading spaces highlighting
-- vim.opt.listchars:append('leadmultispace:···⥑') 

-- Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

-- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.opt.softtabstop = 4

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

-- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
vim.opt.expandtab = true

-- Copy indent from current line when starting a new line.
vim.opt.autoindent = true

-- Copy the structure of the existing lines indent when autoindenting a new line.
vim.opt.copyindent = true
