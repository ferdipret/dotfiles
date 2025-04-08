local lua_ls_init = require("utils.lsp-server-configs").lua_ls_init

return {
	{
		'dmmulroy/ts-error-translator.nvim',
		config = function()
			require("ts-error-translator").setup()
		end,
	},
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
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "vtsls", "eslint" },
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local navic = require("nvim-navic")

			local function make_on_attach(custom_on_attach)
				return function(client, bufnr)
					if client.server_capabilities.documentSymbolProvider then
						navic.attach(client, bufnr)
					end

					if custom_on_attach then
						custom_on_attach(client, bufnr)
					end
				end
			end

			local function setup_lsp(server_name, custom_config)
				local default_config = {
					capabilities = capabilities,
				}
				local config = vim.tbl_deep_extend("force", default_config, custom_config or {})

				config.on_attach = make_on_attach(config.on_attach)

				lspconfig[server_name].setup(config)
			end

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					setup_lsp(server_name)
				end,
				["eslint"] = function()
					setup_lsp("eslint", {
						root_dir = require("lspconfig.util").root_pattern(
							".eslintrc.cjs",
							".eslintrc.js",
							"eslint.config.js",
							"package.json"
						),
						settings = { format = false },
						on_attach = function(client)
							client.server_capabilities.documentFormattingProvider = false
						end,
					})
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
						root_dir = require("lspconfig").util.root_pattern(".graphqlconfig", "package.json", ".git"),
					})
				end,
				["emmet_language_server"] = function()
					setup_lsp("emmet_language_server", {
						filetypes = {
							"html", "css", "javascript", "javascriptreact",
							"typescript", "typescriptreact", "elixir", "heex",
						},
					})
				end,
				["tailwindcss"] = function()
					setup_lsp("tailwindcss", {
						filetypes = {
							"html", "css", "javascript", "javascriptreact",
							"typescript", "typescriptreact", "elixir", "heex",
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
