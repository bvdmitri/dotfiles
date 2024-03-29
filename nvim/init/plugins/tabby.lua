
vim.o.showtabline = 2

local opt = { noremap = true, silent = true }

vim.keymap.set('n', '<M-1>', '1gt', opt)
vim.keymap.set('n', '<M-2>', '2gt', opt)
vim.keymap.set('n', '<M-3>', '3gt', opt)
vim.keymap.set('n', '<M-4>', '4gt', opt)
vim.keymap.set('n', '<M-5>', '5gt', opt)
vim.keymap.set('n', '<M-6>', '6gt', opt)
vim.keymap.set('n', '<M-7>', '7gt', opt)
vim.keymap.set('n', '<M-8>', '8gt', opt)
vim.keymap.set('n', '<M-9>', '9gt', opt)

local tabby = require('tabby.tabline')

local function tab_name(tab) 
   return string.gsub(tab,"%[..%]","") 
end

local function tab_modified(tab)
    wins = require("tabby.module.api").get_tab_wins(tab)
    for i, x in pairs(wins) do
        if vim.bo[vim.api.nvim_win_get_buf(x)].modified then
            return ""
        end
    end
    return ""
end

local function lsp_diag(buf) 
    diagnostics = vim.diagnostic.get(buf)
    local count = {0, 0, 0, 0}
    
    for _, diagnostic in ipairs(diagnostics) do
        count[diagnostic.severity] = count[diagnostic.severity] + 1
    end
    if count[1] > 0 then
        return vim.bo[buf].modified and "" or ""
    elseif count[2] > 0 then 
        return vim.bo[buf].modified and "" or ""
    end
    return vim.bo[buf].modified and "" or ""
end 

local function get_modified(buf)
    if vim.bo[buf].modified then
        return ''
    else
        return ''
    end
end

local function buffer_name(buf)
    if string.find(buf,"NvimTree") then 
        return "NvimTree"
    end
    return buf
end

local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  inactive_tab = 'TabLine',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

tabby.set(function(line)
  return {
    {
      { '  ', hl = theme.head },
      line.sep('', theme.head, theme.fill),
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.inactive_tab
      return {
        line.sep('', hl, theme.fill),
        tab.number(),
        "",
        tab_name(tab.name()),
        "",
        tab_modified(tab.id),
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      local hl = win.is_current() and theme.current_tab or theme.inactive_tab
      return {
        line.sep('', hl, theme.fill),
        win.file_icon(),
        "",
        buffer_name(win.buf_name()),
        "",
        get_modified(win.buf().id),
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
    },
    hl = theme.fill,
  }
end)
