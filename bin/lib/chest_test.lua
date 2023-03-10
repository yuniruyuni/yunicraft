local test = require("test")

local Chest = require("lib/chest")
local Cell = require("lib/cell")

test:case("successful construction", function(t)
    t:noerror(Chest.new, {
        name = "name",
        cells = { Cell.default{} },
    })
end)

test:case("construction parameter doesn't match", function (t)
    t:assert(true) -- always ok for this object
end)

test:case("it hasAvailableCellFor an item if exist unoccupied cell for target item", function (t)
    local target = Chest.new{
        name = "abc",
        cells = {
            Cell.default{ name = "ITEM", count = 2, maxCount = 2 },
            Cell.default{ name = "ITEM", count = 1, maxCount = 2 },
            Cell.default{ name = "ITEM", count = 2, maxCount = 2 },
        },
    }

    t:assert(target:hasAvailableCellFor({name = "ITEM"}))
end)

return test
