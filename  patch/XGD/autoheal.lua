-- Auto-Heal Patch
local player = game.Players.LocalPlayer

game:GetService("RunService").Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
            warn("[Auto-Heal] Health restored to maximum.")
        end
    end
end)

warn("[Auto-Heal] Patch applied.")