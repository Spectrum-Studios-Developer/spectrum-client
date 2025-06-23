local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

local rs = game:GetService("RunService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

local function createInstance(t,p,n)
	local i=Instance.new(t)
	i.Name=n
	i.Parent=p
	return i
end

local mainGui = createInstance("ScreenGui", player.PlayerGui, "main")

local mainFrame = createInstance("Frame", mainGui, "MainFrame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0

local corner = createInstance("UICorner", mainFrame, "Corner")
corner.CornerRadius = UDim.new(0, 8)

local titleBar = createInstance("Frame", mainFrame, "TitleBar")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0

local titleCorner = createInstance("UICorner", titleBar, "Corner")
titleCorner.CornerRadius = UDim.new(0, 8)

local titleLabel = createInstance("TextLabel", titleBar, "Title")
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Spectrum Client v1.0.0"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local leftFrame = createInstance("Frame", mainFrame, "LeftFrame")
leftFrame.Size = UDim2.new(0.4, -10, 1, -40)
leftFrame.Position = UDim2.new(0, 5, 0, 35)
leftFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
leftFrame.BorderSizePixel = 0

local leftCorner = createInstance("UICorner", leftFrame, "Corner")
leftCorner.CornerRadius = UDim.new(0, 6)

local modulesList = createInstance("ScrollingFrame", leftFrame, "ModulesList")
modulesList.Size = UDim2.new(1, -20, 1, -20)
modulesList.Position = UDim2.new(0, 10, 0, 10)
modulesList.BackgroundTransparency = 1
modulesList.ScrollBarThickness = 6
modulesList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
modulesList.BorderSizePixel = 0

local listLayout = createInstance("UIListLayout", modulesList, "Layout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)

-- Right side (settings)
local rightFrame = createInstance("Frame", mainFrame, "RightFrame")
rightFrame.Size = UDim2.new(0.6, -10, 1, -40)
rightFrame.Position = UDim2.new(0.4, 5, 0, 35)
rightFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
rightFrame.BorderSizePixel = 0

local rightCorner = createInstance("UICorner", rightFrame, "Corner")
rightCorner.CornerRadius = UDim.new(0, 6)

local settingsTitle = createInstance("TextLabel", rightFrame, "SettingsTitle")
settingsTitle.Size = UDim2.new(1, -20, 0, 30)
settingsTitle.Position = UDim2.new(0, 10, 0, 10)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Select a module"
settingsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
settingsTitle.TextScaled = true
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

local settingsFrame = createInstance("Frame", rightFrame, "SettingsFrame")
settingsFrame.Size = UDim2.new(1, -20, 1, -50)
settingsFrame.Position = UDim2.new(0, 10, 0, 40)
settingsFrame.BackgroundTransparency = 1

local settingsLayout = createInstance("UIListLayout", settingsFrame, "Layout")
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 10)

local modules = {
	{name = "Disabler", enabled = true},
	{name = "Speed", enabled = false, sliderValue = 16, sliderMin = 2, sliderMax = 75},
	{name = "Fly", enabled = false, sliderValue = 16, sliderMin = 10, sliderMax = 75},
	{name = "No Clip", enabled = false, sliderValue = 2, sliderMin = 0, sliderMax = 10},
	{name = "Anti Bot", enabled = false, sliderValue = 26, sliderMin = 1, sliderMax = 50},
	{name = "ESP", enabled = false}
}

local moduleFunctions = {
	[1] = function(moduleData) 
		
	end,
	
	[2] = function(moduleData)
		
		if not moduleData.enabled then
			if humanoid then
					humanoid.WalkSpeed = 16
			end
			return
		else
			humanoid.WalkSpeed = moduleData.sliderValue or 16
		end
		
	end,
	
	[3] = function(moduleData)
		if moduleData.connection then
			moduleData.connection:Disconnect()
			moduleData.connection = nil
		end

		if not moduleData.enabled then
			if humanoidRootPart then
				local existingVelocity = humanoidRootPart:FindFirstChild("FlyVelocity")
				if existingVelocity then
					existingVelocity:Destroy()
				end
			end
			return
		end

		moduleData.connection = rs.RenderStepped:Connect(function()
			character = player.Character
			humanoid = character and character:FindFirstChild("Humanoid")
			humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local camera = workspace.CurrentCamera

			if not (character and humanoid and humanoidRootPart and camera) then
				return
			end

			local moveDirection = Vector3.new()
			if uis:IsKeyDown(Enum.KeyCode.W) then
				moveDirection = moveDirection + Vector3.new(0, 0, 1)
			end
			if uis:IsKeyDown(Enum.KeyCode.S) then
				moveDirection = moveDirection + Vector3.new(0, 0, -1)
			end
			if uis:IsKeyDown(Enum.KeyCode.A) then
				moveDirection = moveDirection + Vector3.new(1, 0, 0) 
			end
			if uis:IsKeyDown(Enum.KeyCode.D) then
				moveDirection = moveDirection + Vector3.new(-1, 0, 0) 
			end

			local lookDirection = camera.CFrame.LookVector
			local flatLookDirection = Vector3.new(lookDirection.X, 0, lookDirection.Z).Unit
			local moveVelocity = flatLookDirection * moveDirection.Z + Vector3.new(flatLookDirection.Z, 0, -flatLookDirection.X) * moveDirection.X

			local speed = moduleData.sliderValue or 50
			moveVelocity = moveVelocity * speed

			if uis:IsKeyDown(Enum.KeyCode.Space) then
				moveVelocity = moveVelocity + Vector3.new(0, speed, 0)
			end
			if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
				moveVelocity = moveVelocity + Vector3.new(0, -speed, 0)
			end

			local bodyVelocity = humanoidRootPart:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
			bodyVelocity.Name = "FlyVelocity"
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = moveVelocity
			bodyVelocity.Parent = humanoidRootPart
		end)
	end,
		
	[4] = function(moduleData)
		local userInputService = game:GetService("UserInputService")

		if moduleData.connection then
			moduleData.connection:Disconnect()
			moduleData.connection = nil
		end
		local character = player.Character
		local humanoid = character and character:FindFirstChild("Humanoid")
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end

		if not moduleData.enabled then
			return
		end

		moduleData.connection = userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if gameProcessedEvent then return end
			
			character = player.Character
			humanoid = character and character:FindFirstChild("Humanoid")
			humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local camera = workspace.CurrentCamera
			if not (character and humanoid and humanoidRootPart and camera) then
				return
			end

			local moveDirection = Vector3.new()
			if input.KeyCode == Enum.KeyCode.W then
				moveDirection = moveDirection + Vector3.new(0, 0, 1)
			elseif input.KeyCode == Enum.KeyCode.S then
				moveDirection = moveDirection + Vector3.new(0, 0, -1)
			elseif input.KeyCode == Enum.KeyCode.A then
				moveDirection = moveDirection + Vector3.new(-1, 0, 0) 
			elseif input.KeyCode == Enum.KeyCode.D then
				moveDirection = moveDirection + Vector3.new(1, 0, 0) 
			end

			if moveDirection.Magnitude == 0 then
				return
			end

			local lookDirection = camera.CFrame.LookVector
			local rightDirection = camera.CFrame.RightVector
			local moveOffset
			if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
				moveOffset = moveDirection
			else
				moveOffset = lookDirection * moveDirection.Z + rightDirection * moveDirection.X
			end

			local distance = moduleData.sliderValue or 50
			moveOffset = moveOffset.Unit * distance
			
			humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveOffset
		end)
	end,
	
	[5] = function(moduleData)

		if moduleData.connection then
			moduleData.connection:Disconnect()
			moduleData.connection = nil
		end

		if not moduleData.enabled then
			return
		end

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not (character and root) then
			return
		end

		moduleData.connection = rs.Heartbeat:Connect(function(deltaTime)
			character = player.Character
			root = character and character:FindFirstChild("HumanoidRootPart")
			if not (character and root) then
				return
			end

			local rotationSpeed = moduleData.sliderValue or 26 
			local rotationAmount = math.rad(rotationSpeed * 1000 * deltaTime) 
			root.CFrame = root.CFrame * CFrame.Angles(0, rotationAmount, 0)
		end)
	end,
	
	[6] = function(moduleData)
		if moduleData.espConnection then
			moduleData.espConnection:Disconnect()
			moduleData.espConnection = nil
		end
		if moduleData.charAddedConnections then
			for _, connection in pairs(moduleData.charAddedConnections) do
				connection:Disconnect()
			end
			moduleData.charAddedConnections = nil
		end
		if moduleData.espGuiMap then
			for _, gui in pairs(moduleData.espGuiMap) do
				if gui and gui.Parent then
					gui:Destroy()
				end
			end
			moduleData.espGuiMap = nil
		end

		if not moduleData.enabled then
			return
		end

		moduleData.charAddedConnections = {}
		moduleData.espGuiMap = {}

		local function attachESPToCharacter(targetPlayer, character)
			if targetPlayer == player then return end 
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local billboard = Instance.new("BillboardGui")
			billboard.Name = "ESP_GUI"
			billboard.Adornee = hrp
			billboard.AlwaysOnTop = true
			billboard.Size = UDim2.new(4, 0, 6, 0)
			billboard.StudsOffset = Vector3.new(0, 0, 0)
			billboard.Parent = hrp

			local box = Instance.new("Frame")
			box.Size = UDim2.new(1, 0, 1, 0)
			box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			box.BackgroundTransparency = 0.6
			box.BorderSizePixel = 1
			box.BorderColor3 = Color3.new(1, 1, 1)
			box.Parent = billboard

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
			nameLabel.Position = UDim2.new(0, 0, -0.2, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = targetPlayer.Name
			nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			nameLabel.TextStrokeTransparency = 0.5
			nameLabel.TextScaled = true
			nameLabel.Font = Enum.Font.SourceSansBold
			nameLabel.Parent = billboard

			moduleData.espGuiMap[targetPlayer] = billboard
		end

		for _, targetPlayer in ipairs(game.Players:GetPlayers()) do
			if targetPlayer.Character then
				attachESPToCharacter(targetPlayer, targetPlayer.Character)
			end
			moduleData.charAddedConnections[targetPlayer] = targetPlayer.CharacterAdded:Connect(function(char)
				task.wait(1) 
				attachESPToCharacter(targetPlayer, char)
			end)
		end

		moduleData.espConnection = game.Players.PlayerAdded:Connect(function(targetPlayer)
			if targetPlayer.Character then
				attachESPToCharacter(targetPlayer, targetPlayer.Character)
			end
			moduleData.charAddedConnections[targetPlayer] = targetPlayer.CharacterAdded:Connect(function(char)
				task.wait(1)
				attachESPToCharacter(targetPlayer, char)
			end)
		end)
	end,
}

local selectedModule = nil
local moduleButtons = {}

local function createModuleButton(moduleData, index)
	local button = createInstance("TextButton", modulesList, "Module" .. index)
	button.Size = UDim2.new(1, -10, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	button.BorderSizePixel = 0
	button.Text = moduleData.name
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.TextScaled = true
	button.Font = Enum.Font.Gotham

	local buttonCorner = createInstance("UICorner", button, "Corner")
	buttonCorner.CornerRadius = UDim.new(0, 4)

	moduleButtons[index] = button

	button.MouseButton1Click:Connect(function()
		if selectedModule == index then return end

		if selectedModule then
			TweenService:Create(moduleButtons[selectedModule], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()
		end

		selectedModule = index
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 85, 85)}):Play()

		showSettings(moduleData, index)
	end)

	button.MouseEnter:Connect(function()
		if selectedModule ~= index then
			TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(75, 75, 75)}):Play()
		end
	end)

	button.MouseLeave:Connect(function()
		if selectedModule ~= index then
			TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()
		end
	end)
end

function showSettings(moduleData, index)
	settingsTitle.Text = moduleData.name

	for _, child in pairs(settingsFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local enabledFrame = createInstance("Frame", settingsFrame, "EnabledFrame")
	enabledFrame.Size = UDim2.new(1, 0, 0, 30)
	enabledFrame.BackgroundTransparency = 1

	local enabledLabel = createInstance("TextLabel", enabledFrame, "Label")
	enabledLabel.Size = UDim2.new(0.5, 0, 1, 0)
	enabledLabel.BackgroundTransparency = 1
	enabledLabel.Text = "Enabled:"
	enabledLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	enabledLabel.TextScaled = true
	enabledLabel.Font = Enum.Font.Gotham
	enabledLabel.TextXAlignment = Enum.TextXAlignment.Left

	local toggleButton = createInstance("TextButton", enabledFrame, "Toggle")
	toggleButton.Size = UDim2.new(0, 60, 0, 25)
	toggleButton.Position = UDim2.new(0.5, 0, 0, 2.5)
	toggleButton.BackgroundColor3 = moduleData.enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
	toggleButton.BorderSizePixel = 0
	toggleButton.Text = moduleData.enabled and "ON" or "OFF"
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.TextScaled = true
	toggleButton.Font = Enum.Font.GothamBold

	local toggleCorner = createInstance("UICorner", toggleButton, "Corner")
	toggleCorner.CornerRadius = UDim.new(0, 4)

	toggleButton.MouseButton1Click:Connect(function()
		moduleData.enabled = not moduleData.enabled
		modules[index] = moduleData

		local newColor = moduleData.enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
		local newText = moduleData.enabled and "ON" or "OFF"

		TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
		toggleButton.Text = newText

		if moduleFunctions[index] then
			moduleFunctions[index](moduleData)
		end
	end)
	
	if moduleData.textValue then
		local textFrame = createInstance("Frame", settingsFrame, "TextFrame")
		textFrame.Size = UDim2.new(1, 0, 0, 40)
		textFrame.BackgroundTransparency = 1

		local textLabel = createInstance("TextLabel", textFrame, "Label")
		textLabel.Size = UDim2.new(1, 0, 0, 15)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Text Input:"
		textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		textLabel.TextScaled = true
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextXAlignment = Enum.TextXAlignment.Left

		local textBox = createInstance("TextBox", textFrame, "TextBox")
		textBox.Size = UDim2.new(1, 0, 0, 20)
		textBox.Position = UDim2.new(0, 0, 0, 15)
		textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		textBox.BorderSizePixel = 0
		textBox.Text = moduleData.textValue
		textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		textBox.TextScaled = true
		textBox.Font = Enum.Font.Gotham
		textBox.PlaceholderText = "Enter text..."
		textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)

		local textCorner = createInstance("UICorner", textBox, "Corner")
		textCorner.CornerRadius = UDim.new(0, 3)

		textBox.FocusLost:Connect(function()
			moduleData.textValue = textBox.Text
			modules[index] = moduleData

			if moduleFunctions[index] then
				moduleFunctions[index](moduleData)
			end
		end)
	end

	if moduleData.sliderValue and moduleData.sliderMin and moduleData.sliderMax then
		local sliderFrame = createInstance("Frame", settingsFrame, "SliderFrame")
		sliderFrame.Size = UDim2.new(1, 0, 0, 50)
		sliderFrame.BackgroundTransparency = 1

		local sliderLabel = createInstance("TextLabel", sliderFrame, "Label")
		sliderLabel.Size = UDim2.new(1, 0, 0, 15)
		sliderLabel.BackgroundTransparency = 1
		sliderLabel.Text = "Slider: " .. moduleData.sliderValue .. " (" .. moduleData.sliderMin .. "-" .. moduleData.sliderMax .. ")"
		sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		sliderLabel.TextScaled = true
		sliderLabel.Font = Enum.Font.Gotham
		sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

		local sliderBg = createInstance("Frame", sliderFrame, "SliderBg")
		sliderBg.Size = UDim2.new(1, 0, 0, 20)
		sliderBg.Position = UDim2.new(0, 0, 0, 20)
		sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		sliderBg.BorderSizePixel = 0

		local sliderBgCorner = createInstance("UICorner", sliderBg, "Corner")
		sliderBgCorner.CornerRadius = UDim.new(0, 10)

		local sliderFill = createInstance("Frame", sliderBg, "SliderFill")
		local fillPercent = (moduleData.sliderValue - moduleData.sliderMin) / (moduleData.sliderMax - moduleData.sliderMin)
		sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
		sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		sliderFill.BorderSizePixel = 0

		local sliderFillCorner = createInstance("UICorner", sliderFill, "Corner")
		sliderFillCorner.CornerRadius = UDim.new(0, 10)

		local sliderButton = createInstance("TextButton", sliderBg, "SliderButton")
		sliderButton.Size = UDim2.new(0, 20, 1, 0)
		sliderButton.Position = UDim2.new(fillPercent, -10, 0, 0)
		sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sliderButton.BorderSizePixel = 0
		sliderButton.Text = ""

		local sliderButtonCorner = createInstance("UICorner", sliderButton, "Corner")
		sliderButtonCorner.CornerRadius = UDim.new(1, 0)

		local draggingSlider = false

		sliderButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				draggingSlider = true
			end
		end)

		uis.InputChanged:Connect(function(input)
			if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mousePos = input.Position
				local sliderPos = sliderBg.AbsolutePosition
				local relativeX = mousePos.X - sliderPos.X
				local percent = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)

				local newValue = math.floor(moduleData.sliderMin + (moduleData.sliderMax - moduleData.sliderMin) * percent)
				moduleData.sliderValue = newValue
				modules[index] = moduleData

				sliderFill.Size = UDim2.new(percent, 0, 1, 0)
				sliderButton.Position = UDim2.new(percent, -10, 0, 0)
				sliderLabel.Text = "Slider: " .. newValue .. " (" .. moduleData.sliderMin .. "-" .. moduleData.sliderMax .. ")"
			end
		end)

		uis.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingSlider then
				draggingSlider = false

				if moduleFunctions[index] then
					moduleFunctions[index](moduleData)
				end
			end
		end)

		sliderBg.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local mousePos = input.Position
				local sliderPos = sliderBg.AbsolutePosition
				local relativeX = mousePos.X - sliderPos.X
				local percent = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)

				local newValue = math.floor(moduleData.sliderMin + (moduleData.sliderMax - moduleData.sliderMin) * percent)
				moduleData.sliderValue = newValue
				modules[index] = moduleData

				TweenService:Create(sliderFill, TweenInfo.new(0.2), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
				TweenService:Create(sliderButton, TweenInfo.new(0.2), {Position = UDim2.new(percent, -10, 0, 0)}):Play()
				sliderLabel.Text = "Slider: " .. newValue .. " (" .. moduleData.sliderMin .. "-" .. moduleData.sliderMax .. ")"

				if moduleFunctions[index] then
					moduleFunctions[index](moduleData)
				end
			end
		end)
	end

	settingsFrame.Position = UDim2.new(0, 30, 0, 40)
	TweenService:Create(settingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 10, 0, 40)}):Play()
end

for i, moduleData in ipairs(modules) do
	createModuleButton(moduleData, i)
end

modulesList.CanvasSize = UDim2.new(0, 0, 0, #modules * 43)

local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

uis.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Initial animation
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -300, 0.5, -200)}):Play()
