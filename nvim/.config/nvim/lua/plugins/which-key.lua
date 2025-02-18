return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix", -- Your existing preset
    spec = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
      { "<leader>w", "<cmd>w<CR>", desc = "Save" },
      { "<leader>q", "<cmd>q<CR>", desc = "Quit" },
      { "<leader>x", "<cmd>x<CR>", desc = "Save & Quit" },
    },
	},
}

