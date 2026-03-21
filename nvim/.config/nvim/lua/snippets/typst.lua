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
$
	{}
$
]],
			{ i(1) }
		)
	),
	s("frac", fmt("#frac({}, {})", { i(1), i(2) })),
	s("sum", fmt("sum_{{{}={}}}^{{{}}} {}", { i(1, "i"), i(2, "1"), i(3, "n"), i(4) })),
	s(
		"mat",
		fmt(
			[[
#math.mat(
	{},
)
]],
			{ i(1, "1, 0; 0, 1") }
		)
	),
}
