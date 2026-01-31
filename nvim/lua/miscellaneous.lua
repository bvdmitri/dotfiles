vim.pack.add({
    { src = gh('nvim-mini/mini.starter') },
    { src = gh('nvim-mini/mini.sessions') },
    { src = gh('nvim-mini/mini.indentscope') },
    { src = gh('nvim-mini/mini.jump2d') },
    { src = gh('nvim-mini/mini.icons') },
    { src = gh('nvim-mini/mini.pairs') },
    { src = gh('nvim-mini/mini.surround') },
    { src = gh('nvim-mini/mini.statusline') },
    { src = gh('nvim-mini/mini.notify') },
    { src = gh('nmac427/guess-indent.nvim') },
})

local keymap = require('keymap')

local MiniSessions = require('mini.sessions')

MiniSessions.setup()

local function write_cwd_session()
    local session_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    return MiniSessions.write(session_name)
end

-- This is only required to create a new session
keymap.nmap('\\s', write_cwd_session, 'Write current session')

require('mini.starter').setup()
-- Custom settings for MiniIndentscope
-- The default settings include some kind of animation,
-- which I don't really like. Override to disable the animation
require('mini.indentscope').setup({
    draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none()
    }
})
-- Custom settings for MiniJump2d
-- The default colorscheme is quite bad IMO
-- The new settings make the selesction standout and also undercurl
vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = 'White', standout = true })
vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', { fg = 'White', undercurl = true })
vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', { fg = 'White', undercurl = true })
local MiniJump2d = require('mini.jump2d')
MiniJump2d.setup({
    view = {
        dim = true,
        n_steps_ahead = 1
    }
})
keymap.nmap('\\j', MiniJump2d.start, 'Jump anywhere on the screen')
-- The rest of miscellaneous
require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.statusline').setup()
require('mini.notify').setup()
require('guess-indent').setup()
