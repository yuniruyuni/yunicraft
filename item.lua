TORCH = "minecraft:torch"

-- find_slot finds an item slot that has a specified item.
function find_slot(name)
  for i = 1,16 do
    local item = turtle.getItemDetail(i)
    if item and item.name == "minecraft:torch" then
        return i
    end
  end
  return -1
end

-- place_item finds specified name item and place the item from inventry to front.
function place_item(name)
    turtle.select(find_slot(name))
    turtle.place()
end
