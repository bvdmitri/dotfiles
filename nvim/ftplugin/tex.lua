-- Check if the plgugin has been enabled already
if vim.b.latex_ftplugin == 1 then
    return 
end
-- Indicate that the plugin has been enabled
vim.b.latex_ftplugin = 1
-- LaTeX specific environment settings
vim.opt.tabstop = 2       -- Number of spaces that a <Tab> in the file counts for.
vim.opt.softtabstop = 2   -- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.opt.shiftwidth = 2    -- Number of spaces to use for each step of (auto)indent.
vim.opt.expandtab = true  -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.

vim.opt.wrap = true  -- Wrap long sentences
vim.opt.spell = true -- Enable spell checking
vim.opt.spelllang = { "en_us" }
-- Set extra keymaps for the latex extension
local keyconfig = { noremap = true, silent = true }
vim.keymap.set('n', '<C-l>b', '<CMD>TexlabBuild<CR>', keyconfig)     -- Build on Ctrl-L b
vim.keymap.set('n', '<C-l>v', '<CMD>TexlabForward<CR>', keyconfig)   -- View on Ctrl-L v
