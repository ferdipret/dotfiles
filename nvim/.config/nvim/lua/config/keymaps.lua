local map = vim.keymap.set

vim.g.mapleader = " " -- Space as leader key

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Escape clears search highlights
map("n", "<esc>", ":nohlsearch<CR>")

-- Toggle file explorer (Neo-tree)
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

