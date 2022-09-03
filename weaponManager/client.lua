guns = 
{
    combatPDW = "weapon_combatpdw",
    shotgun = "weapon_shotgun",
    pistol = "weapon_pistol",
    minigun = "weapon_minigun"
}

Citizen.CreateThread
(
    function()
        for k,v in pairs(guns) do
            GiveWeaponToPed
            (
                GetPlayerPed(-1),
                GetHashKey(guns[k]),
                999,
                false,
                false
            )
        end
    end
)