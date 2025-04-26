-- Anti-NextBot Patch
local player = game.Players.LocalPlayer

game:GetService("RunService").Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Velocity.Magnitude > 50 and (obj.Position - hrp.Position).Magnitude < 10 then
                hrp.Velocity = Vector3.new(0,0,0)
                hrp.RotVelocity = Vector3.new(0,0,0)
                warn("[Anti-NextBot] High-velocity object neutralized.")
            end
        end
    end
end)

warn("[Anti-NextBot] Patch applied.")