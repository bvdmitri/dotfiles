vim.pack.add({
    { src = gh('nvim-mini/mini.jump2d') },
    { src = gh('fnune/recall.nvim') },
})

local keymap = require('keymap')

-- MiniJump2d
local MiniJump2d = require('mini.jump2d')

-- The default colorscheme is quite bad IMO
-- The new settings make the selesction standout and also undercurl
vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = 'White', standout = true })
vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', { fg = 'White', undercurl = true })
vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', { fg = 'White', undercurl = true })

MiniJump2d.setup({
    view = { dim = true, n_steps_ahead = 1 },
    mappings = { start_jumping = '' }
})

keymap.nmap('\\j', MiniJump2d.start, 'Jump anywhere on the screen')
keymap.nmap('<leader>gj', MiniJump2d.start, 'Goto anywhere on the screen')

-- Recal (better marks)

local recall = require('recall')

recall.setup({
    sign_highlight = 'Green'
})

-- Overwrite the recall navigation to use the opened buffer instead
require('recall.navigation').goto_mark = function(direction)
  local mark = require('recall.navigation').find_mark(direction)
  if mark then
    local bufnr = vim.fn.bufnr(mark.file)
    if bufnr ~= -1 then
      -- Buffer exists, check if it's already displayed in a window
      local win_id = vim.fn.bufwinid(bufnr)
      if win_id ~= -1 then
        -- Buffer is visible, switch focus to that window
        vim.api.nvim_set_current_win(win_id)
        vim.api.nvim_win_set_cursor(win_id, { mark.pos[2], mark.pos[3] })
      else
        -- Buffer exists but not visible, switch to it
        vim.cmd("silent buffer " .. bufnr)
        vim.api.nvim_win_set_cursor(0, { mark.pos[2], mark.pos[3] })
      end
    else
      -- Buffer not loaded, open it
      vim.cmd("silent buffer " .. mark.file)
      vim.api.nvim_win_set_cursor(0, { mark.pos[2], mark.pos[3] })
    end
  else
    print("No global marks set")
  end
end


keymap.nmap('mm', recall.toggle, 'Toggle a global mark')
keymap.nmap('mc', recall.clear, 'Clear all global marks')
keymap.nmap('m]', recall.goto_next, 'Go to next global mark')
keymap.nmap('<C-m>', recall.goto_next, 'Go to next global mark')
keymap.nmap('m[', recall.goto_prev, 'Go to prev global mark')
