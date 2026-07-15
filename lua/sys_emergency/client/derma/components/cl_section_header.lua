local PANEL = {}
AccessorFunc(PANEL, "Header", "Header", FORCE_STRING)
AccessorFunc(PANEL, "Description", "Description", FORCE_STRING)
local s = EmergencySystem.UI.Scale
local c = EmergencySystem.Colors
function PANEL:Init()
    self:SetHeader("PLACEHOLDER")
    self:SetDescription("PLACEHOLDER")
end

function PANEL:Paint(w, h)
    draw.SimpleText(self:GetHeader(), "EmergencySystem.UI.15", s(10), s(10), c.TextPrimary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(self:GetDescription(), "EmergencySystem.UI.10", s(10), s(30), c.TextSecondary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

vgui.Register("EmergencySystem.Components.SectionHeader", PANEL, "DPanel")