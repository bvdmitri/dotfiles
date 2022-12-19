
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<Leader>df', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- The `on_attach` function is used to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Do not use completion triggered by <c-x><c-o> with LSP
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Language related commands start with Control-l
  vim.keymap.set('n', '<C-l>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<C-l>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<C-l>f', vim.lsp.buf.format, bufopts)

  -- Override neovim built-in mappings for help
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  -- "Go to" related commands start with letter "g"
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gs', vim.lsp.buf.type_definition, bufopts)

  -- Autocompletion mapping
  local luasnip = require('luasnip')
  local cmp = require('cmp')
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-s>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }

end

local lspconfig = require('lspconfig')

------------------- Julia LS settings -----------------
lspconfig.julials.setup {
  on_attach = on_attach,
  capabilities = autocomplete
}

------------------- Latex LS settings -----------------
vim.b.texlabwd = string.format("/tmp/tectonic-latex/%s", vim.b.wd) 

-- Create texlab working directory if it does not exist
os.execute(string.format("mkdir -p %s", vim.b.texlabwd))

lspconfig.texlab.setup {
  on_attach = on_attach,
  settings = {
    texlab = {
      auxDirectory = vim.b.texlabwd,
      build = {
        executable = "tectonic",
        args = {  "-X", "compile", "%f", "-p", "--synctex", "--keep-logs", "--keep-intermediates", "--outdir", vim.b.texlabwd },
        onSave = true,
      },
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "%l", "%p", "%f" }
      },
      latexindent = {
        modifyLineBreaks = true
      }
    }
  },
  capabilities = autocomplete
}
