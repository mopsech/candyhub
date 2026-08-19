--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                    CANDY ZONE EXECUTOR - MM2 EDITION                      ║
    ║                      Version 0.1 Pre-Release                              ║
    ║                         by mopsech                                        ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
]]

repeat task.wait() until game:IsLoaded()
task.wait(0.5)

print("🍬 [CANDY ZONE MM2] Initialization started...")

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

--// ════════════════════════════════════════════════════════════════════════
--// CONFIGURATION
--// ════════════════════════════════════════════════════════════════════════

local Config = {
    Version = "0.1 Pre-Release",
    Developer = "mopsech",
    Discord = "discord.gg/3KjWyZ6uBu",
    
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
    
    -- Sizes (75% of screen)
    Size = {
        TopBar = {Height = 32, Spacing = 8, Radius = 6},
        Window = {Width = 615, Height = 390, Radius = 16}, -- 75% of 820x520
        Nav = {Width = 140, ButtonHeight = 38, Spacing = 8, Radius = 8},
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
    
    -- Settings Storage
    Settings = {
        Keybinds = {
            ToggleGUI = Enum.KeyCode.RightShift,
            PanicKey = Enum.KeyCode.End,
            Camlock = Enum.KeyCode.Q,
            SilentAim = Enum.KeyCode.E,
        },
        
        Colors = {
            ForceField = Color3.fromRGB(0, 255, 255),
            TargetESP = Color3.fromRGB(255, 0, 0),
            AuraTrail = Color3.fromRGB(255, 255, 0),
        }
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
    return game.PlaceId == 142823291 and "MM2" or "MMV"
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
    count = 120
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
        CurrentTab = "Visuals",
        Blur = nil,
        Window = nil,
        Nav = {},
        Content = nil
    }
}

function GUI:Initialize()
    print("🔨 [CANDY ZONE] Creating GUI...")
    
    -- Create ScreenGui with TopMost
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CandyZoneMM2_" .. HttpService:GenerateGUID(false):sub(1, 8)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.DisplayOrder = 999999999 -- TopMost
    
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
    
    -- Load Visuals Tab
    self:LoadTab("Visuals")
    
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
    title.Text = "CANDY ZONE MM2"
    title.TextColor3 = Config.Color.Text.Primary
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 53
    title.Parent = bar
    
    -- Version
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 120, 1, 0)
    version.Position = UDim2.new(0, 160, 0, 0)
    version.BackgroundTransparency = 1
    version.Font = Enum.Font.GothamBold
    version.Text = "v" .. Config.Version
    version.TextColor3 = Config.Color.Accent.Gray
    version.TextSize = 9
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.TextTransparency = 0.4
    version.ZIndex = 53
    version.Parent = bar
    
    -- Close Button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -40, 0, 7)
    close.BackgroundColor3 = Config.Color.Background.Secondary
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.Text = "X"
    close.TextColor3 = Config.Color.Text.Primary
    close.TextSize = 14
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
    btn.Text = "" -- NO TEXT ON BUTTON
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
    textLbl.TextSize = 11
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
    self.Main.Content.Size = UDim2.new(1, -(Config.Size.Nav.Width + 40), 1, -75)
    self.Main.Content.Position = UDim2.new(0, Config.Size.Nav.Width + 20, 0, 60)
    self.Main.Content.BackgroundTransparency = 1
    self.Main.Content.BorderSizePixel = 0
    self.Main.Content.ScrollBarThickness = 5
    self.Main.Content.ScrollBarImageColor3 = Config.Color.Accent.White
    self.Main.Content.ScrollBarImageTransparency = 0.7
    self.Main.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Main.Content.ZIndex = 52
    self.Main.Content.Parent = self.Main.Window
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
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
    if tabName == "Visuals" then
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
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Config.Color.Background.Secondary
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.ZIndex = 53
    section.Parent = self.Main.Content
    
    Util:Corner(section, 8)
    Util:Stroke(section, 1, Config.Color.Accent.White, 0.88)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 25)
    titleLbl.Position = UDim2.new(0, 10, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title
    titleLbl.TextColor3 = Config.Color.Text.Primary
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 54
    titleLbl.Parent = section
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -20, 0, 0)
    container.Position = UDim2.new(0, 10, 0, 32)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ZIndex = 53
    container.Parent = section
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = container
    
    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 8)
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
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = toggle
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, Config.Size.Toggle.Width, 0, Config.Size.Toggle.Height)
    btn.Position = UDim2.new(1, -45, 0.5, -10)
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
    slider.Size = UDim2.new(1, 0, 0, 44)
    slider.BackgroundColor3 = Config.Color.Background.Input
    slider.BackgroundTransparency = 0.5
    slider.BorderSizePixel = 0
    slider.ZIndex = 54
    slider.Parent = parent
    
    Util:Corner(slider, 6)
    Util:Stroke(slider, 0.5, Config.Color.Accent.White, 0.9)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = slider
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0, 60, 0, 18)
    value.Position = UDim2.new(1, -68, 0, 4)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.Text = tostring(default)
    value.TextColor3 = Config.Color.Accent.White
    value.TextSize = 10
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.ZIndex = 55
    value.Parent = slider
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, Config.Size.Slider.Height)
    bg.Position = UDim2.new(0, 10, 1, -14)
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
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = text -- KEEP TEXT FOR BUTTONS
    btn.TextColor3 = Config.Color.Text.Primary
    btn.TextSize = 11
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

function GUI:CreateColorPicker(parent, text, defaultColor, callback)
    local picker = Instance.new("Frame")
    picker.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    picker.BackgroundColor3 = Config.Color.Background.Input
    picker.BackgroundTransparency = 0.5
    picker.BorderSizePixel = 0
    picker.ZIndex = 54
    picker.Parent = parent
    
    Util:Corner(picker, 6)
    Util:Stroke(picker, 0.5, Config.Color.Accent.White, 0.9)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = picker
    
    local colorBox = Instance.new("TextButton")
    colorBox.Size = UDim2.new(0, 35, 0, 20)
    colorBox.Position = UDim2.new(1, -45, 0.5, -10)
    colorBox.BackgroundColor3 = defaultColor
    colorBox.BorderSizePixel = 0
    colorBox.Text = ""
    colorBox.AutoButtonColor = false
    colorBox.ZIndex = 55
    Util:Corner(colorBox, 4)
    colorBox.Parent = picker
    
    colorBox.MouseButton1Click:Connect(function()
        -- Color picker UI would open here
        print("[COLOR PICKER] " .. text)
        if callback then pcall(callback, defaultColor) end
    end)
    
    return picker
end

function GUI:CreateLabel(parent, labelText, valueText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundColor3 = Config.Color.Background.Input
    frame.BackgroundTransparency = 0.6
    frame.BorderSizePixel = 0
    frame.ZIndex = 54
    frame.Parent = parent
    
    Util:Corner(frame, 6)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = labelText
    label.TextColor3 = Config.Color.Text.Secondary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = frame
    
    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.5, -10, 1, 0)
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

function GUI:CreateKeybindButton(parent, text, defaultKey, callback)
    local keybind = Instance.new("Frame")
    keybind.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    keybind.BackgroundColor3 = Config.Color.Background.Input
    keybind.BackgroundTransparency = 0.5
    keybind.BorderSizePixel = 0
    keybind.ZIndex = 54
    keybind.Parent = parent
    
    Util:Corner(keybind, 6)
    Util:Stroke(keybind, 0.5, Config.Color.Accent.White, 0.9)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = keybind
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 24)
    btn.Position = UDim2.new(1, -85, 0.5, -12)
    btn.BackgroundColor3 = Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = defaultKey.Name
    btn.TextColor3 = Config.Color.Text.Primary
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.ZIndex = 55
    Util:Corner(btn, 4)
    btn.Parent = keybind
    
    local listening = false
    
    btn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        btn.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                btn.Text = input.KeyCode.Name
                if callback then pcall(callback, input.KeyCode) end
                listening = false
                connection:Disconnect()
            end
        end)
    end)
    
    return keybind
end

function GUI:CreateDropdown(parent, text, options, defaultOption, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    dropdown.BackgroundColor3 = Config.Color.Background.Input
    dropdown.BackgroundTransparency = 0.5
    dropdown.BorderSizePixel = 0
    dropdown.ZIndex = 54
    dropdown.Parent = parent
    
    Util:Corner(dropdown, 6)
    Util:Stroke(dropdown, 0.5, Config.Color.Accent.White, 0.9)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Config.Color.Text.Primary
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 55
    label.Parent = dropdown
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 24)
    btn.Position = UDim2.new(1, -95, 0.5, -12)
    btn.BackgroundColor3 = Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.Text = defaultOption
    btn.TextColor3 = Config.Color.Text.Primary
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.ZIndex = 55
    Util:Corner(btn, 4)
    btn.Parent = dropdown
    
    local currentIndex = 1
    for i, opt in ipairs(options) do
        if opt == defaultOption then
            currentIndex = i
            break
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then
            currentIndex = 1
        end
        
        btn.Text = options[currentIndex]
        if callback then pcall(callback, options[currentIndex]) end
    end)
    
    return dropdown
end

--// ════════════════════════════════════════════════════════════════════════
--// TAB CONTENT
--// ════════════════════════════════════════════════════════════════════════

function GUI:CreateVisualsTab()
    -- ESP Section
    local esp = self:CreateSection("ESP")
    self:CreateToggle(esp, "Highlight Inn", false, function(s) print("[ESP] Inn:", s) end)
    self:CreateToggle(esp, "Highlight Sheriff", false, function(s) print("[ESP] Sheriff:", s) end)
    self:CreateToggle(esp, "Highlight Hero", false, function(s) print("[ESP] Hero:", s) end)
    self:CreateToggle(esp, "Highlight Murder", false, function(s) print("[ESP] Murder:", s) end)
    
    -- Player Section
    local player = self:CreateSection("Player")
    self:CreateToggle(player, "ForceField", false, function(s) print("[PLAYER] ForceField:", s) end)
    self:CreateColorPicker(player, "ForceField Color", Config.Settings.Colors.ForceField, function(c)
        Config.Settings.Colors.ForceField = c
        print("[PLAYER] ForceField Color changed")
    end)
    
    self:CreateToggle(player, "Target ESP", false, function(s) print("[PLAYER] Target ESP:", s) end)
    self:CreateColorPicker(player, "Target ESP Color", Config.Settings.Colors.TargetESP, function(c)
        Config.Settings.Colors.TargetESP = c
        print("[PLAYER] Target ESP Color changed")
    end)
    
    self:CreateToggle(player, "Aura Trail", false, function(s) print("[PLAYER] Aura Trail:", s) end)
    self:CreateColorPicker(player, "Aura Trail Color", Config.Settings.Colors.AuraTrail, function(c)
        Config.Settings.Colors.AuraTrail = c
        print("[PLAYER] Aura Trail Color changed")
    end)
end

function GUI:CreateCombatTab()
    -- Camlock Aim Section
    local camlock = self:CreateSection("Camlock Aim")
    self:CreateToggle(camlock, "Camlock Aim", false, function(s) print("[CAMLOCK] Enabled:", s) end)
    self:CreateSlider(camlock, "FOV", 0, 360, 120, function(v) print("[CAMLOCK] FOV:", v) end)
    self:CreateSlider(camlock, "Predict", 0, 200, 100, function(v) print("[CAMLOCK] Predict:", v) end)
    self:CreateToggle(camlock, "Visible Check", true, function(s) print("[CAMLOCK] Visible:", s) end)
    self:CreateSlider(camlock, "Smoothness", 0, 100, 50, function(v) print("[CAMLOCK] Smoothness:", v) end)
    self:CreateToggle(camlock, "Predict", true, function(s) print("[CAMLOCK] Predict Toggle:", s) end)
    
    -- Silent Aim Section
    local silent = self:CreateSection("Silent Aim")
    self:CreateToggle(silent, "Silent Aim", false, function(s) print("[SILENT] Enabled:", s) end)
    self:CreateSlider(silent, "FOV", 0, 360, 120, function(v) print("[SILENT] FOV:", v) end)
    self:CreateSlider(silent, "Predict", 0, 200, 100, function(v) print("[SILENT] Predict:", v) end)
    self:CreateToggle(silent, "Visible Check", true, function(s) print("[SILENT] Visible:", s) end)
    self:CreateToggle(silent, "Predict", true, function(s) print("[SILENT] Predict Toggle:", s) end)
    
    -- Buttons Section
    local buttons = self:CreateSection("Buttons")
    self:CreateToggle(buttons, "Auto Shoot", false, function(s) print("[AUTO] Auto Shoot:", s) end)
    self:CreateSlider(buttons, "Predict", 0, 200, 100, function(v) print("[AUTO] Predict:", v) end)
end

function GUI:CreateRageTab()
    local rage = self:CreateSection("Rage Features")
    
    self:CreateToggle(rage, "SpinBot", false, function(s) print("[RAGE] SpinBot:", s) end)
    self:CreateSlider(rage, "SpinBot Speed", 1, 100, 50, function(v) print("[RAGE] Spin Speed:", v) end)
    
    self:CreateToggle(rage, "Bhop", false, function(s) print("[RAGE] Bhop:", s) end)
    self:CreateSlider(rage, "Bhop Height", 1, 50, 10, function(v) print("[RAGE] Bhop Height:", v) end)
    
    self:CreateToggle(rage, "Noclip", false, function(s) print("[RAGE] Noclip:", s) end)
    
    self:CreateToggle(rage, "Fly", false, function(s) print("[RAGE] Fly:", s) end)
end

function GUI:CreateFunTab()
    -- Fling Section
    local fling = self:CreateSection("Fling")
    
    -- Scan all players and create buttons
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateButton(fling, player.Name, function()
                print("[FLING] Flinging: " .. player.Name)
                -- Fling logic goes here (you'll implement)
            end)
        end
    end
    
    -- HitSound Section
    local hitsound = self:CreateSection("HitSound")
    self:CreateDropdown(hitsound, "HitSound", {
        "None",
        "Neverlose",
        "Skeet",
        "Bonk",
        "Pop"
    }, "None", function(sound)
        print("[HITSOUND] Selected:", sound)
    end)
end

function GUI:CreateSettingsTab()
    -- GUI Settings
    local gui = self:CreateSection("GUI Settings")
    self:CreateSlider(gui, "Transparency", 0, 100, 10, function(v)
        if self.Main.Window then
            self.Main.Window.BackgroundTransparency = v / 100
        end
    end)
    self:CreateToggle(gui, "Snow Effect", true, function(s)
        Snow:Toggle(s)
    end)
    
    -- Keybinds
    local keys = self:CreateSection("Keybinds")
    self:CreateKeybindButton(keys, "Toggle GUI", Config.Settings.Keybinds.ToggleGUI, function(key)
        Config.Settings.Keybinds.ToggleGUI = key
        print("[KEYBIND] Toggle GUI:", key.Name)
    end)
    
    self:CreateKeybindButton(keys, "Panic Key", Config.Settings.Keybinds.PanicKey, function(key)
        Config.Settings.Keybinds.PanicKey = key
        print("[KEYBIND] Panic Key:", key.Name)
    end)
    
    self:CreateKeybindButton(keys, "Camlock", Config.Settings.Keybinds.Camlock, function(key)
        Config.Settings.Keybinds.Camlock = key
        print("[KEYBIND] Camlock:", key.Name)
    end)
    
    self:CreateKeybindButton(keys, "Silent Aim", Config.Settings.Keybinds.SilentAim, function(key)
        Config.Settings.Keybinds.SilentAim = key
        print("[KEYBIND] Silent Aim:", key.Name)
    end)
end

function GUI:CreateMiscTab()
    -- Utilities
    local util = self:CreateSection("Utilities")
    
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
    
    -- Information
    local info = self:CreateSection("Information")
    self:CreateLabel(info, "Developer", Config.Developer)
    self:CreateLabel(info, "Version", Config.Version)
    self:CreateLabel(info, "Discord", Config.Discord)
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
    
    if input.KeyCode == Config.Settings.Keybinds.ToggleGUI then
        print("🔑 [CANDY ZONE] Toggle key pressed!")
        GUI:ToggleMain()
    elseif input.KeyCode == Config.Settings.Keybinds.PanicKey then
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
        Title = "🍬 Candy Zone MM2",
        Text = "Press RightShift to open",
        Duration = 5
    })
end)

print("═══════════════════════════════════════════════════════════")
print("🍬 CANDY ZONE MM2 v" .. Config.Version)
print("✅ Successfully Loaded!")
print("🎮 Game: " .. Util:GetGameName())
print("👤 Developer: " .. Config.Developer)
print("💬 Discord: " .. Config.Discord)
print("⌨️ Toggle: RightShift | Panic: End")
print("═══════════════════════════════════════════════════════════")
