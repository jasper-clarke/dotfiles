-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local user_vars = require("user_variables")

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require("helpers")

local awesome_dir = gears.filesystem.get_configuration_dir()

-- This is used later as the default terminal and editor to run.
terminal = user_vars.apps.terminal

modkey = user_vars.keys.modkey
altkey = user_vars.keys.altkey
ctrl = "Control"

-- {{{ Key bindings
awful.keyboard.append_global_keybindings({
  -- Main
  awful.key(
    { modkey },
    "s",
    hotkeys_popup.show_help,
    { description = "- Show this Help Menu", group = "Window System" }
  ),
  awful.key(
    { modkey, "Control" },
    "r",
    awesome.restart,
    { description = "- Reload System", group = "Window System" }
  ),
  awful.key(
    { modkey, "Control" },
    "q",
    awesome.quit,
    { description = "- Quit to Login Screen", group = "Window System" }
  ),
  awful.key({ modkey }, "e", function()
    awful.spawn(terminal)
  end, { description = "Open a Terminal", group = "Launchers" }),
  awful.key({ modkey }, "space", function()
    awful.spawn("rofi -show drun -theme ~/.config/rofi/launcher.rasi")
  end, { description = "Open the App Launcher", group = "Launchers" }),
  -- Focus related keybindings
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.byidx(1)
  end, { description = "- Cycle focus through windows on active screen", group = "Window Bindings" }),
  awful.key({ modkey }, "h", function()
    awful.screen.focus_bydirection("left", mouse.screen)
  end, { description = "- Focus to next Screen on the Left", group = "Screens" }),
  awful.key({ modkey }, "l", function()
    awful.screen.focus_bydirection("right", mouse.screen)
  end, { description = "- Focus to next Screen on the Right", group = "Screens" }),

  --- Resize focused client
  awful.key({ modkey, ctrl }, "k", function(c)
    if awful.screen.focused().index == 2 or awful.screen.focused().index == 3 then
      helpers.client.resize_client(c, "left")
    else
      helpers.client.resize_client(c, "up")
    end
  end, { description = "resize to the up", group = "client" }),
  awful.key({ modkey, ctrl }, "j", function(c)
    if awful.screen.focused().index == 2 or awful.screen.focused().index == 3 then
      helpers.client.resize_client(c, "right")
    else
      helpers.client.resize_client(c, "down")
    end
  end, { description = "resize to the down", group = "client" }),
  awful.key({ modkey, ctrl }, "h", function(c)
    helpers.client.resize_client(c, "left")
  end, { description = "resize to the left", group = "client" }),
  awful.key({ modkey, ctrl }, "l", function(c)
    helpers.client.resize_client(c, "right")
  end, { description = "resize to the right", group = "client" }),

  -- Tag switching bindings
  awful.key({
    modifiers = { modkey },
    keygroup = "numrow",
    description = "- Switch to Workspace (num)",
    group = "Workspaces",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  awful.key({
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "- Move active window to Workspace (num)",
    group = "Workspaces",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),

  -- Music
  awful.key({ altkey }, "h", function()
    awful.spawn.with_shell("playerctl previous")
  end, { description = "- Play previous track", group = "Media" }),
  awful.key({ altkey }, "l", function()
    awful.spawn.with_shell("playerctl next")
  end, { description = "- Play next track", group = "Media" }),
  -- awful.key({ altkey }, "space", function()
  --   awful.spawn.with_shell("playerctl play-pause")
  -- end, { description = "- Toggle Play/Pause", group = "Media" }),

  -- Utilities
  awful.key({ modkey, "Shift" }, "s", function()
    awful.spawn.with_shell("flameshot gui")
  end, { description = "- Launch Screenshot Tool", group = "Launchers" }),
  awful.key({ modkey }, "v", function()
    awful.spawn.with_shell("kitty --class clipboard -e clipse")
  end, { description = "- Launch Clipboard Manager", group = "Launchers" }),
})

function toggleMicMute()
  awful.spawn.easy_async_with_shell("wpctl inspect @DEFAULT_SOURCE@", function(stdout, stderr, exitreason, exitcode)
    if string.match(stdout, "Audio/Source") then
      awful.spawn.with_shell("wpctl set-mute @DEFAULT_SOURCE@ toggle")
      awesome.emit_signal("mic_button::toggle", awful.screen.focused())
    end
  end)
end

-- Client mousebindings
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      c:activate({ context = "mouse_click" })
    end),
    awful.button({ modkey }, 1, function(c)
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ modkey }, 3, function(c)
      c:activate({ context = "mouse_click", action = "mouse_resize" })
    end),
    awful.button({ modkey }, 4, function()
      awful.tag.incmwfact(-0.03)
    end),
    awful.button({ modkey }, 5, function()
      awful.tag.incmwfact(0.03)
    end),
  })
end)

-- Client keybindings
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    awful.key({ modkey }, "f", function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, { description = "- Toggle Fullscreen mode", group = "Window Bindings" }),

    awful.key({ modkey, "Shift" }, "h", function(c)
      c:move_to_screen(c.screen.index - 1)
    end, { description = "- Move Window to next Screen on the Left", group = "Screens" }),
    awful.key({ modkey, "Shift" }, "l", function(c)
      c:move_to_screen(c.screen.index + 1)
    end, { description = "- Move Window to next Screen on the Right", group = "Screens" }),

    awful.key({ modkey }, "q", function(c)
      c:kill()
    end, { description = "- Close active Window", group = "Window Bindings" }),
    awful.key(
      { modkey, "Control" },
      "space",
      awful.client.floating.toggle,
      { description = "- Toggle Floating Mode", group = "Window Bindings" }
    ),
  })
end)
