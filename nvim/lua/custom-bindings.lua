vim.keymap.set("n", "<S-l>", "<Cmd>bnext<CR>", {})
vim.keymap.set("n", "<S-h>", "<Cmd>bprevious<CR>", {})

-- LSP
vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", {})
vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", {})
vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<cr>", {})
vim.keymap.set("n", "gI", "<Cmd>lua vim.lsp.buf.implementation()<cr>", {})
vim.keymap.set("n", "gs", "<Cmd>lua vim.lsp.buf.signature_help()<cr>", {})

-- NvimTree
vim.keymap.set("n", "F", "<Cmd>:NvimTreeFindFile<CR>", {})

