return {
	"epwalsh/obsidian.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	lazy = true,
	ft = "markdown",
	opts = {
		workspaces = {
			{ name = "notes", path = "~/Documents/notes" },
		},
		ui = { enable = false },

		completion = { nvim_cmp = true },
		picker = { name = "telescope.nvim" },

		note_id_func = function(title)
			local suffix = os.date("%Y%m%d%H%M")
			if title then
				return "fleeting/" .. title:gsub(" ", "-")
			else
				return "fleeting/" .. suffix
			end
		end,

		new_notes_location = "fleeting",

		daily_notes = {
			folder = "dailies",
			template = "_templates/daily.md",
		},

		templates = {
			folder = "_templates",
		},

		follow_url_func = function(url)
			-- vim.fn.jobstart({"open", url})  -- Mac OS
			vim.fn.jobstart({ "xdg-open", url }) -- linux
			-- vim.ui.open(url) -- need Neovim 0.10.0+
		end,

	},
	keys = {
		{ "<leader>no", "<cmd>ObsidianOpen<cr>",   desc = "Open Obsidian" },
		{ "<leader>nn", "<cmd>ObsidianNew<cr>",    desc = "Create Fleeting Note" },
		{ "<leader>nd", "<cmd>ObsidianToday<cr>",  desc = "Open Daily Note" },
		{ "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian Vault" },
		{
			"gd",
			function()
				local util = require("obsidian").util
				local word_under_cursor = vim.fn.expand("<cWORD>") -- Get the word under the cursor

				if word_under_cursor:match("^https?://") then
					-- Open external links in browser
					vim.fn.jobstart({ "xdg-open", word_under_cursor }, { detach = true }) -- Linux
					vim.fn.jobstart({ "open", word_under_cursor }, { detach = true }) -- macOS
				elseif util.cursor_on_markdown_link() or word_under_cursor:match("%[%[.-%]%]") then
					-- If on an Obsidian-style link ([[Course Notes]]), follow it
					vim.cmd("ObsidianFollowLink")
				else
					-- Otherwise, default to LSP "go to definition"
					vim.cmd("normal! gd")
				end
			end,
			desc = "Follow link (Obsidian or external) or go to definition"
		},
		{
			"<CR>",
			function()
				if vim.bo.filetype == "markdown" then
					require("obsidian").util.toggle_checkbox()
				end
			end,
			desc = "Toggle Task Checkbox in Markdown",
		},
	},
}
