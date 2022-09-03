isSmoking = false

Citizen.CreateThread
(
    function()
        while true do
            Citizen.Wait(1)

            if IsControlJustReleased(1, 174) then
                if isSmoking == false then
                    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_SMOKING", 0, true)
                    isSmoking = true
                elseif isSmoking == true then
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    isSmoking = false
                end
            end
        end

        CreateObject
        (
            GetHashKey('prop_weed_01'),
            -1074.1231689453,
            -2583.5339355469,
            13.50,
            --13.665752410889,
            true,
            false,
            false
        )
    end
)