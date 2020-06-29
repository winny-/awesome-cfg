-- common actions for keybinds and other things

local awful = require 'awful'
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

return {
    nextclient=function() awful.client.focus.byidx(1) end,
    prevclient=function() awful.client.focus.byidx(-1) end,
    swapnextclient=function() awful.client.swap.byidx(1) end,
    swapprevclient=function() awful.client.swap.byidx(-1) end,
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
    terminal=function() awful.spawn(defaults.terminal) end,
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
}
