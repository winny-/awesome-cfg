local suit = require 'awful.layout.suit'
local lain = require 'lain.layout'
local gears = require 'gears'

-- local dynamite = require 'dynamite'

-- local stack = dynamite {
--   name = 'stack',
--   {
--     reflow       = true,
--     max_elements = 1,
--     priority     = 2,
--     ratio        = 0.20,
--     layout       = dynamite.layout.ratio.vertical
--   },
--   {
--     priority = 1,
--     layout    = dynamite.layout.stack
--   },
--   inner_fill_strategy = 'default',
--   layout     = dynamite.layout.ratio.horizontal
-- }

-- Table of layouts to cover with awful.layout.inc, order matters.
local tiles = {
    suit.tile,
    suit.tile.bottom,
    suit.spiral.dwindle,
    suit.corner.nw,
    lain.centerwork,
}
local grids = {
    suit.fair,
    suit.fair.horizontal,
    lain.termfair,      
}
local monocle = suit.max
local floating = suit.floating
return {
    order=gears.table.join(
        {floating},
        tiles,
        grids,
        {monocle}
    ),
    tiles=tiles,
    grids=grids,
    monocle=monocle,
    floating=floating,
}
