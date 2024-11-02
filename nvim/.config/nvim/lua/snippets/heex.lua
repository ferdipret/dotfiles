local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local shared_snippets = {
	s("%=", { t("<%= "), i(1, "code"), t(" %>") }),
	s("%==", { t("<% "), i(1, "expr"), t(" %>") }, { priority = 1001 }),
}

return shared_snippets, {}
