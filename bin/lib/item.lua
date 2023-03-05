local TORCH = "minecraft:torch"
local BEDROCK = "minecraft:bedrock"
local DRIED_KELP = "minecraft:dried_kelp"
local DRIED_KELP_BLOCK = "minecraft:dried_kelp_block"
local DIRT = "minecraft:dirt"

-- find finds an item slot that has a specified item.
local function find(name)
  for i = 1,16 do
    local item = turtle.getItemDetail(i)
    if item and item.name == name then
        return i
    end
  end
  return -1
end

-- place finds specified name item and place the item from inventry to front.
-- if no specified item, it just skip item placing.
local function place(name)
    local found = find(name)
    if found == -1 then
      return
    end

    turtle.select(found)
    while not turtle.place() do
      print("failed to place, retry.")
    end
end

-- placeDown finds specified name item and placeDown the item from inventry to bottom.
-- if no specified item, it just skip item placing.
-- if bottom field cell is filled, it will retry.
local function placeDown(name)
    local found = find(name)
    if found == -1 then
      return
    end

    turtle.select(found)
    while not turtle.placeDown() do
      print("failed to placeDown, retry.")
    end
end

-- drop finds specified name item and drop the item from inventry to front.
local function drop(name)
    local found = find(name)
    if found == -1 then
      return -1
    end

    turtle.select(found)
    turtle.drop()
    return found
end

local FUELS = {
  [DRIED_KELP_BLOCK] = 200,
}

-- refuel turtle by specified name item.
local function refuel(name)
    local fuel = FUELS[name]
    assert(fuel, "target item '" .. name .. "' is not a fuel.")

    local slot = find(name)
    if slot == -1 then
        return -1
    end

    local diff = turtle.getFuelLimit() - turtle.getFuelLevel()
    local amount = diff / fuel

    turtle.select(slot)
    -- 燃料補給
    turtle.refuel(amount)
end

return {
  FUELS = FUELS,
  TORCH = TORCH,
  BEDROCK = BEDROCK,
  DRIED_KELP = DRIED_KELP,
  DRIED_KELP_BLOCK = DRIED_KELP_BLOCK,
  DIRT = DIRT,
  find = find,
  place = place,
  placeDown = placeDown,
  drop = drop,
  refuel = refuel,
}
