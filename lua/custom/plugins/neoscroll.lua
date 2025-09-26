return {
  'karb94/neoscroll.nvim',
  config = function()
    -- no need for neoscroll when using neovide
    if not vim.g.neovide then
      require('neoscroll').setup {
        performance_mode = false,
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', 'zt', 'zz', 'zb' },
      }
    end
  end,
}
