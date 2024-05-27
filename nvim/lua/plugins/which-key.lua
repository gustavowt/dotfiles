return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 0
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  vopts = {
    mode = "v",       -- VISUAL mode
    prefix = "<leader>",
    buffer = nil,     -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,    -- use `silent` when creating keymaps
    noremap = true,   -- use `noremap` when creating keymaps
    nowait = true,    -- use `nowait` when creating keymaps
  },
  -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
  -- see https://neovim.io/doc/user/map.html#:map-cmd
  vmappings = {
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
  },
}
