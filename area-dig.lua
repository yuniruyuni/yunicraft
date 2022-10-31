require("dig")
require("item")

local width = 10
local depth = 10
local height = 5
local torch_freq = 5

for x = 1, width do
    local torch_x = (x % torch_freq) == 0
    for z = 1, depth do
        turtle.dig("left")
        turtle.forward()
        digup(height)
    end

    for z = 1, depth do
        turtle.back()
        local torch_z = (z % torch_freq) == 0
        if tourch_x and tourch_z then
            place_item(TORCH)
        end
    end

    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
end