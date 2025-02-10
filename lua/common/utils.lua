local function file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'file'
end

local function dir_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

local function copy_file(source, destination)
  if not file_exists(source) then
    vim.notify('Source file does not exist: ' .. source, vim.log.levels.ERROR)
    return
  end

  -- Read the content of the source file
  local file = io.open(source, 'rb') -- Open in binary mode
  if not file then
    vim.notify('Failed to open source file: ' .. source, vim.log.levels.ERROR)
    return
  end

  local content = file:read '*all' -- Read the entire file
  file:close()

  -- Write the content to the destination file
  file = io.open(destination, 'wb') -- Open in binary mode
  if not file then
    vim.notify('Failed to open destination file for writing: ' .. destination, vim.log.levels.ERROR)
    return
  end

  file:write(content)
  file:close()

  -- vim.notify('File copied from ' .. source .. ' to ' .. destination, vim.log.levels.INFO)
end

local function create_dir_if_nonexistent(path, mode)
  mode = mode or 511
  if dir_exists(path) then
    return false
  end
  vim.uv.fs_mkdir(path, mode)
  return true
end

local function log_trace(msg)
  vim.notify(msg, vim.log.levels.TRACE)
end

local function log_info(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

local function log_error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function run_after_user_event(pattern, callback)
  vim.api.nvim_create_autocmd('User', {
    pattern = pattern,
    callback = callback,
    once = true,
  })
end

local function command_available(command)
  return vim.fn.executable(command) == 1
end

local M = {
  copy_file = copy_file,
  file_exists = file_exists,
  dir_exists = dir_exists,
  mkdir = create_dir_if_nonexistent,
  log_trace = log_trace,
  log_info = log_info,
  log_error = log_error,
  run_after_user_event = run_after_user_event,
  command_available = command_available,
}

return M
