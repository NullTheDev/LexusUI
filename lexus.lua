local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("LexusUI") then
	CoreGui:FindFirstChild("LexusUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LexusUI"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local function MakeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			TweenService:Create(frame, TweenInfo.new(0.1), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end
MakeDraggable(MainFrame)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 9)
UICorner.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 9)
SidebarCorner.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Text = "LEXUS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Sidebar

local TabButtons = Instance.new("ScrollingFrame")
TabButtons.Size = UDim2.new(1, 0, 1, -70)
TabButtons.Position = UDim2.new(0, 0, 0, 60)
TabButtons.BackgroundTransparency = 1
TabButtons.ScrollBarThickness = 0
TabButtons.Parent = Sidebar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabButtons
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -175, 1, -20)
Content.Position = UDim2.new(0, 168, 0, 10)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local function CreateTab(name, iconId, isDefault)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 145, 0, 38)
	Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	Btn.BackgroundTransparency = isDefault and 0 or 1
	Btn.Text = name
	Btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextSize = 13
	Btn.AutoButtonColor = false
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.Parent = TabButtons
	
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingLeft = UDim.new(0, 35)
	UIPadding.Parent = Btn

	local Icon = Instance.new("ImageLabel")
	Icon.Size = UDim2.new(0, 18, 0, 18)
	Icon.Position = UDim2.new(0, -25, 0.5, -9)
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxassetid://" .. tostring(iconId)
	Icon.ImageColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
	Icon.Parent = Btn

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = Btn

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = isDefault
	Page.ScrollBarThickness = 0
	Page.Name = name .. "Page"
	Page.Parent = Content
	
	local PagePadding = Instance.new("UIPadding")
	PagePadding.PaddingTop = UDim.new(0, 5)
	PagePadding.PaddingLeft = UDim.new(0, 5)
	PagePadding.Parent = Page
	
	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Parent = Page
	PageLayout.Padding = UDim.new(0, 5)

	Btn.MouseButton1Click:Connect(function()
		for _, child in pairs(Content:GetChildren()) do
			if child:IsA("ScrollingFrame") then child.Visible = false end
		end
		for _, b in pairs(TabButtons:GetChildren()) do
			if b:IsA("TextButton") then
				TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
				TweenService:Create(b.ImageLabel, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
			end
		end
		Page.Visible = true
		TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		TweenService:Create(Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	return Page
end

local function CreateToggle(parent, text, callback)
	local ToggleFrame = Instance.new("TextButton")
	ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.Text = ""
	ToggleFrame.Parent = parent

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -50, 1, 0)
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.BackgroundTransparency = 1
	Label.Parent = ToggleFrame

	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(0, 35, 0, 18)
	Box.Position = UDim2.new(1, -40, 0.5, -9)
	Box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	Box.Parent = ToggleFrame
	Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.new(0, 14, 0, 14)
	Indicator.Position = UDim2.new(0, 2, 0.5, -7)
	Indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	Indicator.Parent = Box
	Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

	local enabled = false
	local function SetState(state)
		enabled = state
		local targetPos = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
		local targetCol = enabled and Color3.fromRGB(160, 132, 255) or Color3.fromRGB(100, 100, 100)
		TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = targetPos, BackgroundColor3 = targetCol}):Play()
		callback(enabled)
	end
	
	ToggleFrame.MouseButton1Click:Connect(function() SetState(not enabled) end)
	return {SetState = SetState}
end

local CombatPage = CreateTab("Combat", 10734881999, false)
local MovePage   = CreateTab("Movement", 10734883578, true)

local flyActive = false
local flyMode = "Static"
local flySpeed = 60

RunService.RenderStepped:Connect(function()
	if not flyActive or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
	local root = Player.Character.HumanoidRootPart
	local camera = workspace.CurrentCamera
	
	root.Velocity = Vector3.zero
	
	local moveDir = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += (flyMode == "Dynamic" and camera.CFrame.LookVector or camera.CFrame.LookVector * Vector3.new(1,0,1)) end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= (flyMode == "Dynamic" and camera.CFrame.LookVector or camera.CFrame.LookVector * Vector3.new(1,0,1)) end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
	
	if moveDir.Magnitude > 0 then
		root.Velocity = moveDir.Unit * flySpeed
	end
end)

local staticToggle, dynamicToggle

staticToggle = CreateToggle(MovePage, "Static Fly", function(v)
	if v then
		flyActive = true
		flyMode = "Static"
		dynamicToggle.SetState(false)
	elseif flyMode == "Static" then
		flyActive = false
	end
end)

dynamicToggle = CreateToggle(MovePage, "Dynamic Fly", function(v)
	if v then
		flyActive = true
		flyMode = "Dynamic"
		staticToggle.SetState(false)
	elseif flyMode == "Dynamic" then
		flyActive = false
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Insert then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
