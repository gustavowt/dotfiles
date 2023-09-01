--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "kanagawa"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":bprevious<CR>"
lvim.keys.normal_mode["<S-F>"] = ":NvimTreeFocus<CR>"
lvim.builtin.which_key.mappings["F"] = { "<cmd>Telescope buffers<CR>", "Buffers" }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "ruby",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

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
local nvim_lsp = require("lspconfig")

nvim_lsp.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby", "rakefile" },
  root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
  on_attach = require("lsp-format").on_attach,
  settings = {
    solargraph = {
      autoformat = true,
      completion = true,
      diagnostic = true,
      folding = true,
      references = true,
      rename = true,
      symbols = true
    }
  }
}

-- Additional Plugins
lvim.plugins = {
  {
    'christoomey/vim-tmux-navigator'
  },
  {
    "lukas-reineke/lsp-format.nvim",
    config = function()
      require("lsp-format").setup()
    end,
  },
  { "rebelot/kanagawa.nvim" },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  { "oberblastmeister/neuron.nvim" },
  {
    "anuvyklack/windows.nvim",
    requires = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim"
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    end
  }
}

require 'luasnip'.filetype_extend("ruby", { "rails" })
