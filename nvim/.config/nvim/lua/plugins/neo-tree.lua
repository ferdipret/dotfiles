return 	{
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
	opts = {
		filesystem = { hijack_netrw_behavior = "disabled" },
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}

