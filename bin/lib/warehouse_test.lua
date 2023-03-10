local test = require("test")

local Warehouse = require("lib/warehouse")
local Chest = require("lib/chest")
local Cell = require("lib/cell")

test:case("successful construction", function(t)
    t:noerror(Warehouse.new, {
        chests = { Chest.default{} },
    })
end)

test:case("construction parameter doesn't match", function (t)
    t:error(Warehouse.new, { })
    t:error(Warehouse.new, { source = "text", })
end)

test:case("availableChestFor finds a chest for the item", function (t)
    local target = Warehouse.default{
        chests = {
            Chest.default{
                name = "chest-1",
                cells = {
                    Cell.default{ name = "item-1", count = 3, maxCount = 3 },
                    Cell.default{ name = "item-1", count = 1, maxCount = 3 },
                    Cell.default{ name = "item-1", count = 2, maxCount = 3 },
                },
            },
        },
    }
    local expected = target.chests[1]
    local actual = target:findAvailableChestFor(
        Cell.default{name = "item-1", count = 3, maxCount = 3}
    )

    t:deepEquals(expected, actual)
end)

test:case("putItem puts items while item count meet maxCount", function (t)
    local target = Warehouse.default{
        chests = {
            Chest.default{
                name = "chest-1",
                cells = {
                    Cell.default{ name = "item-1", count = 3, maxCount = 3 },
                    Cell.default{ name = "item-1", count = 1, maxCount = 3 },
                    Cell.default{ name = "item-1", count = 2, maxCount = 3 },
                },
            },
        },
    }
    local expected = Warehouse.default{
        chests = {
            Chest.default{
                name = "chest-1",
                cells = {
                    Cell.default{ name = "item-1", count = 3, maxCount = 3 },
                    Cell.default{ name = "item-1", count = 3, maxCount = 3 },
                    Cell.default{ name = "item-1", count = 2, maxCount = 3 },
                },
            },
        },
    }

    local res = target:pushItem({name = "item-1", count = 3, maxCount = 3})

    t:deepEquals(expected, target)
    t:deepEquals(Cell.default{name = "item-1", count = 1, maxCount = 3}, res)
end)


return test
