local function set_buffer_map(bufnr, lhs, rhs, desc, mode)
	vim.keymap.set(mode or "n", lhs, rhs, {
		buffer = bufnr,
		desc = desc,
		silent = true,
	})
end

return {
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_mappings_enabled = 0
			vim.g.vimtex_imaps_enabled = 0

			if vim.fn.executable("zathura") == 1 then
				vim.g.vimtex_view_method = "zathura"
			elseif vim.fn.executable("okular") == 1 then
				vim.g.vimtex_view_method = "general"
				vim.g.vimtex_view_general_viewer = "okular"
				vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
			end
		end,
		config = function()
			local group = vim.api.nvim_create_augroup("vimtex-local-keymaps", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = { "tex", "plaintex" },
				callback = function(event)
					vim.opt_local.wrap = true
					vim.opt_local.spell = true
					vim.opt_local.conceallevel = 2

					set_buffer_map(event.buf, "<localleader>c", "<cmd>VimtexCompile<cr>", "Compile Document")
					set_buffer_map(event.buf, "<localleader>v", "<cmd>VimtexView<cr>", "View PDF")
					set_buffer_map(event.buf, "<localleader>t", "<cmd>VimtexTocOpen<cr>", "Table of Contents")
					set_buffer_map(event.buf, "<localleader>e", "<cmd>VimtexErrors<cr>", "Show Errors")
					set_buffer_map(event.buf, "<localleader>k", "<cmd>VimtexClean<cr>", "Clean Aux Files")
				end,
			})
		end,
	},
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		config = function()
			require("typst-preview").setup({
				dependencies_bin = {
					["tinymist"] = "tinymist",
				},
			})

			local group = vim.api.nvim_create_augroup("typst-local-keymaps", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "typst",
				callback = function(event)
					vim.opt_local.wrap = true
					vim.opt_local.spell = true

					set_buffer_map(event.buf, "<localleader>p", "<cmd>TypstPreviewToggle<cr>", "Toggle Preview")
					set_buffer_map(event.buf, "<localleader>s", "<cmd>TypstPreviewSyncCursor<cr>", "Sync Preview")
					set_buffer_map(event.buf, "<localleader>f", "<cmd>TypstPreviewFollowCursorToggle<cr>", "Follow Cursor")
				end,
			})
		end,
	},
}
