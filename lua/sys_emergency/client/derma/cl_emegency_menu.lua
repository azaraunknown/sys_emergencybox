EmergencySystem = EmergencySystem or {}
EmergencySystem.panel = EmergencySystem.panel or nil
local c = EmergencySystem.Colors
local UI = EmergencySystem.UI
local config = EmergencySystem.Config
local s = {
    radius = UI.Scale(8),
    panel_width = UI.Scale(400),
    panel_height = UI.Scale(600),
    close_btn_size = UI.Scale(15),
    header_height = UI.Scale(35),
    header_text_offset = UI.Scale(15),
    scrollbar_width = UI.Scale(4),
    components_width = UI.Scale(380),
    components_border = UI.Scale(1),
    components_dock_offset = UI.Scale(5),
    components_inner_offset = UI.Scale(5),
    sub_components_width = UI.Scale(370),
    sub_components_height = UI.Scale(25),
    current_state_h = UI.Scale(65)
}

function EmergencySystem.OpenMenu()
    if IsValid(EmergencySystem.panel) then EmergencySystem.panel:Remove() end
    EmergencySystem.panel = vgui.Create("DPanel")
    local panel = EmergencySystem.panel
    panel:SetSize(s.panel_width, s.panel_height)
    panel:Center()
    panel:MakePopup()
    panel.Paint = function(_, w, h) draw.RoundedBox(s.radius, 0, 0, w, h, c.Secondary) end
    local header = vgui.Create("DPanel", panel)
    header:SetSize(s.panel_width, s.header_height)
    header:Dock(TOP)
    header.Paint = function(_, w, h)
        draw.RoundedBoxEx(s.radius, 0, 0, w, h, c.Primary, true, true, false, false)
        draw.RoundedBox(0, 0, h - 1, s.panel_width, 1, color_white)
        draw.SimpleText("Emergency Button", "EmergencySystem.UI.20", s.header_text_offset, h * 0.5, c.TextPrimary, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local closeBtn = vgui.Create("DButton", panel)
    closeBtn:SetSize(s.close_btn_size, s.close_btn_size)
    closeBtn:SetPos(s.panel_width - (s.header_text_offset * 1.5), s.header_text_offset * 0.6)
    closeBtn:SetText('')
    closeBtn.Paint = function(_, w, h) draw.SimpleText("✖", "EmergencySystem.UI.20", w / 2, h / 2, c.TextPrimary, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
    closeBtn.DoClick = function(_, w, h) panel:Remove() end
    local contents = panel:Add("DScrollPanel")
    contents:SetSize(s.panel_width, s.panel_height - s.header_height - s.header_text_offset - s.scrollbar_width)
    contents:Dock(TOP)
    contents:DockMargin(0, s.header_text_offset, 0, 0)
    local scrollBar = contents:GetVBar()
    scrollBar:SetWide(s.scrollbar_width)
    scrollBar.Paint = function(_, w, h) draw.RoundedBox(s.radius, 0, 0, w * 0.5, h, c.Secondary) end
    scrollBar.btnUp.Paint = function(_, w, h) end
    scrollBar.btnDown.Paint = function(_, w, h) end
    local current_state = contents:Add("DPanel")
    current_state:SetSize(s.components_width, s.current_state_h)
    current_state:Dock(TOP)
    current_state:DockMargin(s.components_dock_offset, 0, s.components_dock_offset, 0)
    current_state.Paint = function(_, w, h)
        draw.RoundedBox(s.radius, 0, 0, w, h, c.TextPrimary)
        draw.RoundedBox(s.radius, s.components_border, s.components_border, w - (s.components_border * 2), h - (s.components_border * 2), c.Primary)
        draw.SimpleText("SCP Foundation", "EmergencySystem.UI.20", s.components_inner_offset, s.components_inner_offset, c.TextPrimary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Current state: " .. EmergencySystem.currentState .. ".", "EmergencySystem.UI.10", s.components_inner_offset, s.components_inner_offset + UI.Scale(30), c.TextSecondary, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local alert_states = contents:Add("DPanel")
    alert_states:SetSize(s.components_width, s.current_state_h)
    alert_states:Dock(TOP)
    alert_states:DockMargin(s.components_dock_offset, s.components_dock_offset, s.components_dock_offset, 0)
    alert_states.Paint = function(_, w, h)
        draw.RoundedBox(s.radius, 0, 0, w, h, c.TextPrimary)
        draw.RoundedBox(s.radius, s.components_border, s.components_border, w - (s.components_border * 2), h - (s.components_border * 2), c.Primary)
    end

    local alert_states_header = alert_states:Add("EmergencySystem.Components.SectionHeader")
    alert_states_header:SetHeader("Alert States")
    alert_states_header:SetDescription("Declare or clear a site emergency state.")
    alert_states_header:SetSize(s.sub_components_width, s.sub_components_height * 2)
    alert_states_header:Dock(TOP)
    local alert_buttons = alert_states:Add("EmergencySystem.Components.ButtonGroup")
    alert_buttons:SetTable(config.alertStates)
    alert_buttons:Dock(TOP)
    alert_buttons:SetComponentsInnerOffset(s.components_inner_offset)
    alert_buttons:SetSubComponentsWidth(s.sub_components_width)
    alert_buttons:SetSubComponentsHeight(s.sub_components_height)
    alert_buttons:SetActionType(config.actionTypes.alertState)
    alert_buttons:Build()
    local alert_height = s.current_state_h + alert_buttons.ContentsSize
    alert_states:SetTall(alert_height)
    local recorded_announcements = contents:Add("DPanel")
    recorded_announcements:SetSize(s.components_width, s.current_state_h)
    recorded_announcements:Dock(TOP)
    recorded_announcements:DockMargin(s.components_dock_offset, s.components_dock_offset, s.components_dock_offset, 0)
    recorded_announcements.Paint = function(_, w, h)
        draw.RoundedBox(s.radius, 0, 0, w, h, c.TextPrimary)
        draw.RoundedBox(s.radius, s.components_border, s.components_border, w - (s.components_border * 2), h - (s.components_border * 2), c.Primary)
    end

    local recorded_announcements_header = recorded_announcements:Add("EmergencySystem.Components.SectionHeader")
    recorded_announcements_header:SetHeader("Recorded Announcements")
    recorded_announcements_header:SetDescription("Play a fixed facility announcement without changing the emergency state.")
    recorded_announcements_header:SetSize(s.sub_components_width, s.sub_components_height * 2)
    recorded_announcements_header:Dock(TOP)
    local recorded_announcements_height = s.current_state_h + s.components_dock_offset + s.components_inner_offset
    local recorded_announcements_buttons = recorded_announcements:Add("EmergencySystem.Components.ButtonGroup")
    recorded_announcements_buttons:SetTable(config.recordedAnnouncements)
    recorded_announcements_buttons:SetActionType(config.actionTypes.recordedAnnouncement)
    recorded_announcements_buttons:Dock(TOP)
    recorded_announcements_buttons:SetComponentsInnerOffset(s.components_inner_offset)
    recorded_announcements_buttons:SetSubComponentsWidth(s.sub_components_width)
    recorded_announcements_buttons:SetSubComponentsHeight(s.sub_components_height)
    recorded_announcements_buttons:Build()
    recorded_announcements_height = s.current_state_h + recorded_announcements_buttons.ContentsSize
    recorded_announcements:SetTall(recorded_announcements_height)
end