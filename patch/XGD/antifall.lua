-- Anti-Fall Damage Patch
local player = game.Players.LocalPlayer

local function protect()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                warn("[Anti-Fall] Freefall prevented.")
            end
        end)
    end
end

if player.Character then protect() end
player.CharacterAdded:Connect(protect)
warn("[Anti-Fall] Patch applied.")