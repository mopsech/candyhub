--[[
    PREMIUM EXECUTOR UI
    Полнофункциональный интерфейс с анимациями и системой страниц
    Версия: 2.0
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Очистка старого UI
if PlayerGui:FindFirstChild("ExecutorUI") then
    PlayerGui:FindFirstChild("ExecutorUI"):Destroy()
end

-- ============================
-- КОНФИГУРАЦИЯ
-- ============================

local Config = {
    -- Цветовая палитра
    Colors = {
        Background = Color3.fromRGB(15, 15, 15),
        BackgroundSecondary = Color3.fromRGB(20, 20, 20),
        Surface = Color3.fromRGB(25, 25, 25),
        SurfaceHover = Color3.fromRGB(30, 30, 30),
        Border = Color3.fromRGB(40, 40, 40),
        BorderLight = Color3.fromRGB(50, 50, 50),
        
        Text = Color3.fromRGB(245, 245, 245),
        TextSecondary = Color3.fromRGB(160, 160, 160),
        TextTertiary = Color3.fromRGB(100, 100, 100),
        
        Accent = Color3.fromRGB(255, 255, 255),
        AccentDim = Color3.fromRGB(200, 200, 200),
        
        Success = Color3.fromRGB(120, 255, 120),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 100),
        
        ToggleOff = Color3.fromRGB(35, 35, 35),
        ToggleOn = Color3.fromRGB(255, 255, 255),
        ToggleIndicatorOff = Color3.fromRGB(60, 60, 60),
        ToggleIndicatorOn = Color3.fromRGB(20, 20, 20),
    },
    
    -- Иконки (используем реальные Lucide Icons от Roblox)
    Icons = {
        Home = "rbxassetid://10734896629",
        Combat = "rbxassetid://10747374131",
        Visuals = "rbxassetid://10747384394",
        Movement = "rbxassetid://10734952584",
        Settings = "rbxassetid://10734950309",
        
        Shield = "rbxassetid://10723434518",
        Target = "rbxassetid://10723407389",
        Eye = "rbxassetid://10723424719",
        Zap = "rbxassetid://10723407617",
        Users = "rbxassetid://10723416652",
        Box = "rbxassetid://10723383872",
        Crosshair = "rbxassetid://10723396716",
        Activity = "rbxassetid://10723368599",
        Gauge = "rbxassetid://10723409130",
        Feather = "rbxassetid://10723404337",
        Wind = "rbxassetid://10747372167",
        Maximize = "rbxassetid://10734920149",
        Sliders = "rbxassetid://10734961189",
        Palette = "rbxassetid://10734952273",
        Info = "rbxassetid://10723434711",
    },
    
    -- Анимация
    Animation = {
        Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Medium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Slow = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Smooth = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        Bounce = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    },
    
    -- Размеры
    Spacing = {
        XS = 4,
        SM = 8,
        MD = 12,
        LG = 16,
        XL = 20,
        XXL = 24,
    },
    
    -- Снег
    Snow = {
        ParticleCount = 60,
        MinSize = 2,
        MaxSize = 5,
        MinSpeed = 0.3,
        MaxSpeed = 0.8,
        DriftAmount = 0.15,
    }
}

-- ============================
-- УТИЛИТЫ
-- ============================

local Util = {}

function Util.CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Util.Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Util.CreateCorner(radius, parent)
    return Util.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
end

function Util.CreateStroke(color, thickness, transparency, parent)
    return Util.CreateInstance("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = transparency or 0.5,
        Parent = parent
    })
end

function Util.CreatePadding(parent, all)
    return Util.CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, all),
        PaddingBottom = UDim.new(0, all),
        PaddingLeft = UDim.new(0, all),
        PaddingRight = UDim.new(0, all),
        Parent = parent
    })
end

function Util.CreateIcon(image, size, color, parent)
    local icon = Util.CreateInstance("ImageLabel", {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1,
        Image = image,
        ImageColor3 = color,
        Parent = parent
    })
    return icon
end

-- ============================
-- SNOW SYSTEM (Оптимизированная)
-- ============================

local SnowSystem = {}
SnowSystem.__index = SnowSystem

function SnowSystem.new(parent)
    local self = setmetatable({}, SnowSystem)
    
    self.Container = Util.CreateInstance("Frame", {
        Name = "SnowContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = parent
    })
    
    self.Particles = {}
    self.PoolSize = Config.Snow.ParticleCount
    self.UpdateInterval = 0
    self.IsRunning = false
    
    self:Initialize()
    return self
end

function SnowSystem:Initialize()
    -- Создаем пул снежинок
    for i = 1, self.PoolSize do
        local size = math.random(Config.Snow.MinSize, Config.Snow.MaxSize)
        local transparency = math.random(40, 80) / 100
        
        local particle = Util.CreateInstance("Frame", {
            Name = "Snow_" .. i,
            Size = UDim2.new(0, size, 0, size),
            BackgroundColor3 = Config.Colors.Accent,
            BorderSizePixel = 0,
            BackgroundTransparency = transparency,
            Position = UDim2.new(
                math.random(0, 100) / 100,
                0,
                math.random(-50, 0) / 100,
                0
            ),
            Parent = self.Container
        })
        
        Util.CreateCorner(size, particle)
        
        table.insert(self.Particles, {
            frame = particle,
            speed = math.random(Config.Snow.MinSpeed * 100, Config.Snow.MaxSpeed * 100) / 10000,
            drift = math.random(-Config.Snow.DriftAmount * 100, Config.Snow.DriftAmount * 100) / 10000,
            phase = math.random(0, 628) / 100,
            resetDelay = 0
        })
    end
end

function SnowSystem:Start()
    if self.IsRunning then return end
    self.IsRunning = true
    
    local lastUpdate = tick()
    
    self.Connection = RunService.Heartbeat:Connect(function()
        local now = tick()
        local deltaTime = now - lastUpdate
        
        -- Ограничиваем обновления до 60 FPS
        if deltaTime < 1/60 then return end
        lastUpdate = now
        
        for _, particle in ipairs(self.Particles) do
            if particle.resetDelay > 0 then
                particle.resetDelay = particle.resetDelay - deltaTime
            else
                local pos = particle.frame.Position
                local newY = pos.Y.Scale + particle.speed
                local drift = math.sin(now * 0.8 + particle.phase) * particle.drift
                local newX = pos.X.Scale + drift
                
                if newY > 1.15 then
                    newY = -0.1
                    newX = math.random(0, 100) / 100
                    particle.resetDelay = math.random(0, 50) / 100
                end
                
                particle.frame.Position = UDim2.new(newX, 0, newY, 0)
            end
        end
    end)
end

function SnowSystem:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    self.IsRunning = false
end

-- ============================
-- STATE MANAGER
-- ============================

local StateManager = {}
StateManager.__index = StateManager

function StateManager.new()
    local self = setmetatable({}, StateManager)
    self.CurrentPage = "Home"
    self.TogglesState = {}
    self.Listeners = {}
    return self
end

function StateManager:SetPage(pageName)
    if self.CurrentPage == pageName then return end
    self.CurrentPage = pageName
    self:Notify("PageChanged", pageName)
end

function StateManager:GetPage()
    return self.CurrentPage
end

function StateManager:SetToggle(name, state)
    self.TogglesState[name] = state
    self:Notify("ToggleChanged", {name = name, state = state})
end

function StateManager:GetToggle(name)
    return self.TogglesState[name] or false
end

function StateManager:Listen(event, callback)
    if not self.Listeners[event] then
        self.Listeners[event] = {}
    end
    table.insert(self.Listeners[event], callback)
end

function StateManager:Notify(event, data)
    if self.Listeners[event] then
        for _, callback in ipairs(self.Listeners[event]) do
            task.spawn(callback, data)
        end
    end
end

-- ============================
-- КОМПОНЕНТЫ UI
-- ============================

-- Toggle Component
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, name, description, icon)
    local self = setmetatable({}, Toggle)
    self.Name = name
    self.IsOn = false
    
    -- Container
    self.Container = Util.CreateInstance("Frame", {
        Name = name .. "Toggle",
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    Util.CreateCorner(10, self.Container)
    self.Stroke = Util.CreateStroke(Config.Colors.Border, 1, 0.6, self.Container)
    
    -- Icon
    if icon then
        self.Icon = Util.CreateIcon(
            icon,
            20,
            Config.Colors.TextSecondary,
            self.Container
        )
        self.Icon.Position = UDim2.new(0, 16, 0, 24)
    end
    
    -- Labels Container
    local labelOffset = icon and 48 or 16
    
    self.NameLabel = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, -labelOffset - 80, 0, 22),
        Position = UDim2.new(0, labelOffset, 0, 14),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Config.Colors.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    self.DescLabel = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, -labelOffset - 80, 0, 18),
        Position = UDim2.new(0, labelOffset, 0, 36),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Toggle Switch
    self.Switch = Util.CreateInstance("TextButton", {
        Size = UDim2.new(0, 52, 0, 28),
        Position = UDim2.new(1, -68, 0.5, -14),
        BackgroundColor3 = Config.Colors.ToggleOff,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = self.Container
    })
    
    Util.CreateCorner(14, self.Switch)
    
    -- Toggle Indicator
    self.Indicator = Util.CreateInstance("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundColor3 = Config.Colors.ToggleIndicatorOff,
        BorderSizePixel = 0,
        Parent = self.Switch
    })
    
    Util.CreateCorner(11, self.Indicator)
    
    -- Hover effects
    self.Container.MouseEnter:Connect(function() self:OnHoverEnter() end)
    self.Container.MouseLeave:Connect(function() self:OnHoverLeave() end)
    self.Switch.MouseButton1Click:Connect(function() self:Toggle() end)
    
    return self
end

function Toggle:OnHoverEnter()
    Util.Tween(self.Container, Config.Animation.Fast, {
        BackgroundColor3 = Config.Colors.SurfaceHover
    })
    Util.Tween(self.Stroke, Config.Animation.Fast, {
        Transparency = 0.3
    })
end

function Toggle:OnHoverLeave()
    Util.Tween(self.Container, Config.Animation.Fast, {
        BackgroundColor3 = Config.Colors.Surface
    })
    Util.Tween(self.Stroke, Config.Animation.Fast, {
        Transparency = 0.6
    })
end

function Toggle:Toggle()
    self.IsOn = not self.IsOn
    
    if self.IsOn then
        Util.Tween(self.Switch, Config.Animation.Medium, {
            BackgroundColor3 = Config.Colors.ToggleOn
        })
        Util.Tween(self.Indicator, Config.Animation.Medium, {
            Position = UDim2.new(1, -25, 0, 3),
            BackgroundColor3 = Config.Colors.ToggleIndicatorOn
        })
        if self.Icon then
            Util.Tween(self.Icon, Config.Animation.Medium, {
                ImageColor3 = Config.Colors.Accent
            })
        end
    else
        Util.Tween(self.Switch, Config.Animation.Medium, {
            BackgroundColor3 = Config.Colors.ToggleOff
        })
        Util.Tween(self.Indicator, Config.Animation.Medium, {
            Position = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = Config.Colors.ToggleIndicatorOff
        })
        if self.Icon then
            Util.Tween(self.Icon, Config.Animation.Medium, {
                ImageColor3 = Config.Colors.TextSecondary
            })
        end
    end
    
    if self.OnChanged then
        self.OnChanged(self.IsOn)
    end
end

function Toggle:SetState(state)
    if self.IsOn == state then return end
    self:Toggle()
end

-- Button Component
local Button = {}
Button.__index = Button

function Button.new(parent, text, icon, size, position)
    local self = setmetatable({}, Button)
    
    self.Container = Util.CreateInstance("TextButton", {
        Size = size or UDim2.new(1, 0, 0, 40),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    Util.CreateCorner(8, self.Container)
    self.Stroke = Util.CreateStroke(Config.Colors.Border, 1, 0.6, self.Container)
    
    if icon then
        self.Icon = Util.CreateIcon(
            icon,
            18,
            Config.Colors.Text,
            self.Container
        )
        self.Icon.Position = UDim2.new(0, 12, 0.5, -9)
    end
    
    self.Label = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, icon and -40 or -24, 1, 0),
        Position = UDim2.new(0, icon and 38 or 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    self.Container.MouseEnter:Connect(function() self:OnHoverEnter() end)
    self.Container.MouseLeave:Connect(function() self:OnHoverLeave() end)
    
    return self
end

function Button:OnHoverEnter()
    Util.Tween(self.Container, Config.Animation.Fast, {
        BackgroundColor3 = Config.Colors.SurfaceHover
    })
    Util.Tween(self.Stroke, Config.Animation.Fast, {
        Transparency = 0.3
    })
end

function Button:OnHoverLeave()
    Util.Tween(self.Container, Config.Animation.Fast, {
        BackgroundColor3 = Config.Colors.Surface
    })
    Util.Tween(self.Stroke, Config.Animation.Fast, {
        Transparency = 0.6
    })
end

function Button:OnClick(callback)
    self.Container.MouseButton1Click:Connect(callback)
end

-- Stat Card Component
local StatCard = {}
StatCard.__index = StatCard

function StatCard.new(parent, label, value, icon, index)
    local self = setmetatable({}, StatCard)
    
    self.Container = Util.CreateInstance("Frame", {
        Size = UDim2.new(0.48, 0, 0, 80),
        Position = UDim2.new(
            (index % 2 == 0) and 0.52 or 0,
            0,
            0,
            math.floor(index / 2) * 92
        ),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    Util.CreateCorner(10, self.Container)
    Util.CreateStroke(Config.Colors.Border, 1, 0.6, self.Container)
    
    -- Icon
    if icon then
        self.Icon = Util.CreateIcon(
            icon,
            24,
            Config.Colors.AccentDim,
            self.Container
        )
        self.Icon.Position = UDim2.new(0, 16, 0, 16)
    end
    
    -- Value
    self.ValueLabel = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, -56, 0, 28),
        Position = UDim2.new(0, icon and 48 or 16, 0, 14),
        BackgroundTransparency = 1,
        Text = value,
        TextColor3 = Config.Colors.Text,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    -- Label
    self.Label = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, -56, 0, 16),
        Position = UDim2.new(0, icon and 48 or 16, 0, 46),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    
    return self
end

function StatCard:SetValue(value)
    self.ValueLabel.Text = value
end

-- Category Button Component
local CategoryButton = {}
CategoryButton.__index = CategoryButton

function CategoryButton.new(parent, name, icon, index)
    local self = setmetatable({}, CategoryButton)
    self.Name = name
    self.IsSelected = false
    
    self.Container = Util.CreateInstance("TextButton", {
        Size = UDim2.new(0, 56, 0, 56),
        Position = UDim2.new(0, index * 64 + 4, 0, 4),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    Util.CreateCorner(12, self.Container)
    
    self.Icon = Util.CreateIcon(
        icon,
        24,
        Config.Colors.TextSecondary,
        self.Container
    )
    self.Icon.Position = UDim2.new(0.5, -12, 0.5, -12)
    
    self.Container.MouseEnter:Connect(function() self:OnHoverEnter() end)
    self.Container.MouseLeave:Connect(function() self:OnHoverLeave() end)
    
    return self
end

function CategoryButton:OnHoverEnter()
    if not self.IsSelected then
        Util.Tween(self.Container, Config.Animation.Fast, {
            BackgroundColor3 = Config.Colors.BackgroundSecondary
        })
        Util.Tween(self.Icon, Config.Animation.Fast, {
            ImageColor3 = Config.Colors.Text
        })
    end
end

function CategoryButton:OnHoverLeave()
    if not self.IsSelected then
        Util.Tween(self.Container, Config.Animation.Fast, {
            BackgroundColor3 = Config.Colors.Surface
        })
        Util.Tween(self.Icon, Config.Animation.Fast, {
            ImageColor3 = Config.Colors.TextSecondary
        })
    end
end

function CategoryButton:Select()
    self.IsSelected = true
    Util.Tween(self.Container, Config.Animation.Medium, {
        BackgroundColor3 = Config.Colors.BackgroundSecondary
    })
    Util.Tween(self.Icon, Config.Animation.Medium, {
        ImageColor3 = Config.Colors.Accent
    })
end

function CategoryButton:Deselect()
    self.IsSelected = false
    Util.Tween(self.Container, Config.Animation.Medium, {
        BackgroundColor3 = Config.Colors.Surface
    })
    Util.Tween(self.Icon, Config.Animation.Medium, {
        ImageColor3 = Config.Colors.TextSecondary
    })
end

function CategoryButton:OnClick(callback)
    self.Container.MouseButton1Click:Connect(callback)
end

-- ============================
-- PAGE SYSTEM
-- ============================

local PageSystem = {}
PageSystem.__index = PageSystem

function PageSystem.new(parent)
    local self = setmetatable({}, PageSystem)
    
    self.Container = Util.CreateInstance("Frame", {
        Name = "PageContainer",
        Size = UDim2.new(1, 0, 1, -80),
        Position = UDim2.new(0, 0, 0, 72),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = parent
    })
    
    self.Pages = {}
    self.CurrentPage = nil
    
    return self
end

function PageSystem:CreatePage(name)
    local page = Util.CreateInstance("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Colors.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = self.Container
    })
    
    Util.CreatePadding(page, Config.Spacing.LG)
    
    local layout = Util.CreateInstance("UIListLayout", {
        Padding = UDim.new(0, Config.Spacing.MD),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page
    })
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + Config.Spacing.LG * 2)
    end)
    
    self.Pages[name] = page
    return page
end

function PageSystem:SwitchTo(pageName, instant)
    local targetPage = self.Pages[pageName]
    if not targetPage then return end
    
    if self.CurrentPage then
        local oldPage = self.CurrentPage
        
        if instant then
            oldPage.Visible = false
            targetPage.Visible = true
        else
            -- Fade out старая страница
            Util.Tween(oldPage, Config.Animation.Fast, {
                Position = UDim2.new(-0.05, 0, 0, 0),
                GroupTransparency = 1
            }).Completed:Connect(function()
                oldPage.Visible = false
                oldPage.Position = UDim2.new(0, 0, 0, 0)
                oldPage.GroupTransparency = 0
            end)
            
            -- Fade in новая страница
            targetPage.Position = UDim2.new(0.05, 0, 0, 0)
            targetPage.GroupTransparency = 1
            targetPage.Visible = true
            
            Util.Tween(targetPage, Config.Animation.Medium, {
                Position = UDim2.new(0, 0, 0, 0),
                GroupTransparency = 0
            })
        end
    else
        targetPage.Visible = true
    end
    
    self.CurrentPage = targetPage
end

-- ============================
-- ГЛАВНОЕ ПРИЛОЖЕНИЕ
-- ============================

local App = {}
App.__index = App

function App.new()
    local self = setmetatable({}, App)
    
    -- Создаем главный ScreenGui
    self.ScreenGui = Util.CreateInstance("ScreenGui", {
        Name = "ExecutorUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })
    
    -- Инициализируем системы
    self.State = StateManager.new()
    self.Snow = SnowSystem.new(self.ScreenGui)
    
    -- Создаем UI
    self:CreateMainFrame()
    self:CreateHeader()
    self:CreatePages()
    self:CreateCategoryBar()
    
    -- Запускаем системы
    self.Snow:Start()
    
    -- Устанавливаем начальную страницу
    self.PageSystem:SwitchTo("Home", true)
    self.CategoryButtons[1]:Select()
    
    print("✓ Premium Executor UI initialized")
    return self
end

function App:CreateMainFrame()
    self.MainFrame = Util.CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 480, 0, 580),
        Position = UDim2.new(0.5, -240, 0.5, -290),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = self.ScreenGui
    })
    
    Util.CreateCorner(16, self.MainFrame)
    Util.CreateStroke(Config.Colors.Border, 1, 0.5, self.MainFrame)
    
    -- Тень (fake shadow через дублирование)
    local shadow = Util.CreateInstance("Frame", {
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = self.MainFrame
    })
    Util.CreateCorner(20, shadow)
    shadow.Parent = self.ScreenGui
    shadow.ZIndex = 1
end

function App:CreateHeader()
    local header = Util.CreateInstance("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 68),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
    
    -- Logo Badge
    local badge = Util.CreateInstance("Frame", {
        Size = UDim2.new(0, 70, 0, 26),
        Position = UDim2.new(0, Config.Spacing.LG, 0, Config.Spacing.LG),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        Parent = header
    })
    
    Util.CreateCorner(6, badge)
    local badgeStroke = Util.CreateStroke(Config.Colors.Accent, 1, 0.7, badge)
    
    local badgeText = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "VOID",
        TextColor3 = Config.Colors.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = badge
    })
    
    -- Animated glow effect
    task.spawn(function()
        while true do
            Util.Tween(badgeStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.3
            }).Completed:Wait()
            Util.Tween(badgeStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.7
            }).Completed:Wait()
        end
    end)
    
    -- Status
    local statusContainer = Util.CreateInstance("Frame", {
        Size = UDim2.new(0, 100, 0, 24),
        Position = UDim2.new(1, -Config.Spacing.LG - 100, 0, Config.Spacing.LG + 1),
        BackgroundTransparency = 1,
        Parent = header
    })
    
    local statusDot = Util.CreateInstance("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 0, 0.5, -3),
        BackgroundColor3 = Config.Colors.Success,
        BorderSizePixel = 0,
        Parent = statusContainer
    })
    Util.CreateCorner(3, statusDot)
    
    local statusText = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "READY",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = statusContainer
    })
    
    -- Separator
    local separator = Util.CreateInstance("Frame", {
        Size = UDim2.new(1, -Config.Spacing.LG * 2, 0, 1),
        Position = UDim2.new(0, Config.Spacing.LG, 1, -1),
        BackgroundColor3 = Config.Colors.Border,
        BorderSizePixel = 0,
        Parent = header
    })
end

function App:CreatePages()
    self.PageSystem = PageSystem.new(self.MainFrame)
    
    -- HOME PAGE
    local homePage = self.PageSystem:CreatePage("Home")
    
    -- Welcome Section
    local welcomeText = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        Text = "Welcome back",
        TextColor3 = Config.Colors.Text,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = homePage
    })
    
    local subtitleText = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "Your executor is ready for action",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = homePage
    })
    
    -- Stats Container
    local statsContainer = Util.CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 184),
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Parent = homePage
    })
    
    StatCard.new(statsContainer, "SCRIPTS LOADED", "47", Config.Icons.Activity, 0)
    StatCard.new(statsContainer, "UPTIME", "2h 34m", Config.Icons.Gauge, 1)
    StatCard.new(statsContainer, "ACTIVE FEATURES", "12", Config.Icons.Zap, 2)
    StatCard.new(statsContainer, "PERFORMANCE", "98%", Config.Icons.Target, 3)
    
    -- Quick Actions
    local quickTitle = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "Quick Actions",
        TextColor3 = Config.Colors.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 4,
        Parent = homePage
    })
    
    local actionsContainer = Util.CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 96),
        BackgroundTransparency = 1,
        LayoutOrder = 5,
        Parent = homePage
    })
    
    local actionsLayout = Util.CreateInstance("UIListLayout", {
        Padding = UDim.new(0, Config.Spacing.SM),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = actionsContainer
    })
    
    local btn1 = Button.new(actionsContainer, "Execute Clipboard", Config.Icons.Activity)
    btn1.Container.LayoutOrder = 1
    
    local btn2 = Button.new(actionsContainer, "Clear Console", Config.Icons.Box)
    btn2.Container.LayoutOrder = 2
    
    -- COMBAT PAGE
    local combatPage = self.PageSystem:CreatePage("Combat")
    
    local combatTitle = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Combat Features",
        TextColor3 = Config.Colors.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = combatPage
    })
    
    local combatDesc = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "Configure combat assistance and targeting",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = combatPage
    })
    
    local t1 = Toggle.new(combatPage, "Aimbot", "Automatic target acquisition", Config.Icons.Target)
    t1.Container.LayoutOrder = 3
    
    local t2 = Toggle.new(combatPage, "Silent Aim", "Invisible aim correction", Config.Icons.Crosshair)
    t2.Container.LayoutOrder = 4
    
    local t3 = Toggle.new(combatPage, "Triggerbot", "Auto-fire when on target", Config.Icons.Zap)
    t3.Container.LayoutOrder = 5
    
    local t4 = Toggle.new(combatPage, "Target Prediction", "Lead moving targets", Config.Icons.Activity)
    t4.Container.LayoutOrder = 6
    
    local t5 = Toggle.new(combatPage, "Anti-Recoil", "Weapon stabilization", Config.Icons.Shield)
    t5.Container.LayoutOrder = 7
    
    -- VISUALS PAGE
    local visualsPage = self.PageSystem:CreatePage("Visuals")
    
    local visualsTitle = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Visual Features",
        TextColor3 = Config.Colors.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = visualsPage
    })
    
    local visualsDesc = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "Enhance your visual awareness",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = visualsPage
    })
    
    local v1 = Toggle.new(visualsPage, "Player ESP", "See players through walls", Config.Icons.Eye)
    v1.Container.LayoutOrder = 3
    
    local v2 = Toggle.new(visualsPage, "Box ESP", "Draw boxes around entities", Config.Icons.Box)
    v2.Container.LayoutOrder = 4
    
    local v3 = Toggle.new(visualsPage, "Health ESP", "Display health bars", Config.Icons.Activity)
    v3.Container.LayoutOrder = 5
    
    local v4 = Toggle.new(visualsPage, "Distance ESP", "Show distance to targets", Config.Icons.Info)
    v4.Container.LayoutOrder = 6
    
    local v5 = Toggle.new(visualsPage, "Tracers", "Draw lines to entities", Config.Icons.Activity)
    v5.Container.LayoutOrder = 7
    
    local v6 = Toggle.new(visualsPage, "Chams", "Colored player models", Config.Icons.Palette)
    v6.Container.LayoutOrder = 8
    
    -- MOVEMENT PAGE
    local movementPage = self.PageSystem:CreatePage("Movement")
    
    local movementTitle = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Movement Enhancements",
        TextColor3 = Config.Colors.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = movementPage
    })
    
    local movementDesc = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "Modify movement mechanics",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = movementPage
    })
    
    local m1 = Toggle.new(movementPage, "Speed Boost", "Increase walk speed", Config.Icons.Zap)
    m1.Container.LayoutOrder = 3
    
    local m2 = Toggle.new(movementPage, "Fly Mode", "Free camera movement", Config.Icons.Feather)
    m2.Container.LayoutOrder = 4
    
    local m3 = Toggle.new(movementPage, "No Clip", "Walk through walls", Config.Icons.Maximize)
    m3.Container.LayoutOrder = 5
    
    local m4 = Toggle.new(movementPage, "Infinite Jump", "Jump without limits", Config.Icons.Wind)
    m4.Container.LayoutOrder = 6
    
    local m5 = Toggle.new(movementPage, "Anti-Fall Damage", "Prevent fall damage", Config.Icons.Shield)
    m5.Container.LayoutOrder = 7
    
    -- SETTINGS PAGE
    local settingsPage = self.PageSystem:CreatePage("Settings")
    
    local settingsTitle = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Settings",
        TextColor3 = Config.Colors.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = settingsPage
    })
    
    local settingsDesc = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "Configure executor preferences",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
        Parent = settingsPage
    })
    
    local s1 = Toggle.new(settingsPage, "Auto-Execute", "Run scripts on join", Config.Icons.Zap)
    s1.Container.LayoutOrder = 3
    
    local s2 = Toggle.new(settingsPage, "Save Config", "Persist settings", Config.Icons.Box)
    s2.Container.LayoutOrder = 4
    
    local s3 = Toggle.new(settingsPage, "Notifications", "Show UI notifications", Config.Icons.Info)
    s3.Container.LayoutOrder = 5
    
    local s4 = Toggle.new(settingsPage, "Performance Mode", "Reduce visual effects", Config.Icons.Gauge)
    s4.Container.LayoutOrder = 6
    
    -- Info section
    local infoContainer = Util.CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 120),
        BackgroundColor3 = Config.Colors.Surface,
        BorderSizePixel = 0,
        LayoutOrder = 7,
        Parent = settingsPage
    })
    
    Util.CreateCorner(10, infoContainer)
    Util.CreateStroke(Config.Colors.Border, 1, 0.6, infoContainer)
    Util.CreatePadding(infoContainer, Config.Spacing.LG)
    
    local infoTitle = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "About",
        TextColor3 = Config.Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = infoContainer
    })
    
    local infoText = Util.CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = "Premium Executor UI v2.0\nBuilt with modern design principles\nOptimized for performance",
        TextColor3 = Config.Colors.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = infoContainer
    })
end

function App:CreateCategoryBar()
    self.CategoryBar = Util.CreateInstance("Frame", {
        Name = "CategoryBar",
        Size = UDim2.new(0, 340, 0, 64),
        Position = UDim2.new(0.5, -170, 1, -84),
        BackgroundColor3 = Config.Colors.Background,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = self.ScreenGui
    })
    
    Util.CreateCorner(16, self.CategoryBar)
    Util.CreateStroke(Config.Colors.Border, 1, 0.5, self.CategoryBar)
    
    -- Selection Indicator
    self.SelectionIndicator = Util.CreateInstance("Frame", {
        Size = UDim2.new(0, 56, 0, 3),
        Position = UDim2.new(0, 4, 1, -4),
        BackgroundColor3 = Config.Colors.Accent,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = self.CategoryBar
    })
    
    Util.CreateCorner(2, self.SelectionIndicator)
    
    -- Categories
    local categories = {
        {name = "Home", icon = Config.Icons.Home},
        {name = "Combat", icon = Config.Icons.Combat},
        {name = "Visuals", icon = Config.Icons.Visuals},
        {name = "Movement", icon = Config.Icons.Movement},
        {name = "Settings", icon = Config.Icons.Settings}
    }
    
    self.CategoryButtons = {}
    
    for i, cat in ipairs(categories) do
        local button = CategoryButton.new(self.CategoryBar, cat.name, cat.icon, i - 1)
        
        button:OnClick(function()
            self:SwitchCategory(cat.name, i)
        end)
        
        table.insert(self.CategoryButtons, button)
    end
end

function App:SwitchCategory(categoryName, index)
    -- Deselect all
    for _, btn in ipairs(self.CategoryButtons) do
        btn:Deselect()
    end
    
    -- Select current
    self.CategoryButtons[index]:Select()
    
    -- Move indicator
    local targetX = (index - 1) * 64 + 4
    Util.Tween(self.SelectionIndicator, Config.Animation.Smooth, {
        Position = UDim2.new(0, targetX, 1, -4)
    })
    
    -- Switch page
    self.PageSystem:SwitchTo(categoryName)
    self.State:SetPage(categoryName)
end

-- ============================
-- ЗАПУСК
-- ============================

local executor = App.new()

-- Дополнительные утилиты для разработчика
_G.ExecutorUI = {
    GetState = function() return executor.State end,
    GetPage = function() return executor.State:GetPage() end,
    SwitchTo = function(page) 
        for i, cat in ipairs({"Home", "Combat", "Visuals", "Movement", "Settings"}) do
            if cat == page then
                executor:SwitchCategory(page, i)
                break
            end
        end
    end,
    ToggleSnow = function()
        if executor.Snow.IsRunning then
            executor.Snow:Stop()
        else
            executor.Snow:Start()
        end
    end
}

print("═══════════════════════════════════")
print("   PREMIUM EXECUTOR UI v2.0")
print("═══════════════════════════════════")
print("✓ Interface loaded successfully")
print("✓ 5 pages with smooth transitions")
print("✓ 60 particle snow system active")
print("✓ All components initialized")
print("")
print("Developer API:")
print("_G.ExecutorUI.GetPage()")
print("_G.ExecutorUI.SwitchTo(page)")
print("_G.ExecutorUI.ToggleSnow()")
print("═══════════════════════════════════")

-- Keyboard shortcuts
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        executor:SwitchCategory("Home", 1)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        executor:SwitchCategory("Combat", 2)
    elseif input.KeyCode == Enum.KeyCode.F3 then
        executor:SwitchCategory("Visuals", 3)
    elseif input.KeyCode == Enum.KeyCode.F4 then
        executor:SwitchCategory("Movement", 4)
    elseif input.KeyCode == Enum.KeyCode.F5 then
        executor:SwitchCategory("Settings", 5)
    end
end)
