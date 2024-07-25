local function remove_all_swap_files()
  -- Get the directory where Neovim stores swap files
  local swap_dir = vim.fn.stdpath 'data' .. '/swap/'

  -- Get a list of all files in the swap directory
  local swap_files = vim.fn.globpath(swap_dir, '*', false, 1)

  -- Loop through the swap files and delete them
  for _, file in ipairs(swap_files) do
    os.remove(file)
  end

  -- Print a message to indicate that the swap files have been removed
  print 'All Neovim swap files have been removed.'
end

local function clear_swap_files()
  vim.ui.select({ 'yes', 'no' }, {
    prompt = 'Are you sure to erase all swap files?',
  }, function(choice)
    if choice == 'yes' then
      remove_all_swap_files()
    end
  end)
end

vim.api.nvim_create_user_command('ClearSwapFiles', clear_swap_files, {})
