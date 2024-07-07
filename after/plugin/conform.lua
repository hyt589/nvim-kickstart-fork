vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b[vim.fn.bufnr()].disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b[vim.fn.bufnr()].disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

local function _format_buffer()
  require('conform').format { async = true, lsp_fallback = true }
end

vim.keymap.set('', '<c-f>', _format_buffer, { desc = '[F]ormat buffer' })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'xmake.lua',
  callback = function()
    print 'Disabling auto format for this xmake file'
    vim.b[vim.fn.bufnr()].disable_autoformat = true
  end,
})
