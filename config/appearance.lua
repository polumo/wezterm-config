local wezterm = require("wezterm")
local gpu_adapters = require("utils.gpu_adapter")
local colors = require("colors.custom")

return {
	max_fps = 144,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	webgpu_preferred_adapter = gpu_adapters:pick_best(),

	-- cursor
	animation_fps = 144,
	cursor_blink_ease_in = "Linear",
	cursor_blink_ease_out = "Linear",
	default_cursor_style = "BlinkingBar",

	-- color scheme
	colors = colors,

	-- background
	background = {
		{
			source = { File = wezterm.GLOBAL.background },
			horizontal_align = "Center",
		},
		{
			source = { Color = colors.background },
			height = "100%",
			width = "100%",
			opacity = 0.96,
		},
	},

	-- scrollbar
	enable_scroll_bar = false,

	-- tab bar
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = false,
	tab_max_width = 25,
	show_tab_index_in_tab_bar = true,
	switch_to_last_active_tab_when_closing_tab = true,

	-- window
	window_decorations = "INTEGRATED_BUTTONS | RESIZE",
	-- window_padding = {
	-- 	left = 0,
	-- 	right = 0,
	-- 	top = 10,
	-- 	bottom = 5,
	-- },
	window_close_confirmation = "NeverPrompt",
	window_frame = {
		active_titlebar_bg = "#090909",
		-- font = fonts.font,
		-- font_size = fonts.font_size,
	},
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.65,
	},
}
