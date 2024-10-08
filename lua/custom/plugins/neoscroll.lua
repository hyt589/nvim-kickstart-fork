return {
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup {
      performance_mode = false,
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb' },
    }
  end,
}
