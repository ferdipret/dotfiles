return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			local mocha = require("catppuccin.palettes").get_palette("mocha")
			local catppuccin = require("catppuccin")

			catppuccin.setup({
				custom_highlights = function(c)
					return {
						TelescopeNormal = {
							bg = c.mantle,
							fg = c.text,
						},
						TelescopeBorder = {
							bg = c.mantle,
							fg = c.mantle,
						},
						TelescopePromptBorder = {
							bg = c.surface0,
							fg = c.surface0,
						},
						TelescopePromptNormal = {
							bg = c.surface0,
							fg = c.text,
						},
						TelescopePromptTitle = {
							bg = c.surface0,
							fg = c.text,
						},
					}
				end,
			})

			vim.cmd(string.format("hi ToggleTermNormal guibg=%s", mocha.mantle))
			vim.cmd(string.format("hi ToggleTermNormalFloat guibg=%s", mocha.mantle))
			vim.cmd(string.format("hi ToggleTermFloatBorder guibg=%s guifg=%s", mocha.surface0, mocha.surface0))

			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
