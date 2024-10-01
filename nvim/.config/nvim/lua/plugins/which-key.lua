local show_which_key = function()
	require("which-key").show({ global = false })
end

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	keys = {
		-- Code actions
		{ "<leader>c", group = "code" },
		{ "<leader>?", show_which_key, desc = "Buffer Local Keymaps" },
	},
}
