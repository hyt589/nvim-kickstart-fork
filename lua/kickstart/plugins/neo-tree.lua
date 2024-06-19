-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local function toggle_neotree()
  vim.cmd 'Neotree dir=./ reveal'
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\f', toggle_neotree, { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        position = 'float',
        mappings = {
          ['\\f'] = 'close_window',
        },
      },
    },
  },
}
