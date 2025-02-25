local utils = require 'common.utils'
local is_windows = require('common.os').is_windows
local slash = is_windows and '\\' or '/'

local presets = nil

local function read_cmake_preset_json()
  local json_path = vim.fn.getcwd() .. slash .. 'CMakePresets.json'
  local file = io.open(json_path, 'rb')
  if not file then
    return nil
  end
  local json = vim.fn.json_decode(file:read '*a')
  file:close()
  return json
end

vim.api.nvim_create_autocmd({ 'DirChanged', 'VimEnter' }, {
  pattern = '*',
  callback = function()
    presets = read_cmake_preset_json()
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = 'CMakePresets.json',
  callback = function()
    utils.log_info 'Presets changed. Reloading...'
    presets = read_cmake_preset_json()
  end,
})

local PresetType = {
  Configuration = 'configure',
  Build = 'build',
  Workflow = 'workflow',
}

local function select_configure_preset(fresh)
  local names = {}
  local named_presets = {}
  for _, preset in ipairs(presets.configurePresets) do
    table.insert(names, preset.name)
    named_presets[preset.name] = preset
  end
  vim.ui.select(names, { prompt = 'Select a configure preset' }, function(name)
    if named_presets[name]['binaryDir'] == nil then
      vim.cmd('CreateTerminalWithCommands cmake -B build --preset ' .. name .. fresh .. ' ; ' .. vim.o.shell)
    else
      vim.cmd('CreateTerminalWithCommands cmake --preset ' .. name .. fresh .. ' ; ' .. vim.o.shell)
    end
  end)
end

local function select_build_preset()
  local names = {}
  for _, preset in ipairs(presets.buildPresets) do
    table.insert(names, preset.name)
  end
  vim.ui.select(names, { prompt = 'Select a build preset' }, function(name)
    vim.cmd('CreateTerminalWithCommands cmake --build --preset ' .. name .. ' ; ' .. vim.o.shell)
  end)
end

local function select_workflow_preset(fresh)
  local names = {}
  for _, preset in ipairs(presets.workflowPresets) do
    table.insert(names, preset.name)
  end
  vim.ui.select(names, { prompt = 'Select a workflow preset' }, function(name)
    vim.cmd('CreateTerminalWithCommands cmake --workflow --preset ' .. name .. fresh .. ' ; ' .. vim.o.shell)
  end)
end

vim.api.nvim_create_user_command('CMakePreset', function()
  if presets == nil then
    utils.log_info 'No presets found'
    return
  end
  vim.ui.select({
    PresetType.Configuration,
    PresetType.Build,
    PresetType.Workflow,
  }, { prompt = 'Select a type of preset you would like to run' }, function(type)
    if type ~= PresetType.Build then
      vim.ui.select({ 'yes', 'no' }, { prompt = 'Would you like to start a fresh run (ignoring cache variables)?' }, function(choice)
        local fresh = (choice == 'yes') and ' --fresh ' or ''
        if type == PresetType.Configuration then
          select_configure_preset(fresh)
        elseif type == PresetType.Workflow then
          select_workflow_preset(fresh)
        end
      end)
    elseif type == PresetType.Build then
      select_build_preset()
    end
  end)
end, {})
