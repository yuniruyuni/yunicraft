local test = require("bin/test")

local Cell = require("bin/lib/cell")

test:case("successful construction", function(t)
    t:noerror(Cell.new, {
        count = 32,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = {
            ["minecraft:stone_crafting_materials"] = true,
            ["minecraft:stone_tool_materials"] = true,
        },
    })
end)

test:case("construction parameter doesn't match", function (t)
    t:error(Cell.new, { })
    t:error(Cell.new, { count = "text", })
end)

test:case("calc correct capacity", function (t)
    local target = Cell.new{
        count = 30,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = { },
    }
    t:equals(target:capacity(), 34)
end)

test:case("unoccupied if count < maxCount", function (t)
    local target = Cell.new{
        count = 30,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = { },
    }
    t:assert(target:unoccupied())
end)

test:case("occupied if count >= maxCount", function (t)
    local target = Cell.new{
        count = 64,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = { },
    }
    t:assert(target:occupied())
end)

test:case("empty if count == 0", function (t)
    local target = Cell.new{
        count = 0,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = { },
    }
    t:assert(target:empty())
end)

test:case("not empty if count != 0", function (t)
    local target = Cell.new{
        count = 32,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = { },
    }
    t:assert(not target:empty())
end)

test:case("empty cell available for all item", function (t)
    local target = Cell.new{
        count = 0,
        maxCount = 64,
        name = "ITEM",
        displayName = "...",
        tags = { },
    }
    t:assert(target:availableFor("OTHER-ITEM"))
end)

test:case("unoccupied cell available for target item", function (t)
    local target = Cell.new{
        count = 32,
        maxCount = 64,
        name = "ITEM",
        displayName = "...",
        tags = { },
    }
    t:assert(target:availableFor("ITEM"))
end)

test:case("occupied cell unavailable for target item", function (t)
    local target = Cell.new{
        count = 64,
        maxCount = 64,
        name = "ITEM",
        displayName = "...",
        tags = { },
    }
    t:assert(not target:availableFor("ITEM"))
end)

return test
