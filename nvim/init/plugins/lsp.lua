
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

  -- Diagnostics related commands
  vim.keymap.set('n', '<C-l>l', vim.diagnostic.setloclist, bufopts)
  vim.keymap.set('n', '<C-l>o', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

  local diagnostics_active = true
  vim.keymap.set('n', '<C-l>d', function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
      vim.diagnostic.show()
    else
      vim.diagnostic.hide()
    end
  end)

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
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

------------------- Scala LS settings -----------------
lspconfig.metals.setup {
  on_attach = on_attach,
  capabilities = lsp_capabilities
}

------------------- Typescript LS settings ------------
-- requires npm install -g typescript typescript-language-server
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = lsp_capabilities
}

------------------- Clang LS settings -----------------
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = lsp_capabilities
}

------------------- Julia LS settings -----------------
lspconfig.julials.setup {
  on_attach = on_attach,
  capabilities = lsp_capabilities
}

------------------- Latex LS settings -----------------
-- requires brew install --cask mactex & the Skim application
vim.g.texlabwd = string.format("/tmp/texlab-latex/%s", vim.g.wd) 
vim.g.texlab_latexindent_config = string.format("%s/latexindent.yaml", vim.g.pwd)

-- Create texlab working directory if it does not exist
os.execute(string.format("mkdir -p %s", vim.g.texlabwd))

lspconfig.texlab.setup {
  on_attach = on_attach,
  log_level = vim.lsp.protocol.MessageType.Log,
  cmd = { "texlab", "-vvvv", "--log-file=/tmp/texlab.log" },
  settings = {
    texlab = {
      auxDirectory = vim.g.texlabwd,
      build = {
        -- executable = "tectonic",
        -- args = {  "-X", "compile", "%f", "-p", "--synctex", "--keep-logs", "--keep-intermediates", "--outdir", vim.b.texlabwd },
        executable = "latexmk",
        args = { "-pdf", "-f", "-interaction=nonstopmode", "-synctex=1", string.format("-outdir=%s", vim.g.texlabwd), "%f" },
        onSave = true,
        forwardSearchAfter = true
      },
      chktex = {
        onOpenAndSave = true
      },
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "-g", "%l", "%p", "%f" }
      },
      latexFormatter = "latexindent",
      latexindent = {
        ['local'] = vim.g.texlab_latexindent_config,
        modifyLineBreaks = true
      }
    }
  },
  capabilities = lsp_capabilities
}
