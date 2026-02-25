vim.pack.add({
    { src = gh('chomosuke/typst-preview.nvim') }
})

vim.lsp.enable('tinymist')

require('typst-preview').setup()
