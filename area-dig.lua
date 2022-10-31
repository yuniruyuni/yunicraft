require("dig")

local width = 10
local depth = 10
local height = 5

for x = 1, width do
    for z = 1, depth do
        turtle.dig("left")
        turtle.forward()
        digup(height)
    end

    for i = 1, depth do
        turtle.back()
    end

    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
end
