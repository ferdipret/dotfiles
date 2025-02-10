return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- For icons
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto", -- Automatically use colors from your colorscheme
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" }, -- Shows current mode (NORMAL, INSERT, etc.)
				lualine_b = { "branch" }, -- Git branch
				lualine_c = { { "filename", path = 1 } }, -- Show filename with relative path
				lualine_x = { "encoding", "fileformat", "filetype" }, -- File info
				lualine_y = { "progress" }, -- % through the file
				lualine_z = { "location" }, -- Cursor position (line:col)
			},
		})
	end,
}
