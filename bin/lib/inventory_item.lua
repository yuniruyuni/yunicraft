local expect = require "cc.expect"

local Item = {}

function Item.new(obj)
    expect.field(obj, "count", "number")
    expect.field(obj, "displayName", "string")
    expect.field(obj, "maxCount", "number")
    expect.field(obj, "name", "string")
    expect.field(obj, "tags", "table")

    setmetadata(obj, {__index = Item})
    return obj
end

return Item
