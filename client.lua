ESX = exports.es_extended:getSharedObject()

local peds = {}
-- high scripts

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0150, 0.015 + factor, 0.03, 0, 0, 0, 100)
end
-- high scripts

CreateThread(function()
    for _, pedData in pairs(Config.Peds) do
        RequestModel(GetHashKey(pedData.model))
        while not HasModelLoaded(GetHashKey(pedData.model)) do
            Wait(0)
        end

        local ped = CreatePed(4, GetHashKey(pedData.model), pedData.coords.x, pedData.coords.y, pedData.coords.z - 1.0, pedData.heading, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanRagdoll(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
-- high scripts

        table.insert(peds, {
            ped = ped,
            event = pedData.event,
            distance = pedData.distance,
            text = pedData.text
        })
    end-- high scripts

-- high scripts

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        for _, pedInfo in pairs(peds) do
            local pedCoords = GetEntityCoords(pedInfo.ped)
            local distance = #(playerCoords - pedCoords)

            if distance <= 10.0 then
                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, pedInfo.text)
            end

            if distance <= pedInfo.distance then
                ESX.ShowHelpNotification("Premi ~INPUT_CONTEXT~ per interagire")
                if IsControlJustReleased(0, 38) then
                    TriggerEvent(pedInfo.event)
                end
            end-- high scripts

        end
        Wait(0)
    end
end)

-- high scripts

RegisterNetEvent("event1")
AddEventHandler("event1", function()
    print("Hai parlato con il polizziotto")
end)

RegisterNetEvent("event2")
AddEventHandler("event2", function()
    print("Hai parlato con il pompiere")
end)
-- high scripts
