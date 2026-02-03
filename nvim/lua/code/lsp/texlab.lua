vim.lsp.config('texlab', {
   settings = {
      texlab = {
         build = {
            executable = "tectonic",
            args = {
               "-X",
               "compile",
               "%f",
               "--synctex",
               "--keep-logs",
               "--keep-intermediates",
            }
         }
      }
   }
})

local keymap = require('keymap')

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
   pattern = { "main.tex" },
   callback = function()
      keymap.nmap('<leader>cb', '<CMD>LspTexlabBuild<CR>', 'Build Latex project')
   end
})
