local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if type(speed) ~= "number" or not (speed.enabled) then
    warn("[SimpleSpeed] Disabled or speed not set.")
    return
end

local function applySpeed()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

if not getgenv()._bypassSpeed then
    getgenv()._bypassSpeed = true
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index

    mt.__index = newcclosure(function(self, key)
        if key == "WalkSpeed" and typeof(self) == "Instance" and self:IsA("Humanoid") then
            return 16 
        end
        return oldIndex(self, key)
    end)
end

applySpeed()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
end)

while speed.enabled do
    task.wait(0.5)
    pcall(applySpeed)
end