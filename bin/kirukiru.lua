local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

local width = 9
local depth = 29

local torch_freq = 4

local sapling = "minecraft:birch_sapling"
local leaves = "minecraft:birch_leaves"

local function upAll()
    local moved = 0
    while true do
        local found, inspected = turtle.inspectUp()
        if (not found) or (inspected.name == "minecraft:birch_leaves") then
            break
        end

        moved = moved + 1
        turtle.digUp()
        turtle.up()
    end

    return moved
end

while true do
    for x = 1, width, 4 do
        -- 該当の位置まで移動
        turtle.turnRight()
        move.forward(x-1)
        turtle.turnLeft()

        local torch_x = ((x % torch_freq) == 1)
        for z = 1, depth do
            move.ensureForward()
            move.down(upAll())
        end

        sleep(30)

        for z = 1, depth do
            turtle.suck()
            move.ensureBack()
            local torch_z = ((z % torch_freq) == 1)
            if torch_x and torch_z then
                item.place(sapling)
            end
        end

        turtle.turnLeft()
        move.forward(x-1)
        turtle.turnLeft()

        -- アイテムを全てチェストに置く
        -- ただし苗木は例外
        for i = 1,16 do
            turtle.select(i)
            local detail = turtle.getItemDetail()
            if detail and detail.name ~= sapling then
                turtle.drop()
            end
        end

        turtle.turnRight()
        turtle.turnRight()
    end

    sleep(120)
end
