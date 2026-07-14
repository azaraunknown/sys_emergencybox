include("shared.lua")
function ENT:Draw()
    self:DrawModel()
end

local colors
local round = math.Round
local max = math.Max
local UI
function ENT:DrawInteractionPrompt()
    if not UI then
        UI = EmergencySystem.UI
        colors = EmergencySystem.Colors
    end

    local center = self:LocalToWorld(self:OBBCenter()):ToScreen()
    local cx, cy = ScrW() * 0.5, ScrH() * 0.5
    local width, height = UI.Scale(100), UI.Scale(50)
    local radius = UI.Scale(0)
    local key_outer_w, key_outer_h = width * 0.45, height
    local key_inner_w, key_inner_h = width * 0.40, height * 0.9
    local offset = width * 0.25
    local x, y = cx, cy - height
    surface.SetDrawColor(colors.TextPrimary)
    surface.DrawLine(round(center.x), round(center.y), round(cx), round(cy))
    draw.RoundedBox(radius, x, y, width, height, colors.Primary)
    draw.RoundedBox(radius, x, y, key_outer_w, key_outer_h, colors.Border)
    draw.RoundedBox(radius, x + (key_outer_w - key_inner_w) * 0.5, y + (key_outer_h - key_inner_h) * 0.5, key_inner_w, key_inner_h, colors.Secondary)
    draw.SimpleText("E", "EmergencySystem.Interaction.Key", x + key_outer_w * 0.5, y + key_outer_h * 0.5, colors.TextPrimary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Use", "EmergencySystem.Interaction.Label", x + key_outer_w + offset, y + key_outer_h * 0.5, colors.TextPrimary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint", "EmergencySystem:HUDPaint.DrawInteractionPrompt", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local trace = ply:GetEyeTrace()
    if not trace.Hit or not IsValid(trace.Entity) then return end
    local ent = trace.Entity
    if ent:GetClass() ~= "ent_emergencybox" then return end
    local distance = trace.HitPos:Distance(ply:GetPos())
    if distance > 125 then return end
    ent:DrawInteractionPrompt()
end)