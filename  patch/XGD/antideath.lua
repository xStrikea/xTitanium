-- Anti-Death Patch
local player = game.Players.LocalPlayer

local function protect()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                humanoid.Health = 100
                warn("[Anti-Death] Health restored.")
            end
        end)
    end
end

if player.Character then protect() end
player.CharacterAdded:Connect(protect)
warn("[Anti-Death] Patch applied.")