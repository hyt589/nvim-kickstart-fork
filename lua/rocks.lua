local rocks = require 'common.luarocks'

if not rocks.luarocks_available() then
  rocks.install_luarocks()
end
