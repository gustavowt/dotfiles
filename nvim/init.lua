local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.g.mapleader = " "
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")

require("vim-options")
require("which-key-config")
require("custom-bindings")
require("ruby-lsp")
require("lsp-config")
require("lualine-config")

require("format-on-save")
-- require("nvimtree-on-vimenter")
