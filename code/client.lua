local ESX = exports['es_extended']:getSharedObject()
local isFirstAid = false
local isBusy = false


local VehicleAllowedItems = {

}


local function CanUseInVehicle(itemName)
    return VehicleAllowedItems[itemName] == true or not IsPedInAnyVehicle(PlayerPedId(), false)
end

CheckZone = function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    for _, v in ipairs(Config.UseZone) do
        if Vdist(coords, vector3(v.x, v.y, v.z)) < v.r then return true end
    end

    TriggerEvent("mythic_notify:client:SendAlert", {
        text = 'ไม่สามารถใช้ในสถานที่นี้ได้',
        type = 'error',
        timeout = 5 * 1000
    })
    return false
end

CheckIsAnimate = function() return isFirstAid or isBusy end

RegisterNetEvent('catherina:UseItem')
AddEventHandler('catherina:UseItem', function(itemName)
    local item = Config.GeneralItems[itemName] or Config.JobRestrictedItems[itemName]
    if not item then return end

    if item.zoneOnly and not CheckZone() then return end

    if item.type == 'revive' then
        StartRevive(itemName)
    elseif item.healAmount then
        StartHeal(itemName, item.healAmount)
    end
end)

function StartRevive(itemName)
    if isBusy then return end

    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 1.5 then
        TriggerEvent("mythic_notify:client:SendAlert", {
            text = "ไม่พบผู้เล่นอยู่ในระยะ",
            type = "error",
            timeout = 5000,
        })
        return
    end

    if not CanUseInVehicle(itemName) then
        TriggerEvent("mythic_notify:client:SendAlert", {
            text = "ไม่สามารถใช้บนยานพาหนะได้",
            type = "error",
            timeout = 5000,
        })
        return
    end

    if IsEntityDead(PlayerPedId()) then return end
    isBusy = true

    local closestPed = GetPlayerPed(closestPlayer)
    if not IsEntityDead(closestPed) then
        isBusy = false
        return
    end

    local cancelledByUser = false

    TriggerEvent("0x4A4A78_progbar:client:progress", {
        name = "unique_action_name",
        duration = 12000,
        label = "กำลังชุป",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        },
        animation = {
            animDict = "mini@cpr@char_a@cpr_str",
            anim = "cpr_pumpchest",
            flags = 1,
        },
    }, function(cancelled)
        if not cancelled and not cancelledByUser and not IsEntityDead(PlayerPedId()) then
  
            TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
            TriggerServerEvent('0x4A4A78:removeItem', itemName)


            ClearPedTasksImmediately(PlayerPedId())
            ClearPedSecondaryTask(PlayerPedId())
        end
        isBusy = false
        cancelledByUser = false
    end)


Citizen.CreateThread(function()
    local animDict = "mini@cpr@char_a@cpr_str"
    local animName = "cpr_pumpchest"
    local ped = PlayerPedId()

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

    while isBusy do
 
        if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
            TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
        end

        if IsControlJustPressed(0, 73) then
            cancelledByUser = true
            TriggerEvent("0x4A4A78_progbar:client:cancel")
            ClearPedTasksImmediately(ped)
            ClearPedSecondaryTask(ped)
            isBusy = false
            break
        end

        Wait(200)
    end
end)

end


function StartHeal(itemName, healAmount)
    if isFirstAid then return end

    if not CanUseInVehicle(itemName) then

            TriggerEvent("mythic_notify:client:SendAlert", {
	text = 'ไม่สามารถใช้บนยานพาหนะได้',
 	type = 'error',
 	timeout = 5000,
 })
        return
    end

    isFirstAid = true

    TriggerServerEvent('0x4A4A78:removeItem', itemName)
                TriggerEvent('Heathens.ItemProgress:progress', {
                    item = 'painkiller', -- ===> ชื่อไอเทม
                    text = 'Painkiller', -- ===> ข้อความ
                    duration = 3000, -- ===> เวลาคูลดาวน์ 
                }, function()
                end)
    ESX.Streaming.RequestAnimDict('anim@heists@narcotics@funding@gang_idle', function()
        TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01',
            20.2, -20.2, -1, 1, 0, false, false, false)
        Citizen.Wait(3000)
        ClearPedTasks(PlayerPedId())
        SetEntityHealth(PlayerPedId(), math.min(200, GetEntityHealth(PlayerPedId()) + healAmount))
        isFirstAid = false
    end)
end
