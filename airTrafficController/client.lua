airplaneHash = GetHashKey('shamal')                             -- Get hash key value for Shamal airplane.
pilotHash = GetHashKey('s_m_m_pilot_01')                        -- Get hash key value for airline pilot pedestrian.

runways = 
{
    LosSantos = 
    {  
        start = { x = -896.0627, y = -3202.284, z = 14.54807 },

        ending = { x = -1217.3631591797, y = -3018.0910644531, z = 13.551184654236 }
    },

    SandyShores = 
    {
        start = { x = 1055.5882568359, y = 3075.9333496094, z = 42.022682189941 },

        ending = { x = 1608.9467773438, y = 3226.4233398438, z = 41.585639953613 }
    }
}

planeSpawns = 
{
    LS = 
    {
        x = -1217.3631591797, y = -3018.0910644531, z = 13.551184654236, heading = 59.943
    },
    
    SS = 
    {
        x = 1688.67, y = 3240.992, z = 41.43713, heading = 285.448
    }
}

flightPath =                                                    -- Object containing flight path for the plane.
{
    LS_to_SS = 
    {
        taxi = { x = -1504.393, y = -2852.970, z = 14.560 },        -- X/Y/Z Coordinates for end of LS International Runway
        ascent = { x = -1872.648, y = -2645.448, z = 86.175 },      -- X/Y/Z Coordinates to aim at when nearing end of LS International Runway
        descent = { x = -3000.0, y = 1400.0, z = 1029.044 },        -- X/Y/Z Coordinates to aim at when heading towards Runway approach above Tonga Valley
        landing = { x = 93.393, y = 2846.236, z = 206.568 }         -- X/Y/Z Coordinates of Runway Entry

    },

    SS_to_LS =
    {
        taxi = { x = 1688.67, y = 3240.992, z = 41.43713 },
        ascent = { x = 2425.498, y = 3377.478, z = 253.6307 },
        midway = { x = 4000.0, y = 136.9569, z = 892.042 },
        descent = { x = 2500.0, y = -4250.0, z = 501.4512 },
        landing = { x = 150.0, y = -3950.0, z = 250.0 }
    }
}

AddTextEntry('PLANEBLIP', 'Airliner')
airplaneBlip = AddBlipForEntity(airplane)
BeginTextCommandSetBlipName('PLANEBLIP')
SetBlipSprite(airplaneBlip, 423)
EndTextCommandSetBlipName(airplaneBlip)

LSTaxiBlip = AddBlipForCoord(flightPath.LS_to_SS.taxi.x, flightPath.LS_to_SS.taxi.y, flightPath.LS_to_SS.taxi.z)
LSAscentBlip = AddBlipForCoord(flightPath.LS_to_SS.ascent.x, flightPath.LS_to_SS.ascent.y, flightPath.LS_to_SS.ascent.z)
LSDescentBlip = AddBlipForCoord(flightPath.LS_to_SS.descent.x, flightPath.LS_to_SS.descent.y, flightPath.LS_to_SS.descent.z)
LSLandingBlip = AddBlipForCoord(flightPath.LS_to_SS.landing.x, flightPath.LS_to_SS.landing.y, flightPath.LS_to_SS.landing.z)

SSTaxiBlip = AddBlipForCoord(flightPath.SS_to_LS.taxi.x, flightPath.SS_to_LS.taxi.y, flightPath.SS_to_LS.taxi.z)
SSAscentBlip = AddBlipForCoord(flightPath.SS_to_LS.ascent.x, flightPath.SS_to_LS.ascent.y, flightPath.SS_to_LS.ascent.z)
SSMidwayBlip = AddBlipForCoord(flightPath.SS_to_LS.midway.x, flightPath.SS_to_LS.midway.y, flightPath.SS_to_LS.midway.z)
SSDescentBlip = AddBlipForCoord(flightPath.SS_to_LS.descent.x, flightPath.SS_to_LS.descent.y, flightPath.SS_to_LS.descent.z)
SSLandingBlip = AddBlipForCoord(flightPath.SS_to_LS.landing.x, flightPath.SS_to_LS.landing.y, flightPath.SS_to_LS.landing.z)

AddTextEntry('LSTAXI', 'LS Taxi')
BeginTextCommandSetBlipName('LSTAXI')
EndTextCommandSetBlipName(LSTaxiBlip)


AddTextEntry('LSASCENT', 'LS Ascent')
BeginTextCommandSetBlipName('LSASCENT')
EndTextCommandSetBlipName(LSAscentBlip)

AddTextEntry('LSDESCENT', 'LS Descent')
BeginTextCommandSetBlipName('LSDESCENT')
EndTextCommandSetBlipName(LSDescentBlip)

AddTextEntry('LSLANDING', 'LS Landing')
BeginTextCommandSetBlipName('LSLANDING')
EndTextCommandSetBlipName(LSLandingBlip)

AddTextEntry('SSTAXI', 'SS Taxi')
BeginTextCommandSetBlipName('SSTAXI')
EndTextCommandSetBlipName(SSTaxiBlip)


AddTextEntry('SSASCENT', 'SS Ascent')
BeginTextCommandSetBlipName('SSASCENT')
EndTextCommandSetBlipName(SSAscentBlip)

AddTextEntry('SSMIDWAY', 'SS Midway')
BeginTextCommandSetBlipName('SSMIDWAY')
EndTextCommandSetBlipName(SSMidwayBlip)

AddTextEntry('SSDESCENT', 'SS Descent')
BeginTextCommandSetBlipName('SSDESCENT')
EndTextCommandSetBlipName(SSDescentBlip)

AddTextEntry('SSLANDING', 'SS Landing')
BeginTextCommandSetBlipName('SSLANDING')
EndTextCommandSetBlipName(SSLandingBlip)

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
            planeSpawns.LS.x,
            planeSpawns.LS.y,
            planeSpawns.LS.z,
            planeSpawns.LS.heading,
            true,                                       -- isNetworkModel
            false
        )

        AddTextEntry('PLANEBLIP', 'Airliner')
        airplaneBlip = AddBlipForEntity(airplane)
        BeginTextCommandSetBlipName('PLANEBLIP')
        SetBlipSprite(airplaneBlip, 423)
        EndTextCommandSetBlipName(airplaneBlip)

        airplanePilot = CreatePedInsideVehicle          -- Create a new `airplanePilot` object using the CreatePedInsideVehicle Native function.
        (
            airplane,                                   -- VEHICLE
            1,                                          
            pilotHash,
            -1,
            true,
            false
        )
        
        if IsVehicleSeatFree(airplane, 1) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                1
            )
        elseif IsVehicleSeatFree(airplane, 2) ~= false then
                TaskWarpPedIntoVehicle
                (
                    GetPlayerPed(-1),
                    airplane,
                    2
                )
        elseif IsVehicleSeatFree(airplane, 3) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                3
            )
        elseif IsVehicleSeatFree(airplane, 4) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                4
            )
        elseif IsVehicleSeatFree(airplane, 5) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                5
            )
        elseif IsVehicleSeatFree(airplane, 6) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                6
            )
        elseif IsVehicleSeatFree(airplane, 7) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                7
            )
        elseif IsVehicleSeatFree(airplane, 8) ~= false then
            TaskWarpPedIntoVehicle
            (
                GetPlayerPed(-1),
                airplane,
                8
            )
        end
        Citizen.Wait(50000)
        --[[TaskVehicleDriveToCoord
        (
            airplanePilot,
            airplane,
            flightPath.SS_to_LS.ascent.x,
            flightPath.SS_to_LS.ascent.y,
            flightPath.SS_to_LS.ascent.z,
            30.0,
            1.0,
            airplaneHash,
            45,
            1.0,
            true
        )]]
        --[[TaskVehicleDriveToCoord
        (
            airplanePilot,
            airplane,
            flightPath.LS_to_SS.taxi.x,
            flightPath.LS_to_SS.taxi.y,
            flightPath.LS_to_SS.taxi.z,
            30.0,
            1.0,
            airplaneHash,
            45,
            1.0,
            true
        )]]
        while true do
            Citizen.Wait(0)
            local planeCoords = GetEntityCoords(airplane)

            if Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.LS_to_SS.taxi.x, flightPath.LS_to_SS.taxi.y, flightPath.LS_to_SS.taxi.z) < 10 then
                print("'aircontrol': Heading towards LS Ascent point...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.LS_to_SS.ascent.x,
                    flightPath.LS_to_SS.ascent.y,
                    flightPath.LS_to_SS.ascent.z,
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
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.LS_to_SS.ascent.x, flightPath.LS_to_SS.ascent.y, flightPath.LS_to_SS.ascent.z) < 10 then
                print("'aircontrol': Heading towards LS Descent point...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.LS_to_SS.descent.x,
                    flightPath.LS_to_SS.descent.y,
                    flightPath.LS_to_SS.descent.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.LS_to_SS.descent.x, flightPath.LS_to_SS.descent.y, flightPath.LS_to_SS.descent.z) < 10 then
                print("'aircontrol': Heading towards LS Landing point...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.LS_to_SS.landing.x,
                    flightPath.LS_to_SS.landing.y,
                    flightPath.LS_to_SS.landing.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.LS_to_SS.landing.x, flightPath.LS_to_SS.landing.y, flightPath.LS_to_SS.landing.z) < 15 then
                print("'aircontrol': Engaging Landing Procedure...")
                TaskPlaneLand
                (
                    airplanePilot,                          -- Plane to land.
                    airplane,                               -- Pilot to land plane.
                    runways.SandyShores.start.x,            -- Runway start X coordinate.
                    runways.SandyShores.start.y,            -- Runway start Y coordinate.
                    runways.SandyShores.start.z,            -- Runway start Z coordinate.
                    runways.SandyShores.ending.x,           -- Runway end X coordinate.
                    runways.SandyShores.ending.y,           -- Runway end Y coordinate.
                    runways.SandyShores.ending.z            -- Runway end Z coordainte.
                )

                Citizen.Wait(180000)

                print("'aircontrol': Heading towards SS Ascent point...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.SS_to_LS.ascent.x,
                    flightPath.SS_to_LS.ascent.y,
                    flightPath.SS_to_LS.ascent.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.SS_to_LS.ascent.x, flightPath.SS_to_LS.ascent.y, flightPath.SS_to_LS.ascent.z) < 10 then
                print("'aircontrol': Heading towards SS Midway point...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.SS_to_LS.midway.x,
                    flightPath.SS_to_LS.midway.y,
                    flightPath.SS_to_LS.midway.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
                Citizen.Wait(5000)
                ControlLandingGear(airplane, 3)
                Citizen.Wait(3000)
                ControlLandingGear(airplane, 1)
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.SS_to_LS.midway.x, flightPath.SS_to_LS.midway.y, flightPath.SS_to_LS.midway.z) < 10 then
                print("'aircontrol': Heading towards SS Descent point...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.SS_to_LS.descent.x,
                    flightPath.SS_to_LS.descent.y,
                    flightPath.SS_to_LS.descent.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.SS_to_LS.descent.x, flightPath.SS_to_LS.descent.y, flightPath.SS_to_LS.descent.z) < 10 then
                print("'aircontrol': Heading towards SS landing prep...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.SS_to_LS.landing.x,
                    flightPath.SS_to_LS.landing.y,
                    flightPath.SS_to_LS.landing.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, flightPath.SS_to_LS.landing.x, flightPath.SS_to_LS.landing.y, flightPath.SS_to_LS.landing.z) < 10 then
                print("'aircontrol': Engaging Landing Procedure...")
                --[[TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    runways.LosSantos.start.x,            -- Runway start X coordinate.
                    runways.LosSantos.start.y,            -- Runway start Y coordinate.
                    runways.LosSantos.start.z,            -- Runway start Z coordinate.
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )]]
                TaskPlaneLand
                (
                    airplanePilot,                          -- Plane to land.
                    airplane,                               -- Pilot to land plane.
                    runways.LosSantos.start.x,            -- Runway start X coordinate.
                    runways.LosSantos.start.y,            -- Runway start Y coordinate.
                    runways.LosSantos.start.z,            -- Runway start Z coordinate.
                    runways.LosSantos.ending.x,           -- Runway end X coordinate.
                    runways.LosSantos.ending.y,           -- Runway end Y coordinate.
                    runways.LosSantos.ending.z            -- Runway end Z coordainte.
                )
                Citizen.Wait(180000)
            elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, planeSpawns.LS.x, planeSpawns.LS.y, planeSpawns.LS.z) < 100 then
                print("'aircontrol': Heading towards LS taxi...")
                TaskVehicleDriveToCoord
                (
                    airplanePilot,
                    airplane,
                    flightPath.LS_to_SS.taxi.x,
                    flightPath.LS_to_SS.taxi.y,
                    flightPath.LS_to_SS.taxi.z,
                    30.0,
                    1.0,
                    airplaneHash,
                    45,
                    1.0,
                    true
                )
            --[[elseif Vdist(planeCoords.x, planeCoords.y, planeCoords.z, runways.LosSantos.start.x, runways.LosSantos.start.y, runways.LosSantos.start.z) < 300 then
                print("'aircontrol': Engaging Landing Procedure...")
                TaskPlaneLand
                (
                    airplanePilot,                          -- Plane to land.
                    airplane,                               -- Pilot to land plane.
                    runways.LosSantos.start.x,            -- Runway start X coordinate.
                    runways.LosSantos.start.y,            -- Runway start Y coordinate.
                    runways.LosSantos.start.z,            -- Runway start Z coordinate.
                    runways.LosSantos.ending.x,           -- Runway end X coordinate.
                    runways.LosSantos.ending.y,           -- Runway end Y coordinate.
                    runways.LosSantos.ending.z            -- Runway end Z coordainte.
                )
                --Citizen.Wait(240000)]]
            end
        end
    end
)
