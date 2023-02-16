-- common actions for keybinds and other things

local awful = require 'awful'
local gears = require 'gears'
local defaults = require './defaults'
local layouts = require './layouts'
local naughty = require 'naughty'
local util = require './util'

local act = {
    spawn = function(cmd)
        return function()
            awful.spawn(cmd)
        end
    end
}

-- Decorator that ensures the fn is only called when a client is focused.
local function with_client(fn)
    return function()
        if client.focus then
            return fn(client.focus)
        end
    end
end

local function togglenotifications()
    if naughty.is_suspended() then
        naughty.resume()
    else
        naughty.suspend()
        naughty.destroy_all_notifications()
    end
end

local function makeselecttag(idx)
    return function()
        local screen = awful.screen.focused()
        local tag = screen.tags[idx]
        if tag then
            tag:view_only()
        end
    end
end

local function maketoggletag(idx)
    return function()
        local screen = awful.screen.focused()
        local tag = screen.tags[idx]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end
end

local selecttagfns = {};
for i = 1, 9 do
    selecttagfns['selecttag' .. i] = makeselecttag(i)
end

local toggletagfns = {};
for i = 1, 9 do
    toggletagfns['toggletag' .. i] = maketoggletag(i)
end

local function makeselectclient(idx)
    return function()
        local c = awful.client.visible(awful.screen.focused())[idx]
        if c then
            c:jump_to()
            c:raise()
        end
    end
end

local selectclientfns = {}
for i = 1, 9 do
    selectclientfns['selectclient' .. i] = makeselectclient(i)
end

return gears.table.join({
        togglenotifications=togglenotifications,
        nextclient=function() awful.client.focus.byidx(1) end,
        prevclient=function() awful.client.focus.byidx(-1) end,
        swapnextclient=function() awful.client.swap.byidx(1) end,
        swapprevclient=function() awful.client.swap.byidx(-1) end,
        swapmasterclient=with_client(function(c) c:swap(awful.client.getmaster()) end),
        pushmasterclient=with_client(function(c)
                if awful.client.getmaster() ~= c then
                    awful.client.setmaster(c)
                end
        end),
        minimizeclient=with_client(function(c) c.minimized = true end),
        recenttag=awful.tag.history.restore,
        nexttag=awful.tag.viewnext,
        prevtag=awful.tag.viewprev,
        recentclient=function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        nextscreen=function() awful.screen.focus_relative(1) end,
        prevscreen=function() awful.screen.focus_relative(-1) end,
        moveclienttoscreen=with_client(function(c) c:move_to_screen() end),
        terminal=function() awful.spawn(defaults.terminal) end,
        editor=function() awful.spawn(defaults.editor) end,
        browser=function() awful.spawn(defaults.browser) end,
        mixer=function() awful.spawn(defaults.mixer) end,
        selectsink=function() awful.spawn('rofi-switch-sink') end,
        bluetoothcontrol=function() awful.spawn('rofi-bluetooth-control') end,
        passwordmanager=function() awful.spawn('rofi-pass --last-used') end,
        dmenu=function() awful.spawn(defaults.dmenu) end,
        nap=act.spawn(defaults.nap),
        lock=act.spawn(defaults.lock),
        selectclient=function() awful.spawn('rofi -show window') end,
        restart=awesome.restart,
        quit=awesome.quit,
        increasemasterwidthfactor=function() awful.tag.incmwfact(defaults.master_width_factor_step) end,
        decreasemasterwidthfactor=function() awful.tag.incmwfact(-defaults.master_width_factor_step) end,
        closeclient=with_client(function(c) c:kill() end),
        togglefullscreen=with_client(function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
        end),
        togglesticky=with_client(function(c) c.sticky = not c.sticky end),
        cycletile=function()
            local tag = util.gettagdwim()
            tag.layout = layouts.tiles[1]
        end,
        togglemonocle=function()
            local tag = util.gettagdwim()
            tag.layout = layouts.monocle
        end,
        makeselecttag=makeselecttag,
        maketoggletag=maketoggletag,
        makeselectclient=makeselectclient,

        -- API doesn't appear to allow you to get a minimized client by index... So
        -- this is the best we have for now.
        restorerandom=function()
            local c = awful.client.restore(awful.screen.focused())

            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,

        unfloatall=function()
            for _, cl in ipairs(awful.screen.focused().clients) do
                cl.floating = false
            end
            naughty.notify({text="Unfloated all..."})
        end,
    },
    selecttagfns,
    toggletagfns,
    selectclientfns
)
