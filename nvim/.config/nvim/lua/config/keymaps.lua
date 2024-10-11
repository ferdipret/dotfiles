local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "m"

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<esc>", ":nohl<CR>", opts)

-- Floating terminal
keymap("n", "<C-/>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Term(Root)" })
keymap("i", "<C-/>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Term(Root)" })

-- Terminal Mappings
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })