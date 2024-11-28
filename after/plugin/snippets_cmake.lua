local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require 'luasnip.util.events'
local ai = require 'luasnip.nodes.absolute_indexer'
local extras = require 'luasnip.extras'
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require 'luasnip.extras.expand_conditions'
local postfix = require('luasnip.extras.postfix').postfix
local types = require 'luasnip.util.types'
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key

local snippets = {
  s('msg', fmta('message(<> "<>")', { i(1, 'STATUS'), i(2, 'text') })),
  s(
    'msgv',
    fmta('message(<> "<>: ${<>}")', {
      i(1, 'STATUS'),
      f(function(args, parent, user_args)
        return args[1][1]
      end, { 2 }, {}),
      i(2, 'variable'),
    })
  ),
  s('tid', fmta([[target_include_directories(<> <> <>)]], { i(1, 'target_name'), c(2, { t 'PUBLIC', t 'PRIVATE', t 'INTERFACE' }), i(3, 'dirs') })),
  s('tll', fmta([[target_link_libraries(<> <> <>)]], { i(1, 'target_name'), c(2, { t 'PUBLIC', t 'PRIVATE', t 'INTERFACE' }), i(3, 'libs') })),
  s(
    'add',
    fmta([[add_<>(<> <>)]], {
      c(1, { t 'library', t 'executable', t 'subdirectory' }),
      i(2, 'name'),
      d(3, function(args)
        local target_type = args[1][1]
        if target_type == 'executable' then
          return sn(nil, t '')
        elseif target_type == 'library' then
          return sn(nil, c(1, { t 'SHARED', t 'STATIC', t 'INTERFACE' }))
        end
        return sn(nil, t '')
      end, { 1 }, {}),
    })
  ),
}

vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end)

ls.add_snippets('cmake', snippets)
