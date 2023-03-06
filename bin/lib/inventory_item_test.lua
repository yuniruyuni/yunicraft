local test = require("bin/test")

local Item = require("bin/lib/inventory_item")

test:case("successful construction", function(t)
    local inst, err = pcall(Item.new, {})
    t.assert(inst ~= nil)
    t.assert(err == nil)
end)

test:case("construction parameter doesn't match", function (t)
    local inst, err = pcall(Item.new, {})
    t.assert(inst == nil)
    t.assert(err ~= nil)
end)

return test
