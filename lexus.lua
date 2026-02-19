local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
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
ScreenGui.IgnoreGuiInset = true

local Theme = {
	Accent = Color3.fromRGB(160, 132, 255),
	Master = Color3.fromRGB(180, 50, 255),
	Background = Color3.fromRGB(15, 15, 17),
	Sidebar = Color3.fromRGB(22, 22, 25),
	Element = Color3.fromRGB(30, 30, 35),
	Text = Color3.fromRGB(255, 255, 255),
}

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 650, 0, 450)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Draggable Logic
local function MakeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end
MakeDraggable(MainFrame)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "LEXUS"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -70)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -200, 1, -20)
Content.Position = UDim2.new(0, 190, 0, 10)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local function CreateTab(name, iconId)
	local Btn = Instance.new("TextButton", TabContainer)
	Btn.Size = UDim2.new(1, -10, 0, 40)
	Btn.BackgroundTransparency = 1
	Btn.Text = "        " .. name
	Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 13
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", Btn)

	local Icon = Instance.new("ImageLabel", Btn)
	Icon.Size = UDim2.new(0, 18, 0, 18)
	Icon.Position = UDim2.new(0, 12, 0.5, -9)
	Icon.Image = "rbxassetid://" .. iconId
	Icon.BackgroundTransparency = 1
	Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)

	local Page = Instance.new("ScrollingFrame", Content)
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.ScrollBarThickness = 2
	Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

	Btn.MouseButton1Click:Connect(function()
		for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
		for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150,150,150); b.ImageLabel.ImageColor3 = Color3.fromRGB(150,150,150) end end
		Page.Visible = true
		Btn.TextColor3 = Theme.Text
		Icon.ImageColor3 = Theme.Accent
	end)
	return Page
end

local function CreateToggle(parent, text, isMaster, cb)
	local f = Instance.new("TextButton", parent)
	f.Size = UDim2.new(1, -10, 0, 38)
	f.BackgroundColor3 = Theme.Element
	f.Text = (isMaster and "  [M] " or "  ") .. text
	f.TextColor3 = isMaster and Theme.Master or Theme.Text
	f.Font = Enum.Font.Gotham
	f.TextSize = 13
	f.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", f)
	local s = false
	f.MouseButton1Click:Connect(function() s = not s; f.BackgroundColor3 = s and Theme.Accent or Theme.Element; cb(s) end)
end

local function CreateButton(parent, text, isMaster, cb)
	local f = Instance.new("TextButton", parent)
	f.Size = UDim2.new(1, -10, 0, 38)
	f.BackgroundColor3 = isMaster and Theme.Master or Theme.Element
	f.Text = (isMaster and "[M] " or "") .. text
	f.TextColor3 = Theme.Text
	f.Font = Enum.Font.GothamBold
	f.TextSize = 13
	Instance.new("UICorner", f)
	f.MouseButton1Click:Connect(cb)
end

-- TABS
local MovePage = CreateTab("Movement", 11550188736) -- Feather
local PlayerPage = CreateTab("Players", 11293977610)
local VisualPage = CreateTab("Visuals", 11295286510)
local ExploitPage = CreateTab("Exploits", 11293981532)

-- FLY LOGIC
local flyOn, flyMode, flySpeed = false, "Static", 2.5
RunService.Heartbeat:Connect(function()
	if flyOn and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = Player.Character.HumanoidRootPart
		local hum = Player.Character:FindFirstChildOfClass("Humanoid")
		local cam = workspace.CurrentCamera.CFrame
		hrp.Velocity = Vector3.new(0, 0.1, 0)
		hum.PlatformStand = true
		
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
		
		if flyMode == "Dynamic" then
			-- Facing AWAY from camera: cam.LookVector used for orientation
			hrp.CFrame = CFrame.new(hrp.Position + (dir * flySpeed), hrp.Position + (dir * flySpeed) + (cam.LookVector * 5))
		else
			hrp.CFrame = hrp.CFrame + (dir * flySpeed)
		end
	elseif Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
		Player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
	end
end)

-- MOVEMENT OPTIONS
CreateToggle(MovePage, "Static Fly", false, function(v) flyOn = v; flyMode = "Static" end)
CreateToggle(MovePage, "Dynamic Fly (Away Lock)", false, function(v) flyOn = v; flyMode = "Dynamic" end)
CreateToggle(MovePage, "Infinite Jump", false, function(v) _G.InfJump = v end)
UserInputService.JumpRequest:Connect(function() if _G.InfJump then Player.Character.Humanoid:ChangeState("Jumping") end end)
CreateToggle(MovePage, "No-Clip", false, function(v) _G.NoClip = v end)
RunService.Stepped:Connect(function() if _G.NoClip then for _,p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
CreateToggle(MovePage, "Speed Hack (100)", false, function(v) Player.Character.Humanoid.WalkSpeed = v and 100 or 16 end)
CreateToggle(MovePage, "High Jump", false, function(v) Player.Character.Humanoid.JumpPower = v and 150 or 50 end)

-- EXPLOIT OPTIONS (Master Button)
CreateButton(ExploitPage, "Grant Master (One-Time)", true, function()
	settings().Physics.AllowSleep = false
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(Player.Character) then
			pcall(function() v:SetNetworkOwner(Player) end)
		end
	end
end)
CreateToggle(ExploitPage, "Anti-Void", false, function(v) _G.AntiVoid = v end)
RunService.Heartbeat:Connect(function() if _G.AntiVoid and Player.Character.HumanoidRootPart.Position.Y < -50 then Player.Character.HumanoidRootPart.Velocity = Vector3.new(0,100,0) end end)
CreateToggle(ExploitPage, "Auto-Clicker", false, function(v) task.spawn(function() while v do game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)); task.wait(0.1) end end) end)
CreateToggle(ExploitPage, "Kill All", true, function(v) end)

-- PLAYER LIST
local SelectedPlayer = nil
local PList = Instance.new("ScrollingFrame", PlayerPage)
PList.Size = UDim2.new(1, 0, 0.6, 0)
PList.BackgroundTransparency = 1
Instance.new("UIListLayout", PList)

local ActionFrame = Instance.new("Frame", PlayerPage)
ActionFrame.Size = UDim2.new(1, 0, 0.38, 0)
ActionFrame.BackgroundTransparency = 1
Instance.new("UIGridLayout", ActionFrame).CellSize = UDim2.new(0, 110, 0, 32)

local function UpdateList()
	for _,v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= Player then
			local b = Instance.new("TextButton", PList)
			b.Size = UDim2.new(1, -10, 0, 30); b.BackgroundColor3 = Theme.Element; b.Text = " " .. p.Name
			b.TextColor3 = Theme.Text; b.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", b)
			b.MouseButton1Click:Connect(function() SelectedPlayer = p; for _,o in pairs(PList:GetChildren()) do if o:IsA("TextButton") then o.BackgroundColor3 = Theme.Element end end; b.BackgroundColor3 = Theme.Accent end)
		end
	end
end
UpdateList(); Players.PlayerAdded:Connect(UpdateList); Players.PlayerRemoving:Connect(UpdateList)

local function AddAct(n, m, c)
	local b = Instance.new("TextButton", ActionFrame)
	b.Text = (m and "[M] " or "") .. n; b.BackgroundColor3 = m and Theme.Master or Theme.Accent
	b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function() if SelectedPlayer then c() end end)
end

AddAct("GoTo", false, function() Player.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame end)
AddAct("Bring", true, function() SelectedPlayer.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame end)
AddAct("Destroy Rig", true, function() for _,v in pairs(SelectedPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v:Destroy() end end end)
AddAct("Dynamic Kill", true, function() SelectedPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0) end)
AddAct("Fling", true, function() local hrp = Player.Character.HumanoidRootPart; local thrp = SelectedPlayer.Character.HumanoidRootPart; hrp.CFrame = thrp.CFrame; hrp.Velocity = Vector3.new(99999, 99999, 99999) end)

-- VISUALS
CreateToggle(VisualPage, "Box ESP", false, function(v) _G.BoxESP = v end)
CreateToggle(VisualPage, "Tracer ESP", false, function(v) _G.Tracers = v end)
CreateToggle(VisualPage, "Name ESP", false, function(v) _G.Names = v end)

-- TOGGLE MENU
UserInputService.InputBegan:Connect(function(i, g)
	if not g and (i.KeyCode == Enum.KeyCode.Insert or i.KeyCode == Enum.KeyCode.Delete) then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
