return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>gn", "<cmd>Neogit kind=split<CR>", desc = "Neogit Status" },
			{ "<leader>gnc", "<cmd>Neogit commit<CR>", desc = "Commit" },
			{ "<leader>gnp", "<cmd>Neogit push<CR>", desc = "Push" },
			{ "<leader>gnl", "<cmd>Neogit log<CR>", desc = "Log" },
			{ "<leader>gnd", "<cmd>Neogit diff<CR>", desc = "Diff" },
			{ "<leader>gnr", "<cmd>Neogit reset HEAD<CR>", desc = "Reset (unstage)" },
		},
		config = function()
			require("neogit").setup({
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			})
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<leader>ghh", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
			{ "<leader>ghn", function() require("gitsigns").next_hunk() end, desc = "Next Hunk" },
			{ "<leader>ghp", function() require("gitsigns").prev_hunk() end, desc = "Previous Hunk" },
			{ "<leader>ghs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
			{ "<leader>ghu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Hunk" },
			{ "<leader>ghr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
			{ "<leader>ghR", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
			{ "<leader>ghb", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
			{ "<leader>ght", function() require("gitsigns").toggle_signs() end, desc = "Toggle Signs" },
			{ "<leader>ghd", function() require("gitsigns").diffthis() end, desc = "Diff This" },
			{ "<leader>gho", function() require("gitsigns").open_fold() end, desc = "Open Fold" },
			{ "<leader>ghc", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle Line Blame" },
		},
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				current_line_blame = true,
			})
		end,
	},
}
