RegisterServerEvent('pompier:openBossChest')
AddEventHandler('pompier:openBossChest', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer or xPlayer.job.name ~= 'pompier' then return end
    if xPlayer.job.grade < 10 then return end

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pompier', function(inventory)
        TriggerClientEvent('esx_inventoryhud:openInventory', source, {
            type = 'society',
            id = 'pompier',
            title = 'Coffre Direction Pompier',
            weight = 1000,
            inventory = inventory.items
        })
    end)
end)
