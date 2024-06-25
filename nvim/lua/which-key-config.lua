local wk = require("which-key")

-- register visual mappings
wk.register({
	["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
	},
	g = {
		name = "Git",
		r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
		s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
	},
}, { mode = "v", prefix = "<leader>" })

wk.register({
	["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
	["w"] = { "<cmd>w!<CR>", "Save" },
	["q"] = { "<cmd>confirm q<CR>", "Quit" },
	["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
	["c"] = { "<cmd>lua require 'commands'.buf_kill('bd')<CR>", "Close Buffer" },
	["f"] = { "<cmd>Telescope find_files<CR>", "Find files" },
	b = {
		name = "Buffers",
		j = { "<cmd>BufferLinePick<cr>", "Jump" },
		f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
		e = {
			"<cmd>BufferLinePickClose<cr>",
			"Pick which buffer to close",
		},
		h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		l = {
			"<cmd>BufferLineCloseRight<cr>",
			"Close all to the right",
		},
	},
	p = {
		name = "Plugins",
		i = { "<cmd>Lazy install<cr>", "Install" },
		s = { "<cmd>Lazy sync<cr>", "Sync" },
		S = { "<cmd>Lazy clear<cr>", "Status" },
		c = { "<cmd>Lazy clean<cr>", "Clean" },
		u = { "<cmd>Lazy update<cr>", "Update" },
		p = { "<cmd>Lazy profile<cr>", "Profile" },
		l = { "<cmd>Lazy log<cr>", "Log" },
		d = { "<cmd>Lazy debug<cr>", "Debug" },
	},
	l = {
		name = "LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
		w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
		f = { "<cmd>lua require('commands').lsp_format()<cr>", "Format" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>Mason<cr>", "Mason Info" },
		r = { "<cmd>lua vim.lsp.buf.references()", "References" },
		j = {
			"<cmd>lua vim.diagnostic.goto_next()<cr>",
			"Next Diagnostic",
		},
	},
	t = {
		name = "Test",
		n = { "<cmd>TestNearest<CR>", "Nearest" },
		f = { "<cmd>TestFile<CR>", "File" },
		s = { "<cmd>TestSuite<CR>", "Suite" },
		l = { "<cmd>TestLast<CR>", "Last" },
		v = { "<cmd>TestVisit<CR>", "Visit" },
	},
	g = {
		p = { "<cmd>:Gitsigns preview_hunk<CR>", "Preview" },
		b = { "<cmd>:Gitsigns toggle_current_line_blame<CR>", "Blame" },
		u = { "<cmd>:Git push origin HEAD<CR>", "Push HEAD" },
	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		l = { "<cmd>Telescope resume<cr>", "Resume last search" },
		p = {
			"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
			"Colorscheme with Preview",
		},
	},
}, { prefix = "<leader>" })
