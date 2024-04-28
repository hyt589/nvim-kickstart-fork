-- epilogue runs after plugins are loaded

-- TODO: Make this better:
--  1. probably allow multiple terminals to be created
--  2. switch between terminals via telescope pickers

local Terminal = require('toggleterm.terminal').Terminal
local float_term = Terminal:new { hidden = true, direction = 'float' }

local function _float_terminal_toggle()
  float_term:toggle()
end

vim.keymap.set('n', '\\t', _float_terminal_toggle, { desc = 'Toggle terminal' })
