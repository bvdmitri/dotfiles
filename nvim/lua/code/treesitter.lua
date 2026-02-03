vim.pack.add({
    { src = gh('nvim-treesitter/nvim-treesitter') },
})

local NvimTreesitter = require('nvim-treesitter')

NvimTreesitter.install({
    'rust',
    'javascript',
    'typescript',
    'python',
    'bash',
    'vim',
    'vimdoc',
    'c',
    'html',
    'lua',
    'julia',
    'markdown',
    'diff',
    'git_rebase',
    'gitcommit',
    'latex'
})

NvimTreesitter.update()
