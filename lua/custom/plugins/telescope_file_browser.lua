local os = require 'common.os'

return {
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      local fb_actions = require 'telescope._extensions.file_browser.actions'
      local actions = require 'telescope.actions'

      require('telescope').setup {
        extensions = {
          file_browser = {
            mappings = {
              n = {
                q = actions.close,
                h = fb_actions.goto_parent_dir,
                j = actions.move_selection_better,
                k = actions.move_selection_worse,
                l = actions.select_default, -- action for going into directories and opening files
              },
            },
          },
        },
      }

      require('telescope').load_extension 'file_browser'
    end,
  },
}
