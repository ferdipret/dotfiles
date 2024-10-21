local k = require("utils.keymap")
local opts, set = k.opts, k.set

-- Remap space as leader key
set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "m"

-- Window Navigation
set("n", "<C-h>", "<C-w>h", opts)
set("n", "<C-j>", "<C-w>j", opts)
set("n", "<C-k>", "<C-w>k", opts)
set("n", "<C-l>", "<C-w>l", opts)
set("n", "<esc>", ":nohl<CR>", opts)

-- Floating terminal
-- set({ "n", "i" }, "<C-_>", "<cmd>ToggleTerm<cr>", { desc = "Toggle Term(Root)" })

-- Terminal Mappings
-- set("t", "<C-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })
set("t", "<Esc>", [[<C-\><C-n>]], opts)
