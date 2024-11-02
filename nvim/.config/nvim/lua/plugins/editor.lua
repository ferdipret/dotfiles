local nt = require("utils.neo-tree")

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
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader><leader>", require("telescope.builtin").find_files, desc = "Find Files" },
			{ "<leader>ff", require("telescope.builtin").find_files, desc = "Find Files" },
			{ "<leader>fh", require("telescope.builtin").help_tags, desc = "Help Tags" },
			{ "<leader>fg", require("telescope.builtin").live_grep, desc = "Live Grep" },
			{ "<leader>/", require("telescope.builtin").live_grep, desc = "Live Grep" },
			{ "<leader>fb", require("telescope.builtin").buffers, desc = "Buffers" },
			{ "<leader>,", require("telescope.builtin").buffers, desc = "Buffers" },
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
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},

		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		config = function()
			require("telescope").load_extension("lazygit")

			vim.g.lazygit_floating_window_border_chars = {
				b.top_left_corner,
				b.horizontal_top_line,
				b.top_right_corner,
				b.vertical_right_line,
				b.bottom_right_corner,
				b.horizontal_bottom_line,
				b.bottom_left_corner,
				b.vertical_left_line,
			}
		end,
	},
}
