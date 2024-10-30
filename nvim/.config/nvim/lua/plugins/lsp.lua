local lua_ls_init = require("utils.lsp-server-configs").lua_ls_init

return {
	{ "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
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
			})
		end,
		keys = {
			{ "K", vim.lsp.buf.hover },
			{ "gd", vim.lsp.buf.definition },
			{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
		},
	},

	-- These are used to configure LuaLS for Neovim editing.
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
}
