return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				markdown = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				zsh = { "shfmt" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range" })
	end,
}
