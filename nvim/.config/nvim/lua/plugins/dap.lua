return {
	-- Core DAP
	{ "mfussenegger/nvim-dap" },

	-- UI (optional but nice)
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
		end,
	},

	-- Python adapter helper
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			-- We'll point this at a local venv debugpy (created below)
			require("dap-python").setup(vim.fn.getcwd() .. "/api/.venv/bin/python")
		end,
	},
}
