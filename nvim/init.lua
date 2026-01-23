vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.shiftwidth = 4
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.signcolumn = "yes"
vim.g.winborder = "rounded"
vim.o.winwidth = 20
vim.o.winheight = 10
vim.o.winborder = "rounded"
vim.o.winblend = 5
vim.o.autocomplete = true
vim.o.completeopt = 'menuone,popup,noselect,fuzzy'
vim.o.completefunc = 'v:lua.MiniCompletion.completefunc_lsp'
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.pummaxwidth = 45
vim.o.pumblend = 5
vim.o.colorcolumn = '80'
vim.o.list = true
vim.o.listchars = "tab:» ,trail:·,nbsp:␣"
vim.o.inccommand = 'split'
vim.o.updatetime = 250
vim.o.cursorline = true
vim.o.scrolloff = 10

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    { src = gh('neovim/nvim-lspconfig') },
    { src = gh('mason-org/mason.nvim') },
    { src = gh('mason-org/mason-lspconfig.nvim') },
    { src = gh('mfussenegger/nvim-dap') },
    { src = gh('nvim-neotest/nvim-nio') },
    { src = gh('rcarriga/nvim-dap-ui') },
    { src = gh('jay-babu/mason-nvim-dap.nvim') },
    { src = gh('nvim-mini/mini.indentscope') },
    { src = gh('nvim-mini/mini.icons') },
    { src = gh('nvim-mini/mini.pairs') },
    { src = gh('nvim-mini/mini.surround') },
    { src = gh('nvim-mini/mini.snippets') },
    { src = gh('nvim-mini/mini.completion') },
    { src = gh('nvim-mini/mini.statusline') },
    { src = gh('nvim-mini/mini.files') },
    { src = gh('nvim-mini/mini.pick') },
    { src = gh('nvim-mini/mini.keymap') },
    { src = gh('nvim-mini/mini.extra') },
    { src = gh('nvim-treesitter/nvim-treesitter') },
    { src = gh('folke/which-key.nvim') },
    { src = gh('nmac427/guess-indent.nvim') },
    { src = gh('rafamadriz/friendly-snippets') },
    { src = gh('sainnhe/sonokai'),                name = "theme-sonokai" },
    { src = gh('rebelot/kanagawa.nvim'),          name = "theme-kanagawa" },
})

-- I Like sonokai overall, but they use ugly black type of
-- WinSeparator, so I change it to light gray instead
vim.g.sonokai_dim_inactive_windows = 1
vim.g.sonokai_float_style = 'blend'
vim.g.sonokai_disable_terminal_colors = 1
vim.cmd("colorscheme sonokai")

vim.cmd("hi MiniPickMatchCurrent guibg='NvimDarkGray4'")
vim.cmd("hi MiniPickMatchMarked guifg='lightgreen'")
vim.cmd("hi MiniPickMatchRanges guifg='orange'")

require('mini.indentscope').setup()
require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.statusline').setup()
require('guess-indent').setup()

local MiniFiles = require('mini.files')
MiniFiles.setup()

local MiniPick = require('mini.pick')
MiniPick.setup()

local MiniExtra = require('mini.extra')
MiniExtra.setup()

local MiniCompletion = require('mini.completion')
-- Customize post-processing of LSP responses for a better user experience.
-- Don't show 'Text' suggestions (usually noisy) and show snippets last.
local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
end
MiniCompletion.setup({
    lsp_completion = {
        -- Without this config autocompletion is set up through `:h 'completefunc'`.
        -- Although not needed, setting up through `:h 'omnifunc'` is cleaner
        -- (sets up only when needed) and makes it possible to use `<C-u>`.
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = process_items,
    },
})

-- Set 'omnifunc' for LSP completion only when needed.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
})

-- Advertise to servers that Neovim now supports certain set of completion and
-- signature features through 'mini.completion'.
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

local MiniSnippets = require('mini.snippets')
MiniSnippets.setup({
    snippets = {
        -- Load custom file with global snippets first
        MiniSnippets.gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories
        MiniSnippets.gen_loader.from_lang(),
    },
})
MiniSnippets.start_lsp_server()

local MiniKeymap = require('mini.keymap')
-- Cycle through popup menu items with <Tab>
-- Cycle through popup menu items backwards with <S-Tab>
-- On `<CR>` try to accept current completion item,
-- fall back to accounting for pairs from 'mini.pairs'
-- On `<BS>` just try to account for pairs from 'mini.pairs'
MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })

local NvimTreesitter = require('nvim-treesitter')
NvimTreesitter.install({
    'rust',
    'javascript',
    'typescript',
    'python',
    'bash',
    'vim',
    'vimdoc',
    'c',
    'diff',
    'html',
    'lua',
    'markdown',
})
NvimTreesitter.update()

vim.diagnostic.config({
    virtual_text = true
})

require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'ts_ls',
        'lua_ls',
        'eslint',
        'basedpyright',
        'ruff',
        'clangd'
    }
})
require('mason-nvim-dap').setup({
    ensure_installed = {
        'cppdbg', 'python'
    }
})
require('dapui').setup()

local dap = require('dap')
dap.adapters.lldb = {
    name = 'lldb',
    type = 'executable',
    command = 'lldb-dap'
}

local function dap_cpp_pick_program()
    root = root or vim.fn.getcwd()
    local filename = vim.fn.expand("%:t:r")

    -- find executable files, excluding .git and .venv
    local files = vim.fn.systemlist({
        "find",
        root,
        "-type", "f",
        "-perm", "+111",
        "-not", "-path", root .. "/.git/*",
        "-not", "-path", root .. "/.venv/*",
    })

    if vim.v.shell_error ~= 0 or #files == 0 then
        vim.notify("No executable files found", vim.log.levels.WARN)
        return
    end

    -- run git check-ignore -v on all files
    local executables = vim.fn.systemlist(
        { "git", "check-ignore", "--stdin" },
        table.concat(files, "\n")
    )

    if #executables == 0 then
        vim.notify("No non-gitignored executables found", vim.log.levels.WARN)
        return
    end

    -- sort: prefer executables containing current filename
    table.sort(executables, function(a, b)
        local a_match = filename ~= "" and a:find(filename, 1, true) ~= nil
        local b_match = filename ~= "" and b:find(filename, 1, true) ~= nil

        if a_match ~= b_match then
            return a_match
        end

        return a < b
    end)

    local coro = assert(coroutine.running())

    -- The vim.ui.select is an async call,
    -- we need to wait for the result until we resume
    vim.schedule(function()
        vim.ui.select(executables, {
            prompt = "Select executable:",
            format_item = function(item)
                return item:gsub("^" .. vim.pesc(root) .. "/", "")
            end,
        }, function(choice)
            if choice then
                print("Selected:", choice)
            end
            coroutine.resume(coro, choice)
        end)
    end)

    local result = coroutine.yield()
    return result
end

dap.configurations.cpp = {
    {
        name = "Launch (LLDB)",
        type = "lldb",
        request = "launch",
        program = dap_cpp_pick_program,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    }
}

-- Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local wk = require('which-key')

wk.setup({
    preset = 'helix',
    spec = {
        { '\\',        group = 'Utilities' },
        { '<leader>c', group = 'Code' },
        { '<leader>f', group = 'File/Find' },
        { '<leader>g', group = 'Go to' },
        { '<leader>s', group = 'Search' },
    }
})

vim.keymap.set({ 'n', 't' }, '<C-h>', '<CMD>wincmd h<CR>', { desc = 'Move to the left window' })
vim.keymap.set({ 'n', 't' }, '<C-j>', '<CMD>wincmd j<CR>', { desc = 'Move to the bottom window' })
vim.keymap.set({ 'n', 't' }, '<C-k>', '<CMD>wincmd k<CR>', { desc = 'Move to the top window' })
vim.keymap.set({ 'n', 't' }, '<C-l>', '<CMD>wincmd l<CR>', { desc = 'Move to the right window' })
vim.keymap.set('n', '<A-k>', ':resize -4<CR>', { desc = 'Make window smaller horizontally' })
vim.keymap.set('n', '<A-j>', ':resize +4<CR>', { desc = 'Make window larger horizontally' })
vim.keymap.set('n', '<A-h>', ':vertical resize -4<CR>', { desc = 'Make window smaller vertically' })
vim.keymap.set('n', '<A-l>', ':vertical resize +4<CR>', { desc = 'Make window larger vertically' })
vim.keymap.set('t', '\\d', '<C-\\><C-N>', { desc = 'Detach from terminal input mode' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-N>', { desc = 'Detach from terminal input mode' })
vim.keymap.set('i', '<C-x><C-x>', '<C-x><C-o>', { desc = 'Open omni-completion' })

-- Utilities group
vim.keymap.set('n', '\\[', ':e $MYVIMRC<CR>', { desc = 'Edit my Neovim config' })
vim.keymap.set('n', '\\]', MiniPick.builtin.help, { desc = 'Search help' })
vim.keymap.set('n', '\\h', ':noh<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '\\?', function() wk.show({ global = false }) end, { desc = 'Show buffer local keymaps (which-key)' })
vim.keymap.set('n', '\\x', ':confirm quit<CR>', { desc = 'Confirm quit' })

-- Global group
vim.keymap.set('n', '<leader>e', MiniFiles.open, { desc = 'Explorer MiniFiles (resume)' })
vim.keymap.set('n', '<leader>E', function() MiniFiles.open(nil, false) end, { desc = 'Explorer MiniFiles (cwd)' })
vim.keymap.set('n', '<leader>-', ':split<CR>', { desc = 'Split window below' })
vim.keymap.set('n', '<leader>|', ':vsplit<CR>', { desc = 'Split window right' })

-- Code group
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format code' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostic' })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol under cursor' })
vim.keymap.set('n', '<leader>ci', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls (citations)' })
vim.keymap.set('n', '<leader>co', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls (children)' })

-- Go to group
vim.keymap.set('n', '<leader>gr', [[:Pick lsp scope='references'<CR>]], { desc = 'Go to references' })
vim.keymap.set('n', '<leader>gi', [[:Pick lsp scope='implementation'<CR>]], { desc = 'Go to implementations' })
vim.keymap.set('n', '<leader>gd', [[:Pick lsp scope='definition'<CR>]], { desc = 'Go to definition' })
vim.keymap.set('n', '<leader>gD', [[:Pick lsp scope='declaration'<CR>]], { desc = 'Go to declaration' })
vim.keymap.set('n', '<leader>gt', [[:Pick lsp scope='type_definition'<CR>]], { desc = 'Go to type definition' })

-- File/Find group
vim.keymap.set('n', '<leader>fa', '<C-^>', { desc = 'Open alternative file' })
vim.keymap.set('n', '<leader>ff', MiniPick.builtin.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', MiniPick.builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fr', MiniPick.builtin.resume, { desc = 'Resume' })

-- Search
vim.keymap.set('n', '<leader>ss', [[:Pick lsp scope='document_symbol'<CR>]], { desc = 'Buffer symbols' })
vim.keymap.set('n', '<leader>sS', [[:Pick lsp scope='workspace_symbol_live'<CR>]], { desc = 'Workspace symbols' })
vim.keymap.set('n', '<leader>sd', [[:Pick diagnostic scope='current'<CR>]], { desc = 'Buffer diagnostics' })
vim.keymap.set('n', '<leader>sD', [[:Pick diagnostic scope='all'<CR>]], { desc = 'Workspace diagnostics' })
vim.keymap.set('n', '<leader>sG', MiniPick.builtin.grep_live, { desc = 'Grep live' })
