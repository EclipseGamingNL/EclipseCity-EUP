local outfits = {
    ['Ambulance Uniform'] = {
        category = 'Ambulance Uniformen',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
            { 1, 1, 1 },	
            { 3, 110, 1 },	
            { 4, 50, 1 },
            { 5, 1, 1 },
            { 6, 26, 1 },
            { 7, 1, 1 },
            { 8, 16, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },	
            { 11, 153, 1 },
        },
    },
    ['OvD-G Uniform'] = {
        category = 'Ambulance Uniformen',
        ped = 'mp_f_freemode_01',
        props = {
            { 0, 0, 0 },	
            { 2, 0, 0 },	
            { 3, 0, 0 },	
        },
        components = {
            { 1, 1, 1 },	
            { 3, 110, 1 },	
            { 4, 50, 2 },
            { 5, 1, 1 },
            { 6, 26, 1 },
            { 7, 1, 1 },
            { 8, 58, 1 },
            { 9, 1, 1 },
            { 10, 1, 1 },	
            { 11, 149, 6 },
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
local mainMenu = NativeUI.CreateMenu('Ambulance EUP', 'Kies je outfit!')

for name, list in pairs(categoryOutfits) do
    local subMenu = menuPool:AddSubMenu(mainMenu, name)

    for id, outfit in pairs(list) do
        outfit.item = NativeUI.CreateItem(id, 'Selecteer je outfit.')
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

menuPool:Add(mainMenu)

menuPool:RefreshIndex()

RegisterCommand('ambuv', function()
    mainMenu:Visible(not mainMenu:Visible())
end, false)

CreateThread(function()
    while true do
        Wait(0)

        menuPool:ProcessMenus()
    end
end)