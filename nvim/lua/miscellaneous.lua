vim.pack.add({
    { src = gh('nvim-mini/mini.indentscope') },
    { src = gh('nvim-mini/mini.icons') },
    { src = gh('nvim-mini/mini.pairs') },
    { src = gh('nvim-mini/mini.surround') },
    { src = gh('nvim-mini/mini.statusline') },
    { src = gh('nmac427/guess-indent.nvim') },
})

require('mini.indentscope').setup()
require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.statusline').setup()
require('guess-indent').setup()
