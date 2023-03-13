local Warehouse = require("model/warehouse")
local Chest = require("model/chest")
local Cell = require("model/cell")

local modem = peripheral.find("modem")

-- findSrcBarrel finds a barrel in connected computer network.
-- This function will return a barrel's network name.
-- If there are no barrel in connected network, it will return empty string.
local function filterBarrels()
    local res = {}
    local srcPrefix = "minecraft:barrel_"
    for _, val in pairs(peripheral.getNames()) do
        if string.match(val, srcPrefix) then
            table.insert(res, val)
        end
    end
    return res
end

local function wrapBarrels(names)
    local res = {}
    for _, name in pairs(names) do
        table.insert(res, peripheral.wrap(name))
    end
    return res
end

local srcNames = filterBarrels()
local srcs = wrapBarrels(srcNames)
if #srcs == 0 then
    print("There are no barrel. This program needs least one barrel for item inbox.")
    return 1
end

-- double chest's max inventory item count.
local CHEST_MAX_ITEM_COUNT = 54

-- enumerate all storage chests
local warehouse = Warehouse.default{}

local dstPrefixPattern = "minecraft:chest_"
for _, dstName in ipairs(modem.getNamesRemote()) do
    if string.match(dstName, dstPrefixPattern) then
        local dst = peripheral.wrap(dstName)
        local items = dst.list()

        -- 中身がないならemptyChestsとして登録
        local chest = Chest.default{name = dstName}
        for i = 1, CHEST_MAX_ITEM_COUNT do
            local item = {}
            if items[i] ~= nil then
                item = items[i]
            end

            local cell = Cell.default(item)
            table.insert(chest.cells, cell)
        end

        table.insert(warehouse.chests, chest)
    end
end

while true do
    for _, src in ipairs(srcs) do
        for i, item in pairs(src.list()) do
            if item ~= nil then
                local cell = Cell.default(item)
                -- print(textutils.serializeJSON(cell))
                local chest = warehouse:findAvailableChestFor(cell)
                -- print(textutils.serializeJSON(chest))
                src.pushItems(chest.name, i, 64)
                local pushed = warehouse:pushItem(cell)
                -- print(textutils.serializeJSON(pushed))
            else
                print("item was nil")
            end
        end
    end
end
