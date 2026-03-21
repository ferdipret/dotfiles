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

			local function executable(name)
				return vim.fn.executable(name) == 1
			end

			local function available(...)
				local linters = {}
				for _, name in ipairs({ ... }) do
					if executable(name) then
						table.insert(linters, name)
					end
				end
				return linters
			end

			lint.linters_by_ft = {
				javascript = available("eslint_d"),
				javascriptreact = available("eslint_d"),
				typescript = available("eslint_d"),
				typescriptreact = available("eslint_d"),
				markdown = available("markdownlint-cli2"),
				python = available("ruff"),
				sh = available("shellcheck"),
				zsh = available("shellcheck"),
			}

			local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = group,
				callback = function()
					local names = lint.linters_by_ft[vim.bo.filetype]
					if names and #names > 0 then
						lint.try_lint(names)
					end
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
