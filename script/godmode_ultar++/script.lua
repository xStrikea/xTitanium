--[[
    Godmode ULTRA++ by xSpecter(github name)
    Feature: Full protection + Anti-detection + Auto-recover + F6 toggle
    MIT License
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local ProtectionEnabled = true
local KEY_TOGGLE = Enum.KeyCode.F6

-- 通知用函式
local function notify(msg)
    StarterGui:SetCore("SendNotification", {
        Title = "Godmode ULTRA+",
        Text = msg,
        Duration = 3
    })
end

local function protectCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid") or Instance.new("Humanoid", character)
    humanoid.Name = "Humanoid"

    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health <= 0 and ProtectionEnabled then
            humanoid.Health = 100
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)

    humanoid.StateChanged:Connect(function(_, state)
        if ProtectionEnabled and (state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.FallingDown) then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            humanoid.Health = 100
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if not ProtectionEnabled then return end
        if humanoid.Health < 100 then
            humanoid.Health = 100
        end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.zero
                part.RotVelocity = Vector3.zero
                part.Anchored = false
                part.CanCollide = true
                if part.Name:lower():find("kill") or part.Name:lower():find("damage") then
                    part.CanTouch = false
                    Debris:AddItem(part, 0.1)
                end
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("TouchTransmitter") then
                        child:Destroy()
                    end
                end
            end
        end
    end)

    character.AncestryChanged:Connect(function(_, parent)
        if not parent and ProtectionEnabled then
            notify("The character was damaged and has been remade.")
            LocalPlayer:LoadCharacter()
        end
    end)

    for _, remote in ipairs(character:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            remote:Destroy()
        end
    end
end

local function initProtection()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    protectCharacter(char)
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.25)
        protectCharacter(newChar)
    end)
end

-- F6 
LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key:lower() == KEY_TOGGLE.Name:lower():gsub("keycode%.", "") then
        ProtectionEnabled = not ProtectionEnabled
        notify("Godmode ULTRA++" .. (ProtectionEnabled and "on" or "off"))
    end
end)

initProtection()
notify("Godmode ULTRA++ Start")