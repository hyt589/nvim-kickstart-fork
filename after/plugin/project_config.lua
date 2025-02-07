local check_on_starup = true

local choice_table = {}
local cached_config_path = vim.fn.stdpath 'cache' .. '/project_local_config_cache'

local function read_cached_choice()
  local file = io.open(cached_config_path, 'rb')
  if not file then
    return nil
  end
  local cached_config = vim.fn.json_decode(file:read '*a')
  file:close()
  return cached_config
end

local function cache_current_choice(data)
  local data_json = vim.fn.json_encode(data)
  local ok, result = pcall(vim.fn.writefile, { data_json }, cached_config_path)
  if not ok then
    error(vim.inspect(result), 0)
  end
end

local function remove_cached_choice()
  local confirm = vim.fn.confirm('Are you sure you want to delete per project config loading cache?', '&Yes\n&No', 2)
  if confirm == 1 then
    local ok, err = os.remove(cached_config_path)
    if ok then
      print 'Success'
    else
      error('Error: ' .. err)
    end
  end
end

local function prompt_local_config(ignore_cache)
  local project_config = vim.fn.getcwd() .. '/.nvim.lua'

  local should_prompt = ignore_cache
  if not ignore_cache then
    choice_table = read_cached_choice() or choice_table
    should_prompt = choice_table[project_config] == nil and choice_table[project_config] ~= false
  end

  if vim.fn.filereadable(project_config) == 1 and not should_prompt and choice_table[project_config] then
    dofile(project_config)
  end

  if vim.fn.filereadable(project_config) == 1 and should_prompt then
    local choices = { 'yes', 'no', 'show content' }
    local opts = { prompt = 'Local configurations detected, load them?' }
    require('common.utils').run_after_user_event('VeryLazy', function()
      vim.ui.select(choices, opts, function(choice)
        if choice == 'yes' then
          dofile(project_config)
          choice_table[project_config] = true
        elseif choice == 'show content' then
          vim.cmd('e ' .. project_config)
          choice_table[project_config] = false
        else
          choice_table[project_config] = false
        end
        cache_current_choice(choice_table)
      end)
    end)
  end
end

local autocmds = { 'DirChanged' }
if check_on_starup then
  autocmds[#autocmds + 1] = 'VimEnter'
end

vim.api.nvim_create_autocmd(autocmds, {
  pattern = '*',
  callback = function()
    prompt_local_config(false)
  end,
})

vim.api.nvim_create_user_command('CheckProjectConfig', function()
  local project_config = vim.fn.getcwd() .. '/.nvim.lua'
  if vim.fn.filereadable(project_config) == 0 then
    local choices = { 'ok' }
    local opts = { prompt = 'No project config files found' }
    require('common.utils').run_after_user_event('VeryLazy', function()
      vim.ui.select(choices, opts, function() end)
    end)
  else
    prompt_local_config(true)
  end
end, {
  desc = 'Check and prompt for loading project config',
})

vim.api.nvim_create_user_command('RemoveProjectConfigLoadingCache', function()
  remove_cached_choice()
end, {
  desc = 'Check and prompt for loading project config',
})
