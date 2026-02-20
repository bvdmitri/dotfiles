vim.pack.add({
    { src = gh('j-hui/fidget.nvim') },
})

require('fidget').setup({
    progress = {
        render_limit = 4,
    },
    notification = {
        override_vim_notify = true,
        view = {
            reflow = true,
        },
        window = {
            border = "rounded",
            winblend = 10,
            max_width = 60,
            zindex = 55
        }
    },
})

local notifications = {}

notifications.progress = require('fidget.progress')

return notifications
