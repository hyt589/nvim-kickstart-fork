local check_on_starup = true

local sourced_config = {}

local function prompt_local_config()
  local project_config = vim.fn.getcwd() .. '/.nvim.lua'

  if vim.fn.filereadable(project_config) == 1 and sourced_config[project_config] == nil and sourced_config[project_config] ~= false then
    local choices = { 'yes', 'no', 'show content' }
    local opts = { prompt = 'Local configurations detected, load them?' }
    vim.ui.select(choices, opts, function(choice)
      if choice == 'yes' then
        dofile(project_config)
        sourced_config[project_config] = true
      elseif choice == 'show content' then
        vim.cmd('e ' .. project_config)
        sourced_config[project_config] = false
      else
        sourced_config[project_config] = false
      end
    end)
  end
end

local autocmds = { 'DirChanged' }
if check_on_starup then
  autocmds[#autocmds + 1] = 'VimEnter'
end

vim.api.nvim_create_autocmd(autocmds, {
  pattern = '*',
  callback = prompt_local_config,
})

vim.api.nvim_create_user_command('CheckProjectConfig', function()
  local project_config = vim.fn.getcwd() .. '/.nvim.lua'
  if vim.fn.filereadable(project_config) == 0 then
    local choices = { 'ok' }
    local opts = { prompt = 'No project config files found' }
    vim.ui.select(choices, opts, function() end)
  else
    prompt_local_config()
  end
end, {
  desc = 'Check and prompt for loading project config',
})
