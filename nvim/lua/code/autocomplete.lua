vim.pack.add({
    {
        src = gh('saghen/blink.cmp'),
        version = vim.version.range('1.0.0 - 2.0.0')
    },
    { src = gh('rafamadriz/friendly-snippets') },
})

local BlinkCmp = require('blink.cmp')

BlinkCmp.setup({
    keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' }
    },
    fuzzy = { implementation = 'rust' },
    signature = { enabled = true }
})

local keymap = require('keymap')

local function toggle_documentation()
    if BlinkCmp.is_documentation_visible() then
        BlinkCmp.hide_documentation()
    else
        BlinkCmp.show_documentation()
    end
end

keymap.imap('<C-x><C-h>', toggle_documentation, 'Toggle autocomplete docs')
keymap.imap('<C-x><C-a>', BlinkCmp.show_signature, 'Toggle autocomplete signature')

vim.lsp.config('*', { capabilities = BlinkCmp.get_lsp_capabilities() })
