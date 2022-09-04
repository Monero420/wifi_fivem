isSmoking = false   -- Boolean switch to show if player is smoking or not

Citizen.CreateThread
(
    function()
        while true do
            Citizen.Wait(1)

            if IsControlJustReleased(1, 174) then                                               -- Check for Release of LeftMouseButton
                if isSmoking == false then                                                      -- Check if already smoking
                    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING", 0, true)  -- If not, start smoking animation
                    isSmoking = true                                                            -- Set boolean switch to show player is now smoking
                elseif isSmoking == true then                                                   -- If so, then cancel the smoking action
                    ClearPedTasksImmediately(GetPlayerPed(-1))                                  -- Stop all player tasks to kill the animation
                    isSmoking = false                                                           -- Set boolean switch to show player is no longer smoking
                end
            end
        end

        CreateObject    -- Create a random marijuana plant cause why the fuck not
        (
            GetHashKey('prop_weed_01'), -- Hash of the prop ID
            -1074.1231689453,           -- X Coordinate
            -2583.5339355469,           -- Y Coordinate
            13.50,                      -- Z Coordinate
            true,                       -- isNetworkModel (false=client-side/true=server-side)
            false,                      -- Rockstar Network Model (not sure)
            false                       -- doorFlag (is this a door?)
        )
    end
)
