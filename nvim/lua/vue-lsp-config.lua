-- vue + vtsls: single-TS-server setup with vtsls prewarm for .vue-first workflow

-- Helper to get Mason packages dir (works even if NvChad sets $MASON=skip)
local function mason_packages_dir()
	local m = vim.fn.expand("$MASON")
	if m ~= "$MASON" and m ~= "" then
		return m .. "/packages"
	end
	return vim.fn.stdpath("data") .. "/mason/packages"
end

-- Path to @vue/language-server (so TS plugin is found)
local vue_language_server_path = mason_packages_dir() .. "/vue-language-server/node_modules/@vue/language-server"

-- Register the Vue TS plugin so TS features inside <script> work
local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

-- vtsls should handle JS/TS only; let vue_ls own .vue
local ts_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" }

local vtsls_settings = {
	vtsls = {
		tsserver = {
			globalPlugins = { vue_plugin },
		},
	},
}

-- ---------- Prewarm vtsls when opening .vue first ----------
-- Starts a background vtsls client for the project root if none exists yet.
local function ensure_vtsls_started_for_root(root)
	if not root or root == "" then
		return
	end
	for _, c in ipairs(vim.lsp.get_clients({ name = "vtsls" })) do
		if c.config and c.config.root_dir == root then
			return -- already running for this root
		end
	end

	-- Get vtsls default cmd from lspconfig
	local ok_cfg, cfg = pcall(function()
		return require("lspconfig.server_configurations.vtsls").default_config
	end)
	if not ok_cfg or not cfg then
		return
	end

	vim.lsp.start({
		name = "vtsls",
		cmd = cfg.cmd,
		cmd_env = cfg.cmd_env,
		root_dir = root,
		settings = vtsls_settings,
		-- Do not attach to the current .vue buffer; just start workspace client
		on_attach = function() end,
	})
end

-- Root detection helper
local function detect_root(filepath)
	local ok_util, util = pcall(require, "lspconfig.util")
	if not ok_util then
		return vim.loop.cwd()
	end
	return util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(filepath) or vim.loop.cwd()
end

-- Prewarm on .vue open
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = "*.vue",
	callback = function(args)
		local root = detect_root(args.file)
		ensure_vtsls_started_for_root(root)
	end,
})

-- ---------- Server setups ----------

if vim.lsp and vim.lsp.config then
	-- Neovim 0.11+ API
	vim.lsp.config("vtsls", {
		settings = vtsls_settings,
		filetypes = ts_filetypes,
	})

	-- No custom forwarder: vue_ls v3 forwards internally to vtsls
	vim.lsp.config("vue_ls", {
		filetypes = { "vue" },
	})

	vim.lsp.enable({ "vtsls", "vue_ls" })
else
	-- Neovim < 0.11 via nvim-lspconfig
	local lspconfig = require("lspconfig")
	lspconfig.vtsls.setup({
		settings = vtsls_settings,
		filetypes = ts_filetypes,
	})

	lspconfig.vue_ls.setup({
		filetypes = { "vue" },
	})
end
