airplaneHash = GetHashKey('shamal')                             -- Get hash key value for Shamal airplane.
pilotHash = GetHashKey('s_m_m_pilot_01')                        -- Get hash key value for airline pilot pedestrian.

flightPath =                                                    -- Object containing flight path for the plane.
{
    taxi = { x = -1504.393, y = -2852.970, z = 14.560 },        -- X/Y/Z Coordinates for end of LS International Runway

    ascent = { x = -1872.648, y = -2645.448, z = 86.175 },      -- X/Y/Z Coordinates to aim at when nearing end of LS International Runway

    descent = { x = -3000.0, y = 1400.0, z = 1029.044 },        -- X/Y/Z Coordinates to aim at when heading towards Runway approach above Tonga Valley

    landing = { x = 93.393, y = 2846.236, z = 206.568 }         -- X/Y/Z Coordinates of Runway Entry
}


RequestModel(airplaneHash)                                      -- Request 3d model of our airplane be loaded by the client.
RequestModel(pilotHash)                                         -- Request 3d model of our airline pilot be loaded by the client.

Citizen.CreateThread
(
    function()
        
        -- The `waiting` variable and the while loop below this comment create a safeguard to prevent our server from crashing due to a client failure to download a requested model.
        -- It checks every tenth of a second to see if the models have loaded or not. If either of the models fail to load after waiting 5 seconds the safeguard will kill the Citizen thread.  
        local waiting = 0

        while not HasModelLoaded(airplaneHash) and not HasModelLoaded(pilotHash) do
            waiting = waiting + 100
            Citizen.Wait(100)

            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end
        -- End of safeguard feature.

        airplane = CreateVehicle                        -- Create a new `airplane` object using the CreateVehicle Native function.
        (
            airplaneHash,                               -- VEHICLE
            -1217.3631591797,                           -- SPAWN: X COORDINATE
            -3018.0910644531,                           -- SPAWN: Y COORDINATE
            13.551184654236,                            -- SPAWN: Z COORDINATE
            59.943477630615,                            -- SPAWN: HEADING
            true,                                       -- isNetworkModel
            false
        )

        airplanePilot = CreatePedInsideVehicle          -- Create a new `airplanePilot` object using the CreatePedInsideVehicle Native function.
        (
            airplane,                                   -- VEHICLE
            1,                                          
            pilotHash,
            -1,
            true,
            false
        )

        TaskWarpPedIntoVehicle
        (
            GetPlayerPed(-1),
            airplane,
            3
        )

        

        TaskVehicleDriveToCoord
        (
            airplanePilot,
            airplane,
            flightPath.taxi.x,
            flightPath.taxi.y,
            flightPath.taxi.z,
            30.0,
            1.0,
            airplaneHash,
            45,
            1.0,
            true
        )
        
        while true do
            Citizen.Wait(0)
            local planeCoords = GetEntityCoords(airplane)

            if Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.taxi.x, flightPath.taxi.y, flightPath.taxi.z) < 10 then
                print("'aircontrol': Climbing...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.ascent.x,
                    flightPath.ascent.y,
                    flightPath.ascent.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
                Citizen.Wait(3000)
                ControlLandingGear(airplane, 3)
                Citizen.Wait(1500)
                ControlLandingGear(airplane, 1)
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.ascent.x, flightPath.ascent.y, flightPath.ascent.z) < 10 then
                print("'aircontrol': Falling...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.descent.x,
                    flightPath.descent.y,
                    flightPath.descent.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.descent.x, flightPath.descent.y, flightPath.descent.z) < 10 then
                print("'aircontrol': Preparing Landing Procedure...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.landing.x,
                    flightPath.landing.y,
                    flightPath.landing.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.landing.x, flightPath.landing.y, flightPath.landing.z) < 10 then
                print("'aircontrol': Engaging Landing Procedure...")
                TaskPlaneLand
                (
                    airplanePilot,              -- Plane to land.
                    airplane,                   -- Pilot to land plane.
                    1055.5882568359,            -- Runway start X coordinate.
                    3075.9333496094,            -- Runway start Y coordinate.
                    42.022682189941,            -- Runway start Z coordinate.
                    1608.9467773438,            -- Runway end X coordinate.
                    3226.4233398438,            -- Runway end Y coordinate.
                    41.585639953613             -- Runway end Z coordainte.
                )
            end
        end
    end
)
