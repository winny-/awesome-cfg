local wibox = require 'wibox'
local awful = require 'awful'
local gears = require 'gears'

local defaults = require './defaults'
local helper = require './helper'

local mytextclock = wibox.widget.textclock('<span font_weight="normal">%a %b %d <b>%T</b></span>' ,1)
local mycalendar = awful.widget.calendar_popup.month()
mycalendar:attach(mytextclock, 'tr', {on_hover=false})

local myloadavg = awful.widget.watch("cut -f1-3 -d' ' < /proc/loadavg", 1)

-- XXX figure out why
-- df -h --output=avail / | awk 'END { printf(\"%s\", $1); }'
-- does not work
local mydf = awful.widget.watch("rootdf", 5) 


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
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, {tasklist_disable_icon=false})

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
                    wibox.widget.textbox(' '),
                    mydf,
                    wibox.widget.textbox(' | '),
                    myloadavg,
                    wibox.widget.textbox(' | '),
                    mytextclock,
                    wibox.widget.textbox(' '),
                    wibox.widget.systray(),
                    
                },
            },
        }
    end
}
