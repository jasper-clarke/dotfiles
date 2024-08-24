local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local widgets = require("ui.widgets")
local naughty = require("naughty")

--- Mic Widget
--- ~~~~~~~~~~~~~~~~~

local function button(icon)
	return widgets.button.text.state({
		forced_width = dpi(60),
		forced_height = dpi(60),
		normal_bg = beautiful.one_bg3,
		normal_shape = gears.shape.circle,
		on_normal_bg = beautiful.accent,
		text_normal_bg = beautiful.accent,
		text_on_normal_bg = beautiful.one_bg3,
		font = beautiful.icon_font .. "Round ",
		size = 17,
		text = icon,
	})
end

local widget = button("")

local update_widget = function()
	awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_SOURCE@ | awk '{ print $3 }' | sed -e 's/^[ \t]*//'", function(stdout, stderr, exitreason, exitcode)
		if string.match(stdout, "[MUTED]") then
			widget:turn_on()
		else
			widget:turn_off()
		end
	end)
end

local update_startup = function()
	awful.spawn.with_shell("wpctl set-mute @DEFAULT_SOURCE@ 0")
	widget:turn_off()
end

update_startup()

awesome.connect_signal("mic_button::toggle", function()
	update_widget()
end)

--- buttons
widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
	awful.spawn.easy_async_with_shell("wpctl inspect @DEFAULT_SOURCE@", function(stdout, stderr, exitreason, exitcode)
		if string.match(stdout, "Audio/Source") then
			awful.spawn.with_shell("wpctl set-mute @DEFAULT_SOURCE@ toggle")
			widget:turn_off()
		else
			naughty.notify({
				app_name = "System",
				title = "Notice",
				text = "No Microphone Found to be toggled",
			})
		end
	end)
	gears.timer({
		timeout = 0.1,
		autostart = true,
		single_shot = true,
		callback = function()
			update_widget()
		end
	})
end)))

return widget
