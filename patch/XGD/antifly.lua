-- Anti-Fly Patch
local player = game.Players.LocalPlayer

game:GetService("RunService").Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
            warn("[Anti-Fly] PlatformStand disabled.")
        end
    end
end)

warn("[Anti-Fly] Patch applied.")