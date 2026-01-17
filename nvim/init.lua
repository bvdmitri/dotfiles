
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
  { src = gh('ibhagwan/fzf-lua') },
  { src = gh('neovim/nvim-lspconfig') },
  { src = gh('nvim-mini/mini.indentscope') },
  { src = gh('nvim-mini/mini.icons') },
  { src = gh('nvim-mini/mini.snippets') },
  { src = gh('nvim-mini/mini.completion') },
  { src = gh('nvim-mini/mini.statusline') },
  { src = gh('nvim-mini/mini.files') },
  { src = gh('nvim-treesitter/nvim-treesitter') },
  { src = gh('sainnhe/sonokai'), name = "theme-sonokai" },
  { src = gh('rebelot/kanagawa.nvim'), name = "theme-kanagawa" },
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

local FzfLua = require('fzf-lua')
FzfLua.setup()

-- FzfLua will be the default for all the "select" actions 
-- E.g. vim.lsp.buf.code_actions() will open Fzf UI
FzfLua.register_ui_select()

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

vim.keymap.set('n', '\\[', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '\\]', FzfLua.helptags)
vim.keymap.set('n', '\\h', ':noh<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<A-k>', ':resize -4<CR>')
vim.keymap.set('n', '<A-j>', ':resize +4<CR>')
vim.keymap.set('n', '<A-h>', ':vertical resize -4<CR>')
vim.keymap.set('n', '<A-l>', ':vertical resize +4<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', '<leader>q', FzfLua.global)
vim.keymap.set('n', '<leader>w', FzfLua.files)
vim.keymap.set('n', '<leader>e', FzfLua.quickfix)
vim.keymap.set('n', '<leader>r', FzfLua.resume)
vim.keymap.set('n', '<leader>t', FzfLua.live_grep)
vim.keymap.set('n', '<leader>a', '<C-^>')
vim.keymap.set('n', '<leader>-', MiniFiles.open)
vim.keymap.set('n', '<leader>_', function() MiniFiles.open(nil, false) end)

vim.keymap.set('n', '<leader>x', ':confirm quit<CR>')
vim.keymap.set('n', '<leader>u', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>fr', FzfLua.lsp_references)
vim.keymap.set('n', '<leader>fi', FzfLua.lsp_implementations)
vim.keymap.set('n', '<leader>fo', vim.lsp.buf.outgoing_calls)
vim.keymap.set('n', '<leader>fd', FzfLua.lsp_definitions)
vim.keymap.set('n', '<leader>sa', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>sd', FzfLua.lsp_document_symbols)
vim.keymap.set('n', '<leader>sw', FzfLua.lsp_live_workspace_symbols)
vim.keymap.set('n', '<leader>sr', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ss', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', '<leader>dd', FzfLua.lsp_document_diagnostics)
vim.keymap.set('n', '<leader>dw', FzfLua.lsp_workspace_diagnostics)

vim.keymap.set('t', '\\d', '<C-\\><C-N>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>')
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<CR>')
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<CR>')
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<CR>')
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<CR>')
