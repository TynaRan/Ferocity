local UILib = {}

UILib.Window = {}
UILib.Tab = {}

function UILib:CreateWindow(name, parent)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name or "UI"
    ScreenGui.Parent = parent or game:GetService("CoreGui")

    local Window = Instance.new("Frame", ScreenGui)
    Window.Size = UDim2.new(0, 650, 0, 500)
    Window.Position = UDim2.new(0, 10, 0, 10)
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.Active = true
    Window.Draggable = true

    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 6)

    local Title = Instance.new("TextLabel", Window)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Text = name or "windows"
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleShowUI = Instance.new("TextButton", ScreenGui)
    ToggleShowUI.Size = UDim2.new(0, 90, 0, 30)
    ToggleShowUI.Position = UDim2.new(0, 10, 0, 40)
    ToggleShowUI.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleShowUI.Text = "Hide UI"
    ToggleShowUI.Font = Enum.Font.Code
    ToggleShowUI.TextSize = 14
    ToggleShowUI.TextColor3 = Color3.fromRGB(255, 255, 255)

    Instance.new("UICorner", ToggleShowUI).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", ToggleShowUI).Color = Color3.fromRGB(100, 100, 100)

    local ToggleLockUI = Instance.new("TextButton", ScreenGui)
    ToggleLockUI.Size = UDim2.new(0, 90, 0, 30)
    ToggleLockUI.Position = UDim2.new(0, 10, 0, 80) 
    ToggleLockUI.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleLockUI.Text = "Unlock UI"
    ToggleLockUI.Font = Enum.Font.Code
    ToggleLockUI.TextSize = 14
    ToggleLockUI.TextColor3 = Color3.fromRGB(255, 255, 255)

    Instance.new("UICorner", ToggleLockUI).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", ToggleLockUI).Color = Color3.fromRGB(100, 100, 100)
    ToggleShowUI.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLockUI.TextXAlignment = Enum.TextXAlignment.Left

    ToggleShowUI.MouseButton1Click:Connect(function()
        Window.Visible = not Window.Visible
        ToggleShowUI.Text = Window.Visible and "Hide UI" or "Show UI"
    end)

    local locked = false
    ToggleLockUI.MouseButton1Click:Connect(function()
        locked = not locked
        Window.Active = not locked
        ToggleLockUI.Text = locked and "Lock UI" or "Unlock UI"
    end)

    local Tabs = Instance.new("ScrollingFrame", Window)
    Tabs.Size = UDim2.new(0, 120, 1, -35)
    Tabs.Position = UDim2.new(0, 0, 0, 35)
    Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tabs.ScrollBarThickness = 6
    Tabs.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    Tabs.ClipsDescendants = true

    Instance.new("UIStroke", Tabs).Color = Color3.fromRGB(60, 60, 60)

    local Functions = Instance.new("ScrollingFrame", Window)
    Functions.Size = UDim2.new(1, -125, 1, -35)
    Functions.Position = UDim2.new(0, 125, 0, 35)
    Functions.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Functions.CanvasSize = UDim2.new(0, 0, 0, 0)
    Functions.ScrollBarThickness = 6
    Functions.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    Functions.ClipsDescendants = true

    Instance.new("UIStroke", Functions).Color = Color3.fromRGB(60, 60, 60)

    local LayoutTabs = Instance.new("UIListLayout", Tabs)
    LayoutTabs.FillDirection = Enum.FillDirection.Vertical
    LayoutTabs.Padding = UDim.new(0, 5)
    LayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder

    local LayoutFuncs = Instance.new("UIListLayout", Functions)
    LayoutFuncs.FillDirection = Enum.FillDirection.Vertical
    LayoutFuncs.Padding = UDim.new(0, 5)

    LayoutFuncs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Functions.CanvasSize = UDim2.new(0, 0, 0, LayoutFuncs.AbsoluteContentSize.Y + 10)
    end)

    LayoutTabs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Tabs.CanvasSize = UDim2.new(0, 0, 0, LayoutTabs.AbsoluteContentSize.Y + 10)
    end)

    UILib.Window.Tabs = Tabs
    UILib.Window.Functions = Functions
end
function UILib.Window:CreateTab(name)
    local Button = Instance.new("TextButton", self.Tabs)
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.Text = name
    Button.Font = Enum.Font.Code
    Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    Button.BackgroundTransparency = 1
    Button.TextSize = 14

    Instance.new("UIStroke", Button).Color = Color3.fromRGB(60, 60, 60)

    local Page = Instance.new("Frame", self.Functions)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false

    Button.MouseButton1Click:Connect(function()
        for _, Obj in ipairs(self.Functions:GetChildren()) do
            if Obj:IsA("Frame") then
                Obj.Visible = false
            end
        end
        Page.Visible = true
    end)

    local tabObject = { Page = Page }
    setmetatable(tabObject, { __index = UILib.Tab })
    table.insert(self.Functions:GetChildren(), Page)  
    return tabObject
end

function UILib.Tab:CreateCheckbox(name, callback)
    local CheckboxFrame = Instance.new("Frame", self.Page)
    CheckboxFrame.Size = UDim2.new(1, 0, 0, 40)
    CheckboxFrame.BackgroundTransparency = 1

    Instance.new("UIStroke", CheckboxFrame).Color = Color3.fromRGB(60, 60, 60)

    local CheckboxButton = Instance.new("TextButton", CheckboxFrame)
    CheckboxButton.Size = UDim2.new(0, 20, 0, 20)
    CheckboxButton.Position = UDim2.new(0, 5, 0.5, -10)
    CheckboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CheckboxButton.Text = ""
    CheckboxButton.AutoButtonColor = false

    Instance.new("UIStroke", CheckboxButton).Color = Color3.fromRGB(60, 60, 60)

    local Corner = Instance.new("UICorner", CheckboxButton)
    Corner.CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel", CheckboxFrame)
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.new(0, 30, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local active = false
    CheckboxButton.MouseButton1Click:Connect(function()
        active = not active
        CheckboxButton.BackgroundColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50)
        if callback then
            callback(active)
        end
    end)

    
    if not self.Page:FindFirstChild("UIListLayout") then
        local Layout = Instance.new("UIListLayout", self.Page)
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.Padding = UDim.new(0, 5)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
    end
end
function UILib.Tab:CreateButton(name, callback)
    if not self.Page:FindFirstChild("UIListLayout") then
        local Layout = Instance.new("UIListLayout", self.Page)
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.Padding = UDim.new(0, 5)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local ButtonFrame = Instance.new("Frame", self.Page)
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.BackgroundTransparency = 1

    local Stroke = Instance.new("UIStroke", ButtonFrame)
    Stroke.Color = Color3.fromRGB(60, 60, 60)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Corner = Instance.new("UICorner", ButtonFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    local Button = Instance.new("TextButton", ButtonFrame)
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = name
    Button.Font = Enum.Font.Code
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.AutoButtonColor = false

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end
function UILib.Tab:CreateInput(title, placeholder, callback)
    if not self.Page:FindFirstChild("UIListLayout") then
        local Layout = Instance.new("UIListLayout", self.Page)
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.Padding = UDim.new(0, 5)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local InputFrame = Instance.new("Frame", self.Page)
    InputFrame.Size = UDim2.new(1, 0, 0, 40)
    InputFrame.BackgroundTransparency = 1

    local Stroke = Instance.new("UIStroke", InputFrame)
    Stroke.Color = Color3.fromRGB(60, 60, 60)

    local Corner = Instance.new("UICorner", InputFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    local InputField = Instance.new("TextBox", InputFrame)
    InputField.Size = UDim2.new(1, 0, 1, 0)
    InputField.BackgroundTransparency = 1
    InputField.Text = ""
    InputField.PlaceholderText = placeholder
    InputField.Font = Enum.Font.Code
    InputField.TextSize = 14
    InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputField.TextXAlignment = Enum.TextXAlignment.Left
    InputField.ClearTextOnFocus = false

    InputField.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(InputField.Text)
        end
    end)
end
function UILib.Tab:CreateLabel(text)
    if not self.Page:FindFirstChild("UIListLayout") then
        local Layout = Instance.new("UIListLayout", self.Page)
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.Padding = UDim.new(0, 5)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local LabelFrame = Instance.new("Frame", self.Page)
    LabelFrame.Size = UDim2.new(1, 0, 0, 40)
    LabelFrame.BackgroundTransparency = 1

    local Stroke = Instance.new("UIStroke", LabelFrame)
    Stroke.Color = Color3.fromRGB(60, 60, 60)

    local Corner = Instance.new("UICorner", LabelFrame)
    Corner.CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", LabelFrame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
end
UILib.Notifications = {}

function UILib:Notify(message, duration)
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("NotificationGui") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "NotificationGui"

    local textSize = #message * 8
    local NotificationFrame = Instance.new("Frame", ScreenGui)
    NotificationFrame.Size = UDim2.new(0, math.max(120, textSize), 0, 0)
    NotificationFrame.Position = UDim2.new(0, 15, 0, 10 + (#UILib.Notifications * 40))
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

    Instance.new("UICorner", NotificationFrame).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", NotificationFrame)
    Stroke.Color = Color3.fromRGB(100, 100, 100)

    local Label = Instance.new("TextLabel", NotificationFrame)
    Label.Size = UDim2.new(1, 0, 1, -5)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = message
    Label.Font = Enum.Font.Code
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ProgressBar = Instance.new("Frame", NotificationFrame)
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 2)

    NotificationFrame:TweenSize(UDim2.new(0, math.max(120, textSize), 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3, true) 

    table.insert(UILib.Notifications, NotificationFrame)

    local step = 0
    local totalSteps = duration * 60
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        step = step + 1
        ProgressBar.Size = UDim2.new(1 - (step / totalSteps), 0, 0, 2)
        if step >= totalSteps then
            connection:Disconnect()
            NotificationFrame:TweenSize(UDim2.new(0, math.max(120, textSize), 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.3, true, function()
                NotificationFrame:Destroy()
                table.remove(UILib.Notifications, 1)
                for index, notif in ipairs(UILib.Notifications) do
                    notif.Position = UDim2.new(0, 15, 0, (index - 1) * 40 + 1)
                end
            end)
        end
    end)

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590657391"
    sound.PlaybackSpeed, sound.Volume, sound.Parent = 1, 3, workspace
    sound:Play()
    
    task.wait(1)
    sound:Destroy()
end
return UILib
