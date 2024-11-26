local function remove_all_swap_files()
  -- Get the directory where Neovim stores swap files
  -- local swap_dir = vim.fn.stdpath 'data' .. '/swap/'
  local swap_dir = vim.o.directory

  -- Get a list of all files in the swap directory
  local swap_files = vim.fn.globpath(swap_dir, '*', false, 1)

  -- Loop through the swap files and delete them
  for _, file in ipairs(swap_files) do
    print('removing ' .. file)
    os.remove(file)
  end

  -- Print a message to indicate that the swap files have been removed
  print 'All Neovim swap files have been removed.'
end

local function remove_lsp_log()
  local lsp_log_file = vim.fn.stdpath 'state' .. '/lsp.log'
  print('removing ' .. lsp_log_file)
  os.remove(lsp_log_file)
  print('removed ' .. lsp_log_file)
end

local function confirm_prompt(text, confirm_callback, cancel_callback)
  confirm_callback = confirm_callback or function()
    print 'confirmed'
  end
  cancel_callback = cancel_callback or function()
    print 'cancelled'
  end
  vim.ui.select({ 'yes', 'no' }, { prompt = text }, function(choice)
    if choice == 'yes' then
      assert(type(confirm_callback) == 'function', 'confirm_callback is not a function')
      confirm_callback()
    elseif choice == 'no' then
      assert(type(cancel_callback) == 'function', 'cancel_callback is not a function')
      cancel_callback()
    end
  end)
end

local function clear_swap_files()
  confirm_prompt('Are you sure to erase all swap files?', remove_all_swap_files)
end

local function clear_lsp_log()
  confirm_prompt('Are you sure to clear lsp log?', remove_lsp_log)
end

vim.api.nvim_create_user_command('ClearSwapFiles', clear_swap_files, {})
vim.api.nvim_create_user_command('ClearLspLog', clear_lsp_log, {})
