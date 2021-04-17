local wibox = require 'wibox'
local awful = require 'awful'
local gears = require 'gears'

local defaults = require './defaults'
local helper = require './helper'

local lain = require './lain'

-- See https://developer.gnome.org/pygtk/stable/pango-markup-language.html
local mytextclock = wibox.widget.textclock('<span weight="normal">%a %b %d <span weight="heavy">%H:%M</span>:%S</span>' ,1)
local mycalendar = awful.widget.calendar_popup.month()
mycalendar:attach(mytextclock, 'tr', {on_hover=false})

local myloadavg = awful.widget.watch("cut -f1-3 -d' ' < /proc/loadavg", 1)

-- XXX figure out why
-- df -h --output=avail / | awk 'END { printf(\"%s\", $1); }'
-- does not work
-- local mydf = awful.widget.watch("/home/winston/.config/awesome/bin/awesome-df", 5)
local AWESOME_DF = gears.filesystem.get_configuration_dir() .. '/bin/awesome-df'
local rootdf = awful.widget.watch(AWESOME_DF .. ' /', 5)
local homedf = awful.widget.watch(AWESOME_DF .. ' /home', 5)

-- battery infos from freedesktop upower
local mybattery = nil
local fh, emsg = io.open('/sys/class/power_supply/BAT0/uevent')
if not emsg then
    fh:close()
    mybattery = awful.widget.watch(
        { awful.util.shell, "-c", "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | sed -n '/present/,/icon-name/p'" },
        30,
        function(widget, stdout)
            local icons = {
                discharging='🔋',
                charging='⚡',
                fully='🔌',
                unknown='? ',
            }
            local bat_now = {
                present      = "N/A",
                state        = "N/A",
                warninglevel = "N/A",
                energy       = "N/A",
                energyfull   = "N/A",
                energyrate   = "N/A",
                voltage      = "N/A",
                percentage   = "N/A",
                capacity     = "N/A",
                icon         = "N/A",
            }

            for k, v in string.gmatch(stdout, '([%a]+[%a|-]+):%s*([%a|%d]+[,|%a|%d]-)') do
                if     k == "present"       then bat_now.present      = v
                elseif k == "state"         then bat_now.state        = v
                elseif k == "warning-level" then bat_now.warninglevel = v
                elseif k == "energy"        then bat_now.energy       = string.gsub(v, ",", ".") -- Wh
                elseif k == "energy-full"   then bat_now.energyfull   = string.gsub(v, ",", ".") -- Wh
                elseif k == "energy-rate"   then bat_now.energyrate   = string.gsub(v, ",", ".") -- W
                elseif k == "voltage"       then bat_now.voltage      = string.gsub(v, ",", ".") -- V
                elseif k == "percentage"    then bat_now.percentage   = tonumber(v)              -- %
                elseif k == "capacity"      then bat_now.capacity     = string.gsub(v, ",", ".") -- %
                elseif k == "icon-name"     then bat_now.icon         = v
                end
            end

            local state_icon = icons[bat_now.state]
            if not state_icon then state_icon = bat_now.state end
            local styling = "%s%s"
            if bat_now.state == 'discharging' or bat_now.state == 'unknown' then
                if bat_now.percentage <= 10 then
                    styling = "%s<span background='red' font_weight='bold' foreground='black'>%s</span>"
                elseif bat_now.percentage <= 20 then
                    styling = "%s<span background='orange' font_weight='bold' foreground='black'>%s</span>"
                end
            end
            widget:set_markup_silently(string.format(styling,
                                                     gears.string.xml_escape(state_icon),
                                                     gears.string.xml_escape(string.format("%2d%%", bat_now.percentage))))
        end
    )
end


local function only_on_primary(widget)
    return awful.widget.only_on_screen(widget, awful.screen.primary)
end

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ defaults.modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ defaults.modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
    end),
    awful.button({ }, 3, helper.client_menu_toggle_fn()),
    awful.button({ }, 4, function ()
            awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
            awful.client.focus.byidx(-1)
end))

return {
    main = function(s)
        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
                                  awful.button({ }, 1, function () awful.layout.inc( 1) end),
                                  awful.button({ }, 3, function () awful.layout.inc(-1) end),
                                  awful.button({ }, 4, function () awful.layout.inc( 1) end),
                                  awful.button({ }, 5, function () awful.layout.inc(-1) end)))
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
            style = {
                tasklist_disable_icon = false
            },
            layout = {
                spacing_widget = {
                    color = '#555',
                    widget = wibox.widget.separator
                },
                spacing = 1,
                layout = wibox.layout.flex.horizontal
            }
        }

        -- Create the wibox
        s.mywibox = awful.wibar({ position = "top", screen = s })

        -- Add widgets to the wibox
        s.mywibox:setup {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                s.mytaglist,
                layout = wibox.layout.fixed.horizontal,
                s.mylayoutbox,
                s.mypromptbox,
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = awful.widget.only_on_screen,
                screen = 'primary',
                {
                    layout = wibox.layout.fixed.horizontal,
                    gears.table.join({
                            layout = wibox.layout.fixed.horizontal,
                            spacing = 20,
                            rootdf,
                            homedf,
                            myloadavg,
                                     },
                        mybattery and {mybattery},
                        {
                            mytextclock,
                            wibox.widget.systray(),
                    }),

                },
            },
        }
    end
}
