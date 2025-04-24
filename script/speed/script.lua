-- Thanks to @ProBaconHub from scriptblox for the fix.
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if type(speed) ~= "table" or not speed.enabled or type(speed.value) ~= "number" then
    warn("[SimpleSpeed] Disabled or speed not properly set.")
    return
end

local function applySpeed()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed.value
        end
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

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
end)

RunService.Heartbeat:Connect(function()
    if speed.enabled then
        pcall(applySpeed)
    end
end)