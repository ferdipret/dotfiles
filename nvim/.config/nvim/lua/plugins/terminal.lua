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
				id = 999,
				direction = "float",
				float_opts = {
					border = border,
				},
				hidden = true,
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

			local terminals = {}

			local function toggle_new_terminal()
				local new_term = Terminal:new({
					direction = "vertical",
					hidden = true,
				})

				table.insert(terminals, new_term)
				new_term:toggle()
			end

			local function toggle_all_terminals()
				if #terminals == 0 then
					toggle_new_terminal()
				else
					for _, term in ipairs(terminals) do
						term:toggle()
					end
				end
			end

			local function close_last_terminal()
				if #terminals > 0 then
					local term_to_close = table.remove(terminals)
					term_to_close:close()
				end
			end

			-- Keybindings
			set({ "n", "t" }, "<M-n>", toggle_new_terminal, opts)
			set({ "n", "t" }, "<M-c>", close_last_terminal, opts)
			set({ "n", "t" }, "<M-/>", toggle_all_terminals, opts)
		end,
	},
}
