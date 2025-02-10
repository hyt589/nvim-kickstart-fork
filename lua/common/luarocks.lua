local sys = require 'common.system_package_manager'
local utils = require 'common.utils'

package.path = package.path .. ';' .. vim.fn.expand '~/.luarocks/share/lua/5.1/?/init.lua'
package.path = package.path .. ';' .. vim.fn.expand '~/.luarocks/share/lua/5.1/?.lua'
package.cpath = package.cpath .. ';' .. vim.fn.expand '~/.luarocks/lib/lua/5.1/?.so'

local function luarocks_available()
  return utils.command_available 'luarocks'
end

local function install_luarocks()
  if luarocks_available() then
    return
  end
  local candidates = vim.deepcopy(sys.AvailablePackageManagers)
  while #candidates > 0 and not utils.command_available(candidates[1]) do
    table.remove(candidates, 1)
  end
  if #candidates <= 0 then
    utils.log_error 'Cannot find a suitable package manager to install luarocks'
    utils.log_error('suitable package managers: ' .. table.concat(sys.AvailablePackageManagers, ', '))
    return
  end
  local package_manger = candidates[1]
  utils.log_info('Trying to install luarocks with ' .. package_manger)
  local ok, sys_obj = pcall(vim.system, { package_manger, sys.InstallCommands[package_manger], 'luarocks' })
  if not ok then
    utils.log_error('Error while trying to install luarocks with ' .. package_manger)
    return
  end
  sys_obj:wait()
  assert(luarocks_available(), 'luarocks not available even after installing')
  utils.log_info('luarocks is installed via ' .. package_manger)
end

local function install_rock(rock_name)
  assert(luarocks_available(), 'luarocks not available')
  utils.log_info('installing ' .. rock_name .. ' with luarocks')
  vim.system({ 'luarocks', '--lua-version', '5.1', '--local', 'install', rock_name }):wait()
  utils.log_info('installed ' .. rock_name .. ' with luarocks')
end

return {
  luarocks_available = luarocks_available,
  install_luarocks = install_luarocks,
  install = install_rock,
}
