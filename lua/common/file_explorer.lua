local os = require 'common.os'

local function open()
  if not os.is_windows then
    require('ranger-nvim').open(true)
  else
    require('telescope').extensions.file_browser.file_browser {
      path = '%:p:h',
      select_buffer = true,
      initial_mode = 'normal',
    }
  end
end

return {
  open_file_exporer = open,
}
