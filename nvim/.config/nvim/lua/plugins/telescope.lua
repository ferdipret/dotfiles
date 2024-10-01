return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ "<leader>f", require('telescope.builtin').find_files, {} },
			{ "<leader>,", require('telescope.builtin').buffers,    {} },
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require('telescope').setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
						})
					}
				}
			})

			require("telescope").load_extension("ui-select")
		end
	}
}
