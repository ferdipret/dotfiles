local M = {}

M.toggle = function()
	require("neo-tree.command").execute({
		toggle = true,
		reveal = true,
		source = "filesystem",
		position = "left",
	})
end

M.focus_filesystem = function()
	vim.api.nvim_exec2("Neotree focus filesystem left", { output = true })
end

M.focus_buffers = function()
	vim.api.nvim_exec2("Neotree focus buffers left", { output = true })
end

M.focus_git_status = function()
	vim.api.nvim_exec2("Neotree focus git_status left", { output = true })
end

return M
