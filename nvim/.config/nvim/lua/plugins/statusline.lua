return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-lua/lsp-status.nvim" },
		config = function()
			local function get_active_lsp()
				local clients = vim.lsp.get_active_clients()
				if #clients == 0 then return "No LSP" end
				local lsp_names = {}
				for _, client in ipairs(clients) do
					table.insert(lsp_names, client.name)
				end
				return table.concat(lsp_names, " | ")
			end

			local function is_supermaven_active()
				if package.loaded["supermaven-nvim"] then
					return " Supermaven"
				end
				return ""
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
					theme = "tokyonight",
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
						{ is_supermaven_active },
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
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			sidebar_filetypes = {
				["neo-tree"] = {
					text = "Neo-tree",
					position = "left",
					padding = 1,
					separator = true,
				},
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
