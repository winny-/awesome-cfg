local setmetatable = setmetatable
local textbox = require("wibox.widget.textbox")
local timer = require("gears.timer")
local spawn = require("awful.spawn")

local watch = { mt = {} }

function watch.new(callback, timeout, base_widget)
    timeout = timeout or 5
    base_widget = base_widget or textbox()
    local t = timer { timeout = timeout }
    t:connect_signal("timeout", function()
        t:stop()
        callback(base_widget)
        t:again()
    end)
    t:start()
    t:emit_signal("timeout")
    return base_widget, t
end

function watch.mt.__call(_, ...)
    return watch.new(...)
end

return setmetatable(watch, watch.mt)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
