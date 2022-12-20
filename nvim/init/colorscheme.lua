
-- Enable 24-bit RGB color in the UI
vim.opt.termguicolors = true

-- Everforest theme configuration
vim.g.everforest_background = 'hard'
vim.g.everforest_better_performance = 1
vim.g.everforest_colors_override = {
  bg0 = { '#080808', '243' },
}

-- Grubvox theme configuration
-- vim.g.gruvbox_contrast_dark = 'hard'

vim.cmd.colorscheme 'everforest'
