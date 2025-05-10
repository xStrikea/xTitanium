local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local detectionRadius = 25
local healThreshold = 50
local healAmount = 50
local healCooldown = 0.2
local lastHeal = 0

local weaponPriority = {"VampireKnife", "Shovel", "Sword", "Axe", "MeleeWeapon"}

local function getBestMeleeWeapon()
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name == "Sword" or tool.Name == "Shovel" or tool.Name == "Axe" or tool.Name == "MeleeWeapon") then
			return tool
		end
	end
	return nil
end

local function equipWeapon(tool)
	local character = LocalPlayer.Character
	if tool and tool.Parent == LocalPlayer.Backpack then
		tool.Parent = character
	end
end

local function isEnemy(model)
	local humanoid = model:FindFirstChild("Humanoid")
	local hrp = model:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return false end
	if Players:GetPlayerFromCharacter(model) then return false end
	if humanoid.Health <= 0 then return false end
	return true
end

local function findNearestEnemy()
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
	local root = character.HumanoidRootPart
	local closest = nil
	local shortestDistance = detectionRadius

	for _, model in pairs(workspace:GetChildren()) do
		if model:IsA("Model") and isEnemy(model) then
			local hrp = model:FindFirstChild("HumanoidRootPart")
			local distance = (root.Position - hrp.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closest = model
			end
		end
	end

	return closest
end

RunService.RenderStepped:Connect(function()
	local character = LocalPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		if humanoid.Health > 0 and humanoid.Health < healThreshold and tick() - lastHeal > healCooldown then
			humanoid.Health = math.min(humanoid.Health + healAmount, humanoid.MaxHealth)
			lastHeal = tick()
		end
	end
	
	local enemy = findNearestEnemy()
	if enemy then
		local bestWeapon = getBestMeleeWeapon()
		if bestWeapon then
			equipWeapon(bestWeapon)
			local equipped = character:FindFirstChild(bestWeapon.Name)
			if equipped and equipped:IsA("Tool") and equipped:FindFirstChild("Handle") then
				equipped:Activate() 
			end
		end
	end
end)