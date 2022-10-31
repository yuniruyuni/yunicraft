require("dig")

local moves = tonumber(arg[1])

for i = 1, moves do
    turtle.dig("left")
    turtle.forward()
    digup_all()
    turtle.turnLeft()
    turtle.dig("left")
    turtle.forward()
    digup_all()
    turtle.turnRight()
    turtle.turnRight()
    turtle.forward()
    turtle.dig("left")
    turtle.forward()
    digup_all()
    turtle.back()
    turtle.turnLeft()
end

for i = 1, moves do
    turtle.back()
end
