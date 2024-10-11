local M = {}

M.toggle = function()
	require("neo-tree.command").execute({
		toggle = true,
		source = "filesystem",
		position = "left",
	})
end

return M
