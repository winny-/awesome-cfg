local beautiful = require('beautiful')
local awful = require('awful')
local keys = require './keys'
local buttons = require './buttons'

-- Rules to apply to new clients (through the "manage" signal).
local default_rule = {
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = keys.client,
        buttons = buttons.client,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        size_hints_honor=false,
    },
}

-- Floating clients.
local floats = {
    rule_any = {
        instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
        },
        class = {
            "Arandr",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm.
            "Wpa_gui",
            "pinentry",
            "veromix",
            "xtightvncviewer",
        },
        name = {
            "Event Tester",  -- xev.
        },
        role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = {
        floating = true,
    },
}

return {
    default_rule,
    floats,

    { rule_any = { class = { "Steam" }},
      properties = { tag = "9" }},

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = true },
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
