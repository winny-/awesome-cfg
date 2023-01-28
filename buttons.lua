local gears = require 'gears'
local awful = require 'awful'

local helper = require './helper'
local defaults = require './defaults'

return {
    client = gears.table.join(
        awful.button({ }, 1, function (c) helper.maybefocus(c); c:raise() end),
        awful.button({ defaults.modkey }, 1, awful.mouse.client.move),
        awful.button({ defaults.modkey }, 3, awful.mouse.client.resize)),
    global = gears.table.join(
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)),
    make_titlebar = function(c)
        return gears.table.join(
            awful.button({ }, 1, function()
                    helper.maybefocus(c)
                    c:raise()
                    awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                    helper.maybefocus(c)
                    c:raise()
                    awful.mouse.client.resize(c)
            end))
    end
}
