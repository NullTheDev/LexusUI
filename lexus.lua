local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("LexusUI") then CoreGui:FindFirstChild("LexusUI"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LexusUI"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.DisplayOrder = 999999

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 30, 45))
})
UIGradient.Parent = MainFrame

local function MemoryPatch()
    local success, err = pcall(function()
        if setfflag then
            setfflag("AbuseReportScreenshot", "False")
            setfflag("LuaWebViewCrashReporting", "False")
        end
        if hookmetamethod then
            local old; old = hookmetamethod(game, "__index", function(self, key)
                if not checkcaller() and (key == "WalkSpeed" or key == "JumpPower") then
                    return 16
                end
                return old(self, key)
            end)
        end
    end)
end
MemoryPatch()

local ParticleEmitter = Instance.new("ParticleEmitter")
ParticleEmitter.Acceleration = Vector3.new(0, 0.5, 0)
ParticleEmitter.Lifetime = NumberRange.new(1, 2)
ParticleEmitter.Rate = 5
ParticleEmitter.Speed = NumberRange.new(5, 10)
ParticleEmitter.Transparency = NumberSequence.new(0.5, 1)
ParticleEmitter.Size = NumberSequence.new(2, 0)
ParticleEmitter.Enabled = false
local Attachment = Instance.new("Attachment", MainFrame)
ParticleEmitter.Parent = Attachment

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -20)
Content.Position = UDim2.new(0, 165, 0, 10)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local TabButtons = Instance.new("ScrollingFrame")
TabButtons.Size = UDim2.new(1, 0, 1, -60)
TabButtons.Position = UDim2.new(0, 0, 0, 60)
TabButtons.BackgroundTransparency = 1
TabButtons.ScrollBarThickness = 0
TabButtons.Parent = Sidebar
Instance.new("UIListLayout", TabButtons).Padding = UDim.new(0, 5)

local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundTransparency = 1
    Btn.Text = "  " .. name
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = TabButtons

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 0
    Page.Parent = Content
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        Page.Visible = true
    end)
    return Page
end

local MovePage = CreateTab("Movement")
local PlayerPage = CreateTab("Player List")
local VisualPage = CreateTab("Visuals")
local ThemePage = CreateTab("Customization")

local flyActive = false
local flyMode = "Static"
local flyMult = 5

RunService.RenderStepped:Connect(function()
    if not flyActive or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = Player.Character.HumanoidRootPart
    local cam = workspace.CurrentCamera.CFrame
    root.Velocity = Vector3.new(0, 0.1, 0) -- Anti-Fall Gravity Nullifier

    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += (flyMode == "Dynamic" and cam.LookVector or cam.LookVector * Vector3.new(1,0,1)) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= (flyMode == "Dynamic" and cam.LookVector or cam.LookVector * Vector3.new(1,0,1)) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
    
    root.CFrame = root.CFrame + (dir * flyMult)
end)

local function AddToggle(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(30,30,35)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parent
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(80, 60, 200) or Color3.fromRGB(30,30,35)
        cb(state)
    end)
end

AddToggle(MovePage, "Static Fly (Fast)", function(v) flyActive = v; flyMode = "Static" end)
AddToggle(MovePage, "Dynamic Fly (Look)", function(v) flyActive = v; flyMode = "Dynamic" end)

local SelectedPlayer = nil
local PList = Instance.new("ScrollingFrame", PlayerPage)
PList.Size = UDim2.new(1, 0, 0.7, 0)
PList.BackgroundTransparency = 0.9
Instance.new("UIListLayout", PList)

local Controls = Instance.new("Frame", PlayerPage)
Controls.Size = UDim2.new(1, 0, 0.25, 0)
Controls.BackgroundTransparency = 1

local function RefreshList()
    for _, v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", PList)
        b.Size = UDim2.new(1, 0, 0, 25)
        b.Text = p.Name
        b.MouseButton1Click:Connect(function() SelectedPlayer = p end)
    end
end
RefreshList()

local GoTo = Instance.new("TextButton", Controls)
GoTo.Size = UDim2.new(0, 100, 0, 30)
GoTo.Text = "Go To"
GoTo.MouseButton1Click:Connect(function()
    if SelectedPlayer and SelectedPlayer.Character then
        Player.Character:MoveTo(SelectedPlayer.Character.HumanoidRootPart.Position)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.Delete then
        MainFrame.Visible = not MainFrame.Visible
        ParticleEmitter.Enabled = MainFrame.Visible
    end
end)
