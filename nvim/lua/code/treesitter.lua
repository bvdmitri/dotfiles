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
    'markdown',
    'diff',
    'git_rebase',
    'gitcommit'
})

NvimTreesitter.update()
