local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local brightness = require(... .. "./brightness")
local volume = require(... .. "./volume")
local mic = require(... .. "./mic")

local sliders = {
	brightness,
	volume,
	mic,
}

return wibox.widget({
	{
		{
			{
				-- sliders[1],
				sliders[2],
				sliders[3],
				spacing = dpi(12),
				layout = wibox.layout.fixed.vertical,
			},
			margins = { top = dpi(12), bottom = dpi(12), left = dpi(18), right = dpi(12) },
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		forced_height = dpi(180),
		forced_width = dpi(350),
		bg = beautiful.widget_bg,
		shape = helpers.ui.rrect(beautiful.border_radius),
	},
	margins = dpi(10),
	color = "#FF000000",
	widget = wibox.container.margin,
})
