return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix", -- Your existing preset
		spec = {
			{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
		},
	},
}
