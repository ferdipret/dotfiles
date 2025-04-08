return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd [[colorscheme tokyonight-night]]
		local function set_navic_highlights()
			local colors = require("tokyonight.colors").setup({ style = "night" })

			vim.api.nvim_set_hl(0, "NavicIconsFile", { bg = colors.bg, fg = colors.blue })
			vim.api.nvim_set_hl(0, "NavicIconsModule", { bg = colors.bg, fg = colors.cyan })
			vim.api.nvim_set_hl(0, "NavicIconsNamespace", { bg = colors.bg, fg = colors.yellow })
			vim.api.nvim_set_hl(0, "NavicIconsPackage", { bg = colors.bg, fg = colors.green })
			vim.api.nvim_set_hl(0, "NavicIconsClass", { bg = colors.bg, fg = colors.red })
			vim.api.nvim_set_hl(0, "NavicIconsMethod", { bg = colors.bg, fg = colors.blue })
			vim.api.nvim_set_hl(0, "NavicIconsProperty", { bg = colors.bg, fg = colors.blue })
			vim.api.nvim_set_hl(0, "NavicIconsField", { bg = colors.bg, fg = colors.magenta })
			vim.api.nvim_set_hl(0, "NavicIconsConstructor", { bg = colors.bg, fg = colors.red })
			vim.api.nvim_set_hl(0, "NavicIconsEnum", { bg = colors.bg, fg = colors.orange })
			vim.api.nvim_set_hl(0, "NavicIconsInterface", { bg = colors.bg, fg = colors.orange })
			vim.api.nvim_set_hl(0, "NavicIconsFunction", { bg = colors.bg, fg = colors.blue })
			vim.api.nvim_set_hl(0, "NavicIconsVariable", { bg = colors.bg, fg = colors.fg })
			vim.api.nvim_set_hl(0, "NavicIconsConstant", { bg = colors.bg, fg = colors.fg })
			vim.api.nvim_set_hl(0, "NavicIconsString", { bg = colors.bg, fg = colors.green })
			vim.api.nvim_set_hl(0, "NavicIconsNumber", { bg = colors.bg, fg = colors.orange })
			vim.api.nvim_set_hl(0, "NavicIconsBoolean", { bg = colors.bg, fg = colors.orange })
			vim.api.nvim_set_hl(0, "NavicIconsArray", { bg = colors.bg, fg = colors.cyan })
			vim.api.nvim_set_hl(0, "NavicIconsObject", { bg = colors.bg, fg = colors.cyan })
			vim.api.nvim_set_hl(0, "NavicIconsKey", { bg = colors.bg, fg = colors.cyan })
			vim.api.nvim_set_hl(0, "NavicIconsNull", { bg = colors.bg, fg = colors.fg })
			vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { bg = colors.bg, fg = colors.cyan })
			vim.api.nvim_set_hl(0, "NavicIconsStruct", { bg = colors.bg, fg = colors.blue })
			vim.api.nvim_set_hl(0, "NavicIconsEvent", { bg = colors.bg, fg = colors.magenta })
			vim.api.nvim_set_hl(0, "NavicIconsOperator", { bg = colors.bg, fg = colors.fg })
			vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { bg = colors.bg, fg = colors.fg })

			vim.api.nvim_set_hl(0, "NavicText", { bg = colors.bg, fg = colors.comment })
			vim.api.nvim_set_hl(0, "NavicSeparator", { bg = colors.bg, fg = colors.comment })

			vim.api.nvim_set_hl(0, "WinbarModified", { bg = colors.bg, fg = colors.red })
			vim.api.nvim_set_hl(0, "WinbarSaved", { bg = colors.bg, fg = colors.green })
		end

		set_navic_highlights()

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "tokyonight*",
			callback = function()
				set_navic_highlights()
			end,
		})
	end
}
