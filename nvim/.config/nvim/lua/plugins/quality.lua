return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufWritePost", "InsertLeave" },
		keys = {
			{
				"<leader>rl",
				function()
					require("lint").try_lint()
				end,
				desc = "Lint Buffer",
			},
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				markdown = { "markdownlint-cli2" },
				python = { "ruff" },
				sh = { "shellcheck" },
				zsh = { "shellcheck" },
			}

			local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = group,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-python",
			"marilari88/neotest-vitest",
		},
		keys = {
			{
				"<leader>ra",
				function()
					require("neotest").run.run(vim.fn.getcwd())
				end,
				desc = "Run All Tests",
			},
			{
				"<leader>rf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File Tests",
			},
			{
				"<leader>rn",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest Test",
			},
			{
				"<leader>ro",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Open Test Output",
			},
			{
				"<leader>rO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},
			{
				"<leader>rs",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Test Summary",
			},
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-plenary"),
					require("neotest-python")({
						dap = { justMyCode = false },
					}),
					require("neotest-vitest")({
						filter_dir = function(name)
							return name ~= "node_modules" and name ~= ".git"
						end,
					}),
				},
				quickfix = {
					open = false,
				},
			})
		end,
	},
}
