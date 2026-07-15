AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/veeds/intercom/intercom.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self.NextUse = 0
    self:SetMaxHealth(500)
    self:SetHealth(500)
    self.Broken = false
end

function ENT:Use(activator, caller)
    if self.NextUse > CurTime() then return end
    if self.Broken then return end
    local ply = activator
    if not IsValid(ply) then return end
    self.NextUse = CurTime() + 1
    ply:SendLua("EmergencySystem.OpenMenu()")
end

function ENT:OnTakeDamage(dmg)
    if self.Broken then return end
    if self:Health() <= 0 then return end
    local damage = dmg:GetDamage()
    self:SetHealth(math.Clamp(self:Health() - damage, 0, self:GetMaxHealth()))
    if self:Health() == 0 then self:Break() end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end
    if not ent:IsPlayer() then return end
    if not self.Broken then return end
    self:Repair()
end

function ENT:Break()
    self.Broken = true
end

function ENT:Repair()
    self.Broken = false
    self:SetHealth(self:GetMaxHealth())
end