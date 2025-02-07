return {
  {
    'kelly-lin/ranger.nvim',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('ranger-nvim').setup { replace_netrw = true }
      if not require('common.os').is_windows then
        vim.api.nvim_set_keymap('n', '\\f', '', {
          noremap = true,
          callback = function()
            require('ranger-nvim').open(true)
          end,
        })
      end
    end,
  },
}
