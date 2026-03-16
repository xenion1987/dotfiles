-- Pull in the wezterm API and build the config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Fonts & Look
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
config.color_scheme = "DimmedMonokai"
config.font = wezterm.font("MesloLGS NF")
config.font_size = 14

config.keys = {
	{
		key = "d",
		mods = "SUPER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "SUPER|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "Enter",
		mods = "CTRL|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
}
for i = 1, 9 do
	-- ALT + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[\b([A-Z]{3,}-\d{1,4})\b]],
-- 	format = "https://COMPANY.atlassian.com/browse/$1",
-- })

-- -- START MacOS fix: broken OPT key mappings
-- config.keys = config.keys or {}
-- config.send_composed_key_when_left_alt_is_pressed = true
-- config.send_composed_key_when_right_alt_is_pressed = true
-- for _, k in ipairs({ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }) do
--         table.insert(config.keys, { key = k, mods = "ALT", action = wezterm.action.DisableDefaultAssignment })
-- end
-- -- END MacOS fix: broken OPT key mappings

return config
