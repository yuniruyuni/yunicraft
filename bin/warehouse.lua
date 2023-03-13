local Warehouse = require("model/warehouse")
local Chest = require("model/chest")
local Cell = require("model/cell")

local choice = require("lib/choice")

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
local transferTarget = ""

local dstPrefix = "minecraft:chest_"
for _, dstName in ipairs(modem.getNamesRemote()) do
    if string.match(dstName, dstPrefix) then
        local dst = peripheral.wrap(dstName)
        if dst.size() == CHEST_MAX_ITEM_COUNT then
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
        else
            transferTarget = dstName
        end
    end
end

parallel.waitForAll(
    -- thread for transfering from barrel to warehouse
    function ()
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
    end,
    -- thread for detecting transfer target chest.
    function ()
        local _, side = os.pullEvent("peripheral")
        transferTarget = side
        print("changed target: " .. transferTarget)
    end,
    -- thread for detecting new
    function ()
        while true do
            local items = warehouse:listItems()

            local indexedItems = {}
            for _, item in pairs(items) do
                -- cut empty cell
                if item.name ~= "" then
                    table.insert(indexedItems, item)
                end
            end

            local selected = choice(indexedItems, function(item)
                local sum = 0
                for _, ref in ipairs(item.refs) do
                    sum = sum + ref.count
                end
                return item.name .. " / " .. sum
            end)

            print("attempt to obtain " .. selected.name .. " from " .. transferTarget)
            local target = peripheral.wrap(transferTarget)
            for _, ref in ipairs(selected.refs) do
                target.pullItems(ref.chestName, ref.cellIndex)
            end
        end
    end
)
