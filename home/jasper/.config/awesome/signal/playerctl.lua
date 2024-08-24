local bling = require("modules.bling")

local playerctl = {}
local instance = nil

local function new()
	return bling.signal.playerctl.cli({
		update_on_activity = true,
		player = { "mpd" },
		debounce_delay = 1,
	})
end

if not instance then
	instance = new()
end
return instance
