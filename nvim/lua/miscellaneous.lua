vim.pack.add({
    { src = gh('nvim-mini/mini.starter') },
    { src = gh('nvim-mini/mini.sessions') },
    { src = gh('nvim-mini/mini.indentscope') },
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

keymap.nmap('\\s', write_cwd_session, 'Write current session')

require('mini.starter').setup()
require('mini.indentscope').setup({
    draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none()
    }
})
require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.statusline').setup()
require('mini.notify').setup()
require('guess-indent').setup()
