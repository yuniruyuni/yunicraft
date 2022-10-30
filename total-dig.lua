requie("dig")

local moves = 5

for i = 0, moves do
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

for i = 0, moves do
    turtle.back()
end
