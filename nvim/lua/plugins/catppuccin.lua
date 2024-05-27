return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					cmp = true,
					gitsigns = true,
          barbar = true,
					treesitter = true,
					notify = false,
          neotree = true,
				},
			})
			-- vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
}
