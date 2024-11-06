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
		"nvimdev/dashboard-nvim",
		lazy = false,
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
						{
							desc = " Apps",
							group = "DiagnosticHint",
							action = "Telescope app",
							key = "a",
						},
						{
							desc = " dotfiles",
							group = "Number",
							action = "Telescope dotfiles",
							key = "d",
						},
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "nordic",
					section_separators = { left = "", right = "" },
					component_separators = { left = "│", right = "│" },
					ignore_focus = {
						"neo-tree",
						"toggleterm",
					},
				},
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},

			scope = { show_start = false, show_end = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
		main = "ibl",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
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
			set({ "n", "t" }, "<F9>", toggle_new_terminal, opts)
			set({ "n", "t" }, "<F10>", close_last_terminal, opts)
			set({ "n", "t" }, "<C-_>", toggle_all_terminals, opts)
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
}
