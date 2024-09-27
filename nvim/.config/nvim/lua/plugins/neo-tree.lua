local tree_toggle = function()
	require('neo-tree.command').execute({
		toggle = true,
		source = "filesystem",
		position = "left",
	})
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},  
	keys = {
		{ "<leader>e", tree_toggle, desc = "Project sidebar" },
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree").setup({
            window = {
              position = "current",
            },
          })
        end
      end
    end
}
