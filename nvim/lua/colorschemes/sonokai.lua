
vim.pack.add({
    { src = gh('sainnhe/sonokai'), name = 'theme-sonokai' }
})

-- I Like sonokai overall, but they use ugly black type of
-- WinSeparator, so I change it to light gray instead
vim.g.sonokai_dim_inactive_windows = 1
vim.g.sonokai_float_style = 'blend'
vim.g.sonokai_disable_terminal_colors = 1
vim.cmd("colorscheme sonokai")

vim.cmd("hi MiniPickMatchCurrent guibg='NvimDarkGray4'")
vim.cmd("hi MiniPickMatchMarked guifg='lightgreen'")
vim.cmd("hi MiniPickMatchRanges guifg='orange'")

