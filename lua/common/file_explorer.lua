local function open()
  -- require('oil').open_float()
  require('ranger-nvim').open(true)
end

return {
  open_file_exporer = open,
}
