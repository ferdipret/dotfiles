return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				highlights = {
					Normal = {
						link = "ToggleTermNormal",
					},
					NormalFloat = {
						link = "ToggleTermNormalFloat",
					},
					FloatBorder = {
						link = "ToggleTermFloatBorder",
					},
				},
				float_opts = {
					border = "single",
				},
			})
		end,
	},
}
