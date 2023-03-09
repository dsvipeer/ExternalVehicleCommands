----------------------------------------------
-- External Vehicle Commands, Made by FAXES --
----------------------------------------------

--- Config ---

usingKeyPress = false -- Allow use of a key press combo (default Ctrl + E) to open trunk/hood from outside
togKey = 38 -- E


--- Code ---

local animDicts = {
    "anim_heist@hs3f@ig14_open_car_trunk@male@",
    "anim@heists@fleeca_bank@scope_out@return_case"
}

Citizen.CreateThread(function()
    for i = 1, #animDicts do
        RequestAnimDict(animDicts[i])
        while not HasAnimDictLoaded(animDicts[i]) do
            Citizen.Wait(0)
        end
    end
end)


function ShowInfo(text)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostTicker(false, false)
end

RegisterCommand("trunk", function(source, args, raw)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsUsing(ped)
    local vehLast = GetPlayersLastVehicle()
    local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(vehLast), 1)
    local door = 5

    if IsPedInAnyVehicle(ped, false) then
        if GetVehicleDoorAngleRatio(veh, door) > 0 then
            TaskPlayAnimAdvanced(ped, "anim@heists@fleeca_bank@scope_out@return_case", "trevor_action", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 4.0, -4.0, -1, 49, 0.25, 0.0, 0, 0)
            Citizen.Wait(1600) -- wait for the animation to finish
            SetVehicleDoorShut(veh, door, false)
            ShowInfo("[Vehicle] ~g~Trunk Closed.")
        else
            TaskPlayAnimAdvanced(ped, "anim_heist@hs3f@ig14_open_car_trunk@male@", "open_trunk_rushed", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 4.0, -4.0, -1, 49, 0.25, 0.0, 0, 0)
            Citizen.Wait(1600) -- wait for the animation to finish
            SetVehicleDoorOpen(veh, door, false, false)
            ShowInfo("[Vehicle] ~g~Trunk Opened.")
        end
    else
        if distanceToVeh < 6 then
            if GetVehicleDoorAngleRatio(vehLast, door) > 0 then
                TaskPlayAnimAdvanced(ped, "anim@heists@fleeca_bank@scope_out@return_case", "trevor_action", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 4.0, -4.0, -1, 49, 0.25, 0.0, 0, 0)
                Citizen.Wait(1600) -- wait for the animation to finish
                SetVehicleDoorShut(vehLast, door, false)
                ShowInfo("[Vehicle] ~g~Trunk Closed.")
            else
                TaskPlayAnimAdvanced(ped, "anim_heist@hs3f@ig14_open_car_trunk@male@", "open_trunk_rushed", GetEntityCoords(ped), 0, 0, GetEntityHeading(ped), 4.0, -4.0, -1, 49, 0.25, 0.0, 0, 0)
                Citizen.Wait(1600) -- wait for the animation to finish
                SetVehicleDoorOpen(vehLast, door, false, false)
                ShowInfo("[Vehicle] ~g~Trunk Opened.")
            end
        else
            ShowInfo("[Vehicle] ~y~Too far away from vehicle.")
        end
    end
    ClearPedTasksImmediately(ped)
end, false)



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
