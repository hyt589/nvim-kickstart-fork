-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  require 'kickstart.plugins.gitsigns',

  require 'kickstart.plugins.which-key',

  require 'kickstart.plugins.telescope',

  require 'kickstart.plugins.lspconfig',

  require 'kickstart.plugins.conform',

  require 'kickstart.plugins.cmp',

  require 'kickstart.plugins.tokyonight',

  require 'kickstart.plugins.todo-comments',

  require 'kickstart.plugins.mini',

  require 'kickstart.plugins.treesitter',

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },

  { 'MunifTanjim/nui.nvim' },
  require 'custom.plugins.nvim_window',
  require 'custom.plugins.dashboard',
  require 'custom.plugins.bufferline',
  require 'custom.plugins.hop',
  require 'custom.plugins.neoscroll',
  require 'custom.plugins.project',
  require 'custom.plugins.auto_session',
  require 'custom.plugins.telescope_file_browser',
  require 'custom.plugins.toggleterm',
  require 'custom.plugins.dressing',
  require 'custom.plugins.barbecue',
  require 'custom.plugins.ibl',
  require 'custom.plugins.mini_indent_line',
  require 'custom.plugins.lualine',
  require 'custom.plugins.noice',
  require 'custom.plugins.marks',
  require 'custom.plugins.floating_help',
  require 'custom.plugins.catppuccin',
  require 'custom.plugins.oil',
  require 'custom.plugins.ranger',
  require 'custom.plugins.outline',
  -- require 'custom.plugins.llm.llm', -- this is bugged TODO: replace with minuet
  require 'custom.plugins.trouble',
  require 'custom.plugins.maximize',
  require 'custom.plugins.github_colorscheme',
  require 'custom.plugins.helpview',
  -- require 'custom.plugins.avante',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
