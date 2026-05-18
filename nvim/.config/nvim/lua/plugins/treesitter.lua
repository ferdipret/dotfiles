return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Parsers (your previous list + the ones you'd likely want for your stack)
			local parsers = {
				"lua",
				"latex",
				"bibtex",
				"typst",
				"markdown",
				"markdown_inline",
				-- Add anything else you actively use:
				"vim", "vimdoc", "query",
				"elixir", "heex", "eex",
				"typescript", "tsx", "javascript",
				"html", "css", "json", "yaml", "toml",
				"bash", "regex",
			}
			require("nvim-treesitter").install(parsers)

			-- Enable highlight + indent per-buffer (new API replaces highlight/indent modules)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = args.match
					local lang = vim.treesitter.language.get_lang(ft)
					if lang and pcall(vim.treesitter.start, args.buf, lang) then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- Custom query directives (unchanged — these use vim.treesitter.query, not nvim-treesitter)
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
	-- playground removed: deprecated, use built-in :InspectTree and :EditQuery instead
}
