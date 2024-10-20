local k = require("utils.keymap")
local set, opts = k.set, k.opts

local b = require("utils.borders").box_drawing_chars

local border = {
	b.top_left_corner,
	b.horizontal_top_line,
	b.top_right_corner,
	b.vertical_right_line,
	b.bottom_right_corner,
	b.horizontal_bottom_line,
	b.bottom_left_corner,
	b.vertical_left_line,
}

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = border,
				},
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					else
						return 20
					end
				end,
			})

			local Terminal = require("toggleterm.terminal").Terminal

			local sidebar_term = Terminal:new({
				direction = "vertical",
				hidden = true,
			})

			local toggle_sidebar_term = function()
				sidebar_term:toggle()
			end

			set({ "n", "t" }, "<M-/>", toggle_sidebar_term, opts)
		end,
	},
}
