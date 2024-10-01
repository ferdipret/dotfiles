local tree_toggle = function()
	require('neo-tree.command').execute({
		toggle = true,
		source = "filesystem",
		position = "right",
	})
end

local M = {}

M.toggle = tree_toggle

return M
