local outfits = {
        ['ANWB Uniform'] = {
        category = 'Wegenwacht',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 11, 2 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
            { 1, 1, 1 },	
            { 3, 32, 1 },	
            { 4, 47, 2 },
            { 5, 1, 1 },
            { 6, 26, 1 },
            { 7, 16, 1 },
            { 8, 16, 1 },
            { 9, 1, 1 },
            { 10, 2, 1 },	
            { 11, 119, 1 },	
        },
    },
	['Weginspecteur'] = {
        category = 'Wegenwacht',
        ped = 'mp_m_freemode_01',
        props = {
            { 0, 0, 0 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
            { 1, 1, 1 },	
            { 3, 32, 1 },	
            { 4, 47, 1 },
            { 5, 1, 1 },
            { 6, 26, 1 },
            { 7, 16, 1 },
            { 8, 16, 1 },
            { 9, 1, 1 },
            { 10, 2, 1 },	
            { 11, 19, 2 },	
        },
    },
	['Monteur riem'] = {
        category = 'Wegenwacht',
        ped = 'mp_m_freemode_01',
        components = {
            { 8, 91, 1 },
        },
    },
	['Monteur riem V2'] = {
        category = 'Wegenwacht',
        ped = 'mp_m_freemode_01',
        components = {
            { 8, 90, 1 },
        },
    },
    
}



local function setOutfit(outfit)
    local ped = PlayerPedId()

    RequestModel(outfit.ped)

    while not HasModelLoaded(outfit.ped) do
        Wait(0)
    end

    if GetEntityModel(ped) ~= GetHashKey(outfit.ped) then
        SetPlayerModel(PlayerId(), outfit.ped)
    end

    ped = PlayerPedId()

    for _, comp in ipairs(outfit.components) do
       SetPedComponentVariation(ped, comp[1], comp[2] - 1, comp[3] - 1, 0)
    end

    for _, comp in ipairs(outfit.props) do
        if comp[2] == 0 then
            ClearPedProp(ped, comp[1])
        else
            SetPedPropIndex(ped, comp[1], comp[2] - 1, comp[3] - 1, true)
        end
    end
end

local categoryOutfits = {}

for name, outfit in pairs(outfits) do
    if not categoryOutfits[outfit.category] then
        categoryOutfits[outfit.category] = {}
    end

    categoryOutfits[outfit.category][name] = outfit
end

local menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu('Wegenwacht EUP', 'Kies je afdeling')

for name, list in pairs(categoryOutfits) do
    local subMenu = menuPool:AddSubMenu(mainMenu, name)

    for id, outfit in pairs(list) do
        outfit.item = NativeUI.CreateItem(id, 'Pak hier je kleding')
        subMenu:AddItem(outfit.item)
    end

    subMenu.OnItemSelect = function(sender, item, index)
        -- find the outfit
        for _, outfit in pairs(list) do
            if outfit.item == item then
                CreateThread(function()
                    setOutfit(outfit)
                end)
            end
        end
    end
end

QBCore = nil
local QBCore = exports['qb-core']:GetCoreObject()

menuPool:Add(mainMenu)

menuPool:RefreshIndex()

    RegisterCommand('anwb', function()

        PlayerData = QBCore.Functions.GetPlayerData()

        if PlayerData.job.name == 'mechanic' then
        
            mainMenu:Visible(not mainMenu:Visible())
        else
            QBCore.Functions.Notify('~r~Je hebt geen permissies om dit uit te voeren.')
            Citizen.Wait(100)
            QBCore.Functions.Notify('~y~Het management is contacteerd, probeer dit niet nogmaals!')
            QBCore.Functions.Notify('~r~Er zullen sancties oplopen als je dit te vaak doet.')
            Citizen.Wait(100)

        end

    end, false)

CreateThread(function()
    while true do
        Wait(0)

        menuPool:ProcessMenus()
    end
end)

-- ESX = nil
-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- menuPool:Add(mainMenu)

-- menuPool:RefreshIndex()

--     RegisterCommand('anwb', function()

--         PlayerData = ESX.GetPlayerData()

--         if PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'anwb' or PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'wegenwacht' or PlayerData.job.name == 'mechanic' then
        
--             mainMenu:Visible(not mainMenu:Visible())
--         else
--             ESX.ShowNotification('~r~Je hebt geen permissies om dit uit te voeren.')
--             Citizen.Wait(100)
--             ESX.ShowNotification('~y~Het management is contacteerd, probeer dit niet nogmaals!')
--             ESX.ShowNotification('~r~Er zullen sancties oplopen als je dit te vaak doet.')
--             Citizen.Wait(100)

--         end

--     end, false)

-- CreateThread(function()
--     while true do
--         Wait(0)

--         menuPool:ProcessMenus()
--     end
-- end)