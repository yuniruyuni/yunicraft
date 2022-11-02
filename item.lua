local TORCH = "minecraft:torch"

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
local function place(name)
    turtle.select(find(name))
    turtle.place()
end

return {
  find = find,
  place = place
}
