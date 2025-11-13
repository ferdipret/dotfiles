return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			bullet = {
				enabled = true,
				right_pad = 1,
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_echo_preview_url = 1
			vim.g.mkdp_theme = "dark"
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		keys = {
			{
				"<leader>nP",
				function()
					if vim.bo.filetype ~= "markdown" then
						vim.notify("Markdown previews are only available for markdown buffers", vim.log.levels.WARN)
						return
					end
					vim.cmd("MarkdownPreviewToggle")
				end,
				desc = "Toggle Markdown Preview",
			},
		},
	},
}
