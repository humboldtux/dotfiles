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
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{ key = "t", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{
			key = "o",
			mods = "LEADER",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "v",
			mods = "LEADER",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "f", mods = "LEADER", action = wezterm.action({ Search = { CaseSensitiveString = "" } }) },
		{ key = "-", mods = "LEADER", action = "DecreaseFontSize" },
		{ key = "_", mods = "LEADER", action = "IncreaseFontSize" },
		{ key = "=", mods = "LEADER", action = "ResetFontSize" },
		{ key = "w", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "PageUp", mods = "SHIFT", action = wezterm.action({ ScrollByPage = -1 }) },
		{ key = "PageDown", mods = "SHIFT", action = wezterm.action({ ScrollByPage = 1 }) },
		{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }),
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }),
		},
		{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
		{
			key = "DownArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }),
		},
	},
}
