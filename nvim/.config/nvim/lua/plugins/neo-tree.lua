return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
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

		local wk = require("which-key")

		wk.add({
			{ "<leader>e", "<cmd>Neotree source=filesystem reveal=true toggle<CR>", desc = "Explorer" },
		})
	end,
}
