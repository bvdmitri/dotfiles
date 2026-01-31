-- A function that simplifies loading packages from GitHub
---@diagnostic disable-next-line: lowercase-global
function gh(x) return 'https://github.com/' .. x end

-- Those are some kind of handy plugins used by many other plugins
-- So they should be installed here globally
vim.pack.add({
    { src = gh('nvim-neotest/nvim-nio') }, -- asynchronous IO
    { src = gh('nvim-lua/plenary.nvim') }, -- generic functions
})

require('settings')
require('colorscheme')
require('keymap')
require('explorer')
require('search')
require('git')
require('code')
require('miscellaneous')

