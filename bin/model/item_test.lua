local test = require("test")

local Item = require("model/item")

test:case("successful construction", function(t)
    t:noerror(Item.new, {
        name = "minecraft:item",
        displayName = "item",
        maxCount = 64,
        refs = {},
    })
end)

test:case("construction parameter doesn't match", function (t)
    t:error(Item.new, { })
    t:error(Item.new, { source = "text", })
end)

test:case("pushRef inserts ref for a cell", function (t)
    local target = Item.new {
        name = "minecraft:item",
        displayName = "item",
        maxCount = 64,
        refs = {},
    }
    local expected = Item.new {
        name = "minecraft:item",
        displayName = "item",
        maxCount = 64,
        refs = {{chestName = "chest-1", cellIndex = 1, count = 32}},
    }
    target:pushRef("chest-1", 1, 32)

    t:deepEquals(expected, target)
end)


return test
