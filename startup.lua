-- when starting system, it will run automatically.
local label = os.getComputerLabel()

if label and fs.exists(label) then
    require(label)
end
