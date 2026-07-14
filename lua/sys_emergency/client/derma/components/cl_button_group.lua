local PANEL = {}
AccessorFunc(PANEL, "Table", "Table")
AccessorFunc(PANEL, "ActionType", "ActionType", FORCE_STRING)
AccessorFunc(PANEL, "ComponentsInnerOffset", "ComponentsInnerOffset", FORCE_NUMBER)
AccessorFunc(PANEL, "SubComponentsWidth", "SubComponentsWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "SubComponentsHeight", "SubComponentsHeight", FORCE_NUMBER)
function PANEL:Init()
    self:SetTable({})
    self.ContentsSize = 0
    self.ComponentsInnerOffset = 0
    self.SubComponentsWidth = 0
    self.SubComponentsHeight = 0
end

function PANEL:Build()
    local components_inner_offset = self:GetComponentsInnerOffset()
    local sub_components_width = self:GetSubComponentsWidth()
    local sub_components_height = self:GetSubComponentsHeight()
    for id, state in ipairs(self:GetTable()) do
        local b = self:Add("EmergencySystem.Components.Button")
        b:SetSize(sub_components_width, sub_components_height)
        b:Dock(TOP)
        b:DockMargin(components_inner_offset, components_inner_offset, components_inner_offset, 0)
        b:SetText("")
        b:SetPText(state.name)
        b:SetColor(state.color)
        b:SetID(id)
        b:SetActionType(self:GetActionType())
        self.ContentsSize = self.ContentsSize + sub_components_height + components_inner_offset
    end

    self:SetTall(self.ContentsSize)
end

function PANEL:Paint()
end

vgui.Register("EmergencySystem.Components.ButtonGroup", PANEL, "DPanel")