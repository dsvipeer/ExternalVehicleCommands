----------------------------------------------
-- External Vehicle Commands, Made by FAXES --
----------------------------------------------

--- Config ---

usingKeyPress = false -- Allow use of a key press combo (default Ctrl + E) to open trunk/hood from outside
togKey = 38 -- E


local animDicts = {
    "anim_heist@hs3f@ig14_open_car_trunk@male@",
    "anim@heists@fleeca_bank@scope_out@return_case"
}

-- Preload Animation Dictionaries
Citizen.CreateThread(function()
    for _, dict in ipairs(animDicts) do
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end)

function ShowInfo(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(false, false)
end

-- Trunk Command
RegisterCommand("trunk", function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local vehLast = GetPlayersLastVehicle()
    local coords = GetEntityCoords(ped)
    local door = 5 -- Trunk door index

    if IsPedInAnyVehicle(ped, false) then
        -- Inside the vehicle, toggle trunk directly without animation
        local isTrunkOpen = GetVehicleDoorAngleRatio(veh, door) > 0
        if isTrunkOpen then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Trunk Closed.")
        else
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Trunk Opened.")
        end
    elseif #(coords - GetEntityCoords(vehLast)) < 6 then
        -- Outside the vehicle, play animation and toggle trunk
        local isTrunkOpen = GetVehicleDoorAngleRatio(vehLast, door) > 0
        TriggerServerEvent("trunk:toggle", NetworkGetNetworkIdFromEntity(vehLast), isTrunkOpen)
    else
        ShowInfo("[Vehicle] ~y~Too far away from the vehicle.")
    end
end, false)

-- Play Animation and Toggle Trunk
RegisterNetEvent("trunk:toggleAnim")
AddEventHandler("trunk:toggleAnim", function(vehicleNetId, isTrunkOpen)
    local ped = PlayerPedId()
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    local door = 5 -- Trunk door index

    if DoesEntityExist(vehicle) then
        if isTrunkOpen then
            -- Close Trunk Animation
            TaskPlayAnim(ped, "anim@heists@fleeca_bank@scope_out@return_case", "trevor_action", 8.0, -8.0, -1, 49, 0, false, false, false)
            Citizen.Wait(1600)
            SetVehicleDoorShut(vehicle, door, false)
            ShowInfo("[Vehicle] ~g~Trunk Closed.")
        else
            -- Open Trunk Animation
            TaskPlayAnim(ped, "anim_heist@hs3f@ig14_open_car_trunk@male@", "open_trunk_rushed", 8.0, -8.0, -1, 49, 0, false, false, false)
            Citizen.Wait(1600)
            SetVehicleDoorOpen(vehicle, door, false, false)
            ShowInfo("[Vehicle] ~g~Trunk Opened.")
        end
        ClearPedTasksImmediately(ped)
    end
end)





RegisterCommand("hood", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 4

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Hood Closed.")
        else	
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Hood Opened.")
        end
    else
        if distanceToVeh < 4 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Vehicle] ~g~Hood Closed.")
            else	
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Vehicle] ~g~Hood Opened.")
            end
        else
            ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
        end
    end
end)


RegisterCommand("door", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    
    if args[1] == "1" then -- Front Left Door
        door = 0
    elseif args[1] == "2" then -- Front Right Door
        door = 1
    elseif args[1] == "3" then -- Back Left Door
        door = 2
    elseif args[1] == "4" then -- Back Right Door
        door = 3
    else
        door = nil
        ShowInfo("Usage: ~n~~b~/door [door]")
        ShowInfo("~y~Possible doors:")
        ShowInfo("1: Front Left Door~n~2: Front Right Door")
        ShowInfo("3: Back Left Door~n~4: Back Right Door")
    end

    if door ~= nil then
        if IsPedInAnyVehicle(ped, false) then
            if GetVehicleDoorAngleRatio(veh, door) > 0 then
                SetVehicleDoorShut(veh, door, false)
                ShowInfo("[Vehicle] ~g~Door Closed.")
            else	
                SetVehicleDoorOpen(veh, door, false, false)
                ShowInfo("[Vehicle] ~g~Door Opened.")
            end
        else
            if distanceToVeh < 4 then
                if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                    SetVehicleDoorShut(vehLast, door, false)
                    ShowInfo("[Vehicle] ~g~Door Closed.")
                else	
                    SetVehicleDoorOpen(vehLast, door, false, false)
                    ShowInfo("[Vehicle] ~g~Door Opened.")
                end
            else
                ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
            end
        end
    end
end)

if usingKeyPress then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsUsing(ped)
            local vehLast = GetPlayersLastVehicle()
            local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
            local door = 5
            if IsControlPressed(1, 224) and IsControlJustPressed(1, togKey) then
                if not IsPedInAnyVehicle(ped, false) then
                    if distanceToVeh < 4 then
                        if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                            SetVehicleDoorShut(vehLast, door, false)
                            ShowInfo("[Vehicle] ~g~Trunk Closed.")
                        else	
                            SetVehicleDoorOpen(vehLast, door, false, false)
                            ShowInfo("[Vehicle] ~g~Trunk Opened.")
                        end
                    else
                        ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
                    end
                end
            end
        end
    end)
end
