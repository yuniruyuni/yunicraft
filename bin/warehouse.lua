local Warehouse = require("model/warehouse")
local Chest = require("model/chest")
local Cell = require("model/cell")

local choice = require("lib/choice")

local modem = peripheral.find("modem")

-- acquireBarrels finds a barrel in connected computer network.
-- This function will return wrapped barrels
-- If there are no barrel in connected network, it will return empty array.
function acquireBarrels()
    return {
        peripheral.find("inventory", function (name)
            return string.match(name, "minecraft:barrel_")
        end)
    }
end

local barrels = acquireBarrels()
if #barrels == 0 then
    print("There are no barrel. This program needs least one barrel for item inbox.")
    return 1
end

-- double chest's max inventory item count.
local CHEST_MAX_ITEM_COUNT = 54

-- enumerate all storage chests
local warehouse = Warehouse.default{}
local transferTarget = ""

function consructWarehouse()
    local warehouse = Warehouse.default{}
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
    return warehouse
end

warehouse = consructWarehouse()

function transferBarrelItems()
    for _, src in ipairs(barrels) do
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

function showMenuList()
    local menus = {
        {
            name = "transfer",
            run = function ()
                local selected = showItemList()
                transferItem(selected)
            end
        },
        {
            name = "furnace",
            run = function()
                local selected = showItemList()
                local amount = 256
                runFurnace(selected, amount)
            end
        },
        {
            name = "vacuum",
            run = function()
                vacuum()
            end
        },
    }

    return choice(menus, function(item)
        return item.name
    end)
end

function showItemList()
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

    return selected
end

function transferItem(selected)
    print("attempt to obtain " .. selected.name .. " from " .. transferTarget)
    local target = peripheral.wrap(transferTarget)
    for _, ref in ipairs(selected.refs) do
        target.pullItems(ref.chestName, ref.cellIndex)
    end
    warehouse = consructWarehouse()
end

function acquireFurnace()
    return {
        peripheral.find("inventory", function (name)
            return string.match(name, "minecraft:furnace_")
        end)
    }
end

local furnaces = acquireFurnace()

function runFurnace(selected, amount)
    local furnanceSrc = 1

    local len = table.getn(furnaces)

    local transfered = 0
    for _, ref in ipairs(selected.refs) do
        if amount <= transfered then
            break
        end

        -- minimum assignment for each furnace.
        -- if it is not defined, almost always furnance burns single item by single fuel.
        -- this is too inefficient so avoid by this value.
        local MinAssign = 8
        local desired = math.max(math.floor(ref.count / len), MinAssign)

        for _, fur in pairs(furnaces) do
            local count = fur.pullItems(
                ref.chestName,
                ref.cellIndex,
                desired,
                furnanceSrc
            )
            transfered = transfered + count
        end
    end

    warehouse = consructWarehouse()
end

function vacuum()
    local furnaceSrc = 1
    local barrel = barrels[1]
    for _, fur in pairs(furnaces) do
        local detail = fur.getItemDetail(furnaceSrc)
        if detail then
            local cell = findCell(barrel, detail.name)
            fur.pushItems(
                peripheral.getName(barrel),
                furnaceSrc,
                64,
                cell
            )
        end
    end
end


function findCell(chest, item)
  firstEmpty = 0
  items = chest.list()
  for i = chest.size(),1,-1 do
    detail = items[i]
    if not detail then
      firstEmpty = i
      goto continue
    end

    if (
        (detail.name == item) and
        (detail.count < 64)
    ) then
      return i
    end
    ::continue::
  end
  return firstEmpty
end

function collectFurnaceProduct()
    local furnaceProduct = 3
    local barrel = barrels[1]
    for _, fur in pairs(furnaces) do
        local detail = fur.getItemDetail(furnaceProduct)
        if detail then
            local cell = findCell(barrel, detail.name)
            barrel.pullItems(
                peripheral.getName(fur),
                furnaceProduct,
                64,
                cell
            )
        end
    end
end

function refuelFurnace()
    local fuelName = "minecraft:charcoal"
    local items = warehouse:listItems()

    local found = nil
    for _, item in pairs(items) do
        if item.name == fuelName then
            found = item
        end
    end

    if found then
        local furnaceFuel = 2

        for _, ref in ipairs(found.refs) do
            while 0 <= ref.count do
                local len = table.getn(furnaces)
                local desired = math.max(math.floor(ref.count / len), 1)
                for _, fur in pairs(furnaces) do
                    local count = fur.pullItems(
                        ref.chestName,
                        ref.cellIndex,
                        desired,
                        furnaceFuel
                    )
                    if count then
                        ref.count = ref.count - count
                    end
                end
            end
        end

        warehouse = consructWarehouse()
    else
        sleep(1)
    end
end

function infiniteOf(f)
    return function ()
        while true do
            f()
        end
    end
end

parallel.waitForAll(
    -- thread for main menu
    function ()
        while true do
            local menu = showMenuList()
            if menu then
                menu.run()
            end
        end
    end,
    -- thread for detecting transfer target chest.
    function ()
        local _, side = os.pullEvent("peripheral")
        transferTarget = side
        print("changed target: " .. transferTarget)
    end,
    -- thread for transfering from barrel to warehouse
    infiniteOf(transferBarrelItems),
    -- auto product collection from furnace
    infiniteOf(collectFurnaceProduct),
    -- auto refuel for furnace
    infiniteOf(refuelFurnace)
)
