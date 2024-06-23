return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		-- OR setup with some options
		require("nvim-tree").setup({
			on_attach = function(buffer)
				local api = require("nvim-tree.api")
				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = buffer,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				vim.keymap.set("n", "l", api.node.open.edit, opts("Edit Or Open"))
				vim.keymap.set("n", "o", api.node.open.edit, opts("Edit Or Open"))
				vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Edit Or Open"))
				vim.keymap.set("n", "v", api.node.open.vertical, opts("Vertical split"))
				vim.keymap.set("n", "s", api.node.open.horizontal, opts("Horizontal split"))
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close"))
				vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
				vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))
				vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
				vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
				vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
				vim.keymap.set("n", "a", api.fs.create, opts("Create"))
				vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
				vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
				vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
				vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
				vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
				vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
				vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
				vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
				vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
			end,
			hijack_directories = {
				enable = false,
				auto_open = true,
			},
			update_focused_file = {
				enable = true,
				update_root = {
					enable = true,
					ignore_list = {},
				},
				exclude = false,
			},
			diagnostics = {
				enable = true,
				show_on_dirs = false,
				show_on_open_dirs = true,
				debounce_delay = 50,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
			},
			git = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
				disable_for_dirs = {},
				timeout = 400,
				cygwin_support = false,
			},
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
		})
	end,
}
