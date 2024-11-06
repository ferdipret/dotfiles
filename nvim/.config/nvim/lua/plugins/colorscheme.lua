return {
	-- "folke/tokyonight.nvim",
	-- lazy = false,
	-- priority = 1000,
	-- config = function()
	-- 	require("tokyonight").setup()
	--
	-- 	vim.cmd([[colorscheme tokyonight-night]])
	-- end,
	--

	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nordic").setup({})
		local c = require("nordic.colors")

		vim.cmd([[colorscheme nordic]])

		vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = c.black0 })
		vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = c.black0 })
	end,
}
