local moves = 5
for i = 0, moves do
    turtle.dig("left")
    turtle.turnLeft()
    turtle.dig("left")
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig("left")
    turtle.turnRight()
    turtle.dig("left")
    turtle.forward()
end

for i = 0, moves do
    turtle.back()
end
