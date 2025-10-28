return {
	"obsidian-nvim/obsidian.nvim", -- Community fork with blink.cmp & snacks support
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter", -- Better markdown parsing
	},
	lazy = true,
	ft = "markdown",
	opts = {
		workspaces = {
			{ name = "notes", path = "~/Documents/notes" },
		},

		-- Disable UI for performance, use render-markdown.nvim instead
		ui = { enable = false },

		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},

		picker = {
			name = "telescope.nvim",
		},

		-- Enhanced note ID function with better organization
		note_id_func = function(title)
			local suffix = os.date("%Y%m%d%H%M")
			if title then
				-- Keep it simple, just use the title with dashes
				return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
			else
				return suffix
			end
		end,

		-- Smart note location based on context
		new_notes_location = "notes",

		-- Enhanced daily notes
		daily_notes = {
			folder = "Dailies", -- Match your existing folder name
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			-- template = "daily", -- Disabled: Use Python script for date-aware generation
		},

		templates = {
			folder = "_templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- Substitutions for templates
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y-%m-%d", os.time() + 86400)
				end,
			},
		},

		-- Better link handling
		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,

		-- Attachments configuration (for images, PDFs, etc.)
		attachments = {
			img_folder = "assets/images",
			---@param client obsidian.Client
			---@param path obsidian.Path the absolute path to the image file
			---@return string
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},

		-- Enable additional markdown features
		note_frontmatter_func = function(note)
			local out = {
				id = note.id,
				aliases = note.aliases,
				tags = note.tags,
				created = os.date("%Y-%m-%d %H:%M"),
			}

			-- Add metadata for todos
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,

		-- Backlinks and references
		disable_frontmatter = false,

		-- Better search
		finder = "telescope.nvim",
		sort_by = "modified",
		sort_reversed = true,
		search_max_lines = 1000,
		open_notes_in = "current",
	},

	keys = {
		-- Existing keybindings
		{ "<leader>no", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
		{ "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "New Note" },
		{ "<leader>nd", "<cmd>ObsidianToday<cr>", desc = "Daily Note" },
		{ "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search Vault" },
		{ "<leader>nf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow Link" },

		-- Enhanced workflow keybindings
		{ "<leader>nq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch Note" },
		{ "<leader>nb", "<cmd>ObsidianBacklinks<cr>", desc = "Show Backlinks" },
		{ "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "Search Tags" },
		{ "<leader>nl", "<cmd>ObsidianLinks<cr>", desc = "Show All Links" },

		-- Todo management
		{ "<leader>nT", "<cmd>ObsidianTOC<cr>", desc = "Table of Contents" },
		{
			"<leader>nx",
			"<cmd>ObsidianExtractNote<cr>",
			mode = "v",
			desc = "Extract to New Note",
		},

		-- Templates
		{ "<leader>nti", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
		{ "<leader>ntm", "<cmd>ObsidianTemplate meeting<cr>", desc = "Meeting Template" },
		{ "<leader>ntp", "<cmd>ObsidianTemplate project<cr>", desc = "Project Template" },
		{ "<leader>ntt", "<cmd>ObsidianTemplate todo<cr>", desc = "Todo Template" },

		-- Quick capture workflows
		{
			"<leader>nm",
			function()
				-- Quick meeting note
				local title = "Meeting " .. os.date("%Y-%m-%d %H:%M")
				vim.cmd("ObsidianNew " .. title)
			end,
			desc = "Quick Meeting Note",
		},
		{
			"<leader>ni",
			function()
				-- Quick idea capture
				local title = "Idea " .. os.date("%Y%m%d%H%M")
				vim.cmd("ObsidianNew " .. title)
			end,
			desc = "Quick Idea",
		},

		-- Working with current file
		{ "<leader>nr", "<cmd>ObsidianRename<cr>", desc = "Rename Note" },
		{ "<leader>np", "<cmd>ObsidianPasteImg<cr>", desc = "Paste Image" },

		-- Todo/checkbox management
		{
			"<CR>",
			function()
				if vim.bo.filetype == "markdown" then
					require("obsidian").util.toggle_checkbox()
				end
			end,
			desc = "Toggle Checkbox",
		},
		{
			"<leader>nc",
			function()
				if vim.bo.filetype == "markdown" then
					require("obsidian").util.toggle_checkbox()
				end
			end,
			desc = "Toggle Checkbox",
		},

		-- Navigation (using Python script for date-aware generation)
		{
			"<leader>nd",
			function()
				local script_path = vim.fn.expand("~/Documents/notes/.scripts/generate_daily_note.py")
				vim.system(
					{ "python3", script_path, "0" },
					{ text = true },
					vim.schedule_wrap(function(obj)
						if obj.code == 0 then
							for _, line in ipairs(vim.split(obj.stdout, "\n")) do
								local file_path = line:match("FILE_PATH:(.*)")
								if file_path then
									vim.cmd("edit " .. vim.fn.fnameescape(file_path))
									return
								end
							end
						else
							vim.notify("Failed to generate daily note: " .. obj.stderr, vim.log.levels.ERROR)
						end
					end)
				)
			end,
			desc = "Generate Today's Daily Note"
		},
		{
			"<leader>ny",
			function()
				local script_path = vim.fn.expand("~/Documents/notes/.scripts/generate_daily_note.py")
				vim.system(
					{ "python3", script_path, "-1" },
					{ text = true },
					vim.schedule_wrap(function(obj)
						if obj.code == 0 then
							for _, line in ipairs(vim.split(obj.stdout, "\n")) do
								local file_path = line:match("FILE_PATH:(.*)")
								if file_path then
									vim.cmd("edit " .. vim.fn.fnameescape(file_path))
									return
								end
							end
						else
							vim.notify("Failed to generate yesterday's note: " .. obj.stderr, vim.log.levels.ERROR)
						end
					end)
				)
			end,
			desc = "Generate Yesterday's Daily Note"
		},
		{
			"<leader>nY",
			function()
				local script_path = vim.fn.expand("~/Documents/notes/.scripts/generate_daily_note.py")
				vim.system(
					{ "python3", script_path, "1" },
					{ text = true },
					vim.schedule_wrap(function(obj)
						if obj.code == 0 then
							for _, line in ipairs(vim.split(obj.stdout, "\n")) do
								local file_path = line:match("FILE_PATH:(.*)")
								if file_path then
									vim.cmd("edit " .. vim.fn.fnameescape(file_path))
									return
								end
							end
						else
							vim.notify("Failed to generate tomorrow's note: " .. obj.stderr, vim.log.levels.ERROR)
						end
					end)
				)
			end,
			desc = "Generate Tomorrow's Daily Note"
		},
		{ "<leader>nD", "<cmd>ObsidianDailies<cr>", desc = "Browse Daily Notes" },

		-- Workspace management (if you add more workspaces later)
		{ "<leader>nw", "<cmd>ObsidianWorkspace<cr>", desc = "Switch Workspace" },
	},
}
