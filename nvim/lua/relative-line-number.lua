local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
augroup('LineNumberToggle', { clear = true })
autocmd(
  { "BufEnter", "InsertLeave", "FocusGained" },
  {
    pattern = "*",
    command = "set relativenumber", -- if callback, vim.api.nvim_buf_set_option(0,relativenumber,true) ?
    group = 'LineNumberToggle',
    desc = "Turn on relative line numbering when the buffer is entered.",
  }
)

autocmd(
  { "BufLeave", "InsertEnter", "FocusLost" },
  {
    pattern = "*",
    command = "set norelativenumber",
    group = 'LineNumberToggle',
    desc = "Turn off relative line numbering when the buffer is exited.",
  }
)
