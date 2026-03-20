-- Floating/split terminal toggle
-- <C-.>   opens a centered floating window (80x80% of the screen)
-- <C-S-.> opens a vertical split on the right
-- Switching between modes closes the current window and reopens in the new style.
-- Both share the same buffer, so the shell session persists across toggles.

local keymap       = require('keymap')

local terminal     = {}

terminal.config    = {
    float = {
        width  = 0.8, -- fraction of editor columns
        height = 0.7, -- fraction of editor lines
        border = 'rounded',
    },
    split = {
        width = 0.3, -- fraction of editor columns
    },
}

terminal.buf       = nil
terminal.float_win = nil
terminal.split_win = nil

function terminal.float_config()
    local width  = math.floor(vim.o.columns * terminal.config.float.width)
    local height = math.floor(vim.o.lines * terminal.config.float.height)
    local col    = math.floor((vim.o.columns - width) / 2)
    local row    = math.floor((vim.o.lines - height) / 2)
    return {
        relative = 'editor',
        width    = width,
        height   = height,
        row      = row,
        col      = col,
        style    = 'minimal',
        border   = terminal.config.float.border,
    }
end

function terminal.ensure_buf()
    if not terminal.buf or not vim.api.nvim_buf_is_valid(terminal.buf) then
        terminal.buf = vim.api.nvim_create_buf(false, true)
    end
end

function terminal.ensure_terminal()
    if vim.bo[terminal.buf].buftype ~= 'terminal' then
        vim.fn.jobstart(vim.o.shell, { term = true })
    end
end

function terminal.close_float()
    if terminal.float_win and vim.api.nvim_win_is_valid(terminal.float_win) then
        vim.api.nvim_win_close(terminal.float_win, false)
        terminal.float_win = nil
    end
end

function terminal.close_split()
    if terminal.split_win and vim.api.nvim_win_is_valid(terminal.split_win) then
        vim.api.nvim_win_close(terminal.split_win, false)
        terminal.split_win = nil
    end
end

function terminal.open_float()
    terminal.ensure_buf()
    terminal.float_win = vim.api.nvim_open_win(terminal.buf, true, terminal.float_config())
    vim.wo[terminal.float_win].winblend = 0
    terminal.ensure_terminal()
    vim.cmd('startinsert')
end

function terminal.open_split()
    terminal.ensure_buf()
    local width = math.floor(vim.o.columns * terminal.config.split.width)
    vim.cmd('botright vsplit')
    terminal.split_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal.split_win, terminal.buf)
    vim.api.nvim_win_set_width(terminal.split_win, width)
    terminal.ensure_terminal()
    vim.cmd('startinsert')
end

function terminal.toggle_float()
    if terminal.float_win and vim.api.nvim_win_is_valid(terminal.float_win) then
        terminal.close_float()
    else
        terminal.close_split()
        terminal.open_float()
    end
end

function terminal.toggle_split()
    if terminal.split_win and vim.api.nvim_win_is_valid(terminal.split_win) then
        terminal.close_split()
    else
        terminal.close_float()
        terminal.open_split()
    end
end

-- Very often terminal output clashes with the blending option, 
-- simply does not look nice, so I disable it for the terminal buffers
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].buftype == "terminal" then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win].winblend = 0
            vim.b.miniindentscope_disable = true
        end
    end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
        if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
            vim.api.nvim_buf_delete(terminal.buf, { force = true })
            terminal.buf = nil
        end
    end,
})

keymap.ntmap('<C-.>', terminal.toggle_float, 'Toggle floating terminal')
keymap.ntmap('<C-S-.>', terminal.toggle_split, 'Toggle split terminal (right)')

return terminal
