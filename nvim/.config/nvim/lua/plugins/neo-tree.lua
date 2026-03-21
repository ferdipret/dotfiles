return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	keys = {
		{ "<leader>e", "<cmd>Neotree source=filesystem reveal=true toggle<CR>", desc = "Explorer" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
		},
		buffers = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}
