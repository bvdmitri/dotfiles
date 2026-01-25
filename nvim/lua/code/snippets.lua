vim.pack.add({
    { src = gh('nvim-mini/mini.snippets') },
    { src = gh('rafamadriz/friendly-snippets') },
})

local MiniSnippets = require('mini.snippets')

MiniSnippets.setup({
    snippets = {
        -- Load custom file with global snippets first
        MiniSnippets.gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories
        MiniSnippets.gen_loader.from_lang(),
    },
})

MiniSnippets.start_lsp_server()
