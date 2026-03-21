return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local theme = require("config.theme")

			local function get_active_lsp()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then return "No LSP" end
				local lsp_names = {}
				for _, client in ipairs(clients) do
					table.insert(lsp_names, client.name)
				end
				return table.concat(lsp_names, " | ")
			end

			local function get_winbar_content()
				local filepath = vim.fn.expand("%:~:.")
				if filepath == "" then
					filepath = "[No Name]"
				end

				local modified_icon = vim.bo.modified and "%#WinbarModified#" .. "    " or "%#WinbarSaved#" .. "    "
				local reset = "%*"

				local winbar_str = modified_icon .. reset .. "%#NavicText#" .. filepath


				local navic = require("nvim-navic")
				if navic.is_available() then
					local context = navic.get_location()
					if context ~= "" then
						winbar_str = winbar_str .. " " .. "%#NavicText#" .. " " .. reset .. context
					end
				end

				return winbar_str
			end

				require("lualine").setup({
				options = {
					theme = theme.lualine,
					globalstatus = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "│", right = "│" },
					ignore_focus = { "neo-tree", "toggleterm" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						{ get_active_lsp, icon = "  LSP" },
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				winbar = {
					lualine_c = {
						{ get_winbar_content },
					},
				},
			})
		end,
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		event = "VeryLazy",
		opts = {
			options = {
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = function(n) require("snacks").bufdelete(n) end,
				right_mouse_command = function(n) require("snacks").bufdelete(n) end,
				left_mouse_command = "buffer %d",
				middle_mouse_command = nil,
				indicator = {
					icon = '▎',
					style = 'icon',
				},
				buffer_close_icon = '󰅖',
				modified_icon = '●',
				close_icon = '',
				left_trunc_marker = '',
				right_trunc_marker = '',
				max_name_length = 18,
				max_prefix_length = 15,
				truncate_names = true,
				tab_size = 18,
				diagnostics = "nvim_lsp",
				diagnostics_update_in_insert = false,
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						text_align = "center",
						separator = true,
					}
				},
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				persist_buffer_sort = true,
				separator_style = "thin",
				enforce_regular_tabs = false,
				always_show_bufferline = true,
				hover = {
					enabled = true,
					delay = 200,
					reveal = {'close'}
				},
				sort_by = 'insert_after_current',
			},
		},
	},
	{
		"SmiteshP/nvim-navic",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-navic").setup({
				icons = {
					File = ' ',
					Module = ' ',
					Namespace = ' ',
					Package = ' ',
					Class = ' ',
					Method = ' ',
					Property = ' ',
					Field = ' ',
					Constructor = ' ',
					Enum = ' ',
					Interface = ' ',
					Function = ' ',
					Variable = ' ',
					Constant = ' ',
					String = ' ',
					Number = ' ',
					Boolean = ' ',
					Array = ' ',
					Object = ' ',
					Key = ' ',
					Null = ' ',
					EnumMember = ' ',
					Struct = ' ',
					Event = ' ',
					Operator = ' ',
					TypeParameter = ' '
				},
				separator = "  ",
				highlight = true,
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
				lazy_update_context = false,
				click = false,
				format_text = function(text)
					return text
				end,
			})
		end,
	},
}
