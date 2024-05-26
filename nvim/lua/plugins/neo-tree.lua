return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
  config = function ()
    require("neo-tree").setup({
      follow_current_file = {
        enable = true,
        update_cwd = true,
      },
    })
    nvim.keymap.map("n", "<S-f>", "<cmd>Neotree reveal_force_cwd<CR>")
  end
}
