ESX = exports.es_extended:getSharedObject()
local cooldownTable = {}

function CheckCooldown(source, itemName)
    local now = os.time()
    cooldownTable[source] = cooldownTable[source] or {}
    local lastUse = cooldownTable[source][itemName] or 0

    local item = Config.GeneralItems[itemName] or Config.JobRestrictedItems[itemName]
    if not item then return false end

    if now - lastUse < item.cooldown then

        return true
    end

    cooldownTable[source][itemName] = now
    return false
end

function IsJobAllowed(job, allowedJobs)
    for _, j in ipairs(allowedJobs) do
        if job == j then return true end
    end
    return false
end


local function CheckItemLimit(xPlayer, itemName)
    local xItem = xPlayer.getInventoryItem(itemName)


    if xItem and xItem.limit ~= -1 and xItem.count > xItem.limit then
        TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {
            text = 'ITEM เกินที่กำหนดไว้',
            type = 'error',
            timeout = 4 * 1000
        })
        return false
    end

    return true
end



for itemName, data in pairs(Config.GeneralItems) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not CheckItemLimit(xPlayer, itemName) then return end
        if CheckCooldown(source, itemName) then return end
        TriggerClientEvent('catherina:UseItem', source, itemName)
    end)
end


for itemName, data in pairs(Config.JobRestrictedItems) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not IsJobAllowed(xPlayer.job.name, data.allowedJobs) then return end
        if not CheckItemLimit(xPlayer, itemName) then return end
        if CheckCooldown(source, itemName) then return end
        TriggerClientEvent('catherina:UseItem', source, itemName)
    end)
end



RegisterServerEvent('0x4A4A78:removeItem')
AddEventHandler('0x4A4A78:removeItem', function(itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    -- รายชื่อไอเทมที่ไม่ต้องลบ
    local noremove = {
        ["painkiller_wz"] = true,
        ["aed_wz"] = true
    }

    if not noremove[itemName] then
        xPlayer.removeInventoryItem(itemName, 1)
    end
end)

