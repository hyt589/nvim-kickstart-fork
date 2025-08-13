local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- local cmd = vim.api.nvim_create_user_command
-- local namespace = vim.api.nvim_create_namespace

local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
    desc = "Save view with mkview for real files",
    group = view_group,
    callback = function(args)
      if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
    end,
})
autocmd("BufWinEnter", {
    desc = "Try to load file view if available and enable view saving for real files",
    group = view_group,
    callback = function(args)
      if not vim.b[args.buf].view_activated then
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
        local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
        if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
            vim.b[args.buf].view_activated = true
          vim.cmd.loadview { mods = { emsg_silent = true } }
        end
      end
  end,
})
