

-- [ Editor
vim.g.mapleader = '\\'

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show line numbers relative to the current line
vim.opt.wrap = false           -- Do not wrap lines

vim.keymap.set({'n', 'x'}, 'cp', '"+y') -- Use 'cp' for copy from the system clipboard
vim.keymap.set({'n', 'x'}, 'cv', '"+p') -- Use 'cv' for paste from the system clipboard
vim.keymap.set('n', '<Leader>th', '<CMD>set hlsearch!<CR>') -- Toggle search highlithing
vim.keymap.set('n', '<Leader>ev', '<CMD>edit $MYVIMRC<CR>') -- Open & edit vim.lua config

vim.opt.splitright = true
-- ] Editor

-- [ Backup
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupext = ".vbackup"
-- ] Backup

-- [ Autoread
vim.opt.autoread = true -- Autoreload files automatically
-- ] Autoread

-- [ list & listchars
vim.opt.list = true
-- vim.opt.listchars:append('leadmultispace:···⥑') -- Leading spaces highlighting
-- ] list & listchars

-- [ spaces & tabs
vim.opt.tabstop = 4       -- Number of spaces that a <Tab> in the file counts for.
vim.opt.softtabstop = 4   -- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.opt.shiftwidth = 4    -- Number of spaces to use for each step of (auto)indent.
vim.opt.expandtab = true  -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
vim.opt.autoindent = true -- Copy indent from current line when starting a new line.
vim.opt.copyindent = true -- Copy the structure of the existing lines indent when autoindenting a new line.
-- ] spaces & tabs

-- [ Packer bootstrap
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd.packadd("packer.nvim")
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = require('packer')

-- Startup function
local startup = function(use)
  use 'wbthomason/packer.nvim'  -- The boss of all packages

  -- Themes & Visuals
  use { 'sainnhe/everforest' , as = 'everforest' }

  vim.cmd.colorscheme("everforest")

  -- Code & IDEA
  use 'neovim/nvim-lspconfig'               -- Configuration for NVIM Language Server Protocol Client
  use 'j-hui/fidget.nvim'                   -- Language Server Protocol status bar
  use 'nvim-treesitter/nvim-treesitter'     -- Better syntax highlighting & other features, use :TSInstall <language> & :TSUpdate
  use 'lukas-reineke/indent-blankline.nvim' -- Add virtual lines to indentation
  use 'nvim-lualine/lualine.nvim'           -- Status line
  use 'romgrk/barbar.nvim'                  -- Better tabs

  -- Floating terminal
  use 'voldikss/vim-floaterm'

  -- Web devicons requires nerd font. Install via `brew tap homebrew/cask-fonts` & `brew install --cask font-hack-nerd-font`
  use 'nvim-tree/nvim-web-devicons'         -- Dev icons

  -- Telescope also requires `ripgrep` & `df` commands. Install via `brew install ripgrep` & `brew install fd`
  use 'nvim-telescope/telescope-fzf-native.nvim' -- Better search performance for the Telescope
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { { 'nvim-lua/plenary.nvim', } } } -- File finder

  -- use 'vim-airline/vim-airline' -- Status line at the bottom

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then packer.sync() end

  -- LSP Mappings
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<Leader>ds', vim.diagnostic.show, opts)
  vim.keymap.set('n', '<Leader>dh', vim.diagnostic.hide, opts)
  vim.keymap.set('n', '<Leader>df', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  -- The `on_attach` function is used to only map the following keys 
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<Leader>cr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<Leader>cf', function() vim.lsp.buf.format { async = true } end, bufopts)

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)


  end

  local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150
  }

  local lspconfig = require('lspconfig')

  lspconfig.julials.setup {
      on_attach = on_attach,
      flags = lsp_flags
  }

  -- LSP real-time status configuration
  require('fidget').setup {
    text = {
        spinner = "dots"
    }
  }

  -- Treesitter configuration
  require('nvim-treesitter.configs').setup { 
    ensure_installed = { "julia" },
    auto_install = true,
    highlight = { enable = true }
  }

  -- Status line configuration
  require('lualine').setup {}

  -- Floating terminal mappings
  vim.g.floaterm_keymap_toggle = '<F12>'
  -- Floating terminal mappings for Julia
  vim.keymap.set('n', '<Leader>tjj', '<CMD>FloatermNew! --name=julia --position=right --wintype=float --disposable=false --title=Julia --width=0.4 --height=0.9 julia<CR>')
  vim.keymap.set('n', '<Leader>tjf', '<CMD>%FloatermSend --name=julia<CR>')

  -- Telescope mappings
  local telescope = require('telescope.builtin')
  vim.keymap.set('n', '<Leader>ff', telescope.find_files)
  vim.keymap.set('n', '<Leader>fg', telescope.live_grep)
  vim.keymap.set('n', '<Leader>fb', telescope.buffers)
  vim.keymap.set('n', '<Leader>fh', telescope.help_tags)
  vim.keymap.set('n', '<Leader>fm', telescope.marks)
  vim.keymap.set('n', '<Leader>fc', telescope.commands)
  vim.keymap.set('n', '<Leader>fr', telescope.registers)
  vim.keymap.set('n', '<Leader>ld', telescope.lsp_definitions)
  vim.keymap.set('n', '<Leader>li', telescope.lsp_implementations)
  vim.keymap.set('n', '<Leader>ls', telescope.lsp_document_symbols)
  vim.keymap.set('n', '<Leader>ly', telescope.lsp_workspace_symbols)
  vim.keymap.set('n', '<Leader>ld', telescope.diagnostics)

end

return packer.startup(startup)
-- ] Packer bootstrap 


