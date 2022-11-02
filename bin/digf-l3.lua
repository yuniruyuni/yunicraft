local moves = 5
for i = 0, moves do
    turtle.dig()
    turtle.turnLeft()
    turtle.dig()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
end

for i = 0, moves do
    turtle.back()
end
