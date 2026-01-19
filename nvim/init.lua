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
vim.o.completeopt = 'menuone,popup,noselect,fuzzy'
vim.o.completefunc = 'v:lua.MiniCompletion.completefunc_lsp'
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.pummaxwidth = 45
vim.o.pumblend = 5
vim.o.colorcolumn = '80'

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
    { src = gh('nvim-mini/mini.keymap') },
    { src = gh('nvim-mini/mini.extra') },
    { src = gh('nvim-treesitter/nvim-treesitter') },
    { src = gh('folke/which-key.nvim') },
    { src = gh('rafamadriz/friendly-snippets') },
    { src = gh('sainnhe/sonokai'),                name = "theme-sonokai" },
    { src = gh('rebelot/kanagawa.nvim'),          name = "theme-kanagawa" },
})

-- I Like sonokai overall, but they use ugly black type of
-- WinSeparator, so I change it to light gray instead
vim.g.sonokai_dim_inactive_windows = 1
vim.cmd("colorscheme sonokai")

vim.cmd("hi MiniPickMatchCurrent guibg='NvimDarkGray4'")
vim.cmd("hi MiniPickMatchMarked guifg='lightgreen'")
vim.cmd("hi MiniPickMatchRanges guifg='orange'")

require('mini.indentscope').setup()
require('mini.icons').setup()
require('mini.statusline').setup()

local MiniFiles = require('mini.files')
MiniFiles.setup()

local MiniPick = require('mini.pick')
MiniPick.setup()

local MiniExtra = require('mini.extra')
MiniExtra.setup()

local MiniCompletion = require('mini.completion')
-- Customize post-processing of LSP responses for a better user experience.
-- Don't show 'Text' suggestions (usually noisy) and show snippets last.
local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
end
MiniCompletion.setup({
    lsp_completion = {
      -- Without this config autocompletion is set up through `:h 'completefunc'`.
      -- Although not needed, setting up through `:h 'omnifunc'` is cleaner
      -- (sets up only when needed) and makes it possible to use `<C-u>`.
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
})

-- Set 'omnifunc' for LSP completion only when needed.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end
})

-- Advertise to servers that Neovim now supports certain set of completion and
-- signature features through 'mini.completion'.
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

local MiniSnippets = require('mini.snippets')
MiniSnippets.setup({
    snippets = {
        -- Load custom file with global snippets first
        MiniSnippets.gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        -- Load snippets based on current language by reading files from 
        -- "snippets/" subdirectories from 'runtimepath' directories
        MiniSnippets.gen_loader.from_lang(),
    },
})
MiniSnippets.start_lsp_server()

local MiniKeymap = require('mini.keymap')
-- Cycle through popup menu items with MiniCompletion
MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
-- Cycle through popup menu items backwards with MiniCompletion
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
-- On `<CR>` try to accept current completion item, fall back to accounting
-- for pairs from 'mini.pairs'
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
-- On `<BS>` just try to account for pairs from 'mini.pairs'
MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })


require('nvim-treesitter').install({ 'rust', 'javascript', 'typescript', 'python' })
require('nvim-treesitter').update()

vim.diagnostic.config({
    virtual_text = true
})

vim.lsp.config('basedpyright', { cmd = { "uv", "run", "basedpyright-langserver", "--stdio" } })
vim.lsp.config('ruff', { cmd = { "uv", "run", "ruff", "server" } })

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('eslint')
vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

-- Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local wk = require('which-key')

wk.setup({
    preset = 'helix',
    spec = {
        { '\\',        group = 'Utilities' },
        { '<leader>c', group = 'Code' },
        { '<leader>f', group = 'File/Find' },
        { '<leader>g', group = 'Go to' },
        { '<leader>s', group = 'Search' },
    }
})

vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>wincmd h<CR>', { desc = 'Move to the left window' })
vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>wincmd j<CR>', { desc = 'Move to the bottom window' })
vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>wincmd k<CR>', { desc = 'Move to the top window' })
vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>wincmd l<CR>', { desc = 'Move to the right window' })
vim.keymap.set('n', '<A-k>', ':resize -4<CR>', { desc = 'Make window smaller horizontally' })
vim.keymap.set('n', '<A-j>', ':resize +4<CR>', { desc = 'Make window larger horizontally' })
vim.keymap.set('n', '<A-h>', ':vertical resize -4<CR>', { desc = 'Make window smaller vertically' })
vim.keymap.set('n', '<A-l>', ':vertical resize +4<CR>', { desc = 'Make window larger vertically' })
vim.keymap.set('t', '\\d', '<C-\\><C-N>', { desc = 'Detach from terminal input mode' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>', { desc = 'Detach from terminal input mode' })
vim.keymap.set('i', '<C-x><C-x>', '<C-x><C-o>', { desc = 'Open omni-completion' })

-- Utilities group
vim.keymap.set('n', '\\[', ':e $MYVIMRC<CR>', { desc = 'Edit my Neovim config' })
vim.keymap.set('n', '\\]', MiniPick.builtin.help, { desc = 'Search help' })
vim.keymap.set('n', '\\h', ':noh<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '\\?', function() wk.show({ global = false }) end, { desc = 'Show buffer local keymaps (which-key)' })
vim.keymap.set('n', '\\x', ':confirm quit<CR>', { desc = 'Confirm quit' })

-- Global group
vim.keymap.set('n', '<leader>e', MiniFiles.open, { desc = 'Explorer MiniFiles (resume)' })
vim.keymap.set('n', '<leader>E', function() MiniFiles.open(nil, false) end, { desc = 'Explorer MiniFiles (cwd)' })
vim.keymap.set('n', '<leader>-', ':split<CR>', { desc = 'Split window below' })
vim.keymap.set('n', '<leader>|', ':vsplit<CR>', { desc = 'Split window right' })

-- Code group
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format code' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostic' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol under cursor' })
vim.keymap.set('n', '<leader>ci', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls (citations)' })
vim.keymap.set('n', '<leader>co', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls (children)' })

-- Go to group
vim.keymap.set('n', '<leader>gr', [[:Pick lsp scope='references'<CR>]], { desc = 'Go to references' })
vim.keymap.set('n', '<leader>gi', [[:Pick lsp scope='implementation'<CR>]], { desc = 'Go to implementations' })
vim.keymap.set('n', '<leader>gd', [[:Pick lsp scope='definition'<CR>]], { desc = 'Go to definition' })
vim.keymap.set('n', '<leader>gD', [[:Pick lsp scope='declaration'<CR>]], { desc = 'Go to declaration' })
vim.keymap.set('n', '<leader>gt', [[:Pick lsp scope='type_definition'<CR>]], { desc = 'Go to type definition' })

-- File/Find group
vim.keymap.set('n', '<leader>fa', '<C-^>', { desc = 'Open alternative file' })
vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find files (MiniPick)' })
vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Find buffers (MiniPick)' })
vim.keymap.set('n', '<leader>fr', MiniPick.builtin.resume, { desc = 'Resume (MiniPick)' })

-- Search
vim.keymap.set('n', '<leader>ss', [[:Pick lsp scope='document_symbol'<CR>]], { desc = 'Buffer symbols (MiniPick)' })
vim.keymap.set('n', '<leader>sS', [[:Pick lsp scope='workspace_symbol_live'<CR>]], { desc = 'Workspace symbols (MiniPick)' })
vim.keymap.set('n', '<leader>sd', [[:Pick diagnostic scope='current'<CR>]], { desc = 'Buffer diagnostics (MiniPick)' })
vim.keymap.set('n', '<leader>sD', [[:Pick diagnostic scope='all'<CR>]], {desc = 'Workspace diagnostics (MiniPick)' })
vim.keymap.set('n', '<leader>sG', MiniPick.builtin.grep_live, { desc = 'Grep live (MiniPick)' })

