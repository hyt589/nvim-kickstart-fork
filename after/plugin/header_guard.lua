local header_guard_prefix = "BAIDU_KUNLUNXIN_XBLAS_"

local function get_relative_path()
  local filepath = vim.fn.expand '%:.'
  return filepath
end

local function should_add_header_guard()
  local ft = vim.bo.filetype
  return ft == 'c' or ft == 'cpp' or ft == 'cuda'
end

local function insert_header_guard()
  if not should_add_header_guard() then
    return
  end
  local relative_path = get_relative_path()
  local header_guard_macro = relative_path:upper():gsub('/', '_'):gsub('%.', '_')
  header_guard_macro = header_guard_prefix .. header_guard_macro
  local current_buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(current_buffer, 0, 0, false, {
    '#ifndef ' .. header_guard_macro,
    '#define ' .. header_guard_macro,
  })
  local line_count = vim.api.nvim_buf_line_count(current_buffer)
  vim.api.nvim_buf_set_lines(current_buffer, line_count, line_count, false, {
    "#endif"
  })
end

vim.api.nvim_create_user_command('InsertHeaderGuard', insert_header_guard, {})
