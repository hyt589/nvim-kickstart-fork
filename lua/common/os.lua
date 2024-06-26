local os_types = {
  Linux = 'linux',
  Mac = 'mac',
  Windows = 'windows',
}

local detect_os_type = function()
  if vim.fn.has 'linux' == 1 then
    return os_types.Linux
  end
  if vim.fn.has 'mac' == 1 then
    return os_types.Mac
  end
  if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
    return os_types.Windows
  end
end

return {
  OS = os_types,
  os_type = detect_os_type,
}
