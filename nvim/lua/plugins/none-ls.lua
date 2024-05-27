return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with({
          command = "./node_modules/.bin/prettier",
        }),
				null_ls.builtins.diagnostics.erb_lint,
			},
		})

		-- Create a new formatter for ruby using prettier ruby
		local prettier_ruby = null_ls.builtins.formatting.prettier.with({
			command = "./node_modules/.bin/prettier",
			args = { "--plugin", "@prettier/plugin-ruby" },
		})

		null_ls.register({
			sources = { prettier_ruby },
			filetypes = { "ruby" },
		})
	end,
}
