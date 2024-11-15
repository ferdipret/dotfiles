return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				ignore_install = {},
				auto_install = true,
				modules = {},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				aliases = {
					["heex"] = "html",
				},
			})
		end,
	},
	{
		"nvim-treesitter/playground",
	},
}
