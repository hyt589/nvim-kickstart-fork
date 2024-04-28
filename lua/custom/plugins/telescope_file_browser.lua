return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      -- require('telescope').setup({
      --   extensions = {
      --     file_browsers = {
      --       mappings = {
      --         f = false
      --       }
      --     }
      --   }
      -- })
      require('telescope').load_extension 'file_browser'
      vim.keymap.set('n', '\\f', function()
        require('telescope').extensions.file_browser.file_browser()
      end, { desc = 'Open file browser' })
    end,
  },
}
