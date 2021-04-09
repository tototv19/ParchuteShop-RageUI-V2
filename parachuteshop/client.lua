ESX = nil 

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(niceESX) ESX = niceESX end)
    end
end)

-- Citizen.CreateThread(function()
--     for k in pairs(position) do
--        local blip = AddBlipForCoord(position[k].x, position[k].y, position[k].z)
--        SetBlipSprite(blip, 94)
--        SetBlipColour(blip, 1)
--        SetBlipScale(blip, 0.8)
--        SetBlipAsShortRange(blip, true)

--        BeginTextCommandSetBlipName('STRING')
--        AddTextComponentString("~r~Saut en parachute")
--        EndTextCommandSetBlipName(blip)
--    end
-- end)

-- RageUI

local openedMenu = false 
local mainMenu = RageUI.CreateMenu('Parachute', 'Parachute')
local subMenu = RageUI.CreateSubMenu(mainMenu, "Parachute", "Parachute")
mainMenu.Closed = function() openedMenu = false FreezeEntityPosition(PlayerPedId(), false) end
mainMenu:SetRectangleBanner(18, 82, 193, 255)
subMenu:SetRectangleBanner(18, 82, 193 , 255)

function openMenu()
    if openedMenu then
        openedMenu = false
        return 
    else
        openedMenu = true
        FreezeEntityPosition(PlayerPedId(), false)
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while openedMenu do
                Wait(1.0)
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Parachute", nil, {RightLabel = "→→"}, true, {}, subMenu)
                end)
                RageUI.IsVisible(subMenu, function()
                    if #Config.Parachute.Shopping.Weapons[1] ~= 0 then
                        RageUI.Separator('↓ Liste des parachutes ↓')
                        for k, v in pairs(Config.Parachute.Shopping.Weapons[1]) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~r~Prendre~s~ →→"}, true, {
                                onSelected = function()
                                    TriggerServerEvent('tototv:giveparachute', v.name, v.label)
                                end,
                            })
                        end
                    else
                        RageUI.Separator('')
                        RageUI.Separator('~r~Il n\'y a pas de parachute')
                        RageUI.Separator('') 
                    end
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Parachute.Position.Shops) do 

    
        local blip = AddBlipForCoord(v.pos)
        SetBlipSprite(blip, 94)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("~r~Saut en parachute")
        EndTextCommandSetBlipName(blip)

        while not HasModelLoaded(v.pedModel) do
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel), v.pedPos, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do 
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not openedMenu then
            for k, v in pairs(Config.Parachute.Position.Shops) do 
                if #(myCoords - v.pos) < 1.0 then 
                    nofps = true
                    Visual.Subtitle("Appuyer sur ~r~[E]~s~ pour parler au ~r~Vendeur", 1) 
                    if IsControlJustPressed(0, 38) then                  
                        openMenu()
                    end 
                end 
            end 
        end
        if nofps then 
            Wait(1)
        else 
            Wait(1500)
        end 
    end
end) 

