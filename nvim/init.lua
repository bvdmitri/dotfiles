-- Helper function to build GitHub URLs for plugins
-- Simplifies plugin source declarations by concatenating base URL with repo path
---@diagnostic disable-next-line: lowercase-global
function gh(x) return 'https://github.com/' .. x end

-- Core dependencies used by multiple other plugins
-- Installed globally to ensure availability before other modules load
vim.pack.add({
    { src = gh('nvim-neotest/nvim-nio') }, -- asynchronous IO library for neovim
    { src = gh('nvim-lua/plenary.nvim') }, -- utility functions for Lua/neovim
})

-- Load configuration modules in order
-- Each module handles a specific aspect of the editor setup
require('settings')        -- Basic editor settings (indent, line numbers, etc.)
require('colorscheme')     -- Color scheme configuration
require('keymap')          -- Key bindings and mappings
require('explorer')        -- File explorer setup
require('search')          -- Search functionality (find, grep, etc.)
require('git')             -- Git integration
require('code')            -- Code editing features (LSP, completion, etc.)
require('notifications')   -- Notification handling
require('miscellaneous')   -- Other miscellaneous configurations

