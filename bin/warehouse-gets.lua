local choice = require("lib/choice")

local Warehouse = require("model/warehouse")
local Chest = require("model/chest")
local Cell = require("model/cell")

local modem = peripheral.find("modem")

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

local items = warehouse:listItems()

local indexedItems = {}
for _, item in pairs(items) do
    -- cut empty cell
    if item.name ~= "" then
        table.insert(indexedItems, item)
    end
end

local selected = choice(indexedItems, function(item)
    return item.name
end)

-- TODO: transfer  selected item to local storage.

