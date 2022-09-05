airplaneHash = GetHashKey('shamal')
pilotHash = GetHashKey('s_m_m_pilot_01')

flightPath = 
{
    taxi =
    {
        x = -1504.3935546875,
        y = -2852.9709472656,
        z = 14.560501098633
    },

    ascent =
    {
        x = -1872.6486816406,
        y = -2645.4487304688,
        z = 86.175148010254
    },

    descent =
    {
        x = -3000.0,
        y = 1400.0,
        z = 1029.044
    },

    landing = 
    {
        x = 93.393,
        y = 2846.236,
        z = 206.568
    }
}

RequestModel(airplaneHash)
RequestModel(pilotHash)

Citizen.CreateThread
(
    function()
        local waiting = 0

        while not HasModelLoaded(airplaneHash) and not HasModelLoaded(pilotHash) do
            waiting = waiting + 100
            Citizen.Wait(100)

            if waiting > 5000 then
                ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                break
            end
        end

        airplane = CreateVehicle
        (
            airplaneHash,
            -1217.3631591797,
            -3018.0910644531,
            13.551184654236,
            59.943477630615,
            true,
            false
        )

        airplanePilot = CreatePedInsideVehicle
        (
            airplane,
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
            4
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
        
        Citizen.Wait(16510)
        
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

        Citizen.Wait(500)
        ControlLandingGear(airplane, 3)
        Citizen.Wait(250)
        ControlLandingGear(airplane, 1)

        Citizen.Wait(11160)

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

        Citizen.Wait(150000)

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

        Citizen.Wait(115000)

        --Citizen.Wait(500)
        ControlLandingGear(airplane, 2)
        --Citizen.Wait(250)
        ControlLandingGear(airplane, 0)

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
)
