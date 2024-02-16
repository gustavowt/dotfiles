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
lvim.format_on_save.enabled = true
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
  "markdown",
  "markdown_inline"
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

-- Solargraph
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "solargraph" })
-- remove `ruby_ls` from `skipped_servers` list
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "ruby_ls"
end, lvim.lsp.automatic_configuration.skipped_servers)
-- local nvim_lsp = require("lspconfig")

-- nvim_lsp.solargraph.setup {
--   cmd = { "solargraph", "stdio" },
--   filetypes = { "ruby", "rakefile" },
--   root_dir = nvim_lsp.util.root_pattern("Gemfile", ".git", "."),
--   on_attach = require("lsp-format").on_attach,
--   settings = {
--     solargraph = {
--       autoformat = false,
--       completion = true,
--       diagnostic = true,
--       folding = false,
--       references = true,
--       rename = true,
--       symbols = true
--     }
--   }
-- }

-- Ruby-lsp
_timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

require("lspconfig").ruby_ls.setup({
  on_attach = function(client, buffer)
    setup_diagnostics(client, buffer)
  end,
  init_options = {
    formatter = 'rubocop'
  },
})

-- Obsidian
vim.opt.conceallevel = 1

-- Additional Plugins
lvim.plugins = {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "ATON",
          path = "~/Dropbox/obsidian/vaults/aton",
        },
        {
          name = "personal",
          path = "~/Dropbox/obsidian/vaults/personal",
        },
        {
          name = "work",
          path = "~/Dropbox/obsidian/vaults/work",
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
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
    dependencies = {
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

-- Copilot config

local ok, copilot = pcall(require, "copilot")
if not ok then
  return
end

copilot.setup {
  suggestion = {
    keymap = {
      accept = "<c-l>",
      next = "<c-j>",
      prev = "<c-k>",
      dismiss = "<c-h>",
    },
  },
}

lvim.builtin.which_key.mappings["C"] = { "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", "Copilot" }
