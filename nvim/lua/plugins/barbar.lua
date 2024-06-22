return {
	"romgrk/barbar.nvim",
	config = function()
		require("barbar").setup({
			show_buffer_close_icons = false,
			show_tab_indicators = false,
			show_tab_close_icons = false,
			show_index = true,
			auto_hide = false,
		})
	end,
}
