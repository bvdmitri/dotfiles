

-- [ Editor
vim.g.mapleader = '\\'

vim.opt.showmode = false       -- Do not show the mode / it is displayed in the status line
vim.opt.timeout = false        -- No timeout for commands
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
-- ] Backup

-- [ Autoread
vim.opt.autoread = true -- Autoreload files automatically
-- ] Autoread

-- [ list & listchars
-- vim.opt.list = true
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

  -- Code & IDEA
  use 'neovim/nvim-lspconfig'               -- Configuration for NVIM Language Server Protocol Client
  use 'j-hui/fidget.nvim'                   -- Language Server Protocol status bar
  use 'nvim-treesitter/nvim-treesitter'     -- Better syntax highlighting & other features, use :TSInstall <language> & :TSUpdate
  use 'lukas-reineke/indent-blankline.nvim' -- Add virtual lines to indentation
  use 'nvim-lualine/lualine.nvim'           -- Status line

  -- Autocompletion plugins for the LSP
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  local autocomplete = require("cmp_nvim_lsp").default_capabilities()

  -- Floating terminal
  use 'voldikss/vim-floaterm'

  -- Web devicons requires nerd font. Install via `brew tap homebrew/cask-fonts` & `brew install --cask font-hack-nerd-font`
  use 'nvim-tree/nvim-web-devicons'         -- Dev icons

  -- Telescope also requires `ripgrep` & `df` commands. Install via `brew install ripgrep` & `brew install fd`
  use 'nvim-telescope/telescope-fzf-native.nvim' -- Better search performance for the Telescope
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { { 'nvim-lua/plenary.nvim', } } } -- File finder

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then packer.sync() end

  vim.cmd.colorscheme("everforest")

  -- LSP Mappings
  local opts = { noremap = true, silent = true }
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

    vim.keymap.set('n', '<C-l>r', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<C-l>a', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<C-l>f', vim.lsp.buf.format, bufopts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    -- "Go to" related commands start with letter "g"
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.type_definition, bufopts)

    -- Autocompletion mappings
    local luasnip = require('luasnip')
    local cmp = require('cmp')
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-s>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      },
    }

  end

  local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150
  }

  local lspconfig = require('lspconfig')

  lspconfig.julials.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = autocomplete
  }

  lspconfig.texlab.setup {
    settings = {
      texlab = {
        build = {
          executable = "tectonic",
          args = {  "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
          onSave = true,
        },
        forwardSearch = {
          executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
          args = { "%l", "%p", "%f" }
        }
      }
    },
    capabilities = autocomplete
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
    highlight = { enable = true },
 }

  -- Status line configuration
  require('lualine').setup {}

  -- Floating terminal mappings
  vim.g.floaterm_keymap_toggle = '<F12>'
  vim.keymap.set('t', '<F8>', '<CMD>FloatermUpdate --position=topright --width=0.2 --height=0.2<CR>')
  vim.keymap.set('t', '<F9>', '<CMD>FloatermUpdate --position=center --width=0.9 --height=0.9<CR>')
  vim.keymap.set('t', '<F10>', '<CMD>FloatermUpdate --position=right --width=0.4 --height=0.9<CR>')
  -- Floating terminal mappings for Julia
  vim.keymap.set('n', '<Leader>jj', '<CMD>FloatermNew! --name=julia --position=right --wintype=float --disposable=false --title=Julia --width=0.4 --height=0.9 julia<CR>')
  vim.keymap.set('n', '<Leader>jf', '<CMD>%FloatermSend --name=julia<CR>')
  vim.keymap.set('n', '<Leader>jl', '<CMD>FloatermSend --name=julia<CR>')
  vim.keymap.set('n', '<Leader>jv', '<CMD>\'<,\'>FloatermSend --name=julia<CR>')
  vim.keymap.set('n', '<Leader>jk', '<CMD>FloatermKill --name=julia<CR>')
  vim.keymap.set('n', '<Leader>jh', '<CMD>FloatermHide --name=julia<CR>')
  vim.keymap.set('n', '<Leader>js', '<CMD>FloatermShow --name=julia<CR>')
  -- Floating terminal mappings for regular terminal
  vim.keymap.set('n', '<Leader>tt', '<CMD>FloatermNew! --name=terminal --position=right --wintype=float --disposable=true --title=Terminal --width=0.4 --height=0.9 <CR>')

  -- Window mappings
  vim.keymap.set('n', '<C-w>b', '<CMD>vertical resize 1000<CR>z1000<CR>')

  -- Telescope mappings
  local telescope = require('telescope.builtin')
  vim.keymap.set('n', '<space>f', telescope.find_files)
  vim.keymap.set('n', '<space>h', telescope.help_tags)
  vim.keymap.set('n', '<space>g', telescope.live_grep)
  vim.keymap.set('n', '<space>b', telescope.buffers)
  vim.keymap.set('n', '<space>m', telescope.marks)
  vim.keymap.set('n', '<space>c', telescope.commands)
  vim.keymap.set('n', '<space>r', telescope.registers)
  vim.keymap.set('n', '<space>d', telescope.diagnostics)
  vim.keymap.set('n', '<space>i', telescope.lsp_implementations)
  vim.keymap.set('n', '<space>D', telescope.lsp_definitions)
  vim.keymap.set('n', '<space>s', telescope.lsp_document_symbols)
  vim.keymap.set('n', '<space>S', telescope.lsp_workspace_symbols)

end

return packer.startup(startup)
-- ] Packer bootstrap 


