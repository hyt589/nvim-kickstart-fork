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
  s('castshared', {
    t '_shared_ptr_ ',
    i(1, 'type'),
    t '*',
    i(2, 'name'),
    t ' = (_shared_ptr_ ',
    f(function(args, parent, user_args)
      return args[1][1]
    end, { 1 }, {}),
    t '*) ',
    i(3, 'addr'),
    t ';',
  }),
  s(
    'if',
    fmta(
      [[
  if (<>) {
    <>
  }
  ]],
      { i(1, 'condition'), i(2) }
    )
  ),
  s(
    'foreach',
    fmta(
      [[
      for(<> : <>) {
        <>
      }
      ]],
      { i(1, 'item'), i(2, 'container'), i(3) }
    )
  ),
  s(
    'coutv',
    fmt(
      [[
  std::cout << "{}: " << {} << std::endl;
  ]],
      { f(function(args, parent, user_args)
        return args[1][1]
      end, { 1 }, {}), i(1, 'value') }
    )
  ),
  s(
    'coutl',
    fmt(
      [[
  std::cout << "{}" << std::endl;
  ]],
      { i(1, 'line') }
    )
  ),
  s('coutdb', fmt('std::cout << __FILE__ << ":" << __LINE__ << std::endl;', {})),
  s(
    'ifcons',
    fmta(
      [[
  if constexpr(<>){
    <>
  }
  ]],
      { i(1, 'condition'), i(2, 'stmts;') }
    )
  ),
  s(
    'ifconsl',
    fmta(
      [[
  if constexpr(<>){ <> }
  ]],
      { i(1, 'condition'), i(2, 'stmts;') }
    )
  ),
  s(
    'pv',
    fmta([[printf("<>: %<>\n", <>)]], { f(function(args, _, _)
      return args[1][1]
    end, { 1 }, {}), i(2, 'd'), i(1, 'value') })
  ),
}

ls.add_snippets('cpp', snippets)
