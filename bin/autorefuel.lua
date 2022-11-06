local item = require("lib/item")

local FUELS = {}
-- Currently, this program just supports dried_kelp_block.
FUELS["minecraft:dried_kelp_block"] = 200

for name, fuel in pairs(FUELS) do
    local slot = item.find(name)
    if not(slot == -1) then
        local diff = turtle.getFuelLimit() - turtle.getFuelLevel()
        local amount = diff / fuel
        turtle.select(slot)
        turtle.refuel(amount)
    end
end

