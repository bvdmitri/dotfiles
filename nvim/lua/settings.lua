local g, o = vim.g, vim.o

g.mapleader = ' '                     -- Set leader key to space
g.maplocalleader = ' '                -- Set local leader key to space
g.winborder = "rounded"               -- Default border style for windows

o.number = true                       -- Show absolute line numbers
o.relativenumber = true               -- Show relative line numbers
o.shiftwidth = 4                      -- Number of spaces for autoindent
o.softtabstop = 2                     -- Number of spaces for tabstop
o.expandtab = true                    -- Convert tabs to spaces
o.smarttab = true                     -- Tab respects shiftwidth at line start
o.mouse = 'a'                         -- Enable mouse in all modes
o.splitright = true                   -- Vertical splits open to the right
o.splitbelow = true                   -- Horizontal splits open below
o.signcolumn = "yes"                  -- Always show sign column
o.winwidth = 20                       -- Minimum width for active window
o.winheight = 10                      -- Minimum height for active window
o.winborder = "rounded"               -- Border style for windows
o.winblend = 5                        -- Transparency for windows (0-100)
o.pumborder = "rounded"               -- Border style for popup menu
o.pumheight = 10                      -- Maximum height for popup menu
o.pummaxwidth = 45                    -- Maximum width for popup menu
o.pumblend = 5                        -- Transparency for popup menu (0-100)
o.colorcolumn = '80'                  -- Highlight column at 80 characters
o.list = true                         -- Show hidden characters
o.listchars = "tab:» ,trail:·,nbsp:␣" -- Characters for hidden whitespace
o.inccommand = 'split'                -- Show substitute preview in split
o.updatetime = 250                    -- Time before CursorHold event (ms)
o.cursorline = true                   -- Highlight current line
o.scrolloff = 10                      -- Minimum lines above/below cursor
o.ignorecase = true                   -- Ignore case in search patterns
o.smartcase = true                    -- Override ignorecase with uppercase
o.breakindent = true                  -- Wrapped lines match indent

vim.diagnostic.config({
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '󱈸',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '󰌶',
        },
    },
    virtual_text = true,
    virtual_lines = false
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

