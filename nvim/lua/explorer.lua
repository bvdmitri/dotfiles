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

local function open_directory_of_current_file()
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
end

local function open_directory_of_current_project()
    MiniFiles.open(nil, false)
end

keymap.nmap('<leader>e', open_directory_of_current_file, 'Explorer MiniFiles (resume)')
keymap.nmap('<leader>E', open_directory_of_current_project, 'Explorer MiniFiles (cwd)')
