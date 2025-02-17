return {
	"epwalsh/obsidian.nvim",
	version = "*",
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/notes",
				},
			},
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d",
				alias_format = "%B %d, %Y",
				template = nil,
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
			mappings = {
				["gf"] = { action = require("obsidian").util.gf_passthrough },
				["<leader>zz"] = { action = ":ObsidianToday<CR>" },
				["<leader>zn"] = { action = ":ObsidianNew<CR>" },
				["<leader>zf"] = { action = ":ObsidianQuickSwitch<CR>" },
				["<leader>zb"] = { action = ":ObsidianBacklinks<CR>" },
				["<leader>zl"] = { action = ":ObsidianLink<CR>" },
				["<leader>zt"] = { action = ":ObsidianTags<CR>" },
			},
			preferred_link_style = "wiki",
			disable_frontmatter = false,
		})
	end,
}
