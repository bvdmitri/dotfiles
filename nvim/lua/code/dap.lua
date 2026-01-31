vim.pack.add({
    { src = gh('mfussenegger/nvim-dap') },
    { src = gh('rcarriga/nvim-dap-ui') },
    { src = gh('jay-babu/mason-nvim-dap.nvim') },
    { src = gh('theHamsta/nvim-dap-virtual-text') },
})

require('mason-nvim-dap').setup({
    ensure_installed = {
        'cppdbg',
        'python'
    }
})

require("nvim-dap-virtual-text").setup()

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
local search = require('search')

local dap_extra = {}

function dap_extra.step_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    dap.goto_(cursor[1])
end

function dap_extra.search_breakpoints()
    dap.list_breakpoints() -- Puts breakpoints the quick fix list
    search.list('quickfix')() -- Search.list returns a function
end

keymap.add_group('Debug', '<leader>d')
keymap.nmap('<leader>dd', dapui.toggle, 'Toggle debugging UI')
keymap.nmap('<leader>dr', dap.continue, 'Start / Continue debugging session')
keymap.nmap('<leader>dR', dap.run_last, 'Repeat last debugging session')
keymap.nmap('<leader>dx', dap.terminate, 'Terminate debugging session')
keymap.nmap('<leader>ds', dap.step_over, 'Step over')
keymap.nmap('<leader>di', dap.step_into, 'Step into')
keymap.nmap('<leader>do', dap.step_out, 'Step out')
keymap.nmap('<leader>dc', dap_extra.step_current_line, 'Step to current line')
keymap.nmap('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
keymap.nmap('<leader>dB', dap_extra.search_breakpoints, 'Search breakpoints')
