vim.api.nvim_create_augroup("nvim_tree_on_vimenter", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = "nvim_tree_on_vimenter",
	pattern = "*",
	callback = function()
		require("nvim-tree.api").tree.open()
	end,
})
