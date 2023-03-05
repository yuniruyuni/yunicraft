local modem = peripheral.find("modem")

local srcName = "minecraft:chest_18"
local src = peripheral.wrap(srcName)

local CHEST_MAX_ITEM_COUNT = 54

function isFullItem(chest)
    local items = chest.list()
    if #items ~= CHEST_MAX_ITEM_COUNT then
        return false
    end
    local lastItem = chest.getItemDetail(CHEST_MAX_ITEM_COUNT)
    return lastItem and (lastItem.maxCount <= lastItem.count)
end

function findChest(chest, name)
    if isFullItem(chest) then
        return nil
    end

    for _, detail in pairs(chest.list()) do
        if detail and (detail.name == name) then
            return detail
        end
    end
    return nil
end

while true do
    for i, srcDetail in pairs(src.list()) do
        for _, dstName in ipairs(modem.getNamesRemote()) do
            if dstName ~= srcName then
                local dst = peripheral.wrap(dstName)
                local dstDetail = findChest(dst, srcDetail.name)
                if dstDetail and (dstDetail.name == srcDetail.name) then
                    src.pushItems(dstName, i, 64)
                    print("pushItem: " .. srcDetail.name .. " to " .. dstName)
                    break
                end
            end
        end
    end
end
