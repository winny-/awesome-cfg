local gears = require 'gears'
local awful = require 'awful'
local modalbind = require './modalbind'
local actions = require './actions'



modalbind.init()

modalbind.default_keys = {
    {'separator', 'Mode Control'},
    {'Escape', modalbind.close_box, 'Close Modal'},
    {'Return', modalbind.close_box, 'Close Modal'},
}



local tagmap = {}
table.insert(tagmap, {'separator', 'Select a Tag'})
tagmap = gears.table.join(
    tagmap,
    {
        {'n', actions.nexttag, 'select next tag (by index)'},
        {'p', actions.prevtag, 'select previous tag (by index)'},
        {'l', actions.recenttag, 'focus recent tag'},
    }
)

for i = 1, 9 do
    table.insert(tagmap, {tostring(i), actions.makeselecttag(i), 'Select tag ' .. i})
end

table.insert(tagmap, {'separator', 'Toggle a Tag'})
for i = 1, 9 do
    tagmap = gears.table.join(
        tagmap,
        {
            {'F' .. i, actions.maketoggletag(i), 'Toggle tag ' .. i}
        }
    )
end



local launchmap = {
    {'c', actions.terminal, 'spawn terminal'},
    {'d', actions.dmenu, 'dmenu'},
    {'e', actions.editor, 'spawn editor'},
    {'w', actions.browser, 'spawn browser'},
    {'W', function() awful.spawn('qutebrowser -T') end, 'spawn browser (temp session)'},
    {'v', actions.mixer, 'spawn mixer'},
    {'S', actions.selectsink, 'switch pulseaudio sink'},
}



local managemap = gears.table.join({
    {'c', function() modalbind.grab {keymap=launchmap, name='Launch'} end, 'Launch Map'},
    {'separator', 'Client'},
})

for i = 1, 9 do
    managemap = gears.table.join(
        managemap,
        {
            {tostring(i), actions.makeselectclient(i), 'Focus client ' .. i},
        }
    )
end

managemap = gears.table.join(managemap, {
    {'n', actions.nextclient,'focus next (by index)'},
    {'p', actions.prevclient, 'focus previous (by index)'},
    {'N', actions.swapnextclient, 'swap next (by index)'},
    {'P', actions.swapprevclient, 'swap prev (by index)'},
    {'l', actions.recentclient, 'focus recent client'},
    {'k', actions.closeclient, 'close client'},
    {'f', actions.togglefullscreen, 'toggle fullscreen'},
    {'z', actions.minimizeclient, 'minimize'},
    {'x', actions.pushmasterclient, 'push master'},
    {'X', actions.swapmasterclient, 'swap master'},
    {'w', actions.selectclient, 'select client'},
    {'separator', 'Tag'},
    {'L', actions.recenttag, 'focus recent tag'},
    {'Left', actions.prevtag, 'focus next tag (by index)'},
    {'Right', actions.nexttag, 'focus previous tag (by index)'},
    {'g', function() modalbind.grab{keymap=tagmap, name='Manage Tags'} end, 'Manage Tags'},
    {'separator', 'Layout'},
    {'t', actions.cycletile, 'Cycle between tile layouts'},
    {'m', actions.togglemonocle, 'Toggle monocle layout'},
    {'separator', 'Screen'},
    {'o', actions.nextscreen, 'Focus next screen'},
    {'O', actions.moveclienttoscreen, 'Move client to next screen and focus the screen'},
    {'separator', 'Awesome'},
    {'\\', actions.restart, 'restart Awesome'},
})



return {
    manage=function() modalbind.grab{keymap=managemap, name='Manage Awesome',} end,
}
