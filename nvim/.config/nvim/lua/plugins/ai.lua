return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			log_level = "info",
			disable_inline_completion = false,
			disable_keymaps = false,
		})

		local lspkind = require("lspkind")
		lspkind.init({
			symbol_map = {
				Supermaven = "",
			},
		})

		vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
	end,
}
