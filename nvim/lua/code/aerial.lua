vim.pack.add({
    { src = gh('stevearc/aerial.nvim') }
})

local Aerial = require('aerial')

Aerial.setup({
    keymaps = {
        ["{"] = "actions.prev_up",
        ["}"] = "actions.next_up",
        ["[["] = "actions.prev",
        ["]]"] = "actions.next",
    }
})

local keymap = require('keymap')

keymap.nmap('<leader>cT', '<CMD>AerialToggle!<CR>', 'Toggle code tree')
keymap.nmap('<leader>ct', '<CMD>AerialToggle float<CR>', 'Float code tree')
keymap.nmap('<leader>cn', '<CMD>AerialNavToggle<CR>', 'Toggle code nav tree')
