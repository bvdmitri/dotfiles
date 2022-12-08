-- Check if the plgugin has been enabled already
if vim.b.latex_ftplugin == 1 then
    return 
end
-- Indicate that the plugin has been enabled
vim.b.latex_ftplugin = 1
-- Set extra keymaps for the latex extension
local keyconfig = { noremap = true, silent = true }
vim.keymap.set('n', '<C-l>b', '<CMD>TexlabBuild<CR>', keyconfig)     -- Build on Ctrl-L b
vim.keymap.set('n', '<C-l>v', '<CMD>TexlabForward<CR>', keyconfig)   -- View on Ctrl-L v
