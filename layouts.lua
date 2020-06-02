local suit = require 'awful.layout.suit'
local lain = require 'lain.layout'

-- Table of layouts to cover with awful.layout.inc, order matters.
return {
   suit.floating,
   suit.tile,
   suit.tile.bottom,
   suit.fair,
   suit.fair.horizontal,
   suit.spiral,
   suit.spiral.dwindle,
   suit.max,
   suit.max.fullscreen,
   suit.magnifier,
   suit.corner.nw,
   lain.centerwork,
   lain.cascade,
   lain.termfair,
}
