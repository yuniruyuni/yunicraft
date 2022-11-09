local TORCH = "minecraft:torch"
local BEDROCK = "minecraft:bedrock"

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
    turtle.place()
end

-- placeDown finds specified name item and placeDown the item from inventry to front.
-- if no specified item, it just skip item placing.
local function placeDown(name)
    local found = find(name)
    if found == -1 then
      return
    end

    turtle.select(found)
    turtle.placeDown()
end

return {
  TORCH = TORCH,
  BEDROCK = BEDROCK,
  find = find,
  place = place,
  placeDown = placeDown,
}
