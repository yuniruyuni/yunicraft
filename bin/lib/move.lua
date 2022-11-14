local function ensureForward(length)
    if not length then
        length = 1
    end

    for i = 1, length do
        while true do
            turtle.dig()
            if turtle.forward() then
                break
            end

            print("turtle.foward() failure, retrying...")
            sleep(0.1)
        end
    end
end

local function ensureBack(length)
    if not length then
        length = 1
    end
    for i = 1, length do
        while not turtle.back() do
            print("turtle.back() failure, retrying...")
            sleep(0.1)
        end
    end
end

local function up(height)
    for i = 1, height do
        turtle.up()
    end
    return height
end

local function down(height)
    for i = 1, height do
        turtle.down()
    end
    return height
end

local function forward(length)
    for i = 1, length do
        turtle.forward()
    end
    return length
end

local function back(length)
    for i = 1, length do
        turtle.back()
    end
    return length
end

return {
    up = up,
    down = down,
    forward = forward,
    back = back,
    ensureForward = ensureForward,
    ensureBack = ensureBack,
}
