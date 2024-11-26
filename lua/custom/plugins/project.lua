return {
  {
    'ahmedkhalf/project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('project_nvim').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        detection_methods = { 'pattern' },

        -- All the patterns used to detect root dir, when **"pattern"** is in
        -- detection_methods
        patterns = {'!../git', 'compile_commands.json', 'build/compile_commands.json', '^.config/nvim' },

        require('telescope').load_extension 'projects',
        vim.keymap.set('n', '<leader>ps', function()
          require('telescope').extensions.projects.projects {}
        end, { desc = '[P]roject [S]earch' }),
      }
    end,
  },
}
