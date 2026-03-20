vim.pack.add({
    { src = gh('greggh/claude-code.nvim') },
})


local keymap = require('keymap')

keymap.add_group('Coding Assistant', '<leader>a')

local claude = require('claude-code')

claude.setup({
    keymaps = {
        toggle = {
            variants = {
                continue = '<leader>ac',
                verbose = '<leader>av',
                resume = '<leader>ar'
            }
        },
        window_navigation = false,
        scrolling = false
    },
    window = {
        position = "float",
        float = {
            width = "80%",
            height = "80%",
            row = "center",
            col = "center",
            relative = "editor",
            border = "rounded",
        },
    },
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf)
                and vim.bo[buf].buftype == "terminal"
                and (vim.api.nvim_buf_get_name(buf)):lower():find("claude")
            then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end,
})
