--  6҉6҉6҉ 6҉6҉6҉ 6҉6҉6҉ 6҉6҉6҉ 6҉6҉6҉
local textureIds = {
	"rbxassetid://17373820263",
	"rbxassetid://17675276162",
	"rbxassetid://11543333192"
}
local imageOverrideId = "rbxassetid://74276495274441"
local musicId = "rbxassetid://157636421"
local faces = {"Top", "Bottom", "Left", "Right", "Front", "Back"}

local function getRandomTextureId()
	return textureIds[math.random(1, #textureIds)]
end

local function getRandomSkyboxId()
	return textureIds[math.random(1, #textureIds)]
end

local function replaceImageAssets(object)
	for _, child in ipairs(object:GetDescendants()) do
		if child:IsA("Decal") then
			child.Texture = imageOverrideId
		elseif (child:IsA("ImageLabel") or child:IsA("ImageButton")) then
			pcall(function()
				child.Image = imageOverrideId
			end)
		end
	end
end

local function forceApplyTexture(part)
	if not part:IsA("BasePart") or part.Transparency >= 1 then return end

	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("Texture") then
			child:Destroy()
		end
	end

	for _, faceName in ipairs(faces) do
		local texture = Instance.new("Texture")
		texture.Texture = getRandomTextureId()
		texture.Face = Enum.NormalId[faceName]
		texture.Name = "AutoTexture_" .. faceName
		texture.Transparency = part.Transparency
		texture.Parent = part
	end

	replaceImageAssets(part)
end

local function applyTexturesToAll()
	local parts = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Transparency < 1 then
			table.insert(parts, obj)
		end
	end

	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		if player.Character then
			for _, part in ipairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.Transparency < 1 then
					table.insert(parts, part)
				end
			end
		end
	end

	for i = 1, #parts, 50 do
		for j = i, math.min(i + 49, #parts) do
			forceApplyTexture(parts[j])
		end
		wait(0.03)
	end
end

local function setCustomSkybox()
	local lighting = game:GetService("Lighting")
	for _, obj in ipairs(lighting:GetChildren()) do
		if obj:IsA("Sky") then obj:Destroy() end
	end

	local sky = Instance.new("Sky")
	local skyId = getRandomSkyboxId()
	sky.SkyboxBk = skyId
	sky.SkyboxDn = skyId
	sky.SkyboxFt = skyId
	sky.SkyboxLf = skyId
	sky.SkyboxRt = skyId
	sky.SkyboxUp = skyId
	sky.Name = "CustomSky"
	sky.Parent = lighting
end

local function enforceSkybox()
	local lighting = game:GetService("Lighting")
	lighting.ChildRemoved:Connect(function(obj)
		if obj:IsA("Sky") then
			task.wait(0.2)
			setCustomSkybox()
		end
	end)
end

local function playBackgroundMusic()
	local sound = workspace:FindFirstChild("BackgroundMusic")
	if not sound then
		sound = Instance.new("Sound")
		sound.Name = "BackgroundMusic"
		sound.SoundId = musicId
		sound.Volume = 0.2
		sound.Looped = true
		sound.Parent = workspace
		sound:Play()
	end
end

local function monitorMusic()
	task.spawn(function()
		while true do
			if not workspace:FindFirstChild("BackgroundMusic") then
				playBackgroundMusic()
			end
			wait(3)
		end
	end)
end

local function setupPlayer(player)
	player.CharacterAdded:Connect(function(char)
		applyTexturesToAll()
	end)
	if player.Character then
		applyTexturesToAll()
	end
end

setCustomSkybox()
enforceSkybox()
playBackgroundMusic()
monitorMusic()
task.spawn(function()
	while true do
		applyTexturesToAll()
		wait(0.5)
	end
end)

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	setupPlayer(player)
end
game:GetService("Players").PlayerAdded:Connect(setupPlayer)