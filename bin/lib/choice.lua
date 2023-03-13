local function input(buffer)
    local datum = {os.pullEvent()}
    local event = datum[1]

    if event == "key" then
        local key = datum[2]
        if keys.up == key then
            return false, -1, buffer
        end

        if keys.down == key then
            return false, 1, buffer
        end

        if keys.backspace == key then
            return false, 0, buffer:sub(1, -2)
        end
    elseif event == "key_up" then
        local key = datum[2]
        if keys.enter == key then
            return true, 0, buffer
        end
    elseif event == "char" then
        local ch = datum[2]
        return false, 0, buffer .. ch
    end

    return false, 0, buffer
end


-- choice allows the user for choicing an item by interactive interface.
-- args:
--  values: any object
--  f: values -> string function. this result represent each value in console interface.
local function choice(values, f)
    local buffer = ""
    local pos = 1

    local width, height = term.getSize()

    -- buffer を提示するために2行消費する
    local itemarea = height - 2

    local cmin = 1
    local cmax = itemarea
    local last_items = 0

    while true do
        entered, move, buffer = input(buffer)

        local filtered = {}
        for _, v in ipairs(values) do
            if string.match(f(v), buffer) then
                table.insert(filtered, v)
            end
        end

        local updated = (last_items ~= #filtered)
        last_items = #filtered

        pos = pos + move
        pos = math.min(math.max(1, pos), #filtered)

        if updated then
            pos = 1
            cmin = 1
            cmax = math.min(itemarea, #filtered)
        elseif move < 0 then
            cmin = math.max(1, math.min(cmin, pos))
            cmax = math.min(cmin + itemarea - 1, #filtered)
        elseif 0 < move then
            cmax = math.min(math.max(cmax, pos), #filtered)
            cmin = math.max(1, cmax - itemarea + 1)
        end

        term.clear()
        term.setCursorPos(1, 1)
        term.write(buffer)
        term.setCursorPos(1, 2)
        term.write("-----------")

        for i = cmin, cmax do
            term.setCursorPos(1, i-cmin+3)
            local line = f(filtered[i])
            if i == pos then
                if term.isColor() then
                    term.setTextColor(colors.red)
                    print(line)
                else
                    term.write(">> " .. line)
                end
            else
                term.setTextColor(colors.white)
                term.write(line)
            end
        end
        term.setTextColor(colors.white)

        -- pos == 0のときは候補が何もなくて選べない
        if entered and pos ~= 0 then
            term.clear()
            term.setCursorPos(1, 1)
            return filtered[pos]
        end
    end
end

return choice
