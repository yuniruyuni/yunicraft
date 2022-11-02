local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

-- 水槽のサイズ
local width = 5
local depth = 5
local height = 5

-- mode-1. 昆布を壊す
function run_mode1()
    dig.down(height)

    for x = 1, width do
        for z = 1, depth do
            move.ensureForward()
        end

        for z = 1, depth do
            move.ensureBack()
        end

        if not(x == width) then
            turtle.turnRight()
            move.ensureForward()
            turtle.turnLeft()
        end
    end

    move.up(height)

    turtle.turnLeft()
    move.forward(width)
    turtle.turnRight()
end

-- mode-2. 昆布を回収する
function run_mode2()
    for x = 1, width do
        for z = 1, depth do
            turtle.suckDown()
            move.ensureForward()
        end

        for z = 1, depth do
            move.ensureBack()
        end

        if not(x == width) then
            turtle.turnRight()
            move.ensureForward()
            turtle.turnLeft()
        end
    end

    turtle.turnLeft()
    move.forward(width)
    turtle.turnRight()
end

-- mode-3. 昆布をホッパーに投入する(初期位置から2マス上/後)
function run_mode3()
    turtle.turnLeft()
    turtle.turnLeft()

    turtle.up()
    turtle.up()

    local INV_SIZE = 16
    for i = 1, INV_SIZE do
        turtle.select(i)
        turtle.drop()
    end

    turtle.down()
    turtle.down()

    turtle.turnRight()
    turtle.turnRight()
end

-- mode-4. 昆布ブロックをカマドに投入
function run_mode4()
    -- 昆布ブロックをチェストから回収
    -- (初期位置から1マス上/左)
    turtle.turnLeft()

    turtle.up()

    turtle.select(1)
    turtle.suck()

    -- カマドに向く
    turtle.turnLeft()

    local slot = item.find("minecraft:dried_kelp_block")
    if not(slot == -1) then
        turtle.select(slot)
        turtle.drop()
    end

    -- チェストにあまりを戻す
    turtle.turnRight()
    while true do
        local slot = item.find("minecraft:dried_kelp_block")
        if slot == -1 then
            break
        end
        turtle.select(slot)
        turtle.drop()
    end

    turtle.down()

    turtle.turnRight()
end

-- mode-5. 乾燥昆布ができあがるまで待つ(かまどのブロック状態チェック？)
function run_mode5()
    turtle.turnLeft()
    turtle.turnLeft()

    turtle.up()

    while true do
        sleep(10)
        local x, y = turtle.inspect()
        if not y.state.lit then
            break
        end
    end

    turtle.down()

    turtle.turnRight()
    turtle.turnRight()
end

-- mode-6. 乾燥昆布を昆布ブロックに加工(チェストから拾ってインベントリを構成、craft())
function run_mode6()
    turtle.turnLeft()

    local targets = {
        true, true, true, false,
        true, true, true, false,
        true, true, true, false,
        false, false, false, false
    }

    -- 乾燥昆布をとりだす
    for i = 1,16 do
        if targets[i] then
            turtle.select(i)
            turtle.suck()
        end
    end

    -- 生成
    turtle.craft()

    -- あまりは戻す
    while true do
        local slot = item.find("minecraft:dried_kelp")
        if slot == -1 then
            break
        end
        turtle.select(slot)
        turtle.drop()
    end

    turtle.turnRight()
end

-- mode-7. 自分の燃料を補給
function run_mode7()
    turtle.turnLeft()
    turtle.up()

    -- 燃料を取り出す
    turtle.suck()
    local slot = item.find("minecraft:dried_kelp_block")
    if not(slot == -1) then
        local KONBU_FUEL = 200
        local diff = turtle.getFuelLimit() - turtle.getFuelLevel()
        local amount = diff / KONBU_FUEL

        turtle.select(slot)
        -- 燃料補給
        turtle.refuel(amount)
    end

    -- あまりは戻す
    while true do
        local slot = item.find("minecraft:dried_kelp_block")
        if slot == -1 then
            break
        end
        turtle.select(slot)
        turtle.drop()
    end

    turtle.down()
    turtle.turnRight()
end

while true do
    run_mode1()
    sleep(20)
    run_mode2()
    run_mode3()
    run_mode4()
    run_mode5()
    run_mode6()
    run_mode7()
    sleep(600)
end
