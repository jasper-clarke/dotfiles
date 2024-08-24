-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local awesome_dir = gears.filesystem.get_configuration_dir()
local bling = require("modules.bling")

-- Themes define colours, icons, font and wallpapers.
local theme_dir = awesome_dir .. "theme/"
beautiful.init(theme_dir .. "theme.lua")

require(".error-handling")
-- require("utils")
require("configuration")
require("ui")

beautiful.useless_gap = 15
beautiful.gap_single_client = true

awful.spawn.with_shell(awesome_dir .. "scripts/autostart.sh")

-- awful.spawn.easy_async_with_shell("wpctl inspect @DEFAULT_SOURCE@", function(stdout, stderr, exitreason, exitcode)
-- 	if string.match(stdout, "Audio/Sink") then
-- 		local notify = naughty.notify({
-- 			app_name = "System",
-- 			title = "Audio Notice",
-- 			text = "Could not find an attached Microphone",
-- 			timeout = 20,
-- 		})
-- 	end
-- end)

--- ░█▀▀░█▀█░█▀▄░█▀▄░█▀█░█▀▀░█▀▀
--- ░█░█░█▀█░█▀▄░█▀▄░█▀█░█░█░█▀▀
--- ░▀▀▀░▀░▀░▀░▀░▀▀░░▀░▀░▀▀▀░▀▀▀

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage("collect")
	end,
})
