local test = require("bin/test")

local Chest = require("bin/lib/chest")
local Cell = require("bin/lib/cell")

test:case("successful construction", function(t)
    t:noerror(Chest.new, {
        name = "name",
        cells = {
            Cell.new{
                count = 32,
                maxCount = 64,
                name = "name",
                displayName = "displayName",
                tags = {},
            }
        },
    })
end)

test:case("construction parameter doesn't match", function (t)
    t:assert(true) -- always ok for this object
end)

test:case("it hasAvailableCellFor an item if exist unoccupied cell for target item", function (t)
    local target = Chest.new{
        name = "abc",
        cells = {
            Cell.new{
                count = 2,
                displayName = "...",
                maxCount = 2,
                name = "ITEM",
                tags = {},
            },
            Cell.new{
                count = 1,
                displayName = "...",
                maxCount = 2,
                name = "ITEM",
                tags = {},
            },
            Cell.new{
                count = 2,
                displayName = "...",
                maxCount = 2,
                name = "ITEM",
                tags = {},
            },
        },
    }

    t:assert(target:hasAvailableCellFor("ITEM"))
end)

return test
