return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = false,
        styles = {
          comments = { 'italic' },
          functions = { 'bold' },
          keywords = { 'italic' },
          operators = { 'bold' },
          conditionals = { 'bold' },
          loops = { 'bold' },
          booleans = { 'bold', 'italic' },
          numbers = {},
          types = {},
          strings = {},
          variables = {},
          properties = {},
        },
        color_overrides = {
          mocha = {
            base = '#000000',
            -- mantle = '#000000',
            -- crust = '#000000',
          },
        },
        highlight_overrides = {
          all = function(colors)
            return {
              CursorLine = { bg = colors.none },
            }
          end,
        },
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
          },
          gitsigns = true,
          hop = true,
          telescope = true,
        },
      }
    end,
    init = function()
      vim.cmd.colorscheme 'catppuccin'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
