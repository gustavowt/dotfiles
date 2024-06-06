vim.api.nvim_create_augroup("format_on_leave", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = "format_on_leave",
  pattern = "*",
  callback = function()
    vim.lsp.buf.format()
  end,
})
