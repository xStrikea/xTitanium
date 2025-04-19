local textureIds = {
	"rbxassetid://17373820263",
	"rbxassetid://17675276162",
	"rbxassetid://11543333192"
}
local musicId = "rbxassetid://157636421"
local faces = {"Top", "Bottom", "Left", "Right", "Front", "Back"}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local allParts = {}
local partIndex = 1

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

local function refreshAllParts()
	allParts = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Transparency < 1 then
			table.insert(allParts, obj)
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			for _, part in ipairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.Transparency < 1 then
					table.insert(allParts, part)
				end
			end
		end
	end
end

local function gradualTextureUpdater()
	RunService.Heartbeat:Connect(function()
		if #allParts == 0 then return end

		local part = allParts[partIndex]
		if part and part:IsA("BasePart") and part.Transparency < 1 then
			applyOrUpdateTexture(part)
		end

		partIndex = partIndex + 1
		if partIndex > #allParts then
			partIndex = 1
		end
	end)
end

local function setCustomSkybox()
	for _, obj in ipairs(Lighting:GetChildren()) do
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
	sky.Parent = Lighting
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

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(char)
		task.wait(1)
		refreshAllParts()
	end)
	if player.Character then
		refreshAllParts()
	end
end

setCustomSkybox()
playBackgroundMusic()
gradualTextureUpdater()

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end
Players.PlayerAdded:Connect(setupPlayer)

while true do
	refreshAllParts()
	task.wait(3)
end