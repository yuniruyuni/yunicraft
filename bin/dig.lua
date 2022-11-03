local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

if not(#arg == 3) then
    print("usage: bin/dig <width> <depth> <height>")
    print("The turtle digs up until next upper cell was empty if you specify height 0")
    return
end

local width = tonumber(arg[1])
local depth = tonumber(arg[2])
local height = tonumber(arg[3])

local torch_freq = 5

for x = 0, width-1 do
    local torch_x = ((x % torch_freq) == 0)
    for z = 0, depth-1 do
        move.ensureForward()
        if height == 0 then
            move.down(dig.upAll())
        else
            move.down(dig.up(height))
        end
    end

    for z = 0, depth-1 do
        move.ensureBack()
        local torch_z = ((z % torch_freq) == 0)
        if torch_x and torch_z then
            item.place(item.TORCH)
        end
    end

    turtle.turnRight()
    move.ensureForward()
    turtle.turnLeft()
end
