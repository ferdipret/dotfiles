return {
	{
		"echasnovski/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "gza",
					delete = "gzd",
					find = "gzf",
					find_left = "gzF",
					highlight = "gzh",
					replace = "gzr",
					update_n_lines = "gzn",
				},
			})
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").create_default_mappings()
		end,
	},
}
