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
            WallBang = Enum.KeyCode.B,
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
            AutoShoot = false,
            CamlockFOV = 120,
            CamlockPredict = 100,
            CamlockSmooth = 50,
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
local ConfigFolder = 'CandyZone'
local ConfigFile = 'Candycfg.json'

local function getConfigPath()
    if isfolder and writefile and readfile then
        return ConfigFolder .. '/' .. ConfigFile
    end

    return nil
end
local function ensureFolder()
    if isfolder and not isfolder(ConfigFolder) then
        pcall(function()
            makefolder(ConfigFolder)
        end)
    end
end
local function loadConfig()
    local path = getConfigPath()

    if not path then
        return nil
    end
    if not isfile(path) then
        return nil
    end

    local success, data = pcall(function()
        return readfile(path)
    end)

    if success and data then
        local success2, parsed = pcall(function()
            return game:GetService('HttpService'):JSONDecode(data)
        end)

        if success2 then
            return parsed
        end
    end

    return nil
end
local function saveConfig(data)
    local path = getConfigPath()

    if not path then
        return false
    end

    ensureFolder()

    local success, json = pcall(function()
        return game:GetService('HttpService'):JSONEncode(data)
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
    if not saved then
        return defaults
    end

    local result = {}

    for key, defaultVal in pairs(defaults)do
        if saved[key] ~= nil then
            if type(defaultVal) == 'table' and type(saved[key]) == 'table' then
                result[key] = migrateConfig(saved[key], defaultVal)
            else
                result[key] = saved[key]
            end
        else
            result[key] = defaultVal
        end
    end
    for key, val in pairs(saved)do
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
        Mode = 'Underground',
        TweenSpeed = 25,
        AutoReset = true,
        AvoidMurder = true,
        UndergroundOffset = 4,
        MaxDistance = 600,
        CoinLimit = 40,
    },
    Combat = {
        Camlock = false,
        AutoShoot = false,
        CamlockFOV = 120,
        CamlockPredict = 100,
        CamlockSmooth = 50,
        VisibleCheck = true,
        AutoKillAll = false,
        AntiFling = false,
        AntiVoid = false,
        AutoWallHop = false,
        GrabGun = false,
        WallBang = false,
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
            Style = 'Classic',
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
            Current = 'HD',
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
        ToggleGUI = 'RightShift',
        PanicKey = 'End',
        Camlock = 'Q',
        SilentAim = 'E',
    },
    Window = {Transparency = 0.1},
}

local function colorToTable(c)
    return {
        c.R * 255,
        c.G * 255,
        c.B * 255,
    }
end
local function tableToColor(t)
    if not t or #t < 3 then
        return Color3.fromRGB(255, 255, 255)
    end

    return Color3.fromRGB(t[1], t[2], t[3])
end
local function applySavedConfig(cfg)
    if not cfg then
        return
    end
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
    if cfg.Farm then
        FarmSettings.Enabled = cfg.Farm.Enabled or false
        FarmSettings.Mode = cfg.Farm.Mode or 'Underground'
        FarmSettings.TweenSpeed = cfg.Farm.TweenSpeed or 25
        FarmSettings.AutoReset = cfg.Farm.AutoReset ~= false
        FarmSettings.AvoidMurder = cfg.Farm.AvoidMurder ~= false
        FarmSettings.UndergroundOffset = cfg.Farm.UndergroundOffset or 4
        FarmSettings.MaxDistance = cfg.Farm.MaxDistance or 600
        FarmSettings.CoinLimit = cfg.Farm.CoinLimit or 40
    end
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
    if cfg.Rage then
        Config.Settings.Rage.SpinBot = cfg.Rage.SpinBot or false
        Config.Settings.Rage.SpinSpeed = cfg.Rage.SpinSpeed or 50
        Config.Settings.Rage.Noclip = cfg.Rage.Noclip or false
        Config.Settings.Rage.Fly = cfg.Rage.Fly or false
        Config.Settings.Rage.FlySpeed = cfg.Rage.FlySpeed or 50
        Config.Settings.Rage.SpeedGlitch = cfg.Rage.SpeedGlitch or false
        Config.Settings.Rage.SpeedForce = cfg.Rage.SpeedForce or 45
    end
    if cfg.Player then
        if cfg.Player.Hat then
            HatVariables.enabled = cfg.Player.Hat.Enabled or false
            HatVariables.style = cfg.Player.Hat.Style or 'Classic'
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
            SkyboxVariables.current = cfg.Visuals.Skybox.Current or 'HD'
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
    if cfg.Keybinds then
        Config.Settings.Keybinds.ToggleGUI = Enum.KeyCode[cfg.Keybinds.ToggleGUI] or Enum.KeyCode.RightShift
        Config.Settings.Keybinds.PanicKey = Enum.KeyCode[cfg.Keybinds.PanicKey] or Enum.KeyCode.End
        Config.Settings.Keybinds.Camlock = Enum.KeyCode[cfg.Keybinds.Camlock] or Enum.KeyCode.Q
        Config.Settings.Keybinds.SilentAim = Enum.KeyCode[cfg.Keybinds.SilentAim] or Enum.KeyCode.E
    end
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
    local json = game:GetService('HttpService'):JSONEncode(cfg)

    if setclipboard then
        setclipboard(json)

        return true, 'Config copied to clipboard!'
    end

    return false, 'Clipboard not supported'
end
local function importConfig(json)
    if not json or json == '' then
        return false, 'Empty config'
    end

    local success, data = pcall(function()
        return game:GetService('HttpService'):JSONDecode(json)
    end)

    if not success then
        return false, 'Invalid JSON'
    end

    local merged = migrateConfig(data, DefaultConfig)

    applySavedConfig(merged)
    saveConfig(merged)

    return true, 'Config imported successfully!'
end
local function getConfigList()
    if not isfolder then
        return {}
    end
    if not isfolder(ConfigFolder) then
        return {}
    end

    local files = {}

    for _, file in ipairs(listfiles(ConfigFolder))do
        if file:match('%.json$') then
            local name = file:match('([^/\\]+)%.json$')

            if name then
                table.insert(files, name)
            end
        end
    end

    return files
end
local function loadConfigByName(name)
    if not name or name == '' then
        return false
    end

    local path = ConfigFolder .. '/' .. name .. '.json'

    if not isfile(path) then
        return false
    end

    local success, data = pcall(function()
        return readfile(path)
    end)

    if success and data then
        local success2, parsed = pcall(function()
            return game:GetService('HttpService'):JSONDecode(data)
        end)

        if success2 then
            applySavedConfig(parsed)

            return true
        end
    end

    return false
end
local function saveConfigAs(name)
    if not name or name == '' then
        return false
    end

    local cfg = buildConfig()
    local path = ConfigFolder .. '/' .. name .. '.json'

    ensureFolder()

    local success, json = pcall(function()
        return game:GetService('HttpService'):JSONEncode(cfg)
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
    if not name or name == '' then
        return false
    end

    local path = ConfigFolder .. '/' .. name .. '.json'

    if isfile(path) then
        pcall(function()
            delfile(path)
        end)

        return true
    end

    return false
end

local ColorPresets = {
    {
        Name = 'Cyan',
        Color = Color3.fromRGB(0, 255, 255),
    },
    {
        Name = 'Pink',
        Color = Color3.fromRGB(255, 105, 180),
    },
    {
        Name = 'Red',
        Color = Color3.fromRGB(255, 0, 0),
    },
    {
        Name = 'White',
        Color = Color3.fromRGB(255, 255, 255),
    },
    {
        Name = 'Green',
        Color = Color3.fromRGB(0, 255, 0),
    },
    {
        Name = 'Blue',
        Color = Color3.fromRGB(0, 100, 255),
    },
    {
        Name = 'Yellow',
        Color = Color3.fromRGB(255, 255, 0),
    },
    {
        Name = 'Purple',
        Color = Color3.fromRGB(180, 0, 255),
    },
    {
        Name = 'Orange',
        Color = Color3.fromRGB(255, 140, 0),
    },
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
    for _, player in ipairs(Players:GetPlayers())do
        if player.Character then
            local h = player.Character:FindFirstChild('CandyZone_ESP')

            if h then
                h:Destroy()
            end
        end
    end

    ESP.Data = {}
end
local function ApplyESP(player, color)
    local char = player.Character

    if not char then
        return
    end

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

        if role:find('murd') then
            return 'Murderer'
        end
        if role:find('sheriff') or role:find('gun') then
            return 'Sheriff'
        end
        if role:find('hero') then
            return 'Hero'
        end
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
                local ok, data = pcall(function()
                    return remote:InvokeServer()
                end)

                if ok and type(data) == 'table' then
                    ESP.Data = data
                end
            end

            ESP.LastUpdate = tick()
        end

        for _, player in ipairs(Players:GetPlayers())do
            if player.Character then
                local role = GetRole(player)
                local show = ESP.Show[role]

                if player == LocalPlayer and not ESP.Show.Self then
                    show = false
                end
                if show then
                    ApplyESP(player, ESP.Colors[role])
                else
                    local h = player.Character:FindFirstChild('CandyZone_ESP')

                    if h then
                        h:Destroy()
                    end
                end
            end
        end
    end)
end
local function ToggleESP(state)
    ESP.Enabled = state

    if state then
        StartESP()
    else
        if ESP.Connection then
            ESP.Connection:Disconnect()

            ESP.Connection = nil
        end

        ClearESP()
    end
end
local function ToggleMurderer(state)
    ESP.Show.Murderer = state
end
local function ToggleSheriff(state)
    ESP.Show.Sheriff = state
end
local function ToggleHero(state)
    ESP.Show.Hero = state
end
local function ToggleInnocent(state)
    ESP.Show.Innocent = state
end
local function ToggleSelf(state)
    ESP.Show.Self = state
end
local function SetMurdererColor(c)
    ESP.Colors.Murderer = c
end
local function SetSheriffColor(c)
    ESP.Colors.Sheriff = c
end
local function SetHeroColor(c)
    ESP.Colors.Hero = c
end
local function SetInnocentColor(c)
    ESP.Colors.Innocent = c
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)

    if ESP.Enabled then
        ClearESP()
        StartESP()
    end
end)

local Murder = nil
local grabbingGun = false
local TargetESPVariables = {
    enabled = false,
    size = 45,
    maxRadius = 50,
    asset = 'rbxassetid://6031098373',
    color = Color3.fromRGB(255, 70, 90),
    rainbow = false,
    rotation = 0,
    gui = nil,
    frame = nil,
    texture = nil,
    currentTarget = nil,
}

local function getRootPart(char)
    if not char then
        return nil
    end

    return char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('LowerTorso') or char:FindFirstChild('MainPart')
end
local function getHeadPart(char)
    if not char then
        return nil
    end

    return char:FindFirstChild('Head') or char:FindFirstChild('head') or char:FindFirstChild('CameraPart')
end
local function isFriend(player)
    if _G.FriendWhitelist and _G.FriendWhitelist[player] then
        return true
    end

    return false
end
local function isVisible(targetPart, character)
    local localChar = LocalPlayer.Character
    local head = getHeadPart(localChar)

    if not localChar or not head then
        return false
    end

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
    TargetESPVariables.gui = Instance.new('ScreenGui')
    TargetESPVariables.gui.Name = 'AunixTargetESP'
    TargetESPVariables.gui.ResetOnSpawn = false
    TargetESPVariables.gui.IgnoreGuiInset = true

    if gethui then
        TargetESPVariables.gui.Parent = gethui()
    else
        TargetESPVariables.gui.Parent = CoreGui
    end

    TargetESPVariables.frame = Instance.new('Frame')
    TargetESPVariables.frame.Size = UDim2.new(0, 40, 0, 40)
    TargetESPVariables.frame.BackgroundTransparency = 1
    TargetESPVariables.frame.Visible = false
    TargetESPVariables.frame.Parent = TargetESPVariables.gui
    TargetESPVariables.texture = Instance.new('ImageLabel')
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
        if not TargetESPVariables.currentTarget.Character or not TargetESPVariables.currentTarget.Character:FindFirstChildOfClass('Humanoid') or TargetESPVariables.currentTarget.Character:FindFirstChildOfClass('Humanoid').Health <= 0 then
            TargetESPVariables.currentTarget = nil
        end
    end

    local bestTarget = nil
    local closestToCenter = math.huge
    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local localRoot = getRootPart(LocalPlayer.Character)

    if localRoot then
        for _, player in ipairs(Players:GetPlayers())do
            if player ~= LocalPlayer and player.Character and not isFriend(player) then
                local hum = player.Character:FindFirstChildOfClass('Humanoid')
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
        local hum = char:FindFirstChildOfClass('Humanoid')

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

local ArrowESPVariables = {
    enabled = false,
    color = Color3.fromRGB(255, 255, 255),
    rainbow = false,
    distance = 80,
    gui = nil,
    arrows = {},
}

local function ArrowESP_Init()
    ArrowESPVariables.gui = Instance.new('ScreenGui')
    ArrowESPVariables.gui.Name = 'ArrowESP'
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
        for _, arrow in pairs(ArrowESPVariables.arrows)do
            arrow:Remove()
        end

        ArrowESPVariables.arrows = {}

        return
    end

    for _, arrow in pairs(ArrowESPVariables.arrows)do
        arrow:Remove()
    end

    ArrowESPVariables.arrows = {}

    local viewportSize = camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers())do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass('Humanoid')
            local root = getRootPart(player.Character)

            if hum and hum.Health > 0 and root then
                local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)

                if not onScreen or screenPos.Z < 0 then
                    local direction = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Unit
                    local angle = math.atan2(direction.Y, direction.X)
                    local arrowPos = screenCenter + direction * ArrowESPVariables.distance
                    local arrow = Drawing.new('Triangle')

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

local TracerVariables = {
    enabled = false,
    color = Color3.fromRGB(255, 255, 255),
    thickness = 1,
    transparency = 0.5,
    onlyVisible = false,
    tracers = {},
}

local function Tracer_Update()
    for _, tracer in pairs(TracerVariables.tracers)do
        tracer:Remove()
    end

    TracerVariables.tracers = {}

    if not TracerVariables.enabled then
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')

    if not hrp then
        return
    end

    local origin = hrp.Position
    local viewportSize = camera.ViewportSize

    for _, player in ipairs(Players:GetPlayers())do
        if player == LocalPlayer then
            continue
        end
        if not player.Character then
            continue
        end

        local targetHRP = player.Character:FindFirstChild('HumanoidRootPart')
        local hum = player.Character:FindFirstChildOfClass('Humanoid')

        if not targetHRP or not hum or hum.Health <= 0 then
            continue
        end
        if TracerVariables.onlyVisible then
            local origin2 = camera.CFrame.Position
            local direction = (targetHRP.Position - origin2)
            local raycastParams = RaycastParams.new()

            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = {
                char,
                player.Character,
            }
            raycastParams.IgnoreWater = true

            local result = workspace:Raycast(origin2, direction, raycastParams)

            if result then
                continue
            end
        end

        local screenPos, onScreen = camera:WorldToViewportPoint(targetHRP.Position)

        if not onScreen then
            continue
        end

        local tracer = Drawing.new('Line')

        tracer.Visible = true
        tracer.Color = TracerVariables.color
        tracer.Thickness = TracerVariables.thickness
        tracer.Transparency = TracerVariables.transparency
        tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
        tracer.To = Vector2.new(screenPos.X, screenPos.Y)
        tracer.ZIndex = 1

        table.insert(TracerVariables.tracers, tracer)
    end
end

RunService.RenderStepped:Connect(function()
    Tracer_Update()
end)

function ToggleTracers(state)
    TracerVariables.enabled = state

    if not state then
        for _, tracer in pairs(TracerVariables.tracers)do
            tracer:Remove()
        end

        TracerVariables.tracers = {}
    end
end

local GunBeamSettings = {
    enabled = false,
    beamType = 'Neon Fat',
    beamColor = Color3.fromRGB(0, 240, 255),
    thickness = 1.5,
    lifetime = 0.25,
}

local function CreateBeam(p0, p1, color, thickness, lifetime)
    if not p0 or not p1 then
        return
    end

    local dist = (p1 - p0).Magnitude

    if dist < 0.5 then
        return
    end

    local beam = Instance.new('Part')

    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = color
    beam.Shape = Enum.PartType.Cylinder
    beam.Size = Vector3.new(dist, thickness or 1.5, thickness or 1.5)
    beam.CFrame = CFrame.lookAt(p0, p1) * CFrame.new(0, 0, -dist / 2) * CFrame.Angles(0, math.rad(90), 0)
    beam.Parent = workspace.Terrain

    TweenService:Create(beam, TweenInfo.new(lifetime or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(dist, 0, 0),
        Transparency = 1,
    }):Play()
    task.delay((lifetime or 0.25) + 0.05, function()
        if beam then
            beam:Destroy()
        end
    end)

    return beam
end
local function GunBeam_Handle(beam)
    if not beam or not beam:IsA('Beam') then
        return
    end
    if not GunBeamSettings.enabled then
        return
    end

    local p0, p1

    if beam.Attachment0 and beam.Attachment1 then
        p0 = beam.Attachment0.WorldPosition
        p1 = beam.Attachment1.WorldPosition
    end
    if not p0 or not p1 then
        return
    end

    local color = GunBeamSettings.beamColor
    local thick = GunBeamSettings.thickness or 1.5
    local lifetime = GunBeamSettings.lifetime or 0.25

    if GunBeamSettings.beamType == 'Neon Fat' then
        beam.Width0 = 1.8
        beam.Width1 = 1.2
        beam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.2, color),
            ColorSequenceKeypoint.new(1, color),
        })

        CreateBeam(p0, p1, color, 1, lifetime)
    else
        beam.Width0 = 0.5
        beam.Width1 = 0.3
        beam.Color = ColorSequence.new(color)
    end
end

workspace.DescendantAdded:Connect(function(desc)
    if desc:IsA('Beam') and GunBeamSettings.enabled then
        task.wait(0.02)
        pcall(GunBeam_Handle, desc)
    end
end)

for _, beam in ipairs(workspace:GetDescendants())do
    if beam:IsA('Beam') and GunBeamSettings.enabled then
        task.spawn(function()
            pcall(GunBeam_Handle, beam)
        end)
    end
end

function ToggleGunBeam(state)
    GunBeamSettings.enabled = state
end
function SetGunBeamType(type)
    GunBeamSettings.beamType = type
end
function SetGunBeamColor(color)
    GunBeamSettings.beamColor = color
end

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
        if sound.Name == 'Gunshot' and HitsoundData.selectedGunshot and HitsoundData.selectedGunshot ~= 'None' and HitsoundData.gunshotSounds[HitsoundData.selectedGunshot] and sound.SoundId ~= HitsoundData.gunshotSounds[HitsoundData.selectedGunshot] then
            sound.SoundId = HitsoundData.gunshotSounds[HitsoundData.selectedGunshot]
            sound.TimePosition = 0

            sound:Play()
        elseif sound.Name == 'Kill' and HitsoundData.selectedKnifeKill and HitsoundData.selectedKnifeKill ~= 'None' and HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill] and sound.SoundId ~= HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill] then
            sound.SoundId = HitsoundData.knifeKillSounds[HitsoundData.selectedKnifeKill]
            sound.TimePosition = 0

            sound:Play()
        end
    end)
end

workspace.DescendantAdded:Connect(function(d)
    if d:IsA('Sound') and (d.Name == 'Gunshot' or d.Name == 'Kill') then
        hookSound(d)
    end
end)

for _, d in ipairs(workspace:GetDescendants())do
    if d:IsA('Sound') and (d.Name == 'Gunshot' or d.Name == 'Kill') then
        hookSound(d)
    end
end

local isWallHopEnabled = false
local isFlicking = false
local lastFlickTime = 0
local lastHitInstance = nil

local function performVideoFlick()
    if isFlicking then
        return
    end

    isFlicking = true

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild('Humanoid')
    local hrp = char and char:FindFirstChild('HumanoidRootPart')

    if not hum or not hrp then
        isFlicking = false

        return
    end

    hum:ChangeState(Enum.HumanoidStateType.Jumping)

    hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)

    local startCFrame = camera.CFrame

    camera.CFrame = startCFrame * CFrame.Angles(0, math.rad(180), 0)

    task.wait(0.01)

    camera.CFrame = startCFrame
    isFlicking = false
end

RunService.Heartbeat:Connect(function()
    if not Config.Settings.Combat.AutoWallHop then
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')

    if not hrp then
        return
    end

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

local function IsAlive(player)
    local char = player.Character

    if not char then
        return false
    end

    local hum = char:FindFirstChildOfClass('Humanoid')

    return hum and hum.Health > 0
end
local function grabGun()
    if grabbingGun then
        return
    end
    if not IsAlive(LocalPlayer) then
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild('HumanoidRootPart')

    if not char or not hrp then
        return
    end

    local bp = LocalPlayer:FindFirstChild('Backpack')
    local isMurderer = (char:FindFirstChild('Knife')) or (bp and bp:FindFirstChild('Knife')) or (Murder and LocalPlayer.Name == Murder)

    if isMurderer then
        return
    end

    local function hasGun()
        local currentBp = LocalPlayer:FindFirstChild('Backpack')

        return (char:FindFirstChild('Gun') or char:FindFirstChild('Revolver')) or (currentBp and (currentBp:FindFirstChild('Gun') or currentBp:FindFirstChild('Revolver')))
    end

    if hasGun() then
        return
    end

    local gunDrop = workspace:FindFirstChild('GunDrop', true) or workspace:FindFirstChild('DroppedGun', true)
    local handle = gunDrop and (gunDrop:FindFirstChild('Handle', true) or gunDrop:FindFirstChildOfClass('Part', true) or gunDrop)

    if not handle then
        return
    end

    grabbingGun = true

    local originalCFrame = hrp.CFrame
    local targetCFrame = handle:IsA('Model') and handle:GetPivot() or handle.CFrame

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

local WallBangSettings = {enabled = false}
local PlayerRoles = {}
local lastVel = {}

local function GetRole(plr)
    if PlayerRoles[plr.Name] then
        return PlayerRoles[plr.Name]
    end

    local char = plr.Character
    local bp = plr:FindFirstChild('Backpack')

    if char and char:FindFirstChild('Knife') then
        return 'Murderer'
    end
    if bp and bp:FindFirstChild('Knife') then
        return 'Murderer'
    end
    if char and char:FindFirstChild('Gun') then
        return 'Sheriff'
    end
    if bp and bp:FindFirstChild('Gun') then
        return 'Sheriff'
    end

    return nil
end
local function FindMurderer()
    for _, plr in ipairs(Players:GetPlayers())do
        if plr ~= LocalPlayer then
            local role = GetRole(plr)

            if role == 'Murderer' then
                return plr
            end

            local char = plr.Character
            local bp = plr:FindFirstChild('Backpack')

            if (char and char:FindFirstChild('Knife')) or (bp and bp:FindFirstChild('Knife')) then
                return plr
            end
        end
    end

    return nil
end
local function getpredictedpos(targetPart)
    if not targetPart or not targetPart:IsA('BasePart') then
        return targetPart and targetPart.Position or Vector3.zero
    end

    local target = targetPart.Parent
    local hum = target and target:FindFirstChildOfClass('Humanoid')
    local state = hum and hum:GetState() or Enum.HumanoidStateType.None
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild('HumanoidRootPart')

    if not myRoot then
        return targetPart.Position
    end

    local distance = (myRoot.Position - targetPart.Position).Magnitude
    local ping = LocalPlayer:GetNetworkPing() or 0
    local predTime = math.clamp(distance / math.max(myRoot.AssemblyLinearVelocity.Magnitude + 800, 800) * 0.6 + ping, 0.005, 0.12)
    local vel = targetPart.AssemblyLinearVelocity

    if not lastVel[targetPart] then
        lastVel[targetPart] = vel
    end

    local accel = (vel - lastVel[targetPart]).Magnitude
    local smoothFactor = accel > 50 and 0.8 or 0.35
    local smoothedVel = lastVel[targetPart]:Lerp(vel, smoothFactor)

    lastVel[targetPart] = smoothedVel

    local predicted = targetPart.Position + smoothedVel * predTime

    if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.GettingUp then
        predicted = predicted + Vector3.new(0, workspace.Gravity * predTime * predTime * 0.12, 0)

        if smoothedVel.Y > 0 then
            predicted = predicted + Vector3.new(0, smoothedVel.Y * predTime * 0.08, 0)
        end
    end

    local yDiff = predicted.Y - targetPart.Position.Y
    local clampedYDiff = math.clamp(yDiff, -distance * 0.03, distance * 0.05)

    if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
        clampedYDiff = math.clamp(yDiff, -distance * 0.08, distance * 0.12)
    end

    local head = target and target:FindFirstChild('Head')
    local root = target and target:FindFirstChild('HumanoidRootPart')
    local hitboxHeight = 3

    if head and root then
        hitboxHeight = math.abs(head.Position.Y - root.Position.Y) + 1
    end

    local finalPos = Vector3.new(predicted.X, targetPart.Position.Y + clampedYDiff + hitboxHeight * 0.25, predicted.Z)
    local maxOffset = math.max(distance * 0.25, 8)
    local offset = finalPos - targetPart.Position

    if maxOffset < offset.Magnitude then
        finalPos = targetPart.Position + offset.Unit * maxOffset
    end

    return finalPos
end
local function FindGun()
    local char = LocalPlayer.Character

    if char then
        for _, t in ipairs(char:GetChildren())do
            if t:IsA('Tool') and (t.Name:lower():find('gun') or t.Name:lower():find('revolver') or t.Name:lower():find('pistol')) then
                return t
            end
        end
    end

    local bp = LocalPlayer:FindFirstChild('Backpack')

    if bp then
        for _, t in ipairs(bp:GetChildren())do
            if t:IsA('Tool') and (t.Name:lower():find('gun') or t.Name:lower():find('revolver') or t.Name:lower():find('pistol')) then
                return t
            end
        end
    end

    return nil
end
local function UpdateGun()
    local gunTool = FindGun()

    if gunTool then
        local shootRemote = gunTool:FindFirstChild('Shoot')

        if shootRemote and shootRemote:IsA('RemoteEvent') then
            return gunTool, shootRemote
        end
    end

    return nil, nil
end

function WallBangShoot()
    if not WallBangSettings.enabled then
        return false
    end

    local gunTool, shootRemote = UpdateGun()

    if not gunTool or not shootRemote then
        return false
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild('HumanoidRootPart')

    if not char or not root then
        return false
    end
    if gunTool.Parent == LocalPlayer:FindFirstChild('Backpack') then
        local hum = char:FindFirstChildOfClass('Humanoid')

        if hum then
            hum:EquipTool(gunTool)
            task.wait(0.05)
        end

        shootRemote = gunTool:FindFirstChild('Shoot')

        if not shootRemote then
            return false
        end
    end

    local murderer = FindMurderer()

    if not murderer or not murderer.Character then
        return false
    end

    local mRoot = murderer.Character:FindFirstChild('HumanoidRootPart')

    if not mRoot then
        return false
    end

    local mHum = murderer.Character:FindFirstChildOfClass('Humanoid')

    if not mHum or mHum.Health <= 0 then
        return false
    end

    local targetPos = getpredictedpos(mRoot)
    local success = false

    pcall(function()
        local cf = CFrame.new(targetPos)

        shootRemote:FireServer(cf, CFrame.new(root.Position))

        success = true
    end)

    return success
end

local WallBangButtonGui = nil

function CreateWallBangButton()
    if WallBangButtonGui then
        WallBangButtonGui:Destroy()
    end

    local sg = Instance.new('ScreenGui')

    sg.Name = 'WallBangButton'
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999999

    if gethui then
        sg.Parent = gethui()
    else
        sg.Parent = CoreGui
    end

    WallBangButtonGui = sg

    local btn = Instance.new('TextButton')

    btn.Size = UDim2.new(0, 70, 0, 70)
    btn.Position = UDim2.new(0.7, 0, 0.7, 0)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btn.BackgroundTransparency = 0.1
    btn.Text = 'WB'
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = sg

    Util:Corner(btn, 999)
    Util:Stroke(btn, 2, Color3.fromRGB(255, 255, 255), 0.3)
    btn.MouseButton1Click:Connect(function()
        WallBangShoot()
    end)
    btn.TouchTap:Connect(function()
        WallBangShoot()
    end)
end
function RemoveWallBangButton()
    if WallBangButtonGui then
        WallBangButtonGui:Destroy()

        WallBangButtonGui = nil
    end
end

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

        for _, fps in ipairs(self.history)do
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

        for _, p in ipairs(self.particles)do
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
    for _, player in ipairs(Players:GetPlayers())do
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
        for _, part in ipairs(char:GetDescendants())do
            if part:IsA('BasePart') then
                part.CanCollide = false
            end
        end
    end
end))

local flyBV, flyBG
local mobileButtons = {}
local flyEnabled = false
local flyConn = nil

local function setFly(state)
    local char = LocalPlayer.Character

    if not char then
        return
    end

    local hrp = char:FindFirstChild('HumanoidRootPart')
    local hum = char:FindFirstChildOfClass('Humanoid')

    if not hrp or not hum then
        return
    end
    if state then
        flyEnabled = true
        hum.PlatformStand = true

        hum:ChangeState(Enum.HumanoidStateType.Swimming)

        if char:FindFirstChild('Animate') then
            char.Animate.Disabled = true
        end

        for _, anim in ipairs(hum:GetPlayingAnimationTracks())do
            anim:Stop()
        end

        local gyro = Instance.new('BodyGyro')

        gyro.P = 90000
        gyro.MaxTorque = Vector3.new(1, 1, 1) * (1/0)
        gyro.CFrame = camera.CFrame
        gyro.Name = '_FlyGyro'
        gyro.Parent = hrp

        local velocity = Instance.new('BodyVelocity')

        velocity.MaxForce = Vector3.new(1, 1, 1) * (1/0)
        velocity.Velocity = Vector3.zero
        velocity.Name = '_FlyVelocity'
        velocity.Parent = hrp

        if flyConn then
            flyConn:Disconnect()
        end

        flyConn = RunService.RenderStepped:Connect(function()
            if not flyEnabled or not hrp.Parent then
                return
            end

            local moveDirection = hum.MoveDirection
            local camCFrame = camera.CFrame
            local forward = camCFrame.LookVector

            forward = Vector3.new(forward.X, 0, forward.Z).Unit

            local right = camCFrame.RightVector

            right = Vector3.new(right.X, 0, right.Z).Unit

            local moveVector = (right * moveDirection.X + forward * -moveDirection.Z) * 90
            local vel = hrp:FindFirstChild('_FlyVelocity')

            if vel then
                vel.Velocity = moveVector
            end

            local gyro2 = hrp:FindFirstChild('_FlyGyro')

            if gyro2 then
                gyro2.CFrame = camCFrame
            end
        end)
    else
        flyEnabled = false

        if flyConn then
            flyConn:Disconnect()

            flyConn = nil
        end
        if hrp:FindFirstChild('_FlyGyro') then
            hrp._FlyGyro:Destroy()
        end
        if hrp:FindFirstChild('_FlyVelocity') then
            hrp._FlyVelocity:Destroy()
        end

        hum.PlatformStand = false

        if char:FindFirstChild('Animate') then
            char.Animate.Disabled = false
        end
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

                for _, part in pairs(Character:GetChildren())do
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
    for _, p in ipairs(Players:GetPlayers())do
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
    for _, p in ipairs(Players:GetPlayers())do
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

    if not m or not m.Character then
        return
    end

    local mTorso = m.Character:FindFirstChild('UpperTorso') or m.Character:FindFirstChild('Torso') or m.Character:FindFirstChild('HumanoidRootPart')

    if not mTorso then
        return
    end

    local root = char:FindFirstChild('HumanoidRootPart')

    if not root then
        return
    end
    if gun.Parent == LocalPlayer:FindFirstChild('Backpack') then
        local hum = char:FindFirstChildOfClass('Humanoid')

        if hum then
            hum:EquipTool(gun)
            task.wait(0)
        end
    end

    local raycastParams = RaycastParams.new()

    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {
        char,
        m.Character,
    }
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(root.Position, (mTorso.Position - root.Position), raycastParams)
    local shootPos

    if result then
        local Position = mTorso.Position
        local predTime = (Position - root.Position).Magnitude / 250

        if _G.PingPrediction then
            local ok, ping = pcall(function()
                return LocalPlayer:GetNetworkPing()
            end)

            if ok and ping then
                predTime = predTime + ping * 0.5
            end
        end

        local vel = mTorso.AssemblyLinearVelocity
        local hum = m.Character:FindFirstChildOfClass('Humanoid')

        if hum then
            local state = hum:GetState()

            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                vel = Vector3.new(vel.X, vel.Y * 0.35, vel.Z)
            end
        end

        shootPos = Position + vel * predTime
    else
        shootPos = mTorso.Position
    end

    local shootRemote = gun:FindFirstChild('Shoot')

    if shootRemote then
        local origin = root.Position + Vector3.new(0, 1, 0)

        pcall(function()
            shootRemote:FireServer(CFrame.new(origin, shootPos), CFrame.new(shootPos))
        end)
    else
        fireGun(gun, shootPos)
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

local FarmSettings = {
    Enabled = false,
    Mode = 'Underground',
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
        local gui = LocalPlayer.PlayerGui:FindFirstChild('MainGUI')

        if not gui then
            return 0
        end

        local gameGui = gui:FindFirstChild('Game')

        if not gameGui then
            return 0
        end

        local coinBags = gameGui:FindFirstChild('CoinBags')

        if not coinBags then
            return 0
        end

        local container = coinBags:FindFirstChild('Container')

        if not container then
            return 0
        end

        local coin = container:FindFirstChild('Coin')

        if not coin then
            return 0
        end

        local currencyFrame = coin:FindFirstChild('CurrencyFrame')

        if not currencyFrame then
            return 0
        end

        local icon = currencyFrame:FindFirstChild('Icon')

        if not icon then
            return 0
        end

        local coinsText = icon:FindFirstChild('Coins')

        if not coinsText then
            return 0
        end

        return coinsText.Text
    end)

    return ok and (tonumber(res) or 0) or 0
end
local function isRoundOver()
    local pGui = LocalPlayer:FindFirstChild('PlayerGui')

    if not pGui then
        return false
    end

    local victoryGui = pGui:FindFirstChild('Victory')

    if victoryGui then
        for _, child in pairs(victoryGui:GetChildren())do
            if child:IsA('GuiObject') and child.Visible then
                return true
            end
        end
    end

    return false
end
local function isBagFull()
    local pGui = LocalPlayer:FindFirstChild('PlayerGui')

    if pGui then
        local mainGui = pGui:FindFirstChild('MainGUI')

        if mainGui and mainGui:FindFirstChild('Lobby') and mainGui.Lobby:FindFirstChild('Dock') then
            local coinBags = mainGui.Lobby.Dock:FindFirstChild('CoinBags')

            if coinBags then
                local notification = coinBags:FindFirstChild('FullBagNotification')

                if notification and notification.Visible then
                    return true
                end
            end
        end
    end

    return false
end
local function hasNearbyMurderer()
    if not FarmSettings.AvoidMurder then
        return false
    end

    local char = LocalPlayer.Character

    if not char then
        return false
    end

    local hrp = char:FindFirstChild('HumanoidRootPart')

    if not hrp then
        return false
    end

    for _, player in pairs(Players:GetPlayers())do
        if player ~= LocalPlayer and player.Character then
            local otherHRP = player.Character:FindFirstChild('HumanoidRootPart')
            local backpack = player:FindFirstChild('Backpack')

            if otherHRP and (otherHRP.Position - hrp.Position).Magnitude <= 10 then
                if player.Character:FindFirstChild('Knife') then
                    return true
                end
                if backpack and backpack:FindFirstChild('Knife') then
                    return true
                end
            end
        end
    end

    return false
end
local function getNearestCoin(torso)
    local container = nil

    for _, obj in pairs(workspace:GetDescendants())do
        if obj.Name == 'CoinContainer' then
            container = obj

            break
        end
    end

    if not container then
        return nil
    end

    local nearestCoin = nil
    local minDist = math.huge

    for _, coin in pairs(container:GetChildren())do
        if coin.Name == 'Coin_Server' and coin:IsA('BasePart') and not FarmState.ignoredCoins[coin] then
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
    if not char then
        return
    end

    local hrp = char:FindFirstChild('HumanoidRootPart')

    if not hrp then
        return CFrame.Angles(0, 0, 0)
    end

    local bv = hrp:FindFirstChild('FarmBV')

    if not bv then
        bv = Instance.new('BodyVelocity')
        bv.Name = 'FarmBV'
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
    end

    local bg = hrp:FindFirstChild('FarmBG')

    if not bg then
        bg = Instance.new('BodyGyro')
        bg.Name = 'FarmBG'
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

    if not char then
        return
    end

    local hrp = char:FindFirstChild('HumanoidRootPart')

    if hrp then
        if hrp:FindFirstChild('FarmBV') then
            hrp.FarmBV:Destroy()
        end
        if hrp:FindFirstChild('FarmBG') then
            hrp.FarmBG:Destroy()
        end
    end
end
local function setupNoclip()
    local char = LocalPlayer.Character

    if not char then
        return
    end

    local humanoid = char:FindFirstChild('Humanoid')

    if humanoid then
        humanoid.PlatformStand = true
    end

    for _, part in pairs(char:GetDescendants())do
        if part:IsA('BasePart') and part.CanCollide then
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

            if connection then
                connection:Disconnect()
            end

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

            if connection then
                connection:Disconnect()
            end
        end
    end)

    while connection and connection.Connected do
        RunService.Heartbeat:Wait()
    end

    return reached
end
local function tweenToCoin(coin)
    if not coin or not coin.Parent or not coin:FindFirstChild('TouchInterest') then
        return false
    end

    local char = LocalPlayer.Character

    if not char then
        return false
    end

    local hrp = char:FindFirstChild('HumanoidRootPart')
    local hum = char:FindFirstChildOfClass('Humanoid')

    if not hrp or not hum then
        return false
    end

    local target = coin.Position + Vector3.new(0, 2, 0)

    if (hrp.Position - target).Magnitude < 5 then
        return true
    end
    if FarmState.currentTween then
        pcall(function()
            FarmState.currentTween:Cancel()
        end)
    end

    FarmState.currentTween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - target).Magnitude / FarmSettings.TweenSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(target),
    })
    hum.Sit = true

    FarmState.currentTween:Play()

    local done = false
    local c

    c = FarmState.currentTween.Completed:Connect(function()
        done = true

        if c then
            c:Disconnect()
        end
    end)

    local t0 = tick()

    while not done and FarmState.isFarming do
        task.wait(0.1)

        if not coin or not coin.Parent or not coin:FindFirstChild('TouchInterest') then
            if FarmState.currentTween then
                pcall(function()
                    FarmState.currentTween:Cancel()
                end)
            end

            hum.Sit = false

            return false
        end
        if tick() - t0 > 30 then
            if FarmState.currentTween then
                pcall(function()
                    FarmState.currentTween:Cancel()
                end)
            end

            hum.Sit = false

            return false
        end
    end

    hum.Sit = false

    return done
end
local function collectCoin(coin)
    if not coin or not coin.Parent then
        return
    end

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')

    if not hrp then
        return
    end

    pcall(function()
        firetouchinterest(hrp, coin, 0)
        task.wait(0.05)
        firetouchinterest(hrp, coin, 1)
    end)
end

function StartFarming()
    if FarmState.isFarming then
        return
    end

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
                        local hum = char:FindFirstChild('Humanoid')

                        if hum then
                            hum.Sit = false
                        end
                    end

                    task.wait(1)

                    return
                end

                local char = LocalPlayer.Character

                if not char then
                    return
                end

                local hrp = char:FindFirstChild('HumanoidRootPart')
                local torso = char:FindFirstChild('Torso') or char:FindFirstChild('LowerTorso') or char:FindFirstChild('HumanoidRootPart')
                local humanoid = char:FindFirstChild('Humanoid')

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

                    if humanoid then
                        humanoid.Sit = false
                    end

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

                    if humanoid then
                        humanoid.Sit = false
                    end

                    task.wait(0.5)

                    return
                end

                FarmState.isActivelyFlying = true
                FarmState.currentTargetCoin = targetCoin

                local reachedTarget = false

                if FarmSettings.Mode == 'Underground' then
                    setupNoclip()

                    local lockedRotation = applyFlightPhysics(char)
                    local targetPos = targetCoin.Position - Vector3.new(0, FarmSettings.UndergroundOffset, 0)

                    reachedTarget = flyToPoint(targetPos, targetCoin, hrp, torso, lockedRotation)
                elseif FarmSettings.Mode == 'Sit' then
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
        pcall(function()
            FarmState.currentTween:Cancel()
        end)

        FarmState.currentTween = nil
    end

    removePhysics()

    local char = LocalPlayer.Character

    if char then
        local humanoid = char:FindFirstChild('Humanoid')

        if humanoid then
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end
end

RunService.Stepped:Connect(function()
    if not FarmState.isFarming or not FarmState.isActivelyFlying or FarmSettings.Mode ~= 'Underground' then
        return
    end

    local char = LocalPlayer.Character

    if not char then
        return
    end

    local humanoid = char:FindFirstChild('Humanoid')

    if humanoid then
        humanoid.PlatformStand = true
    end

    for _, part in pairs(char:GetDescendants())do
        if part:IsA('BasePart') and part.CanCollide then
            part.CanCollide = false
        end
    end
end)

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

    if not char then
        return
    end

    local knife = char:FindFirstChild('Knife') or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild('Knife'))

    if not knife then
        return
    end
    if knife.Parent == LocalPlayer.Backpack then
        char.Humanoid:EquipTool(knife)
        task.wait(0.1)
    end

    local handleTouched = knife:FindFirstChild('Events') and knife.Events:FindFirstChild('HandleTouched')

    if handleTouched then
        for _, target in ipairs(Players:GetPlayers())do
            if target ~= LocalPlayer and target.Character then
                local hrp = target.Character:FindFirstChild('HumanoidRootPart')
                local humanoid = target.Character:FindFirstChild('Humanoid')

                if hrp and humanoid and humanoid.Health > 0 then
                    pcall(function()
                        handleTouched:FireServer(hrp)
                    end)
                    task.wait(0.05)
                end
            end
        end

        local stabbed = knife:FindFirstChild('KnifeStabbed')

        if stabbed then
            pcall(function()
                stabbed:FireServer()
            end)
        end
    else
        for _, victim in ipairs(Players:GetPlayers())do
            if victim ~= LocalPlayer and victim.Character and victim.Character:FindFirstChild('HumanoidRootPart') then
                local vHum = victim.Character:FindFirstChildOfClass('Humanoid')

                if vHum and vHum.Health > 0 then
                    pcall(function()
                        knife:Activate()

                        local targetPart = victim.Character:FindFirstChild('HumanoidRootPart') or victim.Character:FindFirstChild('Torso') or victim.Character:FindFirstChild('UpperTorso')

                        if targetPart then
                            char.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, 2)

                            task.wait(0.03)

                            if firetouchinterest then
                                firetouchinterest(targetPart, knife.Handle, 0)
                                task.wait(0.03)
                                firetouchinterest(targetPart, knife.Handle, 1)
                            end
                        end
                    end)
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

    for _, part in ipairs(char:GetDescendants())do
        if part:IsA('BasePart') then
            for _, otherPlayer in ipairs(Players:GetPlayers())do
                if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                    for _, otherPart in ipairs(otherPlayer.Character:GetDescendants())do
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
    for char, hat in pairs(HatVariables.parts)do
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
        for _, t in ipairs(TrailVariables.parts[char])do
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
    for char, parts in pairs(TrailVariables.parts)do
        for _, t in ipairs(parts)do
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
    for _, part in ipairs(char:GetDescendants())do
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
    for _, part in ipairs(char:GetDescendants())do
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
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants())do
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
local function FindMurdererWallBang()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local bp = plr:FindFirstChild('Backpack')
            if (char and char:FindFirstChild('Knife')) or (bp and bp:FindFirstChild('Knife')) then
                return plr
            end
        end
    end
    return nil
end

local function GetGunWallBang()
    local char = LocalPlayer.Character
    if not char then return nil end
    local gun = char:FindFirstChild('Gun') or char:FindFirstChild('Revolver')
    if gun then return gun end
    local bp = LocalPlayer:FindFirstChild('Backpack')
    if bp then
        gun = bp:FindFirstChild('Gun') or bp:FindFirstChild('Revolver')
        if gun then
            local hum = char:FindFirstChildOfClass('Humanoid')
            if hum then
                hum:EquipTool(gun)
                task.wait(0.05)
            end
            return gun
        end
    end
    return nil
end

local function WallBangShoot()
    if not Config.Settings.Combat.WallBang then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local gun = GetGunWallBang()
    if not gun then return false end
    local murderer = FindMurdererWallBang()
    if not murderer or not murderer.Character then return false end
    local mRoot = murderer.Character:FindFirstChild('HumanoidRootPart')
    local mHum = murderer.Character:FindFirstChildOfClass('Humanoid')
    if not mRoot or not mHum or mHum.Health <= 0 then return false end
    
    local ping = 0.06
    pcall(function()
        local stats = game:GetService('Stats')
        local net = stats:FindFirstChild('Network')
        if net then
            local ssi = net:FindFirstChild('ServerStatsItem')
            if ssi then
                local dp = ssi:FindFirstChild('Data Ping')
                if dp then ping = dp:GetValue() / 1000 end
            end
        end
    end)
    
    local predT = math.clamp(ping + 0.05, 0.01, 1.2)
    local vel = mRoot.AssemblyLinearVelocity
    if vel.Magnitude < 0.1 and mHum.MoveDirection.Magnitude > 0 then
        vel = mHum.MoveDirection * mHum.WalkSpeed
    end
    local predPos = mRoot.Position + vel * predT
    if mHum.FloorMaterial == Enum.Material.Air then
        predPos = predPos + Vector3.new(0, 0.5 * workspace.Gravity * predT ^ 2, 0)
    end
    if predPos.Y < mRoot.Position.Y - 2 then
        predPos = Vector3.new(predPos.X, mRoot.Position.Y - 0.5, predPos.Z)
    end
    
    local rootPos = char.HumanoidRootPart and char.HumanoidRootPart.Position or char.PrimaryPart.Position
    local shootRemote = gun:FindFirstChild('Shoot')
    if shootRemote and shootRemote:IsA('RemoteEvent') then
        local success = false
        pcall(function()
            shootRemote:FireServer(CFrame.new(rootPos, predPos), CFrame.new(predPos))
            success = true
        end)
        return success
    end
    local remote = ReplicatedStorage:FindFirstChild('ShootGun', true)
    if remote and remote:IsA('RemoteFunction') then
        pcall(function()
            remote:InvokeServer(1, predPos, predPos)
        end)
        return true
    end
    return false
end

local WallBangThread = nil

local function ToggleWallBang(state)
    Config.Settings.Combat.WallBang = state
    if WallBangThread then
        task.cancel(WallBangThread)
        WallBangThread = nil
    end
    if state then
        WallBangThread = task.spawn(function()
            while Config.Settings.Combat.WallBang do
                pcall(WallBangShoot)
                task.wait(0.15)
            end
        end)
    end
end

print('\u{26a1} [CANDY ZONE] All features loaded')

local NeverLose = loadstring(game:HttpGet('https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau'))()
local Notification = NeverLose:CreateNotification()
local Logging = NeverLose:CreateLogger()
local Indicator = NeverLose:CreateIndicator()
local window = NeverLose:CreateWindow({
    Logo = NeverLose.GlobalLogo,
    Name = 'Candy Zone',
    Content = 'MM2  |  v' .. Config.Version,
    Size = NeverLose.Scales.Default,
    ConfigFolder = 'CandyZone_NL',
    Enable3DRenderer = false,
    Keybind = 'RightShift',
})

window:SetAccount({
    Username = LocalPlayer.DisplayName or LocalPlayer.Name,
    Profile = 'Candy Zone MM2',
    Expires = 'Lifetime',
})

local Watermark = window:Watermark()

do
    local wmFPS = Watermark:AddBlock('chart-four-vertical-bars', 'FPS: 60')
    local wmGame = Watermark:AddBlock('cube-vertexes', Util:GetGameName())
    local wmUser = Watermark:AddBlock('user', Util:GetPlayerName())
    local wmToggle = Watermark:AddBlock('layout', 'Candy Zone')

    wmToggle:Input(function()
        window:ToggleInterface()
    end)
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                wmFPS:SetText('FPS: ' .. tostring(FPS.current))
            end)
        end
    end)
end

window:AddTabLabel('MAIN')

local VisualsTab = window:AddTab({
    Icon = 'eye',
    Name = 'Visuals',
})
local CombatTab = window:AddTab({
    Icon = 'crosshairs',
    Name = 'Combat',
})
local RageTab = window:AddTab({
    Icon = 'bolt',
    Name = 'Rage',
})
local FunTab = window:AddTab({
    Icon = 'star',
    Name = 'Fun',
})
local SettingsTab = window:AddTab({
    Icon = 'gear',
    Name = 'Settings',
})
local MiscTab = window:AddTab({
    Icon = 'box',
    Name = 'Misc',
})

do
    local sec = VisualsTab:AddSection({
        Name = 'TARGET ESP',
        Position = 'left',
    })

    sec:AddLabel('Enable Target ESP'):AddToggle({
        Default = Config.Settings.ESP.TargetESP,
        Flag = 'TargetESP',
        Callback = function(s)
            TargetESPVariables.enabled = s
        end,
    })
    sec:AddLabel('Rainbow Mode'):AddToggle({
        Default = TargetESPVariables.rainbow,
        Flag = 'TargetESP_Rainbow',
        Callback = function(s)
            TargetESPVariables.rainbow = s
        end,
    })
    sec:AddLabel('ESP Size'):AddSlider({
        Min = 20,
        Max = 100,
        Default = TargetESPVariables.size,
        Flag = 'TargetESP_Size',
        Callback = function(v)
            TargetESPVariables.size = v
        end,
    })
    sec:AddLabel('Max Radius'):AddSlider({
        Min = 10,
        Max = 150,
        Default = TargetESPVariables.maxRadius,
        Flag = 'TargetESP_Radius',
        Callback = function(v)
            TargetESPVariables.maxRadius = v
        end,
    })
    sec:AddLabel('Target Color'):AddColorPicker({
        Default = TargetESPVariables.color,
        Flag = 'TargetESP_Color',
        Callback = function(c)
            TargetESPVariables.color = c
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'ARROW ESP',
        Position = 'left',
    })

    sec:AddLabel('Enable Arrow ESP'):AddToggle({
        Default = Config.Settings.ESP.ArrowESP,
        Flag = 'ArrowESP',
        Callback = function(s)
            ArrowESPVariables.enabled = s
        end,
    })
    sec:AddLabel('Rainbow Mode'):AddToggle({
        Default = ArrowESPVariables.rainbow,
        Flag = 'ArrowESP_Rainbow',
        Callback = function(s)
            ArrowESPVariables.rainbow = s
        end,
    })
    sec:AddLabel('Distance'):AddSlider({
        Min = 50,
        Max = 150,
        Default = ArrowESPVariables.distance,
        Flag = 'ArrowESP_Dist',
        Callback = function(v)
            ArrowESPVariables.distance = v
        end,
    })
    sec:AddLabel('Arrow Color'):AddColorPicker({
        Default = ArrowESPVariables.color,
        Flag = 'ArrowESP_Color',
        Callback = function(c)
            ArrowESPVariables.color = c
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'ROLE ESP',
        Position = 'right',
    })

    sec:AddLabel('Enable ESP'):AddToggle({
        Default = false,
        Flag = 'ESP_Enabled',
        Callback = function(s)
            ToggleESP(s)
        end,
    })
    sec:AddLabel('Show Murderer'):AddToggle({
        Default = true,
        Flag = 'ESP_Murder',
        Callback = function(s)
            ToggleMurderer(s)
        end,
    })
    sec:AddLabel('Show Sheriff'):AddToggle({
        Default = true,
        Flag = 'ESP_Sheriff',
        Callback = function(s)
            ToggleSheriff(s)
        end,
    })
    sec:AddLabel('Show Hero'):AddToggle({
        Default = true,
        Flag = 'ESP_Hero',
        Callback = function(s)
            ToggleHero(s)
        end,
    })
    sec:AddLabel('Show Innocent'):AddToggle({
        Default = true,
        Flag = 'ESP_Innocent',
        Callback = function(s)
            ToggleInnocent(s)
        end,
    })
    sec:AddLabel('Show Self'):AddToggle({
        Default = true,
        Flag = 'ESP_Self',
        Callback = function(s)
            ToggleSelf(s)
        end,
    })
    sec:AddLabel('Murderer Color'):AddColorPicker({
        Default = ESP.Colors.Murderer,
        Flag = 'ESP_MurderColor',
        Callback = function(c)
            SetMurdererColor(c)
        end,
    })
    sec:AddLabel('Sheriff Color'):AddColorPicker({
        Default = ESP.Colors.Sheriff,
        Flag = 'ESP_SheriffColor',
        Callback = function(c)
            SetSheriffColor(c)
        end,
    })
    sec:AddLabel('Hero Color'):AddColorPicker({
        Default = ESP.Colors.Hero,
        Flag = 'ESP_HeroColor',
        Callback = function(c)
            SetHeroColor(c)
        end,
    })
    sec:AddLabel('Innocent Color'):AddColorPicker({
        Default = ESP.Colors.Innocent,
        Flag = 'ESP_InnocentColor',
        Callback = function(c)
            SetInnocentColor(c)
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'TRACERS',
        Position = 'right',
    })

    sec:AddLabel('Enable Tracers'):AddToggle({
        Default = false,
        Flag = 'Tracers',
        Callback = function(s)
            ToggleTracers(s)
        end,
    })
    sec:AddLabel('Thickness'):AddSlider({
        Min = 1,
        Max = 5,
        Default = 1,
        Flag = 'Tracer_Thick',
        Callback = function(v)
            TracerVariables.thickness = v
        end,
    })
    sec:AddLabel('Tracer Color'):AddColorPicker({
        Default = TracerVariables.color,
        Flag = 'Tracer_Color',
        Callback = function(c)
            TracerVariables.color = c
        end,
    })
    sec:AddLabel('Only Visible'):AddToggle({
        Default = false,
        Flag = 'Tracer_Visible',
        Callback = function(s)
            TracerVariables.onlyVisible = s
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'GUN BEAM',
        Position = 'left',
    })

    sec:AddLabel('Enable Gun Beam'):AddToggle({
        Default = false,
        Flag = 'GunBeam',
        Callback = function(s)
            ToggleGunBeam(s)
        end,
    })
    sec:AddLabel('Beam Type'):AddDropdown({
        Default = 'Neon Fat',
        Values = {
            'Default',
            'Neon Fat',
        },
        Flag = 'GunBeam_Type',
        Callback = function(v)
            SetGunBeamType(v)
        end,
    })
    sec:AddLabel('Beam Color'):AddColorPicker({
        Default = GunBeamSettings.beamColor,
        Flag = 'GunBeam_Color',
        Callback = function(c)
            SetGunBeamColor(c)
        end,
    })
    sec:AddLabel('Thickness'):AddSlider({
        Min = 0.5,
        Max = 5,
        Default = 1.5,
        Rounding = 1,
        Flag = 'GunBeam_Thick',
        Callback = function(v)
            GunBeamSettings.thickness = v
        end,
    })
    sec:AddLabel('Lifetime'):AddSlider({
        Min = 0.1,
        Max = 1,
        Default = 0.25,
        Rounding = 2,
        Flag = 'GunBeam_Life',
        Callback = function(v)
            GunBeamSettings.lifetime = v
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'CHINESE HAT',
        Position = 'right',
    })

    sec:AddLabel('Enable Hat'):AddToggle({
        Default = false,
        Flag = 'Hat_Enabled',
        Callback = function(s)
            Hat_ToggleEnabled(s)
        end,
    })
    sec:AddLabel('Hat Style'):AddDropdown({
        Default = 'Classic',
        Values = {
            'Classic',
            'Drawing',
        },
        Flag = 'Hat_Style',
        Callback = function(v)
            Hat_ChangeStyle(v)
        end,
    })
    sec:AddLabel('Rainbow'):AddToggle({
        Default = false,
        Flag = 'Hat_Rainbow',
        Callback = function(s)
            HatVariables.rainbow = s
        end,
    })
    sec:AddLabel('Rainbow Speed'):AddSlider({
        Min = 1,
        Max = 20,
        Default = 5,
        Flag = 'Hat_RainbowSpeed',
        Callback = function(v)
            HatVariables.rainbowSpeed = v
        end,
    })
    sec:AddLabel('Transparency'):AddSlider({
        Min = 0,
        Max = 100,
        Default = 30,
        Flag = 'Hat_Trans',
        Callback = function(v)
            HatVariables.transparency = v / 100
        end,
    })
    sec:AddLabel('Radius'):AddSlider({
        Min = 5,
        Max = 100,
        Default = 24,
        Flag = 'Hat_Radius',
        Callback = function(v)
            HatVariables.radius = v / 10
        end,
    })
    sec:AddLabel('Height'):AddSlider({
        Min = 5,
        Max = 50,
        Default = 16,
        Flag = 'Hat_Height',
        Callback = function(v)
            HatVariables.height = v / 10
        end,
    })
    sec:AddLabel('Hat Color'):AddColorPicker({
        Default = HatVariables.color,
        Flag = 'Hat_Color',
        Callback = function(c)
            HatVariables.color = c
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'TRAIL',
        Position = 'left',
    })

    sec:AddLabel('Enable Trail'):AddToggle({
        Default = false,
        Flag = 'Trail_Enabled',
        Callback = function(s)
            Trail_ToggleEnabled(s)
        end,
    })
    sec:AddLabel('Gradient Mode'):AddToggle({
        Default = false,
        Flag = 'Trail_Gradient',
        Callback = function(s)
            TrailVariables.isGradient = s

            if TrailVariables.enabled and LocalPlayer.Character then
                Trail_AddToCharacter(LocalPlayer.Character)
            end
        end,
    })
    sec:AddLabel('Lifetime'):AddSlider({
        Min = 1,
        Max = 30,
        Default = 5,
        Flag = 'Trail_Life',
        Callback = function(v)
            TrailVariables.lifetime = v / 10

            Trail_UpdateAll()
        end,
    })
    sec:AddLabel('Rainbow'):AddToggle({
        Default = false,
        Flag = 'Trail_Rainbow',
        Callback = function(s)
            TrailVariables.rainbow = s

            Trail_UpdateAll()
        end,
    })
    sec:AddLabel('Static Color'):AddColorPicker({
        Default = TrailVariables.colorStatic,
        Flag = 'Trail_Color',
        Callback = function(c)
            TrailVariables.colorStatic = c

            Trail_UpdateAll()
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'FORCEFIELD',
        Position = 'right',
    })

    sec:AddLabel('Enable ForceField'):AddToggle({
        Default = false,
        Flag = 'FF_Enabled',
        Callback = function(s)
            ForceField_ToggleEnabled(s)
        end,
    })
    sec:AddLabel('Rainbow'):AddToggle({
        Default = false,
        Flag = 'FF_Rainbow',
        Callback = function(s)
            ForceFieldVariables.rainbow = s

            ForceField_Update()
        end,
    })
    sec:AddLabel('ForceField Color'):AddColorPicker({
        Default = ForceFieldVariables.color,
        Flag = 'FF_Color',
        Callback = function(c)
            ForceFieldVariables.color = c

            if ForceFieldVariables.enabled and LocalPlayer.Character then
                ForceField_Apply(LocalPlayer.Character)
            end
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'AURA TRAILER',
        Position = 'left',
    })

    sec:AddLabel('Enable Aura'):AddToggle({
        Default = false,
        Flag = 'Aura_Enabled',
        Callback = function(s)
            AuraTrailer_Toggle(s)
        end,
    })
    sec:AddLabel('Aura Color'):AddColorPicker({
        Default = AuraTrailerVariables.color,
        Flag = 'Aura_Color',
        Callback = function(c)
            AuraTrailerVariables.color = c

            if AuraTrailerVariables.enabled then
                AuraTrailer_Update()
            end
        end,
    })
    sec:AddLabel('Lifetime'):AddSlider({
        Min = 1,
        Max = 30,
        Default = 5,
        Flag = 'Aura_Life',
        Callback = function(v)
            AuraTrailerVariables.lifetime = v / 10

            if AuraTrailerVariables.enabled then
                AuraTrailer_Update()
            end
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'SKYBOX & LIGHTING',
        Position = 'right',
    })
    local skyList = {}

    for k in pairs(SkyboxAssets)do
        table.insert(skyList, k)
    end

    table.sort(skyList)
    sec:AddLabel('Select Skybox'):AddDropdown({
        Default = 'HD',
        Values = skyList,
        Flag = 'Skybox_Current',
        Callback = function(v)
            SkyboxVariables.current = v

            if SkyboxVariables.customEnabled then
                Skybox_Apply(v)
            end
        end,
    })
    sec:AddLabel('Enable Skybox'):AddToggle({
        Default = false,
        Flag = 'Skybox_Enabled',
        Callback = function(s)
            SkyboxVariables.customEnabled = s

            if s then
                Skybox_Apply(SkyboxVariables.current)
            else
                Skybox_RestoreDefault()
            end
        end,
    })
    sec:AddLabel('Time Changer'):AddToggle({
        Default = false,
        Flag = 'Time_Enabled',
        Callback = function(s)
            WorldVariables.timeEnabled = s
        end,
    })
    sec:AddLabel('Time (0-24)'):AddSlider({
        Min = 0,
        Max = 24,
        Default = 12,
        Flag = 'Time_Value',
        Callback = function(v)
            WorldVariables.timeValue = v
        end,
    })
    sec:AddLabel('Full Bright'):AddToggle({
        Default = false,
        Flag = 'FullBright',
        Callback = function(s)
            WorldVariables.fullBrightEnabled = s

            if not s then
                Lighting.Brightness = defaultLighting.Brightness
                Lighting.GlobalShadows = defaultLighting.GlobalShadows
                Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
            end
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'NEBULA & SCREEN',
        Position = 'left',
    })

    sec:AddLabel('Enable Nebula'):AddToggle({
        Default = false,
        Flag = 'Nebula_Enabled',
        Callback = function(s)
            NebulaVariables.enabled = s

            if s then
                Nebula_Enable()
            else
                Nebula_Disable()
            end
        end,
    })
    sec:AddLabel('Nebula Color'):AddColorPicker({
        Default = NebulaVariables.themeColor,
        Flag = 'Nebula_Color',
        Callback = function(c)
            NebulaVariables.themeColor = c

            Nebula_UpdateColor()
        end,
    })
    sec:AddLabel('Screen Stretch'):AddToggle({
        Default = false,
        Flag = 'Screen_Enabled',
        Callback = function(s)
            Screen_Toggle(s)
        end,
    })
    sec:AddLabel('Stretch Intensity'):AddSlider({
        Min = 0,
        Max = 20,
        Default = 0,
        Flag = 'Screen_Intensity',
        Callback = function(v)
            WorldVariables.screenIntensity = v / 100
        end,
    })
    sec:AddLabel('Anime Image'):AddToggle({
        Default = false,
        Flag = 'Anime',
        Callback = function(s)
            Anime_Toggle(s)
        end,
    })
end
do
    local sec = VisualsTab:AddSection({
        Name = 'HITSOUND',
        Position = 'right',
    })
    local gunshotOptions = {
        'None',
    }

    for name in pairs(HitsoundData.gunshotSounds)do
        table.insert(gunshotOptions, name)
    end

    table.sort(gunshotOptions)

    local knifeOptions = {
        'None',
    }

    for name in pairs(HitsoundData.knifeKillSounds)do
        table.insert(knifeOptions, name)
    end

    table.sort(knifeOptions)
    sec:AddLabel('Gunshot Sound'):AddDropdown({
        Default = HitsoundData.selectedGunshot or 'None',
        Values = gunshotOptions,
        Flag = 'HS_Gunshot',
        Callback = function(sound)
            HitsoundData.selectedGunshot = (sound == 'None') and nil or sound
        end,
    })
    sec:AddLabel('Knife Kill Sound'):AddDropdown({
        Default = HitsoundData.selectedKnifeKill or 'None',
        Values = knifeOptions,
        Flag = 'HS_Knife',
        Callback = function(sound)
            HitsoundData.selectedKnifeKill = (sound == 'None') and nil or sound
        end,
    })
end
do
    local sec = CombatTab:AddSection({
        Name = 'CAMLOCK',
        Position = 'left',
    })

    sec:AddLabel('Camlock Aim'):AddToggle({
        Default = Config.Settings.Combat.Camlock,
        Flag = 'Camlock',
        Callback = function(s)
            Config.Settings.Combat.Camlock = s
        end,
    })
    sec:AddLabel('FOV'):AddSlider({
        Min = 0,
        Max = 360,
        Default = Config.Settings.Combat.CamlockFOV,
        Flag = 'Camlock_FOV',
        Callback = function(v)
            Config.Settings.Combat.CamlockFOV = v
        end,
    })
    sec:AddLabel('Predict'):AddSlider({
        Min = 0,
        Max = 200,
        Default = Config.Settings.Combat.CamlockPredict,
        Flag = 'Camlock_Predict',
        Callback = function(v)
            Config.Settings.Combat.CamlockPredict = v
        end,
    })
    sec:AddLabel('Smoothness'):AddSlider({
        Min = 0,
        Max = 100,
        Default = Config.Settings.Combat.CamlockSmooth,
        Flag = 'Camlock_Smooth',
        Callback = function(v)
            Config.Settings.Combat.CamlockSmooth = v
        end,
    })
    sec:AddLabel('Visible Check'):AddToggle({
        Default = Config.Settings.Combat.VisibleCheck,
        Flag = 'Camlock_Visible',
        Callback = function(s)
            Config.Settings.Combat.VisibleCheck = s
        end,
    })
end
do
    local sec = CombatTab:AddSection({
        Name = 'SHOOT & KILL',
        Position = 'right',
    })

    sec:AddLabel('Draggable Shoot Button'):AddToggle({
        Default = false,
        Flag = 'ShootButton',
        Callback = function(s)
            if s then
                createDraggableShootButton()
            else
                removeDraggableShootButton()
            end
        end,
    })
    sec:AddButton({
        Icon = 'crosshairs',
        Name = 'Shoot Murderer Now',
        Callback = function()
            shootMurdererDirect()
        end,
    })
    sec:AddLabel('Auto Shoot Murderer'):AddToggle({
        Default = Config.Settings.Combat.AutoShoot,
        Flag = 'AutoShoot',
        Callback = function(s)
            Config.Settings.Combat.AutoShoot = s
        end,
    })
    sec:AddLabel('Auto Kill All'):AddToggle({
        Default = Config.Settings.Combat.AutoKillAll,
        Flag = 'AutoKillAll',
        Callback = function(s)
            Config.Settings.Combat.AutoKillAll = s
        end,
    })
    sec:AddButton({
        Icon = 'sword',
        Name = 'Kill All Now',
        Callback = function()
            killAll()
        end,
    })
end
do
    local sec = CombatTab:AddSection({
        Name = 'AUTOFARM & BOMB',
        Position = 'left',
    })

    sec:AddLabel('AutoFarm Coins'):AddToggle({
        Default = FarmSettings.Enabled,
        Flag = 'AutoFarm',
        Callback = function(s)
            FarmSettings.Enabled = s

            if s then
                StartFarming()
            else
                StopFarming()
            end
        end,
    })
    sec:AddLabel('Farm Mode'):AddDropdown({
        Default = FarmSettings.Mode,
        Values = {
            'Underground',
            'Sit',
        },
        Flag = 'Farm_Mode',
        Callback = function(v)
            FarmSettings.Mode = v

            if FarmState.isFarming then
                StopFarming()
                StartFarming()
            end
        end,
    })
    sec:AddLabel('Tween Speed'):AddSlider({
        Min = 10,
        Max = 100,
        Default = FarmSettings.TweenSpeed,
        Flag = 'Farm_Speed',
        Callback = function(v)
            FarmSettings.TweenSpeed = v
        end,
    })
    sec:AddLabel('Auto Reset'):AddToggle({
        Default = FarmSettings.AutoReset,
        Flag = 'Farm_AutoReset',
        Callback = function(s)
            FarmSettings.AutoReset = s
        end,
    })
    sec:AddLabel('Avoid Murder'):AddToggle({
        Default = FarmSettings.AvoidMurder,
        Flag = 'Farm_AvoidMurder',
        Callback = function(s)
            FarmSettings.AvoidMurder = s
        end,
    })
    sec:AddButton({
        Icon = 'bomb',
        Name = 'Bomb Jump',
        Callback = function()
            executeBombJump()
        end,
    })
end
do
    local sec = CombatTab:AddSection({
        Name = 'OTHER',
        Position = 'right',
    })

    sec:AddLabel('Anti Fling'):AddToggle({
        Default = Config.Settings.Combat.AntiFling,
        Flag = 'AntiFling',
        Callback = function(s)
            Config.Settings.Combat.AntiFling = s
        end,
    })
    sec:AddLabel('Anti-Void'):AddToggle({
        Default = Config.Settings.Combat.AntiVoid,
        Flag = 'AntiVoid',
        Callback = function(s)
            Config.Settings.Combat.AntiVoid = s

            if s then
                workspace.FallenPartsDestroyHeight = 0 / 0
            else
                workspace.FallenPartsDestroyHeight = Features.FPDH
            end
        end,
    })
    sec:AddLabel('Auto WallHop'):AddToggle({
        Default = Config.Settings.Combat.AutoWallHop,
        Flag = 'AutoWallHop',
        Callback = function(s)
            Config.Settings.Combat.AutoWallHop = s
        end,
    })
    sec:AddLabel('Grab Gun'):AddToggle({
        Default = Config.Settings.Combat.GrabGun,
        Flag = 'GrabGun',
        Callback = function(s)
            Config.Settings.Combat.GrabGun = s
        end,
    })
sec:AddLabel('Wall Bang'):AddToggle({
    Default = Config.Settings.Combat.WallBang,
    Flag = 'WallBang',
    Callback = function(s)
        ToggleWallBang(s)
    end,
})
end
do
    local sec = RageTab:AddSection({
        Name = 'RAGE FEATURES',
        Position = 'left',
    })

    sec:AddLabel('SpinBot'):AddToggle({
        Default = Config.Settings.Rage.SpinBot,
        Flag = 'SpinBot',
        Callback = function(s)
            Config.Settings.Rage.SpinBot = s
        end,
    })
    sec:AddLabel('SpinBot Speed'):AddSlider({
        Min = 1,
        Max = 100,
        Default = Config.Settings.Rage.SpinSpeed,
        Flag = 'SpinSpeed',
        Callback = function(v)
            Config.Settings.Rage.SpinSpeed = v
        end,
    })
    sec:AddLabel('Speed Glitch'):AddToggle({
        Default = Config.Settings.Rage.SpeedGlitch,
        Flag = 'SpeedGlitch',
        Callback = function(s)
            Config.Settings.Rage.SpeedGlitch = s
        end,
    })
    sec:AddLabel('Speed Force'):AddSlider({
        Min = 15,
        Max = 100,
        Default = Config.Settings.Rage.SpeedForce,
        Flag = 'SpeedForce',
        Callback = function(v)
            Config.Settings.Rage.SpeedForce = v
        end,
    })
    sec:AddLabel('Noclip'):AddToggle({
        Default = Config.Settings.Rage.Noclip,
        Flag = 'Noclip',
        Callback = function(s)
            setNoclip(s)
        end,
    })
    sec:AddLabel('Fly'):AddToggle({
        Default = Config.Settings.Rage.Fly,
        Flag = 'Fly',
        Callback = function(s)
            Config.Settings.Rage.Fly = s

            setFly(s)
        end,
    })
    sec:AddLabel('Fly Speed'):AddSlider({
        Min = 10,
        Max = 150,
        Default = Config.Settings.Rage.FlySpeed,
        Flag = 'FlySpeed',
        Callback = function(v)
            Config.Settings.Rage.FlySpeed = v
        end,
    })
end
do
    local sec = FunTab:AddSection({
        Name = 'FLING',
        Position = 'left',
    })

    sec:AddButton({
        Icon = 'refresh',
        Name = 'Refresh Player List (Fling)',
        Callback = function()
            Notification.new({
                Title = 'Candy Zone',
                Content = 'Rejoin or re-exec to refresh list',
                Duration = 3,
            })
        end,
    })

    for _, player in ipairs(Players:GetPlayers())do
        if player ~= LocalPlayer then
            local pName = (player.DisplayName or player.Name) .. ' (@' .. player.Name .. ')'
            local plr = player

            sec:AddButton({
                Icon = 'user',
                Name = pName,
                Callback = function()
                    flingPlayer(plr)
                end,
            })
        end
    end
end
do
    local sec = FunTab:AddSection({
        Name = 'TELEPORT',
        Position = 'right',
    })

    for _, player in ipairs(Players:GetPlayers())do
        if player ~= LocalPlayer then
            local pName = (player.DisplayName or player.Name) .. ' (@' .. player.Name .. ')'
            local plr = player

            sec:AddButton({
                Icon = 'location',
                Name = pName,
                Callback = function()
                    local char = LocalPlayer.Character
                    local targetChar = plr.Character

                    if char and targetChar then
                        local hrp = char:FindFirstChild('HumanoidRootPart')
                        local targetHrp = targetChar:FindFirstChild('HumanoidRootPart')

                        if hrp and targetHrp then
                            hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 2, 2)
                        end
                    end
                end,
            })
        end
    end
end
do
    local sec = SettingsTab:AddSection({
        Name = 'KEYBINDS',
        Position = 'left',
    })

    sec:AddLabel('Toggle GUI'):AddKeybind({
        Default = 'RightShift',
        Flag = 'KB_ToggleGUI',
        Callback = function(key)
            if type(key) == 'string' then
                Config.Settings.Keybinds.ToggleGUI = Enum.KeyCode[key] or Enum.KeyCode.RightShift
                window.Keybind = key
            elseif typeof(key) == 'EnumItem' then
                Config.Settings.Keybinds.ToggleGUI = key
                window.Keybind = key.Name
            end
        end,
    })
    sec:AddLabel('Panic Key'):AddKeybind({
        Default = 'End',
        Flag = 'KB_Panic',
        Callback = function(key)
            if type(key) == 'string' then
                Config.Settings.Keybinds.PanicKey = Enum.KeyCode[key] or Enum.KeyCode.End
            elseif typeof(key) == 'EnumItem' then
                Config.Settings.Keybinds.PanicKey = key
            end
        end,
    })
    sec:AddLabel('Camlock'):AddKeybind({
        Default = 'Q',
        Flag = 'KB_Camlock',
        Callback = function(key)
            if type(key) == 'string' then
                Config.Settings.Keybinds.Camlock = Enum.KeyCode[key] or Enum.KeyCode.Q
            elseif typeof(key) == 'EnumItem' then
                Config.Settings.Keybinds.Camlock = key
            end
        end,
    })
    sec:AddLabel('Silent Aim'):AddKeybind({
        Default = 'E',
        Flag = 'KB_SilentAim',
        Callback = function(key)
            if type(key) == 'string' then
                Config.Settings.Keybinds.SilentAim = Enum.KeyCode[key] or Enum.KeyCode.E
            elseif typeof(key) == 'EnumItem' then
                Config.Settings.Keybinds.SilentAim = key
            end
        end,
    })
end
do
    local sec = SettingsTab:AddSection({
        Name = 'CONFIG',
        Position = 'right',
    })

    sec:AddButton({
        Icon = 'save',
        Name = 'Save Current Config',
        Callback = function()
            local ok = saveCurrentConfig()

            Notification.new({
                Title = 'Candy Zone',
                Content = ok and 'Config saved!' or 'Failed to save (no writefile)',
                Duration = 4,
            })
        end,
    })
    sec:AddButton({
        Icon = 'folder-open',
        Name = 'Load Saved Config',
        Callback = function()
            local ok = loadAndApplyConfig()

            Notification.new({
                Title = 'Candy Zone',
                Content = ok and 'Config loaded!' or 'No config found',
                Duration = 4,
            })
        end,
    })
    sec:AddButton({
        Icon = 'trash',
        Name = 'Reset to Defaults',
        Callback = function()
            resetToDefaults()
            Notification.new({
                Title = 'Candy Zone',
                Content = 'Config reset to defaults',
                Duration = 4,
            })
        end,
    })
    sec:AddButton({
        Icon = 'clipboard',
        Name = 'Export Config (Clipboard)',
        Callback = function()
            local ok, msg = exportConfig()

            Notification.new({
                Title = 'Candy Zone',
                Content = msg or (ok and 'Copied' or 'Failed'),
                Duration = 4,
            })
        end,
    })
end
do
    window.UserSettings:AddLabel('Menu Keybind'):AddKeybind({
        Default = 'RightShift',
        Callback = function(v)
            window.Keybind = v

            Logging.new('ps4-touchpad', 'Changed UI keybind to ' .. tostring(v), 5)
        end,
    })
    window.UserSettings:AddLabel('Menu Scale'):AddDropdown({
        Default = 'Default',
        Values = {
            'Default',
            'Large',
            'Mobile',
            'Small',
        },
        Callback = function(v)
            if NeverLose.Scales[v] then
                window:SetSize(NeverLose.Scales[v])
                Logging.new('crop', 'Changed UI size to ' .. tostring(v), 5)
            end
        end,
    })
    window.UserSettings:AddLabel('3D Menu'):AddToggle({
        Default = false,
        Callback = function(v)
            window:Set3DRender(v)
        end,
    })
    window.UserSettings:AddButton({
        Icon = 'discord',
        Name = 'Discord',
        Callback = function()
            if setclipboard then
                setclipboard(Config.Discord)
            end

            Logging.new('discord', 'Copied Discord: ' .. Config.Discord, 5)
        end,
    })
end
do
    local sec = MiscTab:AddSection({
        Name = 'UTILITIES',
        Position = 'left',
    })

    sec:AddButton({
        Icon = 'link',
        Name = 'Copy Game Link',
        Callback = function()
            if setclipboard then
                setclipboard('https://www.roblox.com/games/' .. tostring(game.PlaceId))
                Notification.new({
                    Title = 'Candy Zone',
                    Content = 'Game link copied',
                    Duration = 3,
                })
            end
        end,
    })
    sec:AddButton({
        Icon = 'image',
        Name = 'Lower Graphics (All Plastic)',
        Callback = function()
            for _, obj in ipairs(workspace:GetDescendants())do
                if obj:IsA('BasePart') then
                    obj.Material = Enum.Material.Plastic
                end
            end

            Notification.new({
                Title = 'Candy Zone',
                Content = 'Graphics lowered',
                Duration = 3,
            })
        end,
    })
end
do
    local sec = MiscTab:AddSection({
        Name = 'INFORMATION',
        Position = 'right',
    })

    sec:AddLabel('Developer: ' .. Config.Developer, true)
    sec:AddLabel('Version: ' .. Config.Version, true)
    sec:AddLabel('Discord: ' .. Config.Discord, true)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then
        return
    end
    if input.KeyCode == Config.Settings.Keybinds.WallBang then
        ToggleWallBang(not Config.Settings.Combat.WallBang)
    end
    if input.KeyCode == Config.Settings.Keybinds.PanicKey then
        pcall(saveCurrentConfig)
        pcall(function()
            window:ToggleInterface()
        end)
        removeDraggableShootButton()
        RemoveWallBangButton()

        for _, c in ipairs(Features.Connections)do
            pcall(function()
                c:Disconnect()
            end)
        end

        Notification.new({
            Title = 'Candy Zone',
            Content = 'Panic activated \u{2014} config saved',
            Duration = 3,
        })
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
Notification.new({
    Title = '\u{1f36c} Candy Zone MM2',
    Content = 'Press RightShift to open  |  v' .. Config.Version,
    Duration = 6,
})
print('\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}')
print('\u{1f36c} CANDY ZONE MM2 v' .. Config.Version .. ' (NeverLose UI)')
print('\u{2705} Successfully Loaded!')
print('\u{1f3ae} Game: ' .. Util:GetGameName())
print('\u{1f464} Developer: ' .. Config.Developer)
print('\u{1f4ac} Discord: ' .. Config.Discord)
print('\u{2328}\u{fe0f} Toggle: RightShift | Panic: End')
print('\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}\u{2550}')
task.wait(0.5)

local loaded = loadAndApplyConfig()

if loaded then
    print('[CandyZone] Config loaded from CandyZone/Candycfg.json')
else
    print('[CandyZone] No config found, using defaults')
    pcall(function()
        saveConfig(DefaultConfig)
    end)
end
