local luasnip = require("luasnip")

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("heex", {
	-- HEEx Expression
	s("expr", {
		t("<%= "), i(1, "expression"), t(" %>")
	}),

	-- HEEx Comment
	s("comment", {
		t("<%# "), i(1, "comment"), t(" %>")
	}),

	-- HEEx IF Statement
	s("if", {
		t({ "<%= if " }), i(1, "condition"), t({ " do %>", "  " }),
		i(2, "body"), t({ "", "<% end %>" })
	}),

	-- HEEx FOR Loop
	s("for", {
		t({ "<%= for " }), i(1, "item <- collection"), t({ " do %>", "  " }),
		i(2, "body"), t({ "", "<% end %>" })
	}),

	-- HEEx Assign Variable
	s("assign", {
		t("<% "), i(1, "variable = expression"), t(" %>")
	})
})
