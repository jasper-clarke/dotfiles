local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()

return {
  --- Default Applications
  default = {
    --- Default terminal emulator
    terminal = "kitty",
    --- Default music client
    music_player = "spotify",
    --- Default text editor
    text_editor = "kitty -e nvim",
    --- Default code editor
    code_editor = "kitty -e nvim",
    --- Default web browser
    web_browser = "firefox",
    --- Default file manager
    file_manager = "yazi",
    --- Default network manager
    network_manager = "kitty -e nmtui",
    --- Default rofi global menu
    app_launcher = "rofi -show drun -theme ~/.config/rofi/launcher.rasi",
    -- Planner
    planner = "firefox",
  },

  --- List of binaries/shell scripts that will execute for a certain task
  utils = {
    --- Fullscreen screenshot
    full_screenshot = "flameshot screen",
    --- Area screenshot
    area_screenshot = "flameshot gui",
    --- Color Picker
    color_picker = "xcolor-pick",
  },
}
