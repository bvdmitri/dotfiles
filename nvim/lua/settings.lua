local g, o = vim.g, vim.o

g.mapleader = ' '
g.maplocalleader = ' '
g.winborder = "rounded"

o.number = true
o.relativenumber = true
o.shiftwidth = 4
o.softtabstop = 2
o.expandtab = true
o.smarttab = true
o.mouse = 'a'
o.splitright = true
o.splitbelow = true
o.signcolumn = "yes"
o.winwidth = 20
o.winheight = 10
o.winborder = "rounded"
o.winblend = 5
o.autocomplete = true
o.completeopt = 'menuone,popup,noselect,fuzzy'
o.completefunc = 'v:lua.MiniCompletion.completefunc_lsp'
o.pumborder = "rounded"
o.pumheight = 10
o.pummaxwidth = 45
o.pumblend = 5
o.colorcolumn = '80'
o.list = true
o.listchars = "tab:» ,trail:·,nbsp:␣"
o.inccommand = 'split'
o.updatetime = 250
o.cursorline = true
o.scrolloff = 10
o.ignorecase = true
o.smartcase = true
o.breakindent = true

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
    callback = function()
        vim.hl.on_yank()
    end,
})
