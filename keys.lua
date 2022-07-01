local awful = require 'awful'
local gears = require 'gears'
local menubar = require 'menubar'
local hotkeys_popup = require("awful.hotkeys_popup").widget
local lain = require 'lain'

local defaults = require './defaults'

local actions = require './actions'

local function bind_mod(modifiers, key, cb, description, group)
  local modifiers_table = modifiers
  if type(modifiers) == 'string' then
    modifiers_table = {modifiers}
  end
  return awful.key(gears.table.join({defaults.modkey}, modifiers_table), key,
                   cb,
                   {description=description, group=group})
end
local function bind(key, cb, description, group)
  return bind_mod(nil, key, cb, description, group)
end


local globalkeys = gears.table.join(
  bind("slash", hotkeys_popup.show_help,
       'show help', 'awesome'),
  bind("Tab", actions.recenttag,
       'go back', 'tag'),
  bind('n', actions.nextclient,
       'focus next by index', 'client'),
  bind('p', actions.prevclient,
       'focus previous by index', 'client'),
  bind_mod('Shift', 'n', actions.swapnextclient,
           'swap with next client by index', 'client'),
  bind_mod('Shift', 'p', actions.swapprevclient,
           'swap with previous client by index', 'client'),
  bind('o', actions.nextscreen,
       'focus the next screen', 'screen'),
  bind('x', awful.client.urgent.jumpto,
       'jump to urgent client', 'client'),
  bind('apostrophe', actions.recentclient,
       'go back', 'client'),
  bind('Return', actions.terminal,
       'open a terminal', 'launcher'),
  bind_mod('Control', 'r', actions.restart,
           'reload awesome', 'awesome'),
  bind_mod({'Shift', 'Control'}, 'Escape', actions.quit,
    'quit awesome', 'awesome'),
  bind('f', actions.increasemasterwidthfactor,
       'increase master width factor', 'layout'),
  bind('b', actions.decreasemasterwidthfactor,
       'decrease master width factor', 'layout'),
  bind_mod('Shift', 'f', function() awful.tag.incnmaster(1, nil, true) end,
           'increase the number of master clients', 'layout'),
  bind_mod('Shift', 'b', function() awful.tag.incnmaster(-1, nil, true) end,
           'decrease the number of master clients', 'layout'),
  bind_mod('Control', 'f', function () awful.tag.incncol(1, nil, true) end,
           'increase the number of columns', 'layout'),
  bind_mod('Control', 'b', function () awful.tag.incncol(-1, nil, true) end,
           'decrease the number of columns', 'layout'),
  bind('equal', function() lain.util.useless_gaps_resize(-defaults.gap_step) end, 'increase gap size', 'tag'),
  bind('minus', function() lain.util.useless_gaps_resize(defaults.gap_step) end, 'decrease gap size', 'tag'),
  -- Standard program
  awful.key({ defaults.modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
  awful.key({ defaults.modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

  awful.key({ defaults.modkey, "Control" }, "z", actions.restorerandom,
    {description = "restore random minimized on current screen", group = "client"})

)

local clientkeys = gears.table.join(
  awful.key({ defaults.modkey,           }, 'e',
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ defaults.modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
    {description = "close", group = "client"}),
  awful.key({ defaults.modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key({ defaults.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ defaults.modkey,           }, "a",      function (c) c:move_to_screen()               end,
    {description = "move to screen", group = "client"}),
  awful.key({ defaults.modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
  awful.key({ defaults. modkey,          }, "c",      function (c) c.sticky = not c.sticky          end,
      {description = "toggle sticky", group = "client"}),
  awful.key({ defaults.modkey,           }, "z",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    {description = "minimize", group = "client"}),
  awful.key({ defaults.modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end,
    {description = "(un)maximize", group = "client"}),
  awful.key({ defaults.modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    {description = "(un)maximize vertically", group = "client"}),
  awful.key({ defaults.modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only.
    awful.key({ defaults.modkey }, "#" .. i + 9,
        actions['selecttag' .. i],
      {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ defaults.modkey, "Control" }, "#" .. i + 9,
        actions['toggletag' .. i],
      {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ defaults.modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ defaults.modkey, "Control", "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

globalkeys = gears.table.join(
  globalkeys,
  bind('0', function()
         if #awful.screen.focused().selected_tags == #awful.screen.focused().tags then
           awful.tag.history.restore()
         else
           awful.tag.viewmore(awful.screen.focused().tags, awful.screen.focused())
         end
            end,
       'toggle visibility of all tags', 'tag'),
  bind_mod('Shift', '0', function()
             if client.focus then
               if #awful.screen.focused().tags == #client.focus:tags() then
                 client.focus:move_to_tag(awful.screen.focused().selected_tag)
               else
                 for i, t in ipairs(awful.screen.focused().tags) do
                   local tagged = false
                   for j, u in ipairs(client.focus:tags()) do
                     if u == t then
                       tagged = true
                       break
                     end
                   end
                   if not tagged then
                     client.focus:toggle_tag(t)
                   end
                 end
               end
             end
                      end,
           'toggle visibility of client on all tags', 'tag')
)

for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,
    bind_mod('Mod1', tostring(i), actions.makeselectclient(i),
             string.format('Focus the %dth client', i), 'client'))
end

local modal = require './modal'

globalkeys = gears.table.join(
    globalkeys,
    awful.key({ 'Control' }, 'i', modal.manage)
)

return {
  global = globalkeys,
  client = clientkeys,
}
