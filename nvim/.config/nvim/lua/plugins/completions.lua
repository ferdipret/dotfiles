local b = require("utils.borders").box_drawing_chars

local border = {
	b.top_left_corner,
	b.horizontal_top_line,
	b.top_right_corner,
	b.vertical_right_line,
	b.bottom_right_corner,
	b.horizontal_bottom_line,
	b.bottom_left_corner,
	b.vertical_left_line,
}

return {
	{ "hrsh7th/cmp-path" },
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/lua/snippets" } })
			require("luasnip").config.setup({
				update_events = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"onsails/lspkind.nvim",
			"windwp/nvim-autopairs",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						border = border,
						winhighlight = "Normal:CatFloat,FloatBorder:CatFloatBorder",
					},
					documentation = {
						border = border,
						winhighlight = "Normal:CatFloat,FloatBorder:CatFloatBorder",
					},
				},
				mapping = cmp.mapping.preset.insert({
					-- Open Completion Menu (VSCode: Ctrl+Space)
					["<C-Space>"] = cmp.mapping.complete(),

					-- Close Completion Menu (VSCode: Esc)
					["<C-e>"] = cmp.mapping.abort(),

					-- Accept Completion (VSCode: Enter)
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							elseif require("supermaven-nvim.completion_preview").has_suggestion() then
								require("supermaven-nvim.completion_preview").on_accept_suggestion()
							else
								fallback()
							end
						end,
					}),

					-- Navigate Completion List (VSCode: Tab / Shift+Tab)
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						elseif require("supermaven-nvim.completion_preview").has_suggestion() then
							require("supermaven-nvim.completion_preview").on_accept_suggestion()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Alternative Up/Down Navigation (VSCode: Ctrl+n / Ctrl+p)
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "supermaven" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					expandable_indicator = true,
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
			})
		end,
	},
}
