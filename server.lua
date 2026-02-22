
-- Store indicator state for each player
local playerIndicators = {}

-- Register server events
RegisterServerEvent('INDL')
RegisterServerEvent('INDR')

-- Left indicator toggle
AddEventHandler('INDL', function(toggle)
    local playerId = source
    playerIndicators[playerId] = playerIndicators[playerId] or {}
    playerIndicators[playerId]['left'] = toggle

    -- Notify all clients to update the left indicator
    TriggerClientEvent('updateIndicators', -1, playerId, 'left', toggle)

    -- Play sound for the player who toggled
    TriggerClientEvent('PlaySound', playerId, 'turn_signal')
end)

-- Right indicator toggle
AddEventHandler('INDR', function(toggle)
    local playerId = source
    playerIndicators[playerId] = playerIndicators[playerId] or {}
    playerIndicators[playerId]['right'] = toggle

    -- Notify all clients to update the right indicator
    TriggerClientEvent('updateIndicators', -1, playerId, 'right', toggle)

    -- Play sound for the player who toggled
    TriggerClientEvent('PlaySound', playerId, 'turn_signal')
end)

-- Optional: restore indicator state when a player reconnects
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local playerId = source
    if playerIndicators[playerId] then
        if playerIndicators[playerId]['left'] then
            TriggerClientEvent('updateIndicators', -1, playerId, 'left', true)
        end
        if playerIndicators[playerId]['right'] then
            TriggerClientEvent('updateIndicators', -1, playerId, 'right', true)
        end
    end
end)