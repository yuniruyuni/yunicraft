local expect = require "cc.expect"

-- TODO: rename this object as `Cell` or `InventoryCell`.
local Cell = {}

function Cell.new(obj)
    expect.field(obj, "count", "number")
    expect.field(obj, "displayName", "string")
    expect.field(obj, "maxCount", "number")
    expect.field(obj, "name", "string")
    expect.field(obj, "tags", "table")

    setmetatable(obj, {__index = Cell})
    return obj
end

function Cell:capacity()
    return self.maxCount - self.count
end

function Cell:occupied()
    return self:capacity() <= 0
end

function Cell:unoccupied()
    return not self:occupied()
end

function Cell:empty()
    return self.count == 0
end

return Cell
