return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua", "latex", "bibtex", "typst", "markdown", "markdown_inline" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				ignore_install = {},
				auto_install = true,
				modules = {},
			})

			local query = require("vim.treesitter.query")

			local function first_node(capture)
				if type(capture) == "table" then
					return capture[1]
				end
				return capture
			end

			local function node_text(match, bufnr, pred, metadata)
				local id = pred[2]
				local node = first_node(match[id])
				if not node then
					return nil, id
				end
				return vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }), id
			end

			local lang_aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				ts = "typescript",
				uxn = "uxntal",
			}

			query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local text = node_text(match, bufnr, pred, metadata)
				if not text then
					return
				end
				local alias = text:lower()
				metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
					or lang_aliases[alias]
					or alias
			end, { force = true, all = false })

			query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
				local text = node_text(match, bufnr, pred, metadata)
				if not text then
					return
				end
				local configured = ({
					["application/ecmascript"] = "javascript",
					["importmap"] = "json",
					["module"] = "javascript",
					["text/ecmascript"] = "javascript",
				})[text]
				local parts = vim.split(text, "/", {})
				metadata["injection.language"] = configured or parts[#parts]
			end, { force = true, all = false })

			query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
				local text, id = node_text(match, bufnr, pred, metadata)
				if not text then
					return
				end
				metadata[id] = metadata[id] or {}
				metadata[id].text = text:lower()
			end, { force = true, all = false })
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup({
				aliases = {
					["heex"] = "html",
				},
			})
		end,
	},
	{
		"nvim-treesitter/playground",
	},
}
