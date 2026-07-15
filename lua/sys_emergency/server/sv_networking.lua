util.AddNetworkString("EmergencySystem:ExecuteAction")
util.AddNetworkString("EmergencySystem:ActionExecuted")
local c = EmergencySystem.Config
local cooldowns = {}
local cooldownTime = c.cooldownTime or 10
net.Receive("EmergencySystem:ExecuteAction", function(len, ply)
    if not IsValid(ply) then return end
    if cooldowns[ply] and cooldowns[ply] > CurTime() then return end
    cooldowns[ply] = CurTime() + cooldownTime
    local actionType = net.ReadUInt(4)
    local actionID = net.ReadUInt(4)
    EmergencySystem.RequestAction(ply, actionType, actionID)
end)

hook.Add("PlayerDisconnected", "EmergencySystem:ClearCooldown", function(ply)
    cooldowns[ply] = nil
end)