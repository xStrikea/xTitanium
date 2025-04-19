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
	if not part:IsA("BasePart") then return end

	for _, child in ipairs(part:GetChildren()) do
		if child:IsA("Texture") then
			child:Destroy()
		end
	end

	if part.Transparency < 1 then
		for _, faceName in ipairs(faces) do
			local texture = Instance.new("Texture")
			texture.Texture = getRandomTextureId()
			texture.Face = Enum.NormalId[faceName]
			texture.Name = "AutoTexture_" .. faceName
			texture.Transparency = part.Transparency
			texture.Parent = part
		end
	end

	replaceImageAssets(part)
end

local function applyTexturesToAll()
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

	for i = 1, #parts, 50 do
		for j = i, math.min(i + 49, #parts) do
			forceApplyTexture(parts[j])
		end
		wait(0.03)
	end
end

-- 天空盒設定 + 假太陽 Billboard
local function setCustomSkybox()
	local lighting = game:GetService("Lighting")
	for _, obj in ipairs(lighting:GetChildren()) do
		if obj:IsA("Sky") then obj:Destroy() end
	end

	local skyId = getRandomTextureId()
	local sky = Instance.new("Sky")
	sky.SkyboxBk = skyId
	sky.SkyboxDn = skyId
	sky.SkyboxFt = skyId
	sky.SkyboxLf = skyId
	sky.SkyboxRt = skyId
	sky.SkyboxUp = skyId
	sky.CelestialBodiesShown = false
	sky.Name = "CustomSky"
	sky.Parent = lighting

	local sunPart = workspace:FindFirstChild("FakeSun") or Instance.new("Part", workspace)
	sunPart.Name = "FakeSun"
	sunPart.Anchored = true
	sunPart.CanCollide = false
	sunPart.Size = Vector3.new(1, 1, 1)
	sunPart.Position = workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 500, 0)
	sunPart.Transparency = 1

	local billboard = Instance.new("BillboardGui", sunPart)
	billboard.Size = UDim2.new(0, 150, 0, 150)
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.Name = "SunBillboard"

	local img = Instance.new("ImageLabel", billboard)
	img.Image = imageOverrideId
	img.Size = UDim2.new(1, 0, 1, 0)
	img.BackgroundTransparency = 1
end

-- 音樂播放
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

task.spawn(function()
	while true do
		applyTexturesToAll()
		wait(0.5)
	end
end)

setCustomSkybox()
playBackgroundMusic()

for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
	player.CharacterAdded:Connect(function()
		applyTexturesToAll()
	end)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		applyTexturesToAll()
	end)
end)