-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', 'Q', '<cmd>qa<cr>', { desc = 'Close all windows' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = '[W]indow [V]ertical split' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>', { desc = '[W]indow [H]orizontal split' })
vim.keymap.set('n', '<leader>wq', '<cmd>q<cr>', { desc = '[W]indow [Q]uit' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- buffers
vim.keymap.set('n', '<leader>bs', '<c-^>', { desc = '[B]uffer [S]wap' })
vim.keymap.set('n', '<leader>bc', '<cmd>BufferLineCloseOthers<cr>', { desc = '[B]uffer [C]lose others' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<c-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<c-l>', '<cmd>BufferLineCycleNext<cr>', { desc = '[B]uffer [P]rev' })
vim.keymap.set('n', '\\b', '<cmd>BufferLinePick<cr>', { desc = 'Pick buffers' })

-- save buffers
vim.keymap.set('n', '<C-s>', '<cmd>wa<cr>', {})
vim.keymap.set('n', '<C-S>', '<cmd>wa!<cr>', {})

vim.keymap.set('n', '<leader>d', '"_d', { desc = 'delete without yanking' })
vim.keymap.set('x', '<leader>d', '"_d', { desc = 'delete without yanking' })

-- replace currently selected text with default register
-- without yanking it
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'paste without yanking' })

vim.keymap.set('n', '<leader><leader>', '<cmd>HopWordMW<cr>', { desc = 'Hop word' })
vim.keymap.set('x', '<leader><leader>', '<cmd>HopWord<cr>', { desc = 'Hop word' })

vim.keymap.set('n', 'j', 'gj', { desc = 'Move thru wrapped line', silent = true })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move thru wrapped line', silent = true })

vim.keymap.set('x', 'j', 'gj', { desc = 'Move thru wrapped line', silent = true })
vim.keymap.set('x', 'k', 'gk', { desc = 'Move thru wrapped line', silent = true })

vim.keymap.set('n', '<c-_>', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle line comment' })
vim.keymap.set('x', '<c-_>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle line comment' })
vim.keymap.set('n', '<c-/>', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle line comment' })
vim.keymap.set('x', '<c-/>', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle line comment' })

vim.keymap.set('n', '<leader>f,', '<cmd>TodoTelescope<cr>', { desc = '[F]ind todo comments in project' })

vim.keymap.set('n', '\\f', function()
  require('common.file_explorer').open_file_exporer()
end, { desc = 'Open file explorer' })

vim.keymap.set('n', '\\o', function()
  require('oil').open_float()
end, { desc = 'Open file explorer' })

vim.keymap.set('n', '<leader>ge', function()
  vim.diagnostic.goto_next()
end, { desc = 'Jump to next diagnostic' })

vim.keymap.set('n', '<leader>Gn', function()
  vim.diagnostic.goto_prev()
end, { desc = 'Jump to previous diagnostic' })

vim.keymap.set('n', '<leader>wm', function()
  vim.cmd 'Maximize'
end, { desc = '[W]indow [M]aximize' })

if vim.g.neovide then
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-\\><C-n>"+Pi', { noremap = true, silent = false})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
-- vim: ts=2 sts=2 sw=2 et
