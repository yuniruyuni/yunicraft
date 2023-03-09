local expect = require("cc.expect")
local Cell = require("bin/lib/cell")

local Chest = {}

function Chest.new(obj)
    expect.field(obj, "name", "string")
    expect.field(obj, "cells", "table")

    setmetatable(obj, {__index = Chest})
    return obj
end

function Chest:hasAvailableCellFor(item)
    -- TODO: optimize by using dictionary.
    for _, cell in ipairs(self.cells) do
        if cell:availableFor(item) then
            return true
        end
    end
    return false
end

-- toString makes a string expresses this chest.
function Chest:toString()
    -- TODO: enumerate inventory items in string.
    return "chest(name: " .. self.name .. ")"
end

return Chest
