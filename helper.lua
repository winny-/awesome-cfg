local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'

return {
    client_menu_toggle_fn = function()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ theme = { width = 250 } })
            end
        end
    end,
    set_wallpaper = function(s)
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end,
    manage_titlebar=function(c)
        if c.floating and not c.requests_no_titlebar then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end,
}
