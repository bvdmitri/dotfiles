vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.shiftwidth = 4
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.signcolumn = "yes"
vim.g.winborder = "rounded"
vim.o.winwidth = 20
vim.o.winheight = 10
vim.o.winborder = "rounded"
vim.o.winblend = 5
vim.o.autocomplete = true
vim.o.completeopt = 'menuone,popup,noselect,fuzzy,nosort'
vim.o.completefunc = 'v:lua.MiniCompletion.completefunc_lsp'
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.pummaxwidth = 45
vim.o.pumblend = 15

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    { src = gh('neovim/nvim-lspconfig') },
    { src = gh('nvim-mini/mini.indentscope') },
    { src = gh('nvim-mini/mini.icons') },
    { src = gh('nvim-mini/mini.snippets') },
    { src = gh('nvim-mini/mini.completion') },
    { src = gh('nvim-mini/mini.statusline') },
    { src = gh('nvim-mini/mini.files') },
    { src = gh('nvim-mini/mini.pick') },
    { src = gh('nvim-mini/mini.extra') },
    { src = gh('nvim-treesitter/nvim-treesitter') },
    { src = gh('folke/which-key.nvim') },
    { src = gh('sainnhe/sonokai'),                name = "theme-sonokai" },
    { src = gh('rebelot/kanagawa.nvim'),          name = "theme-kanagawa" },
})

-- I Like sonokai overall, but they use ugly black type of
-- WinSeparator, so I change it to light gray instead
vim.g.sonokai_dim_inactive_windows = 1
vim.cmd("colorscheme sonokai | hi WinSeparator guifg='NvimDarkGray4'")

require('mini.indentscope').setup()
require('mini.icons').setup()
require('mini.snippets').setup()
require('mini.completion').setup()
require('mini.statusline').setup()

local MiniFiles = require('mini.files')
MiniFiles.setup()

local MiniPick = require('mini.pick')
MiniPick.setup()

local MiniExtra = require('mini.extra')
MiniExtra.setup()

require('nvim-treesitter').install({ 'rust', 'javascript', 'typescript', 'python' })
require('nvim-treesitter').update()

vim.diagnostic.config({
    virtual_text = true
})

vim.lsp.config('basedpyright', {
    cmd = { "uv", "run", "basedpyright-langserver", "--stdio" },
    settings = { python = {} }
})

vim.lsp.config('ruff', {
    cmd = { "uv", "run", "ruff", "server" }
})

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')
vim.lsp.enable({ 'ts_ls', 'eslint' })
vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

-- Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local wk = require('which-key')

wk.setup({ preset = 'helix' })

wk.add({ '\\', group = 'Utilities' })
vim.keymap.set('n', '\\[', ':e $MYVIMRC<CR>', { desc = 'Change my Neovim config' })
vim.keymap.set('n', '\\]', MiniPick.builtin.help, { desc = 'Search help' })
vim.keymap.set('n', '\\h', ':noh<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '\\?', function() wk.show({ global = false }) end, { desc = 'Show buffer local keymaps (which-key)' })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window' })
vim.keymap.set('n', '<A-k>', ':resize -4<CR>', { desc = 'Make window smaller horizontally' })
vim.keymap.set('n', '<A-j>', ':resize +4<CR>', { desc = 'Make window larger horizontally' })
vim.keymap.set('n', '<A-h>', ':vertical resize -4<CR>', { desc = 'Make window smaller vertically' })
vim.keymap.set('n', '<A-l>', ':vertical resize +4<CR>', { desc = 'Make window larger vertically' })

vim.keymap.set('n', '<leader>e', MiniFiles.open, { desc = 'Explorer MiniFiles (resume)' })
vim.keymap.set('n', '<leader>E', function() MiniFiles.open(nil, false) end, { desc = 'Explorer MiniFiles (cwd)' })

wk.add({ '<leader>f', group = 'File/Find' })
vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find files (MiniPick)' })
vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Find buffers (MiniPick)' })
vim.keymap.set('n', '<leader>fr', MiniPick.builtin.resume, { desc = 'Resume (MiniPick)' })
-- vim.keymap.set('n', '<leader>e', MiniExtra.pickers.marks)
vim.keymap.set('n', '<leader>r', MiniPick.builtin.resume)
vim.keymap.set('n', '<leader>t', MiniPick.builtin.grep_live)
vim.keymap.set('n', '<leader>a', '<C-^>')

vim.keymap.set('n', '<leader>x', ':confirm quit<CR>')
vim.keymap.set('n', '<leader>u', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>sa', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>sr', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>si', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', '<leader>so', vim.lsp.buf.outgoing_calls)
-- vim.keymap.set('n', '<leader>fr', [[:Pick lsp scope='references'<CR>]])
-- vim.keymap.set('n', '<leader>fi', [[:Pick lsp scope='implementation'<CR>]])
-- vim.keymap.set('n', '<leader>fd', [[:Pick lsp scope='definition'<CR>]])
vim.keymap.set('n', '<leader>ds', [[:Pick lsp scope='document_symbol'<CR>]])
vim.keymap.set('n', '<leader>ws', [[:Pick lsp scope='workspace_symbol_livelass '<CR>]])
vim.keymap.set('n', '<leader>dd', [[:Pick diagnostic scope='current'<CR>]])
vim.keymap.set('n', '<leader>wd', [[:Pick diagnostic scope='all'<CR>]])

vim.keymap.set('t', '\\d', '<C-\\><C-N>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>')
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<CR>')
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<CR>')
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<CR>')
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<CR>')
