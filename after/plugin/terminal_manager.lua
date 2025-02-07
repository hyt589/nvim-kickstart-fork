local Terminal = require('toggleterm.terminal').Terminal
local default_term = Terminal:new { hidden = true, direction = 'float', display_name = 'Default Terminal' }

local terminal_list = {
  default = default_term,
}

local current_terminal = terminal_list.default

local function _toggle_current_terminal()
  current_terminal:toggle()
end

local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local function getKeysAsString(tbl)
  local keys = {}
  for key, _ in pairs(tbl) do
    table.insert(keys, key)
  end
  return keys
end

local _terminal_finder = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'Terminal Finder',
      finder = finders.new_table {
        results = getKeysAsString(terminal_list),
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          current_terminal = terminal_list[selection[1]]
          _toggle_current_terminal()
        end)
        return true
      end,
    })
    :find()
end

local _terminal_remover = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'Terminal Remover',
      finder = finders.new_table {
        results = getKeysAsString(terminal_list),
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection[1] ~= 'default' then
            if current_terminal == terminal_list[selection[1]] then
              current_terminal = terminal_list.default
            end
            terminal_list[selection[1]] = nil
          end
        end)
        return true
      end,
    })
    :find()
end

local _compute_name = function(table, basename, postfix_base)
  local name = string.format('%s (%s)', basename, postfix_base)
  local cnt = 0
  while table[name] ~= nil do
    name = string.format('%s (%s %d)', basename, postfix_base, cnt)
    cnt = cnt + 1
  end
  return name
end

local _create_terminal = function()
  vim.ui.input({ prompt = 'Command: ', default = '', completion = 'shellcmd' }, function(input)
    local command = input
    if command == nil or string.len(command) == 0 then
      return
    end
    if terminal_list[command] ~= nil then
      local terminal_name = _compute_name(terminal_list, command, 'duplicate')
      terminal_list[terminal_name] = Terminal:new { cmd = command, hidden = true, direction = 'float', display_name = terminal_name }
      current_terminal = terminal_list[terminal_name]
      _toggle_current_terminal()
      return
    end
    terminal_list[command] = Terminal:new { cmd = command, hidden = true, direction = 'float', display_name = command }
    current_terminal = terminal_list[command]
    _toggle_current_terminal()
  end)
end

--- @class command
--- @field args? string
--- @field fargs? string[]
--- @field nargs number

--- @param command command
local _create_terminal_with_commands = function(command)
  local command_str = command.args
  local key = command.fargs[1]
  terminal_list[key] = Terminal:new { cmd = command_str, hidden = true, direction = 'float', display_name = key, close_on_exit = false }
  current_terminal = terminal_list[key]
  _toggle_current_terminal()
end

vim.api.nvim_create_user_command('FindTerminals', _terminal_finder, {})
vim.api.nvim_create_user_command('RemoveTerminal', _terminal_remover, {})
vim.api.nvim_create_user_command('CreateTerminal', _create_terminal, {})
vim.api.nvim_create_user_command('CreateTerminalWithCommands', _create_terminal_with_commands, { nargs = '*' })

vim.keymap.set('n', '\\t', _toggle_current_terminal, { desc = 'Toggle terminal' })
vim.keymap.set('t', '\\t', _toggle_current_terminal, { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>ct', _create_terminal, { desc = 'Create a terminal' })
vim.keymap.set('n', '<leader>ft', _terminal_finder, { desc = 'Find a terminal' })
vim.keymap.set('n', '<leader>dt', _terminal_remover, { desc = 'Delete terminal' })

vim.api.nvim_create_autocmd({ 'DirChanged' }, {
  pattern = '*',
  callback = function()
    for name, term in pairs(terminal_list) do
      term.dir = vim.fn.getcwd()
      print('Terminal ' .. name .. ' change dir to ' .. vim.fn.getcwd())
    end
  end,
})
