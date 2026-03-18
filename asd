
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
    WindowCount = 0,
    Enabled = true,
    Toggled = true,
    Keybind = Enum.KeyCode.RightControl,
    Accent = Color3.fromRGB(55, 110, 180), -- Refined Steel Blue
    Black = Color3.fromRGB(12, 12, 12),
    Charcoal = Color3.fromRGB(20, 20, 20),
    Gray = Color3.fromRGB(35, 35, 35),
    LightGray = Color3.fromRGB(55, 55, 55),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(140, 140, 140)
}

-- Safety: Check for CoreGui access
local Parent = (RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

-- Cleanup existing UI
if Parent:FindFirstChild("SteelUI") then Parent:FindFirstChild("SteelUI"):Destroy() end
if Parent:FindFirstChild("SteelKeySystem") then Parent:FindFirstChild("SteelKeySystem"):Destroy() end

local function Tween(obj, time, prop)
    if not obj then return end
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), prop)
    t:Play()
    return t
end

local function MakeDraggable(obj, dragPart)
    local dragging, dragInput, dragStart, startPos
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- Built-in Key System
function Library:InitKeySystem(config)
    local config = config or {}
    local correctKey = config.Key or "STEEL-FREE"
    local keyLink = config.Link or "https://discord.gg/steel-community"
    
    local KeyUI = Instance.new("ScreenGui")
    KeyUI.Name = "SteelKeySystem"
    KeyUI.DisplayOrder = 100
    KeyUI.Parent = Parent

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 320, 0, 250)
    Main.Position = UDim2.new(0.5, -160, 0.5, -125)
    Main.BackgroundColor3 = Library.Black
    Main.BorderSizePixel = 0
    Main.Parent = KeyUI

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local ms = Instance.new("UIStroke", Main)
    ms.Color = Library.Gray
    ms.Thickness = 1.5

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "STEEL AUTHENTICATION"
    Title.TextColor3 = Library.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.Parent = Main

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0.85, 0, 0, 40)
    Input.Position = UDim2.new(0.075, 0, 0.3, 0)
    Input.BackgroundColor3 = Library.Charcoal
    Input.Text = ""
    Input.PlaceholderText = "Enter License Key..."
    Input.TextColor3 = Library.Text
    Input.PlaceholderColor3 = Library.TextDark
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 13
    Input.Parent = Main
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Input).Color = Library.Gray

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.85, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0.52, 0)
    VerifyBtn.BackgroundColor3 = Library.Accent
    VerifyBtn.Text = "VERIFY LICENSE"
    VerifyBtn.TextColor3 = Library.Text
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 13
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.Parent = Main
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.85, 0, 0, 35)
    GetKeyBtn.Position = UDim2.new(0.075, 0, 0.75, 0)
    GetKeyBtn.BackgroundTransparency = 1
    GetKeyBtn.Text = "GET KEY / DISCORD"
    GetKeyBtn.TextColor3 = Library.TextDark
    GetKeyBtn.Font = Enum.Font.Gotham
    GetKeyBtn.TextSize = 12
    GetKeyBtn.Parent = Main

    local verified = false

    VerifyBtn.MouseButton1Click:Connect(function()
        if Input.Text == correctKey then
            verified = true
            VerifyBtn.Text = "SUCCESS"
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(45, 110, 45)
            task.wait(0.5)
            KeyUI:Destroy()
        else
            VerifyBtn.Text = "INVALID KEY"
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(110, 45, 45)
            task.delay(1.5, function()
                if VerifyBtn and VerifyBtn.Parent then
                    VerifyBtn.Text = "VERIFY LICENSE"
                    VerifyBtn.BackgroundColor3 = Library.Accent
                end
            end)
        end
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(keyLink)
                GetKeyBtn.Text = "COPIED LINK"
            end
        end)
        task.delay(1.5, function()
            if GetKeyBtn and GetKeyBtn.Parent then GetKeyBtn.Text = "GET KEY / DISCORD" end
        end)
    end)

    while not verified do
        if not KeyUI or not KeyUI.Parent then break end
        task.wait(0.1)
    end
    
    return verified
end

function Library:CreateWindow(title)
    local SteelUI = Instance.new("ScreenGui")
    SteelUI.Name = "SteelUI"
    SteelUI.IgnoreGuiInset = true
    SteelUI.Parent = Parent

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 560, 0, 390)
    Main.Position = UDim2.new(0.5, -280, 0.5, -195)
    Main.BackgroundColor3 = Library.Black
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = SteelUI

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local ms = Instance.new("UIStroke", Main)
    ms.Color = Library.Gray
    ms.Thickness = 1.2
    ms.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Library.Charcoal
    TopBar.Parent = Main

    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local filler = Instance.new("Frame")
    filler.Size = UDim2.new(1, 0, 0, 10)
    filler.Position = UDim2.new(0, 0, 1, -10)
    filler.BackgroundColor3 = Library.Charcoal
    filler.BorderSizePixel = 0
    filler.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = Library.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local ButtonHolder = Instance.new("Frame")
    ButtonHolder.Size = UDim2.new(0, 70, 1, 0)
    ButtonHolder.Position = UDim2.new(1, -75, 0, 0)
    ButtonHolder.BackgroundTransparency = 1
    ButtonHolder.Parent = TopBar

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -30, 0.5, -15)
    Close.BackgroundTransparency = 1
    Close.Text = "X"
    Close.TextColor3 = Library.TextDark
    Close.Font = Enum.Font.Gotham
    Close.TextSize = 22
    Close.Parent = ButtonHolder

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(0, 0, 0.5, -15)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Library.TextDark
    MinimizeBtn.Font = Enum.Font.Gotham
    MinimizeBtn.TextSize = 22
    MinimizeBtn.Parent = ButtonHolder

    local FloatingMin = Instance.new("TextButton")
FloatingMin.Name = "FloatingMinimize"
FloatingMin.Size = UDim2.new(0, 70, 0, 24) -- smaller + balanced pill
FloatingMin.Position = UDim2.new(1, -90, 1, -50) -- better anchored bottom-right
FloatingMin.BackgroundColor3 = Library.Charcoal
FloatingMin.BackgroundTransparency = 0.1
FloatingMin.BorderSizePixel = 0
FloatingMin.Text = "Reopen"
FloatingMin.TextColor3 = Color3.fromRGB(235, 235, 235)
FloatingMin.Font = Enum.Font.GothamMedium
FloatingMin.TextSize = 14
FloatingMin.Visible = false
FloatingMin.Parent = SteelUI

-- Perfect pill shape
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0) -- full pill
Corner.Parent = FloatingMin

-- Subtle stroke (makes it look premium)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Transparency = 0.85
Stroke.Thickness = 1
Stroke.Parent = FloatingMin

-- Padding so text isn't cramped
local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = FloatingMin

-- Smooth hover effect
FloatingMin.MouseEnter:Connect(function()
	FloatingMin.BackgroundTransparency = 0
end)

FloatingMin.MouseLeave:Connect(function()
	FloatingMin.BackgroundTransparency = 0.1
end)
    
    Instance.new("UICorner", FloatingMin).CornerRadius = UDim.new(1, 0)
    local fs = Instance.new("UIStroke", FloatingMin)
    fs.Color = Library.Gray
    fs.Thickness = 2

    local function ToggleUI()
        Library.Toggled = not Library.Toggled
        Main.Visible = Library.Toggled
        FloatingMin.Visible = not Library.Toggled
    end

    MinimizeBtn.MouseButton1Click:Connect(ToggleUI)
    FloatingMin.MouseButton1Click:Connect(ToggleUI)
    MakeDraggable(FloatingMin, FloatingMin)
    MakeDraggable(Main, TopBar)

    Close.MouseButton1Click:Connect(function() SteelUI:Destroy() end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Library.Charcoal
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, 0, 1, -10)
    TabList.Position = UDim2.new(0, 0, 0, 5)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.Parent = Sidebar

    local tl = Instance.new("UIListLayout", TabList)
    tl.Padding = UDim.new(0, 2)
    tl.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -170, 1, -50)
    Container.Position = UDim2.new(0, 170, 0, 50)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Window = { CurrentTab = nil }

    function Window:AddTab(name, icon)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Library.Black
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabList
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Parent = TabBtn

        local tcLayout = Instance.new("UIListLayout", TabContent)
        tcLayout.FillDirection = Enum.FillDirection.Horizontal
        tcLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tcLayout.Padding = UDim.new(0, 8)
        
        local Padding = Instance.new("UIPadding", TabContent)
        Padding.PaddingLeft = UDim.new(0, 10)

        if icon then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.new(0, 18, 0, 18)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = icon:find("rbxassetid://") and icon or "rbxassetid://" .. icon
            IconImg.ImageColor3 = Library.TextDark
            IconImg.Parent = TabContent
        end

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(0.8, 0, 1, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Library.TextDark
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabContent

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.ScrollBarThickness = 2
        TabFrame.ScrollBarImageColor3 = Library.Gray
        TabFrame.Parent = Container

        local tfl = Instance.new("UIListLayout", TabFrame)
        tfl.Padding = UDim.new(0, 10)
        tfl.SortOrder = Enum.SortOrder.LayoutOrder

        if not Window.CurrentTab then
            Window.CurrentTab = TabFrame
            TabFrame.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabLabel.TextColor3 = Library.Text
            if TabContent:FindFirstChildOfClass("ImageLabel") then
                TabContent:FindFirstChildOfClass("ImageLabel").ImageColor3 = Library.Accent
            end
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabList:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 1
                    local content = v:FindFirstChild("Frame")
                    if content then
                        local lbl = content:FindFirstChildOfClass("TextLabel")
                        local img = content:FindFirstChildOfClass("ImageLabel")
                        if lbl then lbl.TextColor3 = Library.TextDark end
                        if img then img.ImageColor3 = Library.TextDark end
                    end
                end
            end
            TabFrame.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabLabel.TextColor3 = Library.Text
            if TabContent:FindFirstChildOfClass("ImageLabel") then
                TabContent:FindFirstChildOfClass("ImageLabel").ImageColor3 = Library.Accent
            end
        end)

        local Tab = {}

        function Tab:AddSection(sname)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, -10, 0, 40)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabFrame

            local sLayout = Instance.new("UIListLayout", SectionFrame)
            sLayout.Padding = UDim.new(0, 6)
            sLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local st = Instance.new("TextLabel")
            st.Size = UDim2.new(1, 0, 0, 20)
            st.BackgroundTransparency = 1
            st.Text = sname:upper()
            st.TextColor3 = Library.Accent
            st.Font = Enum.Font.GothamBold
            st.TextSize = 11
            st.TextXAlignment = Enum.TextXAlignment.Left
            st.Parent = SectionFrame

            local function UpdateSize()
                SectionFrame.Size = UDim2.new(1, -10, 0, sLayout.AbsoluteContentSize.Y)
                TabFrame.CanvasSize = UDim2.new(0, 0, 0, tfl.AbsoluteContentSize.Y + 20)
            end
            sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)

            local Section = {}

            function Section:AddButton(text, callback)
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 32)
                Btn.BackgroundColor3 = Library.Charcoal
                Btn.Text = text
                Btn.TextColor3 = Library.Text
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 13
                Btn.Parent = SectionFrame
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                local s = Instance.new("UIStroke", Btn)
                s.Color = Library.Gray
                Btn.MouseButton1Click:Connect(function() pcall(callback) end)
            end

            function Section:AddToggle(text, default, callback)
                local Tgl = Instance.new("TextButton")
                Tgl.Size = UDim2.new(1, 0, 0, 32)
                Tgl.BackgroundColor3 = Library.Charcoal
                Tgl.Text = ""
                Tgl.Parent = SectionFrame
                Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 4)
                
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -40, 1, 0)
                lbl.Position = UDim2.new(0, 10, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = text
                lbl.TextColor3 = Library.Text
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 13
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = Tgl

                local box = Instance.new("Frame")
                box.Size = UDim2.new(0, 34, 0, 18)
                box.Position = UDim2.new(1, -44, 0.5, -9)
                box.BackgroundColor3 = Library.Gray
                box.Parent = Tgl
                Instance.new("UICorner", box).CornerRadius = UDim.new(1, 0)

                local dot = Instance.new("Frame")
                dot.Size = UDim2.new(0, 14, 0, 14)
                dot.Position = default and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                dot.BackgroundColor3 = default and Library.Accent or Library.TextDark
                dot.Parent = box
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

                local state = default
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(dot, 0.2, {Position = state and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = state and Library.Accent or Library.TextDark})
                    pcall(callback, state)
                end)
            end

            function Section:AddSlider(text, min, max, default, callback)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 45)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Parent = SectionFrame

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SliderFrame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(1, 0, 0, 20)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = tostring(default)
                ValLabel.TextColor3 = Library.TextDark
                ValLabel.Font = Enum.Font.Gotham
                ValLabel.TextSize = 12
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent = SliderFrame

                local Bar = Instance.new("TextButton")
                Bar.Size = UDim2.new(1, 0, 0, 6)
                Bar.Position = UDim2.new(0, 0, 0, 28)
                Bar.BackgroundColor3 = Library.Gray
                Bar.Text = ""
                Bar.AutoButtonColor = false
                Bar.Parent = SliderFrame
                Instance.new("UICorner", Bar)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Library.Accent
                Fill.Parent = Bar
                Instance.new("UICorner", Fill)

                local sliding = false
                local function move()
                    local perc = math.clamp((UIS:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * perc)
                    Fill.Size = UDim2.new(perc, 0, 1, 0)
                    ValLabel.Text = tostring(val)
                    pcall(callback, val)
                end

                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
                end)
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
                end)
                UIS.InputChanged:Connect(function(input)
                    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then move() end
                end)
            end

            function Section:AddDropdown(text, list, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = text .. "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 36)
    Dropdown.BackgroundColor3 = Library.Charcoal
    Dropdown.ClipsDescendants = true
    Dropdown.Parent = SectionFrame
    Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 5)

    local ds = Instance.new("UIStroke", Dropdown)
    ds.Color = Library.Gray
    ds.Thickness = 1

    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundTransparency = 1
    Header.Text = ""
    Header.AutoButtonColor = false
    Header.Parent = Dropdown

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = Library.Text
    Title.Font = Enum.Font.Gotham
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, -65, 1, 0)
    SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = "None"
    SelectedLabel.TextColor3 = Library.TextDark
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.TextSize = 12
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    SelectedLabel.Parent = Header

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 36, 0, 36)
    Icon.Position = UDim2.new(1, -36, 0, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = "v"
    Icon.TextColor3 = Library.TextDark
    Icon.Font = Enum.Font.Gotham
    Icon.TextSize = 12
    Icon.Parent = Header

    local OptionHolder = Instance.new("Frame")
    OptionHolder.Size = UDim2.new(1, -8, 0, 0)
    OptionHolder.Position = UDim2.new(0, 4, 0, 36)
    OptionHolder.BackgroundTransparency = 1
    OptionHolder.ClipsDescendants = true
    OptionHolder.Parent = Dropdown

    local ol = Instance.new("UIListLayout", OptionHolder)
    ol.Padding = UDim.new(0, 4)
    ol.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local open = false
    local selected = nil

    local function UpdateDropdownSize()
        task.wait() -- allow AbsoluteContentSize to update
        local size = ol.AbsoluteContentSize.Y
        OptionHolder.Size = UDim2.new(1, -8, 0, size)
        Dropdown.Size = UDim2.new(1, 0, 0, open and (36 + size + 6) or 36)
    end

    local function ToggleDropdown()
        open = not open
        Tween(Icon, 0.2, {Rotation = open and 180 or 0})
        Tween(ds, 0.2, {Color = open and Library.Accent or Library.Gray})
        UpdateDropdownSize()
    end

    Header.MouseButton1Click:Connect(ToggleDropdown)

    local DropdownFuncs = {}

    function DropdownFuncs:Refresh(newList)
        for _, v in pairs(OptionHolder:GetChildren()) do
            if v:IsA("TextButton") then
                v:Destroy()
            end
        end

        for _, v in ipairs(newList) do
            local Opt = Instance.new("TextButton")
            Opt.Size = UDim2.new(1, 0, 0, 28)
            Opt.BackgroundColor3 = Library.Black
            Opt.BackgroundTransparency = 0.8
            Opt.Text = ""
            Opt.AutoButtonColor = false
            Opt.Parent = OptionHolder
            Instance.new("UICorner", Opt).CornerRadius = UDim.new(0, 4)

            local olbl = Instance.new("TextLabel")
            olbl.Size = UDim2.new(1, -10, 1, 0)
            olbl.Position = UDim2.new(0, 10, 0, 0)
            olbl.BackgroundTransparency = 1
            olbl.Text = v
            olbl.TextColor3 = Library.TextDark
            olbl.Font = Enum.Font.Gotham
            olbl.TextSize = 12
            olbl.TextXAlignment = Enum.TextXAlignment.Left
            olbl.Parent = Opt

            Opt.MouseEnter:Connect(function()
                Tween(Opt, 0.2, {BackgroundTransparency = 0.6})
                Tween(olbl, 0.2, {TextColor3 = Library.Text})
            end)

            Opt.MouseLeave:Connect(function()
                if selected ~= v then
                    Tween(Opt, 0.2, {BackgroundTransparency = 0.8})
                    Tween(olbl, 0.2, {TextColor3 = Library.TextDark})
                end
            end)

            Opt.MouseButton1Click:Connect(function()
                selected = v
                SelectedLabel.Text = v
                ToggleDropdown()
                pcall(callback, v)

                for _, child in pairs(OptionHolder:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundTransparency = 0.8
                        local l = child:FindFirstChildOfClass("TextLabel")
                        if l then l.TextColor3 = Library.TextDark end
                    end
                end

                olbl.TextColor3 = Library.Accent
                Opt.BackgroundTransparency = 0.4
            end)
        end

        UpdateDropdownSize()
    end

    function DropdownFuncs:Set(val)
        selected = val
        SelectedLabel.Text = val
        pcall(callback, val)
    end

    DropdownFuncs:Refresh(list)
    return DropdownFuncs
end

            function Section:AddKeybind(text, default, callback)
                local BindFrame = Instance.new("Frame")
                BindFrame.Size = UDim2.new(1, 0, 0, 32)
                BindFrame.BackgroundColor3 = Library.Charcoal
                BindFrame.Parent = SectionFrame
                Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 4)

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -70, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Library.Text
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 13
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = BindFrame

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 60, 0, 20)
                BindBtn.Position = UDim2.new(1, -65, 0.5, -10)
                BindBtn.BackgroundColor3 = Library.Gray
                BindBtn.Text = default.Name
                BindBtn.TextColor3 = Library.Text
                BindBtn.Font = Enum.Font.GothamBold
                BindBtn.TextSize = 11
                BindBtn.Parent = BindFrame
                Instance.new("UICorner", BindBtn)

                local current = default
                local binding = false

                BindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    BindBtn.Text = "..."
                end)

                UIS.InputBegan:Connect(function(input, gpe)
                    if binding then
                        binding = false
                        current = input.KeyCode
                        BindBtn.Text = current.Name
                    elseif not gpe and input.KeyCode == current then
                        pcall(callback)
                    end
                end)
            end
            
            function Section:AddLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Library.TextDark
                Label.Font = Enum.Font.Gotham
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = SectionFrame
            end

            return Section
        end
        return Tab
    end
    return Window
end

return Library
