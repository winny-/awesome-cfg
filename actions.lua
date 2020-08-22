-- common actions for keybinds and other things

local awful = require 'awful'
local gears = require 'gears'
local defaults = require './defaults'
local layouts = require './layouts'
local naughty = require 'naughty'
local util = require './util'

local function with_client(fn)
    return function()
            if client.focus then
                return fn(client.focus)
            end
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
    nextclient=function() awful.client.focus.byidx(1) end,
    prevclient=function() awful.client.focus.byidx(-1) end,
    swapnextclient=function() awful.client.swap.byidx(1) end,
    swapprevclient=function() awful.client.swap.byidx(-1) end,
    swapmasterclient=with_client(function(c) c:swap(awful.client.getmaster()) end),
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
    dmenu=function() awful.spawn(defaults.dmenu) end,
    choosewindow=function() awful.spawn('rofi -show window') end,
    restart=awesome.restart,
    quit=awesome.quit,
    increasemasterwidthfactor=function() awful.tag.incmwfact(defaults.master_width_factor_step) end,
    decreasemasterwidthfactor=function() awful.tag.incmwfact(-defaults.master_width_factor_step) end,
    closeclient=with_client(function(c) c:kill() end),
    togglefullscreen=with_client(function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
    end),
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
                        },
    selecttagfns,
    toggletagfns,
    selectclientfns)
