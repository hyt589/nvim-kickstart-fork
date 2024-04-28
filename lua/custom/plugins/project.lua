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
        require('telescope').load_extension 'projects',
        vim.keymap.set('n', '<leader>ps', function()
          require('telescope').extensions.projects.projects {}
        end, { desc = '[P]roject [S]earch' }),
      }
    end,
  },
}
