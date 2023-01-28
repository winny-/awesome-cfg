local gears = require 'gears'
local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'

local buttons = require './buttons'
local helper = require './helper'
local layouts = require './layouts'

local callbacks = {
    manage_cb = function (c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and
            not c.size_hints.user_position
        and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end,
    request_titlebars_cb = function(c)
        -- buttons for the titlebar
        local buttons = buttons.make_titlebar(c)

        awful.titlebar(c) : setup {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
                                  }
    end,
    mouse_enter_cb = function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier then
            helper.maybefocus(c)
        end
    end,
    focus_cb = function(c)
        c.border_color = beautiful.border_focus
    end,
    unfocus_cb = function(c)
        c.border_color = beautiful.border_normal
    end,
}

local function connect()
    -- Signal function to execute when a new client appears.
    client.connect_signal('manage', callbacks.manage_cb)

    -- Add a titlebar if titlebars_enabled is set to true in the rules.
    client.connect_signal("request::titlebars", callbacks.request_titlebars_cb)
    -- And ensure floating clients get the titlebar
    client.connect_signal('property::floating', helper.manage_titlebar)

    -- Make floaters stack on top when popped out of tile layout.  Without
    -- programs such as Qutebrowser will automatically lower themself below
    -- other clients.
    client.connect_signal(
        'property::floating',
        function(c)
            local ft = c.first_tag
            if ft ~= nil and ft.layout ~= layouts.floating then
                c:raise()
            end
        end
    )

    -- And ensure floating tags get the titlebar
    awful.tag.attached_connect_signal(
        nil,
        "property::layout",
        function (t)
            local float = t.layout.name == "floating"
            for _,c in pairs(t:clients()) do
                c.floating = float
            end
        end
    )

    -- Enable sloppy focus, so that focus follows mouse.
    client.connect_signal("mouse::enter", callbacks.mouse_enter_cb)

    -- Indicate focused frame
    client.connect_signal("focus", callbacks.focus_cb)
    client.connect_signal("unfocus", callbacks.unfocus_cb)

    -- Re-set wallpaper when a screen's geometry changes
    screen.connect_signal('property::geometry', helper.set_wallpaper)
end

return gears.table.join(callbacks, {connect = connect})
