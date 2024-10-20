local b = require("utils.borders").box_drawing_chars

local borderchars = {
	b.horizontal_top_line,
	b.vertical_right_line,
	b.horizontal_bottom_line,
	b.vertical_left_line,
	b.top_left_corner,
	b.top_right_corner,
	b.bottom_right_corner,
	b.bottom_left_corner,
}

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>f", require("telescope.builtin").find_files, {} },
			{ "<leader>,", require("telescope.builtin").buffers, {} },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					borderchars = borderchars,
					prompt_prefix = "   ",
					selection_caret = " ",
					entry_prefix = " ",
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						width = 0.87,
						height = 0.80,
					},
					mappings = {
						n = { ["q"] = require("telescope.actions").close },
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							borderchars = borderchars,
						}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
