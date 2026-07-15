EmergencySystem = EmergencySystem or {}
EmergencySystem.Access = EmergencySystem.Access or {}
local c = EmergencySystem.Config or false
-- Controlling who can access through weapons
function EmergencySystem.Access.WeaponBased(ply)
    if not IsValid(ply) then return false end
    if not c then c = EmergencySystem.Config end
    for _, wep in pairs(ply:GetWeapons()) do
        if not wep.Base or wep.Base ~= "base_keycard" then continue end
        if wep.AccessLevel and wep.AccessLevel >= c.requiredKeycardLevel then return true end
    end
    return false
end

local auth_jobs = {
    ["Citizen"] = true,
}

function EmergencySystem.Access.Job(ply)
    if not IsValid(ply) then return false end
    if auth_jobs[team.GetName(ply:Team())] then return true end
    return false
end