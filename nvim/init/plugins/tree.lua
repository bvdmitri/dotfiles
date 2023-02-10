-- disable netrw at the very start of your init.lua (stronhly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup {
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = true,
    view = {
        float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = {
                relative = "win",
                row = 2,
                col = 5,
                width = 75,
                height = 50
            }
        }
    },
    actions = {
        open_file = {
            quit_on_open = true,
            window_picker = {
                enable = false
            }
        }
    }
}

local opt = { noremap = true, silent = true }

vim.keymap.set('n', '<Leader>\\', '<CMD>NvimTreeToggle<CR>', opt)
vim.keymap.set('n', '<Leader>]', '<CMD>NvimTreeFindFile<CR>', opt)
vim.keymap.set('n', '<Leader>[', '<CMD>NvimTreeFocus<CR>', opt)
