local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s("mm", fmt("${}$", { i(1) })),
	s(
		"dm",
		fmt(
			[[
\\[
	{}
\\]
]],
			{ i(1) }
		)
	),
	s(
		"ali",
		fmt(
			[[
\\begin{{align*}}
	{}
\\end{{align*}}
]],
			{ i(1) }
		)
	),
	s(
		"beg",
		fmt(
			[[
\\begin{{{}}}
	{}
\\end{{{}}}
]],
			{ i(1, "equation"), i(2), i(1) }
		)
	),
	s(
		"thm",
		fmt(
			[[
\\begin{{theorem}}[{}]
	{}
\\end{{theorem}}
]],
			{ i(1, "Result"), i(2) }
		)
	),
}
