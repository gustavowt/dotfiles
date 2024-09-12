return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 200
	end,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	vopts = {
		mode = "v", -- VISUAL mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = true, -- use `nowait` when creating keymaps
	},
	-- keys = {
	-- 	{ "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
	-- 	{ "<leader>P", "<cmd>Copilot panel<CR>", desc = "Copilot panel" },
	-- 	{ "<leader>b", group = "Buffers" },
	-- 	{ "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close" },
	-- 	{ "<leader>bf", "<cmd>Telescope buffers previewer=false<cr>", desc = "Find" },
	-- 	{ "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
	-- 	{ "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
	-- 	{ "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
	-- 	{ "<leader>c", "<cmd>lua require 'commands'.buf_kill('bd')<CR>", desc = "Close Buffer" },
	-- 	{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },
	-- 	{ "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
	-- 	{ "<leader>gb", "<cmd>:Gitsigns toggle_current_line_blame<CR>", desc = "Blame" },
	-- 	{ "<leader>gp", "<cmd>:Gitsigns preview_hunk<CR>", desc = "Preview" },
	-- 	{ "<leader>gu", "<cmd>:Git push origin HEAD<CR>", desc = "Push HEAD" },
	-- 	{ "<leader>l", group = "LSP" },
	-- 	{ "<leader>lI", "<cmd>Mason<cr>", desc = "Mason Info" },
	-- 	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
	-- 	{ "<leader>ld", "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", desc = "Buffer Diagnostics" },
	-- 	{ "<leader>lf", "<cmd>lua require('commands').lsp_format()<cr>", desc = "Format" },
	-- 	{ "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
	-- 	{ "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
	-- 	{ "<leader>lr", "<cmd>lua vim.lsp.buf.references()", desc = "References" },
	-- 	{ "<leader>lw", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
	-- 	{ "<leader>p", group = "Plugins" },
	-- 	{ "<leader>pS", "<cmd>Lazy clear<cr>", desc = "Status" },
	-- 	{ "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
	-- 	{ "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },
	-- 	{ "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
	-- 	{ "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
	-- 	{ "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
	-- 	{ "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
	-- 	{ "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
	-- 	{ "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
	-- 	{ "<leader>s", group = "Search" },
	-- 	{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
	-- 	{ "<leader>sF", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
	-- 	{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Find highlight groups" },
	-- 	{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
	-- 	{ "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
	-- 	{ "<leader>sY", "<cmd>Telescope frecency<cr>", desc = "Frecency algorithm" },
	-- 	{ "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
	-- 	{ "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
	-- 	{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find File" },
	-- 	{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
	-- 	{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
	-- 	{ "<leader>sl", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
	-- 	{
	-- 		"<leader>sp",
	-- 		"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
	-- 		desc = "Colorscheme with Preview",
	-- 	},
	-- 	{ "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
	-- 	{ "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Text" },
	-- 	{ "<leader>t", group = "Test" },
	-- 	{ "<leader>tf", "<cmd>TestFile<CR>", desc = "File" },
	-- 	{ "<leader>tl", "<cmd>TestLast<CR>", desc = "Last" },
	-- 	{ "<leader>tn", "<cmd>TestNearest<CR>", desc = "Nearest" },
	-- 	{ "<leader>ts", "<cmd>TestSuite<CR>", desc = "Suite" },
	-- 	{ "<leader>tv", "<cmd>TestVisit<CR>", desc = "Visit" },
	-- 	{ "<leader>w", "<cmd>w!<CR>", desc = "Save" },
	-- 	{
	-- 		"<leader>/",
	-- 		"<Plug>(comment_toggle_linewise_visual)",
	-- 		desc = "Comment toggle linewise (visual)",
	-- 		mode = "v",
	-- 	},
	-- 	{ "<leader>g", group = "Git", mode = "v" },
	-- 	{ "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk", mode = "v" },
	-- 	{ "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk", mode = "v" },
	-- 	{ "<leader>l", group = "LSP", mode = "v" },
	-- 	{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", mode = "v" },
	-- },
}
