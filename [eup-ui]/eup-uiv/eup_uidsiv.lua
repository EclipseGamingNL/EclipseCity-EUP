local outfits = {
        ['Grijze Spijkerbroek 1'] = {
        category = 'AT/DSI Extra Broek',
        ped = 'mp_f_freemode_01',
        components = {
            { 4, 46, 4 },
        },
    },
        ['Grijze Spijkerbroek 2'] = {
        category = 'AT/DSI Extra Broek',
        ped = 'mp_f_freemode_01',
        components = {
            { 4, 62, 3 },
        },
    },
        ['Blauwe Spijkerbroek'] = {
        category = 'AT/DSI Extra Broek',
        ped = 'mp_f_freemode_01',
        components = {
            { 4, 1, 11 },
        },
    },
        ['Witte Schoenen 1'] = {
        category = 'AT/DSI Extra Schoenen',
        ped = 'mp_f_freemode_01',
        components = {
            { 6, 2, 1 },
        },
    },
        ['Zwarte Schoenen 1'] = {
        category = 'AT/DSI Extra Schoenen',
        ped = 'mp_f_freemode_01',
        components = {
            { 6, 2, 2 },
        },
    },
        ['Witte Schoenen Airs'] = {
        category = 'AT/DSI Extra Schoenen',
        ped = 'mp_f_freemode_01',
        components = {
            { 6, 5, 1 },
        },
    },
        ['Zwarte Schoenen 2'] = {
        category = 'AT/DSI Extra Schoenen',
        ped = 'mp_f_freemode_01',
        components = {
            { 6, 11, 1 },
        },
    },
        ['Zwarte Schoenen 2'] = {
        category = 'AT/DSI Extra Schoenen',
        ped = 'mp_f_freemode_01',
        components = {
            { 6, 11, 2 },
        },
    },
        ['Dienst Speciale Interventies'] = {
        category = 'AT/DSI Uniformen',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 117, 1 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
            { 1, 73, 2 },	
            { 3, 34, 1 },	
            { 4, 1, 11 },
            { 5, 1, 1 },
            { 6, 11, 2 },
            { 7, 4, 1 },
            { 8, 21, 1 },
            { 9, 30, 4 },
            { 10, 21, 1 },	
            { 11, 43, 2 },			
        },
    },
        ['Arrestatie Team'] = {
        category = 'AT/DSI Uniformen',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 126, 1 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
            { 1, 73, 1 },	
            { 3, 37, 1 },	
            { 4, 5, 3 },
            { 5, 1, 1 },
            { 6, 11, 2 },
            { 7, 4, 1 },
            { 8, 16, 1 },
            { 9, 18, 2 },
            { 10, 17, 1 },	
            { 11, 43, 3 },
			
        },
    },
        ['Blauwe Politie Beret'] = {
        category = 'AT/DSI Hoofd Extra',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 29, 2 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
        },
    },
        ['Night Vision Goggles'] = {
        category = 'AT/DSI Hoofd Extra',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 117, 1 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
        },
    },
        ['DSI Lichte Helm'] = {
        category = 'AT/DSI Hoofd Extra',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 60, 1 },	
            { 1, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
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
local mainMenu = NativeUI.CreateMenu('AT/DSI EUP', 'Kies je afdeling')

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

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

menuPool:Add(mainMenu)

menuPool:RefreshIndex()

    RegisterCommand('atdsiv', function()

        PlayerData = ESX.GetPlayerData()

        if PlayerData.job.name == 'dsi' or PlayerData.job.name == 'at' or PlayerData.job.name == 'police' or PlayerData.job.name == 'politie' or PlayerData.job.name == 'kmar' then
        
            mainMenu:Visible(not mainMenu:Visible())
        else
            ESX.ShowNotification('~r~Je hebt geen permissies om dit uit te voeren.')
            Citizen.Wait(100)
            ESX.ShowNotification('~y~Het management is contacteerd, probeer dit niet nogmaals!')
            ESX.ShowNotification('~r~Er zullen sancties oplopen als je dit te vaak doet.')
            Citizen.Wait(100)

        end

    end, false)

CreateThread(function()
    while true do
        Wait(0)

        menuPool:ProcessMenus()
    end
end)