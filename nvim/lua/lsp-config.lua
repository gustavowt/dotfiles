-- LSP
vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", {})
vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", {})
vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<cr>", {})
vim.keymap.set("n", "gs", "<Cmd>lua vim.lsp.buf.signature_help()<cr>", {})
vim.keymap.set("n", "gI", "<Cmd>lua vim.lsp.buf.implementation()<cr>", {})
vim.keymap.set("n", "gl", function()
	local float = vim.diagnostic.config().float

	if float then
		local config = type(float) == "table" and float or {}
		config.scope = "line"

		vim.diagnostic.open_float(config)
	end
end, {})
