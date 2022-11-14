local dig = require("lib/dig")
local move = require("lib/move")
local item = require("lib/item")

-- 水槽のサイズ
local width = 20
local depth = 19
local height = 6

-- mode-1. 昆布を壊す
function run_mode1()
    dig.down(height)

    for x = 1, width do
        move.ensureForward(depth)

        if x ~= width then
            if (x % 2) == 1 then
                turtle.turnRight()
                move.ensureForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                move.ensureForward()
                turtle.turnLeft()
            end
        end
    end

    move.up(height)

    if (width % 2) == 0 then
        -- 奇数回の横移動なら、最終的な位置が奥なので
        -- 縦方向にも戻る必要がある。方向は正しいので気にしなくて良い
        move.back(depth)
    else
        -- 奇数回の横移動なら、最終的な位置は手前なので位置は気にしなくて良い。
        -- ところが方向は反転しているため一旦正面を向ける。
        move.turnLeft()
        move.turnLeft()
    end

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

        if x ~= width then
            if (x % 2) == 1 then
                turtle.turnRight()
                move.ensureForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                move.ensureForward()
                turtle.turnLeft()
            end
        end
    end

    if (width % 2) == 0 then
        -- 奇数回の横移動なら、最終的な位置が奥なので
        -- 縦方向にも戻る必要がある。方向は正しいので気にしなくて良い
        move.back(depth)
    else
        -- 奇数回の横移動なら、最終的な位置は手前なので位置は気にしなくて良い。
        -- ところが方向は反転しているため一旦正面を向ける。
        move.turnLeft()
        move.turnLeft()
    end

    turtle.turnLeft()
    move.forward(width)
    turtle.turnRight()
end

-- mode-3. 昆布をかまど搬入用チェストに投入する(初期位置から3マス上/後)
function run_mode3()
    turtle.turnLeft()
    turtle.turnLeft()

    turtle.up()
    turtle.up()
    turtle.up()

    local INV_SIZE = 16
    for i = 1, INV_SIZE do
        turtle.select(i)
        turtle.drop()
    end

    turtle.down()
    turtle.down()
    turtle.down()

    turtle.turnRight()
    turtle.turnRight()
end

-- mode-4. 昆布ブロックをカマドに投入
function run_mode4()
    -- 昆布ブロックをチェストから回収
    -- (初期位置から1マス上/左)
    turtle.up()

    -- チェストを向いている状態になる
    turtle.turnLeft()

    -- かまどの数
    local FURNANCE_COUNT = 3
    -- loop invariant: "タートルは昆布ブロック用チェストを向いている" (TODO: なにか表明する手段が欲しい)
    for i = 1, FURNANCE_COUNT do
        -- 1スタック分(=カマドに入る分)取得
        turtle.select(i)
        turtle.suck()

        -- カマドの位置まで動く
        turtle.turnLeft()
        turtle.turnLeft()
        move.forward(i-1)

        -- カマドに向く
        turtle.turnRight()
        item.drop(item.DRIED_KELP_BLOCK)

        -- チェストにあまりを戻す
        turtle.turnRight()
        move.forward(i-1)

        while item.drop(item.DRIED_KELP_BLOCK) ~= -1 do end
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
        local slot = item.find(item.DRIED_KELP)
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

    -- 補給
    turtle.suck()
    item.refuel(item.DRIED_KELP_BLOCK)

    -- あまりは戻す
    while true do
        local slot = item.find(item.DRIED_KELP_BLOCK)
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
