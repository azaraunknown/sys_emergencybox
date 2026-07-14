EmergencySystem = EmergencySystem or {}
EmergencySystem.Access = EmergencySystem.Access or {}

-- Controlling who can access through weapons
function EmergencySystem.Access.WeaponBased(ply)
    return true
end

-- Controlling who can access job based
function EmergencySystem.Access.Job(ply)
    return false
end