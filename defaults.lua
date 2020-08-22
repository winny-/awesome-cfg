local gears = require 'gears'
local layouts = require './layouts'

return {
    editor = os.getenv('EDITOR') or 'emacsclient -c',
    terminal = 'wxfce4-terminal',
    mixer = 'pavucontrol',
    browser = 'qutebrowser',
    editor = 'emacsclient -c',
    dmenu = 'rofi -show run -modi run,drun,window',
    modkey = 'Mod4',
    theme = gears.filesystem.get_configuration_dir() .. 'my_theme/theme.lua',
    layout = layouts.order[2],
    tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    master_width_factor_step = 0.05,
    gap = 5,
    gap_step = 2,
}
