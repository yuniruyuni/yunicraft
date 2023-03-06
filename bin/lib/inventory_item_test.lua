local test = require("bin/test")

local Item = require("bin/lib/inventory_item")

test:case("successful construction", function(t)
    t:noerror(Item.new, {
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
    t:error(Item.new, { })
    t:error(Item.new, { count = "text", })
end)

test:case("calc correct capacity", function (t)
    local target = Item.new{
        count = 30,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = {
            ["minecraft:stone_crafting_materials"] = true,
            ["minecraft:stone_tool_materials"] = true,
        },
    }
    t:equals(target:capacity(), 34)
end)

test:case("available if count < maxCount", function (t)
    local target = Item.new{
        count = 30,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = {
            ["minecraft:stone_crafting_materials"] = true,
            ["minecraft:stone_tool_materials"] = true,
        },
    }
    t:assert(target:available())
end)

test:case("unavailable if count >= maxCount", function (t)
    local target = Item.new{
        count = 64,
        maxCount = 64,
        name = "minecraft:cobblestone",
        displayName = "Cobblestone",
        tags = {
            ["minecraft:stone_crafting_materials"] = true,
            ["minecraft:stone_tool_materials"] = true,
        },
    }
    t:assert(not target:available())
end)


return test
