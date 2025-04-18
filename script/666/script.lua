local textureIds = {
	"rbxassetid://17373820263",
	"rbxassetid://17675276162",
	"rbxassetid://11543333192"
}
local skyboxId = "rbxassetid://17373820263"
local musicId = "rbxassetid://157636421"
local faces = {"Top", "Bottom", "Left", "Right", "Front", "Back"}

local processed = {}

local function getRandomTextureId()
	return textureIds[math.random(1, #textureIds)]
end

local function forceApplyTexture(part)
	local replaced = false
	for _, faceName in ipairs(faces) do
		local face = Enum.NormalId[faceName]

		for _, child in ipairs(part:GetChildren()) do
			if child:IsA("Texture") and child.Face == face then
				child:Destroy()
				replaced = true
			end
		end

		local texture = Instance.new("Texture")
		texture.Texture = getRandomTextureId()
		texture.Face = face
		texture.Name = "AutoTexture_" .. faceName
		texture.Parent = part
	end

	if replaced or not processed[part] then
		print("" .. part:GetFullName())
	end

	processed[part] = true
end

local function forceApplyToModel(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			forceApplyTexture(part)
		end
	end
end

local function setCustomSkybox()
	local lighting = game:GetService("Lighting")
	for _, obj in ipairs(lighting:GetChildren()) do
		if obj:IsA("Sky") then obj:Destroy() end
	end

	local sky = Instance.new("Sky")
	sky.SkyboxBk = skyboxId
	sky.SkyboxDn = skyboxId
	sky.SkyboxFt = skyboxId
	sky.SkyboxLf = skyboxId
	sky.SkyboxRt = skyboxId
	sky.SkyboxUp = skyboxId
	sky.Name = "CustomSky"
	sky.Parent = lighting
end

local function playBackgroundMusic()
	local sound = Instance.new("Sound")
	sound.SoundId = musicId
	sound.Looped = true
	sound.Volume = 0.2
	sound.Name = "BackgroundMusic"
	sound.Parent = workspace
	sound:Play()
end

local function constantlyEnforceTextures()
	while true do
		local parts = {}
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				table.insert(parts, obj)
			end
		end
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player.Character then
				for _, part in ipairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						table.insert(parts, part)
					end
				end
			end
		end

		for i = 1, #parts, 100 do
			for j = i, math.min(i + 49, #parts) do
				local part = parts[j]
				forceApplyTexture(part)
			end
			wait(0.1)
		end
	end
end

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(char)
		forceApplyToModel(char)
	end)
	if player.Character then
		forceApplyToModel(player.Character)
	end
end

setCustomSkybox()
playBackgroundMusic()
task.spawn(constantlyEnforceTextures)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	setupPlayer(player)
end

game:GetService("Players").PlayerAdded:Connect(setupPlayer)