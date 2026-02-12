
-- Just a note for myself
-- LanguageServer.jl, SymbolServer.jl and StaticLint.jl can be installed with `julia` and `Pkg` >sh
--   julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer"); Pkg.add("StaticLint")'
-- where `~/.julia/environments/nvim-lspconfig` is the location where
-- the default configuration expects LanguageServer.jl, SymbolServer.jl and StaticLint.jl to be installed.
--
-- To update an existing install, use the following command >sh
--   julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
--
vim.lsp.enable("julials")
