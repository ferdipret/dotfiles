return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			local mocha = require("catppuccin.palettes").get_palette("mocha")
			local catppuccin = require("catppuccin")

			vim.cmd(string.format("hi CatBase guibg=%s guifg=%s", mocha.base, mocha.text))
			vim.cmd(string.format("hi CatFloat guibg=%s guifg=%s", mocha.mantle, mocha.text))
			vim.cmd(string.format("hi CatFloatBorder guibg=%s guifg=%s", mocha.mantle, mocha.blue))

			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
