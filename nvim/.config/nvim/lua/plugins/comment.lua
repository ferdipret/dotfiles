return {
	"numToStr/Comment.nvim",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	event = "VeryLazy",
	opts = {
		pre_hook = function(ctx)
			return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
		end,
	},
	config = function(_, opts)
		local comment = require("Comment")
		comment.setup(opts)

		local api = require("Comment.api")
		vim.keymap.set("n", "g//", api.toggle.linewise.current, { desc = "Toggle comment (linewise)" })
		vim.keymap.set("n", "g/b", api.toggle.blockwise.current, { desc = "Toggle comment (blockwise)" })

		vim.keymap.set("v", "g/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
			{ desc = "Toggle comment (linewise)", silent = true })
		vim.keymap.set("v", "g/b", "<esc><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<cr>",
			{ desc = "Toggle comment (blockwise)", silent = true })
	end,
}

