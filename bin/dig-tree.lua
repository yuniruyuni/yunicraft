while true do
    turtle.place()

    -- wait tree grows
    while true do
        local found, inspected = turtle.inspect()
        if (not found) or (inspected.name == "minecraft:birch_log") then
            break
        end

        os.sleep(1)
    end

    -- start dig tree
    turtle.dig()
    turtle.forward()

    local moved = 0
    while true do
        local found, inspected = turtle.inspectUp()
        if (not found) or (inspected.name == "minecraft:birch_leaves") then
            break
        end

        moved = moved + 1
        turtle.digUp()
        turtle.up()
    end

    for i = 0, moved do
        turtle.down()
    end

    turtle.back()

    os.sleep(5)
end
