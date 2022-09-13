RegisterCommand
(
    "vehicle", 
    function(source, args, rawCommand)
        vehicleHash = GetHashKey(tostring(args[1]))

        RequestModel(vehicleHash)

        Citizen.CreateThread
        (
            function()
                local playerPedPos = GetEntityCoords(GetPlayerPed(-1))
                local playerPedHeading = GetEntityHeading(GetPlayerPed(-1))
                local waiting = 0

                while not HasModelLoaded(vehicleHash) and not HasModelLoaded(driverPedHash) do
                    waiting = waiting + 100
                    Citizen.Wait(100)

                    if waiting > 5000 then
                        ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                        break
                    end
                end

                local vehicleToSpawn = CreateVehicle
                (
                    vehicleHash,
                    playerPedPos.x + 2.0,
                    playerPedPos.y + 2.0,
                    playerPedPos.z,
                    playerPedHeading,
                    true,
                    true
                )
            end
        )
    end,
    false
)