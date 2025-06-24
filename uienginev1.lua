local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function createInstance(class, parent, name)
	local instance = Instance.new(class)
	instance.Name = name
	instance.Parent = parent
	return instance
end

function UILibrary:CreateUI(player, modules, moduleFunctions)
	local gui = {}
	local selectedModule = nil
	local moduleButtons = {}
	local isMinimized = false
	local dragging = false
	local dragStart = nil
	local startPos = nil

	-- Create main GUI
	local mainGui = createInstance("ScreenGui", player.PlayerGui, "SpectrumClient")
	gui.mainGui = mainGui

	local mainShadow = createInstance("Frame", mainGui, "Shadow")
	mainShadow.Size = UDim2.new(0, 660, 0, 460)
	mainShadow.Position = UDim2.new(0.5, -330, 0.5, -230)
	mainShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	mainShadow.BackgroundTransparency = 0.3
	mainShadow.ZIndex = -1
	createInstance("UICorner", mainShadow, "Corner").CornerRadius = UDim.new(0, 12)

	local mainFrame = createInstance("Frame", mainGui, "MainFrame")
	mainFrame.Size = UDim2.new(0, 650, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	mainFrame.BorderSizePixel = 0
	createInstance("UICorner", mainFrame, "Corner").CornerRadius = UDim.new(0, 10)

	-- Title bar
	local titleBar = createInstance("Frame", mainFrame, "TitleBar")
	titleBar.Size = UDim2.new(1, 0, 0, 35)
	titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	titleBar.BorderSizePixel = 0
	local titleCorner = createInstance("UICorner", titleBar, "Corner")
	titleCorner.CornerRadius = UDim.new(0, 10)

	local titleFix = createInstance("Frame", titleBar, "Fix")
	titleFix.Size = UDim2.new(1, 0, 0, 17)
	titleFix.Position = UDim2.new(0, 0, 1, -17)
	titleFix.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	titleFix.BorderSizePixel = 0

	local titleLabel = createInstance("TextLabel", titleBar, "Title")
	titleLabel.Size = UDim2.new(1, -120, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Spectrum Client v1.2.0"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Buttons
	local minimizeButton = createInstance("TextButton", titleBar, "Minimize")
	minimizeButton.Size = UDim2.new(0, 30, 0, 25)
	minimizeButton.Position = UDim2.new(1, -70, 0, 5)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Text = "−"
	minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	minimizeButton.TextScaled = true
	minimizeButton.Font = Enum.Font.GothamBold
	createInstance("UICorner", minimizeButton, "Corner").CornerRadius = UDim.new(0, 5)

	local closeButton = createInstance("TextButton", titleBar, "Close")
	closeButton.Size = UDim2.new(0, 30, 0, 25)
	closeButton.Position = UDim2.new(1, -35, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "×"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextScaled = true
	closeButton.Font = Enum.Font.GothamBold
	createInstance("UICorner", closeButton, "Corner").CornerRadius = UDim.new(0, 5)

	-- Left frame
	local leftFrame = createInstance("Frame", mainFrame, "LeftFrame")
	leftFrame.Size = UDim2.new(0.4, -10, 1, -45)
	leftFrame.Position = UDim2.new(0, 8, 0, 40)
	leftFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	leftFrame.BorderSizePixel = 0
	createInstance("UICorner", leftFrame, "Corner").CornerRadius = UDim.new(0, 8)
	local leftGradient = createInstance("UIGradient", leftFrame, "Gradient")
	leftGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
	}
	leftGradient.Rotation = 45

	local modulesList = createInstance("ScrollingFrame", leftFrame, "ModulesList")
	modulesList.Size = UDim2.new(1, -16, 1, -16)
	modulesList.Position = UDim2.new(0, 8, 0, 8)
	modulesList.BackgroundTransparency = 1
	modulesList.ScrollBarThickness = 4
	modulesList.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
	modulesList.BorderSizePixel = 0
	local listLayout = createInstance("UIListLayout", modulesList, "Layout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)

	-- Right frame
	local rightFrame = createInstance("Frame", mainFrame, "RightFrame")
	rightFrame.Size = UDim2.new(0.6, -10, 1, -45)
	rightFrame.Position = UDim2.new(0.4, 2, 0, 40)
	rightFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	rightFrame.BorderSizePixel = 0
	createInstance("UICorner", rightFrame, "Corner").CornerRadius = UDim.new(0, 8)
	local rightGradient = createInstance("UIGradient", rightFrame, "Gradient")
	rightGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 35))
	}
	rightGradient.Rotation = 135

	local settingsTitle = createInstance("TextLabel", rightFrame, "SettingsTitle")
	settingsTitle.Size = UDim2.new(1, -16, 0, 30)
	settingsTitle.Position = UDim2.new(0, 8, 0, 8)
	settingsTitle.BackgroundTransparency = 1
	settingsTitle.Text = "Select a module"
	settingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	settingsTitle.TextScaled = true
	settingsTitle.Font = Enum.Font.GothamBold
	settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

	local modeFrame = createInstance("Frame", rightFrame, "ModeFrame")
	modeFrame.Size = UDim2.new(1, -16, 0, 35)
	modeFrame.Position = UDim2.new(0, 8, 0, 45)
	modeFrame.BackgroundTransparency = 1
	modeFrame.Visible = false

	local modeLabel = createInstance("TextLabel", modeFrame, "Label")
	modeLabel.Size = UDim2.new(0.3, 0, 1, 0)
	modeLabel.BackgroundTransparency = 1
	modeLabel.Text = "Mode:"
	modeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	modeLabel.TextScaled = true
	modeLabel.Font = Enum.Font.Gotham
	modeLabel.TextXAlignment = Enum.TextXAlignment.Left

	local modeDropdown = createInstance("TextButton", modeFrame, "Dropdown")
	modeDropdown.Size = UDim2.new(0.7, -5, 0, 30)
	modeDropdown.Position = UDim2.new(0.3, 5, 0, 2.5)
	modeDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	modeDropdown.BorderSizePixel = 0
	modeDropdown.Text = "Default ▼"
	modeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
	modeDropdown.TextScaled = true
	modeDropdown.Font = Enum.Font.Gotham
	createInstance("UICorner", modeDropdown, "Corner").CornerRadius = UDim.new(0, 6)
	createInstance("UIStroke", modeDropdown, "Stroke").Color = Color3.fromRGB(80, 80, 90)

	local settingsFrame = createInstance("ScrollingFrame", rightFrame, "SettingsFrame")
	settingsFrame.Size = UDim2.new(1, -16, 1, -90)
	settingsFrame.Position = UDim2.new(0, 8, 0, 85)
	settingsFrame.BackgroundTransparency = 1
	settingsFrame.ScrollBarThickness = 4
	settingsFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
	settingsFrame.BorderSizePixel = 0
	local settingsLayout = createInstance("UIListLayout", settingsFrame, "Layout")
	settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	settingsLayout.Padding = UDim.new(0, 12)

	local function createModuleButton(moduleData, index)
		local button = createInstance("TextButton", modulesList, "Module" .. index)
		button.Size = UDim2.new(1, -8, 0, 38)
		button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		button.BorderSizePixel = 0
		button.Text = ""
		createInstance("UICorner", button, "Corner").CornerRadius = UDim.new(0, 6)
		local buttonStroke = createInstance("UIStroke", button, "Stroke")
		buttonStroke.Color = Color3.fromRGB(60, 60, 70)
		buttonStroke.Thickness = 1

		local moduleLabel = createInstance("TextLabel", button, "Label")
		moduleLabel.Size = UDim2.new(1, -35, 1, 0)
		moduleLabel.Position = UDim2.new(0, 12, 0, 0)
		moduleLabel.BackgroundTransparency = 1
		moduleLabel.Text = moduleData.name
		moduleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		moduleLabel.TextScaled = true
		moduleLabel.Font = Enum.Font.GothamMedium
		moduleLabel.TextXAlignment = Enum.TextXAlignment.Left

		local statusIcon = createInstance("TextLabel", button, "Status")
		statusIcon.Size = UDim2.new(0, 20, 0, 20)
		statusIcon.Position = UDim2.new(1, -30, 0.5, -10)
		statusIcon.BackgroundColor3 = moduleData.enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
		statusIcon.BorderSizePixel = 0
		statusIcon.Text = ""
		createInstance("UICorner", statusIcon, "Corner").CornerRadius = UDim.new(1, 0)

		moduleButtons[index] = {button = button, icon = statusIcon}

		button.MouseButton1Click:Connect(function()
			if selectedModule == index then return end
			if selectedModule then
				TweenService:Create(moduleButtons[selectedModule].button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
			end
			selectedModule = index
			TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 75)}):Play()
			gui.showSettings(moduleData, index)
		end)

		button.MouseEnter:Connect(function()
			if selectedModule ~= index then
				TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
			end
		end)

		button.MouseLeave:Connect(function()
			if selectedModule ~= index then
				TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
			end
		end)
	end

	local function updateModeDropdown(moduleData)
		local modes = {}
		for mode, _ in pairs(moduleData.modes) do
			table.insert(modes, mode)
		end

		local dropdownList = modeDropdown:FindFirstChild("DropdownList")
		if dropdownList then dropdownList:Destroy() end

		dropdownList = createInstance("Frame", modeDropdown, "DropdownList")
		dropdownList.Size = UDim2.new(1, 0, 0, #modes * 30)
		dropdownList.Position = UDim2.new(0, 0, 1, 2)
		dropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		dropdownList.BorderSizePixel = 0
		dropdownList.Visible = false
		dropdownList.ZIndex = 10
		createInstance("UICorner", dropdownList, "Corner").CornerRadius = UDim.new(0, 6)
		createInstance("UIStroke", dropdownList, "Stroke").Color = Color3.fromRGB(80, 80, 90)

		local dropdownLayout = createInstance("UIListLayout", dropdownList, "Layout")
		dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder

		for _, mode in ipairs(modes) do
			local modeButton = createInstance("TextButton", dropdownList, mode)
			modeButton.Size = UDim2.new(1, 0, 0, 30)
			modeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			modeButton.BorderSizePixel = 0
			modeButton.Text = mode
			modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			modeButton.TextScaled = true
			modeButton.Font = Enum.Font.Gotham

			modeButton.MouseButton1Click:Connect(function()
				moduleData.currentMode = mode
				modeDropdown.Text = mode .. " ▼"
				dropdownList.Visible = false
				gui.showSettings(moduleData, selectedModule)
			end)

			modeButton.MouseEnter:Connect(function()
				TweenService:Create(modeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
			end)

			modeButton.MouseLeave:Connect(function()
				TweenService:Create(modeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
			end)
		end

		modeDropdown.MouseButton1Click:Connect(function()
			dropdownList.Visible = not dropdownList.Visible
		end)
	end

	function gui.showSettings(moduleData, index)
		settingsTitle.Text = moduleData.name
		modeFrame.Visible = true
		modeDropdown.Text = moduleData.currentMode .. " ▼"
		updateModeDropdown(moduleData)

		for _, child in pairs(settingsFrame:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end

		local currentSettings = moduleData.modes[moduleData.currentMode]

		local enabledFrame = createInstance("Frame", settingsFrame, "EnabledFrame")
		enabledFrame.Size = UDim2.new(1, 0, 0, 35)
		enabledFrame.BackgroundTransparency = 1

		local enabledLabel = createInstance("TextLabel", enabledFrame, "Label")
		enabledLabel.Size = UDim2.new(0.5, 0, 1, 0)
		enabledLabel.BackgroundTransparency = 1
		enabledLabel.Text = "Enabled:"
		enabledLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		enabledLabel.TextScaled = true
		enabledLabel.Font = Enum.Font.GothamMedium
		enabledLabel.TextXAlignment = Enum.TextXAlignment.Left

		local toggleButton = createInstance("TextButton", enabledFrame, "Toggle")
		toggleButton.Size = UDim2.new(0, 70, 0, 30)
		toggleButton.Position = UDim2.new(0.5, 0, 0, 2.5)
		toggleButton.BackgroundColor3 = moduleData.enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
		toggleButton.BorderSizePixel = 0
		toggleButton.Text = moduleData.enabled and "ON" or "OFF"
		toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		toggleButton.TextScaled = true
		toggleButton.Font = Enum.Font.GothamBold
		createInstance("UICorner", toggleButton, "Corner").CornerRadius = UDim.new(0, 6)
		createInstance("UIStroke", toggleButton, "Stroke").Color = Color3.fromRGB(100, 100, 100)

		toggleButton.MouseButton1Click:Connect(function()
			moduleData.enabled = not moduleData.enabled
			modules[index] = moduleData
			local newColor = moduleData.enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
			local newText = moduleData.enabled and "ON" or "OFF"
			TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
			TweenService:Create(moduleButtons[index].icon, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
			toggleButton.Text = newText
			if moduleFunctions[index] then moduleFunctions[index](moduleData) end
		end)

		if currentSettings.textValue then
			local textFrame = createInstance("Frame", settingsFrame, "TextFrame")
			textFrame.Size = UDim2.new(1, 0, 0, 50)
			textFrame.BackgroundTransparency = 1

			local textLabel = createInstance("TextLabel", textFrame, "Label")
			textLabel.Size = UDim2.new(1, 0, 0, 20)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "Text Input:"
			textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			textLabel.TextScaled = true
			textLabel.Font = Enum.Font.GothamMedium
			textLabel.TextXAlignment = Enum.TextXAlignment.Left

			local textBox = createInstance("TextBox", textFrame, "TextBox")
			textBox.Size = UDim2.new(1, 0, 0, 25)
			textBox.Position = UDim2.new(0, 0, 0, 22)
			textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			textBox.BorderSizePixel = 0
			textBox.Text = currentSettings.textValue
			textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			textBox.TextScaled = true
			textBox.Font = Enum.Font.Gotham
			textBox.PlaceholderText = "Enter text..."
			textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
			createInstance("UICorner", textBox, "Corner").CornerRadius = UDim.new(0, 4)
			createInstance("UIStroke", textBox, "Stroke").Color = Color3.fromRGB(80, 80, 90)

			textBox.FocusLost:Connect(function()
				currentSettings.textValue = textBox.Text
				modules[index].modes[moduleData.currentMode] = currentSettings
				if moduleFunctions[index] then moduleFunctions[index](moduleData) end
			end)
		end

		if currentSettings.sliderValue and currentSettings.sliderMin and currentSettings.sliderMax then
			local sliderFrame = createInstance("Frame", settingsFrame, "SliderFrame")
			sliderFrame.Size = UDim2.new(1, 0, 0, 60)
			sliderFrame.BackgroundTransparency = 1

			local sliderLabel = createInstance("TextLabel", sliderFrame, "Label")
			sliderLabel.Size = UDim2.new(1, 0, 0, 20)
			sliderLabel.BackgroundTransparency = 1
			sliderLabel.Text = "Value: " .. currentSettings.sliderValue .. " (" .. currentSettings.sliderMin .. "-" .. currentSettings.sliderMax .. ")"
			sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			sliderLabel.TextScaled = true
			sliderLabel.Font = Enum.Font.GothamMedium
			sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

			local sliderBg = createInstance("Frame", sliderFrame, "SliderBg")
			sliderBg.Size = UDim2.new(1, 0, 0, 25)
			sliderBg.Position = UDim2.new(0, 0, 0, 25)
			sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			sliderBg.BorderSizePixel = 0
			createInstance("UICorner", sliderBg, "Corner").CornerRadius = UDim.new(0, 12)
			createInstance("UIStroke", sliderBg, "Stroke").Color = Color3.fromRGB(80, 80, 90)

			local sliderFill = createInstance("Frame", sliderBg, "SliderFill")
			local fillPercent = (currentSettings.sliderValue - currentSettings.sliderMin) / (currentSettings.sliderMax - currentSettings.sliderMin)
			sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
			sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
			sliderFill.BorderSizePixel = 0
			createInstance("UICorner", sliderFill, "Corner").CornerRadius = UDim.new(0, 12)
			local sliderGradient = createInstance("UIGradient", sliderFill, "Gradient")
			sliderGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
			}

			local sliderButton = createInstance("TextButton", sliderBg, "SliderButton")
			sliderButton.Size = UDim2.new(0, 25, 1, 0)
			sliderButton.Position = UDim2.new(fillPercent, -12.5, 0, 0)
			sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			sliderButton.BorderSizePixel = 0
			sliderButton.Text = ""
			createInstance("UICorner", sliderButton, "Corner").CornerRadius = UDim.new(1, 0)
			createInstance("UIStroke", sliderButton, "Stroke").Color = Color3.fromRGB(200, 200, 200)

			local draggingSlider = false

			sliderButton.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingSlider = true
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
					local mousePos = input.Position
					local sliderPos = sliderBg.AbsolutePosition
					local relativeX = mousePos.X - sliderPos.X
					local percent = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
					local newValue = math.floor(currentSettings.sliderMin + (currentSettings.sliderMax - currentSettings.sliderMin) * percent)
					currentSettings.sliderValue = newValue
					modules[index].modes[moduleData.currentMode] = currentSettings
					sliderFill.Size = UDim2.new(percent, 0, 1, 0)
					sliderButton.Position = UDim2.new(percent, -12.5, 0, 0)
					sliderLabel.Text = "Value: " .. newValue .. " (" .. currentSettings.sliderMin .. "-" .. currentSettings.sliderMax .. ")"
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingSlider then
					draggingSlider = false
					if moduleFunctions[index] then moduleFunctions[index](moduleData) end
				end
			end)

			sliderBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mousePos = input.Position
					local sliderPos = sliderBg.AbsolutePosition
					local relativeX = mousePos.X - sliderPos.X
					local percent = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
					local newValue = math.floor(currentSettings.sliderMin + (currentSettings.sliderMax - currentSettings.sliderMin) * percent)
					currentSettings.sliderValue = newValue
					modules[index].modes[moduleData.currentMode] = currentSettings
					TweenService:Create(sliderFill, TweenInfo.new(0.2), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
					TweenService:Create(sliderButton, TweenInfo.new(0.2), {Position = UDim2.new(percent, -12.5, 0, 0)}):Play()
					sliderLabel.Text = "Value: " .. newValue .. " (" .. currentSettings.sliderMin .. "-" .. currentSettings.sliderMax .. ")"
					if moduleFunctions[index] then moduleFunctions[index](moduleData) end
				end
			end)
		end

		settingsFrame.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 10)
		settingsFrame.Position = UDim2.new(0, 30, 0, 85)
		TweenService:Create(settingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 8, 0, 85)}):Play()
	end

	-- Button connections
	closeButton.MouseButton1Click:Connect(function()
		TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -325, 0.5, -275)}):Play()
		TweenService:Create(mainShadow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -330, 0.5, -280)}):Play()
		task.wait(0.3)
		mainGui:Destroy()
	end)

	minimizeButton.MouseButton1Click:Connect(function()
		if not isMinimized then
			TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 650, 0, 35)}):Play()
			TweenService:Create(mainShadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 660, 0, 45)}):Play()
			leftFrame.Visible = false
			rightFrame.Visible = false
			isMinimized = true
		else
			TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 650, 0, 450)}):Play()
			TweenService:Create(mainShadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 660, 0, 460)}):Play()
			task.wait(0.2)
			leftFrame.Visible = true
			rightFrame.Visible = true
			isMinimized = false
		end
	end)

	closeButton.MouseEnter:Connect(function()
		TweenService:Create(closeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
	end)

	closeButton.MouseLeave:Connect(function()
		TweenService:Create(closeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
	end)

	minimizeButton.MouseEnter:Connect(function()
		TweenService:Create(minimizeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 220, 50)}):Play()
	end)

	minimizeButton.MouseLeave:Connect(function()
		TweenService:Create(minimizeButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 190, 0)}):Play()
	end)

	-- Drag functionality
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			mainShadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X - 5, startPos.Y.Scale, startPos.Y.Offset + delta.Y - 5)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Initialize modules
	for i, moduleData in ipairs(modules) do
		createModuleButton(moduleData, i)
	end

	modulesList.CanvasSize = UDim2.new(0, 0, 0, #modules * 44 + (#modules - 1) * 6)

	-- Initial animation
	mainFrame.Position = UDim2.new(0.5, -325, 0.5, -275)
	mainShadow.Position = UDim2.new(0.5, -330, 0.5, -280)
	TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -325, 0.5, -225)}):Play()
	TweenService:Create(mainShadow, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -330, 0.5, -230)}):Play()

	return gui
end

return UILibrary
