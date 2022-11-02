local dig = require("lib/dig")

local moves = tonumber(arg[1])

for i = 1, moves do
    turtle.dig()
    turtle.forward()
    dig.up_all()
    turtle.turnLeft()
    turtle.dig()
    turtle.forward()
    dig.up_all()
    turtle.turnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.dig()
    turtle.forward()
    dig.up_all()
    turtle.back()
    turtle.turnLeft()
end

for i = 1, moves do
    turtle.back()
end
