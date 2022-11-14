local item = require("lib/item")

for name, fuel in pairs(item.FUELS) do
    item.refuel(name)
end

