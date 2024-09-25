return {
  {
    'kelly-lin/ranger.nvim',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('ranger-nvim').setup { replace_netrw = true }
      vim.api.nvim_set_keymap('n', '\\f', '', {
        noremap = true,
        callback = function()
          require('ranger-nvim').open(true)
        end,
      })
    end,
  },
}
