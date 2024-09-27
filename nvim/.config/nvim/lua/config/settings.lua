-- :help options
local settings = {
	fileencoding = "utf-8",
	backup = false,
	writebackup = false,
	undofile = true,
	clipboard = "unnamedplus",
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	smartcase = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	termguicolors = true,
	timeoutlen = 300,
	updatetime = 300,
	shiftwidth = 2,
	tabstop = 2,
	expandtab = false,
	cursorline = true,
	number = true,
	relativenumber = true,
	signcolumn = "yes",
	wrap = false,
	scrolloff = 8,
	sidescrolloff = 8,
	list = true,
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.diagnostic.config({
	virtual_text = false,
})

for k, v in pairs(settings) do
	vim.opt[k] = v
end

vim.cmd([[set iskeyword+=-]])
