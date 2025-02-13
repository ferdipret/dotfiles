return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		ensure_installed = { "lua", "vim", "regex", "javascript", "typescript", "tsx", "html", "css" },
		auto_install = true,
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})
	end,
}
