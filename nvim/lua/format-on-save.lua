vim.api.nvim_create_augroup("format_on_save", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "format_on_save",
	pattern = "*",
	callback = function()
		vim.lsp.buf.format()
	end,
})
