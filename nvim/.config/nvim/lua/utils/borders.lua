local M = {}

M.box_drawing_chars = {
	top_left_corner = "🭽", -- U+1F11D
	top_right_corner = "🭾", -- U+1F11E
	bottom_right_corner = "🭿", -- U+1F11F
	bottom_left_corner = "🭼", -- U+1F11C
	horizontal_top_line = "▔", -- U+2500
	horizontal_bottom_line = "▁",
	vertical_right_line = "▕", -- U+2502
	vertical_left_line = "▏",
	split_horizontal_top = "┬", -- U+252C
	split_horizontal_bottom = "┴", -- U+2534
	split_vertical_left = "├", -- U+251C
	split_vertical_right = "┤", -- U+2524
	intersection = "┼", -- U+253C
}

return M
