local awful = require 'awful'

return {
    gettagdwim=function()
        return client.focus and client.focus.first_tag or awful.screen.focused().selected_tags[1]
    end,
}
