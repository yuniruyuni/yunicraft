local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

if #arg < 4 then
    print("usage: bin/fill <width> <depth> <height> <list of items>")
    return
end

local width = tonumber(arg[1])
local depth = tonumber(arg[2])
local height = tonumber(arg[3])
local itemNames = {}
for i = 4, #arg do
    table.insert(itemNames, arg[i])
end

move.ensureForward()
for x = 1, width do
    for z = 1, depth do
        dig.down(height)
        for i, name in ipairs(itemNames) do
            move.up(1)
            item.placeDown(name)
        end
        move.up(height - #itemNames)
        if z ~= depth then
            move.ensureForward()
        end
    end

    if x ~= width then
        if x % 2 == 1 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
        move.ensureForward()
        if x % 2 == 1 then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
    end
end
