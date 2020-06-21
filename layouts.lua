local suit = require 'awful.layout.suit'
local lain = require 'lain.layout'

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
return {
  suit.floating,
  suit.tile,
  suit.tile.bottom,
  suit.fair,
  suit.fair.horizontal,
  suit.spiral.dwindle,
  suit.max,
  suit.magnifier,
  suit.corner.nw,
  lain.centerwork,
  lain.cascade,
  lain.termfair,
--  stack,
}
