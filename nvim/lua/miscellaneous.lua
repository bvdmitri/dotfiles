vim.pack.add({
    { src = gh('nvim-mini/mini.starter') },
    { src = gh('nvim-mini/mini.sessions') },
    { src = gh('nvim-mini/mini.indentscope') },
    { src = gh('nvim-mini/mini.jump2d') },
    { src = gh('nvim-mini/mini.pairs') },
    { src = gh('nvim-mini/mini.icons') },
    { src = gh('nvim-mini/mini.statusline') },
    { src = gh('nmac427/guess-indent.nvim') },
    { src = gh('chrisgrieser/nvim-early-retirement') },
    { src = gh('OXY2DEV/markview.nvim') },
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

-- Autopairs
require('mini.pairs').setup()

-- The rest of miscellaneous
require('mini.icons').setup()
require('mini.statusline').setup()
require('guess-indent').setup()
require('early-retirement').setup({})

-- Markdown preview
require('markview').setup({
    preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {}
    }
})

local function pack_clean()
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end

    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        print("No unused plugins.")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

vim.api.nvim_create_user_command('PackClean', pack_clean, {})
vim.api.nvim_create_user_command('PackUpdate', 'lua vim.pack.update()', {})
