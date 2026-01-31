vim.pack.add({
  { src = gh('nvim-neotest/neotest') },
  { src = gh('nvim-neotest/neotest-python') }
})

local Neotest = require('neotest')

Neotest.setup({
  adapters = {
    require('neotest-python')
  },
  icons = {
    expanded = "",
    child_prefix = "",
    child_indent = "",
    final_child_prefix = "",
    non_collapsible = "",
    collapsed = "",

    passed = "󰄴",
    running = "󰙧", -- 󱥸 
    running_animated = { "", "", "", "", "", "", },
    failed = "",
    unknown = "󰄰",
    watching = ""
  },
})

local keymap = require('keymap')

Neotest.run.run_file = function() Neotest.run.run(vim.fn.expand('%')) end
Neotest.run.debug = function() Neotest.run.run({ strategy = 'dap' }) end

Neotest.watch.toggle_file = function() Neotest.watch.toggle(vim.fn.expand('%')) end

Neotest.jump.next_failed = function() Neotest.jump.next({ status = 'failed' }) end
Neotest.jump.prev_failed = function() Neotest.jump.prev({ status = 'failed' }) end

keymap.add_group('Testing', '<leader>t')
keymap.nmap('<leader>tt', Neotest.run.run, 'Run the nearest test')
keymap.nmap('<leader>tx', Neotest.run.stop, 'Stop the testing process')
keymap.nmap('<leader>tm', Neotest.summary.run_marked, 'Run marked tests')
keymap.nmap('<leader>tf', Neotest.run.run_file, 'Run the current file')
keymap.nmap('<leader>td', Neotest.run.debug, 'Run the nearest test')
keymap.nmap('<leader>t.', Neotest.run.run_last, 'Re-run the last test')
keymap.nmap('<leader>tw', Neotest.watch.toggle, 'Watch the nearest test')
keymap.nmap('<leader>tW', Neotest.watch.toggle_file, 'Watch the current_file')
keymap.nmap('<leader>tJ', Neotest.jump.next_failed, 'Next failed test')
keymap.nmap('<leader>tK', Neotest.jump.prev_failed, 'Prev failed test')
keymap.nmap('<leader>ts', Neotest.summary.toggle, 'Toggle summary panel')
keymap.nmap('<leader>tr', Neotest.output.open, 'Show test result')
keymap.nmap('<leader>to', Neotest.output_panel.toggle, 'Toggle output panel')
keymap.nmap('<leader>tO', Neotest.output_panel.clear, 'Clear output panel')
