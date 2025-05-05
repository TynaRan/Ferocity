local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TynaRan/Ferocity/refs/heads/main/UILib.lua"))()
UILib:CreateWindow("XCreepy Edition")

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

TabAuto:CreateCheckbox("Auto Fire ProximityPrompt", function(state)
    if state then
        notify("proximityprompt firing enabled")
        while state do
            local closestPrompt = nil
            local closestDistance = math.huge

            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local playerCFrame = plr.Character.HumanoidRootPart.CFrame
                    local promptCFrame = obj.Parent.CFrame
                    local distance = (playerCFrame.Position - promptCFrame.Position).Magnitude

                    if distance < closestDistance then
                        closestPrompt = obj
                        closestDistance = distance
                    end
                end
            end

            if closestPrompt then
                fireproximityprompt(closestPrompt)
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
TabMisc:CreateCheckbox("No Fog (Complete Removal)", function(state)
    if state then
        notify("All fog effects removed")
        game.Lighting.FogEnd = 1e6
        game.Lighting.FogStart = 1e6
        game.Lighting.FogColor = Color3.new(1, 1, 1)

        for _, obj in pairs(game.Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Sky") or obj:IsA("PostEffect") then
                obj:Destroy()
            end
        end
    else
        notify("Fog effects restored")
        game.Lighting.FogEnd = 100
        game.Lighting.FogStart = 0
        game.Lighting.FogColor = Color3.new(0.5, 0.5, 0.5)

        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Parent = game.Lighting
    end
end)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local velocityHandlerName = "VelocityHandler"
local gyroHandlerName = "GyroHandler"

local vfly = false
local vehicleflyspeed = 2
local iyflyspeed = 1.5

local function getRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

TabMisc:CreateCheckbox("Fly (IY)", function(state)
    vfly = state
    if state then
        notify("Fly enabled")

        local speaker = Players.LocalPlayer
        local root = getRoot(speaker.Character)
        local camera = workspace.CurrentCamera
        local v3none = Vector3.new()
        local v3zero = Vector3.new(0, 0, 0)
        local v3inf = Vector3.new(9e9, 9e9, 9e9)

        local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

        if root then
            local bv = Instance.new("BodyVelocity")
            bv.Name = velocityHandlerName
            bv.Parent = root
            bv.MaxForce = v3zero
            bv.Velocity = v3zero

            local bg = Instance.new("BodyGyro")
            bg.Name = gyroHandlerName
            bg.Parent = root
            bg.MaxTorque = v3inf
            bg.P = 1000
            bg.D = 50
        end

        mfly1 = speaker.CharacterAdded:Connect(function()
            task.wait()
            root = getRoot(speaker.Character)
            if root then
                local bv = Instance.new("BodyVelocity")
                bv.Name = velocityHandlerName
                bv.Parent = root
                bv.MaxForce = v3zero
                bv.Velocity = v3zero

                local bg = Instance.new("BodyGyro")
                bg.Name = gyroHandlerName
                bg.Parent = root
                bg.MaxTorque = v3inf
                bg.P = 1000
                bg.D = 50
            end
        end)

        mfly2 = RunService.RenderStepped:Connect(function()
            if not vfly then return end

            root = getRoot(speaker.Character)
            camera = workspace.CurrentCamera
            if speaker.Character and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
                local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
                local VelocityHandler = root:FindFirstChild(velocityHandlerName)
                local GyroHandler = root:FindFirstChild(gyroHandlerName)

                VelocityHandler.MaxForce = v3inf
                GyroHandler.MaxTorque = v3inf
                humanoid.PlatformStand = true
                GyroHandler.CFrame = camera.CFrame
                VelocityHandler.Velocity = v3none

                local direction = controlModule:GetMoveVector()
                if direction.X > 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
                end
                if direction.X < 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
                end
                if direction.Z > 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
                end
                if direction.Z < 0 then
                    VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
                end
            end
        end)

    else
        notify("Fly disabled")
        vfly = false
            
        local root = getRoot(Players.LocalPlayer.Character)
        if root then
            if root:FindFirstChild(velocityHandlerName) then
                root:FindFirstChild(velocityHandlerName):Destroy()
            end
            if root:FindFirstChild(gyroHandlerName) then
                root:FindFirstChild(gyroHandlerName):Destroy()
            end
        end
        if mfly1 then mfly1:Disconnect() end
        if mfly2 then mfly2:Disconnect() end
        humanoid.PlatformStand = false
    end
end)
local plr = game.Players.LocalPlayer
local lastPlayerPosition
local scrapCollectionActive = false

TabAuto:CreateCheckbox("Quick Scrap Collection", function(state)
    scrapCollectionActive = state

    if state then
        local character = plr.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            lastPlayerPosition = character.HumanoidRootPart.CFrame
            notify("Position saved - Scrap collection ACTIVATED")
        end

        task.spawn(function()
            while scrapCollectionActive do
                local rootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local nearestScrap = nil
                    local minDistance = math.huge

                    for _, item in pairs(workspace:GetDescendants()) do
                        if item:IsA("BasePart") and string.lower(item.Name) == "defaultmaterial10" then
                            local distance = (rootPart.Position - item.Position).Magnitude
                            if distance < minDistance then
                                nearestScrap = item
                                minDistance = distance
                            end
                        end
                    end

                    if nearestScrap then
                        rootPart.CFrame = nearestScrap.CFrame
                        for _, prompt in pairs(nearestScrap:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        notify("Scrap collection DEACTIVATED")
        if lastPlayerPosition then
            local currentCharacter = plr.Character
            if currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart") then
                currentCharacter.HumanoidRootPart.CFrame = lastPlayerPosition
                notify("Teleported back to original position")
            end
        end
    end
end)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local camera = workspace.CurrentCamera

local function getRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getTarget()
    local origin = camera.CFrame.Position
    local direction = camera.CFrame.LookVector * 1000
    local params = RaycastParams.new()
    local playerCharacters = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            table.insert(playerCharacters, player.Character)
        end
    end

    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = playerCharacters
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)
    if result and result.Instance and result.Instance.Parent then
        local targetModel = result.Instance.Parent
        if targetModel:FindFirstChild("HumanoidRootPart") and targetModel:FindFirstChild("Humanoid") then
            return targetModel
        end
    end
    return nil
end

local function drawCrosshair()
    local gui = Instance.new("ScreenGui")
    gui.Parent = game.Players.LocalPlayer.PlayerGui

    local size = 20

    local vertical = Instance.new("Frame")
    vertical.Parent = gui
    vertical.AnchorPoint = Vector2.new(0.5, 0.5)
    vertical.Position = UDim2.new(0.5, 0, 0.5, 0)
    vertical.Size = UDim2.new(0, 2, 0, size)
    vertical.BackgroundColor3 = Color3.new(1, 0, 0)

    local horizontal = Instance.new("Frame")
    horizontal.Parent = gui
    horizontal.AnchorPoint = Vector2.new(0.5, 0.5)
    horizontal.Position = UDim2.new(0.5, 0, 0.5, 0)
    horizontal.Size = UDim2.new(0, size, 0, 2)
    horizontal.BackgroundColor3 = Color3.new(1, 0, 0)

    return gui
end

local function createPresetLine()
    local presetLine = Instance.new("Part")
    presetLine.Size = Vector3.new(0.2, 0.2, 100)
    presetLine.Anchored = true
    presetLine.CanCollide = false
    presetLine.Color = Color3.fromRGB(255, 0, 0)
    presetLine.Material = Enum.Material.Neon
    presetLine.Parent = workspace
    return presetLine
end

local crosshairGui = drawCrosshair()
local presetLine = createPresetLine()


TabMisc:CreateCheckbox("Noclip", function(state)
    local player = game.Players.LocalPlayer
    if state then
        RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

TabMisc:CreateCheckbox("Aim NPC", function(state)
    local aimConnection

    if state then
        crosshairGui.Enabled = true
        presetLine.Transparency = 0
        aimConnection = RunService.RenderStepped:Connect(function()
            local target = getTarget()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.HumanoidRootPart.Position)
                presetLine.Position = (camera.CFrame.Position + target.HumanoidRootPart.Position) / 2
                presetLine.CFrame = CFrame.lookAt(presetLine.Position, target.HumanoidRootPart.Position)
            end
        end)
    else
        if aimConnection then
            aimConnection:Disconnect()
        end
        crosshairGui.Enabled = false
        presetLine.Transparency = 1
    end
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local camera = workspace.CurrentCamera

TabMisc:CreateCheckbox("Third-Person Stable Camera", function(state)
    local player = Players.LocalPlayer
    if state then
        local cameraPart = Instance.new("Part")
        cameraPart.Size = Vector3.new(1, 1, 1)
        cameraPart.Transparency = 1
        cameraPart.CanCollide = false
        cameraPart.Anchored = true
        cameraPart.Parent = workspace

        RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                cameraPart.Position = root.Position - root.CFrame.LookVector * 3 + Vector3.new(0, 4, 0)
                camera.CameraSubject = cameraPart
                camera.CameraType = Enum.CameraType.Custom
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, camera.Focus.Position), 0.2)
            end
        end)
    else
        camera.CameraSubject = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        camera.CameraType = Enum.CameraType.Custom
    end
end)
