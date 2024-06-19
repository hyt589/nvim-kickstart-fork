return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      -- statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      require('mini.align').setup {
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          start = 'ga',
          start_with_preview = 'gA',
        },

        -- Modifiers changing alignment steps and/or options
        -- modifiers = {
        --   -- Main option modifiers
        --   ['s'] = --<function: enter split pattern>,
        --   ['j'] = --<function: choose justify side>,
        --   ['m'] = --<function: enter merge delimiter>,
        --
        --   -- Modifiers adding pre-steps
        --   ['f'] = --<function: filter parts by entering Lua expression>,
        --   ['i'] = --<function: ignore some split matches>,
        --   ['p'] = --<function: pair parts>,
        --   ['t'] = --<function: trim parts>,
        --
        --   -- Delete some last pre-step
        --   ['<BS>'] = --<function: delete some last pre-step>,
        --
        --   -- Special configurations for common splits
        --   ['='] = --<function: enhanced setup for '='>,
        --   [','] = --<function: enhanced setup for ','>,
        --   [' '] = --<function: enhanced setup for ' '>,
        -- },

        -- Default options controlling alignment process
        options = {
          split_pattern = '',
          justify_side = 'left',
          merge_delimiter = '',
        },

        -- Default steps performing alignment (if `nil`, default is used)
        steps = {
          pre_split = {},
          split = nil,
          pre_justify = {},
          justify = nil,
          pre_merge = {},
          merge = nil,
        },

        -- Whether to disable showing non-error feedback
        silent = false,
      }

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
