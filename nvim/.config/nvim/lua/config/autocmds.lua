vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		-- Ensure Neovim was opened with a directory
		if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
			-- Get all buffers
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				local bufname = vim.api.nvim_buf_get_name(bufnr)

				-- Delete directory buffers
				if vim.fn.isdirectory(bufname) == 1 or bufname == "" then
					vim.schedule(function()
						vim.api.nvim_buf_delete(bufnr, { force = true })
					end)
				end
			end
		end
	end,
})

