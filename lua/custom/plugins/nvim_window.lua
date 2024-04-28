return {
  {
    'https://gitlab.com/yorickpeterse/nvim-window.git',
    config = function()
      vim.api.nvim_set_keymap('n', '\\w', "<cmd>lua require('nvim-window').pick()<cr>", { noremap = true })
    end,
  },
}
