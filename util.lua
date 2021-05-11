local awful = require 'awful'

return {
    gettagdwim=function()
        return client.focus and client.focus.first_tag or awful.screen.focused().selected_tags[1]
    end,
    minutes2hm=function(minutes)
        local m = math.floor(minutes % 60)
        local h = math.floor(minutes / 60)
        local s = string.format('%sh', h)
        if m == 0 then          -- no minutes. hide minutes.
            return s
        end
        if h == 0 then          -- no hours but there are minutes; hide hours.
            s = ''
        end
        return s .. string.format('%sm', m)
    end,
}
