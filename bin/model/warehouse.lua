local expect = require("cc.expect")
local default = require("lib/default")
local Chest = require("model/chest")

local Warehouse = {}

function Warehouse.new(obj)
    expect.field(obj, "chests", "table")

    setmetatable(obj, {__index = Warehouse})
    return obj
end

function Warehouse.default(obj)
    return Warehouse.new(default({
        chests = {},
    }, obj))
end

-- findAvailableChestFor finds a chest that has available cell for an item.
function Warehouse:findAvailableChestFor(item)
    for _, chest in ipairs(self.chests) do
        if chest:hasAvailableCellFor(item) then
            return chest
        end
    end
    return nil
end

-- pushItem insert an item for a chest in this storage.
-- It just calculate in memory, and real action will not happen.
function Warehouse:pushItem(item)
    local found = self:findAvailableChestFor(item)
    if not found then return item end
    return found:pushItem(item)
end

-- listCells gathers all cells in all chests.
function Warehouse:listCells()
    local cells = {}
    for _, chest in ipairs(self.chests) do
        for _, cell in ipairs(chest.cells) do
            table.insert(cells, cell)
        end
    end
    return cells
end

return Warehouse
