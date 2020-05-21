local suit = require 'awful.layout.suit'

-- Table of layouts to cover with awful.layout.inc, order matters.
return {
   suit.floating,
   suit.tile,
   suit.tile.left,
   suit.tile.bottom,
   suit.tile.top,
   suit.fair,
   suit.fair.horizontal,
   suit.spiral,
   suit.spiral.dwindle,
   suit.max,
   suit.max.fullscreen,
   suit.magnifier,
   suit.corner.nw,
   -- suit.corner.ne,
   -- suit.corner.sw,
   -- suit.corner.se,
}
