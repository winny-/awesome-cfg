require './error_handling'
local defaults = require './defaults'

local beautiful = require("beautiful") -- Theme handling library
beautiful.init(defaults.theme)

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local menubar = require("menubar")

local keys = require './keys'
local buttons = require './buttons'
local signals = require './signals'
local helper = require './helper'

local bar = require './bar'

awful.layout.layouts = require('./layouts').order
awful.rules.rules = require './rules'

awful.screen.connect_for_each_screen(helper.set_wallpaper) -- Set wallpaper on each screen
awful.screen.connect_for_each_screen(function(s) -- set up tags on each screen
        awful.tag(defaults.tags, s, defaults.layout)
end)
awful.screen.connect_for_each_screen(bar.main) -- set up a bar on each screen

-- Set the terminal for applications that require it
menubar.utils.terminal = defaults.terminal

root.keys(keys.global)
root.buttons(buttons.global)

signals.connect()

local wallpaper = beautiful.get().wallpaper
if wallpaper then
    gears.wallpaper.maximized(wallpaper)
else
    gears.wallpaper.set('#111111') -- Fallback
end
