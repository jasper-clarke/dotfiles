-- Standard awesome library
local awful = require("awful")
-- Declarative object management
local ruled = require("ruled")

local helpers = require("helpers")

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			raise = true,
			size_hints_honor = false,
			honor_workarea = true,
			honor_padding = true,
			-- screen = awful.screen.preferred,
			titlebars_enabled = false,
			screen = awful.screen.focused,
			focus = awful.client.focus.filter,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	-- Clipboard
	ruled.client.append_rule({
		id = "clipboard",
		rule_any = {
			class = {
				"clipboard",
			},
		},
		properties = {
			floating = true,
			placement = helpers.client.centered_client_placement,
			width = 1100,
			height = 1100,
		},
	})

	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			class = {
				"clipboard",
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	})
	-- }
end)
-- }}}

-- {{{ Notifications

ruled.notification.connect_signal("request::rules", function()
	-- All notifications will match this rule.
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end)
