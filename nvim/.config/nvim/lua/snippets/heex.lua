local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Most common/useful HEEx snippets converted to proper LuaSnip format
return {
	-- EEx basics
	s("ee", fmt("<%= {} %>", { i(1) })),
	s("eex", fmt("<% {} %>", { i(1) })),
	s("eec", fmt("<%!-- {} --%>", { i(1) })),

	-- Control flow
	s("eif", fmt([[
<%= if {} do %>
  {}
<% end %>]], { i(1), i(2) })),

	s("eife", fmt([[
<%= if {} do %>
  {}
<% else %>
  {}
<% end %>]], { i(1), i(2), i(3) })),

	s("efor", fmt([[
<%= for {} <- {} do %>
  {}
<% end %>]], { i(1), i(2), i(3) })),

	-- Phoenix components
	s("comp", fmt("<.{} {}={{{}}} />", { i(1), i(2), i(3) })),

	s("link", fmt('<.link navigate={{~p"/{}"}}>{}</.link>', { i(1), i(2) })),

	s("btn", fmt("<.button>{}</.button>", { i(1) })),

	s("btnc", fmt('<.button phx-click="{}">{}</.button>', { i(1), i(2) })),

	s("input", fmt('<.input field={{f[:{}]}} type="{}" label="{}" />', { i(1), i(2), i(3) })),

	s("form", fmt([[
<.form :let={{f}} for={{@changeset}} phx-submit="{}">
  {}
  <.button>{}</.button>
</.form>]], { i(1), i(2), i(3, "Save") })),

	-- LiveView
	s("pc", fmt('phx-click="{}"', { i(1) })),
	s("ps", fmt('phx-submit="{}"', { i(1) })),
	s("pch", fmt('phx-change="{}"', { i(1) })),

	-- Utilities
	s("at", fmt("@{}", { i(1) })),
	s("slot", fmt("<%= render_slot(@{}) %>", { i(1) })),
}
