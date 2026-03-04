vim.pack.add({
    { src = gh('nvim-mini/mini.jump2d') },
    { src = gh('bvdmitri/recall.nvim'), version = 'reuse_opened_buffer' },
})

local keymap = require('keymap')

-- MiniJump2d
local MiniJump2d = require('mini.jump2d')

-- The default colorscheme is quite bad IMO
-- The new settings make the selesction standout and also undercurl
vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = 'White', standout = true })
vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', { fg = 'White', undercurl = true })
vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', { fg = 'White', undercurl = true })

MiniJump2d.setup({
    view = { dim = true, n_steps_ahead = 1 },
    mappings = { start_jumping = '' }
})

keymap.nmap('\\j', MiniJump2d.start, 'Jump anywhere on the screen')
keymap.nmap('<leader>gj', MiniJump2d.start, 'Goto anywhere on the screen')

-- Recal (better marks)

local recall = require('recall')

recall.setup({
    sign_highlight = 'Green',
    reuse_opened_windows = true
})

keymap.nmap('mm', recall.toggle, 'Toggle a global mark')
keymap.nmap('mc', recall.clear, 'Clear all global marks')
keymap.nmap('m]', recall.goto_next, 'Go to next global mark')
keymap.nmap('<C-m>', recall.goto_next, 'Go to next global mark')
keymap.nmap('m[', recall.goto_prev, 'Go to prev global mark')
