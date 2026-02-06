vim.pack.add({
    { src = gh('nvim-treesitter/nvim-treesitter') },
    { src = gh('nvim-treesitter/nvim-treesitter-context') },
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

local TreesitterContext = require('treesitter-context')

TreesitterContext.setup()

local keymap = require('keymap')

local function jump_to_context()
    TreesitterContext.go_to_context(vim.v.count1)
end

keymap.nmap('[c', jump_to_context, 'Jump up to the context')
