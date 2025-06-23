local os = require 'common.os'

local function load_telescope_extension()
  if not os.is_windows then -- telescope extension is broken on windows
    return require('telescope').load_extension 'projects'
  end
  return nil
end

local function methods()
  if not os.is_windows then
    return { 'pattern' }
  else
    return { 'lsp' }
  end
end

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
        detection_methods = methods(),

        -- All the patterns used to detect root dir, when **"pattern"** is in
        -- detection_methods
        patterns = { '!=build', '!../git', 'compile_commands.json', 'build/compile_commands.json', '^.config/nvim' },

        load_telescope_extension(),
        vim.keymap.set('n', '<leader>ps', function()
          require('telescope').extensions.projects.projects {}
        end, { desc = '[P]roject [S]earch' }),
      }
    end,
  },
}
