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
        local wallpaper = beautiful.get().wallpaper
        if wallpaper then
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        else
            gears.wallpaper.set('#1111111', s)
        end
    end,
    manage_titlebar=function(c)
        if c.floating and not (c.requests_no_titlebar or c.fullscreen) then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end,
}
