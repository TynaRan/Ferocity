local UILib = {}

UILib.Window = {}
UILib.Tab = {}

function UILib:CreateWindow(name, parent)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = name or "UI"
    ScreenGui.Parent = parent or game:GetService("CoreGui")

    local Window = Instance.new("Frame", ScreenGui)
    Window.Size = UDim2.new(0, 700, 0, 600)
    Window.Position = UDim2.new(0, 10, 0, 10)
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.Active = true
    Window.Draggable = true

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

    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 6)

    local Tabs = Instance.new("ScrollingFrame", Window)
    Tabs.Size = UDim2.new(0, 120, 1, 0)
    Tabs.Position = UDim2.new(0, 0, 0,35) 
    Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tabs.ScrollBarThickness = 6
    Tabs.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    Tabs.ClipsDescendants = true

    Instance.new("UIStroke", Tabs).Color = Color3.fromRGB(60, 60, 60)

    local Functions = Instance.new("ScrollingFrame", Window)
    Functions.Size = UDim2.new(1, -125, 1, 0)
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
    
    
    local Button = Instance.new("TextButton", self.Page)
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = name
    Button.Font = Enum.Font.Code
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.TextXAlignment = Enum.TextXAlignment.Left

    Instance.new("UIStroke", Button).Color = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end
function UILib.Tab:CreateSlider(title, min, max, default, callback)
    if not self.Page:FindFirstChild("UIListLayout") then
        local Layout = Instance.new("UIListLayout", self.Page)
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.Padding = UDim.new(0, 5)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local SliderFrame = Instance.new("Frame", self.Page)
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = title .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame", SliderFrame)
    Bar.Size = UDim2.new(1, 0, 0, 10)
    Bar.Position = UDim2.new(0, 0, 0, 25)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local Handle = Instance.new("Frame", Bar)
    Handle.Size = UDim2.new(0, 10, 1, 0)
    Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local function updateSlider(position)
        local percent = math.clamp(position.X / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percent)
        Label.Text = title .. ": " .. value
        Handle.Position = UDim2.new(percent, -5, 0, 0)
        if callback then
            callback(value)
        end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input.Position)
        end
    end)

    Bar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input.Position)
        end
    end)
end
function UILib.Tab:CreateDropdown(title, choices, defaultValue, callback)
    if not self.Page:FindFirstChild("UIListLayout") then
        local Layout = Instance.new("UIListLayout", self.Page)
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.Padding = UDim.new(0, 5)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local DropdownFrame = Instance.new("Frame", self.Page)
    DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local Label = Instance.new("TextLabel", DropdownFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = title .. ": " .. defaultValue
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local DropdownButton = Instance.new("TextButton", DropdownFrame)
    DropdownButton.Size = UDim2.new(1, 0, 0, 20)
    DropdownButton.Position = UDim2.new(0, 0, 0, 25)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropdownButton.Text = "▼ Select Option"
    DropdownButton.Font = Enum.Font.Code
    DropdownButton.TextSize = 14
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local OptionsList = Instance.new("Frame", DropdownFrame)
    OptionsList.Size = UDim2.new(1, 0, 0, #choices * 25)
    OptionsList.Position = UDim2.new(0, 0, 1, 0)
    OptionsList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    OptionsList.Visible = false

    local Layout = Instance.new("UIListLayout", OptionsList)
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.Padding = UDim.new(0, 2)

    for _, choice in ipairs(choices) do
        local OptionButton = Instance.new("TextButton", OptionsList)
        OptionButton.Size = UDim2.new(1, 0, 0, 20)
        OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        OptionButton.Text = choice
        OptionButton.Font = Enum.Font.Code
        OptionButton.TextSize = 14
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        OptionButton.MouseButton1Click:Connect(function()
            Label.Text = title .. ": " .. choice
            OptionsList.Visible = false
            if callback then
                callback(choice)
            end
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        OptionsList.Visible = not OptionsList.Visible
    end)
end
return UILib
