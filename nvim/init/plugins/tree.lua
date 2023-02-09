-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup {}

local opt = { noremap = true, silent = true }

vim.keymap.set('n', '<Leader>\\', '<CMD>NvimTreeToggle<CR>', opt)
vim.keymap.set('n', '<Leader>]', '<CMD>NvimTreeFocus<CR>', opt)
vim.keymap.set('n', '<Leader>[', '<CMD>NvimTreeFindFile<CR>', opt)

-- Open Nvim Tree on startup
vim.api.nvim_create_autocmd("User", {
    pattern = "NvimTreeSetup",
    callback = function(data) 
        vim.cmd.NvimTreeOpen() 
    end
})
