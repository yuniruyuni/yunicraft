local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

name = "minecraft:cobbled_deepslate"
height = 256

for y = 1, height do
    move.up(1)
    item.placeDown(name)
end

move.ensureForward()
move.down(height)
