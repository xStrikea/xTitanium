-- Auto-Fix Humanoid Patch
local player = game.Players.LocalPlayer

game:GetService("RunService").Heartbeat:Connect(function()
    local character = player.Character
    if character and not character:FindFirstChildOfClass("Humanoid") then
        local humanoid = Instance.new("Humanoid")
        humanoid.Parent = character
        warn("[Auto-Fix Humanoid] Humanoid recreated.")
    end
end)

warn("[Auto-Fix Humanoid] Patch applied.")