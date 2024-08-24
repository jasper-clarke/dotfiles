-- Standard awesome library
local awful = require("awful")

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
  })
end)

screen.connect_signal("request::desktop_decoration", function(s)
  -- Each screen has its own tag table.

  if s.index == 1 then
    awful.tag({ "1", "2", "3" }, screen[1], awful.layout.layouts[3])
  elseif s.index == 2 then
    awful.tag({ "1", "2", "3" }, screen[2], awful.layout.layouts[2])
  elseif s.index == 3 then
    awful.tag({ "1", "2", "3" }, screen[3], awful.layout.layouts[2])
  end
end)
