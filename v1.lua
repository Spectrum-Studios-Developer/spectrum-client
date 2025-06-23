local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

if player.PlayerGui:FindFirstChild("main") then 
	player.PlayerGui.main:Destroy()
	print("Destroyed old version")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "main"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("ScrollingFrame")
mainFrame.ScrollBarThickness = 0
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Parent = screenGui

local function updateSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local scale = math.min(viewportSize.X, viewportSize.Y) / 1080
    scale = math.clamp(scale, 0.5, 10) 
    
    local baseSize = Vector2.new(300, 300)
    mainFrame.Size = UDim2.new(0, baseSize.X * scale, 0, baseSize.Y * scale)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
updateSize() 

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084" 
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ZIndex = -1
shadow.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Spectrum"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 24
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 24
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame

local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 150, 0, 20)
watermark.Position = UDim2.new(0, 10, 1, -25)
watermark.BackgroundTransparency = 1
watermark.Text = "Created by: pzcax"
watermark.TextColor3 = Color3.new(0.7, 0.7, 0.7)
watermark.Font = Enum.Font.Gotham
watermark.TextSize = 14
watermark.TextXAlignment = Enum.TextXAlignment.Left
watermark.Parent = contentFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 15)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = contentFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingLeft = UDim.new(0, 20)
padding.PaddingRight = UDim.new(0, 20)
padding.PaddingBottom = UDim.new(0, 35) 
padding.Parent = contentFrame

local dragging = false
local dragOffset

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragOffset = input.Position - mainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		mainFrame.Position = UDim2.new(0, input.Position.X - dragOffset.X.Offset, 0, input.Position.Y - dragOffset.Y.Offset)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

local isMinimized = false
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(0, mainFrame.Size.X.Offset, 0, 40)

minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	
	local targetSize = isMinimized and minimizedSize or originalSize
	local targetPos = isMinimized and 
		UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 
		mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + (originalSize.Y.Offset - minimizedSize.Y.Offset)/2) or
		UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 
		mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset - (originalSize.Y.Offset - minimizedSize.Y.Offset)/2)
	
	contentFrame.Visible = not isMinimized
	minimizeButton.Text = isMinimized and "+" or "−"
	
	TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = targetSize,
		Position = targetPos
	}):Play()
end)

closeButton.MouseButton1Click:Connect(function()
	local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {
		BackgroundTransparency = 1
	})
	
	fadeTween:Play()
	fadeTween.Completed:Connect(function()
		screenGui:Destroy()
	end)
	
	TweenService:Create(shadow, TweenInfo.new(0.3), {
		ImageTransparency = 1
	}):Play()
end)

local function setupButtonHover(button, baseColor, hoverColor)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = baseColor}):Play()
	end)
end

setupButtonHover(closeButton, Color3.fromRGB(255, 80, 80), Color3.fromRGB(255, 50, 50))
setupButtonHover(minimizeButton, Color3.fromRGB(80, 80, 255), Color3.fromRGB(50, 50, 255))

local function createToggle(name, callback, hasOptions)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, hasOptions and 120 or 50)
	container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	container.BackgroundTransparency = 0.2
	container.ClipsDescendants = true
	container.Parent = contentFrame
	
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 8)
	containerCorner.Parent = container
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Size = UDim2.new(1, 0, 0, 50)
	toggleButton.BackgroundTransparency = 1
	toggleButton.Text = ""
	toggleButton.Parent = container
	
	local toggleLabel = Instance.new("TextLabel")
	toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
	toggleLabel.BackgroundTransparency = 1
	toggleLabel.Text = name
	toggleLabel.TextColor3 = Color3.new(1, 1, 1)
	toggleLabel.Font = Enum.Font.GothamSemibold
	toggleLabel.TextSize = 18
	toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleLabel.Position = UDim2.new(0, 15, 0, 0)
	toggleLabel.Parent = toggleButton
	
	local switchOuter = Instance.new("Frame")
	switchOuter.Size = UDim2.new(0, 50, 0, 26)
	switchOuter.Position = UDim2.new(1, -65, 0.5, -13)
	switchOuter.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	switchOuter.BorderSizePixel = 0
	switchOuter.Parent = toggleButton
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switchOuter
	
	local switchInner = Instance.new("Frame")
	switchInner.Size = UDim2.new(0, 20, 0, 20)
	switchInner.Position = UDim2.new(0, 3, 0.5, -10)
	switchInner.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	switchInner.BorderSizePixel = 0
	switchInner.Parent = switchOuter
	
	local switchInnerCorner = Instance.new("UICorner")
	switchInnerCorner.CornerRadius = UDim.new(1, 0)
	switchInnerCorner.Parent = switchInner
	
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(0, 40, 0, 20)
	statusLabel.Position = UDim2.new(1, -110, 0.5, -10)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "OFF"
	statusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.TextSize = 16
	statusLabel.Parent = toggleButton
	
	local toggled = false
	local optionsFrame
	local sliderFill, sliderLabel, sliderKnob
	local speedValue = 60 
	
	if hasOptions then
		optionsFrame = Instance.new("Frame")
		optionsFrame.Size = UDim2.new(1, -20, 0, 60)
		optionsFrame.Position = UDim2.new(0, 10, 0, 50)
		optionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		optionsFrame.BorderSizePixel = 0
		optionsFrame.Visible = false
		optionsFrame.Parent = container
		
		local optionsCorner = Instance.new("UICorner")
		optionsCorner.CornerRadius = UDim.new(0, 8)
		optionsCorner.Parent = optionsFrame
		
		sliderLabel = Instance.new("TextLabel")
		sliderLabel.Size = UDim2.new(1, 0, 0, 20)
		sliderLabel.Position = UDim2.new(0, 10, 0, 5)
		sliderLabel.BackgroundTransparency = 1
		sliderLabel.Text = "Speed: " .. speedValue
		sliderLabel.TextColor3 = Color3.new(1, 1, 1)
		sliderLabel.Font = Enum.Font.Gotham
		sliderLabel.TextSize = 16
		sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
		sliderLabel.Parent = optionsFrame
		
		local sliderBar = Instance.new("Frame")
		sliderBar.Size = UDim2.new(1, -20, 0, 6)
		sliderBar.Position = UDim2.new(0, 10, 0, 30)
		sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		sliderBar.BorderSizePixel = 0
		sliderBar.Parent = optionsFrame
		
		local sliderBarCorner = Instance.new("UICorner")
		sliderBarCorner.CornerRadius = UDim.new(1, 0)
		sliderBarCorner.Parent = sliderBar
		
		sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
		sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderBar
		
		local sliderFillCorner = Instance.new("UICorner")
		sliderFillCorner.CornerRadius = UDim.new(1, 0)
		sliderFillCorner.Parent = sliderFill
		
		sliderKnob = Instance.new("Frame")
		sliderKnob.Size = UDim2.new(0, 16, 0, 16)
		sliderKnob.Position = UDim2.new(0.5, -8, 0.5, -8)
		sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sliderKnob.BorderSizePixel = 0
		sliderKnob.ZIndex = 2
		sliderKnob.Parent = sliderFill
		
		local sliderKnobCorner = Instance.new("UICorner")
		sliderKnobCorner.CornerRadius = UDim.new(1, 0)
		sliderKnobCorner.Parent = sliderKnob
		
		local dragging = false
		local minSpeed = 16
		local maxSpeed = 150
		
		local function updateSpeedSlider(x)
			local relX = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
			sliderFill.Size = UDim2.new(relX, 0, 1, 0)
			speedValue = math.floor(minSpeed + (maxSpeed - minSpeed) * relX)
			sliderLabel.Text = "Speed: " .. speedValue
			
			if toggled then 
				callback(true, speedValue) 
			end
		end
		
		sliderBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				updateSpeedSlider(input.Position.X)
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				updateSpeedSlider(input.Position.X)
			end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		statusLabel.Text = toggled and "ON" or "OFF"
		statusLabel.TextColor3 = toggled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
		
		local switchInnerPosition = toggled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
		local switchOuterColor = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
		
		TweenService:Create(switchInner, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Position = switchInnerPosition
		}):Play()
		
		TweenService:Create(switchOuter, TweenInfo.new(0.2), {
			BackgroundColor3 = switchOuterColor
		}):Play()
		
		if hasOptions then
			local targetSize = toggled and UDim2.new(1, 0, 0, 120) or UDim2.new(1, 0, 0, 50)
			TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
				Size = targetSize
			}):Play()
			
			if toggled then
				delay(0.1, function()
					optionsFrame.Visible = true
					TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
						BackgroundTransparency = 0
					}):Play()
				end)
			else
				TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
					BackgroundTransparency = 1
				}):Play()
				delay(0.2, function()
					optionsFrame.Visible = false
				end)
			end
			
			callback(toggled, speedValue)
		else
			callback(toggled)
		end
	end)
	
	toggleButton.MouseEnter:Connect(function()
		TweenService:Create(container, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		}):Play()
	end)
	
	toggleButton.MouseLeave:Connect(function()
		TweenService:Create(container, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		}):Play()
	end)
	
	return {
		Container = container,
		Toggle = toggleButton,
		OptionsFrame = optionsFrame,
		IsToggled = function() return toggled end,
		SetToggled = function(state) 
			if toggled ~= state then
				toggleButton.MouseButton1Click:Fire()
			end
		end
	}
end

local originalWalkSpeed = humanoid.WalkSpeed

createToggle("Speed Boost", function(state, speed)
	if state then
		humanoid.WalkSpeed = speed or 100
	else
		humanoid.WalkSpeed = originalWalkSpeed
	end
end, true)

local flyConnection, flyVelocity
createToggle("Fly", function(state, flySpeed)
	local root = character:WaitForChild("HumanoidRootPart")
	
	if state then
		flyVelocity = Instance.new("BodyVelocity")
		flyVelocity.Velocity = Vector3.zero
		flyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
		flyVelocity.Parent = root
		
		flyConnection = RunService.RenderStepped:Connect(function()
			local moveDirection = Vector3.new(0, 0, 0)
			local camera = workspace.CurrentCamera
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDirection = moveDirection + camera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDirection = moveDirection - camera.CFrame.LookVector
			end
			
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDirection = moveDirection - camera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDirection = moveDirection + camera.CFrame.RightVector
			end
			
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDirection = moveDirection + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveDirection = moveDirection - Vector3.new(0, 1, 0)
			end
			
			if moveDirection.Magnitude > 0 then
				moveDirection = moveDirection.Unit
			end
			
			flyVelocity.Velocity = moveDirection * (flySpeed or 60)
		end)
		
		humanoid.PlatformStand = true
	else
		if flyConnection then flyConnection:Disconnect() end
		if flyVelocity then flyVelocity:Destroy() end
		
		humanoid.PlatformStand = false
	end
end, true)

local derpConnection = nil 

createToggle("Derp", function(state, derpSpeed)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    if state then
   
        if derpConnection then
            derpConnection:Disconnect()
            derpConnection = nil
        end

        derpConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
            local rotationSpeed = derpSpeed * 1000 or 26
            local rotationAmount = math.rad(rotationSpeed * deltaTime)
            root.CFrame = root.CFrame * CFrame.Angles(0, rotationAmount, 0)
        end)
    else
        if derpConnection then
            derpConnection:Disconnect()
            derpConnection = nil
        end
    end
end, true)

local espConnection = nil
local charAddedConnections = {}
local espGuiMap = {}

function createUIESP(player)
    if player == game.Players.LocalPlayer then return end

    local function attachESPToCharacter(character)
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
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = billboard

        espGuiMap[player] = billboard
    end

    if player.Character then
        attachESPToCharacter(player.Character)
    end

    charAddedConnections[player] = player.CharacterAdded:Connect(function(char)
        task.wait(1)
        attachESPToCharacter(char)
    end)
end

function removeUIESP()
    for _, gui in pairs(espGuiMap) do
        if gui and gui.Parent then
            gui:Destroy()
        end
    end
    espGuiMap = {}

    for _, conn in pairs(charAddedConnections) do
        if conn then conn:Disconnect() end
    end
    charAddedConnections = {}

    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
end

createToggle("ESP", function(state)
    if state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            createUIESP(player)
        end

        espConnection = game.Players.PlayerAdded:Connect(function(player)
            createUIESP(player)
        end)
    else
        removeUIESP()
    end
end)


local aimbotRunning = false
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local rightMouseHeld = false

--CONFIG
local FOV_RADIUS = 150
local SMOOTHNESS = 0.2

userInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMouseHeld = true
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        rightMouseHeld = false
    end
end)

local function getClosestTarget()
    local closest = nil
    local shortestDist = math.huge

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart
                local screenPoint, onScreen = camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist and dist < FOV_RADIUS then
                        closest = hrp
                        shortestDist = dist
                    end
                end
            end
        end
    end

    return closest
end

local function aimAt(target)
    local camPos = camera.CFrame.Position
    local dir = (target.Position - camPos).Unit
    local goalCFrame = CFrame.new(camPos, camPos + dir)

    camera.CFrame = camera.CFrame:Lerp(goalCFrame, SMOOTHNESS)
end

local function startAimbot()
    aimbotRunning = true
    runService:BindToRenderStep("Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
        if rightMouseHeld then
            local target = getClosestTarget()
            if target then
                aimAt(target)
            end
        end
    end)
end

local function stopAimbot()
    aimbotRunning = false
    runService:UnbindFromRenderStep("Aimbot")
end

createToggle("Aimbot", function(state)
    if state then
        startAimbot()
    else
        stopAimbot()
    end
end)

return screenGui
