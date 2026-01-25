local g, o = vim.g, vim.o

g.mapleader = ' '
g.maplocalleader = ' '
g.winborder = "rounded"
o.number = true
o.relativenumber = true
o.mouse = 'a'
o.shiftwidth = 4
o.softtabstop = 2
o.expandtab = true
o.smarttab = true
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

vim.diagnostic.config({
    virtual_text = true
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
