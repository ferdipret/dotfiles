return {
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					shortcut = {
						{ desc = "Files", action = "Telescope find_files", key = "f" },
						{ desc = "Grep", action = "Telescope live_grep", key = "g" },
						{ desc = "Quit", action = "q", key = "q" },
					},
				},
			})
		end,
	}
