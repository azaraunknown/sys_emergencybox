EmergencySystem = EmergencySystem or {}
EmergencySystem.currentState = EmergencySystem.currentState or 1
local c = EmergencySystem.Config
function EmergencySystem.ValidateAction(ply, actionType, actionID)
    if not IsValid(ply) then return false, nil end
    EmergencySystem.Log("Validating action type " .. actionType .. " and action ID " .. actionID .. " for player " .. ply:Nick())
    local action_real = actionType > 0 and actionType < 3 and actionType or false
    if not action_real then return false, nil end
    local usedTbl = nil
    if action_real == 1 then
        usedTbl = c.alertStates
    else
        usedTbl = c.recordedAnnouncements
    end

    local action = usedTbl[actionID] or false
    if not action or not action.name then return false, nil end
    -- since we verified the table exists for that ID, it should be safe to trust the number from the user.
    -- verify player proximity to an emergency system 
    local closest_system = nil
    local min_distance = math.huge
    for _, ent in pairs(ents.FindInSphere(ply:GetPos(), c.maxProximityDistance)) do
        if ent:GetClass() ~= "ent_emergencybox" then continue end
        local distance = ply:GetPos():Distance(ent:GetPos())
        if ent.Broken then continue end
        if distance < min_distance then
            min_distance = distance
            closest_system = ent
        end
    end

    if not closest_system or min_distance > c.maxProximityDistance then return false, nil end
    EmergencySystem.Log("Player " .. ply:Nick() .. " is within proximity of an emergency system. Validating action.")
    return true, actionID, action_real
end

function EmergencySystem.VerifyAccessLevel(ply)
    if not IsValid(ply) then return false end
    local has_needed_keycard = EmergencySystem.Access.WeaponBased(ply)
    if not has_needed_keycard or not has_needed_job then return false end
    return true
end

function EmergencySystem.RequestAction(ply, actionType, actionID)
    -- the action they have requested is real
    local validated_action, action, action_type = EmergencySystem.ValidateAction(ply, actionType, actionID)
    if not validated_action then return end
    -- Has the keycard or job or rank or whatever needed
    local validated_access = EmergencySystem.VerifyAccessLevel(ply)
    if not validated_access then return end
    if action_type == 1 then EmergencySystem.currentState = action end
    EmergencySystem.BroadcastAction(ply, action_type)
end

function EmergencySystem.BroadcastAction(ply, action_type)
    EmergencySystem.Log("Broadcasting action type " .. action_type .. " from player " .. ply:Nick())
    net.Start("EmergencySystem:ActionExecuted")
    net.WriteUInt(action_type, 4)
    net.WriteUInt(EmergencySystem.currentState, 4)
    net.WriteString(ply:Nick())
    net.Broadcast()
end

function EmergencySystem.Log(log)
    if not EmergencySystem.debugMode then return end
    print("[EmergencySystem] " .. log)
end

local lq = {}
hook.Add("PlayerInitialSpawn", "EmergencySystem:LoadQueue", function(ply) lq[ply] = true end)
hook.Add("StartCommand", "EmergencySystem:LoadQueue", function(ply, cmd, args)
    if cmd:IsForced() then return end
    if not lq[ply] then return end
    lq[ply] = nil
    timer.Simple(2, function()
        if not IsValid(ply) then return end
        ply:SendLua("EmergencySystem.currentState = " .. EmergencySystem.currentState)
    end)
end)