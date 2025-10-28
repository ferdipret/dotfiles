return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		spec = {
			{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
			-- Group descriptions
			{ "<leader>b", group = "Buffers" },
			{ "<leader>c", group = "Code" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>gh", group = "Git Hunks" },
			{ "<leader>gn", group = "Neogit" },
			{ "<leader>n", group = "Notes" },
			{ "<leader>nt", group = "Templates" },
			{ "<leader>s", group = "Search" },
			{ "<leader>u", group = "UI Toggles" },
			{ "<leader>x", group = "Notifications" },
		},
	},
}
