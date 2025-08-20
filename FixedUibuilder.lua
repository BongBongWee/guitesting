local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local SimpleUI = {}
SimpleUI.Theme = {
    ToggleOn = Color3.fromRGB(255, 75, 75),
    ToggleOff = Color3.fromRGB(40, 40, 40),
    Background = Color3.fromRGB(25, 25, 30),
    Tab = Color3.fromRGB(50, 50, 55),
    TabActive = Color3.fromRGB(100, 50, 150),
    Button = Color3.fromRGB(0, 120, 200),
    ButtonText = Color3.fromRGB(255, 255, 255),
    SliderBar = Color3.fromRGB(70, 70, 70),
    SliderFill = Color3.fromRGB(255, 75, 75),
    Dropdown = Color3.fromRGB(60, 60, 60),
    DropdownOption = Color3.fromRGB(80, 80, 80)
}

function SimpleUI:SetTheme(themeTable)
    for k,v in pairs(themeTable) do
        if self.Theme[k] then
            self.Theme[k] = v
        end
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
    Frame.Size = UDim2.new(0, 600, 0, 420)
    Frame.Position = UDim2.new(0.25, 0, 0.2, 0)
    Frame.BackgroundColor3 = SimpleUI.Theme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.Active = true
    Frame.Draggable = true

    local TopBar = Instance.new("TextLabel")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = SimpleUI.Theme.Tab
    TopBar.Text = settings.menuname or "Menu"
    TopBar.TextColor3 = Color3.fromRGB(255,255,255)
    TopBar.Font = Enum.Font.GothamBold
    TopBar.TextScaled = true
    TopBar.Parent = Frame

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(0, 140, 1, -40)
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = TabHolder

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
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BackgroundColor3 = SimpleUI.Theme.Tab
        Tab.Font = Enum.Font.GothamBold
        Tab.TextScaled = true
        Tab.Parent = TabHolder

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 6
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = ContentFrame

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 8)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = Page

        Tabs[tabName] = Page

        Tab.MouseButton1Click:Connect(function()
            for _, p in pairs(ContentFrame:GetChildren()) do
                if p:IsA("ScrollingFrame") then
                    p.Visible = false
                end
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
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -10, 0, 40)
        Container.BackgroundTransparency = 1
        Container.Parent = tabPage

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.Font = Enum.Font.GothamBold
        Label.TextScaled = true
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.Parent = Container

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0.25, 0, 0.8, 0)
        Toggle.Position = UDim2.new(0.72, 0, 0.1, 0)
        Toggle.Text = ""
        Toggle.BackgroundColor3 = SimpleUI.Theme.ToggleOff
        Toggle.Parent = Container

        local state = false
        local enabled = true

        Toggle.MouseButton1Click:Connect(function()
            if not enabled then return end
            state = not state
            Toggle.BackgroundColor3 = state and SimpleUI.Theme.ToggleOn or SimpleUI.Theme.ToggleOff
            if callback then callback(state) end
        end)

        return {
            Set = function(val)
                state = val
                Toggle.BackgroundColor3 = state and SimpleUI.Theme.ToggleOn or SimpleUI.Theme.ToggleOff
            end,
            Disable = function()
                enabled = false
                Toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
            end,
            Enable = function()
                enabled = true
                Toggle.BackgroundColor3 = state and SimpleUI.Theme.ToggleOn or SimpleUI.Theme.ToggleOff
            end
        }
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
        Label.BackgroundTransparency = 1
        Label.Text = name .. " ("..default..")"
        Label.Font = Enum.Font.GothamBold
        Label.TextScaled = true
        Label.TextColor3 = Color3.fromRGB(255,255,255)
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

        local Value = default

        local function update(val)
            Value = math.clamp(val, min, max)
            Fill.Size = UDim2.new((Value-min)/(max-min), 0, 1, 0)
            Label.Text = name.." ("..math.floor(Value)..")"
            if callback then callback(Value) end
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local moveConn, releaseConn
                moveConn = UserInputService.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local relX = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        update(min + (max-min)*relX)
                    end
                end)
                releaseConn = UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        moveConn:Disconnect()
                        releaseConn:Disconnect()
                    end
                end)
            end
        end)

        update(default)
    end

    function Window:CreateDropdown(tabPage, name, options, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -10, 0, 40)
        Frame.BackgroundColor3 = SimpleUI.Theme.Dropdown
        Frame.Parent = tabPage

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.Font = Enum.Font.GothamBold
        Label.TextScaled = true
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.Parent = Frame

        local DropButton = Instance.new("TextButton")
        DropButton.Size = UDim2.new(1, 0, 0, 20)
        DropButton.Position = UDim2.new(0, 0, 0, 20)
        DropButton.Text = "Select..."
        DropButton.Font = Enum.Font.Gotham
        DropButton.TextScaled = true
        DropButton.TextColor3 = Color3.fromRGB(255,255,255)
        DropButton.BackgroundColor3 = SimpleUI.Theme.DropdownOption
        DropButton.Parent = Frame

        local Open = false
        local OptionHolder

        DropButton.MouseButton1Click:Connect(function()
            if Open then
                if OptionHolder then OptionHolder:Destroy() end
                Open = false
                return
            end
            OptionHolder = Instance.new("Frame")
            OptionHolder.Size = UDim2.new(1, 0, 0, #options * 25)
            OptionHolder.Position = UDim2.new(0, 0, 1, 0)
            OptionHolder.BackgroundColor3 = SimpleUI.Theme.DropdownOption
            OptionHolder.Parent = Frame

            local Layout = Instance.new("UIListLayout")
            Layout.Parent = OptionHolder

            for _, opt in ipairs(options) do
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 25)
                Btn.Text = opt
                Btn.Font = Enum.Font.Gotham
                Btn.TextScaled = true
                Btn.TextColor3 = Color3.fromRGB(255,255,255)
                Btn.BackgroundTransparency = 1
                Btn.Parent = OptionHolder

                Btn.MouseButton1Click:Connect(function()
                    DropButton.Text = opt
                    if callback then callback(opt) end
                    OptionHolder:Destroy()
                    Open = false
                end)
            end
            Open = true
        end)
    end

    if settings.keybind then
        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode[settings.keybind:upper()] then
                Frame.Visible = not Frame.Visible
            end
        end)
    end

    return Window
end

return SimpleUI
