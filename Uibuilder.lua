local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local SimpleUI = {}

SimpleUI.Theme = {
    Background = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(140, 90, 255),
    Tab = Color3.fromRGB(40, 40, 55),
    TabActive = Color3.fromRGB(140, 90, 255),
    ToggleOn = Color3.fromRGB(90, 255, 90),
    ToggleOff = Color3.fromRGB(70, 70, 70),
    Button = Color3.fromRGB(70, 140, 255),
    ButtonText = Color3.fromRGB(255, 255, 255),
    SliderBar = Color3.fromRGB(50, 50, 60),
    SliderFill = Color3.fromRGB(140, 90, 255),
    Dropdown = Color3.fromRGB(50, 50, 60),
    Text = Color3.fromRGB(230, 230, 230),
}

function SimpleUI:SetTheme(themeTable)
    for k,v in pairs(themeTable) do
        if self.Theme[k] then self.Theme[k] = v end
    end
end

function SimpleUI:CreateWindow(settings)
    local Window = {}
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 600, 0, 450)
    Frame.Position = UDim2.new(0.25, 0, 0.2, 0)
    Frame.BackgroundColor3 = SimpleUI.Theme.Background
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    local TopBar = Instance.new("TextLabel")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = SimpleUI.Theme.Accent
    TopBar.Text = settings.menuname or "SimpleUI Menu"
    TopBar.TextColor3 = Color3.fromRGB(255,255,255)
    TopBar.Font = Enum.Font.GothamBold
    TopBar.TextScaled = true
    TopBar.Parent = Frame

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0, 140, 1, -40)
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Frame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabHolder

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -140, 1, -40)
    ContentFrame.Position = UDim2.new(0, 140, 0, 40)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = Frame

    local Tabs = {}

    function Window:CreateTab(tabName)
        local Tab = Instance.new("TextButton")
        Tab.Size = UDim2.new(1, -10, 0, 40)
        Tab.Text = tabName
        Tab.TextColor3 = SimpleUI.Theme.Text
        Tab.BackgroundColor3 = SimpleUI.Theme.Tab
        Tab.Font = Enum.Font.GothamBold
        Tab.TextScaled = true
        Tab.Parent = TabHolder

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 6
        Page.Visible = false
        Page.Parent = ContentFrame

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 8)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = Page

        Tabs[tabName] = Page

        Tab.MouseButton1Click:Connect(function()
            for _, p in pairs(ContentFrame:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible = false end
            end
            for _, b in pairs(TabHolder:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = SimpleUI.Theme.Tab
                end
            end
            Page.Visible = true
            Tab.BackgroundColor3 = SimpleUI.Theme.TabActive
        end)

        return Page
    end

    function Window:CreateToggle(tabPage, name, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -10, 0, 40)
        Frame.BackgroundTransparency = 1
        Frame.Parent = tabPage

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Text = name
        Label.Font = Enum.Font.GothamBold
        Label.TextScaled = true
        Label.TextColor3 = SimpleUI.Theme.Text
        Label.BackgroundTransparency = 1
        Label.Parent = Frame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0.25, 0, 0.7, 0)
        Switch.Position = UDim2.new(0.72, 0, 0.15, 0)
        Switch.BackgroundColor3 = SimpleUI.Theme.ToggleOff
        Switch.Text = ""
        Switch.Parent = Frame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Switch

        local state = false
        Switch.MouseButton1Click:Connect(function()
            state = not state
            Switch.BackgroundColor3 = state and SimpleUI.Theme.ToggleOn or SimpleUI.Theme.ToggleOff
            if callback then callback(state) end
        end)
    end

    function Window:CreateButton(tabPage, name, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.Text = name
        Btn.Font = Enum.Font.GothamBold
        Btn.TextScaled = true
        Btn.TextColor3 = SimpleUI.Theme.ButtonText
        Btn.BackgroundColor3 = SimpleUI.Theme.Button
        Btn.Parent = tabPage

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end

    function Window:CreateSlider(tabPage, name, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -10, 0, 60)
        Frame.BackgroundTransparency = 1
        Frame.Parent = tabPage

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Text = name .. " ("..default..")"
        Label.Font = Enum.Font.GothamBold
        Label.TextScaled = true
        Label.TextColor3 = SimpleUI.Theme.Text
        Label.BackgroundTransparency = 1
        Label.Parent = Frame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, -20, 0, 15)
        Bar.Position = UDim2.new(0, 10, 0, 35)
        Bar.BackgroundColor3 = SimpleUI.Theme.SliderBar
        Bar.Parent = Frame

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = SimpleUI.Theme.SliderFill
        Fill.Parent = Bar

        local dragging = false
        local function update(x)
            local relX = math.clamp((x - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max-min) * relX)
            Fill.Size = UDim2.new(relX, 0, 1, 0)
            Label.Text = name .. " ("..value..")"
            if callback then callback(value) end
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(UserInputService:GetMouseLocation().X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(UserInputService:GetMouseLocation().X)
            end
        end)
    end

    function Window:CreateDropdown(tabPage, name, options, callback)
        local Open = false
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -10, 0, 40)
        Btn.Text = name.." ▼"
        Btn.Font = Enum.Font.GothamBold
        Btn.TextScaled = true
        Btn.TextColor3 = SimpleUI.Theme.Text
        Btn.BackgroundColor3 = SimpleUI.Theme.Dropdown
        Btn.Parent = tabPage

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Btn

        local List = Instance.new("Frame")
        List.Size = UDim2.new(1, -10, 0, #options*35)
        List.BackgroundColor3 = SimpleUI.Theme.Background
        List.Visible = false
        List.Parent = tabPage

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 5)
        Layout.Parent = List

        for _, opt in pairs(options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, -10, 0, 30)
            OptBtn.Text = opt
            OptBtn.TextScaled = true
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextColor3 = SimpleUI.Theme.Text
            OptBtn.BackgroundColor3 = SimpleUI.Theme.Tab
            OptBtn.Parent = List
            OptBtn.MouseButton1Click:Connect(function()
                Btn.Text = name.." : "..opt
                List.Visible = false
                Open = false
                if callback then callback(opt) end
            end)
        end

        Btn.MouseButton1Click:Connect(function()
            Open = not Open
            List.Visible = Open
        end)
    end

    local defaultTabs = {"Main","Visuals","Player","Extras","Mods","Settings"}
    for _, t in ipairs(defaultTabs) do Window:CreateTab(t) end
    Tabs[defaultTabs[1]].Visible = true
    TabHolder:GetChildren()[1].BackgroundColor3 = SimpleUI.Theme.TabActive

    if settings.keybind then
        UserInputService.InputBegan:Connect(function(input,gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode[settings.keybind:upper()] then
                Frame.Visible = not Frame.Visible
            end
        end)
    end

    return Window
end

return SimpleUI
