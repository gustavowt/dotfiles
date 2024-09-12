return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.diagnostics.erb_lint,
				null_ls.builtins.diagnostics.rubocop,
				require("none-ls.diagnostics.eslint_d"),
				-- null_ls.builtins.diagnostics.ruby_lsp,
				-- null_ls.diagnostics.esling_d,
			},
			debug = true,
		})

		-- Create a new formatter for ruby using prettier ruby
		local prettier_ruby = null_ls.builtins.formatting.prettierd.with({
			command = "prettierd",
		})

		null_ls.register({
			sources = { prettier_ruby },
			filetypes = { "ruby" },
		})
	end,
}
