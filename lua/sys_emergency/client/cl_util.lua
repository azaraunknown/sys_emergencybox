EmergencySystem = EmergencySystem or {}
EmergencySystem.UI = EmergencySystem.UI or {}
local UI = EmergencySystem.UI

UI.RefWidth = 1920
UI.RefHeight = 1080
local round = math.Round
local clamp = math.Clamp
function UI.Scale(v)
    return round(v * (ScrH() / UI.RefHeight))
end

function UI.ScaleW(v)
    return round(v * (ScrW() / UI.RefWidth))
end

function UI.ScaleH(v)
    return round(v * (ScrH() / UI.RefHeight))
end

function UI.ClampedScale(v, min, max)
    local scaled = UI.Scale(v)
    return clamp(scaled, min or scaled, max or scaled)
end

