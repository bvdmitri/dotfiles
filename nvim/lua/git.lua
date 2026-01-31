vim.pack.add({
    { src = gh('nvim-mini/mini-git') },
})

local MiniGit = require('mini.git')

MiniGit.setup({})
