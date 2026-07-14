EmergencySystem = EmergencySystem or {}
EmergencySystem.currentState = EmergencySystem.currentState or 1
local c = EmergencySystem.Config
function EmergencySystem.ValidateAction(ply, actionType, actionID)
    if not IsValid(ply) then return false, nil end
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
    return true, actionID, action_real
end

function EmergencySystem.VerifyAccessLevel(ply)
    if not IsValid(ply) then return false end
    local has_needed_keycard = EmergencySystem.Access.WeaponBased(ply)
    if not has_needed_keycard then return false end
    return true
end

function EmergencySystem.RequestAction(ply, actionType, actionID)
    -- the action they have requested is real
    local validated_action, action, action_type = EmergencySystem.ValidateAction(ply, actionType, actionID)
    if not validated_action then return end
    -- Has the keycard or job or rank or whatever needed
    local validated_access = EmergencySystem.VerifyAccessLevel(ply)
    if not validated_access then return end
    EmergencySystem.currentState = action
    EmergencySystem.BroadcastAction(ply, action_type)
end

function EmergencySystem.BroadcastAction(ply, action_type)
    net.Start("EmergencySystem:ActionExecuted")
    net.WriteUInt(action_type, 4)
    net.WriteUInt(EmergencySystem.currentState, 4)
    net.WriteString(ply:Nick())
    net.Broadcast()
end

local lq = {}
hook.Add("PlayerInitialSpawnButNotCrashing", "EmergencySystem:LoadQueue", function(ply)
    print("Adding " .. ply:Nick() .. " to load queue")
    lq[ply] = true
end)

hook.Add("StartCommand", "EmergencySystem:LoadQueue", function(ply, cmd, args)
    if cmd:IsForced() then return end
    if not lq[ply] then return end
    lq[ply] = nil
    timer.Simple(2, function()
        print("Sending current state to " .. ply:Nick())
        if not IsValid(ply) then return end
        print("Sending current state to " .. ply:Nick() .. " with state " .. EmergencySystem.currentState)
        ply:SendLua("EmergencySystem.currentState = " .. EmergencySystem.currentState)
    end)
end)

concommand.Add("initalisbroken", function(ply, cmd, args)
    if not IsValid(ply) then return end
    hook.Run("PlayerInitialSpawnButNotCrashing", ply)
end)