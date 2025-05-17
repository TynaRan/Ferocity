local UI = {}

function UI.Create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local coreGui = game:GetService("CoreGui")
local screenGui = UI.Create("ScreenGui", {}, coreGui)

local frame = UI.Create("Frame", {
    Size = UDim2.new(0, 700, 0, 450),
    Position = UDim2.new(0.5, -300, 0.3, 0),
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    Active = true,
    Draggable = true
}, screenGui)

UI.Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "RwandaHyper",
    TextSize = 25,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.RobotoMono
}, frame)

local divider = UI.Create("Frame", {
    Size = UDim2.new(1.005, -10, 0, 0.001),
    Position = UDim2.new(0, 1, 0, 30),
    BackgroundTransparency = 1
}, frame)

UI.Create("UIStroke", {
    Thickness = 0.35,
    Color = Color3.new(1, 1, 1),
    Transparency = 0
}, divider)

local spacer = UI.Create("Frame", {
    Size = UDim2.new(0, 0.01, 0, 420),
    Position = UDim2.new(0, 55, 0, 30),
    BackgroundTransparency = 1
}, frame)

UI.Create("UIStroke", {
    Thickness = 0.35,
    Color = Color3.new(1, 1, 1),
    Transparency = 0
}, spacer)

local scrollFrame = UI.Create("ScrollingFrame", {
    Size = UDim2.new(0, 600, 0, 360),
    Position = UDim2.new(0, 70, 0, 35),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Visible = false,
    Active = true,
    Draggable = true
}, frame)

local inputBox = UI.Create("TextBox", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    ClearTextOnFocus = false,
    MultiLine = true
}, scrollFrame)

UI.Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder
}, scrollFrame)

local executeButton = UI.Create("TextButton", {
    Size = UDim2.new(0, 120, 0, 35),
    Position = UDim2.new(0, 70, 0, 400),
    BackgroundTransparency = 1,
    Text = "Execute",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.RobotoMono,
    Visible = false
}, frame)

local clearButton = UI.Create("TextButton", {
    Size = UDim2.new(0, 120, 0, 35),
    Position = UDim2.new(0, 200, 0, 400),
    BackgroundTransparency = 1,
    Text = "Clear",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.RobotoMono,
    Visible = false
}, frame)

clearButton.MouseButton1Click:Connect(function()
    inputBox.Text = ""
end)

executeButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(inputBox.Text)()
    end)
    if not success then
        print("Execution Error: " .. err)
    end
end)

local button = UI.Create("TextButton", {
    Size = UDim2.new(0, 50, 0, 25),
    Position = UDim2.new(0, 5, 0, 35),
    BackgroundTransparency = 1,
    Text = "</>",
    TextSize = 20,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Font = Enum.Font.RobotoMono
}, frame)

button.MouseButton1Click:Connect(function()
    scrollFrame.Visible = not scrollFrame.Visible
    executeButton.Visible = not executeButton.Visible
    clearButton.Visible = not clearButton.Visible
end)

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local lineHeight = inputBox.TextSize * 1.2
    local lineCount = math.ceil(inputBox.TextBounds.Y / lineHeight)
    local minHeight = 50
    scrollFrame.CanvasSize = UDim2.new(0, 600, 0, math.max(lineCount * lineHeight, minHeight))
end)
inputBox.AutomaticSize = Enum.AutomaticSize.Y
inputBox.TextWrapped = true

UI.Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2)
}, scrollFrame)

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local textHeight = inputBox.TextBounds.Y
    local minHeight = 50
    scrollFrame.CanvasSize = UDim2.new(0, 600, 0, math.max(textHeight, minHeight))
end)
local logService = game:GetService("LogService")
local tabControl = { console = false }

local consoleFrame = UI.Create("Frame", {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0, 55, 0, 30),
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.new(0, 0, 0),
    Visible = tabControl.console
}, frame)

local consoleOutput = UI.Create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, consoleFrame)

UI.Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2)
}, consoleOutput)

local consoleToggleButton = UI.Create("TextButton", {
    Size = UDim2.new(0, 50, 0, 25),
    Position = UDim2.new(0, 5, 0, 60),
    BackgroundTransparency = 1,
    Text = ">_",
    TextSize = 20,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.RobotoMono
}, frame)

consoleToggleButton.MouseButton1Click:Connect(function()
    tabControl.console = not tabControl.console
    consoleFrame.Visible = tabControl.console
end)

logService.MessageOut:Connect(function(message, messageType)
    local logEntry = UI.Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = message,
        TextSize = 16,
        TextColor3 = (messageType == Enum.MessageType.MessageError) and Color3.new(1, 0, 0) or Color3.new(1, 1, 1),
        Font = Enum.Font.RobotoMono,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, consoleOutput)

    logEntry.MouseButton1Click:Connect(function()
        setclipboard(message)
    end)
end)
