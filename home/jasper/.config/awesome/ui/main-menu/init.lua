local awful = require("awful")
local menu = require("ui.widgets.menu")
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require("configuration.apps")
local focused = awful.screen.focused()

--- Beautiful right-click menu
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~

local instance = nil

local function awesome_menu()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Show Help",
			on_press = function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Restart",
			on_press = function()
				awesome.restart()
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Quit",
			on_press = function()
				awesome.quit()
			end,
		}),
	})
end

local function jw_menu()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Site",
			on_press = function()
				awful.spawn(apps.default.web_browser .. " https://jw.org", false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "WOL",
			on_press = function()
				awful.spawn(apps.default.web_browser .. " https://wol.jw.org", false)
			end,
		}),
	})
end

local function widget()
	return menu({
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Planner",
			on_press = function()
				awful.spawn.with_shell(apps.default.planner, false)
			end,
		}),
		menu.sub_menu_button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "JW",
			sub_menu = jw_menu(),
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Web Browser",
			on_press = function()
				awful.spawn(apps.default.web_browser, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "File Manager",
			on_press = function()
				awful.spawn(apps.default.file_manager, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Text Editor",
			on_press = function()
				awful.spawn(apps.default.text_editor, false)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Music Player",
			on_press = function()
				awful.spawn(apps.default.music_player, false)
			end,
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Dashboard",
			on_press = function()
				awesome.emit_signal("central_panel::toggle", focused)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Info Center",
			on_press = function()
				awesome.emit_signal("info_panel::toggle", focused)
			end,
		}),
		menu.button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "Notification Center",
			on_press = function()
				awesome.emit_signal("notification_panel::toggle", focused)
			end,
		}),
		menu.separator(),
		menu.sub_menu_button({
			icon = { icon = "", font = "Material Icons Round " },
			text = "System",
			sub_menu = awesome_menu(),
		}),
	})
end

if not instance then
	instance = widget()
end
return instance
