local gears = require 'gears'
local layouts = require './layouts'

return {
    editor = os.getenv('EDITOR') or 'emacsclient -c',
    terminal = 'wxfce4-terminal',
    modkey = 'Mod4',
    theme = gears.filesystem.get_configuration_dir() .. 'my_theme/theme.lua',
    layout = layouts[2],
}
