return {
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("colorful-menu").setup({ ls = { fallback = true }, max_width = 60 })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"xzbdmw/colorful-menu.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local suggestion = require("supermaven-nvim.completion_preview")
			local colors = require("tokyonight.colors").setup({ style = "night" })

			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

			vim.api.nvim_set_hl(0, "PmenuBorder", { fg = colors.border_highlight, bg = colors.bg_popup })

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
				winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,Search:None",
			})

			lspkind.init({
				symbol_map = {
					Supermaven = "",
				},
			})

			cmp.setup({
				window = {
					documentation = {
						border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
						winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,Search:None",
					},
					completion = {
						border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
						winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,Search:None",
					}
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif suggestion.has_suggestion() then
							suggestion.on_accept_suggestion()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),


					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })

						kind.kind = " " .. (strings[1] or "") .. " "

						local menu_text = strings[2] or ""
						local menu_width = 20
						kind.menu = string.format("%" .. menu_width .. "s", menu_text)

						return kind
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "supermaven" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = 'render-markdown' },
					{ name = 'calc' },
				}),
			})
		end,
	}
}
