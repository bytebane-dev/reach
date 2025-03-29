_G.HeadSize = Vector3.new(6.5, 6.5, 6.5) -- Adjust as needed
_G.HumanoidRootPartSize = Vector3.new(3, 3, 3) -- Adjust as needed
_G.Disabled = false

local localPlayer = game:GetService('Players').LocalPlayer

local function scaleHitbox(character)
    if character then
        local head = character:FindFirstChild("Head")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if head then
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if not mesh then
                mesh = Instance.new("SpecialMesh")
                mesh.Parent = head
            end
            pcall(function()
                mesh.Scale = Vector3.new(_G.HeadSize.X / head.Size.X, _G.HeadSize.Y / head.Size.Y, _G.HeadSize.Z / head.Size.Z)
                head.Size = _G.HeadSize
                head.Transparency = 0.98 -- Nearly invisible instead of 0.7
                head.CanCollide = false
                
                -- Hide face decal
                local face = head:FindFirstChildOfClass("Decal")
                if face then
                    face.Transparency = 1
                end
            end)
        end

        if humanoidRootPart then
            pcall(function()
                humanoidRootPart.Size = _G.HumanoidRootPartSize
                humanoidRootPart.Transparency = 1 -- Fully invisible
                humanoidRootPart.CanCollide = false
            end)
        end
    end
end

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid")
    scaleHitbox(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        scaleHitbox(character)
    end)
end

local function onPlayerAdded(player)
    if player ~= localPlayer then
        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end
end

game:GetService('Players').PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(game:GetService('Players'):GetPlayers()) do
    onPlayerAdded(player)
end

game:GetService('RunService').RenderStepped:Connect(function()
    if not _G.Disabled then
        for _, player in pairs(game:GetService('Players'):GetPlayers()) do
            if player ~= localPlayer then
                pcall(function() 
                    scaleHitbox(player.Character)
                end)
            end
        end
    end
end)
