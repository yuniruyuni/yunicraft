local modem = peripheral.find("modem")

local DEBUG = false
function debug(val)
    if not DEBUG then
        return
    end
    print(val)
end

function findSrcBarrel()
    local srcPrefixPattern= "minecraft:barrel_"
    for _, val in pairs(peripheral.getNames()) do
        if string.match(val, srcPrefixPattern) then
            return val
        end
    end
    return ""
end

local srcName = findSrcBarrel()
local src = peripheral.wrap(srcName)
if src == "" then
    print("There are no barrel. This program needs a barrel for item inbox.")
    return 1
end

local CHEST_MAX_ITEM_COUNT = 54

function isFullItem(chest, name)
    local items = chest.list()
    if #items ~= CHEST_MAX_ITEM_COUNT then
        return false
    end
    local lastItem = chest.getItemDetail(CHEST_MAX_ITEM_COUNT)
    return lastItem and lastItem == name and (lastItem.maxCount <= lastItem.count)
end

function findChest(chest, itemName)
    if isFullItem(chest, itemName) then
        return nil
    end

    for _, detail in pairs(chest.list()) do
        if detail and (detail.name == itemName) then
            return detail
        end
    end
    return nil
end

-- enumerate all storage chests
local chests = {}
for _, dstName in ipairs(modem.getNamesRemote()) do
    if dstName ~= srcName then
        table.insert(chests, dstName)
    end
end

local emptyChests = { }
local item2Chests = { }
-- local fullChests = { }

for _, dstName in ipairs(chests) do
    local dst = peripheral.wrap(dstName)
    local items = dst.list()

    -- 中身がないならemptyChestsとして登録
    if #items == 0 then
        emptyChests[dstName] = true
    end

    -- 中身があるなら、それぞれの保持アイテムのテーブルに差し込む
    -- これによって後にアイテムの挿入先の高速検索を可能にする
    for _, dstDetail in ipairs(items) do
        if not item2Chests[dstDetail.name] then
            item2Chests[dstDetail.name] = {}
        end
        item2Chests[dstDetail.name][dstName] = true
    end
end

function findNextEmptyChest()
    for dstName, enable in pairs(emptyChests) do
        local dst = peripheral.wrap(dstName)
        local dstDetail = findChest(dst, itemName)

        if dstDetail then
            return item2Chests[dstDetail.name]
        end
    end
end

function removeFullChest(name)
    for _, chests in pairs(item2Chests) do
        chests[name] = nil
    end
end

function findReceivableChest(itemName)
    for dstName, _ in pairs(item2Chests[itemName]) do
        local dst = peripheral.wrap(dstName)
        local dstDetail = findChest(dst, itemName)

        if dstDetail then return dst, dstName end
    end

    for dstName, _ in pairs(emptyChests) do
        local dst = peripheral.wrap(dstName)
        return dst, dstName
    end

    return nil, nil, nil
end

function removeEmptyChest(name)
    emptyChests[name] = nil
end


while true do
    for i, srcDetail in pairs(src.list()) do
        -- inbox chestの内容を転送する先のchestをテーブルから検索する
        local itemName = srcDetail.name
        -- ensure
        if not item2Chests[itemName] then
            item2Chests[itemName] = {}
        end
        local dst, dstName = findReceivableChest(itemName)
        if dstName then
            src.pushItems(dstName, i, 64)
            print("pushItem: " .. itemName .. " to " .. dstName)

            debug("removed empty chest: " .. dstName)
            removeEmptyChest(dstName)
            if isFullItem(dst, itemName) then
                debug("removed full chest from candidates: " .. dstName)
                removeFullChest(dstName)
            else
                debug("inserted new non-empty chest: " .. dstName .. ", it's for: " .. itemName)
                item2Chests[itemName][dstName] = true
            end
        end
    end
end
