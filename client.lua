-- Client-side script for Indicators synced with headlights

local leftKey = 311    -- K
local rightKey = 182   -- L
local hazardKey = 74   -- H

local INDL, INDR = false, false

-- Toggle keys
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            if IsControlJustPressed(1, leftKey) then
                INDL = not INDL
                TriggerServerEvent('INDL', INDL)
            end
            if IsControlJustPressed(1, rightKey) then
                INDR = not INDR
                TriggerServerEvent('INDR', INDR)
            end
            if IsControlJustPressed(1, hazardKey) then
                INDL = not INDL
                INDR = not INDR
                TriggerServerEvent('INDL', INDL)
                TriggerServerEvent('INDR', INDR)
            end
        end
    end
end)

-- Update vehicle indicators for all players
RegisterNetEvent('updateIndicators')
AddEventHandler('updateIndicators', function(PID, dir, toggle)
    local ped = GetPlayerPed(GetPlayerFromServerId(PID))
    local veh = GetVehiclePedIsIn(ped, false)
    if veh and veh ~= 0 then
        if dir == 'left' then
            SetVehicleIndicatorLights(veh, 1, toggle)
        elseif dir == 'right' then
            SetVehicleIndicatorLights(veh, 0, toggle)
        end
    end
end)

-- Play signal sound
RegisterNetEvent('PlaySound')
AddEventHandler('PlaySound', function(sound)
    if sound == 'turn_signal' then
        PlaySoundFrontend(-1, "Car_Blinkers_On", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
    end
end)

-- FX Marker synced with lights
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            local pos = GetEntityCoords(veh)

            -- Check headlights
            local _, lightsOn = GetVehicleLightsState(veh)
            -- lightsOn = 1 if headlights on

            -- FX for left indicator
            if INDL then
                local leftOffset = GetOffsetFromEntityInWorldCoords(veh, -1.0, 0.0, 1.2)
                DrawMarker(1, leftOffset.x, leftOffset.y, leftOffset.z, 0,0,0, 0,0,0, 0.15,0.15,0.15, 255,255,0, lightsOn == 1 and 100 or 150, false, true, 2, nil, nil, false)
            end

            -- FX for right indicator
            if INDR then
                local rightOffset = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, 1.2)
                DrawMarker(1, rightOffset.x, rightOffset.y, rightOffset.z, 0,0,0, 0,0,0, 0.15,0.15,0.15, 255,255,0, lightsOn == 1 and 100 or 150, false, true, 2, nil, nil, false)
            end
        end
    end
end)