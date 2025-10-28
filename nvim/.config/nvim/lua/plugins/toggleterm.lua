return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = { "ToggleTerm", "TermExec" },
	keys = {
		{
			"<leader>tf",
			function()
				if vim.fn.mode() == "t" then
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "tn", false)
				end
				require("toggleterm").toggle()
			end,
			mode = { "n", "t" },
			desc = "Toggle Terminal (project root)",
		},
	},
	opts = {
		direction = "float",
		open_mapping = nil, -- we handle mappings manually
		shade_terminals = true,
		shading_factor = 2,
		persist_mode = false,
		float_opts = {
			border = "rounded",
		},
		close_on_exit = true,
		shell = vim.o.shell,
		dir = "git_dir", -- jump to git root when available
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		-- Always start in insert mode when a terminal opens
		local augroup = vim.api.nvim_create_augroup("toggleterm-enter-insert", { clear = true })
		vim.api.nvim_create_autocmd("TermOpen", {
			group = augroup,
			pattern = "term://*toggleterm#*",
			callback = function()
				vim.cmd("startinsert")
			end,
		})

		-- Provide a helper command to retarget the root manually
		vim.api.nvim_create_user_command("ToggleTermRoot", function()
			require("toggleterm").toggle({ dir = "git_dir" })
		end, { desc = "Toggle floating terminal at project root" })
	end,
}
