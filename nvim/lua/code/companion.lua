vim.pack.add({
    { src = gh('greggh/claude-code.nvim') },
})

local claude = require('claude-code')

claude.setup({
    keymaps = {
        toggle = {
            normal = '<leader>aa',
            variants = {
                continue = '<leader>ac',
                verbose = '<leader>av'
            }
        }
    },
    window = {
        position = "float",
        float = {
            width = "30%",
            height = "100%",
            row = 0,
            col = 999,
            relative = "editor",
            border = "rounded",
        },
    },
})


local keymap = require('keymap')

keymap.add_group('Coding Assistant', '<leader>a')

keymap.nmap('<leader>aa', '<CMD>ClaudeCode<CR>', 'Toggle Code Companion')
keymap.nmap('<leader>ar', '<CMD>ClaudeCodeResume<CR>', 'Display interactive conversation picker')
keymap.nmap('<leader>ac', '<CMD>ClaudeCodeContinue<CR>', 'Resume the most recent conversation')

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
