return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		keys = {
			{ "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Ask AI" },
			{ "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Chat With Codebase" },
			{ "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Toggle AI Panel" },
			{ "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Focus AI Panel" },
			{ "<leader>ah", "<cmd>AvanteHistory<cr>", desc = "Chat History" },
			{ "<leader>am", "<cmd>AvanteModels<cr>", desc = "Select Model" },
			{ "<leader>aR", "<cmd>AvanteShowRepoMap<cr>", desc = "Show Repo Map" },
			{ "<leader>as", "<cmd>AvanteStop<cr>", desc = "Stop AI Request" },
		},
		opts = {
			-- add any opts here
			-- for example
			provider = "openai",
			openai = {
				endpoint = "https://api.openai.com/v1",
				model = "o3-mini", -- your desired model (or use gpt-4o, etc.)
				timeout = 90000, -- Timeout in milliseconds, increase this for reasoning models
				temperature = 0,
				max_tokens = 20000, -- Increase this to include reasoning tokens (for reasoning models)
				reasoning_effort = "high", -- low|medium|high, only used for reasoning models
			},
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-telescope/telescope.nvim",
			"saghen/blink.cmp",
			"ibhagwan/fzf-lua",
			"nvim-tree/nvim-web-devicons",
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
