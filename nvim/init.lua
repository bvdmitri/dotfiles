-- A function that simplifies loading packages from GitHub
---@diagnostic disable-next-line: lowercase-global
function gh(x) return 'https://github.com/' .. x end

vim.pack.add({
    { src = gh('nvim-neotest/nvim-nio') }, -- asynchronous IO
})

require('settings')
require('colorscheme')
require('keymap')
require('explorer')
require('search')
require('code')
require('miscellaneous')

