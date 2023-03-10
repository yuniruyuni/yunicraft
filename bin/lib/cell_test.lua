local test = require("test")

local Cell = require("lib/cell")

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
    local target = Cell.default{
        count = 30,
        maxCount = 64,
    }
    t:equals(target:capacity(), 34)
end)

test:case("unoccupied if count < maxCount", function (t)
    local target = Cell.default{
        count = 30,
        maxCount = 64,
    }
    t:assert(target:unoccupied())
end)

test:case("occupied if count >= maxCount", function (t)
    local target = Cell.default{
        count = 64,
        maxCount = 64,
    }
    t:assert(target:occupied())
end)

test:case("empty if count == 0", function (t)
    local target = Cell.default{
        count = 0,
        maxCount = 64,
    }
    t:assert(target:empty())
end)

test:case("not empty if count != 0", function (t)
    local target = Cell.default{
        count = 32,
        maxCount = 64,
    }
    t:assert(not target:empty())
end)

test:case("empty cell available for all item", function (t)
    local target = Cell.default{
        name = "ITEM",
        count = 0,
        maxCount = 64,
    }
    t:assert(target:availableFor({name = "OTHER-ITEM"}))
end)

test:case("unoccupied cell available for target item", function (t)
    local target = Cell.default{
        name = "ITEM",
        count = 32,
        maxCount = 64,
    }
    t:assert(target:availableFor({name = "ITEM"}))
end)

test:case("occupied cell unavailable for target item", function (t)
    local target = Cell.default{
        name = "ITEM",
        count = 64,
        maxCount = 64,
    }
    t:assert(not target:availableFor({name = "ITEM"}))
end)

test:case("pushItem for empty cell", function (t)
    local target = Cell.default{ count = 0, maxCount = 0 }
    local expected = Cell.default{
        name = "ITEM",
        displayName = "DisplayName",
        count = 32,
        maxCount = 64,
        tags = {
            ["minecraft:stone_crafting_materials"] = true,
            ["minecraft:stone_tool_materials"] = true,
        },
    }
    local arg = Cell.default{
        name = "ITEM",
        displayName = "DisplayName",
        count = 32,
        maxCount = 64,
        tags = {
            ["minecraft:stone_crafting_materials"] = true,
            ["minecraft:stone_tool_materials"] = true,
        },
    }

    target:pushItem(arg)

    t:deepEquals(expected, target)
end)

return test
