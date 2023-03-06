local expect = require "cc.expect"

-- TODO: rename this object as `Cell` or `InventoryCell`.
local Item = {}

function Item.new(obj)
    expect.field(obj, "count", "number")
    expect.field(obj, "displayName", "string")
    expect.field(obj, "maxCount", "number")
    expect.field(obj, "name", "string")
    expect.field(obj, "tags", "table")

    setmetatable(obj, {__index = Item})
    return obj
end

function Item:capacity()
    return self.maxCount - self.count
end

function Item:available()
    return self:capacity() <= 0
end

return Item
