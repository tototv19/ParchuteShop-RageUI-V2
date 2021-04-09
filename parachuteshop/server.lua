ESX = nil
TriggerEvent('esx:getSharedObject', function(niceESX) ESX = niceESX end)

RegisterServerEvent('tototv:giveparachute')
AddEventHandler('tototv:giveparachute', function(name, label)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getWeapon(name) then
            return TriggerClientEvent('esx:showNotification', source, '~r~Vous avez déjà un Parachute !')
        else
            xPlayer.addWeapon(name, 250)
            TriggerClientEvent('esx:showNotification', source, 'Vous venez de prendre ~b~1x '..label..'~s~ au Vendeur.')
        end
    end
end)