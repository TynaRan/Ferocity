local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TynaRan/Ferocity/refs/heads/main/UILib.lua"))()
UILib:CreateWindow("Survive to Seventh Day")

local TabAuto = UILib.Window:CreateTab("Automatic")
local TabESP = UILib.Window:CreateTab("ESP Visual")
local TabVisual = UILib.Window:CreateTab("Visual")
local TabMisc = UILib.Window:CreateTab("Misc")

local swing, shoot, fov, speed, espRoot, espBed, fullbright = false, false, false, false, false, false, false
local fovValue, speedValue = 120, 100

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function notify(text)
    StarterGui:SetCore("SendNotification", { Title = "System", Text = text, Duration = 3 })

    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://4590657391" 
    sound.PlaybackSpeed = 1
    sound.Volume = 3
    sound:Play()
    task.wait(1)
    sound:Destroy()
end

TabAuto:CreateCheckbox("Auto Swing Axe", function(state)
    swing = state
    notify(state and "Auto Swing Enabled" or "Auto Swing Disabled")
    while swing do
        ReplicatedStorage:WaitForChild("remotes"):WaitForChild("swing_axe"):FireServer()
        task.wait(0.1)
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local targetCFrame

local function getNearestTarget()
    local closestTarget, closestDistance = nil, math.huge

    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(obj) and obj.Humanoid.Health > 0 then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = obj.HumanoidRootPart.CFrame
                end
            end
        end
    end

    return closestTarget or LocalPlayer.Character.HumanoidRootPart.CFrame
end

TabAuto:CreateCheckbox("Auto Shoot", function(state)
    shoot = state
    notify(state and "Auto Shoot Enabled" or "Auto Shoot Disabled")
    while true do
        targetCFrame = getNearestTarget()
        if targetCFrame then
            ReplicatedStorage:WaitForChild("remotes"):WaitForChild("shoot"):FireServer(targetCFrame, targetCFrame)
        end
        task.wait(0.1)
    end
end)
TabAuto:CreateCheckbox("Modify ProximityPrompt", function(state)
    modifyPrompt = state
    notify(state and "ProximityPrompt Modification Enabled" or "ProximityPrompt Modification Disabled")

    while modifyPrompt do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
                obj.MaxActivationDistance = 15
            end
        end
        task.wait(0.1)
    end
end)

TabAuto:CreateCheckbox("fire proximityprompt", function(state)
    if state then
        notify("proximityprompt firing enabled")
        while state do
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    if string.find(string.lower(obj.Name), "prompt") then
                        fireproximityprompt(obj)
                    end
                end
            end
            task.wait(0.1)
        end
    else
        notify("fire disabled")
    end
end)
local function highlightRootObjects()
    while espRoot do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
            
                if not obj:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight")
                    h.Parent = obj
                    h.FillColor = Color3.fromRGB(0, 0, 255)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.5
                    h.OutlineTransparency = 0
                end
            end
        end
        task.wait(1)
    end
end

TabESP:CreateCheckbox("ESP: All RootPart Objects", function(state)
    espRoot = state
    notify(state and "RootPart ESP Enabled" or "RootPart ESP Disabled")
    if espRoot then
        task.spawn(highlightRootObjects)
    end
end)

local function highlightBedObjects()
    while espBed do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and string.find(obj.Name, "Bed") then
                notify("ESP Active: " .. obj.Name)
                if not obj:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight")
                    h.Parent = obj
                    h.FillColor = Color3.fromRGB(255, 165, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 0.3
                    h.OutlineTransparency = 0
                end
            end
        end
        task.wait(1)
    end
end

TabESP:CreateCheckbox("ESP: Bed Objects", function(state)
    espBed = state
    notify(state and "Bed ESP Enabled" or "Bed ESP Disabled")
    if espBed then
        task.spawn(highlightBedObjects)
    end
end)

local function enableFullBright()
    while fullbright do
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        task.wait(0.1)
    end
end

TabVisual:CreateCheckbox("Enable FullBright", function(state)
    fullbright = state
    notify(state and "FullBright Enabled" or "FullBright Disabled")
    if fullbright then
        task.spawn(enableFullBright)
    end
end)
TabMisc:CreateCheckbox("Infinite FOV", function(state)
    fov = state
    notify(state and "Infinite FOV Enabled" or "Infinite FOV Disabled")
    while fov do
        LocalPlayer.Camera.FieldOfView = fovValue
        task.wait(0.1)
    end
end)

TabMisc:CreateInput("Set FOV", "Enter FOV value...", function(v)
    local f = tonumber(v)
    if f and f > 0 then
        fovValue = f
        notify("New FOV: " .. fovValue)
    end
end)

TabMisc:CreateCheckbox("Infinite Speed", function(state)
    speed = state
    notify(state and "Infinite Speed Enabled" or "Infinite Speed Disabled")
    while speed do
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = speedValue
        end
        task.wait(0.1)
    end
end)

TabMisc:CreateInput("Set Speed", "Enter speed value...", function(v)
    local s = tonumber(v)
    if s and s > 0 then
        speedValue = s
        notify("New Speed: " .. speedValue)
    end
end)
