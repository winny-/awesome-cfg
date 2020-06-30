local gears = require 'gears'
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


local managemap = {
    {'separator', 'Spawn'},
    {'c', actions.terminal, 'spawn terminal'},
    {'separator', 'Client'},
    {'n', actions.nextclient,'focus next (by index)'},
    {'p', actions.prevclient, 'focus previous (by index)'},
    {'N', actions.swapnextclient, 'swap next (by index)'},
    {'P', actions.swapprevclient, 'swap prev (by index)'},
    {'l', actions.recentclient, 'focus recent client'},
    {'k', actions.closeclient, 'close client'},
    {'z', actions.togglefullscreen, 'toggle fullscreen'},
    {'separator', 'Tag'},
    {'L', actions.recenttag, 'focus recent tag'},
    {'Left', actions.prevtag, 'focus next tag (by index)'},
    {'Right', actions.nexttag, 'focus previous tag (by index)'},
    {'g', function() modalbind.grab{keymap=tagmap, name='Manage Tags'} end, 'Manage Tags'},
    {'separator', 'Layout'},
    {'t', actions.cycletile, 'Cycle between tile layouts'},
    {'m', actions.togglemonocle, 'Toggle monocle layout'},
}

return {
    manage=function() modalbind.grab{keymap=managemap, name='Manage Awesome',} end,
}
