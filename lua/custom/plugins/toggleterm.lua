local os = require 'common.os'
local function get_shell()
  if os.os_type() == os.OS.Linux then
    return 'bash'
  end
  if os.os_type() == os.OS.Windows then
    return 'powershell'
  end
  return vim.o.shell
end

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        shell = get_shell,
      }
    end,
  },
}
