return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			automatic_enable = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local mason_lspconfig = require("mason-lspconfig")
			local servers = {
				ruby_lsp = {},
			}

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			if vim.lsp and vim.lsp.config then
				-- Neovim 0.11+ API
				vim.lsp.config("ts_ls", {
					capabilities = capabilities,
				})
				vim.lsp.config("html", {
					capabilities = capabilities,
				})
				vim.lsp.config("lua_ls", {
					capabilities = capabilities,
				})
				vim.lsp.config("ruby_lsp", {
					capabilities = capabilities,
				})

				vim.lsp.enable({ "ts_ls", "html", "lua_ls", "ruby_lsp" })
			else
				-- Neovim < 0.11 via nvim-lspconfig
				local lspconfig = require("lspconfig")
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
				})
				lspconfig.html.setup({
					capabilities = capabilities,
				})
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
				})
				lspconfig.ruby_lsp.setup({
					capabilities = capabilities,
				})
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
		end,
	},
	{
		"SmiteshP/nvim-navic",
	},
}
