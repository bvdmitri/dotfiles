vim.pack.add({
    { src = gh('olimorris/codecompanion.nvim') }
})

local companion = require('codecompanion')

companion.setup({
    interactions = {
        chat = { adapter = "codex" },
        inline = { adapter = "codex" },
        cmd = { adapter = "codex" },
    },
})

local keymap = require('keymap')

keymap.add_group('Coding Assistant', '<leader>a')

keymap.nvmap('<leader>aa', '<CMD>CodeCompanionAction<CR>', 'Coding Assistant Actions')
keymap.nmap('<leader>ac', '<CMD>CodeCompanionChat Toggle<CR>', 'Toggle Coding Assistant Chat')
keymap.vmap('<leader>ae', '<CMD>CodeCompanion /explain<CR>', 'Coding Assistant /explain')
