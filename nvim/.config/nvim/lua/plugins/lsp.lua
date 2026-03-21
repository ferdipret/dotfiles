local lua_ls_init = require("utils.lsp-server-configs").lua_ls_init
return {
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require('tiny-inline-diagnostic').setup()
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
	},
	"williamboman/mason-lspconfig.nvim",
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"SmiteshP/nvim-navic",
		},
		keys = {
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "vtsls", "eslint" },
				automatic_installation = true,
			})

			local navic = require("nvim-navic")

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.server_capabilities.documentSymbolProvider then
						navic.attach(client, args.buf)
					end
				end,
			})

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			vim.lsp.config("eslint", {
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(vim.fs.dirname(vim.fs.find(
						{ ".eslintrc.cjs", ".eslintrc.js", "eslint.config.js", "package.json" },
						{ path = fname, upward = true }
					)[1]))
				end,
				settings = { format = false },
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})

			vim.lsp.config("lua_ls", {
				on_init = lua_ls_init,
				settings = {
					Lua = {},
				},
			})

			vim.lsp.config("elixirls", {
				cmd = { "elixir-ls" },
				filetypes = { "elixir", "heex", "eelixir", "surface" },
			})

			vim.lsp.config("graphql", {
				cmd = { "graphql-lsp", "server", "-m", "stream" },
				filetypes = { "graphql", "javascript", "typescript", "typescriptreact" },
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(vim.fs.dirname(vim.fs.find(
						{ ".graphqlconfig", "package.json", ".git" },
						{ path = fname, upward = true }
					)[1]))
				end,
			})

			vim.lsp.config("emmet_language_server", {
				filetypes = {
					"html", "css", "javascript", "javascriptreact",
					"typescript", "typescriptreact", "elixir", "heex",
				},
			})

			vim.lsp.config("tailwindcss", {
				filetypes = {
					"html", "css", "javascript", "javascriptreact",
					"typescript", "typescriptreact", "elixir", "heex",
				},
				root_dir = function(bufnr, on_dir)
					local fname = vim.api.nvim_buf_get_name(bufnr)
					on_dir(vim.fs.dirname(vim.fs.find(
						{ "tailwind.config.js", "tailwind.config.ts", "package.json", ".git", "mix.exs" },
						{ path = fname, upward = true }
					)[1]))
				end,
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ 'class\\s*=\\s*"([^"]*)"' },
								{ 'class:\\s*"([^"]*)"' },
								{ "cva\\(((?:[^)(]|\\([^)(]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cn\\(((?:[^)(]|\\([^)(]*\\))*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
							},
						},
					},
				},
			})

			vim.lsp.enable({
				"eslint",
				"lua_ls",
				"vtsls",
				"elixirls",
				"graphql",
				"emmet_language_server",
				"tailwindcss",
			})
		end,
	},
}
