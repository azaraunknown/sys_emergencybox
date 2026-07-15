net.Receive("EmergencySystem:ActionExecuted", function()
    local action_type = net.ReadUInt(4)
    local id = net.ReadUInt(4)
    local actor = net.ReadString()
    if action_type == 2 then
        EmergencySystem.PlayAnnouncement(id, actor)
        return
    end

    EmergencySystem.SetState(id, actor)
end)