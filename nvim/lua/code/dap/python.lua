vim.pack.add({
    { src = gh('mfussenegger/nvim-dap-python') }
})

-- Defines the adapter and the default configuration
-- that works nicely with pytest
require('dap-python').setup('debugpy-adapter')
