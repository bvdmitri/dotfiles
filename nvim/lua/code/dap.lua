vim.pack.add({
    { src = gh('mfussenegger/nvim-dap') },
    { src = gh('rcarriga/nvim-dap-ui') },
    { src = gh('jay-babu/mason-nvim-dap.nvim') },
})

require('mason-nvim-dap').setup({
    ensure_installed = {
        'cppdbg',
        'python'
    }
})

require('code.dap.cpp')
require('code.dap.python')

local dap = require('dap')
local dapui = require("dapui")

dapui.setup()

dap.listeners.before.attach.dapui_config = dapui.open
dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close

local keymap = require('keymap')

keymap.add_group('Debug', '<leader>d')
keymap.nmap('<leader>dd', dapui.toggle, 'Toggle debugging UI')
keymap.nmap('<leader>dr', dap.continue, 'Start / Continue debugging session')
keymap.nmap('<leader>ds', dap.terminate, 'Terminate debugging session')
keymap.nmap('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
keymap.nmap('<leader>dB', dap.list_breakpoints, 'List all breakpoints')
