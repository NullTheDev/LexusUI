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
	Background = Color3.fromRGB(15, 15, 17),
	Sidebar = Color3.fromRGB(22, 22, 25),
	Element = Color3.fromRGB(30, 30, 35),
	Text = Color3.fromRGB(255, 255, 255),
}

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

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
Sidebar.Size = UDim2.new(0, 170, 1, 0)
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
Content.Size = UDim2.new(1, -190, 1, -20)
Content.Position = UDim2.new(0, 180, 0, 10)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local function CreateTab(name, iconId)
	local Btn = Instance.new("TextButton", TabContainer)
	Btn.Size = UDim2.new(1, -10, 0, 40)
	Btn.BackgroundTransparency = 1
	Btn.Text = "      " .. name
	Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 14
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", Btn)

	local Page = Instance.new("ScrollingFrame", Content)
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.ScrollBarThickness = 0
	Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

	Btn.MouseButton1Click:Connect(function()
		for _, v in pairs(Content:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
		Page.Visible = true
		Page.Position = UDim2.new(0, 15, 0, 0)
		TweenService:Create(Page, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
	end)
	return Page
end

local function CreateToggle(parent, text, cb)
	local f = Instance.new("TextButton", parent)
	f.Size = UDim2.new(1, -10, 0, 40)
	f.BackgroundColor3 = Theme.Element
	f.Text = "  " .. text
	f.TextColor3 = Theme.Text
	f.Font = Enum.Font.Gotham
	f.TextSize = 13
	f.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", f)
	
	local box = Instance.new("Frame", f)
	box.Size = UDim2.new(0, 30, 0, 15)
	box.Position = UDim2.new(1, -40, 0.5, -7)
	box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Instance.new("UICorner", box).CornerRadius = UDim.new(1, 0)
	
	local dot = Instance.new("Frame", box)
	dot.Size = UDim2.new(0, 11, 0, 11)
	dot.Position = UDim2.new(0, 2, 0.5, -5)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local s = false
	f.MouseButton1Click:Connect(function()
		s = not s
		TweenService:Create(dot, TweenInfo.new(0.2), {Position = s and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = s and Theme.Accent or Color3.new(1,1,1)}):Play()
		cb(s)
	end)
end

local MovePage = CreateTab("Movement", 10734883578)
local VisualPage = CreateTab("Visuals", 10734883344)
local PlayerPage = CreateTab("Players", 10734950309)
local ExploitPage = CreateTab("Exploits", 10734881999)
local ThemePage = CreateTab("Theme", 10734950056)

local flyOn = false
local flySpeed = 5
RunService.Heartbeat:Connect(function()
	if flyOn and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = Player.Character.HumanoidRootPart
		local cam = workspace.CurrentCamera.CFrame
		hrp.Velocity = Vector3.new(0,0.1,0)
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
		hrp.CFrame = hrp.CFrame + (dir * (flySpeed/5))
	end
end)

CreateToggle(MovePage, "Fly Enabled", function(v) flyOn = v end)

local masterOn = false
RunService.Stepped:Connect(function()
	if masterOn then
		settings().Physics.AllowSleep = false
		for _, v in pairs(game:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Velocity = Vector3.new(0, 0, 0.01) -- Keep parts awake
				pcall(function() v:SetNetworkOwner(Player) end)
			end
		end
	end
end)
CreateToggle(ExploitPage, "Loop Grant Master", function(v) masterOn = v end)

local cp = Instance.new("TextBox", ThemePage)
cp.Size = UDim2.new(1, -10, 0, 35)
cp.BackgroundColor3 = Theme.Element
cp.Text = "Enter Accent Hex (e.g. #FF0000)"
cp.TextColor3 = Theme.Text
Instance.new("UICorner", cp)
cp.FocusLost:Connect(function()
	local success, color = pcall(function() return Color3.fromHex(cp.Text) end)
	if success then Theme.Accent = color end
end)

local PList = Instance.new("ScrollingFrame", PlayerPage)
PList.Size = UDim2.new(1, 0, 0.7, 0)
PList.BackgroundTransparency = 1
Instance.new("UIListLayout", PList)

local function UpdatePlayers()
	for _,v in pairs(PList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _,p in pairs(Players:GetPlayers()) do
		local b = Instance.new("TextButton", PList)
		b.Size = UDim2.new(1, -10, 0, 30)
		b.BackgroundColor3 = Theme.Element
		b.Text = p.Name
		b.TextColor3 = Theme.Text
		Instance.new("UICorner", b)
		b.MouseButton1Click:Connect(function()
			pcall(function() Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end)
		end)
	end
end
UpdatePlayers()

UserInputService.InputBegan:Connect(function(i, g)
	if not g and (i.KeyCode == Enum.KeyCode.Insert or i.KeyCode == Enum.KeyCode.Delete) then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
