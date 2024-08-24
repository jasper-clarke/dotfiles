local decorations = require(... .. ".decorations")
decorations.init()

local top_panel = require(... .. ".panels.top-panel")

local awful = require("awful")
awful.screen.connect_for_each_screen(function(s)
	--- Panels
	top_panel(s)
end)
