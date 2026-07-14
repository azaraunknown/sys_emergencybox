local PANEL = {}
AccessorFunc(PANEL, "PaintedText", "PText", FORCE_STRING)
AccessorFunc(PANEL, "Color", "Color", FORCE_COLOR)
AccessorFunc(PANEL, "ID", "ID", FORCE_NUMBER)
AccessorFunc(PANEL, "ActionType", "ActionType", FORCE_STRING)
local s = EmergencySystem.UI.Scale
local c = EmergencySystem.Colors
function PANEL:Init()
    self:SetText("")
    self:SetPText("PLACEHOLDER")
    self:SetColor(c.TextPrimary)
    self:SetID(0)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(s(8), 0, 0, w, h, c.Border)
    draw.RoundedBox(s(8), s(1), s(1), w - s(2), h - s(2), c.Secondary)
    draw.SimpleText(self:GetPText(), "EmergencySystem.UI.15", w * 0.5, h * 0.5, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    net.Start("EmergencySystem:ExecuteAction")
    net.WriteUInt(self:GetActionType(), 4)
    net.WriteUInt(self:GetID(), 4)
    net.SendToServer()
    if IsValid(EmergencySystem.panel) then EmergencySystem.panel:Remove() end
end

vgui.Register("EmergencySystem.Components.Button", PANEL, "DButton")