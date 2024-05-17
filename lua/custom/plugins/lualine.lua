return {
  {
    'nvim-lualine/lualine.nvim',
    after = 'catppuccin',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        theme = 'catppuccin',
      }
    end,
  },
}
