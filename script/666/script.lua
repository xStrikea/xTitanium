local textureIds = {
	"rbxassetid://17373820263",
	"rbxassetid://17675276162",
	"rbxassetid://11543333192"
}
local musicId = "rbxassetid://157636421"
local faces = {"Top", "Bottom", "Left", "Right", "Front", "Back"}

local processedParts = {}

local function getRandomTextureId()
	return textureIds[math.random(1, #textureIds)]
end

local function applyOrUpdateTexture(part)
	if not part:IsA("BasePart") or part.Transparency >= 1 then return end

	for _, faceName in ipairs(faces) do
		local face = Enum.NormalId[faceName]
		local found = false

		for _, child in ipairs(part:GetChildren()) do
			if child:IsA("Texture") and child.Name == "AutoTexture_" .. faceName and child.Face == face then
				child.Texture = getRandomTextureId()
				child.Transparency = part.Transparency
				found = true
			end
		end

		if not found then
			local texture = Instance.new("Texture")
			texture.Texture = getRandomTextureId()
			texture.Face = face
			texture.Name = "AutoTexture_" .. faceName
			texture.Transparency = part.Transparency
			texture.Parent = part
		end
	end
end

local function forceApplyToModel(model)
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			applyOrUpdateTexture(part)
		end
	end
end

local function setCustomSkybox()
	local lighting = game:GetService("Lighting")
	for _, obj in ipairs(lighting:GetChildren()) do
		if obj:IsA("Sky") then obj:Destroy() end
	end

	local skyTextureId = getRandomTextureId()

	local sky = Instance.new("Sky")
	sky.SkyboxBk = skyTextureId
	sky.SkyboxDn = skyTextureId
	sky.SkyboxFt = skyTextureId
	sky.SkyboxLf = skyTextureId
	sky.SkyboxRt = skyTextureId
	sky.SkyboxUp = skyTextureId
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

local function updateTexturesLoop()
	while true do
		local allParts = {}

		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Transparency < 1 then
				table.insert(allParts, obj)
			end
		end

		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player.Character then
				for _, part in ipairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.Transparency < 1 then
						table.insert(allParts, part)
					end
				end
			end
		end

		for _, part in ipairs(allParts) do
			applyOrUpdateTexture(part)
		end

		task.wait(0.5) 
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
task.spawn(updateTexturesLoop)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	setupPlayer(player)
end

game:GetService("Players").PlayerAdded:Connect(setupPlayer)