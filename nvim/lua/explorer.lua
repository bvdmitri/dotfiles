vim.pack.add({
    { src = gh('nvim-mini/mini.files') },
})

local MiniFiles = require('mini.files')

MiniFiles.setup({
    windows = {
        preview = true,
        width_preview = 50
    }
})

local keymap = require('keymap')

keymap.nmap('<leader>e', MiniFiles.open, 'Explorer MiniFiles (resume)')
keymap.nmap('<leader>E', function() MiniFiles.open(nil, false) end, 'Explorer MiniFiles (cwd)')
