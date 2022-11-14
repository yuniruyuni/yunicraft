local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

if not(#arg == 3) then
    print("usage: bin/dig-down <width> <depth> <height>")
    print("The turtle digs down until next lower cell was bedrock if you specify height 0")
    print("You can just specify an even value to <depth>")
    return
end

local width = tonumber(arg[1])
local depth = tonumber(arg[2])
local height = tonumber(arg[3])
local torch_freq = 5

if depth % 2 ~= 0 then
    print("You need to specify an even value to <depth>.")
    return
end

function shouldPutTorch(x, z)
    return ((x % torch_freq) == 1) and ((z % torch_freq) == 1)
end

function putTorch()
    item.placeDown(item.TORCH)
end

for x = 1, width do
    -- step with 2 because we are using digFront() for each cell.
    for z = 1, depth, 2 do
        -- move to correct x pos
        turtle.turnRight()
        move.ensureForward(x-1)
        turtle.turnLeft()

        -- move to correct z pos
        move.ensureForward(z)

        local moved = 0
        if height == 0 then
            moved = dig.downAllWithFront()
        else
            dig.downWithFront(height)
            moved = height
        end

        move.up(1)
        if shouldPutTorch(x, z) then
            putTorch()
        end
        move.up(moved-1)

        -- return to base.
        move.back(z)

        turtle.turnLeft()
        move.forward(x-1)
        turtle.turnLeft()

        -- アイテムを全てチェストに置く
        -- ただしたいまつは例外
        for i = 1,16 do
            turtle.select(i)
            local detail = turtle.getItemDetail()
            if detail and detail.name ~= item.TORCH then
                turtle.drop()
            end
        end

        -- direct to forward.
        turtle.turnLeft()
        turtle.turnLeft()
    end
end
