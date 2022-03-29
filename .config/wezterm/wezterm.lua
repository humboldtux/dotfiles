local wezterm = require("wezterm")

return {
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,

	font = wezterm.font("JetBrainsMono Nerd Font Mono"),

	color_scheme = "nord",

	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.7,
	},

	disable_default_key_bindings = true,
	-- timeout_milliseconds defaults to 1000 and can be omitted
	leader = { key = "mapped:a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "mapped:a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{ key = "mapped:t", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{
			key = "mapped:o",
			mods = "LEADER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "mapped:v",
			mods = "LEADER",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "mapped:h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "mapped:l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "mapped:j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "mapped:k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "mapped:f", mods = "LEADER", action = wezterm.action({ Search = { CaseSensitiveString = "" } }) },
		{ key = "mapped:-", mods = "LEADER", action = "DecreaseFontSize" },
		{ key = "mapped:_", mods = "LEADER", action = "IncreaseFontSize" },
		{ key = "mapped:=", mods = "LEADER", action = "ResetFontSize" },
		{ key = "mapped:w", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "mapped:z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "mapped:PageUp", mods = "SHIFT", action = wezterm.action({ ScrollByPage = -1 }) },
		{ key = "mapped:PageDown", mods = "SHIFT", action = wezterm.action({ ScrollByPage = 1 }) },
		{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "mapped:c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "mapped:v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{
			key = "mapped:LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }),
		},
		{
			key = "mapped:RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }),
		},
		{ key = "mapped:UpArrow", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
		{
			key = "mapped:DownArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }),
		},
	},
}
