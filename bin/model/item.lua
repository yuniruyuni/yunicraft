local expect = require("cc.expect")

local Item = {}

-- construct new Item.
function Item.new(obj)
    expect.field(obj, "name", "string")
    expect.field(obj, "displayName", "string")
    expect.field(obj, "maxCount", "number")
    expect.field(obj, "refs", "table")

    setmetatable(obj, { __index = Item })
    return obj
end


function Item:pushRef(chestName, cellIndex, count)
    table.insert(self.refs, {
        chestName = chestName,
        cellIndex = cellIndex,
        count = count,
    })
end

return Item
