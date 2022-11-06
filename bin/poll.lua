local count = 0
local FUEL_MARGIN = 100
while count < turtle.getFuelLevel() + FUEL_MARGIN do
    turtle.digDown()
    local succeeded = turtle.down()
    if not succeeded then
        break
    end
    count = count + 1
end

print(count)
local _, detail = turtle.inspectDown()
if detail then
    print(detail.name)
end

for y = 1,count do
    turtle.up()
end

