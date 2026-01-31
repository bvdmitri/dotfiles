vim.pack.add({
    { src = gh('mfussenegger/nvim-dap-python') }
})

-- Defines the adapter and the default configuration
-- that works nicely with pytest
local DapPython = require('dap-python')
DapPython.setup('uv')

local keymap = require('keymap')

vim.api.nvim_create_autocmd('FileType', {
    pattern = { "python" },
    callback = function(_)
        keymap.nmap('<leader>dt', DapPython.test_method, 'Test python method')
    end
})
