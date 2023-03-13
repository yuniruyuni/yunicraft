local expect = require("cc.expect")
local default = require("lib/default")

-- TODO: rename this object as `Cell` or `InventoryCell`.
local Cell = {}

function Cell.new(obj)
    expect.field(obj, "name", "string")
    expect.field(obj, "displayName", "string")
    expect.field(obj, "count", "number")
    expect.field(obj, "maxCount", "number")
    expect.field(obj, "tags", "table")

    setmetatable(obj, {__index = Cell})
    return obj
end

function Cell.default(obj)
    return Cell.new(default({
        name = "",
        displayName = "",
        count = 0,
        maxCount = 0,
        tags = {},
    }, obj))
end

function Cell:has(item)
    return self.name == item.name
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

function Cell:availableFor(item)
    return (
        self:empty() or
        (
            self:has(item) and
            self:unoccupied()
        )
    )
end

function Cell:empty()
    return self.count == 0
end

function Cell:pushItem(item)
    if self:empty() then
        -- TODO: extract method for overwrite self object.
        for k, v in pairs(Cell.default(item)) do
            self[k] = v
        end
        local res = {}
        return Cell.default{}
    else
        local moved = math.min(item.count, self:capacity())
        self.count = self.count + moved
        local res = Cell.default(item)
        res.count = res.count - moved
        return res
    end
end

return Cell
