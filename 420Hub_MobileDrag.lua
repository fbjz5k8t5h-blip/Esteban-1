-- 420 HUB | Drag FIXED | by 420 HUB

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "420Hub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 110)
frame.Position = UDim2.new(0.5, -130, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true -- 🔥 REQUIRED FOR DRAG
frame.Parent = gui

-- Rounded
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 16)

-- Stroke
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 255, 180)
stroke.Thickness = 2

-- Gradient
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,170)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}
gradient.Rotation = 45

-- Title (drag handle)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "420 HUB"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,0,0)
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -40, 0, 45)
btn.Position = UDim2.new(0, 20, 0, 45)
btn.Text = "OFF"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
btn.TextColor3 = Color3.fromRGB(0,255,180)
btn.Font = Enum.Font.GothamBold
btn.Parent = frame

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 12)

local btnStroke = Instance.new("UIStroke", btn)
btnStroke.Color = Color3.fromRGB(0,255,180)
btnStroke.Thickness = 1.5

-- 🔥 DRAG LOGIC (PC + MOBILE)
local dragging = false
local dragStart
local startPos

local function beginDrag(input)
	dragging = true
	dragStart = input.Position
	startPos = frame.Position
end

local function endDrag()
	dragging = false
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		beginDrag(input)
	end
end)

title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		endDrag()
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Toggle Logic
local isOn = false
local running = false

btn.MouseButton1Click:Connect(function()
	isOn = not isOn

	if isOn then
		btn.Text = "ON"
		btn.TextColor3 = Color3.fromRGB(0,255,120)
		running = true

		task.spawn(function()
			local payload = table.create(499999,{})
			while running do
				game:GetService("ReplicatedStorage")
					.Packages.Net["RE/UseItem"]:FireServer(payload)
				task.wait(0.1)
			end
		end)
	else
		btn.Text = "OFF"
		btn.TextColor3 = Color3.fromRGB(0,255,180)
		running = false
	end
end)
