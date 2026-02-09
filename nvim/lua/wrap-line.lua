-- Wrap current line at 75 characters without breaking words
local function wrap_line_75()
	local line = vim.api.nvim_get_current_line()
	local result = vim.fn.system("fold -s -w 75", line)
	-- Remove trailing newline and split into lines
	result = result:gsub("\n$", "")
	local lines = vim.split(result, "\n")
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, lines)
end

vim.keymap.set("n", "<leader>wl", wrap_line_75, { desc = "Wrap line at 75 chars" })
