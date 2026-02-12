vim.pack.add({
    -- { src = gh('nvim-mini/mini.notify') },
    { src = gh('j-hui/fidget.nvim') },
})

-- MiniNotify settings
-- local window_bottom_right_corner = function()
--     local has_statusline = vim.o.laststatus > 0
--     local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
--     return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
-- end
-- require('mini.notify').setup({
--     lsp_progress = { enable = false },
--     window = { config = window_bottom_right_corner }
-- })
require('fidget').setup({
    notification = {
        override_vim_notify = true,
        window = {
            border = "rounded",
            winblend = 0
        }
    },
})

local notifications = {}

notifications.progress = require('fidget.progress')

return notifications
