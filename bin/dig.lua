local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

if not(#arg == 3) then
    print("usage: bin/dig <width> <depth> <height>")
    print("The turtle digs up until next upper cell was empty if you specify height 0")
    print("The turtle digs down when you specify height < 0")
    return
end

local width = tonumber(arg[1])
local depth = tonumber(arg[2])
local height = tonumber(arg[3])

local torch_freq = 5

for x = 1, width do
    local torch_x = ((x % torch_freq) == 1)
    for z = 1, depth do
        move.ensureForward()
        if height == 0 then
            move.down(dig.upAll())
        elseif height < -1 then
            move.up(dig.down(-height))
        else
            move.down(dig.up(height))
        end
    end

    for z = 1, depth do
        move.ensureBack()
        local torch_z = ((z % torch_freq) == 1)
        if torch_x and torch_z then
            item.place(item.TORCH)
        end
    end

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

    if x ~= width then
        turtle.turnLeft()
        move.forward(x-1)
        move.ensureForward()
        turtle.turnLeft()
    end
end
