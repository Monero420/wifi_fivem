payphones =
{
    {
        marker_position =               -- Waypoint Marker  
        { 
            x = -1080.25390625,
            y = -2575.11572265625,
            z = 13.94453907012939
        },

        taxi_position =                 -- Taxi Spawn Position
        {
            x = -986.70513916016,
            y = -2458.7255390625,
            z = 13.423865318298,
            heading =  148.1135559082
        }
    }
}

local vehicleHash = GetHashKey('taxi')                  -- Taxi Cab Model
local driverPedHash = GetHashKey('a_m_m_indian_01')     -- Taxi Driver Model
RequestModel(vehicleHash)                               
RequestModel(driverPedHash)

Citizen.CreateThread
(
    function()

        local waiting = 0

        while not HasModelLoaded(vehicleHash) and not HasModelLoaded(driverPedHash) do
            waiting = waiting + 100
            Citizen.Wait(100)

            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        
        while true do
            Citizen.Wait(1)
        
            for i = 1, #payphones, 1 do
                DrawMarker
                (
                    1,
                    payphones[i].marker_position.x,
                    payphones[i].marker_position.y,
                    payphones[i].marker_position.z - 1.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    1.0,
                    1.0,
                    1.0,
                    255,
                    255,
                    0,
                    155,
                    false,
                    true,
                    2,
                    nil,
                    nil,
                    false
                )
            end

            for i = 1, #payphones, 1 do
                local playerPosition = GetEntityCoords(GetPlayerPed(-1))

                if IsControlJustReleased(1, 176) and Vdist(payphones[i].marker_position.x, payphones[i].marker_position.y, payphones[i].marker_position.z, playerPosition.x, playerPosition.y, playerPosition.z) < 0.5 then

                    taxiCab = CreateVehicle
                    (
                        vehicleHash,
                        payphones[i].taxi_position.x,
                        payphones[i].taxi_position.y,
                        payphones[i].taxi_position.z,
                        payphones[i].taxi_position.heading,
                        true,
                        false
                    )

                    taxiDriverPed = CreatePedInsideVehicle
                    (
                        taxiCab,
                        1,
                        driverPedHash,
                        -1,
                        true,
                        false
                    )

                    SetPedMoney
                    (
                        taxiDriverPed,
                        2000
                    )

                    TaskVehicleDriveToCoord
                    (
                        taxiDriverPed,
                        taxiCab,
                        playerPosition.x,
                        playerPosition.y,
                        playerPosition.z,
                        30.0,
                        1.0,
                        vehicleHash,
                        16777216,
                        1.0,
                        true
                    )
                end
            end
        end
    end
)
