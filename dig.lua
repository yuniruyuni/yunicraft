function digup_all()
    local moved = 0
    while true do
        local found, _ = turtle.inspectUp()
        if not found then
            break
        end

        moved = moved + 1
        turtle.digUp("left")
        turtle.up()
    end

    for i = 1, moved do
        turtle.down()
    end
end

function digup(height)
    for i = 1, height do
        turtle.digUp("left")
        turtle.up()
    end

    for i = 1, height do
        turtle.down()
    end
end
