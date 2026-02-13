vim.pack.add({
    { src = gh('nvim-treesitter/nvim-treesitter') },
    { src = gh('nvim-treesitter/nvim-treesitter-context') },
    { src = gh('nvim-treesitter/nvim-treesitter-textobjects') },
})

local keymap = require('keymap')
local NvimTreesitter = require('nvim-treesitter')

NvimTreesitter.install({
    'rust',
    'javascript',
    'typescript',
    'python',
    'bash',
    'vim',
    'vimdoc',
    'c',
    'html',
    'lua',
    'julia',
    'markdown',
    'diff',
    'git_rebase',
    'gitcommit',
    'latex'
})

NvimTreesitter.update()

-- Treesitter Context
local TreesitterContext = require('treesitter-context')

TreesitterContext.setup({
    max_lines = 1
})

local function jump_to_context()
    TreesitterContext.go_to_context(vim.v.count1)
end

keymap.nmap('[c', jump_to_context, 'Jump up to the context')

-- Treesitter TextObjects
local TreesitterTextobjects = require('nvim-treesitter-textobjects')

TreesitterTextobjects.setup({
    move = {
        set_jumps = true
    }
})

local move = require('nvim-treesitter-textobjects.move')
local select = require('nvim-treesitter-textobjects.select')
local swap = require('nvim-treesitter-textobjects.swap')
local repeat_move = require('nvim-treesitter-textobjects.repeatable_move')

vim.g.no_plugin_maps = true

vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })

vim.keymap.set({ "x", "o" }, "am", function() select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "av", function() select.select_textobject("@parameter.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "iv", function() select.select_textobject("@parameter.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)

keymap.nmap('>m', function() swap.swap_next('@function.outer') end, 'Swap the current function with the next')
keymap.nmap('<m', function() swap.swap_previous('@function.outer') end, 'Swap the current function with the previous')
keymap.nmap('>v', function() swap.swap_next('@parameter.inner') end, 'Swap the current parameter with the next')
keymap.nmap('<v', function() swap.swap_previous('@parameter.inner') end, 'Swap the current parameter with the previous')

keymap.nmap(']m', function() move.goto_next_start('@function.outer', 'textobjects') end, 'Next function start')
keymap.nmap(']M', function() move.goto_next_end('@function.outer', 'textobjects') end, 'Next function end')
keymap.nmap('[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, 'Previous function start')
keymap.nmap('[M', function() move.goto_previous_end('@function.outer', 'textobjects') end, 'Previous function end')

keymap.nmap(']v', function() move.goto_next_start('@parameter.inner', 'textobjects') end, 'Next parameter start')
keymap.nmap(']V', function() move.goto_next_end('@parameter.inner', 'textobjects') end, 'Next parameter end')
keymap.nmap('[v', function() move.goto_previous_start('@parameter.inner', 'textobjects') end, 'Previous parameter start')
keymap.nmap('[V', function() move.goto_previous_end('@parameter.inner', 'textobjects') end, 'Previous parameter end')

keymap.nmap(']c', function() move.goto_next_start('@class.inner', 'textobjects') end, 'Next class start')
keymap.nmap(']C', function() move.goto_next_end('@class.inner', 'textobjects') end, 'Next class end')
keymap.nmap('[c', function() move.goto_previous_start('@class.inner', 'textobjects') end, 'Previous class start')
keymap.nmap('[C', function() move.goto_previous_end('@class.inner', 'textobjects') end, 'Previous class end')

keymap.nmap(']o', function() move.goto_next_start('@local.scope', 'locals') end, 'Next local')
keymap.nmap('[o', function() move.goto_previous_start('@local.scope', 'locals') end, 'Previous local')
