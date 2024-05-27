return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = false,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  config = function()
    require("neo-tree").setup({
      follow_current_file = {
        enable = true,
        update_cwd = true,
      },
      window = {
        mappings = {
          ["<space>"] = {
            "<cmd>:Wichkey<CR>",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
          ["S"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
        },

        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
    })

    vim.keymap.set("n", "<S-f>", "<cmd>Neotree reveal_force_cwd<CR>", {})
  end,
}
