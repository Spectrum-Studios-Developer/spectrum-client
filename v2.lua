local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Spectrum-Studios-Developer/spectrum-client/refs/heads/main/uienginev1.lua"))()

local player = game:GetService("Players").LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local modules = {
    {name = "Disabler", enabled = true},
    {name = "Speed", enabled = false, sliderValue = 16, sliderMin = 2, sliderMax = 75},
    {name = "Fly", enabled = false, sliderValue = 16, sliderMin = 10, sliderMax = 75},
    {name = "No Clip", enabled = false, sliderValue = 2, sliderMin = 0, sliderMax = 10},
    {name = "Anti Bot", enabled = false, sliderValue = 26, sliderMin = 1, sliderMax = 50},
    {name = "Inf Health", enabled = false}
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
        if moduleData.healthConnection then
            moduleData.healthConnection:Disconnect()
            moduleData.healthConnection = nil
        end
        if moduleData.charAddedConnection then
            moduleData.charAddedConnection:Disconnect()
            moduleData.charAddedConnection = nil
        end
        if not moduleData.enabled then return end
        local function setMaxHealth()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
        local function connectToCharacter(character)
            local humanoid = character:WaitForChild("Humanoid")
            setMaxHealth()
            moduleData.healthConnection = humanoid.HealthChanged:Connect(function()
                if moduleData.enabled then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
        if player.Character then
            connectToCharacter(player.Character)
        end
        moduleData.charAddedConnection = player.CharacterAdded:Connect(connectToCharacter)
    end,
}

UILibrary:CreateUI(player, modules, moduleFunctions)
