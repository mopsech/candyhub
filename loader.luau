if not game:IsLoaded() then
    pcall(function()
        local Loaded = game.Loaded

        if Loaded then
            Loaded:Wait()
        end
    end)
end
if getgenv().VisionHub_Executed and getgenv().VisionHub_Cleanup then
    pcall(getgenv().VisionHub_Cleanup)
end

getgenv().VisionHub_Executed = true

local Workspace, Players, ReplicatedStorage, RunService, UserInputService, TweenService, SoundService, HttpService
local TeleportService, TextChatService, CoreGui, Stats, MarketplaceService

do
    local v1 = cloneref or function(...)
        return ...
    end
    local t1 = {}
    local u3 = v1

    function t1.__index(p1, p2)
        local v512, v513 = pcall(function()
            return u3(game:GetService(p2))
        end)

        if not v512 or not v513 then
            v512, v513 = pcall(function()
                return game:GetService(p2)
            end)
        end
        if not v512 or not v513 then
            rawset(p1, p2, nil)

            return nil
        end

        rawset(p1, p2, v513)

        return v513
    end

    local self = setmetatable({}, t1)

    Workspace = self.Workspace
    Players = self.Players
    ReplicatedStorage = self.ReplicatedStorage
    RunService = self.RunService
    UserInputService = self.UserInputService
    TweenService = self.TweenService
    SoundService = self.SoundService
    HttpService = self.HttpService
    TeleportService = self.TeleportService
    TextChatService = self.TextChatService
    CoreGui = self.CoreGui
    Stats = self.Stats
    MarketplaceService = self.MarketplaceService
end

local LocalPlayer = Players and Players.LocalPlayer

if not LocalPlayer and Players then
    pcall(function()
        LocalPlayer = Players.LocalPlayer or (Players:GetPropertyChangedSignal('LocalPlayer'):Wait() or Players.LocalPlayer)
    end)
end

local Camera = Workspace and Workspace.CurrentCamera

getgenv().VisionHub_Connections = getgenv().VisionHub_Connections or {}

for _, v in ipairs(getgenv().VisionHub_Connections)do
    if typeof(v) == 'RBXScriptConnection' and v.Connected then
        pcall(function()
            v:Disconnect()
        end)
    end
end

table.clear(getgenv().VisionHub_Connections)

local function TrackConnection(conn)
    if typeof(conn) ~= 'RBXScriptConnection' then
        return
    end

    table.insert(getgenv().VisionHub_Connections, conn)

    return conn
end
local function DisconnectConnection(conn)
    if not conn then
        return
    end

    for i, v in ipairs(getgenv().VisionHub_Connections)do
        if v == conn then
            table.remove(getgenv().VisionHub_Connections, i)

            break
        end
    end

    if typeof(conn) == 'RBXScriptConnection' and conn.Connected then
        conn:Disconnect()
    end
end

if getgenv().FPDH then
    Workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

local Hub = {
    IsPremium = true,
    Player = LocalPlayer,
    Camera = Camera,
    Players = Players,
    Workspace = Workspace,
    RunService = RunService,
    HttpService = HttpService,
    TweenService = TweenService,
    UserInputService = UserInputService,
    ReplicatedStorage = ReplicatedStorage,
    TeleportService = TeleportService,
    CoreGui = CoreGui,
    SoundService = SoundService,
    Config = {
        Invisible = false,
        Noclip = false,
        EnableWalkSpeed = false,
        WalkSpeed = 16,
        EnableJumpPower = false,
        JumpPower = 50,
        FlyEnabled = false,
        FlySpeed = 100,
        InfiniteJump = false,
        AntiFling = false,
        SpeedGlitch = false,
        SpeedGlitchSpeed = 50,
        AutoGrabGun = false,
        AutoShootMurderer = false,
        WallBangEnabled = false,
        AutoWallBangEnabled = false,
        KillAllMode = 'Default',
        KnifeAuraMode = 'Default',
        AutoKillAll = false,
        KnifeAura = false,
        KnifeAuraRange = 20,
        SilentThrow = false,
        KnifeThrowAura = 1000,
        AutoFarmCoins = false,
        AutoFarmSpeed = 25,
        AutoFarmOffset = -5,
        AutoFarmRadius = 3000,
        AutoFarmDelay = 0.1,
        NotifyGunDropped = false,
        HighlightMurderer = false,
        InfoMurderer = false,
        BoxMurderer = false,
        TracersMurderer = false,
        SkeletonMurderer = false,
        HighlightSheriff = false,
        InfoSheriff = false,
        BoxSheriff = false,
        TracersSheriff = false,
        SkeletonSheriff = false,
        HighlightInnocent = false,
        InfoInnocent = false,
        BoxInnocent = false,
        TracersInnocent = false,
        SkeletonInnocent = false,
        ESPGunDropped = false,
        OffScreenArrows = false,
        OffScreenArrowDist = 80,
        OffScreenArrowHeight = 16,
        OffScreenArrowWidth = 16,
        OffScreenArrowFilled = true,
        OffScreenArrowTransparency = 0,
        OffScreenArrowThickness = 1,
        OffScreenArrowColor = Color3.fromRGB(255, 255, 255),
        OffScreenArrowAntiAlias = false,
        ESPColorInnocent = Color3.fromRGB(0, 255, 0),
        ESPColorMurderer = Color3.fromRGB(255, 0, 0),
        ESPColorSheriff = Color3.fromRGB(0, 0, 255),
        ESPEnabled = true,
        HealthBarEnabled = false,
        HealthBarSide = 'left',
        HealthBarColorHigh = Color3.fromRGB(0, 255, 0),
        HealthBarColorLow = Color3.fromRGB(255, 0, 0),
        BoxColor = Color3.fromRGB(255, 255, 255),
        BoxThickness = 1,
        BoxFilled = false,
        BoxFillTransparency = 0.7,
        ButtonsLocked = true,
        AutoHolsterDelay = 1.5,
        PredictionESPEnabled = false,
        PredictionESPAlways = false,
        PredictionESPColor = Color3.fromRGB(255, 55, 95),
        PredictionESPSize = 14,
        PredictionESPThickness = 2,
        PredictionESPTransparency = 0,
        PredictionESPVariants = {
            Dot = true,
            Circle = true,
            Crosshair = true,
            Tracer = true,
            Box = true,
            Ring = true,
        },
        PredictionESPKey = 'P',
        ResolverEnabled = true,
        ResolverMode = 'Adaptive',
        ResolverAimPart = 'Head',
        ResolverLatencyScale = 1,
        ResolverExtraMs = 40,
        ResolverSmooth = 0.35,
        ResolverGravity = true,
        ResolverGroundClamp = true,
        ResolverAutoAdapt = true,
    },
    PlayerData = {},
    Buttons = {},
    Character = nil,
    Humanoid = nil,
    RootPart = nil,
    Backpack = nil,
}

local function SetupCharacter(char)
    Hub.Character = char

    if char then
        Hub.Humanoid = char:WaitForChild('Humanoid', 5)
        Hub.RootPart = char:FindFirstChild('HumanoidRootPart') or char.PrimaryPart
        Hub.Backpack = LocalPlayer and LocalPlayer:WaitForChild('Backpack', 5)
        Hub.Camera = Workspace and Workspace.CurrentCamera

        if Hub.Config.Invisible then
            Hub.ToggleInvisible(true)
        end
        if Hub.Config.AutoFarmCoins then
            Hub.ToggleAutoFarm(true)
        end
    else
        Hub.Humanoid = nil
        Hub.RootPart = nil
        Hub.Backpack = nil
        Hub.Camera = nil
    end
end

if LocalPlayer and LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end
if LocalPlayer then
    TrackConnection(LocalPlayer.CharacterAdded:Connect(SetupCharacter))
    TrackConnection(LocalPlayer.CharacterRemoving:Connect(function()
        SetupCharacter(nil)
    end))
end

function Hub.CheckPremium(feature)
    if not Hub.IsPremium then
        if Library and Library.Notify then
            Library:Notify({
                Title = 'Premium Restricted',
                Description = 'Upgrade to Premium to access: ' .. tostring(feature),
                Time = 4,
            })
        end

        return false
    end

    return true
end

local InvisibleConn = nil

function Hub.ToggleInvisible(state)
    if not Hub.CheckPremium('Invisible') then
        return
    end

    Hub.Config.Invisible = state

    if InvisibleConn then
        DisconnectConnection(InvisibleConn)

        InvisibleConn = nil
    end
    if state then
        if Hub.Character then
            for _, d in pairs(Hub.Character:GetDescendants())do
                if d:IsA('BasePart') and d.Name ~= 'HumanoidRootPart' then
                    d.Transparency = 0.5
                end
            end
        end

        InvisibleConn = TrackConnection(RunService.Heartbeat:Connect(function()
            local rp = Hub.RootPart
            local hum = Hub.Humanoid

            if rp and hum and rp.Parent then
                local cf = rp.CFrame

                rp.CFrame = cf * CFrame.new(0, -2E5, 0)
                hum.CameraOffset = (cf * CFrame.new(0, -2E5, 0)):ToObjectSpace(CFrame.new(cf.Position)).Position

                RunService.RenderStepped:Wait()

                if rp and rp.Parent then
                    rp.CFrame = cf
                end
            end
        end))
    else
        if Hub.Humanoid then
            Hub.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
        if Hub.Character then
            for _, d in pairs(Hub.Character:GetDescendants())do
                if d:IsA('BasePart') and d.Name ~= 'HumanoidRootPart' then
                    d.Transparency = 0
                end
            end
        end
    end
end

local FlyConn = nil
local ControlModule = nil

task.spawn(function()
    local ps = LocalPlayer and LocalPlayer:FindFirstChild('PlayerScripts')

    if ps then
        local pm = ps:WaitForChild('PlayerModule', 2)

        if pm then
            pcall(function()
                ControlModule = require(pm:FindFirstChild('ControlModule'))
            end)
        end
    end
end)

function Hub.ToggleFly(state)
    if state ~= nil then
        Hub.Config.FlyEnabled = state
    end
    if FlyConn then
        DisconnectConnection(FlyConn)

        FlyConn = nil
    end
    if Hub.RootPart then
        for _, c in ipairs(Hub.RootPart:GetChildren())do
            if c.Name == 'VisionFlyGyro' or c.Name == 'VisionFlyVel' then
                c:Destroy()
            end
        end

        if Hub.Humanoid then
            Hub.Humanoid.PlatformStand = false
        end
    end
    if Hub.Config.FlyEnabled then
        if Hub.Character and Hub.RootPart and Hub.Humanoid then
            local rp = Hub.RootPart
            local cam = Workspace.CurrentCamera
            local bg = Instance.new('BodyGyro')

            bg.Name = 'VisionFlyGyro'
            bg.P = 90000
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = rp.CFrame
            bg.Parent = rp

            local bv = Instance.new('BodyVelocity')

            bv.Name = 'VisionFlyVel'
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = rp
            FlyConn = TrackConnection(RunService.RenderStepped:Connect(function()
                if not Hub.Config.FlyEnabled then
                    Hub.ToggleFly(false)

                    return
                end
                if Hub.Character and Hub.RootPart and Hub.RootPart.Parent and Hub.Humanoid and Hub.Humanoid.Health > 0 then
                    Hub.Humanoid.PlatformStand = true
                    bg.CFrame = cam.CFrame

                    local move = Vector3.new(0, 0, 0)

                    if ControlModule and ControlModule.GetMoveVector then
                        pcall(function()
                            move = ControlModule:GetMoveVector()
                        end)
                    end

                    local y = 0

                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        y = 1
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                        y = -1
                    end

                    local spd = Hub.Config.FlySpeed

                    if move.Magnitude > 0 or y ~= 0 then
                        bv.Velocity = cam.CFrame.RightVector * move.X * spd + cam.CFrame.LookVector * -move.Z * spd + Vector3.new(0, y * spd, 0)
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                else
                    if FlyConn then
                        DisconnectConnection(FlyConn)

                        FlyConn = nil
                    end

                    pcall(function()
                        bg:Destroy()
                        bv:Destroy()
                    end)
                end
            end))
        end
    end
end

if LocalPlayer then
    TrackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        task.spawn(function()
            local ps = LocalPlayer:FindFirstChild('PlayerScripts')

            if ps then
                local pm = ps:WaitForChild('PlayerModule', 2)

                if pm then
                    pcall(function()
                        ControlModule = require(pm:FindFirstChild('ControlModule'))
                    end)
                end
            end
        end)

        local hum = char:WaitForChild('Humanoid', 10)
        local hrp = char:WaitForChild('HumanoidRootPart', 10)

        if hrp and hum then
            Hub.Character = char
            Hub.RootPart = hrp
            Hub.Humanoid = hum

            if Hub.Config.FlyEnabled then
                task.wait()
                Hub.ToggleFly()
            end
        end
    end))
end

local AntiFlingConn = nil

local function AntiFling_DisableCollision(character)
    if not character then
        return
    end

    for _, part in pairs(character:GetDescendants())do
        if part:IsA('BasePart') then
            part.CanCollide = false
        end
    end
end

function Hub.ToggleAntiFling(state)
    Hub.Config.AntiFling = state

    if AntiFlingConn then
        DisconnectConnection(AntiFlingConn)

        AntiFlingConn = nil
    end
    if state then
        AntiFlingConn = TrackConnection(RunService.Stepped:Connect(function()
            local char = LocalPlayer and LocalPlayer.Character

            if not char then
                return
            end

            for _, player in pairs(Players:GetPlayers())do
                if player ~= LocalPlayer and player.Character then
                    AntiFling_DisableCollision(player.Character)
                end
            end

            local hrp = char:FindFirstChild('HumanoidRootPart')

            if hrp then
                if hrp.AssemblyLinearVelocity.Magnitude > 150 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
                if hrp.AssemblyAngularVelocity.Magnitude > 150 then
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end))
    end
end

local SpeedGlitchConn = nil

function Hub.ToggleSpeedGlitch(state)
    if state ~= nil then
        Hub.Config.SpeedGlitch = state and true or false
    end
    if SpeedGlitchConn then
        DisconnectConnection(SpeedGlitchConn)

        SpeedGlitchConn = nil
    end
    if Hub.Config.SpeedGlitch then
        SpeedGlitchConn = TrackConnection(RunService.Heartbeat:Connect(function()
            if not Hub.Config.SpeedGlitch then
                return
            end

            local char = Hub.Character or (LocalPlayer and LocalPlayer.Character)
            local hum = Hub.Humanoid or (char and char:FindFirstChildOfClass('Humanoid'))
            local hrp = Hub.RootPart or (char and char:FindFirstChild('HumanoidRootPart'))

            if not char or not hum or not hrp or hum.Health <= 0 then
                return
            end
            if hum.FloorMaterial == Enum.Material.Air then
                local md = hum.MoveDirection

                if md.Magnitude > 0 then
                    local spd = tonumber(Hub.Config.SpeedGlitchSpeed) or 50
                    local vel = hrp.AssemblyLinearVelocity
                    local v = Vector3.new(md.X * spd, vel.Y, md.Z * spd)

                    hrp.AssemblyLinearVelocity = v

                    pcall(function()
                        hrp.Velocity = v
                    end)
                end
            end
        end))
    end
end
function Hub.SetSpeedGlitchSpeed(val)
    local n = tonumber(val) or 50

    if n <= 0 then
        n = 50
    end

    Hub.Config.SpeedGlitchSpeed = n
end
function Hub.Rejoin()
    if TeleportService and LocalPlayer then
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end
end
function Hub.ServerHop()
    if not TeleportService or not LocalPlayer then
        return
    end

    local url = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
    local ok, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if ok and data and data.data then
        for _, s in ipairs(data.data)do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)

                return
            end
        end
    end

    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

local function FindMap()
    for _, c in ipairs(Workspace:GetChildren())do
        if (c:FindFirstChild('CoinContainer') or c:FindFirstChild('CoinAreas')) and c:FindFirstChild('Spawns') then
            return c
        end
    end

    return nil
end

function Hub.TeleportToMap()
    local char = Hub.Character or (Hub.RootPart and Hub.RootPart.Parent)

    if not char then
        return
    end

    local map = FindMap()

    if not map then
        return
    end

    local spawns = map:FindFirstChild('Spawns')

    if not spawns then
        return
    end

    local list = {}

    for _, c in ipairs(spawns:GetChildren())do
        if c:IsA('BasePart') then
            table.insert(list, c)
        end
    end

    local target = #list > 0 and list[math.random(1, #list)] or (spawns:FindFirstChild('Spawn') or spawns:FindFirstChild('PlayerSpawn'))

    if target and target:IsA('BasePart') then
        char:PivotTo(target.CFrame * CFrame.new(0, 5, 0))
    end
end

local function FindLobby()
    for _, c in ipairs(Workspace:GetChildren())do
        if c:FindFirstChild('Lobby') then
            return c.Lobby
        end
        if c.Name:lower() == 'lobby' then
            return c
        end
    end

    return nil
end

function Hub.TeleportToLobby()
    local char = Hub.Character or (Hub.RootPart and Hub.RootPart.Parent)

    if not char then
        return
    end

    local lobby = FindLobby()

    if not lobby then
        return
    end

    local spawns = lobby:FindFirstChild('Spawns')

    if not spawns then
        return
    end

    local list = {}

    for _, c in ipairs(spawns:GetChildren())do
        if c:IsA('BasePart') then
            table.insert(list, c)
        end
    end

    local target = #list > 0 and list[math.random(1, #list)] or spawns:FindFirstChild('SpawnLocation')

    if target and target:IsA('BasePart') then
        char:PivotTo(target.CFrame * CFrame.new(0, 5, 0))
    end
end
function Hub.GetPlayerByName(name)
    if not name then
        return nil
    end

    for _, p in ipairs(Players:GetPlayers())do
        if p.Name:lower() == name:lower() then
            return p
        end
    end

    return nil
end
function Hub.FindMurderer()
    if Hub.PlayerData then
        for k, v in pairs(Hub.PlayerData)do
            if v.Role == 'Murderer' then
                local p = Hub.GetPlayerByName(k)

                if p then
                    return p
                end
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers())do
        local bp = p:FindFirstChild('Backpack')

        if (bp and bp:FindFirstChild('Knife')) or (p.Character and p.Character:FindFirstChild('Knife')) then
            return p
        end
    end

    return nil
end
function Hub.FindSheriff()
    if Hub.PlayerData then
        for k, v in pairs(Hub.PlayerData)do
            if v.Role == 'Sheriff' or v.Role == 'Hero' then
                local p = Hub.GetPlayerByName(k)

                if p then
                    return p
                end
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers())do
        local bp = p:FindFirstChild('Backpack')

        if (bp and bp:FindFirstChild('Gun')) or (p.Character and p.Character:FindFirstChild('Gun')) then
            return p
        end
    end

    return nil
end
function Hub.FindInnocent(plr)
    if plr and Hub.PlayerData then
        local d = Hub.PlayerData[plr.Name]

        return d and d.Role == 'Innocent'
    end

    return false
end

local Remotes = ReplicatedStorage:WaitForChild('Remotes', 10)
local Gameplay = Remotes and Remotes:WaitForChild('Gameplay', 10)
local PlayerDataChanged = Gameplay and Gameplay:WaitForChild('PlayerDataChanged', 10)

if PlayerDataChanged then
    TrackConnection(PlayerDataChanged.OnClientEvent:Connect(function(data)
        if typeof(data) == 'table' then
            Hub.PlayerData = data
        end
    end))
end

local ESPStore = {}

getgenv().ClearESP = function()
    for _, v in pairs(ESPStore)do
        for _, v2 in pairs(v)do
            if typeof(v2) ~= 'table' then
                if v2 and v2.Remove then
                    v2:Remove()
                end
            else
                for _, v3 in ipairs(v2)do
                    v3:Remove()
                end
            end
        end
    end

    table.clear(ESPStore)

    for _, p in ipairs(Players:GetPlayers())do
        local c = p.Character

        if c then
            local h = c:FindFirstChild('VisionHighlight')

            if h then
                pcall(function()
                    h:Destroy()
                end)
            end

            local i = c:FindFirstChild('VisionInfoESP')

            if i then
                pcall(function()
                    i:Destroy()
                end)
            end
        end
    end

    local map = FindMap()

    if map then
        local gd = map:FindFirstChild('GunDrop')

        if gd then
            local gh = gd:FindFirstChild('VisionGunHighlight')

            if gh then
                pcall(function()
                    gh:Destroy()
                end)
            end

            local gi = gd:FindFirstChild('VisionGunInfo')

            if gi then
                pcall(function()
                    gi:Destroy()
                end)
            end
        end
    end
end

local _espRoleCache = {
    murderer = nil,
    sheriff = nil,
    nextUpdate = 0,
}

local function _espAnyEnabled()
    local c = Hub.Config

    if not c then
        return false
    end

    local any = c.HighlightMurderer or c.InfoMurderer or c.BoxMurderer or c.TracersMurderer or c.SkeletonMurderer or c.HighlightSheriff or c.InfoSheriff or c.BoxSheriff or c.TracersSheriff or c.SkeletonSheriff or c.HighlightInnocent or c.InfoInnocent or c.BoxInnocent or c.TracersInnocent or c.SkeletonInnocent or c.ESPGunDropped or c.HealthBarEnabled

    if any then
        c.ESPEnabled = true
    end

    return any and c.ESPEnabled ~= false
end

TrackConnection(RunService.RenderStepped:Connect(function()
    if not _espAnyEnabled() then
        for _, store in pairs(ESPStore)do
            if store.Box then
                store.Box.Visible = false
            end
            if store.Tracer then
                store.Tracer.Visible = false
            end
            if store.Skeleton then
                for _, s in ipairs(store.Skeleton)do
                    s.Visible = false
                end
            end
        end

        return
    end

    local now = os.clock()

    if now >= _espRoleCache.nextUpdate then
        _espRoleCache.murderer = Hub.FindMurderer()
        _espRoleCache.sheriff = Hub.FindSheriff()
        _espRoleCache.nextUpdate = now + 0.25
    end

    local murderer = _espRoleCache.murderer
    local sheriff = _espRoleCache.sheriff
    local cam = Workspace.CurrentCamera

    for _, player in ipairs(Players:GetPlayers())do
        local char = player.Character

        if player ~= LocalPlayer and char and char:FindFirstChild('HumanoidRootPart') and char:FindFirstChild('Humanoid') then
            local hum = char:FindFirstChildOfClass('Humanoid')

            if hum and hum.Health > 0 then
                local role, color = nil, nil

                if murderer and player == murderer then
                    role, color = 'Murderer', Hub.Config.ESPColorMurderer
                elseif sheriff and player == sheriff then
                    role, color = 'Sheriff', Hub.Config.ESPColorSheriff
                elseif Hub.FindInnocent(player) then
                    role, color = 'Innocent', Hub.Config.ESPColorInnocent
                end
                if not role then
                    if ESPStore[player] then
                        ESPStore[player].Box.Visible = false
                        ESPStore[player].Tracer.Visible = false

                        for _, s in ipairs(ESPStore[player].Skeleton)do
                            s.Visible = false
                        end
                    end
                else
                    if not ESPStore[player] then
                        ESPStore[player] = {
                            Box = Drawing.new('Square'),
                            Tracer = Drawing.new('Line'),
                            Skeleton = {},
                        }
                        ESPStore[player].Box.Thickness = 1
                        ESPStore[player].Box.Filled = false
                        ESPStore[player].Box.ZIndex = 2
                        ESPStore[player].Tracer.Thickness = 1
                        ESPStore[player].Tracer.Transparency = 1
                        ESPStore[player].Tracer.ZIndex = 1

                        for _ = 1, 16 do
                            local line = Drawing.new('Line')

                            line.Thickness = 1
                            line.Transparency = 1
                            line.ZIndex = 2

                            table.insert(ESPStore[player].Skeleton, line)
                        end
                    end

                    local store = ESPStore[player]
                    local hrp = char:FindFirstChild('HumanoidRootPart')
                    local head = char:FindFirstChild('Head')

                    if Hub.Config.ESPEnabled and Hub.Config['Highlight' .. role] then
                        local hl = char:FindFirstChild('VisionHighlight')

                        if not hl then
                            hl = Instance.new('Highlight')
                            hl.Name = 'VisionHighlight'
                            hl.FillTransparency = 0.85
                            hl.OutlineTransparency = 0
                            hl.Parent = char
                        end

                        hl.FillColor = color
                        hl.OutlineColor = color
                        hl.Enabled = true
                    else
                        local hl = char:FindFirstChild('VisionHighlight')

                        if hl then
                            hl:Destroy()
                        end
                    end
                    if Hub.Config.ESPEnabled and Hub.Config['Info' .. role] and (head or hrp) then
                        local info = char:FindFirstChild('VisionInfoESP')

                        if not info then
                            info = Instance.new('BillboardGui', char)
                            info.Name = 'VisionInfoESP'
                            info.Size = UDim2.fromOffset(200, 50)
                            info.StudsOffset = Vector3.new(0, 3.5, 0)
                            info.AlwaysOnTop = true

                            local label = Instance.new('TextLabel', info)

                            label.Name = 'InfoLabel'
                            label.BackgroundTransparency = 1
                            label.Size = UDim2.fromScale(1, 1)
                            label.TextStrokeTransparency = 0
                            label.Font = Enum.Font.SourceSansBold
                            label.TextSize = 16
                            label.RichText = true
                        end

                        info.Adornee = head or hrp

                        local dist = hrp and math.floor((cam.CFrame.Position - hrp.Position).Magnitude) or 0
                        local label = info:FindFirstChild('InfoLabel')

                        if label then
                            label.Text = string.format("%s\n<font size='11' color='#DDDDDD'>[%d]</font>", player.Name, dist)
                            label.TextColor3 = color
                        end
                    else
                        local info = char:FindFirstChild('VisionInfoESP')

                        if info then
                            info:Destroy()
                        end
                    end

                    local boxOn = Hub.Config.ESPEnabled and (Hub.Config['Box' .. role] or false)
                    local hrpPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
                    local headPos = head and cam:WorldToViewportPoint(head.Position) or hrpPos

                    if boxOn and onScreen then
                        local topY = math.min(hrpPos.Y, headPos.Y) - 10
                        local bottomY = math.max(hrpPos.Y, headPos.Y) + 20
                        local height = math.max(bottomY - topY, 20)
                        local width = height * 0.65
                        local boxX = hrpPos.X - width / 2
                        local boxY = topY

                        store.Box.Size = Vector2.new(width, height)
                        store.Box.Position = Vector2.new(boxX, boxY)
                        store.Box.Color = color or Hub.Config.BoxColor
                        store.Box.Thickness = Hub.Config.BoxThickness or 1
                        store.Box.Filled = Hub.Config.BoxFilled or false
                        store.Box.Transparency = Hub.Config.BoxFilled and (Hub.Config.BoxFillTransparency or 0.7) or 1
                        store.Box.Visible = true
                        store.lastBoxX = boxX
                        store.lastBoxY = boxY
                        store.lastBoxW = width
                        store.lastBoxH = height
                    else
                        store.Box.Visible = false
                        store.lastBoxX = nil
                    end
                    if Hub.Config.ESPEnabled and Hub.Config.HealthBarEnabled and store.lastBoxX and hum then
                        if not store.HealthBar then
                            store.HealthBar = Drawing.new('Line')
                            store.HealthBar.Thickness = 3
                            store.HealthBar.ZIndex = 3
                            store.HealthBarOutline = Drawing.new('Line')
                            store.HealthBarOutline.Thickness = 5
                            store.HealthBarOutline.Color = Color3.new(0, 0, 0)
                            store.HealthBarOutline.ZIndex = 2
                        end

                        local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        local barColor = (Hub.Config.HealthBarColorHigh or Color3.fromRGB(0, 255, 0)):Lerp(Hub.Config.HealthBarColorLow or Color3.fromRGB(255, 0, 0), 1 - hp)
                        local side = Hub.Config.HealthBarSide or 'left'
                        local bx, by, bw, bh = store.lastBoxX, store.lastBoxY, store.lastBoxW, store.lastBoxH
                        local x1, y1, x2, y2

                        if side == 'left' then
                            x1 = bx - 5
                            x2 = bx - 5
                            y1 = by + bh
                            y2 = by + bh * (1 - hp)
                        elseif side == 'right' then
                            x1 = bx + bw + 5
                            x2 = bx + bw + 5
                            y1 = by + bh
                            y2 = by + bh * (1 - hp)
                        elseif side == 'top' then
                            y1 = by - 5
                            y2 = by - 5
                            x1 = bx
                            x2 = bx + bw * hp
                        else
                            y1 = by + bh + 5
                            y2 = by + bh + 5
                            x1 = bx
                            x2 = bx + bw * hp
                        end
                        if side == 'left' or side == 'right' then
                            store.HealthBarOutline.From = Vector2.new(x1, by + bh)
                            store.HealthBarOutline.To = Vector2.new(x1, by)
                            store.HealthBar.From = Vector2.new(x1, y1)
                            store.HealthBar.To = Vector2.new(x2, y2)
                        else
                            store.HealthBarOutline.From = Vector2.new(bx, y1)
                            store.HealthBarOutline.To = Vector2.new(bx + bw, y1)
                            store.HealthBar.From = Vector2.new(x1, y1)
                            store.HealthBar.To = Vector2.new(x2, y2)
                        end

                        store.HealthBar.Color = barColor
                        store.HealthBar.Visible = true
                        store.HealthBarOutline.Visible = true
                    elseif store.HealthBar then
                        store.HealthBar.Visible = false

                        if store.HealthBarOutline then
                            store.HealthBarOutline.Visible = false
                        end
                    end

                    store.Tracer.Visible = Hub.Config.ESPEnabled and (Hub.Config['Tracers' .. role] or false)

                    for _, s in ipairs(store.Skeleton)do
                        s.Visible = Hub.Config.ESPEnabled and (Hub.Config['Skeleton' .. role] or false)
                    end
                end
            end
        end
    end

    local map = FindMap()
    local gunDrop = map and map:FindFirstChild('GunDrop')

    if gunDrop and gunDrop:IsA('BasePart') then
        if Hub.Config.ESPGunDropped then
            local hl = gunDrop:FindFirstChild('VisionGunHighlight')

            if not hl then
                hl = Instance.new('Highlight')
                hl.Name = 'VisionGunHighlight'
                hl.FillTransparency = 0.4
                hl.OutlineTransparency = 0
                hl.Parent = gunDrop
            end

            hl.FillColor = Color3.fromRGB(0, 255, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.Enabled = true

            local info = gunDrop:FindFirstChild('VisionGunInfo')

            if not info then
                info = Instance.new('BillboardGui', gunDrop)
                info.Name = 'VisionGunInfo'
                info.Size = UDim2.fromOffset(100, 40)
                info.StudsOffset = Vector3.new(0, 2, 0)
                info.AlwaysOnTop = true

                local label = Instance.new('TextLabel', info)

                label.BackgroundTransparency = 1
                label.Size = UDim2.fromScale(1, 1)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.SourceSansBold
                label.TextSize = 18
                label.RichText = true
                label.TextColor3 = Color3.fromRGB(0, 255, 255)
            end

            local dist = math.floor((cam.CFrame.Position - gunDrop.Position).Magnitude)
            local label = info:FindFirstChildOfClass('TextLabel')

            if label then
                label.Text = string.format("<b>GUN</b>\n<font size='13' color='#DDDDDD'>[%d]</font>", dist)
            end
        else
            local hl = gunDrop:FindFirstChild('VisionGunHighlight')

            if hl then
                hl:Destroy()
            end

            local info = gunDrop:FindFirstChild('VisionGunInfo')

            if info then
                info:Destroy()
            end
        end
    end

    for k, v in pairs(ESPStore)do
        if not k.Parent then
            v.Box:Remove()
            v.Tracer:Remove()

            for _, s in ipairs(v.Skeleton)do
                s:Remove()
            end

            if v.HealthBar then
                pcall(function()
                    v.HealthBar:Remove()
                end)
            end
            if v.HealthBarOutline then
                pcall(function()
                    v.HealthBarOutline:Remove()
                end)
            end

            ESPStore[k] = nil
        end
    end
end))
TrackConnection(Players.PlayerRemoving:Connect(function(p)
    if ESPStore[p] then
        ESPStore[p].Box:Remove()
        ESPStore[p].Tracer:Remove()

        for _, s in ipairs(ESPStore[p].Skeleton)do
            s:Remove()
        end

        ESPStore[p] = nil
    end
end))

local OffScreenArrowStore = {}

local function OffScreenArrow_GetRelative(pos, char)
    if not char or not char.PrimaryPart then
        return Vector2.new(0, 0)
    end

    local rootP = char.PrimaryPart.Position
    local camP = Camera and Camera.CFrame.Position or Workspace.CurrentCamera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)

    return Vector2.new(relative.X, relative.Z)
end
local function OffScreenArrow_RelativeToCenter(v)
    local cam = Workspace.CurrentCamera

    return cam.ViewportSize / 2 - v
end
local function OffScreenArrow_RotateVect(v, a)
    a = math.rad(a)

    local x = v.X * math.cos(a) - v.Y * math.sin(a)
    local y = v.X * math.sin(a) + v.Y * math.cos(a)

    return Vector2.new(x, y)
end
local function OffScreenArrow_AntiA(v)
    if not Hub.Config.OffScreenArrowAntiAlias then
        return v
    end

    return Vector2.new(math.round(v.X), math.round(v.Y))
end
local function OffScreenArrow_MakeTriangle()
    local t = Drawing.new('Triangle')

    t.Visible = false
    t.Color = Hub.Config.OffScreenArrowColor or Color3.fromRGB(255, 255, 255)
    t.Filled = Hub.Config.OffScreenArrowFilled ~= false
    t.Thickness = Hub.Config.OffScreenArrowThickness or 1
    t.Transparency = 1 - (Hub.Config.OffScreenArrowTransparency or 0)
    t.ZIndex = 5

    return t
end
local function OffScreenArrow_HideAll()
    for _, tri in pairs(OffScreenArrowStore)do
        if tri then
            tri.Visible = false
        end
    end
end
local function OffScreenArrow_Remove(player)
    local tri = OffScreenArrowStore[player]

    if tri then
        pcall(function()
            tri:Remove()
        end)

        OffScreenArrowStore[player] = nil
    end
end

function Hub.ToggleOffScreenArrows(state)
    Hub.Config.OffScreenArrows = state and true or false

    if not Hub.Config.OffScreenArrows then
        OffScreenArrow_HideAll()
    end
end

TrackConnection(RunService.RenderStepped:Connect(function()
    if not Hub.Config or not Hub.Config.OffScreenArrows then
        OffScreenArrow_HideAll()

        return
    end

    local cam = Workspace.CurrentCamera

    if not cam then
        OffScreenArrow_HideAll()

        return
    end

    local myChar = LocalPlayer and LocalPlayer.Character
    local distFromCenter = tonumber(Hub.Config.OffScreenArrowDist) or 80
    local triH = tonumber(Hub.Config.OffScreenArrowHeight) or 16
    local triW = tonumber(Hub.Config.OffScreenArrowWidth) or 16
    local color = Hub.Config.OffScreenArrowColor or Color3.fromRGB(255, 255, 255)
    local filled = Hub.Config.OffScreenArrowFilled ~= false
    local thickness = tonumber(Hub.Config.OffScreenArrowThickness) or 1
    local transparency = 1 - (tonumber(Hub.Config.OffScreenArrowTransparency) or 0)

    for _, player in ipairs(Players:GetPlayers())do
        if player ~= LocalPlayer then
            local tri = OffScreenArrowStore[player]

            if not tri then
                tri = OffScreenArrow_MakeTriangle()
                OffScreenArrowStore[player] = tri
            end

            local char = player.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            local primary = char and char.PrimaryPart

            if char and hum and primary and hum.Health > 0 then
                local _, onScreen = cam:WorldToViewportPoint(primary.Position)

                if not onScreen then
                    local rel = OffScreenArrow_GetRelative(primary.Position, myChar)

                    if rel.Magnitude > 0.001 then
                        local direction = rel.Unit
                        local base = direction * distFromCenter
                        local sideLength = triW / 2
                        local baseL = base + OffScreenArrow_RotateVect(direction, 90) * sideLength
                        local baseR = base + OffScreenArrow_RotateVect(direction, -90) * sideLength
                        local tip = direction * (distFromCenter + triH)

                        tri.PointA = OffScreenArrow_AntiA(OffScreenArrow_RelativeToCenter(baseL))
                        tri.PointB = OffScreenArrow_AntiA(OffScreenArrow_RelativeToCenter(baseR))
                        tri.PointC = OffScreenArrow_AntiA(OffScreenArrow_RelativeToCenter(tip))
                        tri.Color = color
                        tri.Filled = filled
                        tri.Thickness = thickness
                        tri.Transparency = transparency
                        tri.Visible = true
                    else
                        tri.Visible = false
                    end
                else
                    tri.Visible = false
                end
            else
                tri.Visible = false
            end
        end
    end
    for p, tri in pairs(OffScreenArrowStore)do
        if not p or not p.Parent then
            OffScreenArrow_Remove(p)
        end
    end
end))
TrackConnection(Players.PlayerRemoving:Connect(function(p)
    OffScreenArrow_Remove(p)
end))

function Hub.FlingTarget(target)
    if not target or not target.Character then
        return
    end

    local myChar = LocalPlayer.Character
    local myHum = myChar and myChar:FindFirstChildOfClass('Humanoid')
    local myRoot = myChar and (myChar:FindFirstChild('HumanoidRootPart') or (myHum and myHum.RootPart))
    local tChar = target.Character
    local tHum = tChar and tChar:FindFirstChildOfClass('Humanoid')
    local tRoot = tChar and (tChar:FindFirstChild('HumanoidRootPart') or (tHum and tHum.RootPart))
    local tHead = tChar and tChar:FindFirstChild('Head')
    local tAcc = tChar and tChar:FindFirstChildOfClass('Accessory')
    local tHandle = tAcc and tAcc:FindFirstChild('Handle')

    if not (myChar and myHum and myRoot) then
        return
    end
    if myRoot.AssemblyLinearVelocity.Magnitude < 50 then
        getgenv().OldPos = myRoot.CFrame
    end

    getgenv().FPDH = Workspace.FallenPartsDestroyHeight
    Workspace.FallenPartsDestroyHeight = -5E4

    if tHead then
        Workspace.CurrentCamera.CameraSubject = tHead
    elseif tHandle then
        Workspace.CurrentCamera.CameraSubject = tHandle
    elseif tHum and tRoot then
        Workspace.CurrentCamera.CameraSubject = tHum
    end
    if not tChar:FindFirstChildWhichIsA('BasePart') then
        return
    end

    local function ApplyFling(part, offset, rot)
        if myRoot and myRoot.Parent then
            myRoot.CFrame = CFrame.new(part.Position) * offset * rot

            if myChar.PrimaryPart then
                myChar:PivotTo(CFrame.new(part.Position) * offset * rot)
            end

            myRoot.AssemblyLinearVelocity = Vector3.new(10000, 10000, 10000)
            myRoot.AssemblyAngularVelocity = Vector3.new(10000, 10000, 10000)
        end
    end
    local function FlingLoop(part)
        local start = tick()
        local angle = 0

        while true do
            pcall(function()
                if myRoot and tHum and part.Parent then
                    if part.AssemblyLinearVelocity.Magnitude < 50 then
                        angle = angle + 100

                        ApplyFling(part, CFrame.new(0, 1.5, 0) + tHum.MoveDirection * part.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                        task.wait()
                        ApplyFling(part, CFrame.new(0, -1.5, 0) + tHum.MoveDirection * part.AssemblyLinearVelocity.Magnitude / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
                        task.wait()
                    else
                        ApplyFling(part, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        ApplyFling(part, CFrame.new(0, -1.5, -tHum.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                end
            end)

            local stillValid = part and part.Parent and part.Parent == target.Character
            local notSit = tHum and not tHum.Sit
            local alive = myHum and myHum.Health > 0
            local lowVel = true

            pcall(function()
                lowVel = part.AssemblyLinearVelocity.Magnitude < 500
            end)

            if not stillValid or not notSit or not alive or not lowVel or tick() > start + 2.5 then
                break
            end
        end
    end

    local bv = Instance.new('BodyVelocity')

    bv.Name = 'VisionHub_FlingVelocity'
    bv.Parent = myRoot
    bv.Velocity = Vector3.new(10000, 10000, 10000)
    bv.MaxForce = Vector3.new((1 / 0), (1 / 0), (1 / 0))

    local bav = Instance.new('BodyAngularVelocity')

    bav.Name = 'VisionHub_SpinVelocity'
    bav.Parent = myRoot
    bav.AngularVelocity = Vector3.new(10000, 10000, 10000)
    bav.MaxTorque = Vector3.new((1 / 0), (1 / 0), (1 / 0))

    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if tRoot and tHead and (tRoot.CFrame.p - tHead.CFrame.p).Magnitude <= 5 then
        FlingLoop(tRoot)
    elseif tHead then
        FlingLoop(tHead)
    elseif tRoot then
        FlingLoop(tRoot)
    elseif tHandle then
        FlingLoop(tHandle)
    end
    if bv then
        bv:Destroy()
    end
    if bav then
        bav:Destroy()
    end

    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    Workspace.CurrentCamera.CameraSubject = myHum

    myHum:ChangeState('GettingUp')

    if getgenv().OldPos then
        myRoot.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
    end

    for _, c in ipairs(myChar:GetChildren())do
        if c:IsA('BasePart') then
            c.AssemblyLinearVelocity = Vector3.zero
            c.AssemblyAngularVelocity = Vector3.zero
        end
    end

    Workspace.FallenPartsDestroyHeight = getgenv().FPDH or -500
end

local ResolverState = {
    samples = {},
    lastPos = nil,
    lastVel = Vector3.zero,
    lastT = 0,
    smoothPos = nil,
    shootSmoothPos = nil,
    targetUserId = nil,
    pingEma = 0.055,
    pingRaw = 0.055,
    pingSamples = {},
    lastPingSampleT = 0,
    pingP75 = 0.055,
    pingP90 = 0.06,
    adaptedScale = 1,
    adaptedExtraMs = 36,
    adaptedSmooth = 0.18,
    adaptedShootSmooth = 0.03,
    adaptedLead = 0.09,
    velEma = Vector3.zero,
    hVelEma = Vector3.zero,
    accelEma = Vector3.zero,
    strafeScore = 0,
    dirChangeScore = 0,
    oscScore = 0,
    isAirborne = false,
    lastSignX = 0,
    lastSignZ = 0,
    signFlipCount = 0,
    signWindowT = 0,
    lastHDir = Vector3.zero,
    confidence = 1,
    jumpVy0 = 0,
    airborneSince = 0,
}

local function Resolver_GetPingSeconds()
    local ping = 0.05

    pcall(function()
        if Stats then
            local net = Stats:FindFirstChild('Network')
            local ssi = net and net:FindFirstChild('ServerStatsItem')
            local dp = ssi and ssi:FindFirstChild('Data Ping')

            if dp then
                ping = math.clamp(dp:GetValue() / 1000, 0.006, 0.4)
            end
        end
    end)

    return ping
end
local function Resolver_Percentile(sorted, p)
    if #sorted == 0 then
        return 0
    end
    if #sorted == 1 then
        return sorted[1]
    end

    local idx = (p / 100) * (#sorted - 1) + 1
    local lo = math.floor(idx)
    local hi = math.min(#sorted, lo + 1)
    local f = idx - lo

    return sorted[lo] * (1 - f) + sorted[hi] * f
end
local function Resolver_UpdatePingStats()
    local raw = Resolver_GetPingSeconds()

    ResolverState.pingRaw = raw

    local now = os.clock()
    local delta = math.abs(raw - ResolverState.pingEma)
    local alpha = (delta > 0.08 and 0.08) or (delta > 0.04 and 0.18) or 0.32

    ResolverState.pingEma = ResolverState.pingEma + (raw - ResolverState.pingEma) * alpha

    if (now - ResolverState.lastPingSampleT) >= 0.06 then
        ResolverState.lastPingSampleT = now

        table.insert(ResolverState.pingSamples, raw)

        while#ResolverState.pingSamples > 32 do
            table.remove(ResolverState.pingSamples, 1)
        end

        if #ResolverState.pingSamples >= 5 then
            local sorted = {}

            for i = 1, #ResolverState.pingSamples do
                sorted[i] = ResolverState.pingSamples[i]
            end

            table.sort(sorted)

            ResolverState.pingP75 = Resolver_Percentile(sorted, 75)
            ResolverState.pingP90 = Resolver_Percentile(sorted, 90)
        else
            ResolverState.pingP75 = ResolverState.pingEma
            ResolverState.pingP90 = math.max(ResolverState.pingEma, raw)
        end
    end

    return ResolverState.pingEma, raw
end
local function Resolver_GetPingJitter()
    local s = ResolverState.pingSamples

    if #s < 5 then
        return 0
    end

    local mean = 0

    for i = 1, #s do
        mean = mean + s[i]
    end

    mean = mean / #s

    local var = 0

    for i = 1, #s do
        local d = s[i] - mean

        var = var + d * d
    end

    return math.sqrt(var / #s)
end

function Hub.GetAdaptivePredictionParams()
    local cfg = Hub.Config or {}
    local pingEma = Resolver_UpdatePingStats()
    local pingMs = pingEma * 1000
    local p75Ms = (ResolverState.pingP75 or pingEma) * 1000
    local p90Ms = (ResolverState.pingP90 or pingEma) * 1000
    local jitterMs = Resolver_GetPingJitter() * 1000
    local effectivePing = pingEma * 0.45 + (ResolverState.pingP75 or pingEma) * 0.55
    local scale = 0.48 + math.clamp((p75Ms - 40) / 140, 0, 1) * 0.08 + math.clamp(jitterMs / 40, 0, 1) * 0.04
    local extraMs

    if p75Ms <= 30 then
        extraMs = 18 + p75Ms * 0.2
    elseif p75Ms <= 60 then
        extraMs = 24 + (p75Ms - 30) * 0.42
    elseif p75Ms <= 100 then
        extraMs = 37 + (p75Ms - 60) * 0.28
    else
        extraMs = 48 + (p75Ms - 100) * 0.12
    end

    extraMs = extraMs + math.clamp(jitterMs * 0.6, 0, 20)
    extraMs = extraMs + (1 - ResolverState.confidence) * 8

    local smoothEsp

    if p75Ms <= 40 then
        smoothEsp = 0.1
    elseif p75Ms <= 80 then
        smoothEsp = 0.14 + (p75Ms - 40) / 40 * 0.1
    else
        smoothEsp = 0.24 + math.clamp((p75Ms - 80) / 100, 0, 1) * 0.14
    end

    local smoothShoot = math.clamp(0.02 + smoothEsp * 0.08, 0.01, 0.07)
    local userScale = tonumber(cfg.ResolverLatencyScale) or 1
    local userExtra = tonumber(cfg.ResolverExtraMs) or 40
    local halfPart = effectivePing * scale * userScale

    extraMs = extraMs + (userExtra - 40)
    extraMs = math.clamp(extraMs, 5, 115)
    smoothEsp = math.clamp(smoothEsp, 0.03, 0.65)
    smoothShoot = math.clamp(smoothShoot, 0.008, 0.1)

    local lead = halfPart + extraMs / 1000
    local cut = math.clamp(ResolverState.strafeScore * 0.1 + ResolverState.dirChangeScore * 0.08 + ResolverState.oscScore * 0.12, 0, 0.22)

    lead = lead * (1 - cut)
    lead = math.clamp(lead, 0.014, 0.38)
    ResolverState.adaptedScale = scale * userScale
    ResolverState.adaptedExtraMs = extraMs
    ResolverState.adaptedSmooth = smoothEsp
    ResolverState.adaptedShootSmooth = smoothShoot
    ResolverState.adaptedLead = lead

    return {
        ping = pingEma,
        pingMs = pingMs,
        pingRaw = ResolverState.pingRaw,
        p75Ms = p75Ms,
        p90Ms = p90Ms,
        jitterMs = jitterMs,
        scale = ResolverState.adaptedScale,
        extraMs = extraMs,
        smooth = smoothEsp,
        shootSmooth = smoothShoot,
        lead = lead,
        strafeScore = ResolverState.strafeScore,
        dirChangeScore = ResolverState.dirChangeScore,
        oscScore = ResolverState.oscScore,
        confidence = ResolverState.confidence,
    }
end

local function Resolver_GetAimPart(char, mode)
    mode = mode or 'Head'

    local head = char:FindFirstChild('Head')
    local torso = char:FindFirstChild('UpperTorso') or char:FindFirstChild('Torso')
    local hrp = char:FindFirstChild('HumanoidRootPart')

    if mode == 'Head' then
        return head or torso or hrp
    elseif mode == 'Torso' then
        return torso or hrp or head
    elseif mode == 'HRP' then
        return hrp or torso or head
    elseif mode == 'Closest' then
        local cam = Workspace.CurrentCamera
        local origin = cam and cam.CFrame.Position or (Hub.RootPart and Hub.RootPart.Position)

        if origin then
            local best, bestDist = nil, math.huge

            for _, p in ipairs({head, torso, hrp})do
                if p and p:IsA('BasePart') then
                    local d = (p.Position - origin).Magnitude

                    if d < bestDist then
                        bestDist = d
                        best = p
                    end
                end
            end

            if best then
                return best
            end
        end
    elseif mode == 'Auto' then
        local origin = (Hub.RootPart and Hub.RootPart.Position) or (Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position)

        if origin and hrp then
            local dist = (hrp.Position - origin).Magnitude

            if dist < 48 and head then
                return head
            end
            if torso then
                return torso
            end
        end

        return head or torso or hrp
    end

    return hrp or char.PrimaryPart
end
local function Resolver_PushSample(pos, vel, aimPos, grounded)
    local now = os.clock()

    if vel and vel.Magnitude > 80 then
        vel = vel.Unit * 80
    end

    local hvel = Vector3.new(vel.X, 0, vel.Z)

    table.insert(ResolverState.samples, {
        t = now,
        pos = pos,
        vel = vel,
        hvel = hvel,
        aimPos = aimPos or pos,
        grounded = grounded and true or false,
    })

    while#ResolverState.samples > 24 do
        table.remove(ResolverState.samples, 1)
    end
    while#ResolverState.samples > 0 and (now - ResolverState.samples[1].t) > 0.45 do
        table.remove(ResolverState.samples, 1)
    end

    local a = 0.42

    if ResolverState.velEma.Magnitude < 0.01 then
        ResolverState.velEma = vel
        ResolverState.hVelEma = hvel
    else
        ResolverState.velEma = ResolverState.velEma:Lerp(vel, a)
        ResolverState.hVelEma = ResolverState.hVelEma:Lerp(hvel, a)
    end

    local hDir = hvel.Magnitude > 1 and hvel.Unit or Vector3.zero

    if ResolverState.lastHDir.Magnitude > 0.4 and hDir.Magnitude > 0.4 then
        local dot = math.clamp(ResolverState.lastHDir:Dot(hDir), -1, 1)
        local turn = 1 - dot

        ResolverState.dirChangeScore = ResolverState.dirChangeScore * 0.84 + math.clamp(turn * 0.55, 0, 1) * 0.16
    else
        ResolverState.dirChangeScore = ResolverState.dirChangeScore * 0.93
    end
    if hDir.Magnitude > 0.4 then
        ResolverState.lastHDir = hDir
    end

    local sx = hvel.X > 1.2 and 1 or (hvel.X < -1.2 and -1 or 0)
    local sz = hvel.Z > 1.2 and 1 or (hvel.Z < -1.2 and -1 or 0)

    if ResolverState.signWindowT == 0 then
        ResolverState.signWindowT = now
    end
    if (now - ResolverState.signWindowT) > 0.48 then
        ResolverState.signFlipCount = math.max(0, ResolverState.signFlipCount - 1)
        ResolverState.signWindowT = now
    end
    if sx ~= 0 and ResolverState.lastSignX ~= 0 and sx ~= ResolverState.lastSignX then
        ResolverState.signFlipCount = ResolverState.signFlipCount + 1
    end
    if sz ~= 0 and ResolverState.lastSignZ ~= 0 and sz ~= ResolverState.lastSignZ then
        ResolverState.signFlipCount = ResolverState.signFlipCount + 1
    end
    if sx ~= 0 then
        ResolverState.lastSignX = sx
    end
    if sz ~= 0 then
        ResolverState.lastSignZ = sz
    end

    ResolverState.strafeScore = math.clamp(ResolverState.signFlipCount / 5, 0, 1)

    local osc = 0
    local s = ResolverState.samples

    if #s >= 6 then
        local flips = 0
        local checks = 0
        local last = nil

        for i = math.max(1, #s - 10), #s do
            local hv = s[i].hvel

            if hv.Magnitude > 1.5 then
                local d = hv.Unit

                if last then
                    checks = checks + 1

                    if last:Dot(d) < 0 then
                        flips = flips + 1
                    end
                end

                last = d
            end
        end

        if checks > 0 then
            osc = flips / checks
        end
    end

    ResolverState.oscScore = ResolverState.oscScore * 0.75 + osc * 0.25
end
local function Resolver_EstimateAccel()
    local s = ResolverState.samples

    if #s < 4 then
        return Vector3.zero
    end

    local a = s[math.max(1, #s - 3)]
    local b = s[#s]
    local dt = b.t - a.t

    if dt < 0.025 then
        return Vector3.zero
    end

    local accel = (b.vel - a.vel) / dt

    if accel.Magnitude > 140 then
        accel = accel.Unit * 140
    end
    if ResolverState.accelEma.Magnitude < 0.01 then
        ResolverState.accelEma = accel
    else
        ResolverState.accelEma = ResolverState.accelEma:Lerp(accel, 0.28)
    end

    accel = ResolverState.accelEma

    local damp = 1 - ResolverState.strafeScore * 0.65 - ResolverState.dirChangeScore * 0.4 - ResolverState.oscScore * 0.5

    accel = accel * math.clamp(damp, 0.05, 1)

    return accel
end
local function Resolver_EstimateVelFromHistory()
    local s = ResolverState.samples

    if #s < 3 then
        return nil, 0
    end

    local n = math.min(#s, 10)
    local startIdx = #s - n + 1
    local wSum, vSum = 0, Vector3.zero
    local valid = 0

    for i = startIdx, #s - 1 do
        local a, b = s[i], s[i + 1]
        local dt = b.t - a.t

        if dt >= 0.01 and dt < 0.18 then
            local seg = (b.pos - a.pos) / dt

            if seg.Magnitude <= 72 then
                local age = (#s - i)
                local w = 1.2 + age * 0.15

                w = 1 + (i - startIdx) * 0.4
                vSum = vSum + seg * w
                wSum = wSum + w
                valid = valid + 1
            end
        end
    end

    if wSum < 0.01 or valid < 2 then
        return nil, 0
    end

    local v = vSum / wSum

    if v.Magnitude > 72 then
        return nil, 0
    end

    local conf = math.clamp(valid / 6, 0.2, 1)

    return v, conf
end
local function Resolver_ResolveVelocity(hrp, hum)
    local assembly = (hrp and hrp.AssemblyLinearVelocity) or Vector3.zero

    if assembly.Magnitude > 80 then
        assembly = assembly.Unit * 80
    end

    local move = hum and hum.MoveDirection or Vector3.zero
    local walk = (hum and hum.WalkSpeed) or 16
    local histVel, histConf = Resolver_EstimateVelFromHistory()

    histConf = histConf or 0

    local vel = assembly

    if vel.Magnitude < 0.2 and move.Magnitude > 0.08 then
        vel = move * walk
    end
    if histVel then
        local blend = 0.22 + histConf * 0.28

        if ResolverState.strafeScore > 0.35 or ResolverState.oscScore > 0.3 then
            blend = blend + 0.18
        end
        if assembly.Magnitude < 0.35 then
            blend = math.max(blend, 0.55)
        end

        vel = vel:Lerp(histVel, math.clamp(blend, 0, 0.75))
    end
    if ResolverState.velEma.Magnitude > 0.1 then
        vel = vel:Lerp(ResolverState.velEma, 0.3)
    end

    local hEma = ResolverState.hVelEma

    if hEma.Magnitude > 0.12 then
        local h = Vector3.new(vel.X, 0, vel.Z):Lerp(hEma, 0.3)

        vel = Vector3.new(h.X, assembly.Y * 0.85 + vel.Y * 0.15, h.Z)
    end
    if move.Magnitude > 0.25 then
        local h = Vector3.new(vel.X, 0, vel.Z)

        if h.Magnitude > 1.2 then
            local md, hd = move.Unit, h.Unit
            local dot = md:Dot(hd)

            if dot < 0.15 then
                local targetH = md * math.max(h.Magnitude * 0.7, walk * 0.75)

                h = h:Lerp(targetH, 0.4)
                vel = Vector3.new(h.X, vel.Y, h.Z)
            elseif dot > 0.7 and h.Magnitude < walk * 0.55 then
                h = h:Lerp(md * walk, 0.18)
                vel = Vector3.new(h.X, vel.Y, h.Z)
            end
        elseif move.Magnitude > 0.5 then
            vel = Vector3.new(move.X * walk * 0.9, vel.Y, move.Z * walk * 0.9)
        end
    end

    local conf = 1

    conf = conf - ResolverState.oscScore * 0.35
    conf = conf - ResolverState.strafeScore * 0.2
    conf = conf - ResolverState.dirChangeScore * 0.15

    if histConf > 0 then
        conf = conf * (0.55 + histConf * 0.45)
    end

    ResolverState.confidence = math.clamp(conf, 0.25, 1)

    return vel
end

TrackConnection(RunService.Heartbeat:Connect(function()
    pcall(Resolver_UpdatePingStats)

    if not Hub.Config or Hub.Config.ResolverEnabled == false then
        return
    end

    local murd = Hub.FindMurderer()

    if not murd or not murd.Character then
        ResolverState.samples = {}
        ResolverState.smoothPos = nil
        ResolverState.shootSmoothPos = nil
        ResolverState.targetUserId = nil
        ResolverState.strafeScore = 0
        ResolverState.signFlipCount = 0
        ResolverState.dirChangeScore = 0
        ResolverState.oscScore = 0
        ResolverState.confidence = 1

        return
    end
    if ResolverState.targetUserId ~= murd.UserId then
        ResolverState.samples = {}
        ResolverState.smoothPos = nil
        ResolverState.shootSmoothPos = nil
        ResolverState.targetUserId = murd.UserId
        ResolverState.velEma = Vector3.zero
        ResolverState.hVelEma = Vector3.zero
        ResolverState.accelEma = Vector3.zero
        ResolverState.strafeScore = 0
        ResolverState.signFlipCount = 0
        ResolverState.dirChangeScore = 0
        ResolverState.oscScore = 0
        ResolverState.lastHDir = Vector3.zero
        ResolverState.confidence = 1
        ResolverState.airborneSince = 0
    end

    local hrp = murd.Character:FindFirstChild('HumanoidRootPart')
    local hum = murd.Character:FindFirstChildOfClass('Humanoid')

    if not hrp or not hum or hum.Health <= 0 then
        return
    end

    local aimPart = Resolver_GetAimPart(murd.Character, (Hub.Config and Hub.Config.ResolverAimPart) or 'Head')
    local vel = Resolver_ResolveVelocity(hrp, hum)
    local grounded = hum.FloorMaterial ~= Enum.Material.Air

    ResolverState.isAirborne = not grounded

    if not grounded then
        if ResolverState.airborneSince == 0 then
            ResolverState.airborneSince = os.clock()
            ResolverState.jumpVy0 = vel.Y
        end
    else
        ResolverState.airborneSince = 0
    end

    Resolver_PushSample(hrp.Position, vel, aimPart and aimPart.Position or hrp.Position, grounded)

    ResolverState.lastPos = hrp.Position
    ResolverState.lastVel = vel
    ResolverState.lastT = os.clock()
end))

function Hub.GetResolverLatency(opts)
    opts = opts or {}

    local cfg = Hub.Config or {}
    local mode = cfg.ResolverMode or 'Adaptive'
    local t

    if cfg.ResolverAutoAdapt ~= false then
        local p = Hub.GetAdaptivePredictionParams()

        t = p.lead

        if mode == 'Aggressive' then
            t = t + 0.016
        elseif mode == 'Velocity' then
            t = t * 0.92
        elseif mode == 'Hybrid' then
            t = t * 0.96
        end
    else
        local ping = Resolver_UpdatePingStats()
        local extra = (tonumber(cfg.ResolverExtraMs) or 40) / 1000
        local scale = tonumber(cfg.ResolverLatencyScale) or 1

        t = ping * (0.5 * scale) + extra

        if mode == 'Aggressive' then
            t = t + 0.022
        elseif mode == 'Velocity' then
            t = ping * (0.5 * scale) + extra * 0.5
        elseif mode == 'Hybrid' then
            t = ping * (0.5 * scale) + extra * 0.75
        end
    end

    local dist = tonumber(opts.distance)

    if dist and dist > 0 then
        if dist < 15 then
            t = t * 0.72
        elseif dist < 30 then
            t = t * 0.84
        elseif dist < 50 then
            t = t * 0.93
        elseif dist > 100 then
            t = t * (1 + math.clamp((dist - 100) / 100, 0, 0.22))
        end
    end
    if ResolverState.strafeScore > 0.3 then
        t = t * (1 - ResolverState.strafeScore * 0.16)
    end
    if ResolverState.oscScore > 0.25 then
        t = t * (1 - ResolverState.oscScore * 0.14)
    end
    if ResolverState.dirChangeScore > 0.4 then
        t = t * (1 - ResolverState.dirChangeScore * 0.1)
    end

    return math.clamp(t, 0.012, 0.4)
end
function Hub.GetResolverSmooth()
    local cfg = Hub.Config or {}

    if cfg.ResolverAutoAdapt ~= false then
        Hub.GetAdaptivePredictionParams()

        local auto = ResolverState.adaptedSmooth
        local user = math.clamp(tonumber(cfg.ResolverSmooth) or 0.35, 0, 0.9)
        local bias = (user - 0.35) * 0.4

        return math.clamp(auto + bias, 0.03, 0.75)
    end

    return math.clamp(tonumber(cfg.ResolverSmooth) or 0.35, 0, 0.9)
end
function Hub.GetResolverShootSmooth()
    local cfg = Hub.Config or {}

    if cfg.ResolverAutoAdapt ~= false then
        Hub.GetAdaptivePredictionParams()

        return math.clamp(ResolverState.adaptedShootSmooth or 0.03, 0.005, 0.08)
    end

    local user = math.clamp(tonumber(cfg.ResolverSmooth) or 0.35, 0, 0.9)

    return math.clamp(user * 0.12, 0.005, 0.08)
end
function Hub.ResolveMurderer(opts)
    opts = opts or {}

    local murd = Hub.FindMurderer()

    if not murd or not murd.Character then
        return nil
    end

    local char = murd.Character
    local hum = char:FindFirstChildOfClass('Humanoid')

    if not hum or hum.Health <= 0 then
        return nil
    end

    local cfg = Hub.Config or {}
    local aimMode = opts.aimPart or cfg.ResolverAimPart or 'Head'
    local part = Resolver_GetAimPart(char, aimMode)
    local hrp = char:FindFirstChild('HumanoidRootPart')

    if not part and not hrp then
        return nil
    end

    part = part or hrp

    local pos = part.Position

    if part.Name == 'Head' and not opts.rawAim then
        pos = pos + Vector3.new(0, -0.22, 0)
    elseif part.Name == 'UpperTorso' or part.Name == 'Torso' then
        pos = pos + Vector3.new(0, 0.15, 0)
    end

    local vel = Resolver_ResolveVelocity(hrp, hum)

    if cfg.ResolverEnabled == false then
        return pos, murd, part
    end

    local origin = (Hub.RootPart and Hub.RootPart.Position) or (Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position)
    local dist = origin and (pos - origin).Magnitude or 40
    local t = Hub.GetResolverLatency({distance = dist})

    if opts.forShoot and opts.extraLead then
        t = t + (tonumber(opts.extraLead) or 0)
    end

    local mode = cfg.ResolverMode or 'Adaptive'
    local accel = Resolver_EstimateAccel()
    local airborne = hum.FloorMaterial == Enum.Material.Air
    local speed = vel.Magnitude
    local hSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
    local strafe = ResolverState.strafeScore
    local osc = ResolverState.oscScore
    local dirCh = ResolverState.dirChangeScore
    local conf = ResolverState.confidence
    local predPos
    local hvel = Vector3.new(vel.X, 0, vel.Z)

    if mode == 'Velocity' then
        predPos = pos + vel * t
    elseif mode == 'Aggressive' then
        predPos = pos + vel * t + 0.5 * accel * (t * t)

        if hum.MoveDirection.Magnitude > 0.12 then
            predPos = predPos + hum.MoveDirection * (hum.WalkSpeed or 16) * t * 0.08
        end
    elseif mode == 'Hybrid' then
        local p1 = pos + vel * t
        local p2 = pos + vel * t + 0.5 * accel * (t * t) * math.clamp(1 - strafe * 0.6 - osc * 0.4, 0, 1)

        predPos = p1:Lerp(p2, 0.42)
    else
        local accelScale = math.clamp(accel.Magnitude / 48, 0, 1) * (1 - strafe * 0.7 - osc * 0.55 - dirCh * 0.35) * conf

        if speed < 1.2 and hSpeed < 1 then
            predPos = pos + vel * (t * 0.12)
        elseif airborne then
            local vy = vel.Y

            predPos = pos + hvel * t + Vector3.new(0, vy * t, 0)

            if cfg.ResolverGravity ~= false then
                local g = Workspace.Gravity

                predPos = predPos + Vector3.new(0, -0.5 * g * t * t, 0)
            end
        elseif osc > 0.45 or strafe > 0.55 then
            predPos = pos + vel * (t * (0.88 + conf * 0.08))
        elseif dirCh > 0.55 then
            predPos = pos + vel * (t * 0.85)
        else
            predPos = pos + vel * t + 0.5 * accel * (t * t) * accelScale
        end
    end
    if mode ~= 'Adaptive' and cfg.ResolverGravity ~= false and airborne then
        predPos = predPos + Vector3.new(0, -0.5 * Workspace.Gravity * t * t, 0)
    end
    if cfg.ResolverGroundClamp ~= false and not airborne then
        if predPos.Y < pos.Y - 0.55 then
            predPos = Vector3.new(predPos.X, pos.Y, predPos.Z)
        elseif predPos.Y > pos.Y + 1.8 and speed < 10 then
            predPos = Vector3.new(predPos.X, pos.Y + (predPos.Y - pos.Y) * 0.18, predPos.Z)
        end
    end

    local forShoot = opts.forShoot == true

    if forShoot then
        local sm = Hub.GetResolverShootSmooth()

        if sm > 0 and ResolverState.shootSmoothPos then
            predPos = ResolverState.shootSmoothPos:Lerp(predPos, 1 - sm)
        end

        ResolverState.shootSmoothPos = predPos
    else
        local sm = Hub.GetResolverSmooth()

        if sm > 0 and ResolverState.smoothPos then
            predPos = ResolverState.smoothPos:Lerp(predPos, 1 - sm)
        end

        ResolverState.smoothPos = predPos
    end

    return predPos, murd, part, t
end
function Hub.Prediction(opts)
    local predPos, murd, part = Hub.ResolveMurderer(opts)

    return predPos, murd, part
end
function Hub.PredictionForShoot()
    return Hub.ResolveMurderer({forShoot = true})
end
function Hub.GetPredictionDebug()
    local p = Hub.GetAdaptivePredictionParams()

    return string.format('Ping %.0f/%.0fp75 | Jit %.0f | Lead %.0fms | Sm %.2f/%.2f | Str %.2f Osc %.2f | Conf %.2f', p.pingMs, p.p75Ms or 0, p.jitterMs, p.lead * 1000, p.smooth, p.shootSmooth or 0, p.strafeScore or 0, p.oscScore or 0, p.confidence or 1)
end

local PredictionESPDrawings = {
    GlowOuter = nil,
    GlowMid = nil,
    GlowInner = nil,
    DotCore = nil,
    DotHighlight = nil,
    CircleMain = nil,
    CirclePulse = nil,
    CH = {},
    TracerCore = nil,
    TracerGlow = nil,
    TracerSoft = nil,
    Box = {},
    RingOuter = {},
    RingInner = {},
    DistText = nil,
}
local PredictionESPActive = false
local PredictionESPPhase = 0
local PredictionESPPulse = 0

local function PredictionESP_MakeCircle(sides, z, filled)
    local c = Drawing.new('Circle')

    c.Filled = filled and true or false
    c.NumSides = sides or 32
    c.ZIndex = z or 10
    c.Visible = false

    return c
end
local function PredictionESP_MakeLine(z)
    local l = Drawing.new('Line')

    l.ZIndex = z or 9
    l.Visible = false

    return l
end
local function PredictionESP_Ensure()
    local d = PredictionESPDrawings

    if not d.GlowOuter then
        d.GlowOuter = PredictionESP_MakeCircle(48, 6, true)
        d.GlowMid = PredictionESP_MakeCircle(40, 7, true)
        d.GlowInner = PredictionESP_MakeCircle(32, 8, true)
        d.DotCore = PredictionESP_MakeCircle(24, 12, true)
        d.DotHighlight = PredictionESP_MakeCircle(16, 13, true)
        d.CircleMain = PredictionESP_MakeCircle(48, 10, false)
        d.CirclePulse = PredictionESP_MakeCircle(48, 9, false)
    end
    if #d.CH == 0 then
        for i = 1, 8 do
            d.CH[i] = PredictionESP_MakeLine(11)
        end
    end
    if not d.TracerCore then
        d.TracerCore = PredictionESP_MakeLine(10)
        d.TracerGlow = PredictionESP_MakeLine(8)
        d.TracerSoft = PredictionESP_MakeLine(7)
    end
    if #d.Box == 0 then
        for i = 1, 8 do
            d.Box[i] = PredictionESP_MakeLine(10)
        end
    end
    if #d.RingOuter == 0 then
        for i = 1, 48 do
            d.RingOuter[i] = PredictionESP_MakeLine(9)
        end
        for i = 1, 36 do
            d.RingInner[i] = PredictionESP_MakeLine(10)
        end
    end
    if not d.DistText then
        local ok, t = pcall(function()
            local txt = Drawing.new('Text')

            txt.Center = true
            txt.Outline = true
            txt.OutlineColor = Color3.new(0, 0, 0)
            txt.Size = 14
            txt.Font = 2
            txt.ZIndex = 14
            txt.Visible = false

            return txt
        end)

        if ok then
            d.DistText = t
        end
    end
end
local function PredictionESP_HideAll()
    local d = PredictionESPDrawings

    local function hide(obj)
        if obj then
            obj.Visible = false
        end
    end

    hide(d.GlowOuter)
    hide(d.GlowMid)
    hide(d.GlowInner)
    hide(d.DotCore)
    hide(d.DotHighlight)
    hide(d.CircleMain)
    hide(d.CirclePulse)
    hide(d.TracerCore)
    hide(d.TracerGlow)
    hide(d.TracerSoft)
    hide(d.DistText)

    for _, l in ipairs(d.CH)do
        hide(l)
    end
    for _, l in ipairs(d.Box)do
        hide(l)
    end
    for _, l in ipairs(d.RingOuter)do
        hide(l)
    end
    for _, l in ipairs(d.RingInner)do
        hide(l)
    end
end

function Hub.SetPredictionESPVisible(state)
    PredictionESPActive = state and true or false

    if not PredictionESPActive then
        PredictionESP_HideAll()
    end
end
function Hub.TogglePredictionESP(state)
    Hub.Config.PredictionESPEnabled = state and true or false

    if not Hub.Config.PredictionESPEnabled then
        PredictionESPActive = false

        PredictionESP_HideAll()
    end
end

local function PredictionESP_LerpColor(a, b, t)
    return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end
local function PredictionESP_GetRightHandScreen(cam)
    local char = Hub.Character or (LocalPlayer and LocalPlayer.Character)

    if not char then
        return nil
    end

    local hand = char:FindFirstChild('RightHand') or char:FindFirstChild('Right Arm') or char:FindFirstChild('RightLowerArm') or char:FindFirstChild('RightUpperArm')

    if not hand or not hand:IsA('BasePart') then
        return nil
    end

    local sp, on = cam:WorldToViewportPoint(hand.Position)

    if on and sp.Z > 0 then
        return Vector2.new(sp.X, sp.Y)
    end

    return nil
end

TrackConnection(RunService.RenderStepped:Connect(function(dt)
    local cfg = Hub.Config

    if not cfg or not cfg.PredictionESPEnabled then
        PredictionESP_HideAll()

        return
    end

    local show = cfg.PredictionESPAlways or PredictionESPActive

    if not show then
        PredictionESP_HideAll()

        return
    end

    local murd = Hub.FindMurderer()

    if murd and LocalPlayer and murd == LocalPlayer then
        PredictionESP_HideAll()

        return
    end

    local pred = Hub.Prediction()

    if not pred then
        PredictionESP_HideAll()

        return
    end

    local cam = Workspace.CurrentCamera

    if not cam then
        PredictionESP_HideAll()

        return
    end

    local screenPos, onScreen = cam:WorldToViewportPoint(pred)

    if not onScreen or screenPos.Z <= 0 then
        PredictionESP_HideAll()

        return
    end

    PredictionESP_Ensure()

    local d = PredictionESPDrawings

    dt = dt or 0.016
    PredictionESPPhase = PredictionESPPhase + dt
    PredictionESPPulse = PredictionESPPulse + dt * 3.2

    local baseColor = cfg.PredictionESPColor or Color3.fromRGB(255, 70, 90)
    local hiColor = PredictionESP_LerpColor(baseColor, Color3.new(1, 1, 1), 0.55)
    local loColor = PredictionESP_LerpColor(baseColor, Color3.new(0, 0, 0), 0.25)
    local size = math.max(4, tonumber(cfg.PredictionESPSize) or 14)
    local thickness = math.max(1, tonumber(cfg.PredictionESPThickness) or 2)
    local userT = math.clamp(tonumber(cfg.PredictionESPTransparency) or 0, 0, 1)
    local variants = cfg.PredictionESPVariants or {}
    local cx, cy = screenPos.X, screenPos.Y
    local pos = Vector2.new(cx, cy)
    local pulse = (math.sin(PredictionESPPulse) + 1) * 0.5
    local pulse2 = (math.sin(PredictionESPPulse * 0.65 + 1.2) + 1) * 0.5
    local alpha = (1 - userT)

    local function setCircle(c, radius, color, filled, a, thick)
        if not c then
            return
        end

        c.Position = pos
        c.Radius = radius
        c.Color = color
        c.Filled = filled and true or false
        c.Thickness = thick or 1
        c.Transparency = math.clamp(a, 0, 1)
        c.Visible = true
    end
    local function setLine(l, from, to, color, thick, a)
        if not l then
            return
        end

        l.From = from
        l.To = to
        l.Color = color
        l.Thickness = thick or 1
        l.Transparency = math.clamp(a, 0, 1)
        l.Visible = true
    end

    local anyOn = variants.Dot or variants.Circle or variants.Crosshair or variants.Tracer or variants.Box or variants.Ring

    if anyOn then
        setCircle(d.GlowOuter, size * (2.4 + pulse * 0.45), baseColor, true, alpha * (0.08 + pulse * 0.05), 1)
        setCircle(d.GlowMid, size * (1.55 + pulse * 0.2), baseColor, true, alpha * (0.14 + pulse * 0.06), 1)
        setCircle(d.GlowInner, size * (0.95 + pulse * 0.08), hiColor, true, alpha * (0.22 + pulse * 0.08), 1)
    else
        if d.GlowOuter then
            d.GlowOuter.Visible = false
        end
        if d.GlowMid then
            d.GlowMid.Visible = false
        end
        if d.GlowInner then
            d.GlowInner.Visible = false
        end
    end
    if variants.Dot then
        setCircle(d.DotCore, size * 0.38, baseColor, true, alpha * 0.95, 1)
        setCircle(d.DotHighlight, size * 0.16, hiColor, true, alpha * 0.9, 1)
    else
        if d.DotCore then
            d.DotCore.Visible = false
        end
        if d.DotHighlight then
            d.DotHighlight.Visible = false
        end
    end
    if variants.Circle then
        setCircle(d.CircleMain, size * (1.05 + pulse * 0.06), baseColor, false, alpha * 0.92, thickness + 0.5)

        local pr = size * (1.35 + pulse2 * 0.85)

        setCircle(d.CirclePulse, pr, hiColor, false, alpha * (0.35 * (1 - pulse2)), math.max(1, thickness - 0.5))
    else
        if d.CircleMain then
            d.CircleMain.Visible = false
        end
        if d.CirclePulse then
            d.CirclePulse.Visible = false
        end
    end
    if variants.Crosshair then
        local arm = size * 1.55
        local gap = size * 0.42
        local tip = size * 0.18
        local thick = thickness + 0.5
        local a = alpha * 0.95

        setLine(d.CH[1], Vector2.new(cx - arm, cy), Vector2.new(cx - gap, cy), baseColor, thick, a)
        setLine(d.CH[2], Vector2.new(cx - arm, cy - tip), Vector2.new(cx - arm, cy + tip), hiColor, thick, a * 0.85)
        setLine(d.CH[3], Vector2.new(cx + gap, cy), Vector2.new(cx + arm, cy), baseColor, thick, a)
        setLine(d.CH[4], Vector2.new(cx + arm, cy - tip), Vector2.new(cx + arm, cy + tip), hiColor, thick, a * 0.85)
        setLine(d.CH[5], Vector2.new(cx, cy - arm), Vector2.new(cx, cy - gap), baseColor, thick, a)
        setLine(d.CH[6], Vector2.new(cx - tip, cy - arm), Vector2.new(cx + tip, cy - arm), hiColor, thick, a * 0.85)
        setLine(d.CH[7], Vector2.new(cx, cy + gap), Vector2.new(cx, cy + arm), baseColor, thick, a)
        setLine(d.CH[8], Vector2.new(cx - tip, cy + arm), Vector2.new(cx + tip, cy + arm), hiColor, thick, a * 0.85)
    else
        for _, l in ipairs(d.CH)do
            l.Visible = false
        end
    end
    if variants.Tracer then
        local fromPos = PredictionESP_GetRightHandScreen(cam)

        if not fromPos and Hub.RootPart then
            local rs, on = cam:WorldToViewportPoint(Hub.RootPart.Position)

            if on and rs.Z > 0 then
                fromPos = Vector2.new(rs.X, rs.Y)
            end
        end
        if not fromPos then
            fromPos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y * 0.85)
        end

        setLine(d.TracerSoft, fromPos, pos, baseColor, thickness + 5, alpha * 0.12)
        setLine(d.TracerGlow, fromPos, pos, hiColor, thickness + 2.5, alpha * 0.28)
        setLine(d.TracerCore, fromPos, pos, Color3.new(1, 1, 1), math.max(1, thickness * 0.7), alpha * 0.75)
    else
        if d.TracerCore then
            d.TracerCore.Visible = false
        end
        if d.TracerGlow then
            d.TracerGlow.Visible = false
        end
        if d.TracerSoft then
            d.TracerSoft.Visible = false
        end
    end
    if variants.Box then
        local half = size * 1.25
        local corner = size * 0.7
        local x1, y1 = cx - half, cy - half
        local x2, y2 = cx + half, cy + half
        local a = alpha * 0.95
        local t = thickness + 0.5

        setLine(d.Box[1], Vector2.new(x1, y1), Vector2.new(x1 + corner, y1), baseColor, t, a)
        setLine(d.Box[2], Vector2.new(x1, y1), Vector2.new(x1, y1 + corner), baseColor, t, a)
        setLine(d.Box[3], Vector2.new(x2, y1), Vector2.new(x2 - corner, y1), baseColor, t, a)
        setLine(d.Box[4], Vector2.new(x2, y1), Vector2.new(x2, y1 + corner), baseColor, t, a)
        setLine(d.Box[5], Vector2.new(x1, y2), Vector2.new(x1 + corner, y2), baseColor, t, a)
        setLine(d.Box[6], Vector2.new(x1, y2), Vector2.new(x1, y2 - corner), baseColor, t, a)
        setLine(d.Box[7], Vector2.new(x2, y2), Vector2.new(x2 - corner, y2), baseColor, t, a)
        setLine(d.Box[8], Vector2.new(x2, y2), Vector2.new(x2, y2 - corner), baseColor, t, a)
    else
        for _, l in ipairs(d.Box)do
            l.Visible = false
        end
    end
    if variants.Ring then
        local phase = PredictionESPPhase * 2.2
        local phase2 = -PredictionESPPhase * 3.1
        local rOuter = size * (1.7 + pulse * 0.12)
        local rInner = size * (1.15 + pulse2 * 0.08)
        local nO, nI = #d.RingOuter, #d.RingInner

        for i = 1, nO do
            local a0 = phase + (i - 1) / nO * math.pi * 2
            local a1 = phase + i / nO * math.pi * 2
            local dash = ((i - 1) % 3 ~= 2)
            local line = d.RingOuter[i]

            if dash then
                setLine(line, Vector2.new(cx + math.cos(a0) * rOuter, cy + math.sin(a0) * rOuter), Vector2.new(cx + math.cos(a1) * rOuter, cy + math.sin(a1) * rOuter), baseColor, thickness, alpha * 0.75)
            else
                line.Visible = false
            end
        end
        for i = 1, nI do
            local a0 = phase2 + (i - 1) / nI * math.pi * 2
            local a1 = phase2 + i / nI * math.pi * 2
            local dash = ((i - 1) % 2 == 0)
            local line = d.RingInner[i]

            if dash then
                setLine(line, Vector2.new(cx + math.cos(a0) * rInner, cy + math.sin(a0) * rInner), Vector2.new(cx + math.cos(a1) * rInner, cy + math.sin(a1) * rInner), hiColor, math.max(1, thickness - 0.5), alpha * 0.65)
            else
                line.Visible = false
            end
        end
    else
        for _, l in ipairs(d.RingOuter)do
            l.Visible = false
        end
        for _, l in ipairs(d.RingInner)do
            l.Visible = false
        end
    end
    if d.DistText and anyOn then
        local dist = 0

        if Hub.RootPart then
            dist = (Hub.RootPart.Position - pred).Magnitude
        else
            dist = (cam.CFrame.Position - pred).Magnitude
        end

        d.DistText.Text = string.format('PRED  %.0f studs', dist)
        d.DistText.Position = Vector2.new(cx, cy + size * 2.1 + 6)
        d.DistText.Color = hiColor
        d.DistText.Transparency = alpha * 0.85
        d.DistText.Size = 13
        d.DistText.Visible = true
    elseif d.DistText then
        d.DistText.Visible = false
    end
end))

function Hub.ShootMurderer()
    if not Hub.Character or not Hub.RootPart or not Hub.Backpack then
        return false
    end

    local gun = Hub.Character:FindFirstChild('Gun') or Hub.Backpack:FindFirstChild('Gun')

    if not gun then
        return false
    end

    local pred, murd = Hub.ResolveMurderer({forShoot = true})

    if not pred or not murd or not murd.Character then
        return false
    end
    if gun.Parent == Hub.Backpack then
        pcall(function()
            gun.Parent = Hub.Character
        end)
        task.wait()

        gun = Hub.Character:FindFirstChild('Gun') or gun
    end
    if not gun then
        return false
    end

    local knifeLocal = gun:FindFirstChild('KnifeLocal')
    local shoot = gun:FindFirstChild('Shoot')
    local createBeam = knifeLocal and knifeLocal:FindFirstChild('CreateBeam')
    local rf = createBeam and createBeam:FindFirstChild('RemoteFunction')

    local function fireAt(targetPos)
        if not targetPos or not Hub.RootPart then
            return false
        end
        if rf then
            local ok = pcall(function()
                rf:InvokeServer(1, targetPos, 'AH2')
            end)

            if ok then
                return true
            end
        end
        if shoot and shoot:IsA('RemoteEvent') then
            local origin = Hub.RootPart.Position
            local look = CFrame.lookAt(origin, targetPos)

            return pcall(function()
                shoot:FireServer(look, CFrame.new(targetPos))
            end)
        end

        return false
    end

    task.spawn(function()
        fireAt(pred)
        task.wait(0.016)

        local p2 = Hub.ResolveMurderer({forShoot = true})

        if p2 then
            fireAt(p2)
        end

        task.wait(0.02)

        local p3 = Hub.ResolveMurderer({forShoot = true})

        if p3 then
            fireAt(p3)
        end

        task.wait(0.024)

        local p4 = Hub.ResolveMurderer({
            forShoot = true,
            extraLead = 0.008,
        })

        if p4 then
            fireAt(p4)
        end
    end)
    task.spawn(function()
        task.wait(Hub.Config.AutoHolsterDelay or 1.5)

        if Hub.Character and Hub.Backpack then
            local g = Hub.Character:FindFirstChild('Gun')

            if g then
                pcall(function()
                    g.Parent = Hub.Backpack
                end)
            end
        end
    end)

    return true
end

local AutoShootThread = nil

function Hub.ToggleAutoShootMurderer(state)
    Hub.Config.AutoShootMurderer = state

    if AutoShootThread then
        task.cancel(AutoShootThread)

        AutoShootThread = nil
    end
    if state then
        AutoShootThread = task.spawn(function()
            while Hub.Config.AutoShootMurderer do
                Hub.ShootMurderer()
                task.wait(0.12)
            end
        end)
    end
end
function Hub.WallBangShoot()
    if not Hub.CheckPremium('Wallbang') then
        return
    end
    if not Hub.Character or not Hub.RootPart or not Hub.Backpack then
        return false
    end

    local gun = Hub.Character:FindFirstChild('Gun') or Hub.Backpack:FindFirstChild('Gun')

    if not gun then
        return false
    end

    local murd = Hub.FindMurderer()

    if not murd or not murd.Character then
        return false
    end

    local hrp = murd.Character:FindFirstChild('HumanoidRootPart')
    local hum = murd.Character:FindFirstChild('Humanoid')

    if not hrp or not hum or hum.Health <= 0 then
        return false
    end

    local ping = 0.06

    if Stats then
        local net = Stats:FindFirstChild('Network')
        local ssi = net and net:FindFirstChild('ServerStatsItem')
        local dp = ssi and ssi:FindFirstChild('Data Ping')

        if dp then
            ping = dp:GetValue() / 1000
        end
    end

    local predT = math.clamp(ping + 0.05, 0, 1.2)
    local pos = hrp.Position
    local vel = hrp.AssemblyLinearVelocity

    if vel.Magnitude < 0.1 and hum.MoveDirection.Magnitude > 0 then
        vel = hum.MoveDirection * hum.WalkSpeed
    end

    local predPos = pos + vel * predT

    if hum.FloorMaterial == Enum.Material.Air then
        predPos = predPos + Vector3.new(0, 0.5 * Workspace.Gravity * predT ^ 2, 0)
    end
    if gun.Parent == Hub.Backpack then
        gun.Parent = Hub.Character

        task.wait()
    end

    local shoot = gun:FindFirstChild('Shoot')
    local knifeLocal = gun:FindFirstChild('KnifeLocal')

    if shoot and shoot:IsA('RemoteEvent') then
        task.spawn(function()
            pcall(function()
                shoot:FireServer(CFrame.new(predPos), CFrame.new(Hub.RootPart.Position))
            end)
        end)

        return true
    elseif knifeLocal then
        local createBeam = knifeLocal:FindFirstChild('CreateBeam')
        local rf = createBeam and createBeam:FindFirstChild('RemoteFunction')

        if rf then
            task.spawn(function()
                pcall(function()
                    rf:InvokeServer(1, predPos, 'AH2')
                end)
            end)

            return true
        end
    end

    return false
end
function Hub.ToggleWallBang(state)
    Hub.Config.AutoWallBangEnabled = state

    if state then
        task.spawn(function()
            while Hub.Config.AutoWallBangEnabled do
                Hub.WallBangShoot()
                task.wait(0.2)
            end
        end)
    end
end
function Hub.TeleportToPlayer(plr)
    if not Hub.RootPart then
        return false
    end
    if plr and plr.Character and plr.Character.PrimaryPart then
        return pcall(function()
            Hub.Character:PivotTo(plr.Character.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
        end)
    end

    return false
end

Hub.ToggleTeleportToPlayer = Hub.TeleportToPlayer

local WalkSpeedConn = nil

function Hub.EnableWalkSpeed(state)
    Hub.Config.EnableWalkSpeed = state

    if not state then
        if WalkSpeedConn then
            DisconnectConnection(WalkSpeedConn)

            WalkSpeedConn = nil
        end
        if Hub.Humanoid then
            Hub.Humanoid.WalkSpeed = 16
        end

        return
    end
    if WalkSpeedConn then
        DisconnectConnection(WalkSpeedConn)
    end

    WalkSpeedConn = TrackConnection(RunService.Heartbeat:Connect(function()
        if Hub.Humanoid and Hub.Humanoid.WalkSpeed ~= Hub.Config.WalkSpeed then
            Hub.Humanoid.WalkSpeed = Hub.Config.WalkSpeed
        end
    end))
end
function Hub.SetWalkSpeed(val)
    Hub.Config.WalkSpeed = math.clamp(val, 16, 200)

    if Hub.Config.EnableWalkSpeed and Hub.Humanoid then
        Hub.Humanoid.WalkSpeed = Hub.Config.WalkSpeed
    end
end

local JumpPowerConn = nil

function Hub.EnableJumpPower(state)
    Hub.Config.EnableJumpPower = state

    if not state then
        if JumpPowerConn then
            DisconnectConnection(JumpPowerConn)

            JumpPowerConn = nil
        end
        if Hub.Humanoid then
            Hub.Humanoid.JumpPower = 50
        end

        return
    end
    if JumpPowerConn then
        DisconnectConnection(JumpPowerConn)
    end

    JumpPowerConn = TrackConnection(RunService.Heartbeat:Connect(function()
        if Hub.Humanoid and Hub.Humanoid.JumpPower ~= Hub.Config.JumpPower then
            Hub.Humanoid.JumpPower = Hub.Config.JumpPower
        end
    end))
end
function Hub.SetJumpPower(val)
    Hub.Config.JumpPower = math.clamp(val, 50, 300)

    if Hub.Config.EnableJumpPower and Hub.Humanoid then
        Hub.Humanoid.JumpPower = Hub.Config.JumpPower
    end
end

local NoclipConn = nil
local NoclipParts = {}

function Hub.EnableNoclip(state)
    Hub.Config.Noclip = state

    if not state then
        if NoclipConn then
            DisconnectConnection(NoclipConn)

            NoclipConn = nil
        end

        for part, orig in pairs(NoclipParts)do
            if part and part.Parent then
                part.CanCollide = orig
            end
        end

        NoclipParts = {}

        return
    end

    NoclipParts = {}

    if Hub.Character then
        for _, d in ipairs(Hub.Character:GetDescendants())do
            if d:IsA('BasePart') then
                NoclipParts[d] = d.CanCollide
                d.CanCollide = false
            end
        end
    end
    if NoclipConn then
        DisconnectConnection(NoclipConn)
    end

    NoclipConn = TrackConnection(RunService.Stepped:Connect(function()
        if Hub.Character then
            for _, d in ipairs(Hub.Character:GetDescendants())do
                if d:IsA('BasePart') then
                    d.CanCollide = false
                end
            end
        end
    end))
end

local InfJumpConn = nil

function Hub.InfiniteJump(state)
    Hub.Config.InfiniteJump = state

    if not state then
        if InfJumpConn then
            DisconnectConnection(InfJumpConn)

            InfJumpConn = nil
        end

        return
    end
    if InfJumpConn then
        DisconnectConnection(InfJumpConn)
    end

    InfJumpConn = TrackConnection(UserInputService.JumpRequest:Connect(function()
        if Hub.Humanoid then
            Hub.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end))
end
function Hub.GrabGun()
    local rp = Hub.RootPart

    if not rp or not rp.Parent then
        return
    end

    local map = FindMap()
    local gd = map and map:FindFirstChild('GunDrop')

    if gd and gd:IsA('BasePart') and firetouchinterest then
        firetouchinterest(gd, rp, 1)
        firetouchinterest(gd, rp, 0)
    end
end

local AutoGrabConn = nil

function Hub.ToggleAutoGrabGun(state)
    Hub.Config.AutoGrabGun = state

    if AutoGrabConn then
        AutoGrabConn:Disconnect()

        AutoGrabConn = nil
    end
    if state then
        AutoGrabConn = TrackConnection(RunService.Heartbeat:Connect(Hub.GrabGun))
    end
end
function Hub.KillAll()
    local mode = Hub.Config.KillAllMode
    local knife = (Hub.Character and Hub.Character:FindFirstChild('Knife')) or (Hub.Backpack and Hub.Backpack:FindFirstChild('Knife'))

    if not knife then
        return
    end
    if mode == 'Silent' then
        if not Hub.CheckPremium('Silent Kill All') then
            Hub.Config.KillAllMode = 'Default'

            return
        end

        local events = knife:FindFirstChild('Events')
        local handle = events and events:FindFirstChild('HandleTouched')

        if handle then
            for _, p in ipairs(Players:GetPlayers())do
                if p ~= LocalPlayer and p.Character then
                    local hum = p.Character:FindFirstChild('Humanoid')
                    local hrp = p.Character:FindFirstChild('HumanoidRootPart')

                    if hum and hrp and hum.Health > 0 then
                        pcall(function()
                            handle:FireServer(hrp)
                        end)
                    end
                end
            end
        end

        return
    end

    local targets = {}

    for _, p in ipairs(Players:GetPlayers())do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChild('Humanoid')
            local hrp = p.Character:FindFirstChild('HumanoidRootPart')

            if hum and hrp and hum.Health > 0 then
                table.insert(targets, p)
            end
        end
    end

    if #targets == 0 then
        return
    end
    if knife.Parent == LocalPlayer.Backpack then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Humanoid')

        if hum then
            hum:EquipTool(knife)
            task.wait(0.1)
        end
    end

    local k = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Knife')

    if not k then
        return
    end

    local events = k:FindFirstChild('Events')
    local handle = events and events:FindFirstChild('HandleTouched')

    if handle then
        for _, p in ipairs(targets)do
            if p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
                local hum = p.Character:FindFirstChild('Humanoid')
                local hrp = p.Character.HumanoidRootPart

                if hum and hum.Health > 0 then
                    pcall(function()
                        handle:FireServer(hrp)
                    end)
                end
            end
        end

        local stabbed = events:FindFirstChild('KnifeStabbed')

        if stabbed then
            stabbed:FireServer()
        end
    end
end

local KnifeAuraConn = nil

function Hub.ToggleKnifeAura(state)
    Hub.Config.KnifeAura = state

    if KnifeAuraConn then
        DisconnectConnection(KnifeAuraConn)

        KnifeAuraConn = nil
    end
    if state then
        KnifeAuraConn = TrackConnection(RunService.Heartbeat:Connect(function()
            if not Hub.Config.KnifeAura then
                return
            end
            if not LocalPlayer or not LocalPlayer.Character then
                return
            end

            local myHum = LocalPlayer.Character:FindFirstChild('Humanoid')
            local myRoot = LocalPlayer.Character:FindFirstChild('HumanoidRootPart')

            if not myHum or not myRoot or myHum.Health <= 0 then
                return
            end

            local mode = Hub.Config.KnifeAuraMode
            local knife = LocalPlayer.Character:FindFirstChild('Knife') or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild('Knife'))

            if not knife then
                return
            end

            local events = knife:FindFirstChild('Events')

            if mode == 'Silent' then
                if not Hub.CheckPremium('Silent Knife Aura') then
                    Hub.Config.KnifeAuraMode = 'Default'

                    return
                end

                local handle = events and events:FindFirstChild('HandleTouched')

                if handle then
                    for _, p in ipairs(Players:GetPlayers())do
                        if p ~= LocalPlayer and p.Character then
                            local hum = p.Character:FindFirstChild('Humanoid')
                            local hrp = p.Character:FindFirstChild('HumanoidRootPart')

                            if hum and hrp and hum.Health > 0 and (hrp.Position - myRoot.Position).Magnitude <= Hub.Config.KnifeAuraRange then
                                pcall(function()
                                    handle:FireServer(hrp)
                                end)
                            end
                        end
                    end
                end

                return
            end

            local targets = {}

            for _, p in ipairs(Players:GetPlayers())do
                if p ~= LocalPlayer and p.Character then
                    local hum = p.Character:FindFirstChild('Humanoid')
                    local hrp = p.Character:FindFirstChild('HumanoidRootPart')

                    if hum and hrp and hum.Health > 0 and (hrp.Position - myRoot.Position).Magnitude <= Hub.Config.KnifeAuraRange then
                        table.insert(targets, p)
                    end
                end
            end

            if #targets == 0 then
                return
            end
            if knife.Parent == LocalPlayer.Backpack then
                local hum = LocalPlayer.Character:FindFirstChild('Humanoid')

                if hum then
                    hum:EquipTool(knife)
                end
            end

            local handle = events and events:FindFirstChild('HandleTouched')

            if handle then
                for _, p in ipairs(targets)do
                    local hrp = p.Character and p.Character:FindFirstChild('HumanoidRootPart')

                    if hrp then
                        pcall(function()
                            handle:FireServer(hrp)
                        end)
                    end
                end

                local stabbed = events:FindFirstChild('KnifeStabbed')

                if stabbed then
                    stabbed:FireServer()
                end
            end
        end))
    end
end

local AutoKillAllThread = nil

function Hub.ToggleAutoKillAll(state)
    Hub.Config.AutoKillAll = state

    if AutoKillAllThread then
        task.cancel(AutoKillAllThread)

        AutoKillAllThread = nil
    end
    if state then
        AutoKillAllThread = task.spawn(function()
            while Hub.Config.AutoKillAll do
                pcall(Hub.KillAll)
                task.wait(0.1)
            end
        end)
    end
end

local function GetClosestPlayer(origin, range)
    local closest, closestDist = nil, range

    for _, p in ipairs(Players:GetPlayers())do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChild('Humanoid')
            local hrp = p.Character:FindFirstChild('HumanoidRootPart')

            if hum and hrp and hum.Health > 0 then
                local dist = (origin - hrp.Position).Magnitude

                if dist < closestDist then
                    local params = RaycastParams.new()

                    params.FilterDescendantsInstances = {
                        Hub.Character,
                        hrp.Parent,
                        Camera,
                    }
                    params.FilterType = Enum.RaycastFilterType.Exclude

                    if Workspace:Raycast(origin, hrp.Position - origin, params) == nil then
                        closestDist = dist
                        closest = p
                    end
                end
            end
        end
    end

    return closest
end

function Hub.ExecuteSilentThrow()
    if Hub.FindMurderer() ~= LocalPlayer then
        return
    end
    if not LocalPlayer or not LocalPlayer.Character then
        return
    end

    local myHum = LocalPlayer.Character:FindFirstChild('Humanoid')
    local myRoot = LocalPlayer.Character:FindFirstChild('HumanoidRootPart')

    if not myHum or not myRoot or myHum.Health <= 0 then
        return
    end

    local knife = LocalPlayer.Character:FindFirstChild('Knife') or (Hub.Backpack and Hub.Backpack:FindFirstChild('Knife'))

    if not knife then
        return
    end

    local events = knife:FindFirstChild('Events')
    local thrown = events and events:FindFirstChild('KnifeThrown')

    if not thrown then
        return
    end

    local target = GetClosestPlayer(Hub.RootPart.Position, Hub.Config.KnifeThrowAura)

    if not target then
        return
    end
    if knife.Parent == Hub.Backpack and Hub.Humanoid then
        Hub.Humanoid:EquipTool(knife)
        task.wait(0.05)
    end

    local tChar = target.Character
    local tRoot = tChar and tChar:FindFirstChild('HumanoidRootPart')
    local tHum = tChar and tChar:FindFirstChild('Humanoid')

    if not tRoot or not tHum then
        return
    end

    local ping = 0.06

    if Stats then
        local net = Stats:FindFirstChild('Network')
        local ssi = net and net:FindFirstChild('ServerStatsItem')
        local dp = ssi and ssi:FindFirstChild('Data Ping')

        if dp then
            ping = dp:GetValue() / 1000
        end
    end

    local predT = math.clamp(ping + 0.05, 0.01, 1)
    local vel = tRoot.AssemblyLinearVelocity

    if vel.Magnitude < 0.5 and tHum.MoveDirection.Magnitude > 0 then
        vel = tHum.MoveDirection * tHum.WalkSpeed
    end

    local predPos = tRoot.Position + vel * predT

    if tHum.FloorMaterial == Enum.Material.Air then
        predPos = predPos - Vector3.new(0, 0.5 * Workspace.Gravity * predT ^ 2, 0)
    elseif predPos.Y < tRoot.Position.Y - 1 then
        predPos = Vector3.new(predPos.X, tRoot.Position.Y, predPos.Z)
    end

    pcall(function()
        thrown:FireServer(CFrame.new(Hub.RootPart.Position), CFrame.new(predPos))
    end)
end

local SilentThrowThread = nil

function Hub.ToggleSilentThrow(state)
    Hub.Config.SilentThrow = state

    if SilentThrowThread then
        task.cancel(SilentThrowThread)

        SilentThrowThread = nil
    end
    if state then
        SilentThrowThread = task.spawn(function()
            while Hub.Config.SilentThrow do
                if Hub.FindMurderer() == LocalPlayer then
                    Hub.ExecuteSilentThrow()
                end

                task.wait(0.4)
            end
        end)
    end
end
function Hub.PlayEmote(emote)
    local remotes = ReplicatedStorage:FindFirstChild('Remotes')
    local play = remotes and remotes:FindFirstChild('PlayEmote')

    if play then
        play:Fire(emote)
    else
        local pe = ReplicatedStorage:FindFirstChild('PlayEmote', true)

        if pe then
            pe:Fire(emote)
        end
    end
end
function Hub.ChatRoles()
    local murd = Hub.FindMurderer()
    local sher = Hub.FindSheriff()
    local msg = 'Candy Ware >> Murderer: ' .. (murd and murd.Name or 'Unknown') .. ' | Sheriff: ' .. (sher and sher.Name or 'Unknown')

    if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channels = TextChatService:FindFirstChild('TextChannels')
        local general = channels and channels:FindFirstChild('RBXGeneral')

        if general then
            general:SendAsync(msg)

            return
        end
    end

    local events = ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents')
    local say = events and events:FindFirstChild('SayMessageRequest')

    if say then
        pcall(function()
            say:FireServer(msg, 'Normal')
        end)
    end
end

local AntiAFKConn = nil

function Hub.ToggleAntiAFK(state)
    if AntiAFKConn then
        AntiAFKConn:Disconnect()

        AntiAFKConn = nil
    end
    if state then
        AntiAFKConn = LocalPlayer.Idled:Connect(function()
            local vu = game:GetService('VirtualUser')

            if vu then
                pcall(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end
        end)
    end
end

local FarmThread, FarmIsRound = nil, false
local FarmControllers = {
    MainPoint = nil,
    PosController = nil,
    RotController = nil,
}
local FarmTouched = {}
local FarmTween = nil
local FarmVelConn = nil

task.spawn(function()
    if Gameplay then
        for _, name in ipairs({
            'RoundStart',
            'RoundEndFade',
            'VictoryScreen',
        })do
            local r = Gameplay:FindFirstChild(name)

            if r then
                TrackConnection(r.OnClientEvent:Connect(function()
                    FarmIsRound = (name == 'RoundStart')
                end))
            end
        end
    end
    if LocalPlayer then
        TrackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild('Humanoid', 10)

            if hum then
                hum.Died:Connect(function()
                    FarmIsRound = false
                end)
            end
        end))

        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild('Humanoid')

            if hum then
                hum.Died:Connect(function()
                    FarmIsRound = false
                end)
            end
        end
    end
end)

local function CleanupFarm()
    if FarmTween then
        pcall(function()
            FarmTween:Cancel()
        end)

        FarmTween = nil
    end
    if FarmControllers.PosController then
        FarmControllers.PosController:Destroy()

        FarmControllers.PosController = nil
    end
    if FarmControllers.RotController then
        FarmControllers.RotController:Destroy()

        FarmControllers.RotController = nil
    end
    if FarmControllers.MainPoint then
        FarmControllers.MainPoint:Destroy()

        FarmControllers.MainPoint = nil
    end
end
local function SetFarmNoclip(on)
    if Hub.EnableNoclip then
        Hub.EnableNoclip(on)
    else
        local char = LocalPlayer and LocalPlayer.Character

        if char then
            for _, d in ipairs(char:GetDescendants())do
                if d:IsA('BasePart') then
                    d.CanCollide = not on
                end
            end
        end
    end
end

function Hub.ToggleAutoFarm(state)
    Hub.Config.AutoFarmCoins = state

    if FarmThread then
        task.cancel(FarmThread)

        FarmThread = nil
    end

    CleanupFarm()

    FarmTouched = {}

    if not state then
        SetFarmNoclip(false)

        if FarmVelConn then
            FarmVelConn:Disconnect()

            FarmVelConn = nil
        end

        local char = LocalPlayer and LocalPlayer.Character
        local hum = char and char:FindFirstChild('Humanoid')
        local hrp = char and char:FindFirstChild('HumanoidRootPart')

        if hum then
            hum.PlatformStand = false
        end
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        return
    end

    FarmThread = task.spawn(function()
        while Hub.Config.AutoFarmCoins do
            local spd = Hub.Config.AutoFarmSpeed
            local offset = Hub.Config.AutoFarmOffset
            local radius = Hub.Config.AutoFarmRadius
            local delay = Hub.Config.AutoFarmDelay

            if math.random(1, 100) == 1 then
                for k in pairs(FarmTouched)do
                    if not k or not k.Parent then
                        FarmTouched[k] = nil
                    end
                end
            end
            if not FarmIsRound then
                CleanupFarm()
                SetFarmNoclip(false)

                if FarmVelConn then
                    FarmVelConn:Disconnect()

                    FarmVelConn = nil
                end

                local char = LocalPlayer and LocalPlayer.Character
                local hum = char and char:FindFirstChild('Humanoid')

                if hum then
                    hum.PlatformStand = false
                end

                task.wait(1)
            else
                local char = LocalPlayer and LocalPlayer.Character
                local hrp = char and char:FindFirstChild('HumanoidRootPart')
                local hum = char and char:FindFirstChild('Humanoid')

                if not char or not hrp or not hum or hum.Health <= 0 then
                    task.wait(0.5)
                else
                    SetFarmNoclip(true)

                    if FarmVelConn then
                        FarmVelConn:Disconnect()
                    end

                    FarmVelConn = RunService.Stepped:Connect(function()
                        local r = LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')

                        if r then
                            r.AssemblyLinearVelocity = Vector3.zero
                            r.AssemblyAngularVelocity = Vector3.zero
                        end
                    end)
                    hum.PlatformStand = true

                    local map = FindMap()
                    local coins = map and (map:FindFirstChild('CoinContainer') or map:FindFirstChild('CoinAreas') or map:FindFirstChild('Coins'))

                    if not coins then
                        task.wait(1)
                    else
                        if not FarmControllers.MainPoint or not FarmControllers.MainPoint.Parent then
                            CleanupFarm()

                            local att = Instance.new('Attachment')

                            att.Name = 'FarmPoint'
                            att.Parent = hrp
                            FarmControllers.MainPoint = att

                            local ap = Instance.new('AlignPosition')

                            ap.Mode = Enum.PositionAlignmentMode.OneAttachment
                            ap.Attachment0 = att
                            ap.RigidityEnabled = true
                            ap.Position = hrp.Position
                            ap.Parent = hrp
                            FarmControllers.PosController = ap

                            local ao = Instance.new('AlignOrientation')

                            ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
                            ao.Attachment0 = att
                            ao.RigidityEnabled = true
                            ao.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0)
                            ao.Parent = hrp
                            FarmControllers.RotController = ao
                        end

                        local nearest, nearestDist = nil, math.huge
                        local myPos = hrp.Position

                        for _, child in ipairs(coins:GetChildren())do
                            local visual = child:FindFirstChild('CoinVisual') or child

                            if visual and (visual:IsA('BasePart') or visual:IsA('UnionOperation')) and visual.Transparency < 1 and not FarmTouched[visual] then
                                local d = (visual.Position - myPos).Magnitude

                                if d < radius and d < nearestDist then
                                    nearestDist = d
                                    nearest = visual
                                end
                            end
                        end

                        if not nearest then
                            if FarmControllers.PosController then
                                FarmControllers.PosController.Position = hrp.Position
                            end

                            task.wait(0.5)
                        else
                            local goal = nearest.Position + Vector3.new(0, offset, 0)
                            local time = math.max(nearestDist / math.max(spd, 1), 0.1)

                            if FarmControllers.PosController then
                                FarmTween = TweenService:Create(FarmControllers.PosController, TweenInfo.new(time, Enum.EasingStyle.Linear), {Position = goal})

                                FarmTween:Play()

                                local done = false
                                local c = FarmTween.Completed:Connect(function()
                                    done = true
                                end)
                                local t = 0

                                while t < time + 0.1 and not done and Hub.Config.AutoFarmCoins and FarmIsRound and hrp and hrp.Parent and nearest and nearest.Parent and nearest.Transparency < 1 and not FarmTouched[nearest] do
                                    if FarmControllers.RotController then
                                        FarmControllers.RotController.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(math.rad(90), 0, 0)
                                    end

                                    t = t + RunService.Heartbeat:Wait()
                                end

                                if c then
                                    c:Disconnect()
                                end
                            end
                            if Hub.Config.AutoFarmCoins and FarmIsRound and FarmControllers.PosController and nearest and nearest.Parent then
                                local touchPart = nearest.Parent:IsA('BasePart') and nearest.Parent or nearest

                                if firetouchinterest then
                                    firetouchinterest(hrp, touchPart, 1)
                                    firetouchinterest(hrp, touchPart, 0)
                                end

                                task.wait(delay)
                            end

                            FarmTouched[nearest] = true
                        end
                    end
                end
            end

            task.wait()
        end

        Hub.ToggleAutoFarm(false)
    end)
end

local GunNotifConn = nil
local GunNotified = false

function Hub.ToggleGunDropNotification(state)
    Hub.Config.NotifyGunDropped = state

    if GunNotifConn then
        GunNotifConn:Disconnect()

        GunNotifConn = nil
    end
    if state then
        GunNotified = false

        local gunRunning = true
        local gunThread = task.spawn(function()
            while gunRunning and Hub.Config.NotifyGunDropped do
                local map = FindMap()

                if map then
                    local gd = map:FindFirstChild('GunDrop')

                    if gd and not GunNotified then
                        GunNotified = true

                        if Library and Library.Notify then
                            Library:Notify({
                                Title = 'Gun Dropped!',
                                Description = 'The Sheriff has died. The gun is now available!',
                                Time = 5,
                            })
                        end
                    elseif not gd then
                        GunNotified = false
                    end
                end

                task.wait(0.5)
            end
        end)

        GunNotifConn = {
            Disconnect = function()
                gunRunning = false

                pcall(task.cancel, gunThread)
            end,
        }
    end
end

getgenv().VisionHub_Cleanup = function()
    for _, v in ipairs(getgenv().VisionHub_Connections)do
        if typeof(v) == 'RBXScriptConnection' and v.Connected then
            pcall(function()
                v:Disconnect()
            end)
        end
    end

    table.clear(getgenv().VisionHub_Connections)

    if getgenv().ClearESP then
        getgenv().ClearESP()
    end

    pcall(function()
        if Hub and Hub.TogglePredictionESP then
            Hub.TogglePredictionESP(false)
        end
    end)

    if getgenv().HitsoundData then
        getgenv().HitsoundData.enabled = false
        getgenv().HitsoundData = nil
    end
end

do
    local HitsoundData = {
        enabled = false,
        selectedGunshot = 'RPGS Candy',
        selectedKnifeKill = 'Golden Knife Kill',
        hooked = {},
        gunshotSounds = {
            ['Alchemist Burst'] = 'rbxassetid://130507807370367',
            ['RPGS Candy'] = 'rbxassetid://83995181532586',
            ['RPGE Beary'] = 'rbxassetid://112424028680133',
            ['DB Bloss'] = 'rbxassetid://97681259004692',
            ['Rev Blossom'] = 'rbxassetid://118868788824782',
            ['Kawaii DG'] = 'rbxassetid://135458839245691',
            ['Hit Basic 3'] = 'rbxassetid://90160800327080',
            Bameware = 'rbxassetid://3124331820',
            Bell = 'rbxassetid://6534947240',
            Bubble = 'rbxassetid://6534947588',
            Pick = 'rbxassetid://1347140027',
            Pop = 'rbxassetid://198598793',
            Rust = 'rbxassetid://1255040462',
            Sans = 'rbxassetid://3188795283',
            Fart = 'rbxassetid://130833677',
            Big = 'rbxassetid://5332005053',
            Vine = 'rbxassetid://5332680810',
            Bruh = 'rbxassetid://4578740568',
            Skeet = 'rbxassetid://5633695679',
            Neverlose = 'rbxassetid://6534948092',
            Fatality = 'rbxassetid://6534947869',
            Bonk = 'rbxassetid://5766898159',
            Minecraft = 'rbxassetid://4018616850',
            ['Call of Duty'] = 'rbxassetid://5952120301',
            Bat = 'rbxassetid://3333907347',
            Saber = 'rbxassetid://8415678813',
            Notif = 'rbxassetid://6696469190',
            Shutter = 'rbxassetid://10066921516',
            RIFK7 = 'rbxassetid://9102080552',
            LazerBeam = 'rbxassetid://130791043',
            WindowsXPError = 'rbxassetid://160715357',
            BowHit = 'rbxassetid://1053296915',
            Bow = 'rbxassetid://3442683707',
            OSU = 'rbxassetid://7147454322',
            ['Old Fatality'] = 'rbxassetid://6607142036',
            TF2 = 'rbxassetid://2868331684',
            BulletDeflect = 'rbxassetid://1657157666',
            UwU = 'rbxassetid://8679659744',
            Cod = 'rbxassetid://160432334',
        },
        knifeKillSounds = {
            ['S3 Coin Hit'] = 'rbxassetid://139857881082762',
            ['Custom Hit 1'] = 'rbxassetid://138592514473573',
            ['Golden Knife Kill'] = 'rbxassetid://6066375795',
            ['Among Us'] = 'rbxassetid://130456049552264',
            ['Jeff Laugh'] = 'rbxassetid://140445930084397',
            Pelmeni = 'rbxassetid://130226230760992',
            ['Horror Kill'] = 'rbxassetid://128741351184513',
            ['Jeff Stab'] = 'rbxassetid://81483362340487',
            Bameware = 'rbxassetid://3124331820',
            Bell = 'rbxassetid://6534947240',
            Bubble = 'rbxassetid://6534947588',
            Pick = 'rbxassetid://1347140027',
            Pop = 'rbxassetid://198598793',
            Rust = 'rbxassetid://1255040462',
            Sans = 'rbxassetid://3188795283',
            Fart = 'rbxassetid://130833677',
            Big = 'rbxassetid://5332005053',
            Vine = 'rbxassetid://5332680810',
            Bruh = 'rbxassetid://4578740568',
            Skeet = 'rbxassetid://5633695679',
            Neverlose = 'rbxassetid://6534948092',
            Fatality = 'rbxassetid://6534947869',
            Bonk = 'rbxassetid://5766898159',
            Minecraft = 'rbxassetid://4018616850',
            ['Call of Duty'] = 'rbxassetid://5952120301',
            Bat = 'rbxassetid://3333907347',
            Saber = 'rbxassetid://8415678813',
            Notif = 'rbxassetid://6696469190',
            Shutter = 'rbxassetid://10066921516',
            RIFK7 = 'rbxassetid://9102080552',
            LazerBeam = 'rbxassetid://130791043',
            WindowsXPError = 'rbxassetid://160715357',
            BowHit = 'rbxassetid://1053296915',
            Bow = 'rbxassetid://3442683707',
            OSU = 'rbxassetid://7147454322',
            ['Old Fatality'] = 'rbxassetid://6607142036',
            TF2 = 'rbxassetid://2868331684',
            BulletDeflect = 'rbxassetid://1657157666',
            UwU = 'rbxassetid://8679659744',
            Cod = 'rbxassetid://160432334',
        },
    }

    local function hookSound(sound)
        if not sound:IsA('Sound') or HitsoundData.hooked[sound] then
            return
        end

        HitsoundData.hooked[sound] = true

        sound.Played:Connect(function()
            if not HitsoundData.enabled then
                return
            end
            if sound.Name == 'Gunshot' and HitsoundData.gunshotSounds[HitsoundData.selectedGunshot] then
                local id = HitsoundData.gunshotSounds[HitsoundData.selectedGunshot]

                if sound.SoundId ~= id then
                    sound.SoundId = id
                    sound.TimePosition = 0

                    sound:Play()
                end
            elseif sound.Name == 'Kill' and HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill] then
                local id = HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill]

                if sound.SoundId ~= id then
                    sound.SoundId = id
                    sound.TimePosition = 0

                    sound:Play()
                end
            end
        end)
    end

    workspace.DescendantAdded:Connect(function(d)
        if d:IsA('Sound') and (d.Name == 'Gunshot' or d.Name == 'Kill') then
            hookSound(d)
        end
    end)
    task.defer(function()
        local list = workspace:GetDescendants()
        local n = #list
        local i = 1

        while i <= n do
            local batchEnd = math.min(i + 200, n)

            for j = i, batchEnd do
                local d = list[j]

                if d and d:IsA('Sound') and (d.Name == 'Gunshot' or d.Name == 'Kill') then
                    hookSound(d)
                end
            end

            i = batchEnd + 1

            if i <= n then
                task.wait()
            end
        end
    end)

    getgenv().HitsoundData = HitsoundData
end

local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService('CoreGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

Toggles = Toggles or {}
Options = Options or {}
getgenv().Toggles = Toggles
getgenv().Options = Options

local function __VisionHub_InitFling()
    local State = {
        isFlinging = false,
        flingTarget = nil,
        flingOldPos = nil,
        trueOriginalPos = nil,
        flingOldCameraSubject = nil,
        flingConnection = nil,
        flingVelConn = nil,
        flingAngle = 0,
        flingHighVelCount = 0,
        flingOriginalFallenHeight = nil,
        flingQueue = {},
        flingQueueIndex = 1,
        isFlingingAll = false,
        flingSuccess = false,
        currentMurderer = nil,
        currentSheriff = nil,
        allPlayersCache = {},
        flingDropdown = nil,
        flingStatusLabel = nil,
        floatingButtons = {},
    }

    local function isDead(plr)
        if not plr then
            return true
        end

        local char = plr.Character

        if not char then
            return true
        end

        local hum = char:FindFirstChildOfClass('Humanoid')

        if not hum or hum.Health <= 0 then
            return true
        end

        return false
    end
    local function cachePlayerList()
        State.allPlayersCache = {}

        for _, p in ipairs(Players:GetPlayers())do
            table.insert(State.allPlayersCache, p)
        end
    end
    local function findMurderer()
        for _, p in ipairs(Players:GetPlayers())do
            if p ~= LocalPlayer then
                local bp = p:FindFirstChild('Backpack')
                local char = p.Character

                if (bp and bp:FindFirstChild('Knife')) or (char and char:FindFirstChild('Knife')) then
                    if not isDead(p) then
                        return p
                    end
                end
            end
        end

        if State.currentMurderer and not isDead(State.currentMurderer) then
            return State.currentMurderer
        end

        return nil
    end
    local function findSheriffHero()
        for _, p in ipairs(Players:GetPlayers())do
            if p ~= LocalPlayer then
                local bp = p:FindFirstChild('Backpack')
                local char = p.Character

                if (bp and bp:FindFirstChild('Gun')) or (char and char:FindFirstChild('Gun')) then
                    if not isDead(p) then
                        return p
                    end
                end
            end
        end

        if State.currentSheriff and not isDead(State.currentSheriff) then
            return State.currentSheriff
        end

        return nil
    end
    local function updateCachedRoles()
        State.currentMurderer = findMurderer()
        State.currentSheriff = findSheriffHero()
    end

    task.spawn(function()
        pcall(function()
            local Remotes = ReplicatedStorage:WaitForChild('Remotes', 5)
            local Gameplay = Remotes and Remotes:WaitForChild('Gameplay', 5)
            local PlayerDataChanged = Gameplay and Gameplay:WaitForChild('PlayerDataChanged', 5)

            if PlayerDataChanged then
                PlayerDataChanged.OnClientEvent:Connect(function(data)
                    if typeof(data) ~= 'table' then
                        return
                    end

                    for name, info in pairs(data)do
                        if typeof(info) == 'table' and info.Role then
                            local plr = Players:FindFirstChild(name)

                            if plr then
                                if info.Role == 'Murderer' then
                                    State.currentMurderer = plr
                                elseif info.Role == 'Sheriff' or info.Role == 'Hero' then
                                    State.currentSheriff = plr
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)

    local function setStatus(text)
        if State.flingStatusLabel then
            pcall(function()
                if State.flingStatusLabel.SetText then
                    State.flingStatusLabel:SetText(text)
                end
            end)
        end
    end

    function cleanupFling()
        local wasFlinging = State.isFlinging
        local returnPos = State.trueOriginalPos or State.flingOldPos

        if State.flingVelConn then
            State.flingVelConn:Disconnect()

            State.flingVelConn = nil
        end
        if State.flingConnection then
            State.flingConnection:Disconnect()

            State.flingConnection = nil
        end

        State.isFlinging = false
        State.flingTarget = nil
        State.flingAngle = 0
        State.flingHighVelCount = 0

        if State.flingOriginalFallenHeight ~= nil then
            pcall(function()
                Workspace.FallenPartsDestroyHeight = State.flingOriginalFallenHeight
            end)

            State.flingOriginalFallenHeight = nil
        end
        if State.flingOldCameraSubject then
            pcall(function()
                Camera.CameraSubject = State.flingOldCameraSubject
            end)

            State.flingOldCameraSubject = nil
        else
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')

            if hum then
                pcall(function()
                    Camera.CameraSubject = hum
                end)
            end
        end

        local char = LocalPlayer.Character

        if char then
            local hrp = char:FindFirstChild('HumanoidRootPart')
            local hum = char:FindFirstChildOfClass('Humanoid')

            if hrp then
                for _, child in pairs(hrp:GetChildren())do
                    if child:IsA('BodyVelocity') or child:IsA('BodyGyro') or child:IsA('LinearVelocity') or child:IsA('AngularVelocity') or child.Name == '_xVibFling_2026_Safe' or child.Name == '_xVibFling_2026_Gyro' then
                        pcall(function()
                            child:Destroy()
                        end)
                    end
                end

                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end
            if returnPos and hrp then
                pcall(function()
                    hrp.CFrame = returnPos * CFrame.new(0, 0.5, 0)

                    if char.PrimaryPart then
                        char:PivotTo(returnPos * CFrame.new(0, 0.5, 0))
                    end
                end)
            end
        end

        State.flingOldPos = nil
        State.trueOriginalPos = nil

        if wasFlinging and State.isFlingingAll and State.flingQueue and State.flingQueueIndex <= #State.flingQueue then
            local nextTarget = State.flingQueue[State.flingQueueIndex]

            State.flingQueueIndex = State.flingQueueIndex + 1

            if nextTarget then
                setStatus('Fling Status: Next target...')
                task.delay(0.35, function()
                    startVibrationFling(nextTarget)
                end)

                return
            end
        end
        if wasFlinging then
            State.flingQueue = {}
            State.flingQueueIndex = 1
            State.isFlingingAll = false
        end

        setStatus('Fling Status: Idle')
    end

    local function SkidFling(TargetPlayer)
        local Player = LocalPlayer
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass('Humanoid')
        local RootPart = Humanoid and Humanoid.RootPart
        local TCharacter = TargetPlayer and TargetPlayer.Character

        if not TCharacter then
            setStatus('Fling Status: No valid character')

            return
        end

        local THumanoid = TCharacter:FindFirstChildOfClass('Humanoid')
        local TRootPart = THumanoid and THumanoid.RootPart
        local THead = TCharacter:FindFirstChild('Head')
        local Accessory = TCharacter:FindFirstChildOfClass('Accessory')
        local Handle = Accessory and Accessory:FindFirstChild('Handle')

        if not (Character and Humanoid and RootPart) then
            setStatus('Fling Status: No local character')

            return
        end
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THead and THead.Velocity.Magnitude > 500 then
        elseif not THead and Handle and Handle.Velocity.Magnitude > 500 then
        end
        if THead then
            Workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            Workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            Workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA('BasePart') then
            return
        end

        getgenv().FPDH = Workspace.FallenPartsDestroyHeight

        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang

            pcall(function()
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            end)

            RootPart.Velocity = Vector3.new(9e7, 9E8, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        local mag = (TRootPart and TRootPart.Velocity.Magnitude or 0) / 1.25

                        FPos(BasePart, CFrame.new(0, 1.5, mag), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -mag), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, mag), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        Workspace.FallenPartsDestroyHeight = 0 / 0

        local BV = Instance.new('BodyVelocity')

        BV.Name = 'EpixVel'
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        State.isFlinging = true
        State.flingTarget = TargetPlayer

        setStatus('Fling Status: Flinging ' .. TargetPlayer.Name)

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            setStatus("Fling Status: Can't find target part")
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

        Workspace.CurrentCamera.CameraSubject = Humanoid

        if getgenv().OldPos then
            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)

                pcall(function()
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                end)
                Humanoid:ChangeState('GettingUp')

                for _, x in ipairs(Character:GetChildren())do
                    if x:IsA('BasePart') then
                        x.Velocity = Vector3.new()
                        x.RotVelocity = Vector3.new()
                    end
                end

                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        end
        if getgenv().FPDH ~= nil then
            Workspace.FallenPartsDestroyHeight = getgenv().FPDH
        end

        State.isFlinging = false
        State.flingTarget = nil

        setStatus('Fling Status: Idle')
    end

    function startVibrationFling(target)
        task.spawn(function()
            SkidFling(target)
        end)
    end
    function flingMurderer()
        if State.isFlinging then
            return
        end

        updateCachedRoles()

        local murd = State.currentMurderer or findMurderer()

        if murd and murd ~= LocalPlayer and not isDead(murd) and murd.Character then
            State.flingQueue = {}
            State.flingQueueIndex = 1
            State.isFlingingAll = false

            task.spawn(function()
                SkidFling(murd)
            end)

            return
        end

        setStatus('Fling Status: No Murderer found')
    end
    function flingSheriffHero()
        if State.isFlinging then
            return
        end

        updateCachedRoles()

        local sher = State.currentSheriff or findSheriffHero()

        if sher and sher ~= LocalPlayer and not isDead(sher) and sher.Character then
            State.flingQueue = {}
            State.flingQueueIndex = 1
            State.isFlingingAll = false

            task.spawn(function()
                SkidFling(sher)
            end)

            return
        end

        setStatus('Fling Status: No Sheriff/Hero found')
    end
    function flingSelected()
        if State.isFlinging then
            cleanupFling()

            return
        end
        if not State.flingDropdown then
            setStatus('Fling Status: No player selected')

            return
        end

        local val = State.flingDropdown.Value

        if type(val) == 'table' then
            val = val[1]
        end
        if type(val) ~= 'string' or val == '' then
            setStatus('Fling Status: No player selected')

            return
        end

        local plr = Players:FindFirstChild(val)

        if plr and plr ~= LocalPlayer and not isDead(plr) and plr.Character then
            State.flingQueue = {}
            State.flingQueueIndex = 1
            State.isFlingingAll = false

            startVibrationFling(plr)

            return
        end

        setStatus('Fling Status: Invalid target')
    end
    function getFlingTargetNames()
        local names = {}

        cachePlayerList()

        for _, p in ipairs(State.allPlayersCache)do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild('HumanoidRootPart') then
                table.insert(names, p.Name)
            end
        end

        return names
    end
    function updateFlingDropdown()
        if not State.flingDropdown then
            return
        end

        pcall(function()
            State.flingDropdown:SetValues(getFlingTargetNames())
        end)
    end

    local function makeFloatingButton(name, text, color, callback)
        local parent = (gethui and gethui()) or CoreGui
        local gui = Instance.new('ScreenGui')

        gui.Name = 'FlingFloat_' .. name
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 60
        gui.Parent = parent

        local btn = Instance.new('TextButton')

        btn.Size = UDim2.fromOffset(88, 88)
        btn.Position = UDim2.new(0.85, 0, 0.5, 0)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextWrapped = true
        btn.Parent = gui
        Instance.new('UICorner', btn).CornerRadius = UDim.new(0, 12)

        local dragging, dragStart, startPos = false, nil, nil

        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position

                local moved = false
                local conn

                conn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false

                        if conn then
                            conn:Disconnect()
                        end
                        if not moved then
                            callback()
                        end
                    end
                end)

                local moveConn

                moveConn = UserInputService.InputChanged:Connect(function(inp)
                    if not dragging then
                        if moveConn then
                            moveConn:Disconnect()
                        end

                        return
                    end
                    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                        local d = inp.Position - dragStart

                        if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then
                            moved = true
                        end

                        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                    end
                end)
            end
        end)

        State.floatingButtons[name] = gui

        return gui
    end
    local function toggleFloating(name, enabled, text, color, cb)
        if State.floatingButtons[name] then
            pcall(function()
                State.floatingButtons[name]:Destroy()
            end)

            State.floatingButtons[name] = nil
        end
        if enabled then
            makeFloatingButton(name, text, color, cb)
        end
    end

    Players.PlayerAdded:Connect(function()
        task.wait(0.5)
        updateFlingDropdown()
    end)
    Players.PlayerRemoving:Connect(function()
        task.wait(0.2)
        updateFlingDropdown()
    end)
    task.spawn(function()
        while task.wait(3) do
            updateFlingDropdown()
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function()
        if State.isFlinging then
            cleanupFling()
        end
    end)

    Hub.FlingFns = Hub.FlingFns or {}

    pcall(function()
        Hub.FlingFns.State = State
    end)
    pcall(function()
        Hub.FlingFns.flingMurderer = flingMurderer
    end)
    pcall(function()
        Hub.FlingFns.flingSheriffHero = flingSheriffHero
    end)
    pcall(function()
        Hub.FlingFns.flingSelected = flingSelected
    end)
    pcall(function()
        Hub.FlingFns.cleanupFling = cleanupFling
    end)
    pcall(function()
        Hub.FlingFns.getFlingTargetNames = getFlingTargetNames
    end)
    pcall(function()
        Hub.FlingFns.updateFlingDropdown = updateFlingDropdown
    end)
    pcall(function()
        Hub.FlingFns.toggleFloating = toggleFloating
    end)
    pcall(function()
        Hub.FlingFns.startVibrationFling = startVibrationFling
    end)
    pcall(function()
        Hub.FlingFns.SkidFling = SkidFling
    end)
    pcall(function()
        Hub.FlingFns.setStatus = setStatus
    end)
    pcall(function()
        Hub.FlingFns.isDead = isDead
    end)
    pcall(function()
        Hub.FlingFns.cachePlayerList = cachePlayerList
    end)
    pcall(function()
        Hub.FlingFns.findMurderer = findMurderer
    end)
    pcall(function()
        Hub.FlingFns.findSheriffHero = findSheriffHero
    end)
    pcall(function()
        Hub.FlingFns.updateCachedRoles = updateCachedRoles
    end)
    pcall(function()
        Hub.FlingFns.makeFloatingButton = makeFloatingButton
    end)
end

__VisionHub_InitFling()

local FlingFns = Hub.FlingFns
local State = FlingFns.State
local Lighting = game:GetService('Lighting')
local MaterialService = game:GetService('MaterialService')
local ContentProvider = game:GetService('ContentProvider')
local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor,
}
local DefaultSky = Lighting:FindFirstChildOfClass('Sky')
local DefaultSkySettings = {}

if DefaultSky then
    DefaultSkySettings.SkyboxBk = DefaultSky.SkyboxBk
    DefaultSkySettings.SkyboxDn = DefaultSky.SkyboxDn
    DefaultSkySettings.SkyboxFt = DefaultSky.SkyboxFt
    DefaultSkySettings.SkyboxLf = DefaultSky.SkyboxLf
    DefaultSkySettings.SkyboxRt = DefaultSky.SkyboxRt
    DefaultSkySettings.SkyboxUp = DefaultSky.SkyboxUp
end

local AuraModels = {
    'Godly',
    'Super Sayien',
    'North Star',
    'Blue Lord',
    'Pink Aura',
    'Angel Wing',
    'Sweet Heart',
    'Ethereal Aura',
}
local AuraModelIDs = {
    Godly = 'rbxassetid://16699750981',
    ['Super Sayien'] = 'rbxassetid://116109508364297',
    ['North Star'] = 'rbxassetid://83945069652732',
    ['Blue Lord'] = 'rbxassetid://10974316799',
    ['Pink Aura'] = 'rbxassetid://115980859615239',
    ['Angel Wing'] = 'rbxassetid://90022969696073',
    ['Sweet Heart'] = 'rbxassetid://91724768175470',
    ['Ethereal Aura'] = 'rbxassetid://97041568674250',
}
local activeClassicAuras = {}
local PARTICLE_AURA_DATA = {
    {
        'starlight',
        'rbxassetid://134645216613107',
    },
    {
        'heavenly',
        'rbxassetid://139300897520961',
    },
    {
        'ribbon',
        'rbxassetid://132069507632161',
    },
    {
        'sakura',
        'rbxassetid://81755778619404',
    },
    {
        'angel',
        'rbxassetid://97658130917593',
    },
    {
        'wind',
        'rbxassetid://80694081850877',
    },
    {
        'flow',
        'rbxassetid://119913533725648',
    },
    {
        'star',
        'rbxassetid://73754563740680',
    },
    {
        'neon',
        'rbxassetid://18498709246',
    },
}
local PARTICLE_AURA_NAMES = {}
local particleAuraIdByName = {}

for _, row in ipairs(PARTICLE_AURA_DATA)do
    table.insert(PARTICLE_AURA_NAMES, row[1])

    particleAuraIdByName[row[1] ] = row[2]
end

local loadedParticleAuras = {}
local activeParticleAuras = {}
local MINECRAFT_VARIANTS = {
    Brick = {
        BaseMaterial = Enum.Material.Brick,
        Texture = 'rbxassetid://10777285622',
    },
    Concrete = {
        BaseMaterial = Enum.Material.Concrete,
        Texture = 'rbxassetid://15622710576',
    },
    CorrodedMetal = {
        BaseMaterial = Enum.Material.CorrodedMetal,
        Texture = 'rbxassetid://78612695839404',
    },
    Grass = {
        BaseMaterial = Enum.Material.Grass,
        Texture = 'rbxassetid://9267183930',
    },
    Metal = {
        BaseMaterial = Enum.Material.Metal,
        Texture = 'rbxassetid://121650613091353',
    },
    Sand = {
        BaseMaterial = Enum.Material.Sand,
        Texture = 'rbxassetid://12624140843',
    },
    Slate = {
        BaseMaterial = Enum.Material.Slate,
        Texture = 'rbxassetid://8676746437',
    },
    Wood = {
        BaseMaterial = Enum.Material.Wood,
        Texture = 'rbxassetid://3258599312',
    },
    WoodPlanks = {
        BaseMaterial = Enum.Material.WoodPlanks,
        Texture = 'rbxassetid://8676581022',
    },
}
local MATERIAL_VARIANT_BY_MATERIAL = {
    [Enum.Material.Brick] = 'Brick',
    [Enum.Material.Concrete] = 'Concrete',
    [Enum.Material.CorrodedMetal] = 'CorrodedMetal',
    [Enum.Material.Grass] = 'Grass',
    [Enum.Material.Metal] = 'Metal',
    [Enum.Material.Sand] = 'Sand',
    [Enum.Material.Slate] = 'Slate',
    [Enum.Material.Wood] = 'Wood',
    [Enum.Material.WoodPlanks] = 'WoodPlanks',
}
local MINECRAFT_TERRAIN_COLORS = {
    [Enum.Material.Grass] = Color3.fromRGB(106, 170, 64),
    [Enum.Material.Ground] = Color3.fromRGB(134, 96, 67),
    [Enum.Material.Mud] = Color3.fromRGB(102, 76, 51),
    [Enum.Material.Sand] = Color3.fromRGB(219, 211, 160),
    [Enum.Material.Rock] = Color3.fromRGB(122, 122, 122),
    [Enum.Material.Slate] = Color3.fromRGB(90, 90, 90),
    [Enum.Material.Snow] = Color3.fromRGB(245, 245, 245),
    [Enum.Material.Water] = Color3.fromRGB(63, 118, 228),
}
local LarpticTextureState = setmetatable({}, {
    __mode = 'k',
})
local LarpticMaterialVariantsBuilt = false
local SkyboxAssets = {
    ['Black Storm'] = {
        Bk = 'rbxassetid://15502511288',
        Dn = 'rbxassetid://15502508460',
        Ft = 'rbxassetid://15502510289',
        Lf = 'rbxassetid://15502507918',
        Rt = 'rbxassetid://15502509398',
        Up = 'rbxassetid://15502511911',
    },
    HD = {
        Bk = 'http://www.roblox.com/asset/?id=16553658937',
        Dn = 'http://www.roblox.com/asset/?id=16553660713',
        Ft = 'http://www.roblox.com/asset/?id=16553662144',
        Lf = 'http://www.roblox.com/asset/?id=16553664042',
        Rt = 'http://www.roblox.com/asset/?id=16553665766',
        Up = 'http://www.roblox.com/asset/?id=16553667750',
    },
    Snow = {
        Bk = 'http://www.roblox.com/asset/?id=155657655',
        Dn = 'http://www.roblox.com/asset/?id=155674246',
        Ft = 'http://www.roblox.com/asset/?id=155657609',
        Lf = 'http://www.roblox.com/asset/?id=155657671',
        Rt = 'http://www.roblox.com/asset/?id=155657619',
        Up = 'http://www.roblox.com/asset/?id=155674931',
    },
    ['Blue Space'] = {
        Bk = 'rbxassetid://15536110634',
        Dn = 'rbxassetid://15536112543',
        Ft = 'rbxassetid://15536116141',
        Lf = 'rbxassetid://15536114370',
        Rt = 'rbxassetid://15536118762',
        Up = 'rbxassetid://15536117282',
    },
    Realistic = {
        Bk = 'rbxassetid://653719502',
        Dn = 'rbxassetid://653718790',
        Ft = 'rbxassetid://653719067',
        Lf = 'rbxassetid://653719190',
        Rt = 'rbxassetid://653718931',
        Up = 'rbxassetid://653719321',
    },
    Stormy = {
        Bk = 'http://www.roblox.com/asset/?id=18703245834',
        Dn = 'http://www.roblox.com/asset/?id=18703243349',
        Ft = 'http://www.roblox.com/asset/?id=18703240532',
        Lf = 'http://www.roblox.com/asset/?id=18703237556',
        Rt = 'http://www.roblox.com/asset/?id=18703235430',
        Up = 'http://www.roblox.com/asset/?id=18703232671',
    },
    Pink = {
        Bk = 'rbxassetid://12216109205',
        Dn = 'rbxassetid://12216109875',
        Ft = 'rbxassetid://12216109489',
        Lf = 'rbxassetid://12216110170',
        Rt = 'rbxassetid://12216110471',
        Up = 'rbxassetid://12216108877',
    },
    Sunset = {
        Bk = 'rbxassetid://600830446',
        Dn = 'rbxassetid://600831635',
        Ft = 'rbxassetid://600832720',
        Lf = 'rbxassetid://600886090',
        Rt = 'rbxassetid://600833862',
        Up = 'rbxassetid://600835177',
    },
    Arctic = {
        Bk = 'http://www.roblox.com/asset/?id=225469390',
        Dn = 'http://www.roblox.com/asset/?id=225469395',
        Ft = 'http://www.roblox.com/asset/?id=225469403',
        Lf = 'http://www.roblox.com/asset/?id=225469450',
        Rt = 'http://www.roblox.com/asset/?id=225469471',
        Up = 'http://www.roblox.com/asset/?id=225469481',
    },
    Space = {
        Bk = 'http://www.roblox.com/asset/?id=166509999',
        Dn = 'http://www.roblox.com/asset/?id=166510057',
        Ft = 'http://www.roblox.com/asset/?id=166510116',
        Lf = 'http://www.roblox.com/asset/?id=166510092',
        Rt = 'http://www.roblox.com/asset/?id=166510131',
        Up = 'http://www.roblox.com/asset/?id=166510114',
    },
    ['Roblox Default'] = {
        Bk = 'rbxasset://textures/sky/sky512_bk.tex',
        Dn = 'rbxasset://textures/sky/sky512_dn.tex',
        Ft = 'rbxasset://textures/sky/sky512_ft.tex',
        Lf = 'rbxasset://textures/sky/sky512_lf.tex',
        Rt = 'rbxasset://textures/sky/sky512_rt.tex',
        Up = 'rbxasset://textures/sky/sky512_up.tex',
    },
    ['Red Night'] = {
        Bk = 'http://www.roblox.com/asset/?id=401664839',
        Dn = 'http://www.roblox.com/asset/?id=401664862',
        Ft = 'http://www.roblox.com/asset/?id=401664960',
        Lf = 'http://www.roblox.com/asset/?id=401664881',
        Rt = 'http://www.roblox.com/asset/?id=401664901',
        Up = 'http://www.roblox.com/asset/?id=401664936',
    },
    ['Deep Space 1'] = {
        Bk = 'http://www.roblox.com/asset/?id=149397692',
        Dn = 'http://www.roblox.com/asset/?id=149397686',
        Ft = 'http://www.roblox.com/asset/?id=149397697',
        Lf = 'http://www.roblox.com/asset/?id=149397684',
        Rt = 'http://www.roblox.com/asset/?id=149397688',
        Up = 'http://www.roblox.com/asset/?id=149397702',
    },
    ['Pink Skies'] = {
        Bk = 'http://www.roblox.com/asset/?id=151165214',
        Dn = 'http://www.roblox.com/asset/?id=151165197',
        Ft = 'http://www.roblox.com/asset/?id=151165224',
        Lf = 'http://www.roblox.com/asset/?id=151165191',
        Rt = 'http://www.roblox.com/asset/?id=151165206',
        Up = 'http://www.roblox.com/asset/?id=151165227',
    },
    ['Purple Sunset'] = {
        Bk = 'rbxassetid://264908339',
        Dn = 'rbxassetid://264907909',
        Ft = 'rbxassetid://264909420',
        Lf = 'rbxassetid://264909758',
        Rt = 'rbxassetid://264908886',
        Up = 'rbxassetid://264907379',
    },
    ['Blue Night'] = {
        Bk = 'http://www.roblox.com/asset/?id=12064107',
        Dn = 'http://www.roblox.com/asset/?id=12064152',
        Ft = 'http://www.roblox.com/asset/?id=12064121',
        Lf = 'http://www.roblox.com/asset/?id=12063984',
        Rt = 'http://www.roblox.com/asset/?id=12064115',
        Up = 'http://www.roblox.com/asset/?id=12064131',
    },
    ['Blossom Daylight'] = {
        Bk = 'http://www.roblox.com/asset/?id=271042516',
        Dn = 'http://www.roblox.com/asset/?id=271077243',
        Ft = 'http://www.roblox.com/asset/?id=271042556',
        Lf = 'http://www.roblox.com/asset/?id=271042310',
        Rt = 'http://www.roblox.com/asset/?id=271042467',
        Up = 'http://www.roblox.com/asset/?id=271077958',
    },
    ['Blue Nebula'] = {
        Bk = 'http://www.roblox.com/asset?id=135207744',
        Dn = 'http://www.roblox.com/asset?id=135207662',
        Ft = 'http://www.roblox.com/asset?id=135207770',
        Lf = 'http://www.roblox.com/asset?id=135207615',
        Rt = 'http://www.roblox.com/asset?id=135207695',
        Up = 'http://www.roblox.com/asset?id=135207794',
    },
    ['Blue Planet'] = {
        Bk = 'rbxassetid://218955819',
        Dn = 'rbxassetid://218953419',
        Ft = 'rbxassetid://218954524',
        Lf = 'rbxassetid://218958493',
        Rt = 'rbxassetid://218957134',
        Up = 'rbxassetid://218950090',
    },
    ['Deep Space 2'] = {
        Bk = 'http://www.roblox.com/asset/?id=159248188',
        Dn = 'http://www.roblox.com/asset/?id=159248183',
        Ft = 'http://www.roblox.com/asset/?id=159248187',
        Lf = 'http://www.roblox.com/asset/?id=159248173',
        Rt = 'http://www.roblox.com/asset/?id=159248192',
        Up = 'http://www.roblox.com/asset/?id=159248176',
    },
    Summer = {
        Bk = 'rbxassetid://16648590964',
        Dn = 'rbxassetid://16648617436',
        Ft = 'rbxassetid://16648595424',
        Lf = 'rbxassetid://16648566370',
        Rt = 'rbxassetid://16648577071',
        Up = 'rbxassetid://16648598180',
    },
    Galaxy = {
        Bk = 'rbxassetid://15983968922',
        Dn = 'rbxassetid://15983966825',
        Ft = 'rbxassetid://15983965025',
        Lf = 'rbxassetid://15983967420',
        Rt = 'rbxassetid://15983966246',
        Up = 'rbxassetid://15983964246',
    },
    Stylized = {
        Bk = 'rbxassetid://18351376859',
        Dn = 'rbxassetid://18351374919',
        Ft = 'rbxassetid://18351376800',
        Lf = 'rbxassetid://18351376469',
        Rt = 'rbxassetid://18351376457',
        Up = 'rbxassetid://18351377189',
    },
    Minecraft = {
        Bk = 'rbxassetid://8735166756',
        Dn = 'http://www.roblox.com/asset/?id=8735166707',
        Ft = 'http://www.roblox.com/asset/?id=8735231668',
        Lf = 'http://www.roblox.com/asset/?id=8735166755',
        Rt = 'http://www.roblox.com/asset/?id=8735166751',
        Up = 'http://www.roblox.com/asset/?id=8735166729',
    },
    ['Cloudy Rain'] = {
        Bk = 'http://www.roblox.com/asset/?id=4498828382',
        Dn = 'http://www.roblox.com/asset/?id=4498828812',
        Ft = 'http://www.roblox.com/asset/?id=4498829917',
        Lf = 'http://www.roblox.com/asset/?id=4498830911',
        Rt = 'http://www.roblox.com/asset/?id=4498830417',
        Up = 'http://www.roblox.com/asset/?id=4498831746',
    },
    ['Black Cloudy Rain'] = {
        Bk = 'http://www.roblox.com/asset/?id=149679669',
        Dn = 'http://www.roblox.com/asset/?id=149681979',
        Ft = 'http://www.roblox.com/asset/?id=149679690',
        Lf = 'http://www.roblox.com/asset/?id=149679709',
        Rt = 'http://www.roblox.com/asset/?id=149679722',
        Up = 'http://www.roblox.com/asset/?id=149680199',
    },
}

local function __VisionHub_InitCharVisuals()
    local HatVariables = {
        enabled = false,
        style = 'Classic',
        transparency = 0.3,
        rainbow = false,
        rainbowSpeed = 5,
        color = Color3.fromRGB(0, 255, 255),
        radius = 2.4,
        height = 1.6,
        reflectance = 0,
        sides = 25,
        parts = {},
        connection = nil,
    }
    local tau = math.pi * 2
    local drawings = {}

    for i = 1, HatVariables.sides do
        drawings[i] = {
            Drawing.new('Line'),
            Drawing.new('Triangle'),
        }
        drawings[i][1].ZIndex = 2
        drawings[i][1].Thickness = 2
        drawings[i][2].ZIndex = 1
        drawings[i][2].Filled = true
    end

    local TrailVariables = {
        enabled = false,
        isGradient = false,
        lifetime = 0.5,
        transparencyStart = 0,
        rainbow = false,
        colorStatic = Color3.fromRGB(0, 255, 255),
        gradient1 = Color3.fromRGB(0, 86, 255),
        gradient2 = Color3.fromRGB(255, 0, 0),
        parts = {},
        connection = nil,
    }
    local AuraTrailerVariables = {
        enabled = false,
        color = Color3.fromRGB(255, 0, 0),
        lifetime = 0.5,
    }
    local WorldVariables = {
        screenEnabled = false,
        screenIntensity = 0,
        screenConnection = nil,
        timeEnabled = false,
        timeValue = 12,
        fullBrightEnabled = false,
    }
    local NebulaVariables = {
        enabled = false,
        themeColor = Color3.fromRGB(173, 216, 230),
    }
    local SkyboxVariables = {
        current = 'HD',
        customEnabled = false,
    }
    local AnimeVariables = {
        enabled = false,
        gui = nil,
    }
    local FPSVariables = {
        fpsPing1Enabled = false,
        fpsPing2Enabled = false,
    }
    local LarpticAtmosphere = nil
    local player = LocalPlayer
    local camera = Camera

    local function Hat_RemoveClassic()
        if HatVariables.parts[player.Character] then
            HatVariables.parts[player.Character]:Destroy()

            HatVariables.parts[player.Character] = nil
        end
    end
    local function Hat_AddClassic(char)
        task.wait(0.1)

        local head = char:WaitForChild('Head', 5)

        if not head then
            return
        end

        Hat_RemoveClassic()

        local hat = Instance.new('Part')

        hat.Name = 'ChineseHat'
        hat.Transparency = HatVariables.transparency
        hat.Color = HatVariables.color
        hat.Material = Enum.Material.Neon
        hat.CanCollide = false
        hat.Reflectance = HatVariables.reflectance

        local mesh = Instance.new('SpecialMesh')

        mesh.MeshId = 'rbxassetid://1033714'
        mesh.Scale = Vector3.new(HatVariables.radius, HatVariables.height, HatVariables.radius)
        mesh.Parent = hat

        local weld = Instance.new('WeldConstraint')

        weld.Part0 = head
        weld.Part1 = hat
        weld.Parent = hat
        hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
        hat.Parent = char
        HatVariables.parts[char] = hat
    end
    local function Hat_UpdateClassic()
        for char, hat in pairs(HatVariables.parts)do
            if hat and hat.Parent and char == player.Character then
                hat.Transparency = HatVariables.transparency
                hat.Reflectance = HatVariables.reflectance
                hat.Color = HatVariables.rainbow and Color3.fromHSV(tick() % HatVariables.rainbowSpeed / HatVariables.rainbowSpeed, 1, 1) or HatVariables.color

                local mesh = hat:FindFirstChildOfClass('SpecialMesh')

                if mesh then
                    mesh.Scale = Vector3.new(HatVariables.radius, HatVariables.height, HatVariables.radius)
                end
            end
        end
    end
    local function Hat_UpdateDrawing()
        local pass = HatVariables.enabled and player.Character and player.Character:FindFirstChild('Head') and (camera.CFrame.p - camera.Focus.p).magnitude > 1 and player.Character.Humanoid.Health > 0

        for i = 1, #drawings do
            local line, triangle = drawings[i][1], drawings[i][2]

            if pass then
                local color = HatVariables.rainbow and Color3.fromHSV((tick() % HatVariables.rainbowSpeed / HatVariables.rainbowSpeed - (i / #drawings)) % 1, 0.5, 1) or HatVariables.color
                local pos = player.Character.Head.Position + Vector3.new(0, 0.75, 0)
                local topWorld = pos + Vector3.new(0, 0.75, 0)
                local last, next_ = (i / HatVariables.sides) * tau, ((i + 1) / HatVariables.sides) * tau
                local lastWorld = pos + (Vector3.new(math.cos(last), 0, math.sin(last)) * HatVariables.radius)
                local nextWorld = pos + (Vector3.new(math.cos(next_), 0, math.sin(next_)) * HatVariables.radius)
                local lastScreen = camera:WorldToViewportPoint(lastWorld)
                local nextScreen = camera:WorldToViewportPoint(nextWorld)
                local topScreen = camera:WorldToViewportPoint(topWorld)

                line.From = Vector2.new(lastScreen.X, lastScreen.Y)
                line.To = Vector2.new(nextScreen.X, nextScreen.Y)
                line.Color = color
                line.Transparency = 1 - HatVariables.transparency
                line.Visible = true
                triangle.PointA = Vector2.new(topScreen.X, topScreen.Y)
                triangle.PointB = line.From
                triangle.PointC = line.To
                triangle.Color = color
                triangle.Transparency = 0.35
                triangle.Visible = true
            else
                line.Visible = false
                triangle.Visible = false
            end
        end
    end
    local function Hat_ToggleEnabled(value)
        HatVariables.enabled = value

        if value then
            if HatVariables.style == 'Classic' and player.Character then
                Hat_AddClassic(player.Character)
            end
            if HatVariables.connection then
                HatVariables.connection:Disconnect()
            end

            HatVariables.connection = RunService.Heartbeat:Connect(function()
                if HatVariables.style == 'Classic' then
                    Hat_UpdateClassic()
                end
            end)
        else
            if player.Character then
                Hat_RemoveClassic()
            end

            for i = 1, #drawings do
                drawings[i][1].Visible = false
                drawings[i][2].Visible = false
            end

            if HatVariables.connection then
                HatVariables.connection:Disconnect()

                HatVariables.connection = nil
            end
        end
    end
    local function Hat_ChangeStyle(newStyle)
        local wasEnabled = HatVariables.enabled

        HatVariables.style = newStyle

        if wasEnabled then
            Hat_ToggleEnabled(false)
            task.wait(0.1)
            Hat_ToggleEnabled(true)
        end
    end
    local function Hat_UpdateSides(newSides)
        HatVariables.sides = newSides

        for i = 1, #drawings do
            drawings[i][1]:Remove()
            drawings[i][2]:Remove()
        end

        drawings = {}

        for i = 1, newSides do
            drawings[i] = {
                Drawing.new('Line'),
                Drawing.new('Triangle'),
            }
            drawings[i][1].ZIndex = 2
            drawings[i][1].Thickness = 2
            drawings[i][2].ZIndex = 1
            drawings[i][2].Filled = true
        end
    end

    RunService.RenderStepped:Connect(function()
        if HatVariables.enabled and HatVariables.style == 'Drawing' then
            Hat_UpdateDrawing()
        end
    end)

    local function Trail_RemoveFromCharacter(char)
        if TrailVariables.parts[char] then
            TrailVariables.parts[char]:Destroy()

            TrailVariables.parts[char] = nil
        end
        if char and char:FindFirstChild('HumanoidRootPart') then
            local torso = char.HumanoidRootPart

            if torso:FindFirstChild('TrailAttach0') then
                torso.TrailAttach0:Destroy()
            end
            if torso:FindFirstChild('TrailAttach1') then
                torso.TrailAttach1:Destroy()
            end
        end
    end
    local function Trail_AddToCharacter(character)
        local torso = character:WaitForChild('HumanoidRootPart', 5)

        if not torso then
            return
        end

        Trail_RemoveFromCharacter(character)

        local a0 = Instance.new('Attachment')

        a0.Name = 'TrailAttach0'
        a0.Position = Vector3.new(0, 2, 0)
        a0.Parent = torso

        local a1 = Instance.new('Attachment')

        a1.Name = 'TrailAttach1'
        a1.Position = Vector3.new(0, -2, 0)
        a1.Parent = torso

        local trail = Instance.new('Trail')

        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = TrailVariables.lifetime
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, TrailVariables.transparencyStart),
            NumberSequenceKeypoint.new(1, 1),
        })
        trail.Color = TrailVariables.isGradient and ColorSequence.new(TrailVariables.gradient1, TrailVariables.gradient2) or ColorSequence.new(TrailVariables.colorStatic)
        trail.LightEmission = 0.2
        trail.Enabled = true
        trail.Parent = character
        TrailVariables.parts[character] = trail
    end
    local function Trail_UpdateAll()
        for char, trail in pairs(TrailVariables.parts)do
            if trail and trail.Parent and char == player.Character then
                trail.Lifetime = TrailVariables.lifetime
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, TrailVariables.transparencyStart),
                    NumberSequenceKeypoint.new(1, 1),
                })

                if TrailVariables.isGradient then
                    trail.Color = ColorSequence.new(TrailVariables.gradient1, TrailVariables.gradient2)
                else
                    trail.Color = ColorSequence.new(TrailVariables.rainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or TrailVariables.colorStatic)
                end
            end
        end
    end
    local function Trail_ToggleEnabled(value)
        TrailVariables.enabled = value

        if value and player.Character then
            Trail_AddToCharacter(player.Character)

            if TrailVariables.connection then
                TrailVariables.connection:Disconnect()
            end

            TrailVariables.connection = RunService.Heartbeat:Connect(Trail_UpdateAll)
        else
            if player.Character then
                Trail_RemoveFromCharacter(player.Character)
            end
            if TrailVariables.connection then
                TrailVariables.connection:Disconnect()

                TrailVariables.connection = nil
            end
        end
    end
    local function AuraTrailer_Toggle(enabled)
        local character = player.Character

        if not character then
            return
        end

        local hrp = character:FindFirstChild('HumanoidRootPart')

        if not hrp then
            return
        end

        for _, v in pairs(character:GetChildren())do
            if v:IsA('BasePart') and v ~= hrp then
                if enabled then
                    if not v:FindFirstChild('AuraTrailer') then
                        local trail = Instance.new('Trail')

                        trail.Name = 'AuraTrailer'
                        trail.Texture = 'rbxassetid://1390780157'
                        trail.Parent = v

                        local p1 = Instance.new('Attachment', v)

                        p1.Name = 'AuraPointer1'

                        local p2 = Instance.new('Attachment', hrp)

                        p2.Name = 'AuraPointer2'
                        trail.Attachment0 = p1
                        trail.Attachment1 = p2
                        trail.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, AuraTrailerVariables.color),
                            ColorSequenceKeypoint.new(1, AuraTrailerVariables.color),
                        })
                        trail.Lifetime = AuraTrailerVariables.lifetime
                    end
                else
                    if v:FindFirstChild('AuraTrailer') then
                        v.AuraTrailer:Destroy()
                    end
                    if v:FindFirstChild('AuraPointer1') then
                        v.AuraPointer1:Destroy()
                    end
                end
            end
        end

        if not enabled then
            for _, obj in pairs(hrp:GetChildren())do
                if obj.Name == 'AuraPointer2' then
                    obj:Destroy()
                end
            end
        end
    end
    local function AuraTrailer_Update()
        local character = player.Character

        if not character then
            return
        end

        for _, v in pairs(character:GetDescendants())do
            if v:IsA('Trail') and v.Name == 'AuraTrailer' then
                v.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, AuraTrailerVariables.color),
                    ColorSequenceKeypoint.new(1, AuraTrailerVariables.color),
                })
                v.Lifetime = AuraTrailerVariables.lifetime
            end
        end
    end
    local function Skybox_Apply(name)
        local sb = SkyboxAssets[name]

        if not sb then
            return
        end

        task.spawn(function()
            ContentProvider:PreloadAsync({
                sb.Bk,
                sb.Dn,
                sb.Ft,
                sb.Lf,
                sb.Rt,
                sb.Up,
            })
        end)

        local sky = Lighting:FindFirstChildOfClass('Sky')

        if not sky then
            sky = Instance.new('Sky')
            sky.Name = 'Sky'
            sky.Parent = Lighting
        end

        sky.SkyboxBk = sb.Bk
        sky.SkyboxDn = sb.Dn
        sky.SkyboxFt = sb.Ft
        sky.SkyboxLf = sb.Lf
        sky.SkyboxRt = sb.Rt
        sky.SkyboxUp = sb.Up
    end
    local function Skybox_RestoreDefault()
        local sky = Lighting:FindFirstChildOfClass('Sky')

        if sky and DefaultSkySettings.SkyboxBk then
            sky.SkyboxBk = DefaultSkySettings.SkyboxBk
            sky.SkyboxDn = DefaultSkySettings.SkyboxDn
            sky.SkyboxFt = DefaultSkySettings.SkyboxFt
            sky.SkyboxLf = DefaultSkySettings.SkyboxLf
            sky.SkyboxRt = DefaultSkySettings.SkyboxRt
            sky.SkyboxUp = DefaultSkySettings.SkyboxUp
        elseif sky then
            sky:Destroy()
        end
    end
    local function ClassicAura_LoadModel(id)
        local success, result = pcall(function()
            return game:GetObjects(id)[1]
        end)

        if not success then
            return nil
        end

        return result
    end
    local function ClassicAura_DisableOne(auraName)
        if activeClassicAuras[auraName] then
            for _, v in pairs(activeClassicAuras[auraName])do
                if v and v.Parent then
                    pcall(function()
                        v:Destroy()
                    end)
                end
            end

            activeClassicAuras[auraName] = nil
        end
    end
    local function ClassicAura_EnableOne(char, auraName)
        if not char or not char.Parent then
            return
        end

        ClassicAura_DisableOne(auraName)

        local id = AuraModelIDs[auraName]

        if not id then
            return
        end

        local model = ClassicAura_LoadModel(id)

        if not model then
            return
        end

        local effects = {}

        for _, obj in pairs(model:GetDescendants())do
            if not obj:IsA('BasePart') then
                pcall(function()
                    local clone = obj:Clone()
                    local parentName = obj.Parent and obj.Parent.Name
                    local target = char:FindFirstChild(parentName) or char:FindFirstChild('HumanoidRootPart') or char:FindFirstChildWhichIsA('BasePart')

                    if target then
                        clone.Parent = target

                        table.insert(effects, clone)
                    end
                end)
            end
        end

        pcall(function()
            model:Destroy()
        end)

        if #effects > 0 then
            activeClassicAuras[auraName] = effects
        end
    end
    local function ClassicAura_RefreshAll()
        local char = player.Character

        if not char then
            return
        end
        if not Toggles.ClassicAuraEnabled or not Toggles.ClassicAuraEnabled.Value then
            for _, auraName in ipairs(AuraModels)do
                ClassicAura_DisableOne(auraName)
            end

            return
        end
        if not Options.ClassicAuraDropdown then
            return
        end

        local selectedAuras = Options.ClassicAuraDropdown.Value

        for _, auraName in ipairs(AuraModels)do
            ClassicAura_DisableOne(auraName)
        end

        if type(selectedAuras) == 'table' then
            for auraName, isSelected in pairs(selectedAuras)do
                if isSelected then
                    task.spawn(function()
                        ClassicAura_EnableOne(char, auraName)
                    end)
                end
            end
        end
    end
    local function mapCharacterParts(character)
        local parts = {}

        for _, child in ipairs(character:GetChildren())do
            if child:IsA('BasePart') then
                parts[child.Name] = child
            end
        end

        return parts
    end
    local function getParticleAuraTemplate(name)
        if loadedParticleAuras[name] then
            return loadedParticleAuras[name]
        end

        local id = particleAuraIdByName[name]

        if not id then
            return nil
        end

        local ok, result = pcall(function()
            return game:GetObjects(id)[1]
        end)

        if ok and result then
            loadedParticleAuras[name] = result

            return result
        end

        return nil
    end
    local function tintParticleSubtree(root, color)
        if not color or not root then
            return
        end

        local seq = ColorSequence.new(color)

        local function tintOne(obj)
            pcall(function()
                if obj:IsA('ParticleEmitter') or obj:IsA('Beam') or obj:IsA('Trail') then
                    obj.Color = seq
                elseif obj:IsA('PointLight') then
                    obj.Color = color
                end
            end)
        end

        tintOne(root)

        for _, d in ipairs(root:GetDescendants())do
            tintOne(d)
        end
    end
    local function setParticleEmittersEnabledInSubtree(root, enabled)
        if not root then
            return
        end

        pcall(function()
            if root:IsA('ParticleEmitter') then
                root.Enabled = enabled
            end
        end)

        for _, d in ipairs(root:GetDescendants())do
            pcall(function()
                if d:IsA('ParticleEmitter') then
                    d.Enabled = enabled
                end
            end)
        end
    end
    local function applyParticleAuraToCharacter(character, auraName, color)
        local auraObj = getParticleAuraTemplate(auraName)

        if not auraObj then
            return {}
        end

        local localParts = mapCharacterParts(character)
        local cloned = auraObj:Clone()
        local created = {}

        for _, part in ipairs(cloned:GetChildren())do
            local targetPart = localParts[part.Name]

            if targetPart then
                for _, child in ipairs(part:GetChildren())do
                    pcall(function()
                        local inst = child:Clone()

                        inst.Name = 'LarpticAuraParticle'
                        inst.Parent = targetPart

                        if color then
                            tintParticleSubtree(inst, color)
                        end

                        table.insert(created, inst)
                    end)
                end
            end
        end

        pcall(function()
            cloned:Destroy()
        end)

        for _, p in ipairs(created)do
            setParticleEmittersEnabledInSubtree(p, true)
        end

        return created
    end
    local function ParticleAura_DisableOne(auraName)
        if activeParticleAuras[auraName] then
            for _, p in ipairs(activeParticleAuras[auraName])do
                if p then
                    pcall(function()
                        p:Destroy()
                    end)
                end
            end

            activeParticleAuras[auraName] = nil
        end
    end
    local function ParticleAura_RefreshAll()
        local char = player.Character

        if not char then
            return
        end
        if not Toggles.ParticleAuraEnabled or not Toggles.ParticleAuraEnabled.Value then
            for _, auraName in ipairs(PARTICLE_AURA_NAMES)do
                ParticleAura_DisableOne(auraName)
            end

            return
        end
        if not Options.ParticleAuraDropdown then
            return
        end

        local selectedAuras = Options.ParticleAuraDropdown.Value

        for _, auraName in ipairs(PARTICLE_AURA_NAMES)do
            ParticleAura_DisableOne(auraName)
        end

        local col = Options.ParticleAuraColor and Options.ParticleAuraColor.Value or Color3.fromRGB(133, 220, 255)

        if type(selectedAuras) == 'table' then
            for auraName, isSelected in pairs(selectedAuras)do
                if isSelected then
                    task.spawn(function()
                        activeParticleAuras[auraName] = applyParticleAuraToCharacter(char, auraName, col)
                    end)
                end
            end
        end
    end
    local function applyAtmosphere()
        if not Toggles.WorldAtmEnabled or not Toggles.WorldAtmEnabled.Value then
            if LarpticAtmosphere then
                pcall(function()
                    LarpticAtmosphere:Destroy()
                end)

                LarpticAtmosphere = nil
            end

            return
        end

        local atm = LarpticAtmosphere

        if not (atm and atm.Parent) then
            atm = Instance.new('Atmosphere')
            atm.Name = 'LarpticAtmosphere'
            atm.Parent = Lighting
            LarpticAtmosphere = atm
        end

        pcall(function()
            atm.Density = Options.WorldAtmDensity and Options.WorldAtmDensity.Value or 0.35
            atm.Offset = Options.WorldAtmOffset and Options.WorldAtmOffset.Value or 0
            atm.Haze = Options.WorldAtmHaze and Options.WorldAtmHaze.Value or 1
            atm.Glare = Options.WorldAtmGlare and Options.WorldAtmGlare.Value or 10
            atm.Color = (Options.WorldAtmColor and Options.WorldAtmColor.Value) or Color3.fromRGB(199, 212, 255)
            atm.Decay = (Options.WorldAtmDecay and Options.WorldAtmDecay.Value) or Color3.fromRGB(106, 112, 125)
        end)
    end
    local function ensureMinecraftVariants()
        if LarpticMaterialVariantsBuilt then
            return
        end

        for name, data in pairs(MINECRAFT_VARIANTS)do
            local variant = MaterialService:FindFirstChild(name)

            if not variant then
                variant = Instance.new('MaterialVariant')
                variant.Name = name
                variant.Parent = MaterialService
            end

            pcall(function()
                variant.BaseMaterial = data.BaseMaterial
                variant.ColorMap = data.Texture
                variant.MetalnessMap = data.Texture
                variant.NormalMap = data.Texture
                variant.RoughnessMap = data.Texture
                variant.MaterialPattern = Enum.MaterialPattern.Regular
                variant.StudsPerTile = 5
            end)
        end

        LarpticMaterialVariantsBuilt = true
    end
    local function rememberPartState(part)
        if not LarpticTextureState[part] then
            LarpticTextureState[part] = {
                Color = part.Color,
                Material = part.Material,
                MaterialVariant = part.MaterialVariant,
            }
        end

        return LarpticTextureState[part]
    end
    local function shouldSkipTexturePart(part)
        if not part:IsDescendantOf(workspace) then
            return true
        end
        if part.Name == 'LarpticWeather' or part.Name == 'Part' then
            return true
        end

        local parent = part.Parent

        if parent and (parent:IsA('Tool') or parent:IsA('Accessory')) then
            return true
        end

        local model = part:FindFirstAncestorOfClass('Model')

        if model and game.Players:GetPlayerFromCharacter(model) then
            return true
        end

        return false
    end
    local function applyPartTexturePack()
        ensureMinecraftVariants()

        for _, obj in ipairs(workspace:GetDescendants())do
            if obj:IsA('BasePart') and not shouldSkipTexturePart(obj) then
                rememberPartState(obj)

                local variantName = MATERIAL_VARIANT_BY_MATERIAL[obj.Material]

                if variantName then
                    pcall(function()
                        obj.MaterialVariant = variantName
                    end)
                end
            end
        end
    end
    local function clearPartTexturePack()
        for part, state in pairs(LarpticTextureState)do
            if part and part.Parent and state then
                pcall(function()
                    part.Color = state.Color
                    part.Material = state.Material
                    part.MaterialVariant = state.MaterialVariant or ''
                end)
            end
        end
    end
    local function clearMinecraftVariants()
        for name in pairs(MINECRAFT_VARIANTS)do
            local variant = MaterialService:FindFirstChild(name)

            if variant and variant:IsA('MaterialVariant') then
                pcall(function()
                    variant:Destroy()
                end)
            end
        end

        LarpticMaterialVariantsBuilt = false
    end
    local function applyTexturePack()
        local Terrain = workspace:FindFirstChildOfClass('Terrain')

        if Terrain then
            for mat, col in pairs(MINECRAFT_TERRAIN_COLORS)do
                pcall(function()
                    Terrain:SetMaterialColor(mat, col)
                end)
            end
        end

        applyPartTexturePack()
    end
    local function clearTexturePack()
        clearPartTexturePack()
        clearMinecraftVariants()
    end
    local function Nebula_Enable()
        local b = Instance.new('BloomEffect', Lighting)

        b.Intensity = 0.7
        b.Size = 24
        b.Threshold = 1
        b.Name = 'NebulaBloom'

        local c = Instance.new('ColorCorrectionEffect', Lighting)

        c.Saturation = 0.5
        c.Contrast = 0.2
        c.TintColor = NebulaVariables.themeColor
        c.Name = 'NebulaColorCorrection'

        local a = Instance.new('Atmosphere', Lighting)

        a.Density = 0.4
        a.Offset = 0.25
        a.Glare = 1
        a.Haze = 2
        a.Color = NebulaVariables.themeColor
        a.Decay = Color3.fromRGB(173, 216, 230)
        a.Name = 'NebulaAtmosphere'
        Lighting.Ambient = NebulaVariables.themeColor
        Lighting.OutdoorAmbient = NebulaVariables.themeColor
        Lighting.FogStart = 100
        Lighting.FogEnd = 500
        Lighting.FogColor = NebulaVariables.themeColor
    end
    local function Nebula_Disable()
        for _, name in pairs({
            'NebulaBloom',
            'NebulaColorCorrection',
            'NebulaAtmosphere',
        })do
            local obj = Lighting:FindFirstChild(name)

            if obj then
                obj:Destroy()
            end
        end

        Lighting.Ambient = defaultLighting.Ambient
        Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        Lighting.FogStart = defaultLighting.FogStart
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.FogColor = defaultLighting.FogColor
    end
    local function Nebula_UpdateColor()
        if NebulaVariables.enabled then
            local nc = Lighting:FindFirstChild('NebulaColorCorrection')

            if nc then
                nc.TintColor = NebulaVariables.themeColor
            end

            local na = Lighting:FindFirstChild('NebulaAtmosphere')

            if na then
                na.Color = NebulaVariables.themeColor
            end

            Lighting.Ambient = NebulaVariables.themeColor
            Lighting.OutdoorAmbient = NebulaVariables.themeColor
            Lighting.FogColor = NebulaVariables.themeColor
        end
    end
    local function Screen_Toggle(value)
        WorldVariables.screenEnabled = value

        if value then
            WorldVariables.screenConnection = RunService.RenderStepped:Connect(function()
                camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, (0.65 + WorldVariables.screenIntensity), 0, 0, 0, 1)
            end)
        else
            if WorldVariables.screenConnection then
                WorldVariables.screenConnection:Disconnect()

                WorldVariables.screenConnection = nil
            end
        end
    end
    local function Anime_Toggle(value)
        AnimeVariables.enabled = value

        if value then
            AnimeVariables.gui = Instance.new('ScreenGui', player.PlayerGui)
            AnimeVariables.gui.Name = 'AnimeImageGui'
            AnimeVariables.gui.ResetOnSpawn = false

            local imageLabel = Instance.new('ImageLabel', AnimeVariables.gui)

            imageLabel.Name = 'AnimeImage'
            imageLabel.Image = 'http://www.roblox.com/asset/?id=117783035423570'
            imageLabel.Size = UDim2.new(0, 350, 0, 400)
            imageLabel.Position = UDim2.new(1, -25, 0, 10)
            imageLabel.AnchorPoint = Vector2.new(1, 0)
            imageLabel.BackgroundTransparency = 1
        else
            if AnimeVariables.gui then
                AnimeVariables.gui:Destroy()

                AnimeVariables.gui = nil
            end
        end
    end

    RunService.Heartbeat:Connect(function()
        if WorldVariables.timeEnabled then
            Lighting.ClockTime = WorldVariables.timeValue
        end
        if WorldVariables.fullBrightEnabled then
            Lighting.Brightness = 3
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ExposureCompensation = 0.3
        end
    end)

    local function ReapplyVisuals_OnCharacterSpawned(char)
        task.wait(1)

        if HatVariables.enabled and HatVariables.style == 'Classic' then
            Hat_AddClassic(char)
        end
        if TrailVariables.enabled then
            Trail_AddToCharacter(char)
        end
        if AuraTrailerVariables.enabled then
            AuraTrailer_Toggle(true)
        end
        if AnimeVariables.enabled then
            Anime_Toggle(true)
        end

        ClassicAura_RefreshAll()
        ParticleAura_RefreshAll()
    end

    if player then
        player.CharacterAdded:Connect(ReapplyVisuals_OnCharacterSpawned)

        if player.Character then
            ReapplyVisuals_OnCharacterSpawned(player.Character)
        end
    end

    local function clearAtmosphere()
        if LarpticAtmosphere then
            pcall(function()
                LarpticAtmosphere:Destroy()
            end)

            LarpticAtmosphere = nil
        end
    end

    Hub.VisualFns = Hub.VisualFns or {}
    Hub.VisualFns.clearAtmosphere = clearAtmosphere
    Hub.Hat_ToggleEnabled = Hat_ToggleEnabled
    Hub.VisualFns.Hat_ToggleEnabled = Hat_ToggleEnabled
    Hub.VisualFns.Hat_ChangeStyle = Hat_ChangeStyle
    Hub.VisualFns.Hat_UpdateSides = Hat_UpdateSides
    Hub.VisualFns.HatVariables = HatVariables
    Hub.VisualFns.Trail_ToggleEnabled = Trail_ToggleEnabled
    Hub.VisualFns.Trail_UpdateAll = Trail_UpdateAll
    Hub.VisualFns.Trail_AddToCharacter = Trail_AddToCharacter
    Hub.VisualFns.TrailVariables = TrailVariables
    Hub.VisualFns.AuraTrailer_Toggle = AuraTrailer_Toggle
    Hub.VisualFns.AuraTrailer_Update = AuraTrailer_Update
    Hub.VisualFns.AuraTrailerVariables = AuraTrailerVariables
    Hub.VisualFns.Skybox_Apply = Skybox_Apply
    Hub.VisualFns.Skybox_RestoreDefault = Skybox_RestoreDefault
    Hub.VisualFns.SkyboxVariables = SkyboxVariables
    Hub.VisualFns.SkyboxAssets = SkyboxAssets
    Hub.VisualFns.ClassicAura_RefreshAll = ClassicAura_RefreshAll
    Hub.VisualFns.AuraModels = AuraModels
    Hub.VisualFns.ParticleAura_RefreshAll = ParticleAura_RefreshAll
    Hub.VisualFns.PARTICLE_AURA_NAMES = PARTICLE_AURA_NAMES
    Hub.VisualFns.applyAtmosphere = applyAtmosphere
    Hub.VisualFns.LarpticAtmosphere = LarpticAtmosphere
    Hub.VisualFns.applyTexturePack = applyTexturePack
    Hub.VisualFns.clearTexturePack = clearTexturePack
    Hub.VisualFns.Nebula_Enable = Nebula_Enable
    Hub.VisualFns.Nebula_Disable = Nebula_Disable
    Hub.VisualFns.Nebula_UpdateColor = Nebula_UpdateColor
    Hub.VisualFns.NebulaVariables = NebulaVariables
    Hub.VisualFns.Screen_Toggle = Screen_Toggle
    Hub.VisualFns.WorldVariables = WorldVariables
    Hub.VisualFns.Anime_Toggle = Anime_Toggle
    Hub.VisualFns.AnimeVariables = AnimeVariables
    Hub.VisualFns.FPSVariables = FPSVariables
    Hub.VisualFns.player = player
end

__VisionHub_InitCharVisuals()

local VisualFns = Hub.VisualFns

do
    local _writefile = writefile or (getgenv and getgenv().writefile)
    local _readfile = readfile or (getgenv and getgenv().readfile)
    local _isfile = isfile or (getgenv and getgenv().isfile)

    local function normalizePath(path)
        return tostring(path or ''):gsub('\\', '/')
    end
    local function isDefaultConfig(path)
        path = normalizePath(path)

        return path:match('ProjectVault/Default$') ~= nil or path == 'Default'
    end

    if _writefile then
        local guardedWrite = function(path, data)
            if isDefaultConfig(path) then
                return
            end

            return _writefile(path, data)
        end

        writefile = guardedWrite

        if getgenv then
            getgenv().writefile = guardedWrite
        end
    end
    if _isfile then
        local guardedIsFile = function(path)
            if isDefaultConfig(path) then
                return false
            end

            return _isfile(path)
        end

        isfile = guardedIsFile

        if getgenv then
            getgenv().isfile = guardedIsFile
        end
    end
    if _readfile then
        local guardedRead = function(path)
            if isDefaultConfig(path) then
                return nil
            end

            return _readfile(path)
        end

        readfile = guardedRead

        if getgenv then
            getgenv().readfile = guardedRead
        end
    end
end

local NeverLose = loadstring(game:HttpGet('https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau'))()
local Notification = NeverLose:CreateNotification()
local Logging = NeverLose:CreateLogger()
local Library = {
    Notify = function(_, opts)
        Notification.new({
            Title = opts.Title or 'Candy Ware',
            Content = opts.Description or opts.Content or '',
            Duration = opts.Time or 5,
        })
    end,
    Unload = function()
        if getgenv().VisionHub_Cleanup then
            pcall(getgenv().VisionHub_Cleanup)
        end
    end,
}

getgenv().Library = Library

local Toggles = getgenv().Toggles or {}
local Options = getgenv().Options or {}

local function makeToggleProxy(flag, default)
    local t = Toggles[flag] or {
        Value = default or false,
        Flag = flag,
    }

    t.Value = t.Value ~= nil and t.Value or (default or false)

    function t:SetValue(v)
        self.Value = v

        if self._element and self._element.SetValue then
            pcall(function()
                self._element:SetValue(v)
            end)
        end
    end
    function t:GetValue()
        if self._element and self._element.GetValue then
            local ok, v = pcall(function()
                return self._element:GetValue()
            end)

            if ok then
                self.Value = v
            end
        end

        return self.Value
    end

    Toggles[flag] = t

    return t
end
local function makeOptionProxy(flag, default)
    local o = Options[flag] or {
        Value = default,
        Flag = flag,
    }

    o.Value = o.Value ~= nil and o.Value or default

    function o:SetValue(v)
        self.Value = v

        if self._element and self._element.SetValue then
            pcall(function()
                self._element:SetValue(v)
            end)
        end
    end
    function o:SetValues(list)
        if self._element and self._element.SetValues then
            pcall(function()
                self._element:SetValues(list)
            end)
        end
    end
    function o:GetValue()
        if self._element and self._element.GetValue then
            local ok, v = pcall(function()
                return self._element:GetValue()
            end)

            if ok then
                self.Value = v
            end
        end

        return self.Value
    end

    Options[flag] = o

    return o
end

local VaultLogo = NeverLose.GlobalLogo

pcall(function()
    local logoUrl = 'https://raw.githubusercontent.com/mopsech/candyhub/main/candy.png'
    local data = game:HttpGet(logoUrl)

    if writefile then
        writefile('candy_logo.png', data)   -- меняем имя файла
    end
    if getcustomasset then
        VaultLogo = getcustomasset('candy_logo.png')
    elseif getcustomasset and isfile and isfile('candy_logo.png') then
        VaultLogo = getcustomasset('candy_logo.png')
    end
end)

local Window = NeverLose:CreateWindow({
    Logo = VaultLogo,
    Name = 'Candy Ware',
    Content = 'discord.gg/3daeHMjgsQ',
    Size = NeverLose.Scales.Default,
    ConfigFolder = 'candycfg',
    Enable3DRenderer = false,
    Keybind = 'LeftControl',
})

pcall(function()
    local rawDelfile = delfile or (getgenv and getgenv().delfile)
    local rawIsfile = nil

    if rawDelfile then
        pcall(rawDelfile, 'candycfg/Default')
        pcall(rawDelfile, 'candycfg/Default')
    end
end)
task.spawn(function()
    local rawDelfile = delfile or (getgenv and getgenv().delfile)

    for _ = 1, 15 do
        task.wait(0.4)

        if rawDelfile then
            pcall(rawDelfile, 'candycfg/Default')
            pcall(rawDelfile, 'candycfg/Default')
        end
    end
end)
Notification.new({
    Title = 'Candy Ware',
    Content = 'Loaded successfully',
    Duration = 5,
})

FlingFns = Hub.FlingFns or FlingFns or {}
State = (FlingFns and FlingFns.State) or State or {}
VisualFns = Hub.VisualFns or VisualFns or {}

Window:AddTabLabel('MAIN')

local CombatTab = Window:AddTab({
    Icon = 'crosshairs',
    Name = 'Combat',
})
local VisualsTab = Window:AddTab({
    Icon = 'eye',
    Name = 'Visuals',
})
local WorldTab = Window:AddTab({
    Icon = 'globe-detailed',
    Name = 'World',
})
local MiscTab = Window:AddTab({
    Icon = 'backpack',
    Name = 'Misc',
})
local SettingsTab = Window:AddTab({
    Icon = 'gear',
    Name = 'Settings',
})
local BadgeFns = {}

do
    local BadgeDisplay = LocalPlayer and LocalPlayer.DisplayName or ''
    local BadgeName = LocalPlayer and LocalPlayer.Name or ''
    local VERIFIED = utf8.char(0xe000)
    local B = {
        verifiedEnabled = false,
        starEnabled = false,
        imageAsset = nil,
        verifiedTracked = setmetatable({}, {
            __mode = 'k',
        }),
        starTracked = setmetatable({}, {
            __mode = 'k',
        }),
        verifiedConnections = {},
        starConnections = {},
        verifiedLoop = nil,
        starLoop = nil,
        respawnConn = nil,
        plrListConn = nil,
    }

    local function getScanRoots()
        local roots = {}

        if CoreGui then
            table.insert(roots, CoreGui)
        end

        pcall(function()
            local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass('PlayerGui')

            if pg then
                table.insert(roots, pg)
            end
        end)

        return roots
    end
    local function stripVerified()
        for _, root in ipairs(getScanRoots())do
            pcall(function()
                for _, v in ipairs(root:GetDescendants())do
                    if v:IsA('TextLabel') or v:IsA('TextButton') then
                        local t = v.Text

                        if t and t:find(VERIFIED) then
                            v.Text = t:gsub(VERIFIED, '')
                        end
                    end
                end
            end)
        end
    end
    local function clearVerified()
        B.verifiedEnabled = false

        if TextChatService then
            pcall(function()
                TextChatService.OnIncomingMessage = nil
            end)
        end

        for _, conn in pairs(B.verifiedConnections)do
            pcall(function()
                conn:Disconnect()
            end)
        end

        table.clear(B.verifiedConnections)

        if B.verifiedLoop then
            pcall(task.cancel, B.verifiedLoop)

            B.verifiedLoop = nil
        end

        table.clear(B.verifiedTracked)
        stripVerified()
    end
    local function clearStar()
        B.starEnabled = false

        for _, conn in pairs(B.starConnections)do
            pcall(function()
                conn:Disconnect()
            end)
        end

        table.clear(B.starConnections)

        if B.starLoop then
            pcall(task.cancel, B.starLoop)

            B.starLoop = nil
        end

        for label in pairs(B.starTracked)do
            local parent = label and label.Parent

            if parent then
                local existing = parent:FindFirstChild('StarCreatorBadge')

                if existing then
                    pcall(function()
                        existing:Destroy()
                    end)
                end
            end
        end

        table.clear(B.starTracked)

        for _, root in ipairs(getScanRoots())do
            pcall(function()
                for _, v in ipairs(root:GetDescendants())do
                    if v.Name == 'StarCreatorBadge' then
                        pcall(function()
                            v:Destroy()
                        end)
                    end
                end
            end)
        end
    end
    local function hookChatVerified()
        if not TextChatService then
            return
        end

        TextChatService.OnIncomingMessage = function(message)
            local props = Instance.new('TextChatMessageProperties')

            if B.verifiedEnabled and message.TextSource and LocalPlayer and message.TextSource.UserId == LocalPlayer.UserId then
                local prefix = message.PrefixText or (BadgeDisplay .. ':')

                prefix = prefix:gsub(':%s*$', '')

                if not prefix:find(VERIFIED) then
                    props.PrefixText = prefix .. VERIFIED .. ':'
                else
                    props.PrefixText = prefix
                end
            end

            return props
        end
    end
    local function fixVerifiedLabel(label)
        if not B.verifiedEnabled or not label or not label.Parent then
            return
        end

        local text = label.Text

        if not text or text == '' or text:find(VERIFIED) then
            return
        end

        local newText

        if text:find(BadgeDisplay, 1, true) then
            newText = text:gsub(BadgeDisplay, BadgeDisplay .. VERIFIED, 1)
        elseif text:find('@' .. BadgeName, 1, true) then
            newText = text:gsub('@' .. BadgeName, '@' .. BadgeName .. VERIFIED, 1)
        elseif text:find(BadgeName, 1, true) then
            newText = text:gsub(BadgeName, BadgeName .. VERIFIED, 1)
        end
        if newText then
            pcall(function()
                label.Text = newText
            end)
        end
    end
    local function trackVerified(label)
        if not label or B.verifiedTracked[label] then
            return
        end

        B.verifiedTracked[label] = true

        fixVerifiedLabel(label)
        table.insert(B.verifiedConnections, label:GetPropertyChangedSignal('Text'):Connect(function()
            fixVerifiedLabel(label)
        end))
    end
    local function scanVerified()
        if not B.verifiedEnabled then
            return
        end

        for _, root in ipairs(getScanRoots())do
            local ok, list = pcall(function()
                return root:GetDescendants()
            end)

            if ok and list then
                local count = 0

                for _, v in ipairs(list)do
                    if v:IsA('TextLabel') or v:IsA('TextButton') then
                        local t = v.Text

                        if t and (t:find(BadgeDisplay, 1, true) or t:find(BadgeName, 1, true) or t:find('@' .. BadgeName, 1, true)) then
                            trackVerified(v)
                        end
                    end

                    count = count + 1

                    if count % 150 == 0 then
                        task.wait()
                    end
                end
            end
        end
    end
    local function isInPlayerList(obj)
        local current = obj
        local depth = 0

        while current and depth < 25 do
            local n = tostring(current.Name):lower()

            if n:find('playerlist') or n:find('player_list') or n:find('people') or n:find('playerlist') or n == 'players' then
                return true
            end

            current = current.Parent
            depth = depth + 1
        end

        return false
    end
    local function addStarImage(label)
        if not B.starEnabled or not B.imageAsset or not label or not label.Parent then
            return
        end
        if not isInPlayerList(label) then
            return
        end

        local parent = label.Parent

        if not parent then
            return
        end

        local existing = parent:FindFirstChild('StarCreatorBadge')

        if existing and B.starTracked[label] then
            return
        end
        if existing then
            pcall(function()
                existing:Destroy()
            end)
        end

        B.starTracked[label] = true

        local img = Instance.new('ImageLabel')

        img.Name = 'StarCreatorBadge'
        img.BackgroundTransparency = 1
        img.Image = B.imageAsset
        img.Size = UDim2.new(0, 14, 0, 14)
        img.AnchorPoint = Vector2.new(1, 0.5)
        img.Position = UDim2.new(0, -3, 0.5, 1)
        img.ZIndex = (label.ZIndex or 1) + 1
        img.Parent = parent

        local function updatePos()
            if img and img.Parent and label and label.Parent then
                img.Position = UDim2.new(0, -3, 0.5, 1)
            end
        end

        table.insert(B.starConnections, label:GetPropertyChangedSignal('Text'):Connect(updatePos))
        table.insert(B.starConnections, label:GetPropertyChangedSignal('TextBounds'):Connect(updatePos))
        table.insert(B.starConnections, label:GetPropertyChangedSignal('AbsoluteSize'):Connect(updatePos))
    end
    local function scanStar()
        if not B.starEnabled then
            return
        end

        for _, root in ipairs(getScanRoots())do
            local ok, list = pcall(function()
                return root:GetDescendants()
            end)

            if ok and list then
                local count = 0

                for _, v in ipairs(list)do
                    if (v:IsA('TextLabel') or v:IsA('TextButton')) and isInPlayerList(v) then
                        local t = v.Text

                        if t and (t:find(BadgeDisplay, 1, true) or t:find(BadgeName, 1, true) or t:find('@' .. BadgeName, 1, true)) then
                            addStarImage(v)
                        end
                    end

                    count = count + 1

                    if count % 150 == 0 then
                        task.wait()
                    end
                end
            end
        end
    end
    local function forceRefreshBadges()
        if B.verifiedEnabled then
            table.clear(B.verifiedTracked)
            hookChatVerified()
            scanVerified()
        end
        if B.starEnabled then
            table.clear(B.starTracked)
            scanStar()
        end
    end
    local function bindRespawnHooks()
        if B.respawnConn then
            pcall(function()
                B.respawnConn:Disconnect()
            end)

            B.respawnConn = nil
        end
        if not LocalPlayer then
            return
        end

        B.respawnConn = LocalPlayer.CharacterAdded:Connect(function()
            task.delay(0.75, forceRefreshBadges)
        end)

        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')

            if hum then
                hum.Died:Connect(function()
                    task.delay(1, forceRefreshBadges)
                end)
            end
        end

        LocalPlayer.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild('Humanoid', 10)

            if hum then
                hum.Died:Connect(function()
                    task.delay(1, forceRefreshBadges)
                end)
            end
        end)
    end
    local function startVerified()
        local was = B.verifiedEnabled

        if B.verifiedLoop then
            pcall(task.cancel, B.verifiedLoop)

            B.verifiedLoop = nil
        end

        for _, conn in pairs(B.verifiedConnections)do
            pcall(function()
                conn:Disconnect()
            end)
        end

        table.clear(B.verifiedConnections)
        table.clear(B.verifiedTracked)

        B.verifiedEnabled = true

        hookChatVerified()
        scanVerified()

        B.verifiedLoop = task.spawn(function()
            while B.verifiedEnabled do
                scanVerified()
                task.wait(1.5)
            end
        end)

        for _, root in ipairs(getScanRoots())do
            table.insert(B.verifiedConnections, root.DescendantAdded:Connect(function(obj)
                if not B.verifiedEnabled then
                    return
                end
                if obj:IsA('TextLabel') or obj:IsA('TextButton') then
                    task.defer(function()
                        local t = obj.Text

                        if t and (t:find(BadgeDisplay, 1, true) or t:find(BadgeName, 1, true) or t:find('@' .. BadgeName, 1, true)) then
                            trackVerified(obj)
                        end
                    end)
                end
            end))
        end

        bindRespawnHooks()
    end
    local function startStar()
        if B.starLoop then
            pcall(task.cancel, B.starLoop)

            B.starLoop = nil
        end

        for _, conn in pairs(B.starConnections)do
            pcall(function()
                conn:Disconnect()
            end)
        end

        table.clear(B.starConnections)
        table.clear(B.starTracked)

        B.starEnabled = true

        if not B.imageAsset then
            pcall(function()
                local url = 'https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/4X/e/4/0/e40401a6461ea6998787a77c84b8ce47a4d6dca5.png'
                local data = game:HttpGet(url)

                if writefile then
                    writefile('starcreator.png', data)
                end
                if getcustomasset then
                    B.imageAsset = getcustomasset('starcreator.png')
                end
            end)
        end

        scanStar()

        B.starLoop = task.spawn(function()
            while B.starEnabled do
                scanStar()
                task.wait(2)
            end
        end)

        for _, root in ipairs(getScanRoots())do
            table.insert(B.starConnections, root.DescendantAdded:Connect(function(obj)
                if not B.starEnabled then
                    return
                end
                if (obj:IsA('TextLabel') or obj:IsA('TextButton')) and isInPlayerList(obj) then
                    task.defer(function()
                        local t = obj.Text

                        if t and (t:find(BadgeDisplay, 1, true) or t:find(BadgeName, 1, true) or t:find('@' .. BadgeName, 1, true)) then
                            addStarImage(obj)
                        end
                    end)
                end
            end))
        end

        bindRespawnHooks()
    end

    local oldCleanup = getgenv().VisionHub_Cleanup

    getgenv().VisionHub_Cleanup = function()
        pcall(clearVerified)
        pcall(clearStar)

        if B.respawnConn then
            pcall(function()
                B.respawnConn:Disconnect()
            end)
        end
        if oldCleanup then
            pcall(oldCleanup)
        end
    end
    BadgeFns.startVerified = startVerified
    BadgeFns.clearVerified = clearVerified
    BadgeFns.startStar = startStar
    BadgeFns.clearStar = clearStar
    BadgeFns.forceRefresh = forceRefreshBadges
end

local OtherBadges = MiscTab:AddSection({
    Name = 'BADGES',
    Position = 'left',
})

do
    local t = makeToggleProxy('VerifiedBadgeToggle', false)

    OtherBadges:AddLabel('Verified Badge'):AddToggle({
        Default = false,
        Flag = 'VerifiedBadgeToggle',
        Callback = function(v)
            t.Value = v

            if v then
                BadgeFns.startVerified()
            else
                BadgeFns.clearVerified()
            end
        end,
    })

    local t2 = makeToggleProxy('StarCreatorToggle', false)

    OtherBadges:AddLabel('Star Creator Badge'):AddToggle({
        Default = false,
        Flag = 'StarCreatorToggle',
        Callback = function(v)
            t2.Value = v

            if v then
                BadgeFns.startStar()
            else
                BadgeFns.clearStar()
            end
        end,
    })
end

local WeaponMeshBox = MiscTab:AddSection({
    Name = 'WEAPON MESHES',
    Position = 'right',
})

do
    local mm2MeshesRunning = false

    local function RunMM2WeaponMeshes()
        if mm2MeshesRunning then
            pcall(function()
                Notification.new({
                    Title = 'Candy Ware',
                    Content = 'Weapon meshes already running',
                    Duration = 3,
                })
            end)

            return
        end

        mm2MeshesRunning = true

        task.spawn(function()
            local ok, err = pcall(function()
                local src = [[if not isfile("mm2data.lua") then
    local result = request({
Url = "https://raw.githubusercontent.com/Lutosys/opensrc/refs/heads/main/mm2meshes.lua",
Method = "GET",
    })
    if result.Success then
writefile("mm2data.lua", result.Body)
    end
end

data = loadfile("mm2data.lua")() or nil
if not data then
    return warn("failed to load data")
end

local function findMeshAndTexture(node)
    if not node or type(node) ~= "table" then return nil end

    local props = node.Props
    if props then
local meshId = props.MeshId or props.MeshID
if meshId and meshId ~= "" then
    local textureId = props.TextureId or props.TextureID or ""
    local scale = props.Scale or Vector3.new(0.045,0.045,0.045)
    local size = props.Size or Vector3.new(0.045,0.045,0.045)
    return {
        meshid = meshId, 
        textureid = textureId, 
        scale = scale, 
        size = size
    }
end
    end

    if node.Display and type(node.Display) == "table" then
for _, child in ipairs(node.Display) do
    local res = findMeshAndTexture(child)
    if res then return res end
end
    end
    
    return nil
end
local function getWeaponData(name)
    local weaponData = data[name]
    if not weaponData then
return nil
    end

    local found = findMeshAndTexture(weaponData)
    if found then
return found
    end

    return nil
end

local function applyWeaponMesh(refPart, weaponData, weaponName, weapontype)
    if not weaponData then
return
    end
    if not weaponData.meshid then
return
    end

    if weaponData.meshid:find("79401392") then
if weapontype == "Gun" then
    local tool = refPart:FindFirstAncestorOfClass("Tool")
    if tool then
        tool.Grip = CFrame.fromMatrix(
            Vector3.new(0, -0.699999988, -0.300000012),
            Vector3.new(1, 0, 0), 
            Vector3.new(0, 0, 1), 
            Vector3.new(0, -1, 0)
        )
    end
end
    elseif weaponData.meshid:find("6600918074") then
if weapontype == "Gun" then
    local tool = refPart:FindFirstAncestorOfClass("Tool")
    if tool then
        tool.Grip = CFrame.new(1, -0.359999988, 0.00000012, 0, 0, 1, 0, 1, 0, -1, 0, 0)
    end
end
    else
if weapontype == "Gun" then
    local tool = refPart:FindFirstAncestorOfClass("Tool")
    if tool then
        tool.Grip = CFrame.fromMatrix(
            Vector3.new(0, -0.5, 0.7),
            Vector3.new(1, 0, 0),
            Vector3.new(0, 1, 0),
            Vector3.new(0, 0, 1)
        )
    end
end
    end

    if refPart:IsA("MeshPart") then
local specialMesh = refPart:FindFirstChildOfClass("SpecialMesh")
if specialMesh then
    specialMesh:Destroy()
end
refPart.Size = weaponData.size
refPart.MeshId = weaponData.meshid
refPart.TextureID = weaponData.textureid
    else
local mesh = refPart:FindFirstChildOfClass("SpecialMesh")
if not mesh then
    mesh = Instance.new("SpecialMesh")
    mesh.Name = "Mesh"
    mesh.Parent = refPart
end
refPart.Size = weaponData.size
mesh.MeshId = weaponData.meshid
mesh.TextureId = weaponData.textureid
mesh.Scale = weaponData.scale
    end
end

local InventoryModule = require(game.ReplicatedStorage.Modules.InventoryModule)
local ProfileData = require(game.ReplicatedStorage.Modules.ProfileData)
local Sync = require(game.ReplicatedStorage.Database.Sync)

for name, itemData in pairs(Sync.Weapons) do
    itemData.SortWithinGroup = itemData.SortWithinGroup or 0
    itemData.SortGroup = itemData.SortGroup or nil
    itemData.Name = itemData.Name or itemData.ItemName or name
    itemData.Rarity = itemData.Rarity or "Common"

    if Sync.Rarities[itemData.Rarity] then
local weaponMeshInfo = getWeaponData(name)
if weaponMeshInfo and weaponMeshInfo.meshid and weaponMeshInfo.textureid and weaponMeshInfo.scale and weaponMeshInfo.size then
    ProfileData.Weapons.Owned[name] = 1
end
    end
end

local UpdateInventory = filtergc("table", {Keys = {"UpdateInventory"}}, true).UpdateInventory
for key, func in pairs(getgc()) do
    if typeof(func) == "function" and islclosure(func) and debug.info(func, "l") == 122 and #debug.getupvalues(func) == 2 then
UpdateInventory(debug.getupvalue(func, 2), InventoryModule.MyInventory)
    end
end

local function isMurder()
    local success, result = pcall(function()
for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if typeof(v) == "Instance" and v:IsA("Tool") and v:GetAttribute("ItemType") == "Knife" then
        return true
    end
end

for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if typeof(v) == "Instance" and v:IsA("Tool") and v:GetAttribute("ItemType") == "Knife" then
        return true
    end
end

return false
    end)
    
    if success then
return result
    end
    
    return false
end

game.Workspace.ChildAdded:Connect(function(ch)
    if ch and ch:IsA("BasePart") and ch.Name == "StuckKnife" then
local mesh = ch:WaitForChild("Mesh")
if mesh then
    local equippedKnifeName = ProfileData.Weapons.Equipped.Knife
    local knifedata = getWeaponData(equippedKnifeName)
    if knifedata then
        if isMurder() then
            mesh.MeshId = knifedata.meshid
            mesh.TextureId = knifedata.textureid
            mesh.Scale = knifedata.scale
        end
    end
end
    end
end)

while wait() do
    local char = game.Players.LocalPlayer.Character
    if char then
local equippedKnifeName = ProfileData.Weapons.Equipped.Knife
local equippedGunName = ProfileData.Weapons.Equipped.Gun

for _, tool in pairs(char:GetChildren()) do
    if tool and tool:IsA("Tool") then
        local itemType = tool:GetAttribute("ItemType")
        local Handle = tool:FindFirstChild("Handle")
        if Handle then
            if itemType == "Knife" and equippedKnifeName then
                local knifedata = getWeaponData(equippedKnifeName)
                if knifedata and knifedata.meshid and knifedata.textureid and knifedata.scale and knifedata.size then
                    applyWeaponMesh(Handle, knifedata, equippedKnifeName, "Knife")
                end
            elseif itemType == "Gun" and equippedGunName then
                local gundata = getWeaponData(equippedGunName)
                if gundata and gundata.meshid and gundata.textureid and gundata.scale and gundata.size then
                    applyWeaponMesh(Handle, gundata, equippedGunName, "Gun")
                end
            end
        end
    end
end

local DisplayRefGun = char:FindFirstChild("DisplayRefGun")
if DisplayRefGun then
    local refVal = DisplayRefGun.Value
    if refVal and typeof(refVal) == "Instance" and equippedGunName then
        local gundata = getWeaponData(equippedGunName)
        if gundata and gundata.meshid and gundata.textureid and gundata.scale and gundata.size then
            applyWeaponMesh(refVal, gundata, equippedGunName)
        end
    end
end

local DisplayRefKnife = char:FindFirstChild("DisplayRefKnife")
if DisplayRefKnife then
    local refVal = DisplayRefKnife.Value
    if refVal and typeof(refVal) == "Instance" and equippedKnifeName then
        local knifedata = getWeaponData(equippedKnifeName)
        if knifedata and knifedata.meshid and knifedata.textureid and knifedata.scale and knifedata.size then
            applyWeaponMesh(refVal, knifedata, equippedKnifeName)
        end
    end
end
    end
end]]
                local fn, loadErr = loadstring(src)

                if not fn then
                    error(tostring(loadErr or 'loadstring failed'))
                end

                fn()
            end)

            if not ok then
                mm2MeshesRunning = false

                pcall(function()
                    Notification.new({
                        Title = 'Candy Ware',
                        Content = 'Weapon meshes error: ' .. tostring(err),
                        Duration = 5,
                    })
                end)
            end
        end)
        pcall(function()
            Notification.new({
                Title = 'Candy Ware',
                Content = 'Weapon meshes started',
                Duration = 3,
            })
        end)
    end

    WeaponMeshBox:AddButton({
        Name = 'Load Weapon Meshes',
        Icon = 'backpack',
        Callback = RunMM2WeaponMeshes,
    })
end

local KnifeSizeBox = MiscTab:AddSection({
    Name = 'KNIFE SIZE',
    Position = 'left',
})
local GunSizeBox = MiscTab:AddSection({
    Name = 'GUN SIZE',
    Position = 'right',
})

do
    local WeaponSize = {
        knifeScale = 1,
        gunScale = 1,
        originals = {},
        renderConn = nil,
        heartbeatConn = nil,
        charConn = nil,
        equipConn = nil,
        bpConn = nil,
    }

    local function WeaponSize_IsKnifeTool(tool)
        if not tool or not tool:IsA('Tool') then
            return false
        end

        local n = string.lower(tool.Name)

        if n:find('knife', 1, true) then
            return true
        end

        local ok, attr = pcall(function()
            return tool:GetAttribute('ItemType')
        end)

        if ok and attr and string.lower(tostring(attr)) == 'knife' then
            return true
        end

        return false
    end
    local function WeaponSize_IsGunTool(tool)
        if not tool or not tool:IsA('Tool') then
            return false
        end

        local n = string.lower(tool.Name)

        if n:find('gun', 1, true) or n:find('revolver', 1, true) or n:find('pistol', 1, true) then
            return true
        end

        local ok, attr = pcall(function()
            return tool:GetAttribute('ItemType')
        end)

        if ok and attr then
            local a = string.lower(tostring(attr))

            if a == 'gun' or a == 'revolver' or a == 'weapon' then
                return true
            end
        end

        return false
    end
    local function WeaponSize_MeshKey(part)
        local key = ''

        pcall(function()
            if part:IsA('MeshPart') then
                key = key .. tostring(part.MeshId) .. ':' .. tostring(part.TextureID)
            end

            local sm = part:FindFirstChildOfClass('SpecialMesh')

            if sm then
                key = key .. '|' .. tostring(sm.MeshId) .. ':' .. tostring(sm.TextureId)
            end
        end)

        return key
    end
    local function WeaponSize_ApplyPart(part, scale)
        if not part or not part:IsA('BasePart') then
            return
        end
        if part.Name == 'HumanoidRootPart' then
            return
        end

        scale = math.clamp(tonumber(scale) or 1, 0.1, 20)

        if scale == 1 then
            return
        end

        pcall(function()
            local sm = part:FindFirstChildOfClass('SpecialMesh')
            local meshKey = WeaponSize_MeshKey(part)
            local entry = WeaponSize.originals[part]

            local function recache(fromScale)
                fromScale = math.max(tonumber(fromScale) or 1, 0.001)

                local baseSize = part.Size / fromScale
                local baseMesh = nil

                if sm then
                    baseMesh = sm.Scale / fromScale
                end

                entry = {
                    baseSize = baseSize,
                    baseMeshScale = baseMesh,
                    meshKey = meshKey,
                    lastScale = 1,
                }
                WeaponSize.originals[part] = entry
            end

            if not entry then
                recache(1)
            elseif entry.meshKey ~= meshKey then
                recache(1)
            else
                local expected = entry.baseSize * (entry.lastScale or 1)
                local diffExpected = (part.Size - expected).Magnitude
                local diffBase = (part.Size - entry.baseSize).Magnitude

                if diffBase < 0.025 then
                    entry.lastScale = 1
                elseif diffExpected > 0.04 then
                    recache(1)
                end
            end

            entry.lastScale = scale
            part.Size = entry.baseSize * scale

            if sm then
                if not entry.baseMeshScale then
                    entry.baseMeshScale = sm.Scale / math.max(scale, 0.001)
                end

                sm.Scale = entry.baseMeshScale * scale
            end
            if part:IsA('MeshPart') then
                part.Size = entry.baseSize * scale
            end
        end)
    end
    local function WeaponSize_ApplyToObject(obj, scale)
        if not obj or scale == 1 then
            return
        end
        if obj:IsA('BasePart') then
            WeaponSize_ApplyPart(obj, scale)
        end

        local handle = obj:FindFirstChild('Handle')

        if handle and handle:IsA('BasePart') then
            WeaponSize_ApplyPart(handle, scale)
        end

        for _, d in ipairs(obj:GetDescendants())do
            if d:IsA('BasePart') then
                WeaponSize_ApplyPart(d, scale)
            end
        end
    end
    local function WeaponSize_CollectTargets()
        local knives, guns = {}, {}
        local seen = {}
        local char = LocalPlayer and LocalPlayer.Character
        local backpack = LocalPlayer and LocalPlayer:FindFirstChild('Backpack')

        local function add(list, obj)
            if obj and not seen[obj] then
                seen[obj] = true

                table.insert(list, obj)
            end
        end
        local function scan(container)
            if not container then
                return
            end

            for _, child in ipairs(container:GetChildren())do
                if child:IsA('Tool') then
                    if WeaponSize_IsKnifeTool(child) then
                        add(knives, child)
                    elseif WeaponSize_IsGunTool(child) then
                        add(guns, child)
                    end
                end
            end
        end

        scan(char)
        scan(backpack)

        if char then
            local knifeRef = char:FindFirstChild('DisplayRefKnife')
            local gunRef = char:FindFirstChild('DisplayRefGun')

            if knifeRef and knifeRef.Value then
                add(knives, knifeRef.Value)
            end
            if gunRef and gunRef.Value then
                add(guns, gunRef.Value)
            end

            for _, d in ipairs(char:GetDescendants())do
                if d:IsA('BasePart') or d:IsA('MeshPart') then
                    local n = string.lower(d.Name)

                    if n:find('knife', 1, true) or n == 'handle' then
                        local tool = d:FindFirstAncestorOfClass('Tool')

                        if tool and WeaponSize_IsKnifeTool(tool) then
                            add(knives, tool)
                        elseif not tool and n:find('knife', 1, true) then
                            add(knives, d)
                        end
                    end
                    if n:find('gun', 1, true) or n:find('revolver', 1, true) then
                        local tool = d:FindFirstAncestorOfClass('Tool')

                        if tool and WeaponSize_IsGunTool(tool) then
                            add(guns, tool)
                        elseif not tool then
                            add(guns, d)
                        end
                    end
                end
            end
        end

        pcall(function()
            for _, ch in ipairs(Workspace:GetChildren())do
                if ch:IsA('BasePart') and ch.Name == 'StuckKnife' then
                    add(knives, ch)
                end
            end
        end)

        return knives, guns
    end
    local function WeaponSize_Refresh()
        if WeaponSize.knifeScale == 1 and WeaponSize.gunScale == 1 then
            return
        end

        local knives, guns = WeaponSize_CollectTargets()

        for _, obj in ipairs(knives)do
            WeaponSize_ApplyToObject(obj, WeaponSize.knifeScale)
        end
        for _, obj in ipairs(guns)do
            WeaponSize_ApplyToObject(obj, WeaponSize.gunScale)
        end
    end
    local function WeaponSize_ForceEquipped()
        local char = LocalPlayer and LocalPlayer.Character

        if not char then
            return
        end

        for _, child in ipairs(char:GetChildren())do
            if child:IsA('Tool') then
                if WeaponSize_IsKnifeTool(child) and WeaponSize.knifeScale ~= 1 then
                    WeaponSize_ApplyToObject(child, WeaponSize.knifeScale)
                elseif WeaponSize_IsGunTool(child) and WeaponSize.gunScale ~= 1 then
                    WeaponSize_ApplyToObject(child, WeaponSize.gunScale)
                end
            end
        end

        local knifeRef = char:FindFirstChild('DisplayRefKnife')
        local gunRef = char:FindFirstChild('DisplayRefGun')

        if knifeRef and knifeRef.Value and WeaponSize.knifeScale ~= 1 then
            WeaponSize_ApplyToObject(knifeRef.Value, WeaponSize.knifeScale)
        end
        if gunRef and gunRef.Value and WeaponSize.gunScale ~= 1 then
            WeaponSize_ApplyToObject(gunRef.Value, WeaponSize.gunScale)
        end
    end
    local function WeaponSize_Tick()
        if WeaponSize.knifeScale == 1 and WeaponSize.gunScale == 1 then
            return
        end

        WeaponSize_ForceEquipped()
        WeaponSize_Refresh()
    end
    local function WeaponSize_Disconnect()
        if WeaponSize.renderConn then
            pcall(function()
                if typeof(WeaponSize.renderConn) == 'RBXScriptConnection' then
                    WeaponSize.renderConn:Disconnect()
                end
            end)
            DisconnectConnection(WeaponSize.renderConn)

            WeaponSize.renderConn = nil
        end
        if WeaponSize.heartbeatConn then
            pcall(function()
                if typeof(WeaponSize.heartbeatConn) == 'RBXScriptConnection' then
                    WeaponSize.heartbeatConn:Disconnect()
                end
            end)
            DisconnectConnection(WeaponSize.heartbeatConn)

            WeaponSize.heartbeatConn = nil
        end
        if WeaponSize.charConn then
            pcall(function()
                WeaponSize.charConn:Disconnect()
            end)

            WeaponSize.charConn = nil
        end
        if WeaponSize.equipConn then
            pcall(function()
                WeaponSize.equipConn:Disconnect()
            end)

            WeaponSize.equipConn = nil
        end
        if WeaponSize.bpConn then
            pcall(function()
                WeaponSize.bpConn:Disconnect()
            end)

            WeaponSize.bpConn = nil
        end
    end
    local function WeaponSize_BindCharacter(char)
        if WeaponSize.equipConn then
            pcall(function()
                WeaponSize.equipConn:Disconnect()
            end)

            WeaponSize.equipConn = nil
        end
        if not char then
            return
        end

        WeaponSize.equipConn = TrackConnection(char.ChildAdded:Connect(function(child)
            if child:IsA('Tool') then
                task.defer(WeaponSize_Tick)
                task.delay(0.05, WeaponSize_Tick)
                task.delay(0.15, WeaponSize_Tick)
            end
        end))

        for _, child in ipairs(char:GetChildren())do
            if child:IsA('Tool') then
                pcall(function()
                    TrackConnection(child.DescendantAdded:Connect(function()
                        task.defer(WeaponSize_Tick)
                    end))
                end)
            end
        end
    end
    local function WeaponSize_Start()
        WeaponSize_Disconnect()

        if LocalPlayer then
            WeaponSize.charConn = TrackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.35)

                WeaponSize.originals = {}

                WeaponSize_BindCharacter(char)
                WeaponSize_Tick()
            end))

            if LocalPlayer.Character then
                WeaponSize_BindCharacter(LocalPlayer.Character)
            end

            local bp = LocalPlayer:FindFirstChild('Backpack')

            if bp then
                WeaponSize.bpConn = TrackConnection(bp.ChildAdded:Connect(function()
                    task.defer(WeaponSize_Tick)
                end))
            end
        end

        WeaponSize.heartbeatConn = TrackConnection(RunService.Heartbeat:Connect(function()
            WeaponSize_Tick()
        end))
        WeaponSize.renderConn = TrackConnection(RunService.RenderStepped:Connect(function()
            WeaponSize_ForceEquipped()
        end))

        WeaponSize_Tick()
    end

    WeaponSize_Start()

    local function setKnifeScale(mult)
        WeaponSize.knifeScale = math.clamp(tonumber(mult) or 1, 1, 20)
        WeaponSize.originals = {}

        WeaponSize_Tick()
        pcall(function()
            Notification.new({
                Title = 'Candy Ware',
                Content = 'Knife size: x' .. tostring(WeaponSize.knifeScale) .. ' (session only)',
                Duration = 2,
            })
        end)
    end
    local function setGunScale(mult)
        WeaponSize.gunScale = math.clamp(tonumber(mult) or 1, 1, 20)
        WeaponSize.originals = {}

        WeaponSize_Tick()
        pcall(function()
            Notification.new({
                Title = 'Candy Ware',
                Content = 'Gun size: x' .. tostring(WeaponSize.gunScale) .. ' (session only)',
                Duration = 2,
            })
        end)
    end

    WeaponSize.knifeScale = 1
    WeaponSize.gunScale = 1

    local sizeValues = {}

    for i = 2, 40 do
        local mult = i / 2

        if mult == math.floor(mult) then
            table.insert(sizeValues, 'x' .. tostring(math.floor(mult)))
        else
            table.insert(sizeValues, 'x' .. string.format('%.1f', mult))
        end
    end

    local function parseScaleLabel(v)
        local n = tonumber(tostring(v):match('[%d%.]+'))

        n = math.clamp(n or 1, 1, 20)
        n = math.floor(n * 2 + 0.5) / 2

        return n
    end

    KnifeSizeBox:AddLabel('Select Knife Size (in hands, session only)'):AddDropdown({
        Default = 'x1',
        Values = sizeValues,
        Callback = function(v)
            setKnifeScale(parseScaleLabel(v))
        end,
    })
    GunSizeBox:AddLabel('Select Gun Size (in hands, session only)'):AddDropdown({
        Default = 'x1',
        Values = sizeValues,
        Callback = function(v)
            setGunScale(parseScaleLabel(v))
        end,
    })
end

local KeybindActions = {
    GrabGunKey = 'G',
    KillAllKey = 'K',
    SilentThrowKey = 'V',
    ShootMurdererKey = 'E',
    WallBangKey = 'B',
    PredictionESPKey = 'P',
    SpeedGlitchKey = 'C',
}

local function normalizeKeybind(key)
    if key == nil then
        return nil
    end
    if typeof(key) == 'EnumItem' then
        return key.Name
    end

    local s = tostring(key)

    s = s:gsub('^Enum%.KeyCode%.', ''):gsub('^KeyCode%.', '')

    if s:find('MouseButton1') or s == 'MouseButton1' or s == 'M1' or s == 'LMB' then
        return 'M1B'
    end
    if s:find('MouseButton2') or s == 'MouseButton2' or s == 'M2' or s == 'RMB' then
        return 'M2B'
    end

    return s
end
local function setKeybindAction(action, key, fallback)
    local n = normalizeKeybind(key) or fallback

    KeybindActions[action] = n

    return n
end
local function keyMatches(bound, input)
    if not bound or not input then
        return false
    end

    bound = normalizeKeybind(bound)

    if not bound then
        return false
    end
    if bound == 'M1B' then
        return input.UserInputType == Enum.UserInputType.MouseButton1
    end
    if bound == 'M2B' then
        return input.UserInputType == Enum.UserInputType.MouseButton2
    end
    if input.KeyCode == Enum.KeyCode.Unknown then
        return false
    end

    local name = input.KeyCode.Name

    return name == bound or name:lower() == bound:lower()
end
local function isTypingInTextBox()
    local ok, focused = pcall(function()
        return UserInputService:GetFocusedTextBox()
    end)

    if not ok or not focused then
        return false
    end
    if not focused.Parent then
        return false
    end
    if focused.Visible == false then
        return false
    end

    local abs = focused.AbsoluteSize

    if abs and abs.X <= 0 and abs.Y <= 0 then
        return false
    end

    return true
end

local KeybindBeganConn = nil
local KeybindEndedConn = nil

local function bindKeybindHandlers()
    if KeybindBeganConn then
        pcall(function()
            if KeybindBeganConn.Connected then
                KeybindBeganConn:Disconnect()
            end
        end)

        KeybindBeganConn = nil
    end
    if KeybindEndedConn then
        pcall(function()
            if KeybindEndedConn.Connected then
                KeybindEndedConn:Disconnect()
            end
        end)

        KeybindEndedConn = nil
    end

    KeybindBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isTypingInTextBox() then
            return
        end
        if keyMatches(KeybindActions.GrabGunKey, input) then
            pcall(function()
                Hub.GrabGun()
            end)
        elseif keyMatches(KeybindActions.KillAllKey, input) then
            pcall(function()
                Hub.KillAll()
            end)
        elseif keyMatches(KeybindActions.SilentThrowKey, input) then
            pcall(function()
                Hub.ExecuteSilentThrow()
            end)
        elseif keyMatches(KeybindActions.ShootMurdererKey, input) then
            pcall(function()
                Hub.ShootMurderer()
            end)
        elseif keyMatches(KeybindActions.WallBangKey, input) then
            pcall(function()
                Hub.WallBangShoot()
            end)
        elseif keyMatches(KeybindActions.PredictionESPKey, input) then
            pcall(function()
                Hub.SetPredictionESPVisible(true)
            end)
        elseif keyMatches(KeybindActions.SpeedGlitchKey, input) then
            pcall(function()
                local nextState = not Hub.Config.SpeedGlitch

                Hub.ToggleSpeedGlitch(nextState)

                if Toggles and Toggles.SpeedGlitchToggle then
                    Toggles.SpeedGlitchToggle.Value = nextState

                    if Toggles.SpeedGlitchToggle.SetValue then
                        pcall(function()
                            Toggles.SpeedGlitchToggle:SetValue(nextState)
                        end)
                    end
                end
            end)
        end
    end)
    KeybindEndedConn = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if keyMatches(KeybindActions.PredictionESPKey, input) then
            if Hub.Config and not Hub.Config.PredictionESPAlways then
                pcall(function()
                    Hub.SetPredictionESPVisible(false)
                end)
            end
        end
    end)

    TrackConnection(KeybindBeganConn)
    TrackConnection(KeybindEndedConn)
end

bindKeybindHandlers()
task.spawn(function()
    while true do
        task.wait(4)

        local beganOk = KeybindBeganConn and KeybindBeganConn.Connected
        local endedOk = KeybindEndedConn and KeybindEndedConn.Connected

        if not beganOk or not endedOk then
            pcall(bindKeybindHandlers)
        end
    end
end)

getgenv().VisionHub_SetKeybind = setKeybindAction

local CombatGeneral = CombatTab:AddSection({
    Name = 'GENERAL',
    Position = 'left',
})
local CombatMurderer = CombatTab:AddSection({
    Name = 'MURDERER',
    Position = 'right',
})
local CombatSheriff = CombatTab:AddSection({
    Name = 'SHERIFF',
    Position = 'left',
})

do
    local t = makeToggleProxy('AntiFlingToggle', false)

    CombatGeneral:AddLabel('Anti-Fling'):AddToggle({
        Default = false,
        Flag = 'AntiFlingToggle',
        Callback = function(v)
            t.Value = v

            Hub.ToggleAntiFling(v)
        end,
    })

    local t2 = makeToggleProxy('AntiAFKToggle', false)

    CombatGeneral:AddLabel('Anti-AFK'):AddToggle({
        Default = false,
        Flag = 'AntiAFKToggle',
        Callback = function(v)
            t2.Value = v

            Hub.ToggleAntiAFK(v)
        end,
    })

    local t4 = makeToggleProxy('AutoGrabGunToggle', false)

    CombatGeneral:AddLabel('Auto Grab Gun'):AddToggle({
        Default = false,
        Flag = 'AutoGrabGunToggle',
        Callback = function(v)
            t4.Value = v

            Hub.ToggleAutoGrabGun(v)
        end,
    })
    CombatGeneral:AddLabel('Manual Grab Gun'):AddKeybind({
        Default = 'G',
        Flag = 'GrabGunKey',
        Callback = function(key)
            setKeybindAction('GrabGunKey', key, 'G')
        end,
    })

    local tSg = makeToggleProxy('SpeedGlitchToggle', false)

    CombatGeneral:AddLabel('Speed Glitch'):AddToggle({
        Default = false,
        Flag = 'SpeedGlitchToggle',
        Callback = function(v)
            tSg.Value = v

            Hub.ToggleSpeedGlitch(v)
        end,
    })

    local oSg = makeOptionProxy('SpeedGlitchSpeed', 50)

    CombatGeneral:AddLabel('Speed Glitch Speed'):AddSlider({
        Default = 50,
        Min = 1,
        Max = 500,
        Rounding = 0,
        Flag = 'SpeedGlitchSpeed',
        Size = 80,
        Callback = function(v)
            oSg.Value = v

            Hub.SetSpeedGlitchSpeed(v)
        end,
    })
    CombatGeneral:AddLabel('Speed Glitch Key'):AddKeybind({
        Default = 'C',
        Flag = 'SpeedGlitchKey',
        Callback = function(key)
            setKeybindAction('SpeedGlitchKey', key, 'C')
        end,
    })
end
do
    local o = makeOptionProxy('KillAllMode', 'Default')

    CombatMurderer:AddLabel('Kill All Mode'):AddDropdown({
        Default = 'Default',
        Values = {
            'Default',
            'Silent',
        },
        Flag = 'KillAllMode',
        Callback = function(v)
            o.Value = v
            Hub.Config.KillAllMode = v
        end,
    })
    CombatMurderer:AddLabel('Kill All Players'):AddKeybind({
        Default = 'K',
        Flag = 'KillAllKey',
        Callback = function(key)
            setKeybindAction('KillAllKey', key, 'K')
        end,
    })

    local t = makeToggleProxy('AutoKillAllToggle', false)

    CombatMurderer:AddLabel('Auto Kill All'):AddToggle({
        Default = false,
        Flag = 'AutoKillAllToggle',
        Callback = function(v)
            t.Value = v

            Hub.ToggleAutoKillAll(v)
        end,
    })

    local o2 = makeOptionProxy('KnifeAuraMode', 'Default')

    CombatMurderer:AddLabel('Knife Aura Mode'):AddDropdown({
        Default = 'Default',
        Values = {
            'Default',
            'Silent',
        },
        Flag = 'KnifeAuraMode',
        Callback = function(v)
            o2.Value = v
            Hub.Config.KnifeAuraMode = v
        end,
    })

    local t2 = makeToggleProxy('KnifeAuraToggle', false)

    CombatMurderer:AddLabel('Knife Aura'):AddToggle({
        Default = false,
        Flag = 'KnifeAuraToggle',
        Callback = function(v)
            t2.Value = v

            Hub.ToggleKnifeAura(v)
        end,
    })

    local o3 = makeOptionProxy('KnifeAuraRange', 20)

    CombatMurderer:AddLabel('Knife Aura Range'):AddSlider({
        Default = 20,
        Min = 5,
        Max = 300,
        Rounding = 0,
        Flag = 'KnifeAuraRange',
        Size = 80,
        Callback = function(v)
            o3.Value = v
            Hub.Config.KnifeAuraRange = v
        end,
    })

    local t3 = makeToggleProxy('SilentThrowToggle', false)

    CombatMurderer:AddLabel('Auto Silent Knife Throw'):AddToggle({
        Default = false,
        Flag = 'SilentThrowToggle',
        Callback = function(v)
            t3.Value = v

            Hub.ToggleSilentThrow(v)
        end,
    })
    CombatMurderer:AddLabel('Silent Knife Throw'):AddKeybind({
        Default = 'V',
        Flag = 'SilentThrowKey',
        Callback = function(key)
            setKeybindAction('SilentThrowKey', key, 'V')
        end,
    })
end
do
    local t = makeToggleProxy('AutoShootMurdererToggle', false)

    CombatSheriff:AddLabel('Auto Shoot Murderer'):AddToggle({
        Default = false,
        Flag = 'AutoShootMurdererToggle',
        Callback = function(v)
            t.Value = v

            Hub.ToggleAutoShootMurderer(v)
        end,
    })
    CombatSheriff:AddLabel('Shoot Murderer'):AddKeybind({
        Default = 'E',
        Flag = 'ShootMurdererKey',
        Callback = function(key)
            setKeybindAction('ShootMurdererKey', key, 'E')
        end,
    })

    local o = makeOptionProxy('AutoHolsterDelay', 1.5)

    CombatSheriff:AddLabel('Gun Holster Delay'):AddSlider({
        Default = 1.5,
        Min = 0,
        Max = 10,
        Rounding = 1,
        Flag = 'AutoHolsterDelay',
        Size = 80,
        Callback = function(v)
            o.Value = v
            Hub.Config.AutoHolsterDelay = v
        end,
    })

    local t2 = makeToggleProxy('AutoWallBangToggle', false)

    CombatSheriff:AddLabel('Auto Wall Bang (Premium)'):AddToggle({
        Default = false,
        Flag = 'AutoWallBangToggle',
        Callback = function(v)
            t2.Value = v

            Hub.ToggleWallBang(v)
        end,
    })
    CombatSheriff:AddLabel('Wall Bang Murderer'):AddKeybind({
        Default = 'B',
        Flag = 'WallBangKey',
        Callback = function(key)
            setKeybindAction('WallBangKey', key, 'B')
        end,
    })
end

local FlingBox = CombatTab:AddSection({
    Name = 'FLING',
    Position = 'right',
})

FlingBox:AddButton({
    Name = 'Fling Murderer',
    Icon = 'crosshairs',
    Callback = function()
        if FlingFns.flingMurderer then
            FlingFns.flingMurderer()
        end
    end,
})
FlingBox:AddButton({
    Name = 'Fling Sheriff/Hero',
    Icon = 'shield-check',
    Callback = function()
        if FlingFns.flingSheriffHero then
            FlingFns.flingSheriffHero()
        end
    end,
})

local flingTargetOpt = makeOptionProxy('FlingTarget', '')
local flingDrop = FlingBox:AddLabel('Select Player'):AddDropdown({
    Default = '',
    Values = (FlingFns.getFlingTargetNames and FlingFns.getFlingTargetNames()) or {},
    Multi = false,
    Flag = 'FlingTarget',
    Callback = function(v)
        flingTargetOpt.Value = v

        if State then
            State.flingDropdown = flingTargetOpt
        end
    end,
})

if State then
    State.flingDropdown = flingTargetOpt
end

FlingBox:AddButton({
    Name = 'Fling Selected',
    Icon = 'circle-person',
    Callback = function()
        if FlingFns.flingSelected then
            FlingFns.flingSelected()
        end
    end,
})
task.spawn(function()
    while task.wait(3) do
        if FlingFns.updateFlingDropdown then
            pcall(FlingFns.updateFlingDropdown)
        end
        if flingDrop and flingDrop.SetValues and FlingFns.getFlingTargetNames then
            pcall(function()
                flingDrop:SetValues(FlingFns.getFlingTargetNames())
            end)
        end
    end
end)

local VisMurderer = VisualsTab:AddSection({
    Name = 'MURDERER ESP',
    Position = 'left',
})
local VisSheriff = VisualsTab:AddSection({
    Name = 'SHERIFF ESP',
    Position = 'right',
})
local VisInnocent = VisualsTab:AddSection({
    Name = 'INNOCENT ESP',
    Position = 'left',
})
local VisWorld = VisualsTab:AddSection({
    Name = 'WORLD',
    Position = 'right',
})

do
    local o = makeOptionProxy('ESPColorMurderer', Color3.fromRGB(255, 0, 0))

    VisMurderer:AddLabel('Murderer Color'):AddColorPicker({
        Default = Color3.fromRGB(255, 0, 0),
        Flag = 'ESPColorMurderer',
        Callback = function(c)
            o.Value = c
            Hub.Config.ESPColorMurderer = c
        end,
    })

    for _, info in ipairs({
        {
            'HighlightMurderer',
            'Murderer Chams',
            'HighlightMurderer',
        },
        {
            'InfoMurderer',
            'Murderer Name & Info',
            'InfoMurderer',
        },
        {
            'BoxMurderer',
            'Murderer Box ESP',
            'BoxMurderer',
        },
        {
            'TracersMurderer',
            'Murderer Tracers',
            'TracersMurderer',
        },
        {
            'SkeletonMurderer',
            'Murderer Skeleton',
            'SkeletonMurderer',
        },
    })do
        local flag, text, cfg = info[1], info[2], info[3]
        local t = makeToggleProxy(flag, false)

        VisMurderer:AddLabel(text):AddToggle({
            Default = false,
            Flag = flag,
            Callback = function(v)
                t.Value = v
                Hub.Config[cfg] = v

                if v then
                    Hub.Config.ESPEnabled = true
                end
            end,
        })
    end
end
do
    local o = makeOptionProxy('ESPColorSheriff', Color3.fromRGB(0, 0, 255))

    VisSheriff:AddLabel('Sheriff Color'):AddColorPicker({
        Default = Color3.fromRGB(0, 0, 255),
        Flag = 'ESPColorSheriff',
        Callback = function(c)
            o.Value = c
            Hub.Config.ESPColorSheriff = c
        end,
    })

    for _, info in ipairs({
        {
            'HighlightSheriff',
            'Sheriff Chams',
            'HighlightSheriff',
        },
        {
            'InfoSheriff',
            'Sheriff Name & Info',
            'InfoSheriff',
        },
        {
            'BoxSheriff',
            'Sheriff Box ESP',
            'BoxSheriff',
        },
        {
            'TracersSheriff',
            'Sheriff Tracers',
            'TracersSheriff',
        },
        {
            'SkeletonSheriff',
            'Sheriff Skeleton',
            'SkeletonSheriff',
        },
    })do
        local flag, text, cfg = info[1], info[2], info[3]
        local t = makeToggleProxy(flag, false)

        VisSheriff:AddLabel(text):AddToggle({
            Default = false,
            Flag = flag,
            Callback = function(v)
                t.Value = v
                Hub.Config[cfg] = v

                if v then
                    Hub.Config.ESPEnabled = true
                end
            end,
        })
    end
end
do
    local o = makeOptionProxy('ESPColorInnocent', Color3.fromRGB(0, 255, 0))

    VisInnocent:AddLabel('Innocent Color'):AddColorPicker({
        Default = Color3.fromRGB(0, 255, 0),
        Flag = 'ESPColorInnocent',
        Callback = function(c)
            o.Value = c
            Hub.Config.ESPColorInnocent = c
        end,
    })

    for _, info in ipairs({
        {
            'HighlightInnocent',
            'Innocent Chams',
            'HighlightInnocent',
        },
        {
            'InfoInnocent',
            'Innocent Name & Info',
            'InfoInnocent',
        },
        {
            'BoxInnocent',
            'Innocent Box ESP',
            'BoxInnocent',
        },
        {
            'TracersInnocent',
            'Innocent Tracers',
            'TracersInnocent',
        },
        {
            'SkeletonInnocent',
            'Innocent Skeleton',
            'SkeletonInnocent',
        },
    })do
        local flag, text, cfg = info[1], info[2], info[3]
        local t = makeToggleProxy(flag, false)

        VisInnocent:AddLabel(text):AddToggle({
            Default = false,
            Flag = flag,
            Callback = function(v)
                t.Value = v
                Hub.Config[cfg] = v

                if v then
                    Hub.Config.ESPEnabled = true
                end
            end,
        })
    end
end
do
    local t2 = makeToggleProxy('ESPGunDropped', false)

    VisWorld:AddLabel('Dropped Gun ESP'):AddToggle({
        Default = false,
        Flag = 'ESPGunDropped',
        Callback = function(v)
            t2.Value = v
            Hub.Config.ESPGunDropped = v
        end,
    })

    local t3 = makeToggleProxy('NotifyGunDropped', false)

    VisWorld:AddLabel('Notify on Gun Drop'):AddToggle({
        Default = false,
        Flag = 'NotifyGunDropped',
        Callback = function(v)
            t3.Value = v

            Hub.ToggleGunDropNotification(v)
        end,
    })
end

local OffScreenArrowGb = VisualsTab:AddSection({
    Name = 'OFF-SCREEN ARROWS',
    Position = 'right',
})

do
    local t = makeToggleProxy('OffScreenArrows', false)

    OffScreenArrowGb:AddLabel('Enable Arrows'):AddToggle({
        Default = false,
        Flag = 'OffScreenArrows',
        Callback = function(v)
            t.Value = v

            Hub.ToggleOffScreenArrows(v)
        end,
    })

    local oC = makeOptionProxy('OffScreenArrowColor', Color3.fromRGB(255, 255, 255))

    OffScreenArrowGb:AddLabel('Arrow Color'):AddColorPicker({
        Default = Color3.fromRGB(255, 255, 255),
        Flag = 'OffScreenArrowColor',
        Callback = function(c)
            oC.Value = c
            Hub.Config.OffScreenArrowColor = c
        end,
    })

    local oD = makeOptionProxy('OffScreenArrowDist', 80)

    OffScreenArrowGb:AddLabel('Distance From Center'):AddSlider({
        Default = 80,
        Min = 20,
        Max = 300,
        Rounding = 0,
        Flag = 'OffScreenArrowDist',
        Size = 80,
        Callback = function(v)
            oD.Value = v
            Hub.Config.OffScreenArrowDist = v
        end,
    })

    local oH = makeOptionProxy('OffScreenArrowHeight', 16)

    OffScreenArrowGb:AddLabel('Triangle Height'):AddSlider({
        Default = 16,
        Min = 4,
        Max = 64,
        Rounding = 0,
        Flag = 'OffScreenArrowHeight',
        Size = 80,
        Callback = function(v)
            oH.Value = v
            Hub.Config.OffScreenArrowHeight = v
        end,
    })

    local oW = makeOptionProxy('OffScreenArrowWidth', 16)

    OffScreenArrowGb:AddLabel('Triangle Width'):AddSlider({
        Default = 16,
        Min = 4,
        Max = 64,
        Rounding = 0,
        Flag = 'OffScreenArrowWidth',
        Size = 80,
        Callback = function(v)
            oW.Value = v
            Hub.Config.OffScreenArrowWidth = v
        end,
    })

    local oTh = makeOptionProxy('OffScreenArrowThickness', 1)

    OffScreenArrowGb:AddLabel('Thickness'):AddSlider({
        Default = 1,
        Min = 1,
        Max = 5,
        Rounding = 0,
        Flag = 'OffScreenArrowThickness',
        Size = 80,
        Callback = function(v)
            oTh.Value = v
            Hub.Config.OffScreenArrowThickness = v
        end,
    })

    local oTr = makeOptionProxy('OffScreenArrowTransparency', 0)

    OffScreenArrowGb:AddLabel('Transparency'):AddSlider({
        Default = 0,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Flag = 'OffScreenArrowTransparency',
        Size = 80,
        Callback = function(v)
            oTr.Value = v
            Hub.Config.OffScreenArrowTransparency = v
        end,
    })

    local tF = makeToggleProxy('OffScreenArrowFilled', true)

    OffScreenArrowGb:AddLabel('Filled'):AddToggle({
        Default = true,
        Flag = 'OffScreenArrowFilled',
        Callback = function(v)
            tF.Value = v
            Hub.Config.OffScreenArrowFilled = v
        end,
    })

    local tA = makeToggleProxy('OffScreenArrowAntiAlias', false)

    OffScreenArrowGb:AddLabel('Anti-Aliasing'):AddToggle({
        Default = false,
        Flag = 'OffScreenArrowAntiAlias',
        Callback = function(v)
            tA.Value = v
            Hub.Config.OffScreenArrowAntiAlias = v
        end,
    })
end

local HatGroupBox = VisualsTab:AddSection({
    Name = 'CHINA HAT',
    Position = 'left',
})

do
    local t = makeToggleProxy('HatToggle', false)

    HatGroupBox:AddLabel('Enable Hat'):AddToggle({
        Default = false,
        Flag = 'HatToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.Hat_ToggleEnabled then
                VisualFns.Hat_ToggleEnabled(v)
            end
        end,
    })

    local o = makeOptionProxy('HatStyle', 'Classic')

    HatGroupBox:AddLabel('Hat Style'):AddDropdown({
        Default = 'Classic',
        Values = {
            'Classic',
            'Drawing',
        },
        Flag = 'HatStyle',
        Callback = function(v)
            o.Value = v

            if VisualFns.Hat_ChangeStyle then
                VisualFns.Hat_ChangeStyle(v)
            end
        end,
    })

    local tR = makeToggleProxy('HatRainbow', false)

    HatGroupBox:AddLabel('Rainbow Mode'):AddToggle({
        Default = false,
        Flag = 'HatRainbow',
        Callback = function(v)
            tR.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.rainbow = v
            end
        end,
    })

    local oS = makeOptionProxy('HatRainbowSpeed', 5)

    HatGroupBox:AddLabel('Rainbow Speed'):AddSlider({
        Default = 5,
        Min = 1,
        Max = 20,
        Rounding = 0,
        Flag = 'HatRainbowSpeed',
        Size = 80,
        Callback = function(v)
            oS.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.rainbowSpeed = v
            end
        end,
    })

    local oT = makeOptionProxy('HatTransparency', 0.3)

    HatGroupBox:AddLabel('Transparency'):AddSlider({
        Default = 0.3,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Flag = 'HatTransparency',
        Size = 80,
        Callback = function(v)
            oT.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.transparency = v
            end
        end,
    })

    local oR = makeOptionProxy('HatRadius', 2.4)

    HatGroupBox:AddLabel('Radius'):AddSlider({
        Default = 2.4,
        Min = 0.5,
        Max = 10,
        Rounding = 1,
        Flag = 'HatRadius',
        Size = 80,
        Callback = function(v)
            oR.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.radius = v
            end
        end,
    })

    local oH = makeOptionProxy('HatHeight', 1.6)

    HatGroupBox:AddLabel('Height'):AddSlider({
        Default = 1.6,
        Min = 0.5,
        Max = 5,
        Rounding = 1,
        Flag = 'HatHeight',
        Size = 80,
        Callback = function(v)
            oH.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.height = v
            end
        end,
    })

    local oRef = makeOptionProxy('HatReflectance', 0)

    HatGroupBox:AddLabel('Reflectance (Classic)'):AddSlider({
        Default = 0,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Flag = 'HatReflectance',
        Size = 80,
        Callback = function(v)
            oRef.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.reflectance = v
            end
        end,
    })

    local oSides = makeOptionProxy('HatSides', 25)

    HatGroupBox:AddLabel('Sides (Drawing)'):AddSlider({
        Default = 25,
        Min = 3,
        Max = 300,
        Rounding = 0,
        Flag = 'HatSides',
        Size = 80,
        Callback = function(v)
            oSides.Value = v

            if VisualFns.Hat_UpdateSides then
                VisualFns.Hat_UpdateSides(v)
            end
        end,
    })

    local oC = makeOptionProxy('HatColor', Color3.fromRGB(0, 255, 255))

    HatGroupBox:AddLabel('Hat Color'):AddColorPicker({
        Default = Color3.fromRGB(0, 255, 255),
        Flag = 'HatColor',
        Callback = function(v)
            oC.Value = v

            if VisualFns.HatVariables then
                VisualFns.HatVariables.color = v
            end
        end,
    })
end

local TrailGroupBox = VisualsTab:AddSection({
    Name = 'TRAIL',
    Position = 'left',
})

do
    local t = makeToggleProxy('TrailToggle', false)

    TrailGroupBox:AddLabel('Enable Trail'):AddToggle({
        Default = false,
        Flag = 'TrailToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.Trail_ToggleEnabled then
                VisualFns.Trail_ToggleEnabled(v)
            end
        end,
    })

    local tG = makeToggleProxy('TrailGradient', false)

    TrailGroupBox:AddLabel('Gradient Mode'):AddToggle({
        Default = false,
        Flag = 'TrailGradient',
        Callback = function(v)
            tG.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.isGradient = v

                if VisualFns.TrailVariables.enabled and LocalPlayer.Character and VisualFns.Trail_AddToCharacter then
                    VisualFns.Trail_AddToCharacter(LocalPlayer.Character)
                end
            end
        end,
    })

    local oL = makeOptionProxy('TrailLifetime', 0.5)

    TrailGroupBox:AddLabel('Lifetime'):AddSlider({
        Default = 0.5,
        Min = 0.1,
        Max = 3,
        Rounding = 1,
        Flag = 'TrailLifetime',
        Size = 80,
        Callback = function(v)
            oL.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.lifetime = v
            end
            if VisualFns.Trail_UpdateAll then
                VisualFns.Trail_UpdateAll()
            end
        end,
    })

    local oTr = makeOptionProxy('TrailTransparency', 0)

    TrailGroupBox:AddLabel('Start Transparency'):AddSlider({
        Default = 0,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Flag = 'TrailTransparency',
        Size = 80,
        Callback = function(v)
            oTr.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.transparencyStart = v
            end
            if VisualFns.Trail_UpdateAll then
                VisualFns.Trail_UpdateAll()
            end
        end,
    })

    local tR = makeToggleProxy('TrailRainbow', false)

    TrailGroupBox:AddLabel('Rainbow (Static)'):AddToggle({
        Default = false,
        Flag = 'TrailRainbow',
        Callback = function(v)
            tR.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.rainbow = v
            end
            if VisualFns.Trail_UpdateAll then
                VisualFns.Trail_UpdateAll()
            end
        end,
    })

    local oC = makeOptionProxy('TrailColor', Color3.fromRGB(0, 255, 255))

    TrailGroupBox:AddLabel('Static Color'):AddColorPicker({
        Default = Color3.fromRGB(0, 255, 255),
        Flag = 'TrailColor',
        Callback = function(v)
            oC.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.colorStatic = v
            end
            if VisualFns.Trail_UpdateAll then
                VisualFns.Trail_UpdateAll()
            end
        end,
    })

    local oG1 = makeOptionProxy('TrailGradient1', Color3.fromRGB(0, 86, 255))

    TrailGroupBox:AddLabel('Gradient 1'):AddColorPicker({
        Default = Color3.fromRGB(0, 86, 255),
        Flag = 'TrailGradient1',
        Callback = function(v)
            oG1.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.gradient1 = v
            end
            if VisualFns.Trail_UpdateAll then
                VisualFns.Trail_UpdateAll()
            end
        end,
    })

    local oG2 = makeOptionProxy('TrailGradient2', Color3.fromRGB(255, 0, 0))

    TrailGroupBox:AddLabel('Gradient 2'):AddColorPicker({
        Default = Color3.fromRGB(255, 0, 0),
        Flag = 'TrailGradient2',
        Callback = function(v)
            oG2.Value = v

            if VisualFns.TrailVariables then
                VisualFns.TrailVariables.gradient2 = v
            end
            if VisualFns.Trail_UpdateAll then
                VisualFns.Trail_UpdateAll()
            end
        end,
    })
end

local AuraTrailerGroupBox = VisualsTab:AddSection({
    Name = 'AURA TRAILER',
    Position = 'right',
})

do
    local t = makeToggleProxy('AuraTrailerToggle', false)

    AuraTrailerGroupBox:AddLabel('Enable Aura Trailer'):AddToggle({
        Default = false,
        Flag = 'AuraTrailerToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.AuraTrailerVariables then
                VisualFns.AuraTrailerVariables.enabled = v
            end
            if VisualFns.AuraTrailer_Toggle then
                VisualFns.AuraTrailer_Toggle(v)
            end
        end,
    })

    local oC = makeOptionProxy('AuraTrailerColor', Color3.fromRGB(255, 0, 0))

    AuraTrailerGroupBox:AddLabel('Color'):AddColorPicker({
        Default = Color3.fromRGB(255, 0, 0),
        Flag = 'AuraTrailerColor',
        Callback = function(v)
            oC.Value = v

            if VisualFns.AuraTrailerVariables then
                VisualFns.AuraTrailerVariables.color = v
            end
            if VisualFns.AuraTrailerVariables and VisualFns.AuraTrailerVariables.enabled and VisualFns.AuraTrailer_Update then
                VisualFns.AuraTrailer_Update()
            end
        end,
    })

    local oL = makeOptionProxy('AuraTrailerLife', 0.5)

    AuraTrailerGroupBox:AddLabel('Lifetime'):AddSlider({
        Default = 0.5,
        Min = 0.1,
        Max = 3,
        Rounding = 1,
        Flag = 'AuraTrailerLife',
        Size = 80,
        Callback = function(v)
            oL.Value = v

            if VisualFns.AuraTrailerVariables then
                VisualFns.AuraTrailerVariables.lifetime = v
            end
            if VisualFns.AuraTrailerVariables and VisualFns.AuraTrailerVariables.enabled and VisualFns.AuraTrailer_Update then
                VisualFns.AuraTrailer_Update()
            end
        end,
    })
end

local ClassicAuraGb = VisualsTab:AddSection({
    Name = 'CLASSIC AURA',
    Position = 'right',
})

do
    local t = makeToggleProxy('ClassicAuraEnabled', false)

    ClassicAuraGb:AddLabel('Enable Classic Aura'):AddToggle({
        Default = false,
        Flag = 'ClassicAuraEnabled',
        Callback = function(v)
            t.Value = v

            if VisualFns.ClassicAura_RefreshAll then
                VisualFns.ClassicAura_RefreshAll()
            end
        end,
    })

    local o = makeOptionProxy('ClassicAuraDropdown', {})

    ClassicAuraGb:AddLabel('Select Auras'):AddDropdown({
        Default = {},
        Values = VisualFns.AuraModels or {},
        Multi = true,
        Flag = 'ClassicAuraDropdown',
        Callback = function(v)
            o.Value = v

            if VisualFns.ClassicAura_RefreshAll then
                VisualFns.ClassicAura_RefreshAll()
            end
        end,
    })
end

local ParticleAuraGb = VisualsTab:AddSection({
    Name = 'PARTICLE AURA',
    Position = 'left',
})

do
    local t = makeToggleProxy('ParticleAuraEnabled', false)

    ParticleAuraGb:AddLabel('Enable Particle Aura'):AddToggle({
        Default = false,
        Flag = 'ParticleAuraEnabled',
        Callback = function(v)
            t.Value = v

            if VisualFns.ParticleAura_RefreshAll then
                VisualFns.ParticleAura_RefreshAll()
            end
        end,
    })

    local oC = makeOptionProxy('ParticleAuraColor', Color3.fromRGB(133, 220, 255))

    ParticleAuraGb:AddLabel('Aura Color'):AddColorPicker({
        Default = Color3.fromRGB(133, 220, 255),
        Flag = 'ParticleAuraColor',
        Callback = function(v)
            oC.Value = v

            if VisualFns.ParticleAura_RefreshAll then
                VisualFns.ParticleAura_RefreshAll()
            end
        end,
    })

    local o = makeOptionProxy('ParticleAuraDropdown', {})

    ParticleAuraGb:AddLabel('Select Auras'):AddDropdown({
        Default = {},
        Values = VisualFns.PARTICLE_AURA_NAMES or {},
        Multi = true,
        Flag = 'ParticleAuraDropdown',
        Callback = function(v)
            o.Value = v

            if VisualFns.ParticleAura_RefreshAll then
                VisualFns.ParticleAura_RefreshAll()
            end
        end,
    })
end

local ScreenGroupBox = VisualsTab:AddSection({
    Name = 'SCREEN EFFECT',
    Position = 'left',
})

do
    local t = makeToggleProxy('ScreenToggle', false)

    ScreenGroupBox:AddLabel('Enable Screen Effect'):AddToggle({
        Default = false,
        Flag = 'ScreenToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.Screen_Toggle then
                VisualFns.Screen_Toggle(v)
            end
        end,
    })

    local o = makeOptionProxy('ScreenIntensity', 0)

    ScreenGroupBox:AddLabel('Screen Stretch'):AddSlider({
        Default = 0,
        Min = 0,
        Max = 0.2,
        Rounding = 3,
        Flag = 'ScreenIntensity',
        Size = 80,
        Callback = function(v)
            o.Value = v

            if VisualFns.WorldVariables then
                VisualFns.WorldVariables.screenIntensity = v
            end
        end,
    })
end

local AnimeGroupBox = VisualsTab:AddSection({
    Name = 'UTILITIES',
    Position = 'left',
})

do
    local t = makeToggleProxy('AnimeImageToggle', false)

    AnimeGroupBox:AddLabel('Anime Image'):AddToggle({
        Default = false,
        Flag = 'AnimeImageToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.Anime_Toggle then
                VisualFns.Anime_Toggle(v)
            end
        end,
    })
    AnimeGroupBox:AddButton({
        Name = 'FPS/Ping Counter 1',
        Icon = 'chart-line',
        Callback = function()
            if VisualFns.FPSVariables and not VisualFns.FPSVariables.fpsPing1Enabled then
                pcall(function()
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/GLAMOHGA/fling/refs/heads/main/\u{445}\u{437}%20\u{43a}\u{430}\u{43a}%20\u{43d}\u{430}\u{437}\u{432}\u{430}\u{442}\u{44c}%20\u{442}\u{438}\u{43f}\u{43e}%20\u{444}\u{43f}\u{441}%20\u{438}%20\u{43f}\u{438}\u{43d}\u{433}.md'))()
                end)

                VisualFns.FPSVariables.fpsPing1Enabled = true
            end
        end,
    })
    AnimeGroupBox:AddButton({
        Name = 'FPS/Ping Counter 2',
        Icon = 'chart-four-vertical-bars',
        Callback = function()
            if VisualFns.FPSVariables and not VisualFns.FPSVariables.fpsPing2Enabled then
                pcall(function()
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/VetrexTheBest/Fps-ping/refs/heads/main/fps%2Bping.txt'))()
                end)

                VisualFns.FPSVariables.fpsPing2Enabled = true
            end
        end,
    })
end

local HitsoundGb = VisualsTab:AddSection({
    Name = 'HITSOUNDS',
    Position = 'right',
})

do
    local HD = getgenv().HitsoundData

    if HD then
        local gunshotNames = {}

        for name in pairs(HD.gunshotSounds)do
            table.insert(gunshotNames, name)
        end

        table.sort(gunshotNames)

        local knifeNames = {}

        for name in pairs(HD.knifeKillSounds)do
            table.insert(knifeNames, name)
        end

        table.sort(knifeNames)

        local t = makeToggleProxy('HitsoundEnabled', false)

        HitsoundGb:AddLabel('Enable Hitsounds'):AddToggle({
            Default = false,
            Flag = 'HitsoundEnabled',
            Callback = function(v)
                t.Value = v
                HD.enabled = v
            end,
        })

        local oG = makeOptionProxy('HitsoundGunshot', HD.selectedGunshot)

        HitsoundGb:AddLabel('Gunshot Sound'):AddDropdown({
            Default = HD.selectedGunshot,
            Values = gunshotNames,
            Flag = 'HitsoundGunshot',
            Callback = function(v)
                oG.Value = v
                HD.selectedGunshot = v
            end,
        })

        local oK = makeOptionProxy('HitsoundKnifeKill', HD.selectedKnifeKill)

        HitsoundGb:AddLabel('Knife Kill Sound'):AddDropdown({
            Default = HD.selectedKnifeKill,
            Values = knifeNames,
            Flag = 'HitsoundKnifeKill',
            Callback = function(v)
                oK.Value = v
                HD.selectedKnifeKill = v
            end,
        })
        HitsoundGb:AddButton({
            Name = 'Preview Gunshot',
            Icon = 'audio-wave-dotted-line',
            Callback = function()
                local id = HD.gunshotSounds[HD.selectedGunshot]

                if not id then
                    return
                end

                local s = Instance.new('Sound')

                s.SoundId = id
                s.Volume = 1
                s.Parent = SoundService

                s:Play()
                s.Ended:Connect(function()
                    s:Destroy()
                end)
                task.delay(5, function()
                    if s and s.Parent then
                        s:Destroy()
                    end
                end)
            end,
        })
        HitsoundGb:AddButton({
            Name = 'Preview Knife Kill',
            Icon = 'frame-bubble-soundwave',
            Callback = function()
                local id = HD.knifeKillSounds[HD.selectedKnifeKill]

                if not id then
                    return
                end

                local s = Instance.new('Sound')

                s.SoundId = id
                s.Volume = 1
                s.Parent = SoundService

                s:Play()
                s.Ended:Connect(function()
                    s:Destroy()
                end)
                task.delay(5, function()
                    if s and s.Parent then
                        s:Destroy()
                    end
                end)
            end,
        })
    end
end

local SkyboxGroupBox = WorldTab:AddSection({
    Name = 'SKYBOX',
    Position = 'left',
})

do
    local skyboxList = {}

    if VisualFns.SkyboxAssets then
        for k in pairs(VisualFns.SkyboxAssets)do
            table.insert(skyboxList, k)
        end

        table.sort(skyboxList)
    end

    local o = makeOptionProxy('SkyboxDropdown', 'HD')

    SkyboxGroupBox:AddLabel('Select Skybox'):AddDropdown({
        Default = 'HD',
        Values = skyboxList,
        Flag = 'SkyboxDropdown',
        Callback = function(v)
            o.Value = v

            if VisualFns.SkyboxVariables then
                VisualFns.SkyboxVariables.current = v
            end
            if VisualFns.SkyboxVariables and not VisualFns.SkyboxVariables.customEnabled then
                VisualFns.SkyboxVariables.customEnabled = true

                if Toggles.SkyboxToggle then
                    Toggles.SkyboxToggle:SetValue(true)
                end
            end
            if VisualFns.Skybox_Apply then
                VisualFns.Skybox_Apply(v)
            end
        end,
    })

    local t = makeToggleProxy('SkyboxToggle', false)

    SkyboxGroupBox:AddLabel('Enable Skybox'):AddToggle({
        Default = false,
        Flag = 'SkyboxToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.SkyboxVariables then
                VisualFns.SkyboxVariables.customEnabled = v
            end
            if v then
                if VisualFns.Skybox_Apply and VisualFns.SkyboxVariables then
                    VisualFns.Skybox_Apply(VisualFns.SkyboxVariables.current)
                end
            else
                if VisualFns.Skybox_RestoreDefault then
                    VisualFns.Skybox_RestoreDefault()
                end
            end
        end,
    })
end

local LightingGroupBox = WorldTab:AddSection({
    Name = 'LIGHTING',
    Position = 'left',
})

do
    local t = makeToggleProxy('TimeToggle', false)

    LightingGroupBox:AddLabel('Enable Time Changer'):AddToggle({
        Default = false,
        Flag = 'TimeToggle',
        Callback = function(v)
            t.Value = v

            if VisualFns.WorldVariables then
                VisualFns.WorldVariables.timeEnabled = v
            end
        end,
    })

    local o = makeOptionProxy('TimeSlider', 12)

    LightingGroupBox:AddLabel('Time (0-24 hours)'):AddSlider({
        Default = 12,
        Min = 0,
        Max = 24,
        Rounding = 1,
        Flag = 'TimeSlider',
        Size = 80,
        Callback = function(v)
            o.Value = v

            if VisualFns.WorldVariables then
                VisualFns.WorldVariables.timeValue = v
            end
        end,
    })

    local t2 = makeToggleProxy('FullBright', false)

    LightingGroupBox:AddLabel('Full Bright'):AddToggle({
        Default = false,
        Flag = 'FullBright',
        Callback = function(v)
            t2.Value = v

            if VisualFns.WorldVariables then
                VisualFns.WorldVariables.fullBrightEnabled = v
            end
            if not v then
                local Lighting = game:GetService('Lighting')

                pcall(function()
                    Lighting.Brightness = 1
                    Lighting.GlobalShadows = true
                    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                end)
            end
        end,
    })
end

local WorldAtmGb = WorldTab:AddSection({
    Name = 'ATMOSPHERE',
    Position = 'right',
})

do
    local t = makeToggleProxy('WorldAtmEnabled', false)

    WorldAtmGb:AddLabel('Atmosphere'):AddToggle({
        Default = false,
        Flag = 'WorldAtmEnabled',
        Callback = function(v)
            t.Value = v

            if v then
                if VisualFns.applyAtmosphere then
                    VisualFns.applyAtmosphere()
                end
            else
                if VisualFns.clearAtmosphere then
                    VisualFns.clearAtmosphere()
                end
            end
        end,
    })

    local oC = makeOptionProxy('WorldAtmColor', Color3.fromRGB(199, 212, 255))

    WorldAtmGb:AddLabel('Atmosphere Color'):AddColorPicker({
        Default = Color3.fromRGB(199, 212, 255),
        Flag = 'WorldAtmColor',
        Callback = function(v)
            oC.Value = v

            if Toggles.WorldAtmEnabled and Toggles.WorldAtmEnabled.Value and VisualFns.applyAtmosphere then
                VisualFns.applyAtmosphere()
            end
        end,
    })

    local oD = makeOptionProxy('WorldAtmDecay', Color3.fromRGB(106, 112, 125))

    WorldAtmGb:AddLabel('Atmosphere Decay'):AddColorPicker({
        Default = Color3.fromRGB(106, 112, 125),
        Flag = 'WorldAtmDecay',
        Callback = function(v)
            oD.Value = v

            if Toggles.WorldAtmEnabled and Toggles.WorldAtmEnabled.Value and VisualFns.applyAtmosphere then
                VisualFns.applyAtmosphere()
            end
        end,
    })

    for _, s in ipairs({
        {
            'WorldAtmHaze',
            'Haze',
            1,
            0,
            10,
            1,
        },
        {
            'WorldAtmGlare',
            'Glare',
            10,
            0,
            10,
            1,
        },
        {
            'WorldAtmOffset',
            'Offset',
            0,
            0,
            1,
            2,
        },
        {
            'WorldAtmDensity',
            'Density',
            0.35,
            0,
            1,
            2,
        },
    })do
        local flag, text, def, min, max, rnd = s[1], s[2], s[3], s[4], s[5], s[6]
        local o = makeOptionProxy(flag, def)

        WorldAtmGb:AddLabel(text):AddSlider({
            Default = def,
            Min = min,
            Max = max,
            Rounding = rnd,
            Flag = flag,
            Size = 80,
            Callback = function(v)
                o.Value = v

                if Toggles.WorldAtmEnabled and Toggles.WorldAtmEnabled.Value and VisualFns.applyAtmosphere then
                    VisualFns.applyAtmosphere()
                end
            end,
        })
    end
end

local TextureGb = WorldTab:AddSection({
    Name = 'TEXTURE PACK',
    Position = 'right',
})

do
    local t = makeToggleProxy('WorldTexturesEnabled', false)

    TextureGb:AddLabel('Minecraft Textures'):AddToggle({
        Default = false,
        Flag = 'WorldTexturesEnabled',
        Callback = function(v)
            t.Value = v

            if v then
                if VisualFns.applyTexturePack then
                    VisualFns.applyTexturePack()
                end
            else
                if VisualFns.clearTexturePack then
                    VisualFns.clearTexturePack()
                end
            end
        end,
    })
end

local NebulaGroupBox = WorldTab:AddSection({
    Name = 'NEBULA THEME',
    Position = 'right',
})

do
    local t = makeToggleProxy('Nebula', false)

    NebulaGroupBox:AddLabel('Enable Nebula'):AddToggle({
        Default = false,
        Flag = 'Nebula',
        Callback = function(v)
            t.Value = v

            if VisualFns.NebulaVariables then
                VisualFns.NebulaVariables.enabled = v
            end
            if v then
                if VisualFns.Nebula_Enable then
                    VisualFns.Nebula_Enable()
                end
            else
                if VisualFns.Nebula_Disable then
                    VisualFns.Nebula_Disable()
                end
            end
        end,
    })

    local o = makeOptionProxy('NebulaColor', Color3.fromRGB(173, 216, 230))

    NebulaGroupBox:AddLabel('Theme Color'):AddColorPicker({
        Default = Color3.fromRGB(173, 216, 230),
        Flag = 'NebulaColor',
        Callback = function(v)
            o.Value = v

            if VisualFns.NebulaVariables then
                VisualFns.NebulaVariables.themeColor = v
            end
            if VisualFns.Nebula_UpdateColor then
                VisualFns.Nebula_UpdateColor()
            end
        end,
    })
end
do
    local function _Reset_ApplyConfigDefaults()
        local defaults = {
            Invisible = false,
            Noclip = false,
            EnableWalkSpeed = false,
            WalkSpeed = 16,
            EnableJumpPower = false,
            JumpPower = 50,
            FlyEnabled = false,
            FlySpeed = 100,
            InfiniteJump = false,
            AntiFling = false,
            SpeedGlitch = false,
            SpeedGlitchSpeed = 50,
            AutoGrabGun = false,
            AutoShootMurderer = false,
            WallBangEnabled = false,
            AutoWallBangEnabled = false,
            KillAllMode = 'Default',
            KnifeAuraMode = 'Default',
            AutoKillAll = false,
            KnifeAura = false,
            KnifeAuraRange = 20,
            SilentThrow = false,
            KnifeThrowAura = 1000,
            AutoFarmCoins = false,
            AutoFarmSpeed = 25,
            AutoFarmOffset = -5,
            AutoFarmRadius = 3000,
            AutoFarmDelay = 0.1,
            NotifyGunDropped = false,
            HighlightMurderer = false,
            InfoMurderer = false,
            BoxMurderer = false,
            TracersMurderer = false,
            SkeletonMurderer = false,
            HighlightSheriff = false,
            InfoSheriff = false,
            BoxSheriff = false,
            TracersSheriff = false,
            SkeletonSheriff = false,
            HighlightInnocent = false,
            InfoInnocent = false,
            BoxInnocent = false,
            TracersInnocent = false,
            SkeletonInnocent = false,
            ESPGunDropped = false,
            OffScreenArrows = false,
            OffScreenArrowDist = 80,
            OffScreenArrowHeight = 16,
            OffScreenArrowWidth = 16,
            OffScreenArrowFilled = true,
            OffScreenArrowTransparency = 0,
            OffScreenArrowThickness = 1,
            OffScreenArrowAntiAlias = false,
            ESPEnabled = true,
            HealthBarEnabled = false,
            HealthBarSide = 'left',
            BoxThickness = 1,
            BoxFilled = false,
            BoxFillTransparency = 0.7,
            PredictionESPEnabled = false,
            PredictionESPAlways = false,
            PredictionESPSize = 12,
            PredictionESPThickness = 2,
            PredictionESPTransparency = 0,
            PredictionESPKey = 'P',
            ResolverEnabled = true,
            ResolverMode = 'Adaptive',
            ResolverAimPart = 'Head',
            ResolverLatencyScale = 1,
            ResolverExtraMs = 40,
            ResolverSmooth = 0.35,
            ResolverGravity = true,
            ResolverGroundClamp = true,
            ResolverAutoAdapt = true,
        }
        local colors = {
            ESPColorInnocent = Color3.fromRGB(0, 255, 0),
            ESPColorMurderer = Color3.fromRGB(255, 0, 0),
            ESPColorSheriff = Color3.fromRGB(0, 0, 255),
            HealthBarColorHigh = Color3.fromRGB(0, 255, 0),
            HealthBarColorLow = Color3.fromRGB(255, 0, 0),
            BoxColor = Color3.fromRGB(255, 255, 255),
            PredictionESPColor = Color3.fromRGB(255, 80, 80),
            OffScreenArrowColor = Color3.fromRGB(255, 255, 255),
        }
        local variants = {
            Dot = true,
            Circle = true,
            Crosshair = false,
            Tracer = false,
            Box = false,
            Ring = false,
        }

        if not Hub.Config then
            return
        end

        for k, v in pairs(defaults)do
            Hub.Config[k] = v
        end
        for k, v in pairs(colors)do
            Hub.Config[k] = v
        end

        Hub.Config.PredictionESPVariants = variants
    end
    local function _Reset_DisableFeatures()
        local fns = {
            'ToggleInvisible',
            'EnableNoclip',
            'EnableWalkSpeed',
            'EnableJumpPower',
            'ToggleFly',
            'InfiniteJump',
            'ToggleAntiFling',
            'ToggleSpeedGlitch',
            'ToggleAutoGrabGun',
            'ToggleAutoShootMurderer',
            'ToggleWallBang',
            'ToggleAutoKillAll',
            'ToggleKnifeAura',
            'ToggleSilentThrow',
            'ToggleAutoFarm',
            'ToggleGunDropNotification',
            'ToggleAntiAFK',
            'ToggleOffScreenArrows',
        }

        for _, name in ipairs(fns)do
            local fn = Hub[name]

            if type(fn) == 'function' then
                pcall(fn, Hub, false)
                pcall(fn, false)
            end
        end

        local VF = Hub.VisualFns or (rawget(_G, 'VisualFns')) or VisualFns

        if type(VF) == 'table' then
            pcall(function()
                if VF.Hat_ToggleEnabled then
                    VF.Hat_ToggleEnabled(false)
                end
            end)
            pcall(function()
                if VF.Trail_ToggleEnabled then
                    VF.Trail_ToggleEnabled(false)
                end
            end)
            pcall(function()
                if VF.AuraTrailerVariables then
                    VF.AuraTrailerVariables.enabled = false
                end
                if VF.AuraTrailer_Toggle then
                    VF.AuraTrailer_Toggle(false)
                end
            end)
            pcall(function()
                if Toggles and Toggles.ClassicAuraEnabled then
                    Toggles.ClassicAuraEnabled.Value = false
                end
                if VF.ClassicAura_RefreshAll then
                    VF.ClassicAura_RefreshAll()
                end
            end)
            pcall(function()
                if Toggles and Toggles.ParticleAuraEnabled then
                    Toggles.ParticleAuraEnabled.Value = false
                end
                if VF.ParticleAura_RefreshAll then
                    VF.ParticleAura_RefreshAll()
                end
            end)
            pcall(function()
                if VF.Screen_Toggle then
                    VF.Screen_Toggle(false)
                end
            end)
            pcall(function()
                if VF.Anime_Toggle then
                    VF.Anime_Toggle(false)
                end
            end)
            pcall(function()
                if VF.SkyboxVariables then
                    VF.SkyboxVariables.customEnabled = false
                end
                if VF.Skybox_RestoreDefault then
                    VF.Skybox_RestoreDefault()
                end
            end)
            pcall(function()
                if VF.WorldVariables then
                    VF.WorldVariables.timeEnabled = false
                    VF.WorldVariables.fullBrightEnabled = false
                end
            end)
            pcall(function()
                if Toggles and Toggles.WorldAtmEnabled then
                    Toggles.WorldAtmEnabled.Value = false
                end
                if VF.clearAtmosphere then
                    VF.clearAtmosphere()
                end
            end)
            pcall(function()
                if VF.clearTexturePack then
                    VF.clearTexturePack()
                end
            end)
            pcall(function()
                if VF.NebulaVariables then
                    VF.NebulaVariables.enabled = false
                end
                if VF.Nebula_Disable then
                    VF.Nebula_Disable()
                end
            end)
        end
        if getgenv().HitsoundData then
            getgenv().HitsoundData.enabled = false
            getgenv().HitsoundData.selectedGunshot = 'RPGS Candy'
            getgenv().HitsoundData.selectedKnifeKill = 'Golden Knife Kill'
        end
        if getgenv().ClearESP then
            pcall(getgenv().ClearESP)
        end
    end
    local function _Reset_ApplyToggleDefaults()
        local toggleDefaults = {
            AntiFlingToggle = false,
            AntiAFKToggle = false,
            SpeedGlitchToggle = false,
            AutoGrabGunToggle = false,
            AutoKillAllToggle = false,
            KnifeAuraToggle = false,
            SilentThrowToggle = false,
            AutoShootMurdererToggle = false,
            AutoWallBangToggle = false,
            HighlightMurderer = false,
            InfoMurderer = false,
            BoxMurderer = false,
            TracersMurderer = false,
            SkeletonMurderer = false,
            HighlightSheriff = false,
            InfoSheriff = false,
            BoxSheriff = false,
            TracersSheriff = false,
            SkeletonSheriff = false,
            HighlightInnocent = false,
            InfoInnocent = false,
            BoxInnocent = false,
            TracersInnocent = false,
            SkeletonInnocent = false,
            ESPGunDropped = false,
            NotifyGunDropped = false,
            OffScreenArrows = false,
            OffScreenArrowFilled = true,
            OffScreenArrowAntiAlias = false,
            HatToggle = false,
            HatRainbow = false,
            TrailToggle = false,
            TrailGradient = false,
            TrailRainbow = false,
            AuraTrailerToggle = false,
            ClassicAuraEnabled = false,
            ParticleAuraEnabled = false,
            ScreenToggle = false,
            AnimeImageToggle = false,
            HitsoundEnabled = false,
            SkyboxToggle = false,
            TimeToggle = false,
            FullBright = false,
            WorldAtmEnabled = false,
            WorldTexturesEnabled = false,
            Nebula = false,
            PredictionESPEnabled = false,
            PredictionESPAlways = false,
        }

        if not Toggles then
            return
        end

        for flag, val in pairs(toggleDefaults)do
            local t = Toggles[flag]

            if t then
                t.Value = val

                pcall(function()
                    if t.SetValue then
                        t:SetValue(val)
                    end
                end)
            end
        end
    end
    local function _Reset_ApplyOptionDefaults()
        local optionDefaults = {
            KillAllMode = 'Default',
            KnifeAuraMode = 'Default',
            KnifeAuraRange = 20,
            SpeedGlitchSpeed = 50,
            HatStyle = 'Classic',
            HatRainbowSpeed = 5,
            HatTransparency = 0.3,
            HatRadius = 2.4,
            HatHeight = 1.6,
            HatReflectance = 0,
            HatSides = 25,
            TrailLifetime = 0.5,
            TrailTransparency = 0,
            AuraTrailerLife = 0.5,
            ClassicAuraDropdown = {},
            ParticleAuraDropdown = {},
            ScreenIntensity = 0,
            HitsoundGunshot = 'RPGS Candy',
            HitsoundKnifeKill = 'Golden Knife Kill',
            SkyboxDropdown = 'HD',
            TimeSlider = 12,
            WorldAtmHaze = 1,
            WorldAtmGlare = 10,
            WorldAtmOffset = 0,
            WorldAtmDensity = 0.35,
            PredictionESPSize = 12,
            PredictionESPThickness = 2,
            PredictionESPTransparency = 0,
            PredictionESPVariants = {
                Dot = true,
                Circle = true,
            },
            OffScreenArrowDist = 80,
            OffScreenArrowHeight = 16,
            OffScreenArrowWidth = 16,
            OffScreenArrowThickness = 1,
            OffScreenArrowTransparency = 0,
        }
        local colors = {
            ESPColorMurderer = Color3.fromRGB(255, 0, 0),
            ESPColorSheriff = Color3.fromRGB(0, 0, 255),
            ESPColorInnocent = Color3.fromRGB(0, 255, 0),
            HatColor = Color3.fromRGB(0, 255, 255),
            TrailColor = Color3.fromRGB(0, 255, 255),
            TrailGradient1 = Color3.fromRGB(0, 86, 255),
            TrailGradient2 = Color3.fromRGB(255, 0, 0),
            AuraTrailerColor = Color3.fromRGB(255, 0, 0),
            ParticleAuraColor = Color3.fromRGB(133, 220, 255),
            WorldAtmColor = Color3.fromRGB(199, 212, 255),
            WorldAtmDecay = Color3.fromRGB(106, 112, 125),
            NebulaColor = Color3.fromRGB(173, 216, 230),
            PredictionESPColor = Color3.fromRGB(255, 80, 80),
            OffScreenArrowColor = Color3.fromRGB(255, 255, 255),
        }

        if not Options then
            return
        end

        for flag, val in pairs(optionDefaults)do
            local o = Options[flag]

            if o then
                o.Value = val

                pcall(function()
                    if o.SetValue then
                        o:SetValue(val)
                    end
                end)
            end
        end
        for flag, val in pairs(colors)do
            local o = Options[flag]

            if o then
                o.Value = val

                pcall(function()
                    if o.SetValue then
                        o:SetValue(val)
                    end
                end)
            end
        end
    end

    function Hub.ResetAllToDefaults()
        _Reset_ApplyConfigDefaults()
        _Reset_DisableFeatures()
        _Reset_ApplyToggleDefaults()
        _Reset_ApplyOptionDefaults()
        pcall(function()
            Notification.new({
                Title = 'Candy Ware',
                Content = 'All settings reset to defaults',
                Duration = 4,
            })
        end)
    end
end

local MenuGroup = SettingsTab:AddSection({
    Name = 'MENU SETTINGS',
    Position = 'left',
})
local MenuVisualGroup = SettingsTab:AddSection({
    Name = 'MENU VISUAL',
    Position = 'right',
})
local MenuThemeGroup = SettingsTab:AddSection({
    Name = 'MENU THEME',
    Position = 'left',
})
local MenuInfoGroup = SettingsTab:AddSection({
    Name = 'MENU INFO',
    Position = 'left',
})
local MenuActionsGroup = SettingsTab:AddSection({
    Name = 'ACTIONS',
    Position = 'right',
})
local MenuThemes = {
    Default = {
        Accent = Color3.fromRGB(78, 127, 252),
        Main = Color3.fromRGB(8, 8, 13),
        Secondary = Color3.fromRGB(14, 16, 22),
        Text = Color3.fromRGB(230, 232, 240),
        Outline = Color3.fromRGB(40, 44, 55),
    },
    ['Soft Ocean'] = {
        Accent = Color3.fromRGB(72, 160, 200),
        Main = Color3.fromRGB(10, 14, 20),
        Secondary = Color3.fromRGB(16, 22, 30),
        Text = Color3.fromRGB(220, 230, 240),
        Outline = Color3.fromRGB(35, 50, 65),
    },
    ['Midnight Blue'] = {
        Accent = Color3.fromRGB(90, 130, 210),
        Main = Color3.fromRGB(7, 9, 16),
        Secondary = Color3.fromRGB(12, 16, 26),
        Text = Color3.fromRGB(210, 220, 235),
        Outline = Color3.fromRGB(30, 40, 60),
    },
    ['Lavender Mist'] = {
        Accent = Color3.fromRGB(160, 140, 210),
        Main = Color3.fromRGB(12, 10, 18),
        Secondary = Color3.fromRGB(20, 16, 28),
        Text = Color3.fromRGB(230, 225, 240),
        Outline = Color3.fromRGB(50, 42, 70),
    },
    ['Rose Soft'] = {
        Accent = Color3.fromRGB(210, 120, 150),
        Main = Color3.fromRGB(14, 10, 13),
        Secondary = Color3.fromRGB(22, 15, 20),
        Text = Color3.fromRGB(240, 225, 230),
        Outline = Color3.fromRGB(60, 35, 45),
    },
    ['Emerald Calm'] = {
        Accent = Color3.fromRGB(80, 180, 140),
        Main = Color3.fromRGB(8, 14, 12),
        Secondary = Color3.fromRGB(12, 22, 18),
        Text = Color3.fromRGB(220, 240, 230),
        Outline = Color3.fromRGB(30, 55, 45),
    },
    ['Amber Glow'] = {
        Accent = Color3.fromRGB(220, 160, 80),
        Main = Color3.fromRGB(14, 12, 8),
        Secondary = Color3.fromRGB(22, 18, 12),
        Text = Color3.fromRGB(245, 235, 215),
        Outline = Color3.fromRGB(60, 45, 25),
    },
    Sakura = {
        Accent = Color3.fromRGB(230, 140, 170),
        Main = Color3.fromRGB(16, 12, 15),
        Secondary = Color3.fromRGB(24, 18, 22),
        Text = Color3.fromRGB(250, 230, 235),
        Outline = Color3.fromRGB(70, 40, 55),
    },
    Arctic = {
        Accent = Color3.fromRGB(140, 190, 220),
        Main = Color3.fromRGB(8, 12, 16),
        Secondary = Color3.fromRGB(14, 20, 26),
        Text = Color3.fromRGB(230, 240, 250),
        Outline = Color3.fromRGB(40, 55, 70),
    },
    Forest = {
        Accent = Color3.fromRGB(100, 160, 100),
        Main = Color3.fromRGB(9, 13, 10),
        Secondary = Color3.fromRGB(14, 20, 15),
        Text = Color3.fromRGB(225, 235, 225),
        Outline = Color3.fromRGB(35, 50, 35),
    },
    ['Sunset Soft'] = {
        Accent = Color3.fromRGB(230, 130, 100),
        Main = Color3.fromRGB(16, 11, 10),
        Secondary = Color3.fromRGB(24, 16, 14),
        Text = Color3.fromRGB(245, 230, 220),
        Outline = Color3.fromRGB(65, 40, 30),
    },
    Grape = {
        Accent = Color3.fromRGB(150, 110, 200),
        Main = Color3.fromRGB(12, 9, 16),
        Secondary = Color3.fromRGB(20, 14, 26),
        Text = Color3.fromRGB(230, 220, 245),
        Outline = Color3.fromRGB(50, 35, 70),
    },
    ['Mint Fresh'] = {
        Accent = Color3.fromRGB(100, 200, 170),
        Main = Color3.fromRGB(8, 14, 13),
        Secondary = Color3.fromRGB(12, 22, 20),
        Text = Color3.fromRGB(220, 245, 240),
        Outline = Color3.fromRGB(30, 55, 50),
    },
    ['Crimson Soft'] = {
        Accent = Color3.fromRGB(200, 90, 100),
        Main = Color3.fromRGB(14, 9, 10),
        Secondary = Color3.fromRGB(22, 13, 15),
        Text = Color3.fromRGB(245, 225, 225),
        Outline = Color3.fromRGB(60, 30, 35),
    },
    Steel = {
        Accent = Color3.fromRGB(140, 160, 180),
        Main = Color3.fromRGB(10, 11, 13),
        Secondary = Color3.fromRGB(16, 18, 22),
        Text = Color3.fromRGB(225, 230, 235),
        Outline = Color3.fromRGB(40, 45, 55),
    },
    Peach = {
        Accent = Color3.fromRGB(230, 160, 130),
        Main = Color3.fromRGB(16, 12, 10),
        Secondary = Color3.fromRGB(24, 18, 15),
        Text = Color3.fromRGB(250, 235, 225),
        Outline = Color3.fromRGB(65, 45, 35),
    },
    ['Teal Calm'] = {
        Accent = Color3.fromRGB(70, 170, 170),
        Main = Color3.fromRGB(8, 13, 14),
        Secondary = Color3.fromRGB(12, 20, 22),
        Text = Color3.fromRGB(220, 240, 240),
        Outline = Color3.fromRGB(30, 50, 55),
    },
    ['Indigo Dream'] = {
        Accent = Color3.fromRGB(110, 120, 210),
        Main = Color3.fromRGB(9, 10, 18),
        Secondary = Color3.fromRGB(14, 16, 28),
        Text = Color3.fromRGB(220, 225, 245),
        Outline = Color3.fromRGB(35, 40, 70),
    },
    Sand = {
        Accent = Color3.fromRGB(200, 175, 130),
        Main = Color3.fromRGB(15, 13, 10),
        Secondary = Color3.fromRGB(22, 19, 14),
        Text = Color3.fromRGB(245, 240, 225),
        Outline = Color3.fromRGB(55, 48, 35),
    },
    Aurora = {
        Accent = Color3.fromRGB(100, 190, 180),
        Main = Color3.fromRGB(8, 12, 16),
        Secondary = Color3.fromRGB(12, 20, 24),
        Text = Color3.fromRGB(220, 240, 240),
        Outline = Color3.fromRGB(30, 50, 55),
    },
    Chocolate = {
        Accent = Color3.fromRGB(180, 130, 90),
        Main = Color3.fromRGB(14, 11, 9),
        Secondary = Color3.fromRGB(22, 17, 13),
        Text = Color3.fromRGB(240, 230, 215),
        Outline = Color3.fromRGB(55, 40, 30),
    },
    ['Sky Soft'] = {
        Accent = Color3.fromRGB(120, 180, 230),
        Main = Color3.fromRGB(9, 12, 18),
        Secondary = Color3.fromRGB(14, 20, 28),
        Text = Color3.fromRGB(225, 235, 250),
        Outline = Color3.fromRGB(35, 50, 70),
    },
    ['Violet Dream'] = {
        Accent = Color3.fromRGB(170, 120, 220),
        Main = Color3.fromRGB(12, 9, 16),
        Secondary = Color3.fromRGB(20, 14, 26),
        Text = Color3.fromRGB(235, 225, 250),
        Outline = Color3.fromRGB(55, 35, 75),
    },
    Jade = {
        Accent = Color3.fromRGB(90, 180, 140),
        Main = Color3.fromRGB(8, 13, 11),
        Secondary = Color3.fromRGB(12, 20, 17),
        Text = Color3.fromRGB(220, 240, 230),
        Outline = Color3.fromRGB(30, 50, 40),
    },
    Copper = {
        Accent = Color3.fromRGB(200, 130, 90),
        Main = Color3.fromRGB(14, 11, 9),
        Secondary = Color3.fromRGB(22, 16, 12),
        Text = Color3.fromRGB(245, 230, 215),
        Outline = Color3.fromRGB(60, 40, 30),
    },
    Ghost = {
        Accent = Color3.fromRGB(160, 170, 190),
        Main = Color3.fromRGB(10, 11, 14),
        Secondary = Color3.fromRGB(16, 18, 22),
        Text = Color3.fromRGB(230, 235, 245),
        Outline = Color3.fromRGB(40, 45, 55),
    },
    ['Pastel Pink'] = {
        Accent = Color3.fromRGB(220, 150, 180),
        Main = Color3.fromRGB(15, 11, 14),
        Secondary = Color3.fromRGB(24, 17, 22),
        Text = Color3.fromRGB(250, 230, 240),
        Outline = Color3.fromRGB(65, 40, 55),
    },
    ['Deep Purple'] = {
        Accent = Color3.fromRGB(140, 100, 200),
        Main = Color3.fromRGB(10, 8, 16),
        Secondary = Color3.fromRGB(16, 12, 26),
        Text = Color3.fromRGB(230, 220, 245),
        Outline = Color3.fromRGB(45, 30, 70),
    },
    Berry = {
        Accent = Color3.fromRGB(190, 100, 140),
        Main = Color3.fromRGB(14, 9, 12),
        Secondary = Color3.fromRGB(22, 13, 18),
        Text = Color3.fromRGB(245, 225, 235),
        Outline = Color3.fromRGB(60, 30, 45),
    },
    ['Aqua Soft'] = {
        Accent = Color3.fromRGB(80, 190, 200),
        Main = Color3.fromRGB(8, 13, 15),
        Secondary = Color3.fromRGB(12, 20, 24),
        Text = Color3.fromRGB(220, 240, 245),
        Outline = Color3.fromRGB(30, 50, 60),
    },
    Honey = {
        Accent = Color3.fromRGB(220, 175, 80),
        Main = Color3.fromRGB(15, 13, 8),
        Secondary = Color3.fromRGB(23, 19, 12),
        Text = Color3.fromRGB(250, 240, 215),
        Outline = Color3.fromRGB(65, 50, 25),
    },
    Slate = {
        Accent = Color3.fromRGB(120, 140, 160),
        Main = Color3.fromRGB(10, 11, 13),
        Secondary = Color3.fromRGB(16, 18, 22),
        Text = Color3.fromRGB(225, 230, 235),
        Outline = Color3.fromRGB(40, 45, 55),
    },
    ['Coral Soft'] = {
        Accent = Color3.fromRGB(230, 130, 120),
        Main = Color3.fromRGB(16, 11, 11),
        Secondary = Color3.fromRGB(24, 16, 16),
        Text = Color3.fromRGB(250, 230, 225),
        Outline = Color3.fromRGB(65, 40, 35),
    },
    Moss = {
        Accent = Color3.fromRGB(120, 160, 90),
        Main = Color3.fromRGB(10, 13, 9),
        Secondary = Color3.fromRGB(15, 20, 13),
        Text = Color3.fromRGB(230, 240, 220),
        Outline = Color3.fromRGB(40, 50, 30),
    },
    Cloud = {
        Accent = Color3.fromRGB(150, 180, 210),
        Main = Color3.fromRGB(10, 12, 16),
        Secondary = Color3.fromRGB(16, 20, 26),
        Text = Color3.fromRGB(230, 238, 250),
        Outline = Color3.fromRGB(40, 50, 65),
    },
    Wine = {
        Accent = Color3.fromRGB(170, 80, 100),
        Main = Color3.fromRGB(14, 9, 11),
        Secondary = Color3.fromRGB(22, 13, 16),
        Text = Color3.fromRGB(245, 220, 225),
        Outline = Color3.fromRGB(55, 25, 35),
    },
}
local MenuThemeNames = {}

for name in pairs(MenuThemes)do
    table.insert(MenuThemeNames, name)
end

table.sort(MenuThemeNames)

for i, n in ipairs(MenuThemeNames)do
    if n == 'Default' then
        table.remove(MenuThemeNames, i)
        table.insert(MenuThemeNames, 1, 'Default')

        break
    end
end

local CurrentMenuTheme = 'Default'
local MenuThemeEnabled = true
local OriginalAccent = NeverLose.AccentColor
local OriginalMain = NeverLose.MainColor
local LastAppliedAccent = OriginalAccent

local function colorDistance(a, b)
    local dr, dg, db = a.R - b.R, a.G - b.G, a.B - b.B

    return math.sqrt(dr * dr + dg * dg + db * db)
end
local function applyMenuTheme(themeName)
    local theme = MenuThemes[themeName]

    if not theme then
        return
    end

    local oldAccent = LastAppliedAccent or NeverLose.AccentColor
    local newAccent = theme.Accent
    local newMain = theme.Main

    NeverLose.AccentColor = newAccent
    NeverLose.MainColor = newMain
    LastAppliedAccent = newAccent
    CurrentMenuTheme = themeName

    local root = NeverLose.ScreenGui

    if not root then
        return
    end

    pcall(function()
        for _, obj in ipairs(root:GetDescendants())do
            if obj:IsA('GuiObject') then
                if obj:IsA('Frame') or obj:IsA('TextButton') or obj:IsA('ImageButton') then
                    local bg = obj.BackgroundColor3

                    if colorDistance(bg, oldAccent) < 0.12 then
                        obj.BackgroundColor3 = newAccent
                    elseif colorDistance(bg, Color3.fromRGB(8, 8, 13)) < 0.05 or colorDistance(bg, Color3.fromRGB(10, 11, 14)) < 0.05 or colorDistance(bg, Color3.fromRGB(12, 12, 16)) < 0.05 then
                        obj.BackgroundColor3 = newMain
                    end
                end
                if (obj:IsA('TextLabel') or obj:IsA('TextButton')) and obj.TextColor3 then
                    if colorDistance(obj.TextColor3, oldAccent) < 0.12 then
                        obj.TextColor3 = newAccent
                    end
                end
                if obj:IsA('UIStroke') then
                    if colorDistance(obj.Color, oldAccent) < 0.12 then
                        obj.Color = newAccent
                    end
                end
            end
        end
    end)
end
local function disableMenuTheme()
    MenuThemeEnabled = false
    NeverLose.AccentColor = OriginalAccent
    NeverLose.MainColor = OriginalMain
    LastAppliedAccent = OriginalAccent

    applyMenuTheme('Default')

    CurrentMenuTheme = 'Default'
end
local function __VisionHub_SetupMenuPanel()
    local WatermarkObj = nil
    local wmBlockName, wmBlockPing, wmBlockFps = nil, nil, nil
    local wmEnabled = false
    local wmShowName, wmShowPing, wmShowFps = true, true, true
    local menuScaleName = 'Default'

    local function ensureWatermark()
        if WatermarkObj then
            return WatermarkObj
        end

        pcall(function()
            WatermarkObj = Window:Watermark()
        end)

        return WatermarkObj
    end
    local function refreshWatermarkBlocks()
        local wm = ensureWatermark()

        if not wm then
            return
        end

        pcall(function()
            if wm.SetRender then
                wm:SetRender(wmEnabled)
            end
            if wm.Status ~= nil then
                wm.Status = wmEnabled
            end
        end)
    end

    MenuGroup:AddLabel('Menu Keybind'):AddKeybind({
        Default = 'LeftControl',
        Flag = 'MenuKeybind',
        Callback = function(v)
            Window.Keybind = v

            pcall(function()
                Logging.new('ps4-touchpad', 'Menu keybind: ' .. tostring(v), 3)
            end)
        end,
    })
    MenuGroup:AddLabel('Menu Scale'):AddDropdown({
        Default = 'Default',
        Values = {
            'Small',
            'Mobile',
            'Default',
            'Large',
        },
        Flag = 'MenuScale',
        Callback = function(v)
            menuScaleName = v

            if NeverLose.Scales and NeverLose.Scales[v] then
                Window:SetSize(NeverLose.Scales[v])
            end

            pcall(function()
                Logging.new('crop', 'Menu scale: ' .. tostring(v), 3)
            end)
        end,
    })
    MenuGroup:AddLabel('3D Menu'):AddToggle({
        Default = false,
        Flag = 'Menu3D',
        Callback = function(v)
            pcall(function()
                Window:Set3DRender(v)
            end)
        end,
    })

    local tThemeEn = makeToggleProxy('MenuThemeEnabled', true)

    MenuThemeGroup:AddLabel('Enable Themes'):AddToggle({
        Default = true,
        Flag = 'MenuThemeEnabled',
        Callback = function(v)
            tThemeEn.Value = v
            MenuThemeEnabled = v

            if v then
                applyMenuTheme(CurrentMenuTheme or 'Default')
            else
                disableMenuTheme()
            end
        end,
    })

    local oTheme = makeOptionProxy('MenuThemeSelect', 'Default')

    MenuThemeGroup:AddLabel('Select Theme'):AddDropdown({
        Default = 'Default',
        Values = MenuThemeNames,
        Flag = 'MenuThemeSelect',
        Callback = function(v)
            oTheme.Value = v
            CurrentMenuTheme = v

            if MenuThemeEnabled then
                applyMenuTheme(v)
                pcall(function()
                    Notification.new({
                        Title = 'Candy Ware',
                        Content = 'Theme: ' .. tostring(v),
                        Duration = 2.5,
                    })
                end)
            end
        end,
    })

    local oCustomAccent = makeOptionProxy('MenuThemeCustomAccent', Color3.fromRGB(78, 127, 252))

    MenuThemeGroup:AddLabel('Custom Accent'):AddColorPicker({
        Default = Color3.fromRGB(78, 127, 252),
        Flag = 'MenuThemeCustomAccent',
        Callback = function(c)
            oCustomAccent.Value = c

            if MenuThemeEnabled and CurrentMenuTheme == 'Custom' then
                local t = MenuThemes.Custom or {
                    Accent = c,
                    Main = Color3.fromRGB(8, 8, 13),
                    Secondary = Color3.fromRGB(14, 16, 22),
                    Text = Color3.fromRGB(230, 232, 240),
                    Outline = Color3.fromRGB(40, 44, 55),
                }

                t.Accent = c
                MenuThemes.Custom = t

                applyMenuTheme('Custom')
            end
        end,
    })
    MenuThemeGroup:AddButton({
        Name = 'Apply Custom Accent',
        Icon = 'palette',
        Callback = function()
            local c = (Options.MenuThemeCustomAccent and Options.MenuThemeCustomAccent.Value) or Color3.fromRGB(78, 127, 252)

            MenuThemes.Custom = {
                Accent = c,
                Main = Color3.fromRGB(8, 8, 13),
                Secondary = Color3.fromRGB(14, 16, 22),
                Text = Color3.fromRGB(230, 232, 240),
                Outline = Color3.fromRGB(40, 44, 55),
            }

            if not table.find(MenuThemeNames, 'Custom') then
                table.insert(MenuThemeNames, 'Custom')
            end

            CurrentMenuTheme = 'Custom'
            MenuThemeEnabled = true

            if Toggles.MenuThemeEnabled then
                Toggles.MenuThemeEnabled.Value = true
            end

            applyMenuTheme('Custom')
            Notification.new({
                Title = 'Candy Ware',
                Content = 'Custom accent applied',
                Duration = 2.5,
            })
        end,
    })
    MenuThemeGroup:AddButton({
        Name = 'Reset to Default Theme',
        Icon = 'arrow-spin-counter-clockwise',
        Callback = function()
            disableMenuTheme()

            if Options.MenuThemeSelect and Options.MenuThemeSelect.SetValue then
                pcall(function()
                    Options.MenuThemeSelect:SetValue('Default')
                end)
            end
            if Toggles.MenuThemeEnabled then
                Toggles.MenuThemeEnabled.Value = false
            end

            Notification.new({
                Title = 'Candy Ware',
                Content = 'Theme reset to Default',
                Duration = 2.5,
            })
        end,
    })
    MenuThemeGroup:AddLabel('Soft themes \u{2022} low eye strain \u{2022} 35 presets', true)

    local tWm = makeToggleProxy('WatermarkEnabled', false)

    MenuVisualGroup:AddLabel('Watermark'):AddToggle({
        Default = false,
        Flag = 'WatermarkEnabled',
        Callback = function(v)
            tWm.Value = v
            wmEnabled = v

            local wm = ensureWatermark()

            if not wm then
                return
            end
            if v then
                if not wmBlockName then
                    pcall(function()
                        wmBlockName = wm:AddBlock('cube-vertexes', 'Candy Ware')

                        if wmBlockName and wmBlockName.Input then
                            wmBlockName:Input(function()
                                Window:ToggleInterface()
                            end)
                        end
                    end)
                end
                if not wmBlockPing then
                    pcall(function()
                        wmBlockPing = wm:AddBlock('chart-four-vertical-bars', '0MS')
                    end)
                end
                if not wmBlockFps then
                    pcall(function()
                        wmBlockFps = wm:AddBlock('gauge', '0FPS')
                    end)
                end

                pcall(function()
                    if wm.SetRender then
                        wm:SetRender(true)
                    end
                end)
            else
                pcall(function()
                    if wm.SetRender then
                        wm:SetRender(false)
                    end
                end)
            end
        end,
    })
    MenuVisualGroup:AddLabel('Watermark: Name'):AddToggle({
        Default = true,
        Flag = 'WatermarkShowName',
        Callback = function(v)
            wmShowName = v

            if wmBlockName and wmBlockName.SetVisible then
                pcall(function()
                    wmBlockName:SetVisible(v)
                end)
            end
        end,
    })
    MenuVisualGroup:AddLabel('Watermark: Ping'):AddToggle({
        Default = true,
        Flag = 'WatermarkShowPing',
        Callback = function(v)
            wmShowPing = v

            if wmBlockPing and wmBlockPing.SetVisible then
                pcall(function()
                    wmBlockPing:SetVisible(v)
                end)
            end
        end,
    })
    MenuVisualGroup:AddLabel('Watermark: FPS'):AddToggle({
        Default = true,
        Flag = 'WatermarkShowFps',
        Callback = function(v)
            wmShowFps = v

            if wmBlockFps and wmBlockFps.SetVisible then
                pcall(function()
                    wmBlockFps:SetVisible(v)
                end)
            end
        end,
    })
    task.spawn(function()
        local frames = 0
        local last = tick()
        local fps = 0

        RunService.RenderStepped:Connect(function()
            frames = frames + 1

            local now = tick()

            if now - last >= 1 then
                fps = frames
                frames = 0
                last = now
            end
        end)

        while task.wait(0.5) do
            if wmEnabled then
                local ping = 0

                pcall(function()
                    if Stats then
                        local net = Stats:FindFirstChild('Network')
                        local ssi = net and net:FindFirstChild('ServerStatsItem')
                        local dp = ssi and ssi:FindFirstChild('Data Ping')

                        if dp then
                            ping = math.floor(dp:GetValue())
                        end
                    end
                end)

                if wmShowPing and wmBlockPing and wmBlockPing.SetText then
                    pcall(function()
                        wmBlockPing:SetText(tostring(ping) .. 'MS')
                    end)
                end
                if wmShowFps and wmBlockFps and wmBlockFps.SetText then
                    pcall(function()
                        wmBlockFps:SetText(tostring(fps) .. 'FPS')
                    end)
                end
                if wmShowName and wmBlockName and wmBlockName.SetText then
                    pcall(function()
                        wmBlockName:SetText('Candy Ware')
                    end)
                end
            end
        end
    end)

    local displayName = LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or 'Player'
    local expiresText = 'Lifetime'

    local function getAvatarThumb()
        local uid = LocalPlayer and LocalPlayer.UserId

        if not uid then
            return ''
        end

        return string.format('rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150', uid)
    end
    local function applyAccount()
        pcall(function()
            Window:SetAccount({
                Username = displayName,
                Profile = getAvatarThumb(),
                Expires = expiresText,
            })
        end)
    end

    applyAccount()
    task.delay(1, applyAccount)
    task.delay(3, applyAccount)
    MenuInfoGroup:AddLabel('Display Name'):AddTextInput({
        Default = displayName,
        Placeholder = 'Username',
        Flag = 'MenuProfileText',
        Callback = function(v)
            displayName = tostring(v or displayName)

            applyAccount()
        end,
    })
    MenuInfoGroup:AddLabel('Expires Text'):AddTextInput({
        Default = 'Lifetime',
        Placeholder = 'Expires',
        Flag = 'MenuExpiresText',
        Callback = function(v)
            expiresText = tostring(v or 'Lifetime')

            applyAccount()
        end,
    })
    MenuInfoGroup:AddButton({
        Name = 'Refresh Account Info',
        Icon = 'arrow-spin-clockwise',
        Callback = function()
            applyAccount()
            Notification.new({
                Title = 'Candy Ware',
                Content = 'Account info refreshed',
                Duration = 3,
            })
        end,
    })
    MenuInfoGroup:AddButton({
        Name = 'Open User Settings Panel',
        Icon = 'gear',
        Callback = function()
            pcall(function()
                if Window.UserSettings and Window.UserSettings.Signal then
                    Window.UserSettings.Signal:SetValue(true)
                end
            end)
        end,
    })
    MenuActionsGroup:AddButton({
        Name = 'Reset All Settings',
        Icon = 'arrow-spin-counter-clockwise',
        Callback = function()
            Hub.ResetAllToDefaults()
        end,
    })
    MenuActionsGroup:AddButton({
        Name = 'Unload Script',
        Icon = 'circle-x',
        Callback = function()
            if getgenv().VisionHub_Cleanup then
                pcall(getgenv().VisionHub_Cleanup)
            end

            Library:Unload()
        end,
    })
end

__VisionHub_SetupMenuPanel()

do
    local offKeys = {
        'Invisible',
        'Noclip',
        'EnableWalkSpeed',
        'EnableJumpPower',
        'FlyEnabled',
        'InfiniteJump',
        'AntiFling',
        'SpeedGlitch',
        'AutoGrabGun',
        'AutoShootMurderer',
        'WallBangEnabled',
        'AutoWallBangEnabled',
        'AutoKillAll',
        'KnifeAura',
        'SilentThrow',
        'AutoFarmCoins',
        'NotifyGunDropped',
        'HighlightMurderer',
        'InfoMurderer',
        'BoxMurderer',
        'TracersMurderer',
        'SkeletonMurderer',
        'HighlightSheriff',
        'InfoSheriff',
        'BoxSheriff',
        'TracersSheriff',
        'SkeletonSheriff',
        'HighlightInnocent',
        'InfoInnocent',
        'BoxInnocent',
        'TracersInnocent',
        'SkeletonInnocent',
        'ESPGunDropped',
        'HealthBarEnabled',
        'OffScreenArrows',
        'PredictionESPEnabled',
        'PredictionESPAlways',
    }

    for _, k in ipairs(offKeys)do
        Hub.Config[k] = false
    end

    if getgenv().HitsoundData then
        getgenv().HitsoundData.enabled = false
    end

    local menuFlags = {
        WatermarkEnabled = true,
        WatermarkShowName = true,
        WatermarkShowPing = true,
        WatermarkShowFps = true,
        Menu3D = true,
    }

    for flag, t in pairs(Toggles)do
        if type(t) == 'table' and not menuFlags[flag] then
            t.Value = false
        end
    end
    for _, flag in ipairs({
        'KnifeScaleSelect',
        'GunScaleSelect',
        'KnifeScale',
        'GunScale',
    })do
        Options[flag] = nil

        if Hub.Config then
            Hub.Config[flag] = nil
            Hub.Config.KnifeScale = nil
            Hub.Config.GunScale = nil
        end
    end
end

getgenv().Toggles = Toggles
getgenv().Options = Options
_G.Toggles = Toggles
_G.Options = Options

pcall(function()
    local uid = LocalPlayer and LocalPlayer.UserId
    local thumb = uid and string.format('rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150', uid) or ''

    Window:SetAccount({
        Username = LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or 'Player',
        Profile = thumb,
        Expires = 'Lifetime',
    })
end)
