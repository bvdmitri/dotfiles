vim.pack.add({
    { src = gh('chomosuke/typst-preview.nvim') }
})

vim.lsp.config['tinymist'] = {
    settings = {
        formatterMode = "typstyle"
    }
}

vim.lsp.enable('tinymist')

require('typst-preview').setup()
