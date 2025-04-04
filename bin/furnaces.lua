function constructSpecialChests()
  local srcName = "minecraft:chest_7"
  local src = peripheral.wrap(chestName)
  src.name = srcName

  local fuelName = "minecraft:chest_6"
  local fuel = peripheral.wrap(fuelChestName)
  fuel.name = chestName

  local dstName = "minecraft:chest_11"
  local dst = peripheral.wrap(dstChestName)
  dst.name = dstName

  return {
    src = src,
    fuel = fuel,
    dst = dst,

    contains = function(name)
      if src.name == name then return true end
      if fuel.name == name then return true end
      if dst.name == name then return true end
      return false
    end
  }
end

local chests = constructSpecialChests()

local slots = {
  src = 1,
  fuel = 2,
  dst = 3,
}

function findItem(chest)
  for i, _ in pairs(chest.list()) do
    return i
  end
  return 0
end

function findCell(chest, item)
  firstEmpty = 0
  items = chest.list()
  for i = 27,1,-1 do
    detail = items[i]
    if not detail then
      firstEmpty = i
      goto continue
    end

    if (
        (detail.name == item) and
        (detail.count < 64)
    ) then
      return i
    end
    ::continue::
  end
  return firstEmpty
end

function acquireFurs()
  local furs = {}
  for _, name in ipairs(peripheral.getNames()) do
    if string.match(name, "minecraft:furnace_") == nil then
      goto continue
    end
    device = peripheral.wrap(name)
    device.name = name
    table.insert(furs, device)
    ::continue::
  end
  return furs
end

local furs = acquireFurs()

while true do
  for _, fur in ipairs(furs) do
    print("try to refuel " .. fur.name)
    fuel = findItem(fuelChest)

    -- skip refuel if there are no fuel item.
    if fuel ~= 0 then
      fuelChest.pushItems(fur.name, fuel, 1, slots.fuel)
    end

    print("try to push item " .. fur.name)
    item = findItem(chest)
    if item ~= 0 then
      chest.pushItems(fur.name, item, 1, slots.src)
    end

    print("try to pull item " .. fur.name)
    detail = fur.getItemDetail(slots.dst)
    if not detail then
      goto continue
    end

    cell = findCell(dstChest, detail.name)
    if cell ~= 0 then
      fur.pushItems(dstChestName, slots.dst, 64, cell)
    end

    ::continue::
  end
end
