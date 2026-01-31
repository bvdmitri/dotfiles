vim.pack.add({
    { src = gh('mfussenegger/nvim-dap-python') }
})

-- Defines the adapter and the default configuration
-- that works nicely with pytest
local DapPython = require('dap-python')
DapPython.setup('uv')
