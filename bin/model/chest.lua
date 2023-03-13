local expect = require("cc.expect")
local default = require("lib/default")

local Chest = {}

function Chest.new(obj)
    expect.field(obj, "name", "string")
    expect.field(obj, "cells", "table")

    setmetatable(obj, {__index = Chest})
    return obj
end

function Chest.default(obj)
    return Chest.new(default({
        name = "",
        cells = {},
    }, obj))
end

function Chest:hasAvailableCellFor(item)
    return self:availableCellFor(item) ~= nil
end

function Chest:availableCellFor(item)
    -- TODO: optimize by using dictionary.
    for _, cell in ipairs(self.cells) do
        if cell:availableFor(item) then
            return cell
        end
    end
    return nil
end

function Chest:pushItem(item)
    local cell = self:availableCellFor(item)
    if cell == nil then return item end
    return cell:pushItem(item)
end

-- toString makes a string expresses this chest.
function Chest:toString()
    -- TODO: enumerate inventory items in string.
    return "chest(name: " .. self.name .. ")"
end

return Chest
