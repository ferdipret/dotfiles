local lua_ls_init = require("utils.lsp-server-configs").lua_ls_init

return {
	{ "williamboman/mason.nvim", build = ":MasonUpdate", config = true },
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
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_init = lua_ls_init,
				settings = {
					Lua = {},
				},
			})

			lspconfig.elixirls.setup({
				capabilities = capabilities,
				cmd = { "elixir-ls" },
			})

			lspconfig.vtsls.setup({
				capabilities = capabilities,
			})
		end,
	},
}
