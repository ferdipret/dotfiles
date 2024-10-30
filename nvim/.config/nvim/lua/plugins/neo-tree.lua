local nt = require("utils.neo-tree")

return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", nt.toggle, desc = "Project sidebar" },
	},
	opts = {
		filesystem = {
			hijack_netwr_behavior = "open_default",
		},
	},
	-- This will make sure that we replace netwr with neo-tree
	init = function()
		if vim.fn.argc(-1) == 1 then
			local stat = vim.loop.fs_stat(vim.fn.argv(0))

			if stat and stat.type == "directory" then
				require("neo-tree").setup({
					window = {
						position = "current",
						mappings = {
							["e"] = nt.focus_filesystem,
							["b"] = nt.focus_buffers,
							["g"] = nt.focus_git_status,
						},
					},
					default_component_configs = {
						intent = {
							expander_collapsed = "",
							expander_expanded = "",
						},
					},

					filesystem = {
						filtered_items = {
							visible = true,
							hide_hidden = false,
							hide_dotfiles = false,
						},
					},
				})
			end
		end
	end,
}
