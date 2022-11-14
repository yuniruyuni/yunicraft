DROP_ITEMS = {
  "minecraft:dirt",
  "minecraft:cobbled_deepslate",
  "minecraft:cobblestone",
  "minecraft:tuff",
  "minecraft:andesite",
  "minecraft:diorite",
  "minecraft:granite",
}

while true do
  for i = 1, 16 do
    turtle.suck()
  end
  turtle.turnLeft()
  for i = 1, 16 do
    turtle.select(i)
    local item = turtle.getItemDetail()
    for j, name in ipairs(DROP_ITEMS) do
      if item and item.name == name then
        turtle.drop()
      end
    end
  end
  turtle.turnRight()
end
