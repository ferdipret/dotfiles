return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		keys = {
			{ "<leader>gn",  "<cmd>Neogit kind=split<CR>", desc = "Neogit Status (split)" },
			{ "<leader>gnc", "<cmd>Neogit commit<CR>",     desc = "Neogit Commit" },
			{ "<leader>gnp", "<cmd>Neogit push<CR>",       desc = "Neogit Push" },
			{ "<leader>gnl", "<cmd>Neogit log<CR>",        desc = "Git Log" },
		},
		config = function()
			require("neogit").setup {
				disable_commit_confirmation = true,
				integrations = {
					diffview = true,
				},
			}

			require("which-key").register({
				g = {
					n = {
						name = "Git Neogit",
						n = { "<cmd>Neogit kind=split<CR>", "Status (split)" },
						c = { "<cmd>Neogit commit<CR>", "Commit" },
						p = { "<cmd>Neogit push<CR>", "Push" },
						l = { "<cmd>Neogit log<CR>", "Log" },
						d = { "<cmd>Neogit diff<CR>", "Diff" },
						r = { "<cmd>Neogit reset HEAD<CR>", "Reset (unstage)" },
					},
				},
			}, { prefix = "<leader>" })
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add          = { text = "│" },
					change       = { text = "│" },
					delete       = { text = "_" },
					topdelete    = { text = "‾" },
					changedelete = { text = "~" },
				},
				current_line_blame = true,
			})

			require("which-key").register({
				g = {
					h = {
						name = "Git Hunk",
						h = { "<cmd>lua require('gitsigns').preview_hunk()<CR>", "Preview Hunk" },
						n = { "<cmd>lua require('gitsigns').next_hunk()<CR>", "Next Hunk" },
						p = { "<cmd>lua require('gitsigns').prev_hunk()<CR>", "Previous Hunk" },
						s = { "<cmd>lua require('gitsigns').stage_hunk()<CR>", "Stage Hunk" },
						u = { "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", "Undo Stage Hunk" },
						r = { "<cmd>lua require('gitsigns').reset_hunk()<CR>", "Reset Hunk" },
						R = { "<cmd>lua require('gitsigns').reset_buffer()<CR>", "Reset Buffer" },
						b = { "<cmd>lua require('gitsigns').blame_line()<CR>", "Blame Line" },
						t = { "<cmd>lua require('gitsigns').toggle_signs()<CR>", "Toggle Signs" },
						d = { "<cmd>lua require('gitsigns').diffthis()<CR>", "Diff This" },
						o = { "<cmd>lua require('gitsigns').open_fold()<CR>", "Open Fold" },
						c = { "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>", "Toggle Line Blame" },
					},
				},
			}, { prefix = "<leader>" })
		end,
	},
}
