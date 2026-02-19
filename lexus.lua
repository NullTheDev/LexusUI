local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- // Cleanup Duplicate
if CoreGui:FindFirstChild("LexusUI") then CoreGui:FindFirstChild("LexusUI"):Destroy() end

-- // Notification Logic
local function Notify(title, text, color)
    local nFrame = Instance.new("Frame")
    nFrame.Size = UDim2.new(0, 250, 0, 60)
    nFrame.Position = UDim2.new(1, 5, 0.8, 0)
    nFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    nFrame.BorderSizePixel = 0
    nFrame.Parent = (gethui and gethui()) or CoreGui
    
    local line = Instance.new("Frame", nFrame)
    line.Size = UDim2.new(0, 4, 1, 0)
    line.BackgroundColor3 = color or Color3.fromRGB(160, 132, 255)
    line.BorderSizePixel = 0
    
    local t = Instance.new("TextLabel", nFrame)
    t.Size = UDim2.new(1, -10, 0, 30); t.Position = UDim2.new(0, 10, 0, 5)
    t.Text = title; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.GothamBold; t.TextSize = 14; t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left
    
    local d = Instance.new("TextLabel", nFrame)
    d.Size = UDim2.new(1, -10, 0, 20); d.Position = UDim2.new(0, 10, 0, 25)
    d.Text = text; d.TextColor3 = Color3.fromRGB(200, 200, 200); d.Font = Enum.Font.Gotham; d.TextSize = 12; d.BackgroundTransparency = 1; d.TextXAlignment = Enum.TextXAlignment.Left

    Instance.new("UICorner", nFrame)
    nFrame:TweenPosition(UDim2.new(1, -260, 0.8, 0), "Out", "Back", 0.5)
    task.delay(4, function()
        nFrame:TweenPosition(UDim2.new(1, 5, 0.8, 0), "In", "Back", 0.5)
        task.wait(0.5); nFrame:Destroy()
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LexusUI"
ScreenGui.Parent = (gethui and gethui()) or CoreGui

local Theme = {
    Accent = Color3.fromRGB(160, 132, 255),
    Master = Color3.fromRGB(180, 50, 255),
    BG = Color3.fromRGB(10, 10, 12),
    Sidebar = Color3.fromRGB(15, 15, 18),
    Element = Color3.fromRGB(25, 25, 30)
}

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 700, 0, 500)
Main.Position = UDim2.new(0.5, -350, 0.5, -250)
Main.BackgroundColor3 = Theme.BG
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- // Smooth Dragging
local dragStart, startPos, dragging
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 200, 1, 0)
Side.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", Side).CornerRadius = UDim.new(0, 12)

local TabHolder = Instance.new("ScrollingFrame", Side)
TabHolder.Size = UDim2.new(1, 0, 1, -100); TabHolder.Position = UDim2.new(0, 0, 0, 80); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -220, 1, -20); PageHolder.Position = UDim2.new(0, 210, 0, 10); PageHolder.BackgroundTransparency = 1

local function CreateTab(name)
    local b = Instance.new("TextButton", TabHolder)
    b.Size = UDim2.new(1, -20, 0, 40); b.BackgroundTransparency = 1; b.Text = name; b.TextColor3 = Color3.fromRGB(150, 150, 150); b.Font = Enum.Font.GothamBold; b.TextSize = 14
    
    local p = Instance.new("ScrollingFrame", PageHolder)
    p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
        for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
        p.Visible = true; b.TextColor3 = Theme.Accent
        p.Position = UDim2.new(0, 30, 0, 0)
        TweenService:Create(p, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
    end)
    return p
end

-- // Tabs
local MoveTab = CreateTab("MOVEMENT")
local ExploitTab = CreateTab("EXPLOITS")
local PlayerTab = CreateTab("PLAYERS")

-- // Custom Elements
local function AddToggle(parent, text, isMaster, cb)
    local f = Instance.new("TextButton", parent)
    f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundColor3 = Theme.Element; f.Text = (isMaster and "[M] " or "") .. text; f.TextColor3 = isMaster and Theme.Master or Color3.new(1,1,1); f.Font = Enum.Font.GothamSemibold; f.TextSize = 13; Instance.new("UICorner", f)
    local s = false
    f.MouseButton1Click:Connect(function() s = not s; TweenService:Create(f, TweenInfo.new(0.3), {BackgroundColor3 = s and Theme.Accent or Theme.Element}):Play(); cb(s) end)
end

-- // Movement Core
local fOn, fMode, fSpd = false, "Static", 2.5
RunService.Heartbeat:Connect(function()
    if fOn and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera.CFrame
        hrp.Velocity = Vector3.new(0, 0, 0)
        local d = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then d += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then d -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then d -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then d += cam.RightVector end
        if fMode == "Dynamic" then
            hrp.CFrame = CFrame.new(hrp.Position + (d * fSpd), hrp.Position + (d * fSpd) + (cam.LookVector * 10))
        else
            hrp.CFrame = hrp.CFrame + (d * fSpd)
        end
    end
end)

AddToggle(MoveTab, "Static Fly", false, function(v) fOn = v; fMode = "Static" end)
AddToggle(MoveTab, "Dynamic Fly (Sync)", false, function(v) fOn = v; fMode = "Dynamic" end)
AddToggle(MoveTab, "Noclip (Server Bypass)", false, function(v) _G.NC = v end)
RunService.Stepped:Connect(function() if _G.NC then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- // Exploit Tab
local masterBtn = Instance.new("TextButton", ExploitTab)
masterBtn.Size = UDim2.new(1, -10, 0, 50); masterBtn.BackgroundColor3 = Theme.Master; masterBtn.Text = "FORCE NETWORK MASTER"; masterBtn.TextColor3 = Color3.new(1,1,1); masterBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", masterBtn)
masterBtn.MouseButton1Click:Connect(function()
    settings().Physics.AllowSleep = false
    for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then pcall(function() v:SetNetworkOwner(Player) end) end end
    Notify("MASTER CLAIMED", "Replication Authority Active", Theme.Master)
end)

AddToggle(ExploitTab, "Anti-Ragdoll", false, function(v) Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not v) end)
AddToggle(ExploitTab, "Invisible (Local)", false, function(v) for _,p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 0.5 or 0 end end end)

-- // Player Tab Overhaul
local Selected = nil
local List = Instance.new("ScrollingFrame", PlayerTab)
List.Size = UDim2.new(1, 0, 0.5, 0); List.BackgroundTransparency = 1; Instance.new("UIListLayout", List).Padding = UDim.new(0, 5)

local function Update()
    for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _,p in pairs(Players:GetPlayers()) do if p ~= Player then
        local b = Instance.new("TextButton", List)
        b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Theme.Element; b.Text = p.Name; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() Selected = p; Notify("TARGET", p.Name .. " selected.") end)
    end end
end
Update(); Players.PlayerAdded:Connect(function(p) Notify("JOINED", p.Name .. " entered."); Update() end)
Players.PlayerRemoving:Connect(function(p) Notify("LEFT", p.Name .. " left."); Update() end)

local Actions = Instance.new("Frame", PlayerTab)
Actions.Size = UDim2.new(1, 0, 0.45, 0); Actions.BackgroundTransparency = 1
Instance.new("UIGridLayout", Actions).CellSize = UDim2.new(0, 150, 0, 40)

local function AddAct(n, m, c)
    local b = Instance.new("TextButton", Actions)
    b.Text = (m and "[M] " or "") .. n; b.BackgroundColor3 = m and Theme.Master or Theme.Accent; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() if Selected then c() end end)
end

AddAct("Bring", true, function() Selected.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame end)
AddAct("Fling", true, function() 
    local hrp = Player.Character.HumanoidRootPart
    local old = hrp.CFrame
    hrp.CFrame = Selected.Character.HumanoidRootPart.CFrame
    hrp.Velocity = Vector3.new(999999, 999999, 999999)
    task.wait(0.2); hrp.CFrame = old
end)
AddAct("Kill", true, function() while Selected do Selected.Character.HumanoidRootPart.CFrame = CFrame.new(0, -500, 0); task.wait() end end)
AddAct("Teleport To", false, function() Player.Character.HumanoidRootPart.CFrame = Selected.Character.HumanoidRootPart.CFrame end)

-- // Toggle UI
UserInputService.InputBegan:Connect(function(i, g)
    if not g and (i.KeyCode == Enum.KeyCode.Insert or i.KeyCode == Enum.KeyCode.Delete) then
        Main.Visible = not Main.Visible
    end
end)

Notify("LEXUS LOADED", "Insert/Delete to toggle.", Theme.Accent)
