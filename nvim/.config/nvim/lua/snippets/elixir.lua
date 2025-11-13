local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node

-- Elixir sigils and common patterns
return {
	-- String sigils
	s("ss", fmt('~s({})', { i(1) })),
	s("sS", fmt('~S({})', { i(1) })),
	s("ssq", fmt("~s'{}'", { i(1) })),
	s("sSq", fmt("~S'{}'", { i(1) })),
	s("ssd", fmt('~s"{}"', { i(1) })),
	s("sSd", fmt('~S"{}"', { i(1) })),

	-- Regex sigils
	s("sr", fmt('~r({})', { i(1) })),
	s("sR", fmt('~R({})', { i(1) })),
	s("srq", fmt("~r'{}'", { i(1) })),
	s("sRq", fmt("~R'{}'", { i(1) })),
	s("srd", fmt('~r"{}"', { i(1) })),
	s("sRd", fmt('~R"{}"', { i(1) })),

	-- Regex with modifiers
	s("srm", fmt('~r({}){}', { i(1), i(2, "i") })),

	-- Word list sigils
	s("sw", fmt('~w({})', { i(1) })),
	s("sW", fmt('~W({})', { i(1) })),
	s("swa", fmt('~w({})a', { i(1) })), -- atoms
	s("swc", fmt('~w({})c', { i(1) })), -- charlists
	s("sws", fmt('~w({})s', { i(1) })), -- strings

	-- Charlist sigils
	s("sc", fmt('~c({})', { i(1) })),
	s("sC", fmt('~C({})', { i(1) })),
	s("scq", fmt("~c'{}'", { i(1) })),
	s("sCq", fmt("~C'{}'", { i(1) })),

	-- Date/Time sigils
	s("sD", fmt('~D[{}]', { i(1, "2024-01-01") })),
	s("sT", fmt('~T[{}]', { i(1, "12:00:00") })),
	s("sN", fmt('~N[{}]', { i(1, "2024-01-01 12:00:00") })),
	s("sU", fmt('~U[{}]', { i(1, "2024-01-01 12:00:00Z") })),

	-- Path sigil (Phoenix verified routes)
	s("sp", fmt('~p"{}"', { i(1, "/") })),
	s("spq", fmt("~p'{}'", { i(1, "/") })),

	-- HEEx sigils (for embedded templates in LiveView)
	s("sL", fmt([[
~L"""
{}
"""]], { i(1) })),

	s("sH", fmt([[
~H"""
{}
"""]], { i(1) })),

	-- Inline HEEx snippets for LiveView
	s("lh", fmt('~L"""{}"""', { i(1) })),
	s("hh", fmt('~H"""{}"""', { i(1) })),

	-- Common LiveView patterns with sigils
	s("lvcomp", fmt([[
<.{} {}={{{}}} />
]], { i(1, "component"), i(2, "prop"), i(3) })),

	s("lvif", fmt([[
<%= if {} do %>
  {}
<% end %>
]], { i(1), i(2) })),

	s("lvfor", fmt([[
<%= for {} <- {} do %>
  {}
<% end %>
]], { i(1), i(2), i(3) })),
}
