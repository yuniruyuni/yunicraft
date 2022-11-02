local dig = require("dig")
require("item")

if not(#arg != 3) then
    print("usage: bin/area-dig <width> <depth> <height>")
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
        turtle.dig("left")
        turtle.forward()
        dig.up(height)
    end

    for z = 0, depth-1 do
        turtle.back()
        local torch_z = ((z % torch_freq) == 0)
        if torch_x and torch_z then
            place_item(TORCH)
        end
    end

    turtle.turnRight()
    turtle.dig("left")
    turtle.forward()
    turtle.turnLeft()
end
