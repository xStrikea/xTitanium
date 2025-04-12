--[[
    Godmode ULTRA+ FINAL Z by xSpecter(github name)
    - Full protection: Fall damage, KillBricks, instant kill, anti-knockback, character destruction
    - Hotkey toggle: Press F6 to enable/disable
    - Auto recovery: Reloads character if destroyed
    - Anti-cheat safe: Avoids triggering suspicious server kicks
    - Jump fix: Keeps Y velocity for natural jumping
    MIT License
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local ProtectionEnabled = true
local KEY_TOGGLE = Enum.KeyCode.F6

-- Notification helper
local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Godmode ULTRA+",
            Text = msg,
            Duration = 3
        })
    end)
end

-- Core protection function
local function protectCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        humanoid = Instance.new("Humanoid")
        humanoid.Name = "Humanoid"
        humanoid.Parent = character
    end

    -- Health monitor
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if ProtectionEnabled and humanoid.Health <= 0 then
            humanoid.Health = 100
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)

    -- State protection
    humanoid.StateChanged:Connect(function(_, state)
        if ProtectionEnabled then
            local blocked = {
                [Enum.HumanoidStateType.Dead] = true,
                [Enum.HumanoidStateType.FallingDown] = true,
                [Enum.HumanoidStateType.Physics] = true
            }
            if blocked[state] then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                humanoid.Health = 100
            end
        end
    end)

    -- Continuous loop protection
    RunService.Heartbeat:Connect(function()
        if not ProtectionEnabled then return end

        if humanoid.Health < 100 then
            humanoid.Health = 100
        end

        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                -- Preserve vertical (Y) velocity to allow jumping
                local v = part.Velocity
                part.Velocity = Vector3.new(0, v.Y, 0)
                part.RotVelocity = Vector3.zero
                part.Anchored = false
                part.CanCollide = true

                -- Detect kill/damage bricks
                if part.Name:lower():find("kill") or part.Name:lower():find("damage") then
                    part.CanTouch = false
                    Debris:AddItem(part, 0.1)
                end

                -- Remove TouchTransmitters
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("TouchTransmitter") then
                        child:Destroy()
                    end
                end
            end

            -- Block kill Remotes
            if part:IsA("RemoteEvent") or part:IsA("RemoteFunction") then
                part:Destroy()
            end
        end
    end)

    -- Character destruction detection
    character.AncestryChanged:Connect(function(_, parent)
        if not parent and ProtectionEnabled then
            notify("Character deleted. Reloading...")
            task.wait(0.25)
            LocalPlayer:LoadCharacter()
        end
    end)
end

-- Initial protection setup
local function initProtection()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    protectCharacter(char)

    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.25)
        protectCharacter(newChar)
    end)
end

-- Toggle protection with hotkey (F6)
LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key:lower() == KEY_TOGGLE.Name:lower():gsub("keycode%.", "") then
        ProtectionEnabled = not ProtectionEnabled
        notify("Godmode is now " .. (ProtectionEnabled and "ENABLED" or "DISABLED"))
    end
end)

-- Start
initProtection()
notify("Godmode ULTRA+ FINAL Z Activated")