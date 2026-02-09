vim.pack.add({
    { src = gh('neovim/nvim-lspconfig') },
    { src = gh('mason-org/mason.nvim') },
    { src = gh('mason-org/mason-lspconfig.nvim') },
})

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'ts_ls',
        'lua_ls',
        'eslint',
        'basedpyright',
        'ruff',
        'clangd',
        'texlab',
        -- 'julials' -- Mason is wrong for Julia, see the code.lsp.julia
    }
})

require('code.lsp.lua')
require('code.lsp.texlab')
require('code.lsp.julia')
