-- Setup VISUAL
vim.fn.setenv("VISUAL", "nvr -cc split --remote-wait +'set bufhidden=wipe'")

-- Packer bootstrap
-- As far as I can tell (the function below is copypated from the internet)
-- the procedure simply checks if the `packer` has been installed or not
-- (and downloads it if needed)
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

-- Two procedures below are computing the current working 
-- directory with the full absolute path (`pwd`) and 
-- with only the folder name (`wd`). I'm pretty much sure 
-- there is an easier way to achieve the same...

-- Read the current directory's path
local pwdhandle = io.popen("pwd")
vim.b.pwd = pwdhandle:read()
pwdhandle:close()

-- Get the basename of the current directory's path
local wdhandle = io.popen(string.format("basename %s", vim.b.pwd))
vim.b.wd = wdhandle:read()
wdhandle:close()

local startup = function(use)

  local configpath = vim.fn.stdpath('config')
  
  use 'wbthomason/packer.nvim'  -- The boss of all packages
  use 'nvim-lua/plenary.nvim'   -- Meta package with useful Lua functions 

  ----------------- Themes & Visuals -----------------
  use { 'sainnhe/everforest' , as = 'everforest' }
  use { 'morhetz/gruvbox' , as = 'gruvbox' }
  use { 'sainnhe/sonokai', as = 'sonokai' }

  ----------------- Code & IDEA ----------------------
  use 'neovim/nvim-lspconfig'                          -- Configuration for Language Server Protocol Client
  use 'j-hui/fidget.nvim'                              -- Language Server Protocol status bar
  use 'lukas-reineke/indent-blankline.nvim'            -- Add virtual lines to indentation
  use 'nvim-lualine/lualine.nvim'                      -- Status line
  use 'jeffkreeftmeijer/vim-numbertoggle'              -- Toggle number lines option automatically
  use 'folke/todo-comments.nvim'                       -- Todo comments features
  use 'nvim-treesitter/nvim-treesitter'                -- Fast syntax-tree parse & highlighter
  use 'nvim-tree/nvim-web-devicons'                    -- Dev icons (`brew install --cask font-hack-nerd-font`)
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }  -- File finder, requires `ripgrep` & `df` commands. 
  use 'nvim-telescope/telescope-fzf-native.nvim'          -- Install via `brew install ripgrep` & `brew install fd`
  use 'kylechui/nvim-surround'                         -- Plugin for convenient brackets
  use 'voldikss/vim-floaterm'                          -- Plugin for floating terminals
  use 'scalameta/nvim-metals'                          -- Standalone plugin for Scala LSP
  use 'rgroli/other.nvim'                              -- Plugin to open alternate files (context dependent)

  ----------------- Autocompletion -------------------
  use 'hrsh7th/nvim-cmp'                               -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'                           -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip'                       -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip'                               -- Snippets plugin

  local autocomplete = require("cmp_nvim_lsp").default_capabilities()

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then packer.sync() end

  -- All general settings & options are stored in the `init/editor`
  dofile(configpath .. "/init/editor.lua")
  
  -- netrw plugin options are stored in the `init/netrw`
  dofile(configpath .. "/init/netrw.lua")
  
  -- Extra keymaps are stored in the `init/keymaps`
  dofile(configpath .. "/init/keymaps.lua")
  
  -- Colorscheme & theme settings are stored in the `init/colorscheme`
  dofile(configpath .. "/init/colorscheme.lua")

  ----------------- Plugin configuration -------------
  dofile(configpath .. "/init/plugins/lsp.lua")
  dofile(configpath .. "/init/plugins/treesitter.lua")
  dofile(configpath .. "/init/plugins/telescope.lua")
  dofile(configpath .. "/init/plugins/floaterm.lua")
  dofile(configpath .. "/init/plugins/other.lua")

  -- LSP real-time status configuration
  require('fidget').setup {
    text = {
      spinner = "dots"
    }
  }
  
  require('lualine').setup {        -- Status line configuration
    options = { theme = 'sonokai' }
  }
  require('todo-comments').setup {} -- TODO comments plugin configuration
  require('nvim-surround').setup {} -- Convenient brackets configuration

end

return packer.startup(startup)
