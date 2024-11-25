RegisterServerEvent("trunk:toggle")
AddEventHandler("trunk:toggle", function(vehicleNetId, isTrunkOpen)
    -- Notify only the player who triggered the event to perform the animation
    TriggerClientEvent("trunk:toggleAnim", source, vehicleNetId, isTrunkOpen)
end)
