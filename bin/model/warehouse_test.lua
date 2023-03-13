local test = require("test")

local Warehouse = require("model/warehouse")
local Chest = require("model/chest")
local Cell = require("model/cell")
local Item = require("model/item")

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


test:case("listItems enumeates all items in all chests", function (t)
    local target = Warehouse.default{
        chests = {
            Chest.default{
                name = "chest-1",
                cells = {
                    Cell.default{ name = "item-1", count = 1, maxCount = 3 },
                    Cell.default{ name = "item-2", count = 2, maxCount = 3 },
                },
            },
            Chest.default{
                name = "chest-2",
                cells = {
                    Cell.default{ name = "item-2", count = 1, maxCount = 3 },
                    Cell.default{ name = "item-3", count = 3, maxCount = 3 },
                },
            },
        },
    }
    local expected = {
        ["item-1"] = Item.new {
            name = "item-1",
            displayName = "",
            maxCount = 3,
            tags = {},
            refs = {
                {chestName = "chest-1", cellIndex = 1, count = 1},
            },
        },
        ["item-2"] = Item.new {
            name = "item-2",
            displayName = "",
            maxCount = 3,
            tags = {},
            refs = {
                {chestName = "chest-1", cellIndex = 2, count = 2},
                {chestName = "chest-2", cellIndex = 1, count = 1},
            },
        },
        ["item-3"] = Item.new {
            name = "item-3",
            displayName = "",
            maxCount = 3,
            tags = {},
            refs = {
                {chestName = "chest-2", cellIndex = 2, count = 3},
            },
        },
    }

    local actual = target:listItems()
    t:deepEquals(expected, actual)
end)


return test
