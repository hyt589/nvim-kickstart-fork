local function redirect_message(pattern, view)
  return {
    filter = {
      event = 'msg_show',
      find = pattern,
    },
    view = view,
  }
end

return {
  -- lazy.nvim
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('notify').setup {
        background_colour = '#000000',
      }
      require('noice').setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = false, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true,        -- add a border to hover docs and signature help
        },
        messages = {
          enabled = true,
          view = 'mini',
          view_error = 'mini',
          view_warn = 'mini',
        },
        routes = {
          {
            filter = {
              event = 'msg_history_show',
            },
            view = 'popup',
          },
          {
            filter = {
              event = 'msg_show',
              min_height = 10,
            },
            view = 'popup',
          },
          redirect_message('✓', 'popup'),
          redirect_message('✗', 'popup'),
        },
        views = {
          notify = { scrollbar = false },
          split = { enter = true, scrollbar = false },
          vsplit = { scrollbar = false },
          popup = { scrollbar = false },
          mini = { scrollbar = false },
          cmdline = { scrollbar = false },
          cmdline_popup = { scrollbar = false },
          cmdline_output = { scrollbar = false },
          messages = { scrollbar = false },
          confirm = { scrollbar = false },
          hover = { scrollbar = false },
          popupmenu = { scrollbar = false },
        },
      }
    end,
  },
}
