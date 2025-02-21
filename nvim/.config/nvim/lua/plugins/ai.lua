return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-e>",
					accept_word = "<C-j>",
				},
				disable_inline_completion = false,
				disable_keymaps = false,
			})
		end,
	},
}
