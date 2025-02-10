-- Load Lazy.nvim
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
	-- File Explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		opts = {
			filesystem = { hijack_netrw_behavior = "disabled" },
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
		end,
	},

	-- Dashboard
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					header = {
						"███████╗██╗   ██╗ ██████╗  █████╗ ██████╗ ██╗",
						"██╔════╝██║   ██║██╔════╝ ██╔══██╗██╔══██╗██║",
						"█████╗  ██║   ██║██║  ███╗███████║██║  ██║██║",
						"██╔══╝  ██║   ██║██║   ██║██╔══██║██║  ██║██║",
						"██║     ╚██████╔╝╚██████╔╝██║  ██║██████╔╝███████╗",
						"╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝",
						"       🚀 Stay Focused, Keep Building!       ",
					},
					shortcut = {
						{ desc = "📁 Files", action = "Telescope find_files", key = "f" },
						{ desc = "🔍 Grep", action = "Telescope live_grep", key = "g" },
						{ desc = "🚪 Quit", action = "q", key = "q" },
					},
				},
			})
		end,
	},

	-- Fuzzy Finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})
		end,
	},

	-- Which-Key
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
})
