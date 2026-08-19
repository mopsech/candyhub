--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                    CANDY ZONE EXECUTOR - FULL REWORK                      ║
    ║                         Version 3.5.0 STABLE                              ║
    ║                     Perfect Balance: 1500 Lines                           ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
]]

repeat task.wait() until game:IsLoaded()
task.wait(0.5)

print("🍬 [CANDY ZONE] Initialization started...")

--// ════════════════════════════════════════════════════════════════════════
--// SERVICES & VARIABLES
--// ════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// ════════════════════════════════════════════════════════════════════════
--// CONFIGURATION
--// ════════════════════════════════════════════════════════════════════════

local Config = {
    Version = "3.5.0",
    
    -- Colors
    Color = {
        Background = {
            Primary = Color3.fromRGB(26, 26, 26),
            Secondary = Color3.fromRGB(28, 28, 28),
            Main = Color3.fromRGB(13, 13, 13),
            Hover = Color3.fromRGB(42, 42, 42),
            Active = Color3.fromRGB(40, 40, 40),
            Input = Color3.fromRGB(18, 18, 18),
        },
        
        Accent = {
            White = Color3.fromRGB(255, 255, 255),
            Gray = Color3.fromRGB(180, 180, 180),
            DarkGray = Color3.fromRGB(100, 100, 100),
        },
        
        State = {
            Success = Color3.fromRGB(46, 204, 113),
            Warning = Color3.fromRGB(241, 196, 15),
            Error = Color3.fromRGB(231, 76, 60),
            Info = Color3.fromRGB(52, 152, 219),
        },
        
        Text = {
            Primary = Color3.fromRGB(255, 255, 255),
            Secondary = Color3.fromRGB(200, 200, 200),
            Disabled = Color3.fromRGB(120, 120, 120),
        }
    },
    
    -- Sizes
    Size = {
        TopBar = {Height = 32, Spacing = 8, Radius = 6},
        Window = {Width = 820, Height = 520, Radius = 16},
        Nav = {Width = 160, ButtonHeight = 42, Spacing = 8, Radius = 8},
        Element = {Height = 32, Spacing = 10},
        Toggle = {Width = 42, Height = 20, DotSize = 16},
        Slider = {Height = 6, HandleSize = 14},
    },
    
    -- Animation
    Anim = {
        Fast = 0.15,
        Normal = 0.25,
        Slow = 0.35,
    },
    
    -- Game Names
    Games = {
        [142823291] = "MM2",
        [2788229376] = "Da Hood",
        [286090429] = "Arsenal",
        [606849621] = "Jailbreak",
        [920587237] = "Adopt Me",
    }
}

--// ════════════════════════════════════════════════════════════════════════
--// UTILITY FUNCTIONS
--// ════════════════════════════════════════════════════════════════════════

local Util = {}

function Util:Tween(obj, props, duration, style, direction)
    if not obj then return end
    duration = duration or Config.Anim.Normal
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    tween:Play()
    return tween
end

function Util:Corner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
    return corner
end

function Util:Stroke(obj, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Config.Color.Accent.White
    stroke.Transparency = transparency or 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

function Util:Gradient(obj, colorSeq, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSeq or ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    }
    gradient.Rotation = rotation or 90
    gradient.Parent = obj
    return gradient
end

function Util:Ripple(button)
    button.ClipsDescendants = true
    
    button.MouseButton1Down:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Config.Color.Accent.White
        ripple.BackgroundTransparency = 0.5
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.ZIndex = button.ZIndex + 100
        ripple.BorderSizePixel = 0
        
        local mousePos = UserInputService:GetMouseLocation()
        local buttonPos = button.AbsolutePosition
        local relPos = mousePos - buttonPos
        
        ripple.Position = UDim2.new(0, relPos.X, 0, relPos.Y)
        ripple.Parent = button
        
        Util:Corner(ripple, 999)
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
        
        Util:Tween(ripple, {
            Size = UDim2.new(0, size, 0, size),
            BackgroundTransparency = 1
        }, 0.6, Enum.EasingStyle.Circular)
        
        task.delay(0.6, function()
            ripple:Destroy()
        end)
    end)
end

function Util:GetGameName()
    return Config.Games[game.PlaceId] or "Unknown"
end

function Util:GetPlayerName()
    local name = LocalPlayer.DisplayName or LocalPlayer.Name
    return #name > 12 and name:sub(1, 10) .. ".." or name
end

function Util:Clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

function Util:Round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

print("🔧 [CANDY ZONE] Utilities loaded")

--// ════════════════════════════════════════════════════════════════════════
--// FPS COUNTER
--// ════════════════════════════════════════════════════════════════════════

local FPS = {
    frames = 0,
    lastUpdate = tick(),
    current = 60,
    history = {},
    maxHistory = 60
}

function FPS:Update()
    self.frames = self.frames + 1
    local now = tick()
    
    if now - self.lastUpdate >= 0.5 then
        local instant = self.frames / (now - self.lastUpdate)
        table.insert(self.history, instant)
        
        if #self.history > self.maxHistory then
            table.remove(self.history, 1)
        end
        
        local sum = 0
        for _, fps in ipairs(self.history) do
            sum = sum + fps
        end
        
        self.current = math.floor(sum / #self.history)
        self.frames = 0
        self.lastUpdate = now
    end
    
    return self.current
end

function FPS:GetColor()
    if self.current >= 55 then
        return Config.Color.State.Success
    elseif self.current >= 30 then
        return Config.Color.State.Warning
    else
        return Config.Color.State.Error
    end
end

RunService.RenderStepped:Connect(function()
    FPS:Update()
end)

print("📊 [CANDY ZONE] FPS Counter initialized")

--// ════════════════════════════════════════════════════════════════════════
--// SNOW SYSTEM
--// ════════════════════════════════════════════════════════════════════════

local Snow = {
    particles = {},
    container = nil,
    active = false,
    count = 150
}

function Snow:Create(parent)
    self.container = Instance.new("Frame")
    self.container.Name = "SnowSystem"
    self.container.Size = UDim2.new(1, 0, 1, 0)
    self.container.BackgroundTransparency = 1
    self.container.ClipsDescendants = true
    self.container.ZIndex = 5
    self.container.Parent = parent
    
    for i = 1, self.count do
        local flake = Instance.new("Frame")
        flake.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local size = math.random(2, 5)
        flake.Size = UDim2.new(0, size, 0, size)
        flake.Position = UDim2.new(math.random(), 0, math.random(), 0)
        flake.BackgroundColor3 = Config.Color.Accent.White
        flake.BackgroundTransparency = math.random(60, 85) / 100
        flake.BorderSizePixel = 0
        flake.ZIndex = 6
        
        Util:Corner(flake, 999)
        flake.Parent = self.container
        
        table.insert(self.particles, {
            frame = flake,
            speed = math.random(30, 100) / 1000,
            sway = math.random(10, 25),
            offset = math.random(0, 628) / 100,
            rotation = 0,
            rotSpeed = math.random(-2, 2)
        })
    end
    
    self.active = true
    self:Animate()
    
    print("❄️ [CANDY ZONE] Snow system created")
end

function Snow:Animate()
    local time = 0
    
    RunService.RenderStepped:Connect(function(dt)
        if not self.active then return end
        time = time + dt
        
        for _, p in ipairs(self.particles) do
            if not p.frame.Parent then continue end
            
            local pos = p.frame.Position
            local newY = pos.Y.Scale + p.speed * dt
            
            if newY > 1.1 then
                p.frame.Position = UDim2.new(math.random(), 0, -0.1, 0)
            else
                local swayX = math.sin(time * 2 + p.offset) * (p.sway / 1000)
                p.frame.Position = UDim2.new(pos.X.Scale + swayX, 0, newY, 0)
            end
            
            p.rotation = p.rotation + p.rotSpeed
            p.frame.Rotation = p.rotation
        end
    end)
end

function Snow:Toggle(state)
    self.active = state
    if self.container then
        self.container.Visible = state
    end
end

function Snow:Destroy()
    self.active = false
    if self.container then
        self.container:Destroy()
    end
    self.particles = {}
end

--// ════════════════════════════════════════════════════════════════════════
--// MAIN GUI SYSTEM
--// ════════════════════════════════════════════════════════════════════════

local GUI = {
    ScreenGui = nil,
    TopBar = {},
    Main = {
        IsOpen = false,
        CurrentTab = "Home",
        Blur = nil,
        Window = nil,
        Nav = {},
        Content = nil
    }
}

function GUI:Initialize()
    print("🔨 [CANDY ZONE] Creating GUI...")
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CandyZone_" .. HttpService:GenerateGUID(false):sub(1, 8)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    
    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = CoreGui
    else
        self.ScreenGui.Parent = CoreGui
    end
    
    -- Create components
    self:CreateTopBar()
    self:CreateMainWindow()
    
    print("✅ [CANDY ZONE] GUI created successfully!")
end

--// ════════════════════════════════════════════════════════════════════════
--// TOP BAR
--// ════════════════════════════════════════════════════════════════════════

function GUI:CreateTopBar()
    local container = Instance.new("Frame")
    container.Name = "TopBar"
    container.Size = UDim2.new(0, 410, 0, Config.Size.TopBar.Height)
    container.Position = UDim2.new(0, 15, 0, 15)
    container.BackgroundTransparency = 1
    container.ZIndex = 100
    container.Parent = self.ScreenGui
    
    -- Candy Zone Button
    local candyBtn = self:CreateTopBarBlock("Candy Zone", 110, 0, true)
    candyBtn.MouseButton1Click:Connect(function()
        print("🍬 [TOP BAR] Candy Zone clicked!")
        self:ToggleMain()
    end)
    candyBtn.Parent = container
    self.TopBar.CandyBtn = candyBtn
    
    -- FPS Block
    local fpsBlock = self:CreateTopBarBlock("FPS: 60", 70, 118, false)
    fpsBlock.Parent = container
    self.TopBar.FPS = fpsBlock
    
    -- Game Block
    local gameBlock = self:CreateTopBarBlock(Util:GetGameName(), 110, 196, false)
    gameBlock.Parent = container
    self.TopBar.Game = gameBlock
    
    -- Player Block
    local playerBlock = self:CreateTopBarBlock(Util:GetPlayerName(), 120, 314, false)
    playerBlock.Parent = container
    self.TopBar.Player = playerBlock
    
    -- Start FPS Update
    task.spawn(function()
        while task.wait(0.5) do
            if self.TopBar.FPS and self.TopBar.FPS.Parent then
                local fps = FPS.current
                self.TopBar.FPS.Text = "FPS: " .. fps
                Util:Tween(self.TopBar.FPS, {TextColor3 = FPS:GetColor()}, 0.3)
            else
                break
            end
        end
    end)
    
    print("📊 [CANDY ZONE] Top Bar created")
end

function GUI:CreateTopBarBlock(text, width, xPos, isButton)
    local block = Instance.new(isButton and "TextButton" or "TextLabel")
    block.Size = UDim2.new(0, width, 0, Config.Size.TopBar.Height)
    block.Position = UDim2.new(0, xPos, 0, 0)
    block.BackgroundColor3 = Config.Color.Background.Primary
    block.BackgroundTransparency = 0.15
    block.BorderSizePixel = 0
    block.Font = Enum.Font.GothamBold
    block.Text = text
    block.TextColor3 = Config.Color.Text.Primary
    block.TextSize = 12
    block.ZIndex = 101
    
    if isButton then
        block.AutoButtonColor = false
    end
    
    Util:Corner(block, Config.Size.TopBar.Radius)
    Util:Stroke(block, 1, Config.Color.Accent.White, 0.8)
    
    -- Glow effect
    local glow = Instance.new("TextLabel")
    glow.Size = UDim2.new(1, 0, 1, 2)
    glow.Position = UDim2.new(0, 0, 0, 1)
    glow.BackgroundTransparency = 1
    glow.Font = block.Font
    glow.Text = block.Text
    glow.TextColor3 = Config.Color.Accent.White
    glow.TextSize = block.TextSize
    glow.TextTransparency = 0.85
    glow.ZIndex = 100
    glow.Parent = block
    
    if isButton then
        block.MouseEnter:Connect(function()
            Util:Tween(block, {BackgroundColor3 = Config.Color.Background.Hover}, Config.Anim.Fast)
            Util:Tween(glow, {TextTransparency = 0.65}, Config.Anim.Fast)
        end)
        
        block.MouseLeave:Connect(function()
            Util:Tween(block, {BackgroundColor3 = Config.Color.Background.Primary}, Config.Anim.Fast)
            Util:Tween(glow, {TextTransparency = 0.85}, Config.Anim.Fast)
        end)
        
        Util:Ripple(block)
    end
    
    return block
end

--// ════════════════════════════════════════════════════════════════════════
--// MAIN WINDOW
--// ════════════════════════════════════════════════════════════════════════

function GUI:CreateMainWindow()
    -- Blur Background
    self.Main.Blur = Instance.new("Frame")
    self.Main.Blur.Size = UDim2.new(1, 0, 1, 0)
    self.Main.Blur.BackgroundColor3 = Color3.new(0, 0, 0)
    self.Main.Blur.BackgroundTransparency = 1
    self.Main.Blur.Visible = false
    self.Main.Blur.ZIndex = 50
    self.Main.Blur.Parent = self.ScreenGui
    
    -- Main Window
    self.Main.Window = Instance.new("Frame")
    self.Main.Window.Size = UDim2.new(0, Config.Size.Window.Width, 0, Config.Size.Window.Height)
    self.Main.Window.Position = UDim2.new(0.5, -Config.Size.Window.Width/2, 0.5, -Config.Size.Window.Height/2)
    self.Main.Window.BackgroundColor3 = Config.Color.Background.Main
    self.Main.Window.BackgroundTransparency = 0.1
    self.Main.Window.BorderSizePixel = 0
    self.Main.Window.Visible = false
    self.Main.Window.ZIndex = 51
    self.Main.Window.Parent = self.ScreenGui
    
    Util:Corner(self.Main.Window, Config.Size.Window.Radius)
    Util:Stroke(self.Main.Window, 1.5, Config.Color.Accent.White, 0.85)
    
    -- Accent Bar
    self:CreateAccentBar()
    
    -- Snow
    Snow:Create(self.Main.Window)
    
    -- Title Bar
    self:CreateTitleBar()
    
    -- Navigation
    self:CreateNavigation()
    
    -- Content Area
    self:CreateContentArea()
    
    -- Load Home Tab
    self:LoadTab("Home")
    
    print("🪟 [CANDY ZONE] Main Window created")
end

function GUI:CreateAccentBar()
    local bar = Instance.new("Frame")
    bar.Name = "AccentBar"
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = Config.Color.Accent.White
    bar.BorderSizePixel = 0
    bar.ZIndex = 60
    bar.Parent = self.Main.Window
    
    local grad = Util:Gradient(bar, ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
    }, 90)
    
    -- Animate
    task.spawn(function()
        local offset = 0
        while self.Main.Window and self.Main.Window.Parent do
            task.wait(0.03)
            offset = offset + 0.015
            if grad and grad.Parent then
                grad.Offset = Vector2.new(0, math.sin(offset * 2) * 0.3)
            else
                break
            end
        end
    end)
end

function GUI:CreateTitleBar()
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 45)
    bar.BackgroundTransparency = 1
    bar.ZIndex = 52
    bar.Parent = self.Main.Window
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "CANDY ZONE"
    title.TextColor3 = Config.Color.Text.Primary
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 53
    title.Parent = bar
    
    -- Version
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 100, 1, 0)
    version.Position = UDim2.new(0, 140, 0, 0)
    version.BackgroundTransparency = 1
    version.Font = Enum.Font.GothamBold
    version.Text = "v" .. Config.Version
    version.TextColor3 = Config.Color.Accent.Gray
    version.TextSize = 10
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.TextTransparency = 0.4
    version.ZIndex = 53
    version.Parent = bar
    
    -- Close Button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -45, 0, 5)
    close.BackgroundColor3 = Config.Color.Background.Secondary
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.Text = "X"
    close.TextColor3 = Config.Color.Text.Primary
    close.TextSize = 16
    close.AutoButtonColor = false
    close.ZIndex = 54
    close.Parent = bar
    
    Util:Corner(close, 6)
    Util:Stroke(close, 1, Config.Color.Accent.White, 0.8)
    
    close.MouseEnter:Connect(function()
        Util:Tween(close, {BackgroundColor3 = Config.Color.State.Error}, Config.Anim.Fast)
    end)
    
    close.MouseLeave:Connect(function()
        Util:Tween(close, {BackgroundColor3 = Config.Color.Background.Secondary}, Config.Anim.Fast)
    end)
    
    close.MouseButton1Click:Connect(function()
        self:ToggleMain()
    end)
    
    Util:Ripple(close)
    
    -- Divider
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 1, -1)
    div.BackgroundColor3 = Config.Color.Accent.White
    div.BackgroundTransparency = 0.9
    div.BorderSizePixel = 0
    div.ZIndex = 52
    div.Parent = bar
end

function GUI:CreateNavigation()
    local nav = Instance.new("Frame")
    nav.Size = UDim2.new(0, Config.Size.Nav.Width, 1, -65)
    nav.Position = UDim2.new(0, 15, 0, 55)
    nav.BackgroundTransparency = 1
    nav.ZIndex = 52
    nav.Parent = self.Main.Window
    
    local tabs = {
        {name = "Home", icon = "H"},
        {name = "Visuals", icon = "V"},
        {name = "Combat", icon = "C"},
        {name = "Rage", icon = "R"},
        {name = "Fun", icon = "F"},
        {name = "Settings", icon = "S"},
        {name = "Misc", icon = "M"}
    }
    
    local yPos = 0
    
    for i, tab in ipairs(tabs) do
        local btn = self:CreateNavButton(tab.name, tab.icon, yPos, i == 1)
        btn.Parent = nav
        self.Main.Nav[tab.name] = btn
        yPos = yPos + Config.Size.Nav.ButtonHeight + Config.Size.Nav.Spacing
    end
    
    print("🧭 [CANDY ZONE] Navigation created")
end

function GUI:CreateNavButton(name, icon, yPos, isActive)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, Config.Size.Nav.ButtonHeight)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = isActive and Config.Color.Background.Active or Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 53
    
    Util:Corner(btn, Config.Size.Nav.Radius)
    Util:Stroke(btn, 0.5, Config.Color.Accent.White, 0.92)
    
    -- Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 1, -10)
    indicator.Position = UDim2.new(0, 2, 0, 5)
    indicator.BackgroundColor3 = Config.Color.Accent.White
    indicator.BorderSizePixel = 0
    indicator.Visible = isActive
    indicator.ZIndex = 54
    Util:Corner(indicator, 999)
    indicator.Parent = btn
    
    -- Icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 25, 1, 0)
    iconLbl.Position = UDim2.new(0, 12, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Text = icon
    iconLbl.TextColor3 = Config.Color.Text.Primary
    iconLbl.TextSize = 14
    iconLbl.ZIndex = 54
    iconLbl.Parent = btn
    
    -- Text
    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -45, 1, 0)
    textLbl.Position = UDim2.new(0, 40, 0, 0)
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.GothamMedium
    textLbl.Text = name
    textLbl.TextColor3 = Config.Color.Text.Primary
    textLbl.TextSize = 12
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.ZIndex = 54
    textLbl.Parent = btn
    
    -- Glow
    local glow = Instance.new("TextLabel")
    glow.Size = textLbl.Size
    glow.Position = UDim2.new(0, 40, 0, 1)
    glow.BackgroundTransparency = 1
    glow.Font = textLbl.Font
    glow.Text = textLbl.Text
    glow.TextColor3 = Config.Color.Accent.White
    glow.TextSize = textLbl.TextSize
    glow.TextXAlignment = textLbl.TextXAlignment
    glow.TextTransparency = 0.92
    glow.ZIndex = 53
    glow.Parent = btn
    
    -- Interactions
    btn.MouseEnter:Connect(function()
        if self.Main.CurrentTab ~= name then
            Util:Tween(btn, {BackgroundColor3 = Config.Color.Background.Hover}, Config.Anim.Fast)
            Util:Tween(glow, {TextTransparency = 0.75}, Config.Anim.Fast)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if self.Main.CurrentTab ~= name then
            Util:Tween(btn, {BackgroundColor3 = Config.Color.Background.Secondary}, Config.Anim.Fast)
            Util:Tween(glow, {TextTransparency = 0.92}, Config.Anim.Fast)
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    Util:Ripple(btn)
    
    return btn
end

function GUI:CreateContentArea()
    self.Main.Content = Instance.new("ScrollingFrame")
    self.Main.Content.Size = UDim2.new(1, -(Config.Size.Nav.Width + 45), 1, -75)
    self.Main.Content.Position = UDim2.new(0, Config.Size.Nav.Width + 25, 0, 60)
    self.Main.Content.BackgroundTransparency = 1
    self.Main.Content.BorderSizePixel = 0
    self.Main.Content.ScrollBarThickness = 5
    self.Main.Content.ScrollBarImageColor3 = Config.Color.Accent.White
    self.Main.Content.ScrollBarImageTransparency = 0.7
    self.Main.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Main.Content.ZIndex = 52
    self.Main.Content.Parent = self.Main.Window
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = self.Main.Content
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 5)
    pad.Parent = self.Main.Content
    
    print("📄 [CANDY ZONE] Content Area created")
end

--// ════════════════════════════════════════════════════════════════════════
--// TAB SWITCHING
--// ════════════════════════════════════════════════════════════════════════

function GUI:SwitchTab(tabName)
    if self.Main.CurrentTab == tabName then return end
    
    print("🔄 [CANDY ZONE] Switching to tab: " .. tabName)
    
    for name, btn in pairs(self.Main.Nav) do
        local indicator = btn:FindFirstChild("Indicator")
        local glow = btn:FindFirstChild("TextLabel")
        
        if name == tabName then
            Util:Tween(btn, {BackgroundColor3 = Config.Color.Background.Active}, Config.Anim.Normal)
            if indicator then indicator.Visible = true end
            if glow then Util:Tween(glow, {TextTransparency = 0.65}, Config.Anim.Fast) end
        else
            Util:Tween(btn, {BackgroundColor3 = Config.Color.Background.Secondary}, Config.Anim.Normal)
            if indicator then indicator.Visible = false end
            if glow then Util:Tween(glow, {TextTransparency = 0.92}, Config.Anim.Fast) end
        end
    end
    
    self.Main.CurrentTab = tabName
    self:LoadTab(tabName)
end

function GUI:LoadTab(tabName)
    -- Clear content
    for _, child in ipairs(self.Main.Content:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    -- Load tab content
    if tabName == "Home" then
        self:CreateHomeTab()
    elseif tabName == "Visuals" then
        self:CreateVisualsTab()
    elseif tabName == "Combat" then
        self:CreateCombatTab()
    elseif tabName == "Rage" then
        self:CreateRageTab()
    elseif tabName == "Fun" then
        self:CreateFunTab()
    elseif tabName == "Settings" then
        self:CreateSettingsTab()
    elseif tabName == "Misc" then
        self:CreateMiscTab()
    end
    
    print("✅ [CANDY ZONE] Tab loaded: " .. tabName)
end

--// ════════════════════════════════════════════════════════════════════════
--// UI ELEMENTS
--// ════════════════════════════════════════════════════════════════════════

function GUI:CreateSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 50)
    section.BackgroundColor3 = Config.Color.Background.Secondary
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.ZIndex = 53
    section.Parent = self.Main.Content
    
    Util:Corner(section, 8)
    Util:Stroke(section, 1, Config.Color.Accent.White, 0.88)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 10, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Config.Color.Text.Primary
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 54
    titleLbl.Parent = section
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 0, 0)
    container.Position = UDim2.new(0, 10, 0, 40)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ZIndex = 53
    container.Parent = section
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = container
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = section
    
    return container
end

function GUI:CreateToggle(parent, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    toggle.BackgroundColor3 = Config.Color.Background.Input
    toggle.BackgroundTransparency = 0.5
    toggle.BorderSizePixel = 0
    toggle.ZIndex = 54
    toggle.Parent = parent
    
    Util:Corner(toggle, 6)
    Util:Stroke(toggle, 0.5, Config.Color.Accent.White, 0.9)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = toggle
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, Config.Size.Toggle.Width, 0, Config.Size.Toggle.Height)
    btn.Position = UDim2.new(1, -50, 0.5, -10)
    btn.BackgroundColor3 = default and Config.Color.State.Success or Config.Color.Background.Primary
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 55
    btn.Parent = toggle
    
    Util:Corner(btn, 999)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, Config.Size.Toggle.DotSize, 0, Config.Size.Toggle.DotSize)
    dot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Config.Color.Accent.White
    dot.BorderSizePixel = 0
    dot.ZIndex = 56
    Util:Corner(dot, 999)
    dot.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        
        Util:Tween(btn, {
            BackgroundColor3 = state and Config.Color.State.Success or Config.Color.Background.Primary
        }, Config.Anim.Fast)
        
        Util:Tween(dot, {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }, Config.Anim.Normal)
        
        if callback then
            pcall(callback, state)
        end
    end)
    
    return toggle
end

function GUI:CreateSlider(parent, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 48)
    slider.BackgroundColor3 = Config.Color.Background.Input
    slider.BackgroundTransparency = 0.5
    slider.BorderSizePixel = 0
    slider.ZIndex = 54
    slider.Parent = parent
    
    Util:Corner(slider, 6)
    Util:Stroke(slider, 0.5, Config.Color.Accent.White, 0.9)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = slider
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0, 70, 0, 20)
    value.Position = UDim2.new(1, -78, 0, 6)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.Text = tostring(default)
    value.TextColor3 = Config.Color.Accent.White
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.ZIndex = 55
    value.Parent = slider
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -24, 0, Config.Size.Slider.Height)
    bg.Position = UDim2.new(0, 12, 1, -16)
    bg.BackgroundColor3 = Config.Color.Background.Primary
    bg.BorderSizePixel = 0
    bg.ZIndex = 55
    Util:Corner(bg, 999)
    bg.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.Color.Accent.White
    fill.BorderSizePixel = 0
    fill.ZIndex = 56
    Util:Corner(fill, 999)
    fill.Parent = bg
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, Config.Size.Slider.HandleSize, 0, Config.Size.Slider.HandleSize)
    handle.Position = UDim2.new(1, -7, 0.5, -7)
    handle.BackgroundColor3 = Config.Color.Accent.White
    handle.BorderSizePixel = 0
    handle.ZIndex = 57
    Util:Corner(handle, 999)
    handle.Parent = fill
    
    local dragging = false
    local currentValue = default
    
    local function update(input)
        local x = Util:Clamp(input.Position.X - bg.AbsolutePosition.X, 0, bg.AbsoluteSize.X)
        local percent = x / bg.AbsoluteSize.X
        currentValue = Util:Round(min + (max - min) * percent, 0)
        value.Text = tostring(currentValue)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        if callback then pcall(callback, currentValue) end
    end
    
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    bg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    return slider
end

function GUI:CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Config.Color.Text.Primary
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.ZIndex = 54
    btn.Parent = parent
    
    Util:Corner(btn, 6)
    local stroke = Util:Stroke(btn, 1, Config.Color.Accent.White, 0.85)
    
    btn.MouseEnter:Connect(function()
        Util:Tween(btn, {BackgroundColor3 = Config.Color.Background.Hover}, Config.Anim.Fast)
        Util:Tween(stroke, {Transparency = 0.6}, Config.Anim.Fast)
    end)
    
    btn.MouseLeave:Connect(function()
        Util:Tween(btn, {BackgroundColor3 = Config.Color.Background.Secondary}, Config.Anim.Fast)
        Util:Tween(stroke, {Transparency = 0.85}, Config.Anim.Fast)
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)
    
    Util:Ripple(btn)
    
    return btn
end

function GUI:CreateLabel(parent, labelText, valueText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 28)
    frame.BackgroundColor3 = Config.Color.Background.Input
    frame.BackgroundTransparency = 0.6
    frame.BorderSizePixel = 0
    frame.ZIndex = 54
    frame.Parent = parent
    
    Util:Corner(frame, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -12, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = labelText
    label.TextColor3 = Config.Color.Text.Secondary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = frame
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.5, -12, 1, 0)
    value.Position = UDim2.new(0.5, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.Text = valueText
    value.TextColor3 = Config.Color.Text.Primary
    value.TextSize = 10
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.ZIndex = 55
    value.Parent = frame
    
    return frame
end

--// ════════════════════════════════════════════════════════════════════════
--// TAB CONTENT
--// ════════════════════════════════════════════════════════════════════════

function GUI:CreateHomeTab()
    local welcome = self:CreateSection("Welcome to Candy Zone")
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.BackgroundTransparency = 1
    info.Font = Enum.Font.Gotham
    info.Text = [[Premium executor GUI with full compatibility.

Features: ESP, Aimbot, Speed Hacks, and much more!
Press RightShift to toggle the menu.]]
    info.TextColor3 = Config.Color.Text.Secondary
    info.TextSize = 11
    info.TextWrapped = true
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.ZIndex = 53
    info.Parent = welcome
    
    local stats = self:CreateSection("Statistics")
    self:CreateLabel(stats, "Game", Util:GetGameName())
    self:CreateLabel(stats, "Players", #Players:GetPlayers() .. " Online")
    self:CreateLabel(stats, "Version", Config.Version)
    self:CreateLabel(stats, "FPS", FPS.current)
end

function GUI:CreateVisualsTab()
    local esp = self:CreateSection("ESP Options")
    self:CreateToggle(esp, "Player ESP", false, function(s) print("[ESP] Player:", s) end)
    self:CreateToggle(esp, "Name ESP", false, function(s) print("[ESP] Name:", s) end)
    self:CreateToggle(esp, "Health ESP", false, function(s) print("[ESP] Health:", s) end)
    self:CreateToggle(esp, "Distance ESP", false, function(s) print("[ESP] Distance:", s) end)
    self:CreateSlider(esp, "ESP Distance", 0, 2000, 1000, function(v) print("[ESP] Max Distance:", v) end)
    
    local chams = self:CreateSection("Chams")
    self:CreateToggle(chams, "Enable Chams", false, function(s) print("[CHAMS] Enabled:", s) end)
    self:CreateSlider(chams, "Transparency", 0, 100, 50, function(v) print("[CHAMS] Transparency:", v) end)
    
    local other = self:CreateSection("Other Visuals")
    self:CreateToggle(other, "Tracers", false, function(s) print("[VISUAL] Tracers:", s) end)
    self:CreateToggle(other, "Skeleton ESP", false, function(s) print("[VISUAL] Skeleton:", s) end)
    self:CreateToggle(other, "Crosshair", false, function(s) print("[VISUAL] Crosshair:", s) end)
    self:CreateButton(other, "Reset All Visuals", function() print("[VISUAL] Reset All") end)
end

function GUI:CreateCombatTab()
    local aimbot = self:CreateSection("Aimbot")
    self:CreateToggle(aimbot, "Enable Aimbot", false, function(s) print("[AIMBOT] Enabled:", s) end)
    self:CreateToggle(aimbot, "Visible Check", true, function(s) print("[AIMBOT] Visible:", s) end)
    self:CreateToggle(aimbot, "Team Check", true, function(s) print("[AIMBOT] Team Check:", s) end)
    self:CreateSlider(aimbot, "FOV Size", 0, 360, 120, function(v) print("[AIMBOT] FOV:", v) end)
    self:CreateSlider(aimbot, "Smoothness", 0, 100, 50, function(v) print("[AIMBOT] Smoothness:", v) end)
    
    local silent = self:CreateSection("Silent Aim")
    self:CreateToggle(silent, "Enable Silent Aim", false, function(s) print("[SILENT] Enabled:", s) end)
    self:CreateSlider(silent, "Hit Chance", 0, 100, 80, function(v) print("[SILENT] Hit Chance:", v) end)
    
    local other = self:CreateSection("Other Combat")
    self:CreateToggle(other, "Triggerbot", false, function(s) print("[COMBAT] Triggerbot:", s) end)
    self:CreateToggle(other, "No Recoil", false, function(s) print("[COMBAT] No Recoil:", s) end)
    self:CreateToggle(other, "No Spread", false, function(s) print("[COMBAT] No Spread:", s) end)
end

function GUI:CreateRageTab()
    local speed = self:CreateSection("Speed Hacks")
    self:CreateToggle(speed, "Speed Hack", false, function(s)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16
        end
    end)
    self:CreateSlider(speed, "Walk Speed", 16, 500, 16, function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end)
    self:CreateSlider(speed, "Jump Power", 50, 500, 50, function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end)
    
    local fly = self:CreateSection("Flight")
    self:CreateToggle(fly, "Fly Mode", false, function(s) print("[FLY] Enabled:", s) end)
    self:CreateSlider(fly, "Fly Speed", 1, 100, 50, function(v) print("[FLY] Speed:", v) end)
    
    local other = self:CreateSection("Other Rage")
    self:CreateToggle(other, "Noclip", false, function(s) print("[RAGE] Noclip:", s) end)
    self:CreateToggle(other, "God Mode", false, function(s) print("[RAGE] God Mode:", s) end)
    self:CreateToggle(other, "Infinite Jump", false, function(s) print("[RAGE] Inf Jump:", s) end)
    self:CreateButton(other, "Reset Character", function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end)
end

function GUI:CreateFunTab()
    local anim = self:CreateSection("Animations")
    self:CreateButton(anim, "Play Dance", function() print("[FUN] Dance") end)
    self:CreateButton(anim, "Play Wave", function() print("[FUN] Wave") end)
    self:CreateButton(anim, "Play Sit", function() print("[FUN] Sit") end)
    
    local sound = self:CreateSection("Sound Spam")
    self:CreateToggle(sound, "Sound Spam", false, function(s) print("[FUN] Sound Spam:", s) end)
    self:CreateSlider(sound, "Volume", 0, 100, 50, function(v) print("[FUN] Volume:", v) end)
    
    local particles = self:CreateSection("Particle Effects")
    self:CreateToggle(particles, "Trail Effect", false, function(s) print("[FUN] Trail:", s) end)
    self:CreateToggle(particles, "Sparkles", false, function(s) print("[FUN] Sparkles:", s) end)
    self:CreateToggle(particles, "Fire Effect", false, function(s) print("[FUN] Fire:", s) end)
end

function GUI:CreateSettingsTab()
    local gui = self:CreateSection("GUI Settings")
    self:CreateSlider(gui, "Transparency", 0, 100, 10, function(v)
        if self.Main.Window then
            self.Main.Window.BackgroundTransparency = v / 100
        end
    end)
    self:CreateToggle(gui, "Snow Effect", true, function(s)
        Snow:Toggle(s)
    end)
    self:CreateToggle(gui, "Blur Background", true, function(s)
        print("[SETTINGS] Blur:", s)
    end)
    
    local perf = self:CreateSection("Performance")
    self:CreateSlider(perf, "FPS Cap", 60, 240, 60, function(v)
        if setfpscap then
            setfpscap(v)
        end
    end)
    self:CreateToggle(perf, "Reduce Lag", false, function(s)
        print("[SETTINGS] Reduce Lag:", s)
    end)
    
    local keys = self:CreateSection("Keybinds")
    self:CreateLabel(keys, "Toggle GUI", "RightShift")
    self:CreateLabel(keys, "Panic Key", "End")
    
    self:CreateButton(keys, "Reset All Settings", function()
        print("[SETTINGS] Reset All")
    end)
end

function GUI:CreateMiscTab()
    local util = self:CreateSection("Utilities")
    self:CreateButton(util, "Rejoin Server", function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    self:CreateButton(util, "Server Hop", function()
        print("[MISC] Server Hopping...")
    end)
    self:CreateButton(util, "Copy Game Link", function()
        if setclipboard then
            setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
            print("[MISC] Link copied!")
        end
    end)
    self:CreateButton(util, "Lower Graphics", function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        print("[MISC] Graphics lowered")
    end)
    
    local info = self:CreateSection("Information")
    self:CreateLabel(info, "Developer", "Candy Zone Team")
    self:CreateLabel(info, "Version", Config.Version)
    self:CreateLabel(info, "Discord", "discord.gg/candyzone")
    
    local credits = self:CreateSection("Credits")
    local creditText = Instance.new("TextLabel")
    creditText.Size = UDim2.new(1, -20, 0, 60)
    creditText.BackgroundTransparency = 1
    creditText.Font = Enum.Font.Gotham
    creditText.Text = [[Made with love by Candy Zone Team
Join our Discord for updates and support
Thank you for using our executor!]]
    creditText.TextColor3 = Config.Color.Text.Secondary
    creditText.TextSize = 10
    creditText.TextWrapped = true
    creditText.TextYAlignment = Enum.TextYAlignment.Top
    creditText.TextXAlignment = Enum.TextXAlignment.Center
    creditText.TextTransparency = 0.3
    creditText.ZIndex = 53
    creditText.Parent = credits
end

--// ════════════════════════════════════════════════════════════════════════
--// TOGGLE MAIN WINDOW
--// ════════════════════════════════════════════════════════════════════════

function GUI:ToggleMain()
    self.Main.IsOpen = not self.Main.IsOpen
    
    print("🍬 [CANDY ZONE] Toggle Main! IsOpen: " .. tostring(self.Main.IsOpen))
    
    if self.Main.IsOpen then
        self.Main.Blur.Visible = true
        self.Main.Window.Visible = true
        
        Util:Tween(self.Main.Blur, {BackgroundTransparency = 0.2}, Config.Anim.Slow)
        
        self.Main.Window.Position = UDim2.new(0.5, -Config.Size.Window.Width/2, 1.5, 0)
        Util:Tween(self.Main.Window, {
            Position = UDim2.new(0.5, -Config.Size.Window.Width/2, 0.5, -Config.Size.Window.Height/2)
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        print("✅ [CANDY ZONE] GUI OPENED!")
    else
        Util:Tween(self.Main.Blur, {BackgroundTransparency = 1}, Config.Anim.Normal)
        Util:Tween(self.Main.Window, {
            Position = UDim2.new(0.5, -Config.Size.Window.Width/2, 1.5, 0)
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        
        task.wait(0.4)
        self.Main.Blur.Visible = false
        self.Main.Window.Visible = false
        
        print("✅ [CANDY ZONE] GUI CLOSED!")
    end
end

--// ════════════════════════════════════════════════════════════════════════
--// KEYBINDS
--// ════════════════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        print("🔑 [CANDY ZONE] RightShift pressed!")
        GUI:ToggleMain()
    elseif input.KeyCode == Enum.KeyCode.End then
        print("⚠️ [CANDY ZONE] Panic key pressed! Destroying...")
        GUI.ScreenGui:Destroy()
        Snow:Destroy()
    end
end)

--// ════════════════════════════════════════════════════════════════════════
--// INITIALIZATION
--// ════════════════════════════════════════════════════════════════════════

GUI:Initialize()

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "🍬 Candy Zone Loaded",
        Text = "Press RightShift to open",
        Duration = 5
    })
end)

print("═══════════════════════════════════════════════════════════")
print("🍬 CANDY ZONE EXECUTOR v" .. Config.Version)
print("✅ Successfully Loaded!")
print("🎮 Game: " .. Util:GetGameName())
print("⌨️ Toggle: RightShift | Panic: End")
print("═══════════════════════════════════════════════════════════")
