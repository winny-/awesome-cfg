---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

local font_size = 11
local font_family = 'Sans Serif'

local dir = gfs.get_configuration_dir() .. 'my_theme/'

theme.dpi = dpi  -- Expose for own api consumption

theme.font          = string.format("%s %d", font_family, font_size)
theme.tasklist_font_minimized = string.format("%s Italic %d", font_family, font_size)
theme.tasklist_font_focus = theme.font

--[[
    Based off of https://colorhunt.co/palette/00000052057b892cdcbc6ff1
]]
local color0 = '#000000'
local color1 = '#52057B'
local color2 = '#892CDC'
local color3 = '#BC6FF1'
local color4 = '#EEEEEE'

theme.bg_normal     = color0
theme.bg_focus      = color2
theme.bg_urgent     = '#FF0000'
theme.bg_minimize   = '#999999'
theme.bg_systray    = color0

theme.fg_normal     = color3
theme.fg_focus      = color4
theme.fg_urgent     = color4
theme.fg_minimize   = color0

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = color0
theme.border_focus  = color3
theme.border_marked = '#00FF00'

-- For modalbind.  See ../modalbind/README.md or
-- https://github.com/crater2150/awesome-modalbind )
theme.modalbind_font = theme.font
theme.modebox_fg = theme.fg_normal
theme.modebox_bg = theme.bg_normal
theme.modebox_border = color1
theme.modebox_border_width = dpi(3)

theme.maximized_hide_border = false
theme.fullscreen_hide_border = true

-- Hotkeys
theme.hotkeys_font  = string.format("Mono 13", font_family)  -- help should be easier to read
theme.hotkeys_description_font = string.format("Sans 13", font_family)
theme.hotkeys_bg = '#111111'
theme.hotkeys_border_color = theme.hotkeys_bg
theme.hotkeys_fg = '#eeeeee'
theme.hotkeys_modifiers_fg = '#aa00aa'

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- My configs use this for mouse hover color
theme.taglist_bg_hover = color1

-- This is used in conjunction with logic in bar.lua.  This value is used for
-- the left,right margins on the button's sub-container.
theme.taglist_padding = dpi(8)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = dir.."submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = dir.."titlebar/close_normal.png"
theme.titlebar_close_button_focus  = dir.."titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = dir.."titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = dir.."titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = dir.."titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = dir.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = dir.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = dir.."titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = dir.."titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = dir.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = dir.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = dir.."titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = dir.."titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = dir.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = dir.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = dir.."titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = dir.."titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = dir.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = dir.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = dir.."titlebar/maximized_focus_active.png"

theme.wallpaper = dir.."background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = dir.."layouts/fairhw.png"
theme.layout_fairv = dir.."layouts/fairvw.png"
theme.layout_floating  = dir.."layouts/floatingw.png"
theme.layout_magnifier = dir.."layouts/magnifierw.png"
theme.layout_max = dir.."layouts/maxw.png"
theme.layout_fullscreen = dir.."layouts/fullscreenw.png"
theme.layout_tilebottom = dir.."layouts/tilebottomw.png"
theme.layout_tileleft   = dir.."layouts/tileleftw.png"
theme.layout_tile = dir.."layouts/tilew.png"
theme.layout_tiletop = dir.."layouts/tiletopw.png"
theme.layout_spiral  = dir.."layouts/spiralw.png"
theme.layout_dwindle = dir.."layouts/dwindlew.png"
theme.layout_cornernw = dir.."layouts/cornernww.png"
theme.layout_cornerne = dir.."layouts/cornernew.png"
theme.layout_cornersw = dir.."layouts/cornersww.png"
theme.layout_cornerse = dir.."layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
