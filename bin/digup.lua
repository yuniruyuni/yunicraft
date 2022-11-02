local moves = 10

for i = 0, moves do
    turtle.digUp("left")
    turtle.up()
end

for i = 0, moves do
    turtle.down()
end
