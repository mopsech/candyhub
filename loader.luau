repeat
    task.wait()
until game:IsLoaded()

task.wait(0.5)
print('\u{1f36c} [CANDY ZONE MM2] Initialization started...')

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local CoreGui = game:GetService('CoreGui')
local StarterGui = game:GetService('StarterGui')
local Lighting = game:GetService('Lighting')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local VirtualInputManager = game:GetService('VirtualInputManager')
local SoundService = game:GetService('SoundService')
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Config = {
    Version = '0.2 Full',
    Developer = 'mopsech',
    Discord = 'discord.gg/3KjWyZ6uBu',
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
        },
    },
    Size = {
        TopBar = {
            Height = 32,
            Spacing = 8,
            Radius = 6,
        },
        Window = {
            Width = 615,
            Height = 390,
            Radius = 16,
        },
        Nav = {
            Width = 140,
            ButtonHeight = 38,
            Spacing = 8,
            Radius = 8,
        },
        Element = {
            Height = 32,
            Spacing = 10,
        },
        Toggle = {
            Width = 42,
            Height = 20,
            DotSize = 16,
        },
        Slider = {
            Height = 6,
            HandleSize = 14,
        },
    },
    Anim = {
        Fast = 0.15,
        Normal = 0.25,
        Slow = 0.35,
    },
    Settings = {
        Keybinds = {
            ToggleGUI = Enum.KeyCode.RightShift,
            PanicKey = Enum.KeyCode.End,
            Camlock = Enum.KeyCode.Q,
            SilentAim = Enum.KeyCode.E,
        },
        Colors = {
            ForceField = Color3.fromRGB(0, 255, 255),
            TargetESP = Color3.fromRGB(255, 70, 90),
            AuraTrail = Color3.fromRGB(255, 255, 0),
            MurderESP = Color3.fromRGB(255, 0, 0),
            SheriffESP = Color3.fromRGB(0, 0, 255),
            InnocentESP = Color3.fromRGB(0, 255, 0),
            HeroESP = Color3.fromRGB(255, 250, 0),
            ArrowESP = Color3.fromRGB(255, 255, 255),
        },
        ESP = {
            Murder = false,
            Sheriff = false,
            Innocent = false,
            Hero = false,
            TargetESP = false,
            ArrowESP = false,
        },
        Combat = {
            Camlock = false,
            SilentAim = false,
            AutoShoot = false,
            CamlockFOV = 120,
            CamlockPredict = 100,
            CamlockSmooth = 50,
            SilentFOV = 120,
            SilentPredict = 100,
            VisibleCheck = true,
            AutoKillAll = false,
            AutoFarm = false,
            BombJump = false,
            AntiFling = false,
            AntiVoid = false,
            AutoWallHop = false,
            GrabGun = false,
        },
        Rage = {
            SpinBot = false,
            SpinSpeed = 50,
            Noclip = false,
            Fly = false,
            FlySpeed = 50,
            SpeedGlitch = false,
            SpeedForce = 45,
        },
        Player = {
            ForceField = false,
            TargetESP = false,
            AuraTrail = false,
        },
    },
}

-- ==================== CONFIG SYSTEM ====================
local ConfigFolder = "CandyZone"
local ConfigFile = "Candycfg.json"

local function getConfigPath()
    if isfolder and writefile and readfile then
        return ConfigFolder .. "/" .. ConfigFile
    end
    return nil
end

local function ensureFolder()
    if isfolder and not isfolder(ConfigFolder) then
        pcall(function() makefolder(ConfigFolder) end)
    end
end

local function loadConfig()
    local path = getConfigPath()
    if not path then return nil end
    if not isfile(path) then return nil end
    local success, data = pcall(function()
        return readfile(path)
    end)
    if success and data then
        local success2, parsed = pcall(function()
            return game:GetService("HttpService"):JSONDecode(data)
        end)
        if success2 then
            return parsed
        end
    end
    return nil
end

local function saveConfig(data)
    local path = getConfigPath()
    if not path then return false end
    ensureFolder()
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if success and json then
        pcall(function()
            writefile(path, json)
        end)
        return true
    end
    return false
end

local function migrateConfig(saved, defaults)
    if not saved then return defaults end
    local result = {}
    for key, defaultVal in pairs(defaults) do
        if saved[key] ~= nil then
            if type(defaultVal) == "table" and type(saved[key]) == "table" then
                result[key] = migrateConfig(saved[key], defaultVal)
            else
                result[key] = saved[key]
            end
        else
            result[key] = defaultVal
        end
    end
    for key, val in pairs(saved) do
        if result[key] == nil then
            result[key] = val
        end
    end
    return result
end

local DefaultConfig = {
    ESP = {
        Enabled = false,
        Murderer = true,
        Sheriff = true,
        Hero = true,
        Innocent = true,
        Self = true,
        Colors = {
            Murderer = {255, 40, 40},
            Sheriff = {40, 130, 255},
            Hero = {255, 215, 0},
            Innocent = {0, 220, 0},
        },
    },
    Farm = {
        Enabled = false,
        Mode = "Underground",
        TweenSpeed = 25,
        AutoReset = true,
        AvoidMurder = true,
        UndergroundOffset = 4,
        MaxDistance = 600,
        CoinLimit = 40,
    },
    Combat = {
        Camlock = false,
        SilentAim = false,
        AutoShoot = false,
        CamlockFOV = 120,
        CamlockPredict = 100,
        CamlockSmooth = 50,
        SilentFOV = 120,
        SilentPredict = 100,
        VisibleCheck = true,
        AutoKillAll = false,
        AntiFling = false,
        AntiVoid = false,
        AutoWallHop = false,
        GrabGun = false,
    },
    Rage = {
        SpinBot = false,
        SpinSpeed = 50,
        Noclip = false,
        Fly = false,
        FlySpeed = 50,
        SpeedGlitch = false,
        SpeedForce = 45,
    },
    Player = {
        ForceField = false,
        TargetESP = false,
        AuraTrail = false,
        Hat = {
            Enabled = false,
            Style = "Classic",
            Rainbow = false,
            RainbowSpeed = 5,
            Transparency = 0.3,
            Radius = 2.4,
            Height = 1.6,
            Color = {0, 255, 255},
        },
        Trail = {
            Enabled = false,
            Gradient = false,
            Lifetime = 0.5,
            Rainbow = false,
            Color = {0, 255, 255},
        },
    },
    Visuals = {
        ESP = {
            Murder = false,
            Sheriff = false,
            Innocent = false,
            Hero = false,
            TargetESP = false,
            ArrowESP = false,
        },
        Colors = {
            MurderESP = {255, 0, 0},
            SheriffESP = {0, 0, 255},
            InnocentESP = {0, 255, 0},
            HeroESP = {255, 250, 0},
            TargetESP = {255, 70, 90},
            ArrowESP = {255, 255, 255},
        },
        Skybox = {
            Enabled = false,
            Current = "HD",
        },
        Nebula = {
            Enabled = false,
            Color = {173, 216, 230},
        },
        ScreenStretch = {
            Enabled = false,
            Intensity = 0,
        },
        Anime = false,
        Snow = true,
    },
    Keybinds = {
        ToggleGUI = "RightShift",
        PanicKey = "End",
        Camlock = "Q",
        SilentAim = "E",
    },
    Window = {
        Transparency = 0.1,
    },
}

local function colorToTable(c)
    return {c.R * 255, c.G * 255, c.B * 255}
end

local function tableToColor(t)
    if not t or #t < 3 then return Color3.fromRGB(255, 255, 255) end
    return Color3.fromRGB(t[1], t[2], t[3])
end

local function applySavedConfig(cfg)
    if not cfg then return end
    
    -- ESP
    if cfg.ESP then
        ESP.Enabled = cfg.ESP.Enabled or false
        ESP.Show.Murderer = cfg.ESP.Murderer ~= false
        ESP.Show.Sheriff = cfg.ESP.Sheriff ~= false
        ESP.Show.Hero = cfg.ESP.Hero ~= false
        ESP.Show.Innocent = cfg.ESP.Innocent ~= false
        ESP.Show.Self = cfg.ESP.Self ~= false
        if cfg.ESP.Colors then
            ESP.Colors.Murderer = tableToColor(cfg.ESP.Colors.Murderer)
            ESP.Colors.Sheriff = tableToColor(cfg.ESP.Colors.Sheriff)
            ESP.Colors.Hero = tableToColor(cfg.ESP.Colors.Hero)
            ESP.Colors.Innocent = tableToColor(cfg.ESP.Colors.Innocent)
        end
    end
    
    -- Farm
    if cfg.Farm then
        FarmSettings.Enabled = cfg.Farm.Enabled or false
        FarmSettings.Mode = cfg.Farm.Mode or "Underground"
        FarmSettings.TweenSpeed = cfg.Farm.TweenSpeed or 25
        FarmSettings.AutoReset = cfg.Farm.AutoReset ~= false
        FarmSettings.AvoidMurder = cfg.Farm.AvoidMurder ~= false
        FarmSettings.UndergroundOffset = cfg.Farm.UndergroundOffset or 4
        FarmSettings.MaxDistance = cfg.Farm.MaxDistance or 600
        FarmSettings.CoinLimit = cfg.Farm.CoinLimit or 40
    end
    
    -- Combat
    if cfg.Combat then
        Config.Settings.Combat.Camlock = cfg.Combat.Camlock or false
        Config.Settings.Combat.SilentAim = cfg.Combat.SilentAim or false
        Config.Settings.Combat.AutoShoot = cfg.Combat.AutoShoot or false
        Config.Settings.Combat.CamlockFOV = cfg.Combat.CamlockFOV or 120
        Config.Settings.Combat.CamlockPredict = cfg.Combat.CamlockPredict or 100
        Config.Settings.Combat.CamlockSmooth = cfg.Combat.CamlockSmooth or 50
        Config.Settings.Combat.SilentFOV = cfg.Combat.SilentFOV or 120
        Config.Settings.Combat.SilentPredict = cfg.Combat.SilentPredict or 100
        Config.Settings.Combat.VisibleCheck = cfg.Combat.VisibleCheck ~= false
        Config.Settings.Combat.AutoKillAll = cfg.Combat.AutoKillAll or false
        Config.Settings.Combat.AntiFling = cfg.Combat.AntiFling or false
        Config.Settings.Combat.AntiVoid = cfg.Combat.AntiVoid or false
        Config.Settings.Combat.AutoWallHop = cfg.Combat.AutoWallHop or false
        Config.Settings.Combat.GrabGun = cfg.Combat.GrabGun or false
    end
    
    -- Rage
    if cfg.Rage then
        Config.Settings.Rage.SpinBot = cfg.Rage.SpinBot or false
        Config.Settings.Rage.SpinSpeed = cfg.Rage.SpinSpeed or 50
        Config.Settings.Rage.Noclip = cfg.Rage.Noclip or false
        Config.Settings.Rage.Fly = cfg.Rage.Fly or false
        Config.Settings.Rage.FlySpeed = cfg.Rage.FlySpeed or 50
        Config.Settings.Rage.SpeedGlitch = cfg.Rage.SpeedGlitch or false
        Config.Settings.Rage.SpeedForce = cfg.Rage.SpeedForce or 45
    end
    
    -- Player (Hat, Trail, etc)
    if cfg.Player then
        if cfg.Player.Hat then
            HatVariables.enabled = cfg.Player.Hat.Enabled or false
            HatVariables.style = cfg.Player.Hat.Style or "Classic"
            HatVariables.rainbow = cfg.Player.Hat.Rainbow or false
            HatVariables.rainbowSpeed = cfg.Player.Hat.RainbowSpeed or 5
            HatVariables.transparency = cfg.Player.Hat.Transparency or 0.3
            HatVariables.radius = cfg.Player.Hat.Radius or 2.4
            HatVariables.height = cfg.Player.Hat.Height or 1.6
            HatVariables.color = tableToColor(cfg.Player.Hat.Color)
        end
        if cfg.Player.Trail then
            TrailVariables.enabled = cfg.Player.Trail.Enabled or false
            TrailVariables.isGradient = cfg.Player.Trail.Gradient or false
            TrailVariables.lifetime = cfg.Player.Trail.Lifetime or 0.5
            TrailVariables.rainbow = cfg.Player.Trail.Rainbow or false
            TrailVariables.colorStatic = tableToColor(cfg.Player.Trail.Color)
        end
        Config.Settings.Player.ForceField = cfg.Player.ForceField or false
        Config.Settings.Player.TargetESP = cfg.Player.TargetESP or false
        Config.Settings.Player.AuraTrail = cfg.Player.AuraTrail or false
    end
    
    -- Visuals
    if cfg.Visuals then
        if cfg.Visuals.ESP then
            Config.Settings.ESP.Murder = cfg.Visuals.ESP.Murder or false
            Config.Settings.ESP.Sheriff = cfg.Visuals.ESP.Sheriff or false
            Config.Settings.ESP.Innocent = cfg.Visuals.ESP.Innocent or false
            Config.Settings.ESP.Hero = cfg.Visuals.ESP.Hero or false
            Config.Settings.ESP.TargetESP = cfg.Visuals.ESP.TargetESP or false
            Config.Settings.ESP.ArrowESP = cfg.Visuals.ESP.ArrowESP or false
        end
        if cfg.Visuals.Colors then
            Config.Settings.Colors.MurderESP = tableToColor(cfg.Visuals.Colors.MurderESP)
            Config.Settings.Colors.SheriffESP = tableToColor(cfg.Visuals.Colors.SheriffESP)
            Config.Settings.Colors.InnocentESP = tableToColor(cfg.Visuals.Colors.InnocentESP)
            Config.Settings.Colors.HeroESP = tableToColor(cfg.Visuals.Colors.HeroESP)
            Config.Settings.Colors.TargetESP = tableToColor(cfg.Visuals.Colors.TargetESP)
            Config.Settings.Colors.ArrowESP = tableToColor(cfg.Visuals.Colors.ArrowESP)
        end
        if cfg.Visuals.Skybox then
            SkyboxVariables.customEnabled = cfg.Visuals.Skybox.Enabled or false
            SkyboxVariables.current = cfg.Visuals.Skybox.Current or "HD"
        end
        if cfg.Visuals.Nebula then
            NebulaVariables.enabled = cfg.Visuals.Nebula.Enabled or false
            NebulaVariables.themeColor = tableToColor(cfg.Visuals.Nebula.Color)
        end
        if cfg.Visuals.ScreenStretch then
            WorldVariables.screenEnabled = cfg.Visuals.ScreenStretch.Enabled or false
            WorldVariables.screenIntensity = cfg.Visuals.ScreenStretch.Intensity or 0
        end
        AnimeVariables.enabled = cfg.Visuals.Anime or false
        Snow.active = cfg.Visuals.Snow ~= false
        if cfg.Visuals.Snow ~= false and Snow.container then
            Snow.container.Visible = true
        elseif Snow.container then
            Snow.container.Visible = false
        end
    end
    
    -- Keybinds
    if cfg.Keybinds then
        Config.Settings.Keybinds.ToggleGUI = Enum.KeyCode[cfg.Keybinds.ToggleGUI] or Enum.KeyCode.RightShift
        Config.Settings.Keybinds.PanicKey = Enum.KeyCode[cfg.Keybinds.PanicKey] or Enum.KeyCode.End
        Config.Settings.Keybinds.Camlock = Enum.KeyCode[cfg.Keybinds.Camlock] or Enum.KeyCode.Q
        Config.Settings.Keybinds.SilentAim = Enum.KeyCode[cfg.Keybinds.SilentAim] or Enum.KeyCode.E
    end
    
    -- Window
    if cfg.Window and GUI and GUI.Main and GUI.Main.Window then
        GUI.Main.Window.BackgroundTransparency = cfg.Window.Transparency or 0.1
    end
end

local function buildConfig()
    local cfg = {
        ESP = {
            Enabled = ESP.Enabled,
            Murderer = ESP.Show.Murderer,
            Sheriff = ESP.Show.Sheriff,
            Hero = ESP.Show.Hero,
            Innocent = ESP.Show.Innocent,
            Self = ESP.Show.Self,
            Colors = {
                Murderer = colorToTable(ESP.Colors.Murderer),
                Sheriff = colorToTable(ESP.Colors.Sheriff),
                Hero = colorToTable(ESP.Colors.Hero),
                Innocent = colorToTable(ESP.Colors.Innocent),
            },
        },
        Farm = {
            Enabled = FarmSettings.Enabled,
            Mode = FarmSettings.Mode,
            TweenSpeed = FarmSettings.TweenSpeed,
            AutoReset = FarmSettings.AutoReset,
            AvoidMurder = FarmSettings.AvoidMurder,
            UndergroundOffset = FarmSettings.UndergroundOffset,
            MaxDistance = FarmSettings.MaxDistance,
            CoinLimit = FarmSettings.CoinLimit,
        },
        Combat = {
            Camlock = Config.Settings.Combat.Camlock,
            SilentAim = Config.Settings.Combat.SilentAim,
            AutoShoot = Config.Settings.Combat.AutoShoot,
            CamlockFOV = Config.Settings.Combat.CamlockFOV,
            CamlockPredict = Config.Settings.Combat.CamlockPredict,
            CamlockSmooth = Config.Settings.Combat.CamlockSmooth,
            SilentFOV = Config.Settings.Combat.SilentFOV,
            SilentPredict = Config.Settings.Combat.SilentPredict,
            VisibleCheck = Config.Settings.Combat.VisibleCheck,
            AutoKillAll = Config.Settings.Combat.AutoKillAll,
            AntiFling = Config.Settings.Combat.AntiFling,
            AntiVoid = Config.Settings.Combat.AntiVoid,
            AutoWallHop = Config.Settings.Combat.AutoWallHop,
            GrabGun = Config.Settings.Combat.GrabGun,
        },
        Rage = {
            SpinBot = Config.Settings.Rage.SpinBot,
            SpinSpeed = Config.Settings.Rage.SpinSpeed,
            Noclip = Config.Settings.Rage.Noclip,
            Fly = Config.Settings.Rage.Fly,
            FlySpeed = Config.Settings.Rage.FlySpeed,
            SpeedGlitch = Config.Settings.Rage.SpeedGlitch,
            SpeedForce = Config.Settings.Rage.SpeedForce,
        },
        Player = {
            ForceField = Config.Settings.Player.ForceField,
            TargetESP = Config.Settings.Player.TargetESP,
            AuraTrail = Config.Settings.Player.AuraTrail,
            Hat = {
                Enabled = HatVariables.enabled,
                Style = HatVariables.style,
                Rainbow = HatVariables.rainbow,
                RainbowSpeed = HatVariables.rainbowSpeed,
                Transparency = HatVariables.transparency,
                Radius = HatVariables.radius,
                Height = HatVariables.height,
                Color = colorToTable(HatVariables.color),
            },
            Trail = {
                Enabled = TrailVariables.enabled,
                Gradient = TrailVariables.isGradient,
                Lifetime = TrailVariables.lifetime,
                Rainbow = TrailVariables.rainbow,
                Color = colorToTable(TrailVariables.colorStatic),
            },
        },
        Visuals = {
            ESP = {
                Murder = Config.Settings.ESP.Murder,
                Sheriff = Config.Settings.ESP.Sheriff,
                Innocent = Config.Settings.ESP.Innocent,
                Hero = Config.Settings.ESP.Hero,
                TargetESP = Config.Settings.ESP.TargetESP,
                ArrowESP = Config.Settings.ESP.ArrowESP,
            },
            Colors = {
                MurderESP = colorToTable(Config.Settings.Colors.MurderESP),
                SheriffESP = colorToTable(Config.Settings.Colors.SheriffESP),
                InnocentESP = colorToTable(Config.Settings.Colors.InnocentESP),
                HeroESP = colorToTable(Config.Settings.Colors.HeroESP),
                TargetESP = colorToTable(Config.Settings.Colors.TargetESP),
                ArrowESP = colorToTable(Config.Settings.Colors.ArrowESP),
            },
            Skybox = {
                Enabled = SkyboxVariables.customEnabled,
                Current = SkyboxVariables.current,
            },
            Nebula = {
                Enabled = NebulaVariables.enabled,
                Color = colorToTable(NebulaVariables.themeColor),
            },
            ScreenStretch = {
                Enabled = WorldVariables.screenEnabled,
                Intensity = WorldVariables.screenIntensity,
            },
            Anime = AnimeVariables.enabled,
            Snow = Snow.active,
        },
        Keybinds = {
            ToggleGUI = Config.Settings.Keybinds.ToggleGUI.Name,
            PanicKey = Config.Settings.Keybinds.PanicKey.Name,
            Camlock = Config.Settings.Keybinds.Camlock.Name,
            SilentAim = Config.Settings.Keybinds.SilentAim.Name,
        },
        Window = {
            Transparency = GUI.Main.Window and GUI.Main.Window.BackgroundTransparency or 0.1,
        },
    }
    return cfg
end

local function saveCurrentConfig()
    local cfg = buildConfig()
    return saveConfig(cfg)
end

local function loadAndApplyConfig()
    local saved = loadConfig()
    if saved then
        local merged = migrateConfig(saved, DefaultConfig)
        applySavedConfig(merged)
        return true
    end
    return false
end

local function resetToDefaults()
    applySavedConfig(DefaultConfig)
    saveConfig(DefaultConfig)
end

local function exportConfig()
    local cfg = buildConfig()
    local json = game:GetService("HttpService"):JSONEncode(cfg)
    if setclipboard then
        setclipboard(json)
        return true, "Config copied to clipboard!"
    end
    return false, "Clipboard not supported"
end

local function importConfig(json)
    if not json or json == "" then return false, "Empty config" end
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(json)
    end)
    if not success then return false, "Invalid JSON" end
    local merged = migrateConfig(data, DefaultConfig)
    applySavedConfig(merged)
    saveConfig(merged)
    return true, "Config imported successfully!"
end

local function getConfigList()
    if not isfolder then return {} end
    if not isfolder(ConfigFolder) then return {} end
    local files = {}
    for _, file in ipairs(listfiles(ConfigFolder)) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            if name then
                table.insert(files, name)
            end
        end
    end
    return files
end

local function loadConfigByName(name)
    if not name or name == "" then return false end
    local path = ConfigFolder .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    local success, data = pcall(function()
        return readfile(path)
    end)
    if success and data then
        local success2, parsed = pcall(function()
            return game:GetService("HttpService"):JSONDecode(data)
        end)
        if success2 then
            applySavedConfig(parsed)
            return true
        end
    end
    return false
end

local function saveConfigAs(name)
    if not name or name == "" then return false end
    local cfg = buildConfig()
    local path = ConfigFolder .. "/" .. name .. ".json"
    ensureFolder()
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(cfg)
    end)
    if success and json then
        pcall(function()
            writefile(path, json)
        end)
        return true
    end
    return false
end

local function deleteConfig(name)
    if not name or name == "" then return false end
    local path = ConfigFolder .. "/" .. name .. ".json"
    if isfile(path) then
        pcall(function()
            delfile(path)
        end)
        return true
    end
    return false
end

-- ==================== END CONFIG SYSTEM ====================

local ColorPresets = {
    { Name = 'Cyan', Color = Color3.fromRGB(0, 255, 255) },
    { Name = 'Pink', Color = Color3.fromRGB(255, 105, 180) },
    { Name = 'Red', Color = Color3.fromRGB(255, 0, 0) },
    { Name = 'White', Color = Color3.fromRGB(255, 255, 255) },
    { Name = 'Green', Color = Color3.fromRGB(0, 255, 0) },
    { Name = 'Blue', Color = Color3.fromRGB(0, 100, 255) },
    { Name = 'Yellow', Color = Color3.fromRGB(255, 255, 0) },
    { Name = 'Purple', Color = Color3.fromRGB(180, 0, 255) },
    { Name = 'Orange', Color = Color3.fromRGB(255, 140, 0) },
}

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
    Minecraft = {
        Bk = 'rbxassetid://8735166756',
        Dn = 'http://www.roblox.com/asset/?id=8735166707',
        Ft = 'http://www.roblox.com/asset/?id=8735231668',
        Lf = 'http://www.roblox.com/asset/?id=8735166755',
        Rt = 'http://www.roblox.com/asset/?id=8735166751',
        Up = 'http://www.roblox.com/asset/?id=8735166729',
    },
    Galaxy = {
        Bk = 'rbxassetid://15983968922',
        Dn = 'rbxassetid://15983966825',
        Ft = 'rbxassetid://15983965025',
        Lf = 'rbxassetid://15983967420',
        Rt = 'rbxassetid://15983966246',
        Up = 'rbxassetid://15983964246',
    },
}

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

local ForceFieldVariables = {
    enabled = false,
    color = Color3.fromRGB(128, 128, 128),
    rainbow = false,
    originalColors = {},
    connection = nil,
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

local Features = {
    Connections = {},
    Highlights = {},
    OldPos = nil,
    FPDH = workspace.FallenPartsDestroyHeight,
    ShootButton = nil,
    ShootGui = nil,
    AutoFarmActive = false,
    BombJumpOnCooldown = false,
}

local ESP = {
    Enabled = false,
    Connection = nil,
    Colors = {
        Murderer = Color3.fromRGB(255, 40, 40),
        Sheriff = Color3.fromRGB(40, 130, 255),
        Hero = Color3.fromRGB(255, 215, 0),
        Innocent = Color3.fromRGB(0, 220, 0),
    },
    Show = {
        Murderer = true,
        Sheriff = true,
        Hero = true,
        Innocent = true,
        Self = true,
    },
    Data = {},
    LastUpdate = 0,
}

local function ClearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local h = player.Character:FindFirstChild('CandyZone_ESP')
            if h then h:Destroy() end
        end
    end
    ESP.Data = {}
end

local function ApplyESP(player, color)
    local char = player.Character
    if not char then return end
    local h = char:FindFirstChild('CandyZone_ESP') or Instance.new('Highlight')
    h.Name = 'CandyZone_ESP'
    h.Parent = char
    h.FillColor = color
    h.FillTransparency = 0.7
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0.15
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function GetRole(player)
    local data = ESP.Data[player.Name]
    if data then
        local role = tostring(data.Role or data.role or data.Team or ''):lower()
        if role:find('murd') then return 'Murderer' end
        if role:find('sheriff') or role:find('gun') then return 'Sheriff' end
        if role:find('hero') then return 'Hero' end
    end
    return 'Innocent'
end

local function StartESP()
    if ESP.Connection then
        ESP.Connection:Disconnect()
        ESP.Connection = nil
    end
    ESP.Connection = RunService.Heartbeat:Connect(function()
        if not ESP.Enabled then
            ClearESP()
            return
        end
        if tick() - ESP.LastUpdate > 0.5 then
            local remote = ReplicatedStorage:FindFirstChild('GetCurrentPlayerData', true)
            if remote and remote:IsA('RemoteFunction') then
                local ok, data = pcall(function() return remote:InvokeServer() end)
                if ok and type(data) == 'table' then ESP.Data = data end
            end
            ESP.LastUpdate = tick()
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local role = GetRole(player)
                local show = ESP.Show[role]
                if player == LocalPlayer and not ESP.Show.Self then show = false end
                if show then
                    ApplyESP(player, ESP.Colors[role])
                else
                    local h = player.Character:FindFirstChild('CandyZone_ESP')
                    if h then h:Destroy() end
                end
            end
        end
    end)
end

local function ToggleESP(state)
    ESP.Enabled = state
    if state then StartESP() else if ESP.Connection then ESP.Connection:Disconnect() ESP.Connection = nil end ClearESP() end
end

local function ToggleMurderer(state) ESP.Show.Murderer = state end
local function ToggleSheriff(state) ESP.Show.Sheriff = state end
local function ToggleHero(state) ESP.Show.Hero = state end
local function ToggleInnocent(state) ESP.Show.Innocent = state end
local function ToggleSelf(state) ESP.Show.Self = state end
local function SetMurdererColor(c) ESP.Colors.Murderer = c end
local function SetSheriffColor(c) ESP.Colors.Sheriff = c end
local function SetHeroColor(c) ESP.Colors.Hero = c end
local function SetInnocentColor(c) ESP.Colors.Innocent = c end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if ESP.Enabled then ClearESP() StartESP() end
end)

local Murder = nil
local grabbingGun = false

-- ==================== TARGET ESP ====================
local TargetESPVariables = {
    enabled = false,
    size = 45,
    maxRadius = 50,
    asset = "rbxassetid://113363639205880",
    color = Color3.fromRGB(255, 70, 90),
    rainbow = false,
    rotation = 0,
    gui = nil,
    frame = nil,
    texture = nil,
    currentTarget = nil,
}

local function getRootPart(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("MainPart")
end

local function getHeadPart(char)
    if not char then return nil end
    return char:FindFirstChild("Head") or char:FindFirstChild("head") or char:FindFirstChild("CameraPart")
end

local function isFriend(player)
    if _G.FriendWhitelist and _G.FriendWhitelist[player] then return true end
    return false
end

local function isVisible(targetPart, character)
    local localChar = LocalPlayer.Character
    local head = getHeadPart(localChar)
    if not localChar or not head then return false end
    
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {localChar, character}
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function TargetESP_Init()
    TargetESPVariables.gui = Instance.new("ScreenGui")
    TargetESPVariables.gui.Name = "AunixTargetESP"
    TargetESPVariables.gui.ResetOnSpawn = false
    TargetESPVariables.gui.IgnoreGuiInset = true
    if gethui then
        TargetESPVariables.gui.Parent = gethui()
    else
        TargetESPVariables.gui.Parent = CoreGui
    end

    TargetESPVariables.frame = Instance.new("Frame")
    TargetESPVariables.frame.Size = UDim2.new(0, 40, 0, 40)
    TargetESPVariables.frame.BackgroundTransparency = 1
    TargetESPVariables.frame.Visible = false
    TargetESPVariables.frame.Parent = TargetESPVariables.gui

    TargetESPVariables.texture = Instance.new("ImageLabel")
    TargetESPVariables.texture.Size = UDim2.new(1, 0, 1, 0)
    TargetESPVariables.texture.AnchorPoint = Vector2.new(0.5, 0.5)
    TargetESPVariables.texture.Position = UDim2.new(0.5, 0, 0.5, 0)
    TargetESPVariables.texture.BackgroundTransparency = 1
    TargetESPVariables.texture.Image = TargetESPVariables.asset
    TargetESPVariables.texture.ImageColor3 = TargetESPVariables.color
    TargetESPVariables.texture.Parent = TargetESPVariables.frame
end

TargetESP_Init()

RunService.RenderStepped:Connect(function(dt)
    if not TargetESPVariables.enabled then
        TargetESPVariables.currentTarget = nil
        TargetESPVariables.frame.Visible = false
        return
    end

    if TargetESPVariables.currentTarget then
        if not TargetESPVariables.currentTarget.Character or not TargetESPVariables.currentTarget.Character:FindFirstChildOfClass("Humanoid") or TargetESPVariables.currentTarget.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            TargetESPVariables.currentTarget = nil
        end
    end

    local bestTarget = nil
    local closestToCenter = math.huge
    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local localRoot = getRootPart(LocalPlayer.Character)

    if localRoot then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not isFriend(player) then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local root = getRootPart(player.Character) or getHeadPart(player.Character)
                
                if hum and hum.Health > 0 and root then
                    local dist = (root.Position - localRoot.Position).Magnitude
                    if dist <= TargetESPVariables.maxRadius then
                        if isVisible(root, player.Character) then
                            local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                                if screenDist < closestToCenter and screenDist < 250 then
                                    closestToCenter = screenDist
                                    bestTarget = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    TargetESPVariables.currentTarget = bestTarget

    if TargetESPVariables.currentTarget and TargetESPVariables.currentTarget.Character then
        local char = TargetESPVariables.currentTarget.Character
        local targetPart = getRootPart(char) or getHeadPart(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if targetPart and hum and hum.Health > 0 then
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                TargetESPVariables.rotation = (TargetESPVariables.rotation + 140 * dt) % 360
                TargetESPVariables.texture.Rotation = TargetESPVariables.rotation
                TargetESPVariables.texture.Image = TargetESPVariables.asset

                if TargetESPVariables.rainbow then
                    TargetESPVariables.texture.ImageColor3 = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
                else
                    TargetESPVariables.texture.ImageColor3 = TargetESPVariables.color
                end

                local dist = (targetPart.Position - camera.CFrame.Position).Magnitude
                local scale = math.clamp(1 - (dist / 60), 0.6, 1.4)
                local calculatedSize = math.floor(TargetESPVariables.size * scale)

                TargetESPVariables.frame.Size = UDim2.new(0, calculatedSize, 0, calculatedSize)
                TargetESPVariables.frame.Position = UDim2.new(0, screenPos.X - calculatedSize / 2, 0, screenPos.Y - calculatedSize / 2)
                TargetESPVariables.frame.Visible = true
            else
                TargetESPVariables.frame.Visible = false
            end
        else
            TargetESPVariables.frame.Visible = false
        end
    else
        TargetESPVariables.frame.Visible = false
    end
end)
-- ==================== END TARGET ESP ====================

-- ==================== ARROW ESP ====================
local ArrowESPVariables = {
    enabled = false,
    color = Color3.fromRGB(255, 255, 255),
    rainbow = false,
    distance = 80,
    gui = nil,
    arrows = {},
}

local function ArrowESP_Init()
    ArrowESPVariables.gui = Instance.new("ScreenGui")
    ArrowESPVariables.gui.Name = "ArrowESP"
    ArrowESPVariables.gui.ResetOnSpawn = false
    ArrowESPVariables.gui.IgnoreGuiInset = true
    if gethui then
        ArrowESPVariables.gui.Parent = gethui()
    else
        ArrowESPVariables.gui.Parent = CoreGui
    end
end

ArrowESP_Init()

RunService.RenderStepped:Connect(function()
    if not ArrowESPVariables.enabled then
        for _, arrow in pairs(ArrowESPVariables.arrows) do
            arrow:Remove()
        end
        ArrowESPVariables.arrows = {}
        return
    end

    for _, arrow in pairs(ArrowESPVariables.arrows) do
        arrow:Remove()
    end
    ArrowESPVariables.arrows = {}

    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local root = getRootPart(player.Character)
            
            if hum and hum.Health > 0 and root then
                local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                
                if not onScreen or screenPos.Z < 0 then
                    local direction = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Unit
                    local angle = math.atan2(direction.Y, direction.X)
                    
                    local arrowPos = screenCenter + direction * ArrowESPVariables.distance
                    
                    local arrow = Drawing.new("Triangle")
                    arrow.Visible = true
                    arrow.Filled = true
                    arrow.Thickness = 1
                    
                    if ArrowESPVariables.rainbow then
                        arrow.Color = Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
                    else
                        arrow.Color = ArrowESPVariables.color
                    end
                    
                    local size = 15
                    local p1 = arrowPos + Vector2.new(math.cos(angle) * size, math.sin(angle) * size)
                    local p2 = arrowPos + Vector2.new(math.cos(angle + 2.5) * size * 0.6, math.sin(angle + 2.5) * size * 0.6)
                    local p3 = arrowPos + Vector2.new(math.cos(angle - 2.5) * size * 0.6, math.sin(angle - 2.5) * size * 0.6)
                    
                    arrow.PointA = p1
                    arrow.PointB = p2
                    arrow.PointC = p3
                    
                    table.insert(ArrowESPVariables.arrows, arrow)
                end
            end
        end
    end
end)
-- ==================== END ARROW ESP ====================

-- ==================== HITSOUND SYSTEM ====================
local HitsoundData = {
    enabled = false,
    selectedGunshot = "RPGS Candy",
    selectedKnifeKill = "Golden Knife Kill",
    hooked = {},
    gunshotSounds = {
        ["Alchemist Burst"] = "rbxassetid://130507807370367",
        ["RPGS Candy"]      = "rbxassetid://83995181532586",
        ["RPGE Beary"]      = "rbxassetid://112424028680133",
        ["DB Bloss"]        = "rbxassetid://97681259004692",
        ["Rev Blossom"]     = "rbxassetid://118868788824782",
        ["Kawaii DG"]       = "rbxassetid://135458839245691",
        ["Hit Basic 3"]     = "rbxassetid://90160800327080",
        ["Bameware"]        = "rbxassetid://3124331820",
        ["Bell"]            = "rbxassetid://6534947240",
        ["Bubble"]          = "rbxassetid://6534947588",
        ["Pick"]            = "rbxassetid://1347140027",
        ["Pop"]             = "rbxassetid://198598793",
        ["Rust"]            = "rbxassetid://1255040462",
        ["Sans"]            = "rbxassetid://3188795283",
        ["Fart"]            = "rbxassetid://130833677",
        ["Big"]             = "rbxassetid://5332005053",
        ["Vine"]            = "rbxassetid://5332680810",
        ["Bruh"]            = "rbxassetid://4578740568",
        ["Skeet"]           = "rbxassetid://5633695679",
        ["Neverlose"]       = "rbxassetid://6534948092",
        ["Fatality"]        = "rbxassetid://6534947869",
        ["Bonk"]            = "rbxassetid://5766898159",
        ["Minecraft"]       = "rbxassetid://4018616850",
        ["Call of Duty"]    = "rbxassetid://5952120301",
        ["Bat"]             = "rbxassetid://3333907347",
        ["Saber"]           = "rbxassetid://8415678813",
        ["Notif"]           = "rbxassetid://6696469190",
        ["Shutter"]         = "rbxassetid://10066921516",
        ["RIFK7"]           = "rbxassetid://9102080552",
        ["LazerBeam"]       = "rbxassetid://130791043",
        ["WindowsXPError"]  = "rbxassetid://160715357",
        ["BowHit"]          = "rbxassetid://1053296915",
        ["Bow"]             = "rbxassetid://3442683707",
        ["OSU"]             = "rbxassetid://7147454322",
        ["Old Fatality"]    = "rbxassetid://6607142036",
        ["TF2"]             = "rbxassetid://2868331684",
        ["BulletDeflect"]   = "rbxassetid://1657157666",
        ["UwU"]             = "rbxassetid://8679659744",
        ["Cod"]             = "rbxassetid://160432334",
    },
    knifeKillSounds = {
        ["S3 Coin Hit"]         = "rbxassetid://139857881082762",
        ["Custom Hit 1"]        = "rbxassetid://138592514473573",
        ["Golden Knife Kill"]   = "rbxassetid://6066375795",
        ["Among Us"]            = "rbxassetid://130456049552264",
        ["Jeff Laugh"]          = "rbxassetid://140445930084397",
        ["Pelmeni"]             = "rbxassetid://130226230760992",
        ["Horror Kill"]         = "rbxassetid://128741351184513",
        ["Jeff Stab"]           = "rbxassetid://81483362340487",
        ["Bameware"]            = "rbxassetid://3124331820",
        ["Bell"]                = "rbxassetid://6534947240",
        ["Bubble"]              = "rbxassetid://6534947588",
        ["Pick"]                = "rbxassetid://1347140027",
        ["Pop"]                 = "rbxassetid://198598793",
        ["Rust"]                = "rbxassetid://1255040462",
        ["Sans"]                = "rbxassetid://3188795283",
        ["Fart"]                = "rbxassetid://130833677",
        ["Big"]                 = "rbxassetid://5332005053",
        ["Vine"]                = "rbxassetid://5332680810",
        ["Bruh"]                = "rbxassetid://4578740568",
        ["Skeet"]               = "rbxassetid://5633695679",
        ["Neverlose"]           = "rbxassetid://6534948092",
        ["Fatality"]            = "rbxassetid://6534947869",
        ["Bonk"]                = "rbxassetid://5766898159",
        ["Minecraft"]           = "rbxassetid://4018616850",
        ["Call of Duty"]        = "rbxassetid://5952120301",
        ["Bat"]                 = "rbxassetid://3333907347",
        ["Saber"]               = "rbxassetid://8415678813",
        ["Notif"]               = "rbxassetid://6696469190",
        ["Shutter"]             = "rbxassetid://10066921516",
        ["RIFK7"]               = "rbxassetid://9102080552",
        ["LazerBeam"]           = "rbxassetid://130791043",
        ["WindowsXPError"]      = "rbxassetid://160715357",
        ["BowHit"]              = "rbxassetid://1053296915",
        ["Bow"]                 = "rbxassetid://3442683707",
        ["OSU"]                 = "rbxassetid://7147454322",
        ["Old Fatality"]        = "rbxassetid://6607142036",
        ["TF2"]                 = "rbxassetid://2868331684",
        ["BulletDeflect"]       = "rbxassetid://1657157666",
        ["UwU"]                 = "rbxassetid://8679659744",
        ["Cod"]                 = "rbxassetid://160432334",
    },
}

local function hookSound(sound)
    if not sound:IsA("Sound") or HitsoundData.hooked[sound] then
        return
    end
    HitsoundData.hooked[sound] = true

    sound.Played:Connect(function()
        if sound.Name == "Gunshot" and HitsoundData.selectedGunshot and HitsoundData.selectedGunshot ~= "None" and HitsoundData.gunshotSounds[HitsoundData.selectedGunshot] and sound.SoundId ~= HitsoundData.gunshotSounds[HitsoundData.selectedGunshot] then
            sound.SoundId = HitsoundData.gunshotSounds[HitsoundData.selectedGunshot]
            sound.TimePosition = 0
            sound:Play()
        elseif sound.Name == "Kill" and HitsoundData.selectedKnifeKill and HitsoundData.selectedKnifeKill ~= "None" and HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill] and sound.SoundId ~= HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill] then
            sound.SoundId = HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill]
            sound.TimePosition = 0
            sound:Play()
        end
    end)
end

workspace.DescendantAdded:Connect(function(d)
    if d:IsA("Sound") and (d.Name == "Gunshot" or d.Name == "Kill") then
        hookSound(d)
    end
end)

for _, d in ipairs(workspace:GetDescendants()) do
    if d:IsA("Sound") and (d.Name == "Gunshot" or d.Name == "Kill") then
        hookSound(d)
    end
end
-- ==================== END HITSOUND ====================

-- ==================== AUTO WALLHOP ====================
local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0
local lastHitInstance = nil

local function performVideoFlick()
    if isFlicking then return end
    isFlicking = true
    
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then isFlicking = false return end

    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    local startCFrame = camera.CFrame
    camera.CFrame = startCFrame * CFrame.Angles(0, math.rad(180), 0)
    
    task.wait(0.01)
    
    camera.CFrame = startCFrame
    
    isFlicking = false
end

RunService.Heartbeat:Connect(function()
    if not Config.Settings.Combat.AutoWallHop then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {char}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(hrp.Position, camera.CFrame.LookVector * 3, raycastParams)

    if result and result.Instance.CanCollide then
        if lastHitInstance and lastHitInstance ~= result.Instance then
            if tick() - lastFlickTime > 0.05 then
                lastFlickTime = tick()
                performVideoFlick()
            end
        end
        lastHitInstance = result.Instance
    else
        lastHitInstance = nil
    end
end)
-- ==================== END AUTO WALLHOP ====================

-- ==================== GRAB GUN ====================
local function IsAlive(player)
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function grabGun()
    if grabbingGun then return end
    if not IsAlive(LocalPlayer) then return end
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp then return end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local isMurderer = (char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) or (Murder and LocalPlayer.Name == Murder)
    if isMurderer then return end
    
    local function hasGun()
        local currentBp = LocalPlayer:FindFirstChild("Backpack")
        return (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")) or (currentBp and (currentBp:FindFirstChild("Gun") or currentBp:FindFirstChild("Revolver")))
    end
    if hasGun() then return end
    
    local gunDrop = workspace:FindFirstChild("GunDrop", true) or workspace:FindFirstChild("DroppedGun", true)
    local handle = gunDrop and (gunDrop:FindFirstChild("Handle", true) or gunDrop:FindFirstChildOfClass("Part", true) or gunDrop)
    if not handle then return end
    
    grabbingGun = true
    
    local originalCFrame = hrp.CFrame
    local targetCFrame = handle:IsA("Model") and handle:GetPivot() or handle.CFrame
    
    hrp.CFrame = targetCFrame * CFrame.new(0, -1, 0)
    
    if firetouchinterest then
        pcall(function()
            firetouchinterest(hrp, handle, 0)
            task.wait(0.02)
            firetouchinterest(hrp, handle, 1)
        end)
    end
    
    task.wait(0.15)
    
    if IsAlive(LocalPlayer) then
        hrp.CFrame = originalCFrame
    end
    
    grabbingGun = false
end

task.spawn(function()
    while true do
        if Config.Settings.Combat.GrabGun then
            pcall(grabGun)
        end
        task.wait(0.5)
    end
end)
-- ==================== END GRAB GUN ====================

local function addConn(conn)
    table.insert(Features.Connections, conn)
    return conn
end

local Util = {}

function Util:Tween(obj, props, duration, style, direction)
    if not obj then
        return
    end
    duration = duration or Config.Anim.Normal
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(obj, TweenInfo.new(duration, style, direction), props)
    tween:Play()
    return tween
end

function Util:Corner(obj, radius)
    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
    return corner
end

function Util:Stroke(obj, thickness, color, transparency)
    local stroke = Instance.new('UIStroke')
    stroke.Thickness = thickness or 1
    stroke.Color = color or Config.Color.Accent.White
    stroke.Transparency = transparency or 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

function Util:Gradient(obj, colorSeq, rotation)
    local gradient = Instance.new('UIGradient')
    gradient.Color = colorSeq or ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
    }
    gradient.Rotation = rotation or 90
    gradient.Parent = obj
    return gradient
end

function Util:Ripple(button)
    button.ClipsDescendants = true
    button.MouseButton1Down:Connect(function()
        local ripple = Instance.new('Frame')
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
            BackgroundTransparency = 1,
        }, 0.6, Enum.EasingStyle.Circular)
        task.delay(0.6, function()
            ripple:Destroy()
        end)
    end)
end

function Util:GetGameName()
    return game.PlaceId == 142823291 and 'MM2' or 'MMV'
end

function Util:GetPlayerName()
    local name = LocalPlayer.DisplayName or LocalPlayer.Name
    return #name > 12 and name:sub(1, 10) .. '..' or name
end

function Util:Clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

function Util:Round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

local FPS = {
    frames = 0,
    lastUpdate = tick(),
    current = 60,
    history = {},
    maxHistory = 60,
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

local Snow = {
    particles = {},
    container = nil,
    active = false,
    count = 120,
}

function Snow:Create(parent)
    self.container = Instance.new('Frame')
    self.container.Name = 'SnowSystem'
    self.container.Size = UDim2.new(1, 0, 1, 0)
    self.container.BackgroundTransparency = 1
    self.container.ClipsDescendants = true
    self.container.ZIndex = 5
    self.container.Parent = parent
    for i = 1, self.count do
        local flake = Instance.new('Frame')
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
            rotSpeed = math.random(-2, 2),
        })
    end
    self.active = true
    self:Animate()
end

function Snow:Animate()
    local time = 0
    RunService.RenderStepped:Connect(function(dt)
        if not self.active then
            return
        end
        time = time + dt
        for _, p in ipairs(self.particles) do
            if not p.frame.Parent then
                continue
            end
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

local function applyHighlight(player, color)
    local character = player.Character
    if not character then
        return
    end
    local highlight = character:FindFirstChild('CandyZone_ESP')
    if not highlight then
        highlight = Instance.new('Highlight')
        highlight.Name = 'CandyZone_ESP'
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        Features.Highlights[player] = highlight
    else
        highlight.FillColor = color
        highlight.OutlineColor = color
    end
end

local function removeHighlight(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild('CandyZone_ESP')
        if highlight then
            highlight:Destroy()
        end
    end
    Features.Highlights[player] = nil
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local bp = player:FindFirstChild('Backpack')
            local hasKnife = (player.Character:FindFirstChild('Knife')) or (bp and bp:FindFirstChild('Knife'))
            local hasGun = (player.Character:FindFirstChild('Gun') or player.Character:FindFirstChild('Revolver')) or (bp and (bp:FindFirstChild('Gun') or bp:FindFirstChild('Revolver')))
            local color = nil
            if hasKnife and Config.Settings.ESP.Murder then
                color = Config.Settings.Colors.MurderESP
            elseif hasGun and Config.Settings.ESP.Sheriff then
                color = Config.Settings.Colors.SheriffESP
            elseif Config.Settings.ESP.Innocent and not hasKnife and not hasGun then
                color = Config.Settings.Colors.InnocentESP
            end
            if color then
                applyHighlight(player, color)
            else
                removeHighlight(player)
            end
        end
    end
end

task.spawn(function()
    while true do
        pcall(updateESP)
        task.wait(0.15)
    end
end)

local function setNoclip(state)
    Config.Settings.Rage.Noclip = state
end

addConn(RunService.Stepped:Connect(function()
    if not Config.Settings.Rage.Noclip then
        return
    end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA('BasePart') then
                part.CanCollide = false
            end
        end
    end
end))

local flyBV, flyBG
local mobileButtons = {}

local function setFly(state)
    Config.Settings.Rage.Fly = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    local hum = char and char:FindFirstChildOfClass('Humanoid')
    
    if state and hrp and hum then
        if flyBV then
            flyBV:Destroy()
        end
        if flyBG then
            flyBG:Destroy()
        end
        flyBV = Instance.new('BodyVelocity')
        flyBV.MaxForce = Vector3.new(9e9, 9E9, 9e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = hrp
        flyBG = Instance.new('BodyGyro')
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.P = 9e4
        flyBG.Parent = hrp
        hum.PlatformStand = true
        
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local FlyGui = Instance.new("ScreenGui")
            FlyGui.Name = "FlyControls"
            FlyGui.ResetOnSpawn = false
            FlyGui.Parent = PlayerGui
            
            local function createButton(text, pos)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 60, 0, 60)
                btn.Position = pos
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 18
                btn.Parent = FlyGui
                Util:Corner(btn, 10)
                return btn
            end
            
            mobileButtons.forward = createButton("↑", UDim2.new(0.5, -30, 0.8, -130))
            mobileButtons.backward = createButton("↓", UDim2.new(0.5, -30, 0.8, -60))
            mobileButtons.left = createButton("←", UDim2.new(0.5, -100, 0.8, -95))
            mobileButtons.right = createButton("→", UDim2.new(0.5, 40, 0.8, -95))
            mobileButtons.up = createButton("▲", UDim2.new(0.1, 0, 0.8, -95))
            mobileButtons.down = createButton("▼", UDim2.new(0.1, 70, 0.8, -95))
        end
    else
        if flyBV then
            flyBV:Destroy()
            flyBV = nil
        end
        if flyBG then
            flyBG:Destroy()
            flyBG = nil
        end
        if hum then
            hum.PlatformStand = false
        end
        
        if LocalPlayer:FindFirstChild("PlayerGui") then
            local fg = LocalPlayer.PlayerGui:FindFirstChild("FlyControls")
            if fg then
                fg:Destroy()
            end
        end
        mobileButtons = {}
    end
end

local mobileDir = Vector3.new(0, 0, 0)

addConn(RunService.RenderStepped:Connect(function()
    if not Config.Settings.Rage.Fly then
        return
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    local cam = workspace.CurrentCamera
    if not hrp or not cam or not flyBV then
        return
    end
    
    local dir = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        dir = dir + cam.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        dir = dir - cam.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        dir = dir - cam.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        dir = dir + cam.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        dir = dir + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        dir = dir - Vector3.new(0, 1, 0)
    end
    
    dir = dir + mobileDir
    
    if dir.Magnitude > 0 then
        dir = dir.Unit * (Config.Settings.Rage.FlySpeed or 50)
    end
    flyBV.Velocity = dir
    if flyBG then
        flyBG.CFrame = cam.CFrame
    end
end))

task.spawn(function()
    while true do
        mobileDir = Vector3.new(0, 0, 0)
        if mobileButtons.forward and mobileButtons.forward:IsDescendantOf(game) then
            if mobileButtons.forward.MouseButton1Down:Wait() then
                mobileDir = mobileDir + camera.CFrame.LookVector
            end
        end
        if mobileButtons.backward and mobileButtons.backward:IsDescendantOf(game) then
            if mobileButtons.backward.MouseButton1Down:Wait() then
                mobileDir = mobileDir - camera.CFrame.LookVector
            end
        end
        if mobileButtons.left and mobileButtons.left:IsDescendantOf(game) then
            if mobileButtons.left.MouseButton1Down:Wait() then
                mobileDir = mobileDir - camera.CFrame.RightVector
            end
        end
        if mobileButtons.right and mobileButtons.right:IsDescendantOf(game) then
            if mobileButtons.right.MouseButton1Down:Wait() then
                mobileDir = mobileDir + camera.CFrame.RightVector
            end
        end
        if mobileButtons.up and mobileButtons.up:IsDescendantOf(game) then
            if mobileButtons.up.MouseButton1Down:Wait() then
                mobileDir = mobileDir + Vector3.new(0, 1, 0)
            end
        end
        if mobileButtons.down and mobileButtons.down:IsDescendantOf(game) then
            if mobileButtons.down.MouseButton1Down:Wait() then
                mobileDir = mobileDir - Vector3.new(0, 1, 0)
            end
        end
        task.wait()
    end
end)

addConn(RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass('Humanoid')
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if not hrp or not hum then
        return
    end
    if Config.Settings.Rage.SpeedGlitch and hum.MoveDirection.Magnitude > 0 then
        local slideVector = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
        hrp.CFrame = hrp.CFrame + (slideVector * (Config.Settings.Rage.SpeedForce * dt))
    end
end))

addConn(RunService.RenderStepped:Connect(function()
    if not Config.Settings.Rage.SpinBot then
        return
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    if hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Config.Settings.Rage.SpinSpeed or 50), 0)
    end
end))

local function flingPlayer(targetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass('Humanoid')
    local RootPart = Humanoid and Humanoid.RootPart or (Character and Character:FindFirstChild('HumanoidRootPart'))
    local TCharacter = targetPlayer.Character
    if not TCharacter then
        return
    end
    local THumanoid = TCharacter:FindFirstChildOfClass('Humanoid')
    local TRootPart = THumanoid and THumanoid.RootPart or TCharacter:FindFirstChild('HumanoidRootPart')
    local THead = TCharacter:FindFirstChild('Head')
    local Accessory = TCharacter:FindFirstChildOfClass('Accessory')
    local Handle = Accessory and Accessory:FindFirstChild('Handle')
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            Features.OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA('BasePart') then
            return
        end
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9E8, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        local SFBasePart = function(BasePart)
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
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                end
            until Time + TimeToWait < tick()
        end
        workspace.FallenPartsDestroyHeight = 0 / 0
        local BV = Instance.new('BodyVelocity')
        BV.Parent = RootPart
        BV.Velocity = Vector3.new()
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        if TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        end
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        if Features.OldPos then
            repeat
                RootPart.CFrame = Features.OldPos * CFrame.new(0, 0.5, 0)
                Character:SetPrimaryPartCFrame(Features.OldPos * CFrame.new(0, 0.5, 0))
                Humanoid:ChangeState('GettingUp')
                for _, part in pairs(Character:GetChildren()) do
                    if part:IsA('BasePart') then
                        part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end
                task.wait()
            until (RootPart.Position - Features.OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = Features.FPDH
        end
    end
end

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local bp = p:FindFirstChild('Backpack')
            if (bp and bp:FindFirstChild('Knife')) or p.Character:FindFirstChild('Knife') then
                return p
            end
        end
    end
    return nil
end

local function getSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local bp = p:FindFirstChild('Backpack')
            local hasGun = (bp and (bp:FindFirstChild('Gun') or bp:FindFirstChild('Revolver'))) or p.Character:FindFirstChild('Gun') or p.Character:FindFirstChild('Revolver')
            if hasGun then
                return p
            end
        end
    end
    return nil
end

local function fireGun(gun, targetPosition)
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild('Backpack')
    if gun.Parent == bp then
        char.Humanoid:EquipTool(gun)
        task.wait(0.05)
    end
    local originCF
    local gunServer = gun:FindFirstChild('GunServer')
    if gunServer then
        local attachment = gunServer:FindFirstChild('GunRaycastAttachment1') or gunServer:FindFirstChild('RaycastAttachment')
        if attachment then
            originCF = attachment.WorldCFrame
        end
    end
    if not originCF then
        local handle = gun:FindFirstChild('Handle') or gun:FindFirstChild('Gun')
        if handle and handle:IsA('BasePart') then
            originCF = handle.CFrame
        end
    end
    if not originCF then
        local hrp = char:FindFirstChild('HumanoidRootPart')
        if hrp then
            originCF = hrp.CFrame
        end
    end
    if not originCF then
        return
    end
    local shootRemote = gun:FindFirstChild('Shoot') or gun:FindFirstChild('Fire')
    if shootRemote then
        local args = {
            CFrame.new(originCF.Position, targetPosition),
            CFrame.new(targetPosition),
        }
        shootRemote:FireServer(unpack(args))
    else
        pcall(function()
            if ReplicatedStorage:FindFirstChild('ShootGun') then
                ReplicatedStorage.ShootGun:InvokeServer(1, targetPosition, targetPosition)
            else
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
    end
end

local function shootMurdererDirect()
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local gun = char:FindFirstChild('Gun') or char:FindFirstChild('Revolver')
    if not gun then
        local bp = LocalPlayer:FindFirstChild('Backpack')
        gun = bp and (bp:FindFirstChild('Gun') or bp:FindFirstChild('Revolver'))
    end
    if not gun then
        return
    end
    local m = getMurderer()
    if m and m.Character and m.Character:FindFirstChild('HumanoidRootPart') then
        fireGun(gun, m.Character.HumanoidRootPart.Position)
    end
end

local function createDraggableShootButton()
    if Features.ShootGui then
        Features.ShootGui:Destroy()
    end
    local sg = Instance.new('ScreenGui')
    sg.Name = 'CandyZone_ShootBtn'
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999999
    if gethui then
        sg.Parent = gethui()
    else
        sg.Parent = CoreGui
    end
    Features.ShootGui = sg
    local btn = Instance.new('TextButton')
    btn.Name = 'ShootButton'
    btn.Size = UDim2.new(0, 80, 0, 80)
    btn.Position = UDim2.new(0.85, 0, 0.6, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    btn.Text = '\u{1f52b}\nSHOOT'
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = sg
    Util:Corner(btn, 12)
    Util:Stroke(btn, 2, Color3.fromRGB(0, 150, 255), 0.3)
    btn.MouseButton1Click:Connect(function()
        local ripple = Instance.new('Frame')
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        ripple.BackgroundTransparency = 0.4
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.ZIndex = btn.ZIndex + 1
        ripple.BorderSizePixel = 0
        ripple.Parent = btn
        Util:Corner(ripple, 999)
        Util:Tween(ripple, {
            Size = UDim2.new(0, 120, 0, 120),
            BackgroundTransparency = 1,
        }, 0.4)
        task.delay(0.4, function()
            ripple:Destroy()
        end)
        shootMurdererDirect()
    end)
    Features.ShootButton = btn
end

local function removeDraggableShootButton()
    if Features.ShootGui then
        Features.ShootGui:Destroy()
        Features.ShootGui = nil
        Features.ShootButton = nil
    end
end

-- ==================== AUTOFARM ====================
local FarmSettings = {
    Enabled = false,
    Mode = "Underground",
    TweenSpeed = 25,
    AutoReset = true,
    AvoidMurder = true,
    UndergroundOffset = 4,
    MaxDistance = 600,
    CoinLimit = 40,
}

local FarmState = {
    isFarming = false,
    isActivelyFlying = false,
    currentTargetCoin = nil,
    ignoredCoins = {},
    currentTween = nil,
}

local function getCurrentCoins()
    local ok, res = pcall(function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
        if not gui then return 0 end
        local gameGui = gui:FindFirstChild("Game")
        if not gameGui then return 0 end
        local coinBags = gameGui:FindFirstChild("CoinBags")
        if not coinBags then return 0 end
        local container = coinBags:FindFirstChild("Container")
        if not container then return 0 end
        local coin = container:FindFirstChild("Coin")
        if not coin then return 0 end
        local currencyFrame = coin:FindFirstChild("CurrencyFrame")
        if not currencyFrame then return 0 end
        local icon = currencyFrame:FindFirstChild("Icon")
        if not icon then return 0 end
        local coinsText = icon:FindFirstChild("Coins")
        if not coinsText then return 0 end
        return coinsText.Text
    end)
    return ok and (tonumber(res) or 0) or 0
end

local function isRoundOver()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not pGui then return false end
    local victoryGui = pGui:FindFirstChild("Victory")
    if victoryGui then
        for _, child in pairs(victoryGui:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then return true end
        end
    end
    return false
end

local function isBagFull()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        local mainGui = pGui:FindFirstChild("MainGUI")
        if mainGui and mainGui:FindFirstChild("Lobby") and mainGui.Lobby:FindFirstChild("Dock") then
            local coinBags = mainGui.Lobby.Dock:FindFirstChild("CoinBags")
            if coinBags then
                local notification = coinBags:FindFirstChild("FullBagNotification")
                if notification and notification.Visible then return true end
            end
        end
    end
    return false
end

local function hasNearbyMurderer()
    if not FarmSettings.AvoidMurder then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local otherHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local backpack = player:FindFirstChild("Backpack")
            if otherHRP and (otherHRP.Position - hrp.Position).Magnitude <= 10 then
                if player.Character:FindFirstChild("Knife") then return true end
                if backpack and backpack:FindFirstChild("Knife") then return true end
            end
        end
    end
    return false
end

local function getNearestCoin(torso)
    local container = nil
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "CoinContainer" then
            container = obj
            break
        end
    end
    if not container then return nil end
    local nearestCoin = nil
    local minDist = math.huge
    for _, coin in pairs(container:GetChildren()) do
        if coin.Name == "Coin_Server" and coin:IsA("BasePart") and not FarmState.ignoredCoins[coin] then
            local dist = (torso.Position - coin.Position).Magnitude
            if dist < minDist and dist <= FarmSettings.MaxDistance then
                minDist = dist
                nearestCoin = coin
            end
        end
    end
    return nearestCoin
end

local function applyFlightPhysics(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return CFrame.Angles(0,0,0) end
    local bv = hrp:FindFirstChild("FarmBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "FarmBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
    end
    local bg = hrp:FindFirstChild("FarmBG")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "FarmBG"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 50000
        bg.Parent = hrp
        local _, rotY, _ = hrp.CFrame:ToOrientation()
        bg.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, rotY, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    end
    return bg.CFrame.Rotation
end

local function removePhysics()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        if hrp:FindFirstChild("FarmBV") then hrp.FarmBV:Destroy() end
        if hrp:FindFirstChild("FarmBG") then hrp.FarmBG:Destroy() end
    end
end

local function setupNoclip()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

local function flyToPoint(targetPos, targetCoin, hrp, torso, lockedRotation)
    local dist = (torso.Position - targetPos).Magnitude
    local tweenInfo = TweenInfo.new(dist / FarmSettings.TweenSpeed, Enum.EasingStyle.Linear)
    local targetCFrame = CFrame.new(targetPos) * lockedRotation
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    FarmState.currentTween = tween
    local reached = false
    tween:Play()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not FarmState.isFarming or not targetCoin or not targetCoin:IsDescendantOf(workspace) then
            tween:Cancel()
            if connection then connection:Disconnect() end
            return
        end
        local currentDist = (torso.Position - targetPos).Magnitude
        if firetouchinterest then
            pcall(function()
                firetouchinterest(torso, targetCoin, 0)
                firetouchinterest(torso, targetCoin, 1)
            end)
        end
        if currentDist <= 1.5 then
            reached = true
            tween:Cancel()
            if connection then connection:Disconnect() end
        end
    end)
    while connection and connection.Connected do
        RunService.Heartbeat:Wait()
    end
    return reached
end

local function tweenToCoin(coin)
    if not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then
        return false
    end
    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    local target = coin.Position + Vector3.new(0, 2, 0)
    if (hrp.Position - target).Magnitude < 5 then
        return true
    end
    if FarmState.currentTween then
        pcall(function() FarmState.currentTween:Cancel() end)
    end
    FarmState.currentTween = TweenService:Create(hrp,
        TweenInfo.new(
            (hrp.Position - target).Magnitude / FarmSettings.TweenSpeed,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {CFrame = CFrame.new(target)}
    )
    hum.Sit = true
    FarmState.currentTween:Play()
    local done = false
    local c
    c = FarmState.currentTween.Completed:Connect(function()
        done = true
        if c then c:Disconnect() end
    end)
    local t0 = tick()
    while not done and FarmState.isFarming do
        task.wait(0.1)
        if not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then
            if FarmState.currentTween then
                pcall(function() FarmState.currentTween:Cancel() end)
            end
            hum.Sit = false
            return false
        end
        if tick() - t0 > 30 then
            if FarmState.currentTween then
                pcall(function() FarmState.currentTween:Cancel() end)
            end
            hum.Sit = false
            return false
        end
    end
    hum.Sit = false
    return done
end

local function collectCoin(coin)
    if not coin or not coin.Parent then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        firetouchinterest(hrp, coin, 0)
        task.wait(0.05)
        firetouchinterest(hrp, coin, 1)
    end)
end

function StartFarming()
    if FarmState.isFarming then return end
    FarmState.isFarming = true
    table.clear(FarmState.ignoredCoins)
    task.spawn(function()
        while FarmState.isFarming do
            task.wait()
            local success, err = pcall(function()
                if hasNearbyMurderer() then
                    FarmState.isActivelyFlying = false
                    FarmState.currentTargetCoin = nil
                    removePhysics()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then hum.Sit = false end
                    end
                    task.wait(1)
                    return
                end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                if not hrp or not torso or not humanoid or humanoid.Health <= 0 then
                    FarmState.isActivelyFlying = false
                    FarmState.currentTargetCoin = nil
                    removePhysics()
                    task.wait(1)
                    return
                end
                if isRoundOver() or isBagFull() then
                    FarmState.isActivelyFlying = false
                    FarmState.currentTargetCoin = nil
                    removePhysics()
                    if humanoid then humanoid.Sit = false end
                    task.wait(1)
                    return
                end
                if FarmSettings.AutoReset then
                    local coins = getCurrentCoins()
                    if coins >= FarmSettings.CoinLimit then
                        humanoid.Health = 0
                        task.wait(5)
                        return
                    end
                end
                local targetCoin = getNearestCoin(torso)
                if not targetCoin or not targetCoin:IsDescendantOf(workspace) then
                    FarmState.isActivelyFlying = false
                    FarmState.currentTargetCoin = nil
                    removePhysics()
                    if humanoid then humanoid.Sit = false end
                    task.wait(0.5)
                    return
                end
                FarmState.isActivelyFlying = true
                FarmState.currentTargetCoin = targetCoin
                local reachedTarget = false
                if FarmSettings.Mode == "Underground" then
                    setupNoclip()
                    local lockedRotation = applyFlightPhysics(char)
                    local targetPos = targetCoin.Position - Vector3.new(0, FarmSettings.UndergroundOffset, 0)
                    reachedTarget = flyToPoint(targetPos, targetCoin, hrp, torso, lockedRotation)
                elseif FarmSettings.Mode == "Sit" then
                    reachedTarget = tweenToCoin(targetCoin)
                    if reachedTarget and FarmState.isFarming and humanoid.Health > 0 then
                        collectCoin(targetCoin)
                    end
                end
                if reachedTarget and FarmState.isFarming and humanoid.Health > 0 then
                    FarmState.ignoredCoins[targetCoin] = true
                    task.delay(5, function()
                        FarmState.ignoredCoins[targetCoin] = nil
                    end)
                    task.wait(0.2)
                end
                FarmState.currentTargetCoin = nil
            end)
            if not success then
                FarmState.isActivelyFlying = false
                FarmState.currentTargetCoin = nil
                removePhysics()
                task.wait(1)
            end
        end
    end)
end

function StopFarming()
    FarmState.isFarming = false
    FarmState.isActivelyFlying = false
    FarmState.currentTargetCoin = nil
    if FarmState.currentTween then
        pcall(function() FarmState.currentTween:Cancel() end)
        FarmState.currentTween = nil
    end
    removePhysics()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end
end

RunService.Stepped:Connect(function()
    if not FarmState.isFarming or not FarmState.isActivelyFlying or FarmSettings.Mode ~= "Underground" then return end
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end)
-- ==================== END AUTOFARM ====================

local function executeBombJump()
    if Features.BombJumpOnCooldown then
        return
    end
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild('HumanoidRootPart')
    local hum = char:FindFirstChildOfClass('Humanoid')
    if not hrp or not hum then
        return
    end
    local hasBomb = char:FindFirstChild('FakeBomb') or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild('FakeBomb'))
    if not hasBomb then
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild('Remotes', true)
            if remotes then
                local extras = remotes:FindFirstChild('Extras', true)
                if extras then
                    local replicate = extras:FindFirstChild('ReplicateToy')
                    if replicate then
                        replicate:InvokeServer('FakeBomb')
                    end
                end
            end
        end)
        task.wait(0.3)
    end
    Features.BombJumpOnCooldown = true
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    hrp.Velocity = Vector3.new(hrp.Velocity.X, 120, hrp.Velocity.Z)
    local bomb = char:FindFirstChild('FakeBomb')
    if bomb and bomb:IsA('Tool') then
        pcall(function()
            bomb:Activate()
        end)
    end
    task.delay(1.2, function()
        Features.BombJumpOnCooldown = false
    end)
end

local function killAll()
    local char = LocalPlayer.Character
    if not char then return end
    
    local knife = char:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
    if not knife then
        return
    end
    
    -- Берём нож в руку если в backpack
    if knife.Parent == LocalPlayer.Backpack then
        char.Humanoid:EquipTool(knife)
        task.wait(0.1)
    end
    
    -- Находим RemoteEvent
    local handleTouched = knife:FindFirstChild("Events") and knife.Events:FindFirstChild("HandleTouched")
    
    if handleTouched then
        -- Собираем цели
        local targets = {}
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = target.Character:FindFirstChild("Humanoid")
                if hrp and humanoid and humanoid.Health > 0 then
                    table.insert(targets, hrp)
                end
            end
        end
        
        -- Файрим remote по каждому
        for _, hrp in pairs(targets) do
            pcall(function()
                handleTouched:FireServer(hrp)
            end)
            task.wait(0.05)
        end
        
        -- Анимация удара
        local stabbed = knife:FindFirstChild("KnifeStabbed")
        if stabbed then
            pcall(function()
                stabbed:FireServer()
            end)
        end
    else
        -- Альтернатива через firetouchinterest
        local knifeHandle = knife:FindFirstChild("Handle")
        if knifeHandle then
            for _, target in ipairs(Players:GetPlayers()) do
                if target ~= LocalPlayer and target.Character then
                    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = target.Character:FindFirstChild("Humanoid")
                    if hrp and humanoid and humanoid.Health > 0 then
                        pcall(function()
                            firetouchinterest(knifeHandle, hrp, 0)
                            task.wait(0.05)
                            firetouchinterest(knifeHandle, hrp, 1)
                            task.wait(0.05)
                        end)
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if Config.Settings.Combat.AutoKillAll then
            pcall(killAll)
        end
        task.wait(0.3)
    end
end)

addConn(RunService.Heartbeat:Connect(function()
    if not Config.Settings.Combat.AntiFling then
        return
    end
    local char = LocalPlayer.Character
    if not char then
        return
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA('BasePart') then
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                    for _, otherPart in ipairs(otherPlayer.Character:GetDescendants()) do
                        if otherPart:IsA('BasePart') then
                            pcall(function()
                                part.CanCollide = false
                                local nc = Instance.new('NoCollisionConstraint')
                                nc.Part0 = part
                                nc.Part1 = otherPart
                                nc.Parent = part
                                game:GetService('Debris'):AddItem(nc, 0.1)
                            end)
                        end
                    end
                end
            end
        end
    end
end))

local function Hat_RemoveClassic()
    if HatVariables.parts[LocalPlayer.Character] then
        HatVariables.parts[LocalPlayer.Character]:Destroy()
        HatVariables.parts[LocalPlayer.Character] = nil
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
    for char, hat in pairs(HatVariables.parts) do
        if hat and hat.Parent and char == LocalPlayer.Character then
            hat.Transparency = HatVariables.transparency
            hat.Reflectance = HatVariables.reflectance
            if HatVariables.rainbow then
                hat.Color = Color3.fromHSV(tick() % HatVariables.rainbowSpeed / HatVariables.rainbowSpeed, 1, 1)
            else
                hat.Color = HatVariables.color
            end
            local mesh = hat:FindFirstChildOfClass('SpecialMesh')
            if mesh then
                mesh.Scale = Vector3.new(HatVariables.radius, HatVariables.height, HatVariables.radius)
            end
        end
    end
end

local function Hat_UpdateDrawing()
    local pass = HatVariables.enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head') and (camera.CFrame.p - camera.Focus.p).magnitude > 1 and LocalPlayer.Character.Humanoid.Health > 0
    for i = 1, #drawings do
        local line, triangle = drawings[i][1], drawings[i][2]
        if pass and HatVariables.style == 'Drawing' then
            local color
            if HatVariables.rainbow then
                color = Color3.fromHSV((tick() % HatVariables.rainbowSpeed / HatVariables.rainbowSpeed - (i / #drawings)) % 1, 0.5, 1)
            else
                color = HatVariables.color
            end
            local pos = LocalPlayer.Character.Head.Position + Vector3.new(0, 0.75, 0)
            local topWorld = pos + Vector3.new(0, 0.75, 0)
            local last, next = (i / HatVariables.sides) * tau, ((i + 1) / HatVariables.sides) * tau
            local lastWorld = pos + (Vector3.new(math.cos(last), 0, math.sin(last)) * HatVariables.radius)
            local nextWorld = pos + (Vector3.new(math.cos(next), 0, math.sin(next)) * HatVariables.radius)
            local lastScreen = camera:WorldToViewportPoint(lastWorld)
            local nextScreen = camera:WorldToViewportPoint(nextWorld)
            local topScreen = camera:WorldToViewportPoint(topWorld)
            line.From = Vector2.new(lastScreen.X, lastScreen.Y)
            line.To = Vector2.new(nextScreen.X, nextScreen.Y)
            line.Color = color
            line.Visible = true
            triangle.PointA = Vector2.new(topScreen.X, topScreen.Y)
            triangle.PointB = Vector2.new(lastScreen.X, lastScreen.Y)
            triangle.PointC = Vector2.new(nextScreen.X, nextScreen.Y)
            triangle.Color = color
            triangle.Transparency = HatVariables.transparency
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
        if HatVariables.style == 'Classic' and LocalPlayer.Character then
            Hat_AddClassic(LocalPlayer.Character)
        end
        if not HatVariables.connection then
            HatVariables.connection = RunService.RenderStepped:Connect(function()
                if HatVariables.style == 'Classic' then
                    Hat_UpdateClassic()
                else
                    Hat_UpdateDrawing()
                end
            end)
        end
    else
        Hat_RemoveClassic()
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

local function Hat_ChangeStyle(value)
    HatVariables.style = value
    if HatVariables.enabled then
        Hat_RemoveClassic()
        for i = 1, #drawings do
            drawings[i][1].Visible = false
            drawings[i][2].Visible = false
        end
        if value == 'Classic' and LocalPlayer.Character then
            Hat_AddClassic(LocalPlayer.Character)
        end
    end
end

local function Hat_UpdateSides(value)
    HatVariables.sides = value
    for i = 1, #drawings do
        drawings[i][1]:Remove()
        drawings[i][2]:Remove()
    end
    drawings = {}
    for i = 1, value do
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

local function Trail_RemoveFromCharacter(char)
    if TrailVariables.parts[char] then
        for _, t in ipairs(TrailVariables.parts[char]) do
            if t then
                t:Destroy()
            end
        end
        TrailVariables.parts[char] = nil
    end
end

local function Trail_AddToCharacter(char)
    Trail_RemoveFromCharacter(char)
    local hrp = char:FindFirstChild('HumanoidRootPart')
    if not hrp then
        return
    end
    local trails = {}
    local function makeTrail(attach0, attach1)
        local trail = Instance.new('Trail')
        trail.Attachment0 = attach0
        trail.Attachment1 = attach1
        trail.Lifetime = TrailVariables.lifetime
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, TrailVariables.transparencyStart),
            NumberSequenceKeypoint.new(1, 1),
        })
        trail.FaceCamera = true
        trail.Parent = hrp
        return trail
    end
    local a0 = Instance.new('Attachment')
    a0.Position = Vector3.new(0, 1, 0)
    a0.Parent = hrp
    local a1 = Instance.new('Attachment')
    a1.Position = Vector3.new(0, -1, 0)
    a1.Parent = hrp
    local trail = makeTrail(a0, a1)
    if TrailVariables.isGradient then
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, TrailVariables.gradient1),
            ColorSequenceKeypoint.new(1, TrailVariables.gradient2),
        })
    elseif TrailVariables.rainbow then
    else
        trail.Color = ColorSequence.new(TrailVariables.colorStatic)
    end
    table.insert(trails, trail)
    table.insert(trails, a0)
    table.insert(trails, a1)
    TrailVariables.parts[char] = trails
end

local function Trail_UpdateAll()
    for char, parts in pairs(TrailVariables.parts) do
        for _, t in ipairs(parts) do
            if t:IsA('Trail') then
                t.Lifetime = TrailVariables.lifetime
                t.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, TrailVariables.transparencyStart),
                    NumberSequenceKeypoint.new(1, 1),
                })
                if TrailVariables.isGradient then
                    t.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, TrailVariables.gradient1),
                        ColorSequenceKeypoint.new(1, TrailVariables.gradient2),
                    })
                elseif not TrailVariables.rainbow then
                    t.Color = ColorSequence.new(TrailVariables.colorStatic)
                end
            end
        end
    end
end

local function Trail_ToggleEnabled(value)
    TrailVariables.enabled = value
    if value and LocalPlayer.Character then
        Trail_AddToCharacter(LocalPlayer.Character)
    else
        if LocalPlayer.Character then
            Trail_RemoveFromCharacter(LocalPlayer.Character)
        end
    end
end

local function ForceField_Apply(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA('BasePart') and part.Name ~= 'HumanoidRootPart' then
            if not ForceFieldVariables.originalColors[part] then
                ForceFieldVariables.originalColors[part] = part.Color
            end
            part.Material = Enum.Material.ForceField
            part.Color = ForceFieldVariables.rainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or ForceFieldVariables.color
        end
    end
end

local function ForceField_Remove(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA('BasePart') and ForceFieldVariables.originalColors[part] then
            part.Material = Enum.Material.Plastic
            part.Color = ForceFieldVariables.originalColors[part]
        end
    end
end

local function ForceField_Update()
    if ForceFieldVariables.enabled and LocalPlayer.Character then
        ForceField_Apply(LocalPlayer.Character)
    end
end

local function ForceField_ToggleEnabled(value)
    ForceFieldVariables.enabled = value
    if value and LocalPlayer.Character then
        ForceField_Apply(LocalPlayer.Character)
        if not ForceFieldVariables.connection then
            ForceFieldVariables.connection = RunService.Heartbeat:Connect(function()
                if ForceFieldVariables.rainbow and ForceFieldVariables.enabled and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA('BasePart') and part.Material == Enum.Material.ForceField then
                            part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        end
                    end
                end
            end)
        end
    else
        if LocalPlayer.Character then
            ForceField_Remove(LocalPlayer.Character)
        end
        if ForceFieldVariables.connection then
            ForceFieldVariables.connection:Disconnect()
            ForceFieldVariables.connection = nil
        end
    end
end

local function AuraTrailer_Toggle(value)
    AuraTrailerVariables.enabled = value
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild('HumanoidRootPart')
    if not hrp then
        return
    end
    local existing = hrp:FindFirstChild('CandyAuraTrailer')
    if existing then
        existing:Destroy()
    end
    if value then
        local att0 = Instance.new('Attachment')
        att0.Name = 'CandyAuraTrailer'
        att0.Parent = hrp
        local att1 = Instance.new('Attachment')
        att1.Position = Vector3.new(0, -2, 0)
        att1.Parent = hrp
        local trail = Instance.new('Trail')
        trail.Attachment0 = att0
        trail.Attachment1 = att1
        trail.Color = ColorSequence.new(AuraTrailerVariables.color)
        trail.Lifetime = AuraTrailerVariables.lifetime
        trail.FaceCamera = true
        trail.Parent = hrp
    end
end

local function AuraTrailer_Update()
    if AuraTrailerVariables.enabled then
        AuraTrailer_Toggle(true)
    end
end

local function Skybox_Apply(name)
    local data = SkyboxAssets[name]
    if not data then
        return
    end
    local sky = Lighting:FindFirstChildOfClass('Sky')
    if not sky then
        sky = Instance.new('Sky')
        sky.Parent = Lighting
    end
    sky.SkyboxBk = data.Bk
    sky.SkyboxDn = data.Dn
    sky.SkyboxFt = data.Ft
    sky.SkyboxLf = data.Lf
    sky.SkyboxRt = data.Rt
    sky.SkyboxUp = data.Up
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
    end
end

local function Nebula_Enable()
    local bloom = Instance.new('BloomEffect')
    bloom.Name = 'NebulaBloom'
    bloom.Intensity = 1.2
    bloom.Size = 24
    bloom.Threshold = 0.8
    bloom.Parent = Lighting
    local cc = Instance.new('ColorCorrectionEffect')
    cc.Name = 'NebulaColorCorrection'
    cc.TintColor = NebulaVariables.themeColor
    cc.Parent = Lighting
    local a = Instance.new('Atmosphere')
    a.Name = 'NebulaAtmosphere'
    a.Color = NebulaVariables.themeColor
    a.Decay = Color3.fromRGB(173, 216, 230)
    a.Parent = Lighting
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
    }) do
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
        AnimeVariables.gui = Instance.new('ScreenGui')
        AnimeVariables.gui.Name = 'AnimeImageGui'
        AnimeVariables.gui.ResetOnSpawn = false
        AnimeVariables.gui.Parent = LocalPlayer:WaitForChild('PlayerGui')
        local imageLabel = Instance.new('ImageLabel')
        imageLabel.Name = 'AnimeImage'
        imageLabel.Image = 'http://www.roblox.com/asset/?id=117783035423570'
        imageLabel.Size = UDim2.new(0, 350, 0, 400)
        imageLabel.Position = UDim2.new(1, -25, 0, 10)
        imageLabel.AnchorPoint = Vector2.new(1, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Parent = AnimeVariables.gui
    else
        if AnimeVariables.gui then
            AnimeVariables.gui:Destroy()
            AnimeVariables.gui = nil
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if HatVariables.enabled and HatVariables.style == 'Classic' then
        Hat_AddClassic(char)
    end
    if TrailVariables.enabled then
        Trail_AddToCharacter(char)
    end
    if ForceFieldVariables.enabled then
        ForceField_Apply(char)
    end
    if AuraTrailerVariables.enabled then
        AuraTrailer_Toggle(true)
    end
    if AnimeVariables.enabled then
        Anime_Toggle(true)
    end
end)

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

print('\u{26a1} [CANDY ZONE] All features loaded')

local GUI = {
    ScreenGui = nil,
    TopBar = {},
    Main = {
        IsOpen = false,
        CurrentTab = 'Visuals',
        Blur = nil,
        Window = nil,
        Nav = {},
        Content = nil,
    },
    ToggleStates = {},
}

function GUI:Initialize()
    self.ScreenGui = Instance.new('ScreenGui')
    self.ScreenGui.Name = 'CandyZoneMM2_' .. HttpService:GenerateGUID(false):sub(1, 8)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.DisplayOrder = 999999999
    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = CoreGui
    else
        self.ScreenGui.Parent = CoreGui
    end
    self:CreateTopBar()
    self:CreateMainWindow()
end

function GUI:CreateTopBar()
    local container = Instance.new('Frame')
    container.Name = 'TopBar'
    container.Size = UDim2.new(0, 410, 0, Config.Size.TopBar.Height)
    container.Position = UDim2.new(0, 15, 0, 15)
    container.BackgroundTransparency = 1
    container.ZIndex = 100
    container.Parent = self.ScreenGui
    local candyBtn = self:CreateTopBarBlock('Candy Zone', 110, 0, true)
    candyBtn.MouseButton1Click:Connect(function()
        self:ToggleMain()
    end)
    candyBtn.Parent = container
    self.TopBar.CandyBtn = candyBtn
    local fpsBlock = self:CreateTopBarBlock('FPS: 60', 70, 118, false)
    fpsBlock.Parent = container
    self.TopBar.FPS = fpsBlock
    local gameBlock = self:CreateTopBarBlock(Util:GetGameName(), 110, 196, false)
    gameBlock.Parent = container
    self.TopBar.Game = gameBlock
    local playerBlock = self:CreateTopBarBlock(Util:GetPlayerName(), 120, 314, false)
    playerBlock.Parent = container
    self.TopBar.Player = playerBlock
    task.spawn(function()
        while task.wait(0.5) do
            if self.TopBar.FPS and self.TopBar.FPS.Parent then
                self.TopBar.FPS.Text = 'FPS: ' .. FPS.current
                Util:Tween(self.TopBar.FPS, {
                    TextColor3 = FPS:GetColor(),
                }, 0.3)
            else
                break
            end
        end
    end)
end

function GUI:CreateTopBarBlock(text, width, xPos, isButton)
    local block = Instance.new(isButton and 'TextButton' or 'TextLabel')
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
    local glow = Instance.new('TextLabel')
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
            Util:Tween(block, {
                BackgroundColor3 = Config.Color.Background.Hover,
            }, Config.Anim.Fast)
            Util:Tween(glow, { TextTransparency = 0.65 }, Config.Anim.Fast)
        end)
        block.MouseLeave:Connect(function()
            Util:Tween(block, {
                BackgroundColor3 = Config.Color.Background.Primary,
            }, Config.Anim.Fast)
            Util:Tween(glow, { TextTransparency = 0.85 }, Config.Anim.Fast)
        end)
        Util:Ripple(block)
    end
    return block
end

function GUI:CreateMainWindow()
    self.Main.Blur = Instance.new('Frame')
    self.Main.Blur.Size = UDim2.new(1, 0, 1, 0)
    self.Main.Blur.BackgroundColor3 = Color3.new(0, 0, 0)
    self.Main.Blur.BackgroundTransparency = 1
    self.Main.Blur.Visible = false
    self.Main.Blur.ZIndex = 50
    self.Main.Blur.Parent = self.ScreenGui
    self.Main.Window = Instance.new('Frame')
    self.Main.Window.Size = UDim2.new(0, Config.Size.Window.Width, 0, Config.Size.Window.Height)
    self.Main.Window.Position = UDim2.new(0.5, -Config.Size.Window.Width / 2, 0.5, -Config.Size.Window.Height / 2)
    self.Main.Window.BackgroundColor3 = Config.Color.Background.Main
    self.Main.Window.BackgroundTransparency = 0.1
    self.Main.Window.BorderSizePixel = 0
    self.Main.Window.Visible = false
    self.Main.Window.ZIndex = 51
    self.Main.Window.Parent = self.ScreenGui
    Util:Corner(self.Main.Window, Config.Size.Window.Radius)
    Util:Stroke(self.Main.Window, 1.5, Config.Color.Accent.White, 0.85)
    self:CreateAccentBar()
    Snow:Create(self.Main.Window)
    self:CreateTitleBar()
    self:CreateNavigation()
    self:CreateContentArea()
    self:LoadTab('Visuals')
end

function GUI:CreateAccentBar()
    local bar = Instance.new('Frame')
    bar.Name = 'AccentBar'
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = Config.Color.Accent.White
    bar.BorderSizePixel = 0
    bar.ZIndex = 60
    bar.Parent = self.Main.Window
    local grad = Util:Gradient(bar, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    }, 90)
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
    local bar = Instance.new('Frame')
    bar.Size = UDim2.new(1, 0, 0, 45)
    bar.BackgroundTransparency = 1
    bar.ZIndex = 52
    bar.Parent = self.Main.Window
    local title = Instance.new('TextLabel')
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = 'CANDY ZONE MM2'
    title.TextColor3 = Config.Color.Text.Primary
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 53
    title.Parent = bar
    local version = Instance.new('TextLabel')
    version.Size = UDim2.new(0, 120, 1, 0)
    version.Position = UDim2.new(0, 160, 0, 0)
    version.BackgroundTransparency = 1
    version.Font = Enum.Font.GothamBold
    version.Text = 'v' .. Config.Version
    version.TextColor3 = Config.Color.Accent.Gray
    version.TextSize = 9
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.TextTransparency = 0.4
    version.ZIndex = 53
    version.Parent = bar
    local close = Instance.new('TextButton')
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -40, 0, 7)
    close.BackgroundColor3 = Config.Color.Background.Secondary
    close.BackgroundTransparency = 0.3
    close.BorderSizePixel = 0
    close.Font = Enum.Font.GothamBold
    close.Text = 'X'
    close.TextColor3 = Config.Color.Text.Primary
    close.TextSize = 14
    close.AutoButtonColor = false
    close.ZIndex = 54
    close.Parent = bar
    Util:Corner(close, 6)
    Util:Stroke(close, 1, Config.Color.Accent.White, 0.8)
    close.MouseEnter:Connect(function()
        Util:Tween(close, {
            BackgroundColor3 = Config.Color.State.Error,
        }, Config.Anim.Fast)
    end)
    close.MouseLeave:Connect(function()
        Util:Tween(close, {
            BackgroundColor3 = Config.Color.Background.Secondary,
        }, Config.Anim.Fast)
    end)
    close.MouseButton1Click:Connect(function()
        self:ToggleMain()
    end)
    Util:Ripple(close)
    local div = Instance.new('Frame')
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 1, -1)
    div.BackgroundColor3 = Config.Color.Accent.White
    div.BackgroundTransparency = 0.9
    div.BorderSizePixel = 0
    div.ZIndex = 52
    div.Parent = bar
end

function GUI:CreateNavigation()
    local nav = Instance.new('Frame')
    nav.Size = UDim2.new(0, Config.Size.Nav.Width, 1, -65)
    nav.Position = UDim2.new(0, 15, 0, 55)
    nav.BackgroundTransparency = 1
    nav.ZIndex = 52
    nav.Parent = self.Main.Window
    local tabs = {
        { name = 'Visuals', icon = 'V' },
        { name = 'Combat', icon = 'C' },
        { name = 'Rage', icon = 'R' },
        { name = 'Fun', icon = 'F' },
        { name = 'Settings', icon = 'S' },
        { name = 'Misc', icon = 'M' },
    }
    local yPos = 0
    for i, tab in ipairs(tabs) do
        local btn = self:CreateNavButton(tab.name, tab.icon, yPos, i == 1)
        btn.Parent = nav
        self.Main.Nav[tab.name] = btn
        yPos = yPos + Config.Size.Nav.ButtonHeight + Config.Size.Nav.Spacing
    end
end

function GUI:CreateNavButton(name, icon, yPos, isActive)
    local btn = Instance.new('TextButton')
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, Config.Size.Nav.ButtonHeight)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = isActive and Config.Color.Background.Active or Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ''
    btn.ZIndex = 53
    Util:Corner(btn, Config.Size.Nav.Radius)
    Util:Stroke(btn, 0.5, Config.Color.Accent.White, 0.92)
    local indicator = Instance.new('Frame')
    indicator.Name = 'Indicator'
    indicator.Size = UDim2.new(0, 3, 1, -10)
    indicator.Position = UDim2.new(0, 2, 0, 5)
    indicator.BackgroundColor3 = Config.Color.Accent.White
    indicator.BorderSizePixel = 0
    indicator.Visible = isActive
    indicator.ZIndex = 54
    Util:Corner(indicator, 999)
    indicator.Parent = btn
    local iconLbl = Instance.new('TextLabel')
    iconLbl.Size = UDim2.new(0, 25, 1, 0)
    iconLbl.Position = UDim2.new(0, 12, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Text = icon
    iconLbl.TextColor3 = Config.Color.Text.Primary
    iconLbl.TextSize = 14
    iconLbl.ZIndex = 54
    iconLbl.Parent = btn
    local textLbl = Instance.new('TextLabel')
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
    local glow = Instance.new('TextLabel')
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
    btn.MouseEnter:Connect(function()
        if self.Main.CurrentTab ~= name then
            Util:Tween(btn, {
                BackgroundColor3 = Config.Color.Background.Hover,
            }, Config.Anim.Fast)
            Util:Tween(glow, { TextTransparency = 0.75 }, Config.Anim.Fast)
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.Main.CurrentTab ~= name then
            Util:Tween(btn, {
                BackgroundColor3 = Config.Color.Background.Secondary,
            }, Config.Anim.Fast)
            Util:Tween(glow, { TextTransparency = 0.92 }, Config.Anim.Fast)
        end
    end)
    btn.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    Util:Ripple(btn)
    return btn
end

function GUI:CreateContentArea()
    self.Main.Content = Instance.new('ScrollingFrame')
    self.Main.Content.Size = UDim2.new(1, -(Config.Size.Nav.Width + 40), 1, -75)
    self.Main.Content.Position = UDim2.new(0, Config.Size.Nav.Width + 20, 0, 60)
    self.Main.Content.BackgroundTransparency = 1
    self.Main.Content.BorderSizePixel = 0
    self.Main.Content.ScrollBarThickness = 5
    self.Main.Content.ScrollBarImageColor3 = Config.Color.Accent.White
    self.Main.Content.ScrollBarImageTransparency = 0.7
    self.Main.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Main.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Main.Content.ScrollingDirection = Enum.ScrollingDirection.Y
    self.Main.Content.ElasticBehavior = Enum.ElasticBehavior.Never
    self.Main.Content.ZIndex = 52
    self.Main.Content.Parent = self.Main.Window
    local list = Instance.new('UIListLayout')
    list.Padding = UDim.new(0, 8)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = self.Main.Content
    local pad = Instance.new('UIPadding')
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 5)
    pad.Parent = self.Main.Content
    list:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
        local contentHeight = list.AbsoluteContentSize.Y + 10
        local viewHeight = self.Main.Content.AbsoluteSize.Y
        if contentHeight <= viewHeight then
            self.Main.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
            self.Main.Content.CanvasPosition = Vector2.new(0, 0)
        else
            self.Main.Content.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        end
    end)
end

function GUI:SwitchTab(tabName)
    if self.Main.CurrentTab == tabName then
        return
    end
    for name, btn in pairs(self.Main.Nav) do
        local indicator = btn:FindFirstChild('Indicator')
        local glow = btn:FindFirstChild('TextLabel')
        if name == tabName then
            Util:Tween(btn, {
                BackgroundColor3 = Config.Color.Background.Active,
            }, Config.Anim.Normal)
            if indicator then
                indicator.Visible = true
            end
            if glow then
                Util:Tween(glow, { TextTransparency = 0.65 }, Config.Anim.Fast)
            end
        else
            Util:Tween(btn, {
                BackgroundColor3 = Config.Color.Background.Secondary,
            }, Config.Anim.Normal)
            if indicator then
                indicator.Visible = false
            end
            if glow then
                Util:Tween(glow, { TextTransparency = 0.92 }, Config.Anim.Fast)
            end
        end
    end
    self.Main.CurrentTab = tabName
    self:LoadTab(tabName)
end

function GUI:LoadTab(tabName)
    for _, child in ipairs(self.Main.Content:GetChildren()) do
        if not child:IsA('UIListLayout') and not child:IsA('UIPadding') then
            child:Destroy()
        end
    end
    self.Main.Content.CanvasPosition = Vector2.new(0, 0)
    if tabName == 'Visuals' then
        self:CreateVisualsTab()
    elseif tabName == 'Combat' then
        self:CreateCombatTab()
    elseif tabName == 'Rage' then
        self:CreateRageTab()
    elseif tabName == 'Fun' then
        self:CreateFunTab()
    elseif tabName == 'Settings' then
        self:CreateSettingsTab()
    elseif tabName == 'Misc' then
        self:CreateMiscTab()
    end
end

function GUI:CreateSection(title)
    local section = Instance.new('Frame')
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Config.Color.Background.Secondary
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.ZIndex = 53
    section.Parent = self.Main.Content
    Util:Corner(section, 8)
    Util:Stroke(section, 1, Config.Color.Accent.White, 0.88)
    local titleLbl = Instance.new('TextLabel')
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
    local container = Instance.new('Frame')
    container.Name = 'Container'
    container.Size = UDim2.new(1, -20, 0, 0)
    container.Position = UDim2.new(0, 10, 0, 32)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ZIndex = 53
    container.Parent = section
    local list = Instance.new('UIListLayout')
    list.Padding = UDim.new(0, 6)
    list.Parent = container
    local pad = Instance.new('UIPadding')
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = section
    return container
end

function GUI:CreateToggle(parent, text, default, callback)
    local stateKey = text
    if self.ToggleStates[stateKey] ~= nil then
        default = self.ToggleStates[stateKey]
    end
    
    local toggle = Instance.new('Frame')
    toggle.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    toggle.BackgroundColor3 = Config.Color.Background.Input
    toggle.BackgroundTransparency = 0.5
    toggle.BorderSizePixel = 0
    toggle.ZIndex = 54
    toggle.Parent = parent
    Util:Corner(toggle, 6)
    Util:Stroke(toggle, 0.5, Config.Color.Accent.White, 0.9)
    local label = Instance.new('TextLabel')
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
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(0, Config.Size.Toggle.Width, 0, Config.Size.Toggle.Height)
    btn.Position = UDim2.new(1, -45, 0.5, -10)
    btn.BackgroundColor3 = default and Config.Color.State.Success or Config.Color.Background.Primary
    btn.BorderSizePixel = 0
    btn.Text = ''
    btn.AutoButtonColor = false
    btn.ZIndex = 55
    btn.Parent = toggle
    Util:Corner(btn, 999)
    local dot = Instance.new('Frame')
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
        self.ToggleStates[stateKey] = state
        Util:Tween(btn, {
            BackgroundColor3 = state and Config.Color.State.Success or Config.Color.Background.Primary,
        }, Config.Anim.Fast)
        Util:Tween(dot, {
            Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        }, Config.Anim.Normal)
        if callback then
            pcall(callback, state)
        end
    end)
    return toggle
end

function GUI:CreateSlider(parent, text, min, max, default, callback)
    local slider = Instance.new('Frame')
    slider.Size = UDim2.new(1, 0, 0, 44)
    slider.BackgroundColor3 = Config.Color.Background.Input
    slider.BackgroundTransparency = 0.5
    slider.BorderSizePixel = 0
    slider.ZIndex = 54
    slider.Parent = parent
    Util:Corner(slider, 6)
    Util:Stroke(slider, 0.5, Config.Color.Accent.White, 0.9)
    local label = Instance.new('TextLabel')
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
    local value = Instance.new('TextLabel')
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
    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(1, -20, 0, Config.Size.Slider.Height)
    bg.Position = UDim2.new(0, 10, 1, -14)
    bg.BackgroundColor3 = Config.Color.Background.Primary
    bg.BorderSizePixel = 0
    bg.ZIndex = 55
    Util:Corner(bg, 999)
    bg.Parent = slider
    local fill = Instance.new('Frame')
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.Color.Accent.White
    fill.BorderSizePixel = 0
    fill.ZIndex = 56
    Util:Corner(fill, 999)
    fill.Parent = bg
    local handle = Instance.new('Frame')
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
        local absPos = bg.AbsolutePosition
        local absSize = bg.AbsoluteSize
        local x = Util:Clamp(input.Position.X - absPos.X, 0, absSize.X)
        local percent = absSize.X > 0 and (x / absSize.X) or 0
        currentValue = Util:Round(min + (max - min) * percent, 0)
        value.Text = tostring(currentValue)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        if callback then
            pcall(callback, currentValue)
        end
    end
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end
    bg.InputBegan:Connect(beginDrag)
    fill.InputBegan:Connect(beginDrag)
    handle.InputBegan:Connect(beginDrag)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return slider
end

function GUI:CreateButton(parent, text, callback)
    local btn = Instance.new('TextButton')
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Config.Color.Background.Secondary
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Config.Color.Text.Primary
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.ZIndex = 54
    btn.Parent = parent
    Util:Corner(btn, 6)
    local stroke = Util:Stroke(btn, 1, Config.Color.Accent.White, 0.85)
    btn.MouseEnter:Connect(function()
        Util:Tween(btn, {
            BackgroundColor3 = Config.Color.Background.Hover,
        }, Config.Anim.Fast)
        Util:Tween(stroke, { Transparency = 0.6 }, Config.Anim.Fast)
    end)
    btn.MouseLeave:Connect(function()
        Util:Tween(btn, {
            BackgroundColor3 = Config.Color.Background.Secondary,
        }, Config.Anim.Fast)
        Util:Tween(stroke, { Transparency = 0.85 }, Config.Anim.Fast)
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
    Util:Ripple(btn)
    return btn
end

function GUI:CreateColorPicker(parent, text, defaultColor, callback)
    local picker = Instance.new('Frame')
    picker.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    picker.BackgroundColor3 = Config.Color.Background.Input
    picker.BackgroundTransparency = 0.5
    picker.BorderSizePixel = 0
    picker.ZIndex = 54
    picker.Parent = parent
    Util:Corner(picker, 6)
    Util:Stroke(picker, 0.5, Config.Color.Accent.White, 0.9)
    local label = Instance.new('TextLabel')
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
    local colorBox = Instance.new('TextButton')
    colorBox.Size = UDim2.new(0, 35, 0, 20)
    colorBox.Position = UDim2.new(1, -45, 0.5, -10)
    colorBox.BackgroundColor3 = defaultColor
    colorBox.BorderSizePixel = 0
    colorBox.Text = ''
    colorBox.AutoButtonColor = false
    colorBox.ZIndex = 55
    Util:Corner(colorBox, 4)
    colorBox.Parent = picker
    local currentColor = defaultColor
    local expanded = false
    local presetFrame = nil
    colorBox.MouseButton1Click:Connect(function()
        if expanded and presetFrame then
            presetFrame:Destroy()
            presetFrame = nil
            expanded = false
            return
        end
        expanded = true
        presetFrame = Instance.new('Frame')
        presetFrame.Size = UDim2.new(1, 0, 0, 70)
        presetFrame.BackgroundColor3 = Config.Color.Background.Secondary
        presetFrame.BackgroundTransparency = 0.2
        presetFrame.BorderSizePixel = 0
        presetFrame.ZIndex = 60
        presetFrame.Parent = parent
        Util:Corner(presetFrame, 6)
        Util:Stroke(presetFrame, 1, Config.Color.Accent.White, 0.7)
        local grid = Instance.new('UIGridLayout')
        grid.CellSize = UDim2.new(0, 28, 0, 28)
        grid.CellPadding = UDim2.new(0, 4, 0, 4)
        grid.FillDirectionMaxCells = 9
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.VerticalAlignment = Enum.VerticalAlignment.Center
        grid.Parent = presetFrame
        local pad = Instance.new('UIPadding')
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 6)
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.Parent = presetFrame
        for _, preset in ipairs(ColorPresets) do
            local pBtn = Instance.new('TextButton')
            pBtn.Size = UDim2.new(0, 28, 0, 28)
            pBtn.BackgroundColor3 = preset.Color
            pBtn.BorderSizePixel = 0
            pBtn.Text = ''
            pBtn.AutoButtonColor = false
            pBtn.ZIndex = 61
            Util:Corner(pBtn, 4)
            pBtn.Parent = presetFrame
            pBtn.MouseButton1Click:Connect(function()
                currentColor = preset.Color
                colorBox.BackgroundColor3 = currentColor
                if callback then
                    pcall(callback, currentColor)
                end
                if presetFrame then
                    presetFrame:Destroy()
                end
                expanded = false
                presetFrame = nil
            end)
        end
    end)
    return picker
end

function GUI:CreateLabel(parent, labelText, valueText)
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundColor3 = Config.Color.Background.Input
    frame.BackgroundTransparency = 0.6
    frame.BorderSizePixel = 0
    frame.ZIndex = 54
    frame.Parent = parent
    Util:Corner(frame, 6)
    local label = Instance.new('TextLabel')
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
    local value = Instance.new('TextLabel')
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
    local keybind = Instance.new('Frame')
    keybind.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    keybind.BackgroundColor3 = Config.Color.Background.Input
    keybind.BackgroundTransparency = 0.5
    keybind.BorderSizePixel = 0
    keybind.ZIndex = 54
    keybind.Parent = parent
    Util:Corner(keybind, 6)
    Util:Stroke(keybind, 0.5, Config.Color.Accent.White, 0.9)
    local label = Instance.new('TextLabel')
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
    local btn = Instance.new('TextButton')
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
        if listening then
            return
        end
        listening = true
        btn.Text = '...'
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                btn.Text = input.KeyCode.Name
                if callback then
                    pcall(callback, input.KeyCode)
                end
                listening = false
                connection:Disconnect()
            end
        end)
    end)
    return keybind
end

function GUI:CreateDropdown(parent, text, options, defaultOption, callback)
    local dropdown = Instance.new('Frame')
    dropdown.Size = UDim2.new(1, 0, 0, Config.Size.Element.Height)
    dropdown.BackgroundColor3 = Config.Color.Background.Input
    dropdown.BackgroundTransparency = 0.5
    dropdown.BorderSizePixel = 0
    dropdown.ZIndex = 54
    dropdown.Parent = parent
    Util:Corner(dropdown, 6)
    Util:Stroke(dropdown, 0.5, Config.Color.Accent.White, 0.9)
    local label = Instance.new('TextLabel')
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
    local btn = Instance.new('TextButton')
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
        if callback then
            pcall(callback, options[currentIndex])
        end
    end)
    return dropdown
end

function GUI:CreateVisualsTab()
    local targetEsp = self:CreateSection('Player — Target ESP')
    self:CreateToggle(targetEsp, 'Enable Target ESP', Config.Settings.ESP.TargetESP, function(s)
        TargetESPVariables.enabled = s
    end)
    self:CreateToggle(targetEsp, 'Rainbow Mode', TargetESPVariables.rainbow, function(s)
        TargetESPVariables.rainbow = s
    end)
    self:CreateSlider(targetEsp, 'ESP Size', 20, 100, TargetESPVariables.size, function(v)
        TargetESPVariables.size = v
    end)
    self:CreateSlider(targetEsp, 'Max Radius', 10, 150, TargetESPVariables.maxRadius, function(v)
        TargetESPVariables.maxRadius = v
    end)
    self:CreateColorPicker(targetEsp, 'Target ESP Color', TargetESPVariables.color, function(c)
        TargetESPVariables.color = c
    end)

    local arrowEsp = self:CreateSection('Player — Arrow ESP')
    self:CreateToggle(arrowEsp, 'Enable Arrow ESP', Config.Settings.ESP.ArrowESP, function(s)
        ArrowESPVariables.enabled = s
    end)
    self:CreateToggle(arrowEsp, 'Rainbow Mode', ArrowESPVariables.rainbow, function(s)
        ArrowESPVariables.rainbow = s
    end)
    self:CreateSlider(arrowEsp, 'Distance from Center', 50, 150, ArrowESPVariables.distance, function(v)
        ArrowESPVariables.distance = v
    end)
    self:CreateColorPicker(arrowEsp, 'Arrow Color', ArrowESPVariables.color, function(c)
        ArrowESPVariables.color = c
    end)

    local hatSec = self:CreateSection('Player — Chinese Hat')
    self:CreateToggle(hatSec, 'Enable Hat', false, function(s)
        Hat_ToggleEnabled(s)
    end)
    self:CreateDropdown(hatSec, 'Hat Style', { 'Classic', 'Drawing' }, 'Classic', function(v)
        Hat_ChangeStyle(v)
    end)
    self:CreateToggle(hatSec, 'Rainbow Mode', false, function(s)
        HatVariables.rainbow = s
    end)
    self:CreateSlider(hatSec, 'Rainbow Speed', 1, 20, 5, function(v)
        HatVariables.rainbowSpeed = v
    end)
    self:CreateSlider(hatSec, 'Transparency', 0, 100, 30, function(v)
        HatVariables.transparency = v / 100
    end)
    self:CreateSlider(hatSec, 'Radius', 5, 100, 24, function(v)
        HatVariables.radius = v / 10
    end)
    self:CreateSlider(hatSec, 'Height', 5, 50, 16, function(v)
        HatVariables.height = v / 10
    end)
    self:CreateColorPicker(hatSec, 'Hat Color', HatVariables.color, function(c)
        HatVariables.color = c
    end)

    local trailSec = self:CreateSection('Player — Trail')
    self:CreateToggle(trailSec, 'Enable Trail', false, function(s)
        Trail_ToggleEnabled(s)
    end)
    self:CreateToggle(trailSec, 'Gradient Mode', false, function(s)
        TrailVariables.isGradient = s
        if TrailVariables.enabled and LocalPlayer.Character then
            Trail_AddToCharacter(LocalPlayer.Character)
        end
    end)
    self:CreateSlider(trailSec, 'Lifetime', 1, 30, 5, function(v)
        TrailVariables.lifetime = v / 10
        Trail_UpdateAll()
    end)
    self:CreateToggle(trailSec, 'Rainbow', false, function(s)
        TrailVariables.rainbow = s
        Trail_UpdateAll()
    end)
    self:CreateColorPicker(trailSec, 'Static Color', TrailVariables.colorStatic, function(c)
        TrailVariables.colorStatic = c
        Trail_UpdateAll()
    end)

    local ffSec = self:CreateSection('Player — ForceField')
    self:CreateToggle(ffSec, 'Enable ForceField', false, function(s)
        ForceField_ToggleEnabled(s)
    end)
    self:CreateToggle(ffSec, 'Rainbow Mode', false, function(s)
        ForceFieldVariables.rainbow = s
        ForceField_Update()
    end)
    self:CreateColorPicker(ffSec, 'ForceField Color', ForceFieldVariables.color, function(c)
        ForceFieldVariables.color = c
        if ForceFieldVariables.enabled then
            ForceField_Apply(LocalPlayer.Character)
        end
    end)

local auraSec = self:CreateSection('Player — Aura Trailer')
    self:CreateToggle(auraSec, 'Enable Aura Trailer', false, function(s)
        AuraTrailer_Toggle(s)
    end)
    self:CreateColorPicker(auraSec, 'Aura Color', AuraTrailerVariables.color, function(c)
        AuraTrailerVariables.color = c
        if AuraTrailerVariables.enabled then
            AuraTrailer_Update()
        end
    end)
    self:CreateSlider(auraSec, 'Lifetime', 1, 30, 5, function(v)
        AuraTrailerVariables.lifetime = v / 10
        if AuraTrailerVariables.enabled then
            AuraTrailer_Update()
        end
    end)

    local modelsSec = self:CreateSection('Models')
    
    local SahurikVars = {
        enabled = false,
        modelId = "138151705692565",
        attached = false,
        connection = nil,
    }
    
    local function ApplySahurik(char)
        if not char then return end
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local success, result = pcall(function()
            return game:GetObjects("rbxassetid://" .. SahurikVars.modelId)[1]
        end)
        if success and result then
            local old = char:FindFirstChild("SahurikModel")
            if old then old:Destroy() end
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                    v.Transparency = 1
                elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                    v.Handle.Transparency = 1
                end
            end
            result.Name = "SahurikModel"
            result.Parent = char
            local targetPart = result:IsA("BasePart") and result or result:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                local weld = Instance.new("Weld")
                weld.Part0 = root
                weld.Part1 = targetPart
                weld.C0 = CFrame.new(0, 0, 0)
                weld.Parent = targetPart
                SahurikVars.attached = true
            end
        end
    end
    
    local function RemoveSahurik(char)
        if not char then return end
        local model = char:FindFirstChild("SahurikModel")
        if model then model:Destroy() end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 0
            elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
                v.Handle.Transparency = 0
            end
        end
        SahurikVars.attached = false
    end
    
    self:CreateToggle(modelsSec, 'Sahur Model', false, function(s)
        SahurikVars.enabled = s
        local char = LocalPlayer.Character
        if s then
            if char then ApplySahurik(char) end
            if not SahurikVars.connection then
                SahurikVars.connection = LocalPlayer.CharacterAdded:Connect(function(newChar)
                    task.wait(1)
                    if SahurikVars.enabled then ApplySahurik(newChar) end
                end)
            end
        else
            if char then RemoveSahurik(char) end
            if SahurikVars.connection then
                SahurikVars.connection:Disconnect()
                SahurikVars.connection = nil
            end
        end
    end)
    
    self:CreateButton(modelsSec, 'Apply Model Now', function()
        local char = LocalPlayer.Character
        if char and SahurikVars.enabled then
            RemoveSahurik(char)
            task.wait(0.1)
            ApplySahurik(char)
        end
    end)
    
    self:CreateButton(modelsSec, 'Remove Model', function()
        local char = LocalPlayer.Character
        if char then RemoveSahurik(char) end
        SahurikVars.enabled = false
        if SahurikVars.connection then
            SahurikVars.connection:Disconnect()
            SahurikVars.connection = nil
        end
    end)
    
    self:CreateLabel(modelsSec, 'Model Status', 'Ready')

    local hitsoundSec = self:CreateSection('HitSound')
    
    local gunshotOptions = { "None" }
    for name in pairs(HitsoundData.gunshotSounds) do
        table.insert(gunshotOptions, name)
    end
    table.sort(gunshotOptions)

    local knifeOptions = { "None" }
    for name in pairs(HitsoundData.knifeKillSounds) do
        table.insert(knifeOptions, name)
    end
    table.sort(knifeOptions)

    self:CreateDropdown(hitsoundSec, 'Gunshot Sound', gunshotOptions, HitsoundData.selectedGunshot, function(sound)
        HitsoundData.selectedGunshot = sound == "None" and nil or sound
    end)

    self:CreateButton(hitsoundSec, '🔊 Preview Gunshot', function()
        if HitsoundData.selectedGunshot and HitsoundData.selectedGunshot ~= "None" and HitsoundData.gunshotSounds[HitsoundData.selectedGunshot] then
            local previewSound = Instance.new("Sound")
            previewSound.SoundId = HitsoundData.gunshotSounds[HitsoundData.selectedGunshot]
            previewSound.Volume = 0.5
            previewSound.Parent = SoundService
            previewSound:Play()
            game:GetService("Debris"):AddItem(previewSound, 3)
        end
    end)

    self:CreateDropdown(hitsoundSec, 'Knife Kill Sound', knifeOptions, HitsoundData.selectedKnifeKill, function(sound)
        HitsoundData.selectedKnifeKill = sound == "None" and nil or sound
    end)

    self:CreateButton(hitsoundSec, '🔊 Preview Knife Kill', function()
        if HitsoundData.selectedKnifeKill and HitsoundData.selectedKnifeKill ~= "None" and HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill] then
            local previewSound = Instance.new("Sound")
            previewSound.SoundId = HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill]
            previewSound.Volume = 0.5
            previewSound.Parent = SoundService
            previewSound:Play()
            game:GetService("Debris"):AddItem(previewSound, 3)
        end
    end)

    self:CreateButton(hitsoundSec, '🗑️ Clear Selection', function()
        HitsoundData.selectedGunshot = "None"
        HitsoundData.selectedKnifeKill = "None"
        self:LoadTab('Visuals')
    end)

    local skySec = self:CreateSection('World — Skybox')
    local skyList = {}
    for k in pairs(SkyboxAssets) do
        table.insert(skyList, k)
    end
    table.sort(skyList)
    self:CreateDropdown(skySec, 'Select Skybox', skyList, 'HD', function(v)
        SkyboxVariables.current = v
        if SkyboxVariables.customEnabled then
            Skybox_Apply(v)
        end
    end)
    self:CreateToggle(skySec, 'Enable Skybox', false, function(s)
        SkyboxVariables.customEnabled = s
        if s then
            Skybox_Apply(SkyboxVariables.current)
        else
            Skybox_RestoreDefault()
        end
    end)

    local lightSec = self:CreateSection('World — Lighting')
    self:CreateToggle(lightSec, 'Time Changer', false, function(s)
        WorldVariables.timeEnabled = s
    end)
    self:CreateSlider(lightSec, 'Time (0-24)', 0, 24, 12, function(v)
        WorldVariables.timeValue = v
    end)
    self:CreateToggle(lightSec, 'Full Bright', false, function(s)
        WorldVariables.fullBrightEnabled = s
        if not s then
            Lighting.Brightness = defaultLighting.Brightness
            Lighting.GlobalShadows = defaultLighting.GlobalShadows
            Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
        end
    end)

    local nebulaSec = self:CreateSection('World — Nebula')
    self:CreateToggle(nebulaSec, 'Enable Nebula', false, function(s)
        NebulaVariables.enabled = s
        if s then
            Nebula_Enable()
        else
            Nebula_Disable()
        end
    end)
    self:CreateColorPicker(nebulaSec, 'Nebula Color', NebulaVariables.themeColor, function(c)
        NebulaVariables.themeColor = c
        Nebula_UpdateColor()
    end)

    local screenSec = self:CreateSection('World — Screen Effect')
    self:CreateToggle(screenSec, 'Enable Screen Stretch', false, function(s)
        Screen_Toggle(s)
    end)
    self:CreateSlider(screenSec, 'Stretch Intensity', 0, 20, 0, function(v)
        WorldVariables.screenIntensity = v / 100
    end)

    local utilSec = self:CreateSection('World — Utilities')
    self:CreateToggle(utilSec, 'Anime Image', false, function(s)
        Anime_Toggle(s)
    end)
    local espSec = self:CreateSection('ESP Settings')
    self:CreateToggle(espSec, 'Enable ESP', false, function(s)
        ToggleESP(s)
    end)
    self:CreateToggle(espSec, 'Show Murderer', true, function(s)
        ToggleMurderer(s)
    end)
    self:CreateToggle(espSec, 'Show Sheriff', true, function(s)
        ToggleSheriff(s)
    end)
    self:CreateToggle(espSec, 'Show Hero', true, function(s)
        ToggleHero(s)
    end)
    self:CreateToggle(espSec, 'Show Innocent', true, function(s)
        ToggleInnocent(s)
    end)
    self:CreateToggle(espSec, 'Show Self', true, function(s)
        ToggleSelf(s)
    end)
    self:CreateColorPicker(espSec, 'Murderer Color', ESP.Colors.Murderer, function(c)
        SetMurdererColor(c)
    end)
    self:CreateColorPicker(espSec, 'Sheriff Color', ESP.Colors.Sheriff, function(c)
        SetSheriffColor(c)
    end)
    self:CreateColorPicker(espSec, 'Hero Color', ESP.Colors.Hero, function(c)
        SetHeroColor(c)
    end)
    self:CreateColorPicker(espSec, 'Innocent Color', ESP.Colors.Innocent, function(c)
        SetInnocentColor(c)
    end)
end

function GUI:CreateCombatTab()
    local camlock = self:CreateSection('Camlock Aim')
    self:CreateToggle(camlock, 'Camlock Aim', Config.Settings.Combat.Camlock, function(s)
        Config.Settings.Combat.Camlock = s
    end)
    self:CreateSlider(camlock, 'FOV', 0, 360, Config.Settings.Combat.CamlockFOV, function(v)
        Config.Settings.Combat.CamlockFOV = v
    end)
    self:CreateSlider(camlock, 'Predict', 0, 200, Config.Settings.Combat.CamlockPredict, function(v)
        Config.Settings.Combat.CamlockPredict = v
    end)
    self:CreateToggle(camlock, 'Visible Check', Config.Settings.Combat.VisibleCheck, function(s)
        Config.Settings.Combat.VisibleCheck = s
    end)
    self:CreateSlider(camlock, 'Smoothness', 0, 100, Config.Settings.Combat.CamlockSmooth, function(v)
        Config.Settings.Combat.CamlockSmooth = v
    end)

    local silent = self:CreateSection('Silent Aim')
    self:CreateToggle(silent, 'Silent Aim', Config.Settings.Combat.SilentAim, function(s)
        Config.Settings.Combat.SilentAim = s
    end)
    self:CreateSlider(silent, 'FOV', 0, 360, Config.Settings.Combat.SilentFOV, function(v)
        Config.Settings.Combat.SilentFOV = v
    end)
    self:CreateSlider(silent, 'Predict', 0, 200, Config.Settings.Combat.SilentPredict, function(v)
        Config.Settings.Combat.SilentPredict = v
    end)

    local shootSec = self:CreateSection('Shoot & Kill')
    self:CreateToggle(shootSec, 'Draggable Shoot Button', false, function(s)
        if s then
            createDraggableShootButton()
        else
            removeDraggableShootButton()
        end
    end)
    self:CreateButton(shootSec, 'Shoot Murderer Now', function()
        shootMurdererDirect()
    end)
    self:CreateToggle(shootSec, 'Auto Shoot Murderer', Config.Settings.Combat.AutoShoot, function(s)
        Config.Settings.Combat.AutoShoot = s
    end)
    self:CreateToggle(shootSec, 'Auto Kill All', Config.Settings.Combat.AutoKillAll, function(s)
        Config.Settings.Combat.AutoKillAll = s
    end)
    self:CreateButton(shootSec, 'Kill All Now', function()
        killAll()
    end)

    local farmSec = self:CreateSection('AutoFarm & Bomb')
    self:CreateToggle(farmSec, 'AutoFarm Coins', FarmSettings.Enabled, function(s)
        FarmSettings.Enabled = s
        if s then StartFarming() else StopFarming() end
    end)
    self:CreateDropdown(farmSec, 'Farm Mode', {'Underground', 'Sit'}, FarmSettings.Mode, function(v)
        FarmSettings.Mode = v
        if FarmState.isFarming then StopFarming() StartFarming() end
    end)
    self:CreateSlider(farmSec, 'Tween Speed', 10, 100, FarmSettings.TweenSpeed, function(v)
        FarmSettings.TweenSpeed = v
    end)
    self:CreateToggle(farmSec, 'Auto Reset', FarmSettings.AutoReset, function(s)
        FarmSettings.AutoReset = s
    end)
    self:CreateToggle(farmSec, 'Avoid Murder', FarmSettings.AvoidMurder, function(s)
        FarmSettings.AvoidMurder = s
    end)
    self:CreateButton(farmSec, 'Bomb Jump', function()
        executeBombJump()
    end)

    local otherSec = self:CreateSection('Other')
    self:CreateToggle(otherSec, 'Anti Fling', Config.Settings.Combat.AntiFling, function(s)
        Config.Settings.Combat.AntiFling = s
    end)
    self:CreateToggle(otherSec, 'Anti-Void', Config.Settings.Combat.AntiVoid, function(s)
        Config.Settings.Combat.AntiVoid = s
        if s then
            workspace.FallenPartsDestroyHeight = -0/0
        else
            workspace.FallenPartsDestroyHeight = Features.FPDH
        end
    end)
    self:CreateToggle(otherSec, 'Auto WallHop', Config.Settings.Combat.AutoWallHop, function(s)
        Config.Settings.Combat.AutoWallHop = s
    end)
    self:CreateToggle(otherSec, 'Grab Gun', Config.Settings.Combat.GrabGun, function(s)
        Config.Settings.Combat.GrabGun = s
    end)
end

function GUI:CreateRageTab()
    local rage = self:CreateSection('Rage Features')
    self:CreateToggle(rage, 'SpinBot', Config.Settings.Rage.SpinBot, function(s)
        Config.Settings.Rage.SpinBot = s
    end)
    self:CreateSlider(rage, 'SpinBot Speed', 1, 100, Config.Settings.Rage.SpinSpeed, function(v)
        Config.Settings.Rage.SpinSpeed = v
    end)
    self:CreateToggle(rage, 'Speed Glitch', Config.Settings.Rage.SpeedGlitch, function(s)
        Config.Settings.Rage.SpeedGlitch = s
    end)
    self:CreateSlider(rage, 'Speed Force', 15, 100, Config.Settings.Rage.SpeedForce, function(v)
        Config.Settings.Rage.SpeedForce = v
    end)
    self:CreateToggle(rage, 'Noclip', Config.Settings.Rage.Noclip, function(s)
        setNoclip(s)
    end)
    self:CreateToggle(rage, 'Fly', Config.Settings.Rage.Fly, function(s)
        setFly(s)
    end)
    self:CreateSlider(rage, 'Fly Speed', 10, 150, Config.Settings.Rage.FlySpeed, function(v)
        Config.Settings.Rage.FlySpeed = v
    end)
end

function GUI:CreateFunTab()
    local fling = self:CreateSection('Fling (Click Player)')
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateButton(fling, player.DisplayName .. ' (@' .. player.Name .. ')', function()
                flingPlayer(player)
            end)
        end
    end
    self:CreateButton(fling, 'Refresh Player List', function()
        self:LoadTab('Fun')
    end)

    local teleport = self:CreateSection('Teleport To Player')
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:CreateButton(teleport, player.DisplayName .. ' (@' .. player.Name .. ')', function()
                local char = LocalPlayer.Character
                local targetChar = player.Character
                if char and targetChar then
                    local hrp = char:FindFirstChild('HumanoidRootPart')
                    local targetHrp = targetChar:FindFirstChild('HumanoidRootPart')
                    if hrp and targetHrp then
                        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 2, 2)
                        print('Teleported to ' .. player.Name)
                    end
                end
            end)
        end
    end
    self:CreateButton(teleport, 'Refresh Player List', function()
        self:LoadTab('Fun')
    end)
end

function GUI:CreateSettingsTab()
    local gui = self:CreateSection('GUI Settings')
    self:CreateSlider(gui, 'Transparency', 0, 100, 10, function(v)
        if self.Main.Window then
            self.Main.Window.BackgroundTransparency = v / 100
        end
    end)
    self:CreateToggle(gui, 'Snow Effect', true, function(s)
        Snow:Toggle(s)
    end)

    local keys = self:CreateSection('Keybinds')
    self:CreateKeybindButton(keys, 'Toggle GUI', Config.Settings.Keybinds.ToggleGUI, function(key)
        Config.Settings.Keybinds.ToggleGUI = key
    end)
    self:CreateKeybindButton(keys, 'Panic Key', Config.Settings.Keybinds.PanicKey, function(key)
        Config.Settings.Keybinds.PanicKey = key
    end)
    self:CreateKeybindButton(keys, 'Camlock', Config.Settings.Keybinds.Camlock, function(key)
        Config.Settings.Keybinds.Camlock = key
    end)
    self:CreateKeybindButton(keys, 'Silent Aim', Config.Settings.Keybinds.SilentAim, function(key)
        Config.Settings.Keybinds.SilentAim = key
    end)

    local config = self:CreateSection('Config System')
    self:CreateLabel(config, 'Current Config', 'Default')
    
    self:CreateButton(config, 'Save Current Config', function()
        local ok = saveCurrentConfig()
        if ok then
            print('[CandyZone] Config saved successfully!')
        else
            print('[CandyZone] Failed to save config (no writefile support)')
        end
    end)
    
    self:CreateButton(config, 'Load Saved Config', function()
        local ok = loadAndApplyConfig()
        if ok then
            print('[CandyZone] Config loaded successfully!')
            self:LoadTab(self.Main.CurrentTab)
        else
            print('[CandyZone] No config found, using defaults')
        end
    end)
    
    self:CreateButton(config, 'Reset to Defaults', function()
        resetToDefaults()
        print('[CandyZone] Config reset to defaults')
        self:LoadTab(self.Main.CurrentTab)
    end)
    
    self:CreateDivider(config)
    self:CreateLabel(config, '--- Named Configs ---', '')
    
    local nameInput = Instance.new("TextBox")
    nameInput.Size = UDim2.new(1, 0, 0, 28)
    nameInput.Position = UDim2.new(0, 0, 0, 0)
    nameInput.BackgroundColor3 = Config.Color.Background.Input
    nameInput.TextColor3 = Config.Color.Text.Primary
    nameInput.PlaceholderColor3 = Config.Color.Text.Disabled
    nameInput.Font = Enum.Font.Gotham
    nameInput.TextSize = 12
    nameInput.PlaceholderText = "Enter config name..."
    nameInput.Text = ""
    nameInput.Parent = config.Container
    Util:Corner(nameInput, 6)
    
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, 0, 0, 32)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = config.Container
    
    local saveBtn = Instance.new("TextButton")
    saveBtn.Size = UDim2.new(0.48, 0, 1, 0)
    saveBtn.Position = UDim2.new(0, 0, 0, 0)
    saveBtn.BackgroundColor3 = Config.Color.State.Success
    saveBtn.Text = "💾 Save As"
    saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 11
    saveBtn.Parent = btnFrame
    Util:Corner(saveBtn, 6)
    
    local loadBtn = Instance.new("TextButton")
    loadBtn.Size = UDim2.new(0.48, 0, 1, 0)
    loadBtn.Position = UDim2.new(0.52, 0, 0, 0)
    loadBtn.BackgroundColor3 = Config.Color.State.Info
    loadBtn.Text = "📂 Load"
    loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = 11
    loadBtn.Parent = btnFrame
    Util:Corner(loadBtn, 6)
    
    local deleteBtn = Instance.new("TextButton")
    deleteBtn.Size = UDim2.new(0.48, 0, 1, 0)
    deleteBtn.Position = UDim2.new(0, 0, 0, 0)
    deleteBtn.BackgroundColor3 = Config.Color.State.Error
    deleteBtn.Text = "🗑️ Delete"
    deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteBtn.Font = Enum.Font.GothamBold
    deleteBtn.TextSize = 11
    deleteBtn.Parent = btnFrame
    Util:Corner(deleteBtn, 6)
    deleteBtn.Visible = false
    
    saveBtn.MouseButton1Click:Connect(function()
        local name = nameInput.Text:gsub("%s+", "_")
        if name and name ~= "" then
            local ok = saveConfigAs(name)
            if ok then
                print('[CandyZone] Config saved as: ' .. name)
                loadBtn.Visible = true
                deleteBtn.Visible = true
                self:LoadTab(self.Main.CurrentTab)
            end
        end
    end)
    
    loadBtn.MouseButton1Click:Connect(function()
        local name = nameInput.Text:gsub("%s+", "_")
        if name and name ~= "" then
            local ok = loadConfigByName(name)
            if ok then
                print('[CandyZone] Config loaded: ' .. name)
                self:LoadTab(self.Main.CurrentTab)
            end
        end
    end)
    
    deleteBtn.MouseButton1Click:Connect(function()
        local name = nameInput.Text:gsub("%s+", "_")
        if name and name ~= "" then
            local ok = deleteConfig(name)
            if ok then
                print('[CandyZone] Config deleted: ' .. name)
                nameInput.Text = ""
                loadBtn.Visible = false
                deleteBtn.Visible = false
                self:LoadTab(self.Main.CurrentTab)
            end
        end
    end)
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, 80)
    listFrame.BackgroundColor3 = Config.Color.Background.Input
    listFrame.BackgroundTransparency = 0.3
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 3
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.Parent = config.Container
    Util:Corner(listFrame, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local function refreshConfigList()
        for _, child in ipairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        local files = getConfigList()
        if #files == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 24)
            empty.BackgroundTransparency = 1
            empty.Text = "No configs found"
            empty.TextColor3 = Config.Color.Text.Disabled
            empty.TextSize = 11
            empty.Font = Enum.Font.Gotham
            empty.Parent = listFrame
            return
        end
        for _, file in ipairs(files) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 24)
            btn.BackgroundColor3 = Config.Color.Background.Secondary
            btn.BackgroundTransparency = 0.2
            btn.Text = "📄 " .. file
            btn.TextColor3 = Config.Color.Text.Primary
            btn.TextSize = 11
            btn.Font = Enum.Font.Gotham
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = listFrame
            Util:Corner(btn, 4)
            
            btn.MouseEnter:Connect(function()
                Util:Tween(btn, {
                    BackgroundColor3 = Config.Color.Background.Hover,
                }, Config.Anim.Fast)
            end)
            btn.MouseLeave:Connect(function()
                Util:Tween(btn, {
                    BackgroundColor3 = Config.Color.Background.Secondary,
                }, Config.Anim.Fast)
            end)
            
            btn.MouseButton1Click:Connect(function()
                nameInput.Text = file
                loadBtn.Visible = true
                deleteBtn.Visible = true
                local ok = loadConfigByName(file)
                if ok then
                    print('[CandyZone] Config loaded: ' .. file)
                    for _, child in ipairs(config.Container:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text:find("Current Config") then
                            child.Text = "Current Config: " .. file
                            break
                        end
                    end
                    self:LoadTab(self.Main.CurrentTab)
                end
            end)
        end
    end
    
    refreshConfigList()
    
    self:CreateButton(config, '🔄 Refresh List', function()
        refreshConfigList()
    end)
end

function GUI:CreateMiscTab()
    local util = self:CreateSection('Utilities')
    self:CreateButton(util, 'Copy Game Link', function()
        if setclipboard then
            setclipboard('https://www.roblox.com/games/' .. game.PlaceId)
        end
    end)
    self:CreateButton(util, 'Lower Graphics (Make All Plastic)', function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA('BasePart') then
                obj.Material = Enum.Material.Plastic
            end
        end
    end)

    local info = self:CreateSection('Information')
    self:CreateLabel(info, 'Developer', Config.Developer)
    self:CreateLabel(info, 'Version', Config.Version)
    self:CreateLabel(info, 'Discord', Config.Discord)
end

function GUI:ToggleMain()
    self.Main.IsOpen = not self.Main.IsOpen
    if self.Main.IsOpen then
        self.Main.Blur.Visible = true
        self.Main.Window.Visible = true
        Util:Tween(self.Main.Blur, { BackgroundTransparency = 0.2 }, Config.Anim.Slow)
        self.Main.Window.Position = UDim2.new(0.5, -Config.Size.Window.Width / 2, 1.5, 0)
        Util:Tween(self.Main.Window, {
            Position = UDim2.new(0.5, -Config.Size.Window.Width / 2, 0.5, -Config.Size.Window.Height / 2),
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        Util:Tween(self.Main.Blur, { BackgroundTransparency = 1 }, Config.Anim.Normal)
        Util:Tween(self.Main.Window, {
            Position = UDim2.new(0.5, -Config.Size.Window.Width / 2, 1.5, 0),
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        self.Main.Blur.Visible = false
        self.Main.Window.Visible = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.KeyCode == Config.Settings.Keybinds.ToggleGUI then
        GUI:ToggleMain()
    elseif input.KeyCode == Config.Settings.Keybinds.PanicKey then
        GUI.ScreenGui:Destroy()
        Snow:Destroy()
        removeDraggableShootButton()
        for _, c in ipairs(Features.Connections) do
            pcall(function()
                c:Disconnect()
            end)
        end
    end
end)

task.spawn(function()
    while true do
        if Config.Settings.Combat.AutoShoot then
            pcall(shootMurdererDirect)
        end
        task.wait(0.12)
    end
end)

GUI:Initialize()

pcall(function()
    StarterGui:SetCore('SendNotification', {
        Title = '\u{1f36c} Candy Zone MM2',
        Text = 'Press RightShift to open',
        Duration = 5,
    })
end)

print('\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}')
print('\u{1f36c} CANDY ZONE MM2 v' .. Config.Version)
print('\u{2705} Successfully Loaded!')
print('\u{1f3ae} Game: ' .. Util:GetGameName())
print('\u{1f464} Developer: ' .. Config.Developer)
print('\u{1f4ac} Discord: ' .. Config.Discord)
print('\u{2328}\u{fe0f} Toggle: RightShift | Panic: End')
print('\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}')


-- Load saved config on startup
task.wait(0.5)
local loaded = loadAndApplyConfig()
if loaded then
    print('[CandyZone] Config loaded from CandyZone/Candycfg.json')
    if GUI.Main.IsOpen then
        GUI:LoadTab(GUI.Main.CurrentTab)
    end
else
    print('[CandyZone] No config found, using defaults')
    saveConfig(DefaultConfig)
end

-- Auto-save on panic key
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.Settings.Keybinds.PanicKey then
        saveCurrentConfig()
        print('[CandyZone] Config autosaved on panic')
    end
end)
