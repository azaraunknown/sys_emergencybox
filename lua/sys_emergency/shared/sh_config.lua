EmergencySystem = EmergencySystem or {}
EmergencySystem.Config = EmergencySystem.Config or {}
local c = EmergencySystem.Config
c.actionTypes = {}
c.actionTypes.alertState = 1
c.actionTypes.recordedAnnouncement = 2
c.alertStates = {}
c.alertStates[1] = {
    name = "Emergency Concluded",
    color = Color(50, 205, 50),
    description = "The current emergency has been concluded by: ",
    soundPath = "i_dont_have_sounds.mp3",
    hidden = true -- dont show on hud
}

c.alertStates[2] = {
    name = "False Alarm",
    color = Color(50, 255, 0),
    description = "The current emergency has been declared a false alarm by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.alertStates[3] = {
    name = "Code 1 - Intruder Alert",
    color = Color(218, 139, 67),
    description = "An intruder has been detected in the facility by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.alertStates[4] = {
    name = "Code 2 - Riot In Progress",
    color = Color(218, 139, 67),
    description = "A riot in D-Block has been declared by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.alertStates[5] = {
    name = "Code 3 - Contamination Hazard",
    color = Color(224, 190, 87),
    description = "A contamination has been detected in the facility by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.alertStates[6] = {
    name = "Code 4 - Cognitohazard Breach",
    color = Color(224, 190, 87),
    description = "A cognitohazard has breached containment. Emergency Declaration by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.alertStates[7] = {
    name = "Code 5 - Containment Breach",
    color = Color(214, 81, 65),
    description = "A containment breach has occurred in the facility. Emergency Declaration by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.alertStates[8] = {
    name = "Code Black - Evacuate Facility",
    color = Color(214, 81, 65),
    description = "A facility evacuation has been declared by: ",
    soundPath = "i_dont_have_sounds.mp3"
}

c.recordedAnnouncements = {}
c.recordedAnnouncements[1] = {
    name = "Reminder - Keep Doors Closed",
    description = "This is a reminder to all personnel to keep all doors closed at all times. This is for the safety of all personnel and the containment of SCPs.",
    color = Color(224, 190, 87),
    soundPath = "i_dont_have_sounds.mp3"
}

c.recordedAnnouncements[2] = {
    name = "Reminder - Clear Pneumatic Tubes",
    description = "This is a reminder to all personnel to clear all pneumatic tubes of any obstructions. This is for the safety of all personnel and the containment of SCPs.",
    color = Color(224, 190, 87),
    soundPath = "i_dont_have_sounds.mp3"
}

c.recordedAnnouncements[3] = {
    name = "Reminder - Security Staff Escort",
    description = "This is a reminder to all personnel, if you are in need of an escort, please contact security immediately.",
    color = Color(224, 190, 87),
    soundPath = "i_dont_have_sounds.mp3"
}

c.recordedAnnouncements[4] = {
    name = "Reminder - Experiment with D-Class",
    description = "This is a reminder to all personnel, if you are conducting an experiment with D-Class personnel, please ensure that you have the proper clearance and that you are following all safety protocols.",
    color = Color(224, 190, 87),
    soundPath = "i_dont_have_sounds.mp3"
}

c.recordedAnnouncements[5] = {
    name = "Reminder - Training",
    description = "This is a reminder to all personnel, if you are in need of training, please contact your supervisor immediately.",
    color = Color(224, 190, 87),
    soundPath = "i_dont_have_sounds.mp3"
}

c.recordedAnnouncements[6] = {
    name = "Announcement - Intruder Alert",
    description = "This is an announcement to all personnel, an intruder has been detected in the facility. Please proceed to the nearest safe area and await further instructions.",
    color = Color(224, 190, 87),
    soundPath = "i_dont_have_sounds.mp3"
}

c.defaultState = c.alertStates[1]
c.requiredKeycardLevel = 3
c.maxProximityDistance = 125
c.cooldownTime = 10