vim.pack.add({
    { src = gh('johnseth97/codex.nvim') }
})

local keymap = require('keymap')

keymap.nmap('<leader>cc', '<CMD>CodexToggle<CR>', 'Open Coding Assistant')
