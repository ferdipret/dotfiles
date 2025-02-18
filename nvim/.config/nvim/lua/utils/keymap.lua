local M = {}

M.opts = { noremap = true, silent = true }
M.keymap = vim.api.nvim_set_keymap
M.set = vim.keymap.set

return M
