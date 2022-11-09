local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

if not(#arg == 3) then
    print("usage: bin/dig-down <width> <depth> <height>")
    print("The turtle digs down until next lower cell was empty if you specify height 0")
    return
end

local width = tonumber(arg[1])
local depth = tonumber(arg[2])
local height = tonumber(arg[3])
local torch_freq = 5

function shouldPutTorch(x, z)
    return ((x % torch_freq) == 1) and ((z % torch_freq) == 1)
end

function putTorch()
    item.placeDown(item.TORCH)
end

for x = 1, width do
    for z = 1, depth do
        move.ensureForward()
        local moved = 0
        if height == 0 then
            moved = dig.downAll()
        else
            dig.down(height)
            moved = height
        end

        move.up(1)
        if shouldPutTorch(x, z) then
            putTorch()
        end
        move.up(moved-1)
    end

    turtle.turnLeft()
    move.forward(x-1)
    turtle.turnLeft()
    move.forward(depth)

    -- アイテムを全てチェストに置く
    -- ただしたいまつは例外
    for i = 1,16 do
        turtle.select(i)
        local detail = turtle.getItemDetail()
        if detail and detail.name ~= item.TORCH then
            turtle.drop()
        end
    end

    if x ~= width then
        turtle.turnLeft()
        move.forward(x-1)
        move.ensureForward()
        turtle.turnLeft()
    end
end
