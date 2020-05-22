-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local defaults = require './defaults'
local keys = require './keys'
local buttons = require './buttons'

local signals = require './signals'

require './error_handling'

beautiful.init(defaults.theme)


awful.layout.layouts = require './layouts'
awful.rules.rules = require './rules'


menubar.utils.terminal = defaults.terminal -- Set the terminal for applications that require it

root.keys(keys.global)
root.buttons(buttons.global)


require './bar'


signals.connect()
