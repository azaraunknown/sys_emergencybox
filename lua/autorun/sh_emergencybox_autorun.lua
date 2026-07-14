EmergencySystem = EmergencySystem or {}
EmergencySystem.basePath = "sys_emergency"
EmergencySystem.debugMode = true
local function loadFileShared(path)
    if SERVER then AddCSLuaFile(path) end
    include(path)
end

local function loadFileServer(path)
    if not SERVER then return end
    include(path)
end

local function loadFileClient(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        include(path)
    end
end

local function loadRecursive(dir, loader)
    local files, folders = file.Find(dir .. "/*", "LUA")
    table.sort(files)
    table.sort(folders)
    for _, fileName in ipairs(files) do
        loader(dir .. "/" .. fileName)
    end

    for _, folder in ipairs(folders) do
        loadRecursive(dir .. "/" .. folder, loader)
    end
end

function EmergencySystem.Load()
    loadRecursive(EmergencySystem.basePath .. "/shared", loadFileShared)
    loadRecursive(EmergencySystem.basePath .. "/server", loadFileServer)
    loadRecursive(EmergencySystem.basePath .. "/client", loadFileClient)
end

hook.Add("Initialize", "EmergencySystem.Load", EmergencySystem.Load)