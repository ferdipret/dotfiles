return {
	"epwalsh/obsidian.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	ft = "markdown",
	opts = {
		workspaces = {
			{ name = "notes", path = "~/Documents/notes" },
		},
		completion = { nvim_cmp = true },
		picker = { name = "telescope.nvim" },
		note_id_func = function(title)
			local suffix = os.date("%Y%m%d%H%M")
			return title and title:gsub(" ", "-") or "fleeting-" .. suffix
		end,

		config = function(_, opts)
			require("obsidian").setup(opts)
			require("telescope").load_extension("obsidian")
		end,
	},
	keys = {
		{ "<leader>xo", "<cmd>ObsidianOpen<cr>",       desc = "Open Obsidian" },
		{ "<leader>xl", "<cmd>ObsidianNewLink<cr>",    desc = "New Link" },
		{ "<leader>xd", "<cmd>ObsidianNewDayNote<cr>", desc = "New Day Note" },
		{
			"gd",
			function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "cmd>ObsidianFollowLink<CR>"
				else
					return "gd"
				end
			end,
			desc = "Follow link"
		}
	},
}
