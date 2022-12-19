
local ensure_installed = {
    "help",
    "julia",
    "lua",
    "typescript",
    "java",
    "scala",
    "c",
    "python" 
}

require('nvim-treesitter.configs').setup { 
    ensure_installed = ensure_installed,
    auto_install = true,
    highlight = { 
        enable = true 
    },
    additional_vim_regex_highlighting = false
}
