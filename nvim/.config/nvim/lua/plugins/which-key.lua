return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = 200,
		win = {
			border = "rounded",
		},
		spec = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Show Buffer Keymaps",
				icon = "󰋖",
			},
			{ "<leader>a", group = "AI", icon = "󱙺" },
			{ "<leader>b", group = "Buffers", icon = "󰓩" },
			{ "<leader>c", group = "Code", icon = "󰘦" },
			{ "<leader>d", group = "Diagnostics", icon = "󰅚" },
			{ "<leader>f", group = "Find", icon = "󰍉" },
			{ "<leader>g", group = "Git", icon = "󰊢" },
			{ "<leader>gh", group = "Hunks", icon = "󰐕" },
			{ "<leader>gn", group = "Neogit", icon = "󰊢" },
			{ "<leader>n", group = "Notes", icon = "󱞁" },
			{ "<leader>nt", group = "Templates", icon = "󰗴" },
			{ "<leader>s", group = "Search", icon = "󰱼" },
			{ "<leader>t", group = "Terminal", icon = "󰆍" },
			{ "<leader>u", group = "UI", icon = "󰙵" },
			{ "<leader>x", group = "Notifications", icon = "󰍡" },
			{ "<localleader>", group = "Local", icon = "󰌌" },
		},
	},
}
