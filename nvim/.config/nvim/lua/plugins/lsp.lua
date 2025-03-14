local lua_ls_init = require("utils.lsp-server-configs").lua_ls_init

return {
	{
		'dmmulroy/ts-error-translator.nvim',
		config = function()
			require("ts-error-translator").setup()
		end
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require('tiny-inline-diagnostic').setup()
			vim.diagnostic.config({ virtual_text = false })
		end
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "vtsls" },
				automatic_installation = true,
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function setup_lsp(server_name, custom_config)
				local default_config = {
					capabilities = capabilities,
				}

				local config = vim.tbl_deep_extend("force", default_config, custom_config or {})

				lspconfig[server_name].setup(config)
			end

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					setup_lsp(server_name)
				end,

				["lua_ls"] = function()
					setup_lsp("lua_ls", {
						on_init = lua_ls_init,
						settings = {
							Lua = {},
						},
					})
				end,
				["elixirls"] = function()
					setup_lsp("elixirls", {
						cmd = { "elixir-ls" },
					})
				end,

				["graphql"] = function()
					setup_lsp("graphql", {
						cmd = { "graphql-lsp", "server", "-m", "stream" },
						filetypes = { "graphql", "javascript", "typescript", "typescriptreact" },
						root_dir = require 'lspconfig'.util.root_pattern(".graphqlconfig", "package.json", ".git"),

					})
				end,

				["emmet_language_server"] = function()
					setup_lsp("emmet_language_server", {
						filetypes = {
							"html",
							"css",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"elixir",
							"heex",
						},
					})
				end,

				["tailwindcss"] = function()
					setup_lsp("tailwindcss", {
						filetypes = {
							"html",
							"css",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"elixir",
							"heex",
						},
						root_dir = function(fname)
							return require("lspconfig.util").root_pattern(
								"tailwind.config.js",
								"tailwind.config.ts",
								"package.json",
								".git",
								"mix.exs"
							)(fname)
						end,
						settings = {
							tailwindCSS = {
								experimental = {
									classRegex = {
										-- Phoenix LiveView class syntax
										{ 'class\\s*=\\s*"([^"]*)"' },
										{ 'class:\\s*"([^"]*)"' },
									},
								},
							},
						},
					})
				end,
			})
		end,
	},
}
