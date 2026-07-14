EmergencySystem = EmergencySystem or {}
EmergencySystem.currentState = EmergencySystem.currentState or 1
local c = EmergencySystem.Config
function EmergencySystem.SetState(state, ply)
    EmergencySystem.currentState = state
    local message = c.alertStates[state] and c.alertStates[state].description or "Unknown"
    message = message .. ply
    chat.AddText(c.alertStates[state] and c.alertStates[state].color or Color(255, 255, 255), "[Emergency System] ", c.color, message)
    EmergencySystem.PlaySound(c.alertStates[state].soundPath)
end

function EmergencySystem.PlayAnnouncement(id, ply)
    local announcement = c.recordedAnnouncements[id]
    if not announcement then return end
    local message = announcement.description
    chat.AddText(announcement.color, "[Emergency System] ", c.color, message)
    EmergencySystem.PlaySound(announcement.soundPath)
end

function EmergencySystem.PlaySound(path)
    -- Not implemented since I dont have sounds.
    return
end

local s = nil
hook.Add("HUDPaint", "EmergencySystem:HUD", function()
    if not s then s = EmergencySystem.UI.Scale end
    local state = c.alertStates[EmergencySystem.currentState]
    if not state or state.hidden then return end
    local text = state.name
    local color = EmergencySystem.Colors.TextPrimary
    draw.SimpleText(text, "EmergencySystem.UI.25", ScrW() / 2, ScrH() - s(50), color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)