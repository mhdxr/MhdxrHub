local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [[ SECURITY & BOOTLOADER ]] --
local KeyInput = ""
local CorrectKey = "MHDXR-2025" 
local IsVerified = false

local function BootLoader()
    local BootWindow = WindUI:CreateWindow({
        Title = "Security System - MhdxrHub",
        Icon = "shield-check",
        Size = UDim2.fromOffset(400, 250),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = true
    })
    local SecTab = BootWindow:Tab({ Title = "Verification", Icon = "key" })
    SecTab:Input({
        Title = "Enter License Key",
        Placeholder = "MHDXR-XXXX",
        Callback = function(text) KeyInput = text end
    })
    SecTab:Button({
        Title = "Verify Key",
        Callback = function()
            if KeyInput == CorrectKey then
                IsVerified = true
                BootWindow:Close()
            end
        end
    })
    repeat task.wait(0.5) until IsVerified
end

BootLoader()
if not IsVerified then return end

-- [[ MAIN WINDOW ]] --
local Window = WindUI:CreateWindow({
    Title = "MhdxrHub - Fish It Premium",
    Icon = "rbxassetid://130348378128532",
    Author = "Mhdxr Team",
    Folder = "MhdxrHub",
    Size = UDim2.fromOffset(600, 360),
    Theme = "Sky",
    HideSearchBar = true,
})

Window:Tag({
    Title = "Premium V 1.0.9",
    Icon = "terminal", 
    Color = Color3.fromHex("#00FF00"),
    Radius = 11,
})

-- [[ GLOBAL SERVICES & HELPERS ]] --
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local RepStorage = game:GetService("ReplicatedStorage")
local RPath = {"Packages", "_Index", "sleitnick_net@0.2.0", "net"}

local function GetRemote(remotePath, name, timeout)
    local currentInstance = RepStorage
    for _, childName in ipairs(remotePath) do
        currentInstance = currentInstance:WaitForChild(childName, timeout or 0.5)
        if not currentInstance then return nil end
    end
    return currentInstance:FindFirstChild(name)
end

-- [[ ANTI-STAFF SYSTEM (V1.0.8) ]] --
local function CheckStaff()
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player:GetRankInGroup(3253685) >= 10 or player.Name:lower():find("admin") then
            LocalPlayer:Kick("\n[Security]\nStaff Detected: " .. player.Name)
        end
    end
end
game.Players.PlayerAdded:Connect(CheckStaff)

-- [[ OVERLAY UI STATS (V1.0.8) ]] --
local StatsOverlay = Instance.new("ScreenGui", game.CoreGui)
local OverlayFrame = Instance.new("Frame", StatsOverlay)
OverlayFrame.Size = UDim2.new(0, 200, 0, 100)
OverlayFrame.Position = UDim2.new(0, 10, 0.4, 0)
OverlayFrame.BackgroundTransparency = 0.5
OverlayFrame.BackgroundColor3 = Color3.new(0,0,0)

local StatText = Instance.new("TextLabel", OverlayFrame)
StatText.Size = UDim2.new(1, 0, 1, 0)
StatText.TextColor3 = Color3.new(1,1,1)
StatText.TextSize = 14
StatText.Font = Enum.Font.Code

RunService.RenderStepped:Connect(function()
    local ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
    local fps = math.floor(1/RunService.RenderStepped:Wait())
    StatText.Text = string.format("FPS: %d\nPing: %dms\nLevel: %s", fps, ping, "Loading...")
end)

-- [[ TABS ]] --

-- HOME
local home = Window:Tab({ Title = "Home", Icon = "home" })
home:Section({ Title = "Changelog V 1.0.9", TextSize = 18 })
home:Paragraph({
    Title = "What's New?",
    Desc = "[+] Hacker Event Teleport\n[+] Auto Open Treasure Chest\n[+] Anti-Staff & Overlay UI\n[~] Fixed Christmas Cave TP Bug"
})

-- EVENT TAB (V1.0.9)
local EventTab = Window:Tab({ Title = "Events", Icon = "zap" })
local HackerSec = EventTab:Section({ Title = "Hacker & Treasure", TextSize = 18 })

HackerSec:Button({
    Title = "Teleport to Hacker Island",
    Icon = "terminal",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(-1250, 45, -4500) end
    end
})

local autoChest = false
HackerSec:Toggle({
    Title = "Auto Open Treasure Chest",
    Value = false,
    Callback = function(state)
        autoChest = state
        task.spawn(function()
            while autoChest do
                local remote = GetRemote(RPath, "RF/OpenTreasureChest")
                if remote then remote:InvokeServer() end
                task.wait(1.5)
            end
        end)
    end
})

-- CHRISTMAS TAB (V1.0.7)
local Christmas = Window:Tab({ Title = "Christmas", Icon = "gift" })
Christmas:Toggle({
    Title = "Auto Santa Factory",
    Callback = function(state)
        _G.AutoSanta = state
        while _G.AutoSanta do
            local rem = GetRemote(RPath, "RE/SantaFactoryInteract")
            if rem then rem:FireServer() end
            task.wait(1)
        end
    end
})

-- [[ AUTO SAVE POSITION & TP BACK (V1.0.7/V1.0.9) ]] --
local PosFile = "Mhdxr_Pos.json"
task.spawn(function()
    while true do
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local data = {x = hrp.Position.X, y = hrp.Position.Y, z = hrp.Position.Z}
            writefile(PosFile, HttpService:JSONEncode(data))
        end
        task.wait(10)
    end
end)

-- Restore Position after Event/Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(3)
    if isfile(PosFile) then
        local data = HttpService:JSONDecode(readfile(PosFile))
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(data.x, data.y, data.z) end
    end
end)

WindUI:Notify({ Title = "MhdxrHub V1.0.9", Content = "Script Loaded Successfully!", Duration = 5, Icon = "check" })
