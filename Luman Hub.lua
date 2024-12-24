local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()


local Window = OrionLib:MakeWindow({Name = "Luman HUB", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Deepwoken",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "DeepWoken is trash"
})

Tab:AddToggle({
	Name = "Player ESP",
	Default = false,
	Callback = function(Value)
		local Players = game:GetService("Players")

-- Function to create a BillboardGui for displaying the player's name
local function createNameTag(character, playerName)
    if character:FindFirstChild("NameTag") then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameTag"
    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(5, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = playerName
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextScaled = true
    textLabel.Parent = billboard
end

-- Function to add a highlight effect to a character
local function addHighlight(character)
    if character:FindFirstChild("Highlight") then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.FillColor = Color3.new(0, 1, 0) -- Green fill color
    highlight.OutlineColor = Color3.new(1, 0, 0) -- Red outline color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.Parent = character
end

-- Handle new players joining
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        createNameTag(character, player.Name)
        addHighlight(character)
    end)

    if player.Character then
        createNameTag(player.Character, player.Name)
        addHighlight(player.Character)
    end
end

-- Connect to existing and new players
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)

	end    
})

Tab:AddBind({
	Name = "Noclip",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		print("press")


local Players = game:GetService("Players")

local player = Players.LocalPlayer

local function disableCanCollide()
    local character = player.Character or player.CharacterAdded:Wait()

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- Listen for new parts being added to the character
    character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end)
end

-- Run the function when the player's character is ready
if player.Character then
    disableCanCollide()
else
    player.CharacterAdded:Connect(disableCanCollide)
end




	end    
})


Tab:AddBind({
	Name = "Place Part Under u",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		print("press")
        


local Players = game:GetService("Players")

local player = Players.LocalPlayer

local function spawnBlockUnderFeet()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Create a new block
    local block = Instance.new("Part")
    block.Size = Vector3.new(5, 1, 5) -- Adjust the size as needed
    block.Position = humanoidRootPart.Position - Vector3.new(0, humanoidRootPart.Size.Y / 2 + 0.5, 0) -- Place it under the feet
    block.Anchored = true
    block.BrickColor = BrickColor.new("Bright yellow") -- Optional: change block color
    block.Parent = workspace
end

-- Call the function to spawn the block
spawnBlockUnderFeet()





	end    
})


Tab:AddBind({
	Name = "Remove All the parts",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		print("press")
        local workspace = game:GetService("Workspace")

local function removeBlocks()
    for _, part in ipairs(workspace:GetChildren()) do
        -- Check if the part is an anchored block with the size 5x1x5
        if part:IsA("Part") and part.Anchored and part.Size == Vector3.new(5, 1, 5) and part.BrickColor == BrickColor.new("Bright yellow") then
            part:Destroy()
        end
    end
end

-- Call the function to remove the blocks
removeBlocks()
	end    
})



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local StarterPlayer = game:GetService("StarterPlayer")
local BlockAction = StarterPlayer.StarterCharacterScripts.CharacterHandler.Requests:FindFirstChild("Block")

local DetectionRadius = 5 -- Adjust this value for proximity detection
local monitoring = false -- Tracks toggle state

local function detectProximity()
    while monitoring do
        pcall(function()
            -- Check for players' weapons
            for _, livePlayer in pairs(workspace.Live:GetChildren()) do
                -- Exclude the local player
                if livePlayer.Name ~= LocalPlayer.Name and livePlayer:FindFirstChild("Weapon") then
                    local weapon = livePlayer.Weapon:FindFirstChild("Weapon")
                    if weapon and weapon:IsA("BasePart") then
                        local distance = (HumanoidRootPart.Position - weapon.Position).Magnitude
                        if distance <= DetectionRadius then
                            -- Trigger block if the weapon is close enough
                            if BlockAction then
                                BlockAction.Value = true
                            end
                        end
                    end
                end
            end

            -- Check for nearby non-player objects
            for _, obj in pairs(workspace.Live:GetChildren()) do
                -- Exclude players
                if not obj:FindFirstChild("Humanoid") and obj:IsA("BasePart") then
                    local distance = (HumanoidRootPart.Position - obj.Position).Magnitude
                    if distance <= DetectionRadius then
                        -- Trigger block if the object is close enough
                        if BlockAction then
                            BlockAction.Value = true
                        end
                    end
                end
            end
        end)
        wait(0.1) -- Adjust for performance and responsiveness
    end
end

-- Add Toggle Callback
Tab:AddToggle({
    Name = "Enable Auto-Block\parry player and mobs",
    Default = false,
    Callback = function(Value)
        monitoring = Value
        if monitoring then
            task.spawn(detectProximity)
        end
    end    
})


local Workspace = game:GetService("Workspace")
local chestsFolderName = "Chests"

local function applyGlowEffect(object)
    if not object:FindFirstChildOfClass("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = object
        highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Gold color for glow
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
        highlight.Parent = object
    end
end

local function removeGlowEffect(object)
    local highlight = object:FindFirstChildOfClass("Highlight")
    if highlight then
        highlight:Destroy()
    end
end

local function processChests(folder, isEnabled)
    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("BasePart") or item:IsA("Model") then
            if isEnabled then
                applyGlowEffect(item)
            else
                removeGlowEffect(item)
            end
        end
    end
end

local chestsFolder = Workspace:FindFirstChild(chestsFolderName)
if not chestsFolder then
    warn("Chests folder not found!")
    return
end

-- Toggle setup
Tab:AddToggle({
    Name = "Chest Eps",
    Default = false,
    Callback = function(Value)
        if Value then
            print("Chest ESP Enabled")
            processChests(chestsFolder, true)

            -- Handle dynamic additions
            chestsFolder.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("BasePart") or descendant:IsA("Model") then
                    applyGlowEffect(descendant)
                end
            end)
        else
            print("Chest ESP Disabled")
            processChests(chestsFolder, false)
        end
    end
})
