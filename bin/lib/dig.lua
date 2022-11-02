-- up_all() digs blocks until turtle meets empty cell
-- and return turtle moved count.
local function upAll()
    local moved = 0
    while true do
        local found, _ = turtle.inspectUp()
        if not found then
            break
        end

        moved = moved + 1
        turtle.digUp()
        turtle.up()
    end

    return moved
end

local function up(height)
    for i = 1, height do
        turtle.digUp()
        turtle.up()
    end
    return height
end

local function down(height)
    for i = 1, height do
        turtle.digDown()
        turtle.down()
    end
    return height
end

return {
    upAll = upAll,
    up = up,
    down = down,
}
