
function run_moveup()
    turtle.up()
end

function run_movedown()
    turtle.down()
end

function run_digmelon()
    turtle.dig()
    turtle.turnRight()

    turtle.dig()
    turtle.turnRight()

    turtle.dig()
    turtle.turnRight()

    turtle.dig()
    turtle.turnRight()
end

function run_dropitem()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.getItemCount() ~= 0 then
            turtle.dropDown()
        end
    end
end

while true do
    for i = 1, 6 do
        run_moveup()
        run_moveup()
        run_moveup()
        run_digmelon()
    end
    sleep(120)
    for i = 1, 6 do
        run_movedown()
        run_movedown()
        run_movedown()
        run_digmelon()
    end
    run_dropitem()
    sleep(120)
end
