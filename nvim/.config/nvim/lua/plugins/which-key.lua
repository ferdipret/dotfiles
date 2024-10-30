local show_which_key = function()
	require("which-key").show({ global = false })
end

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},

	config = function()
		local status_ok, which_key = pcall(require, "which-key")
		if not status_ok then
			print("Which-key config not loaded")
			return
		end

		which_key.setup()

		which_key.add({
			{ "<leader>f", group = "file" },
			{ "<leader>?", show_which_key, desc = "Buffer Local Keymaps" },
			{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Lookup definition" },
			{ "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Lookup references" },
			{ "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Lookup declaration" },
			{ "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Lookup implementation" },
			{ "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Lookup Documentation" },
			{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature help" },
		})
	end,
}
