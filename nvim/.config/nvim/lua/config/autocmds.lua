-- Prevent Neo-tree from auto-opening when using `nvim .`
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				local name = vim.api.nvim_buf_get_name(bufnr)
				if name == "" or name == "." then
					vim.api.nvim_buf_delete(bufnr, { force = true }) -- Remove empty buffer
				end
			end
			vim.cmd("Dashboard") -- Load the dashboard
		end
	end,
})

-- Ensure the Dashboard loads when Neovim starts with no files
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	desc = "Open dashboard on startup if no files are provided",
	callback = function()
		if vim.fn.argc() == 0 then
			vim.cmd("Dashboard")
		end
	end,
})
