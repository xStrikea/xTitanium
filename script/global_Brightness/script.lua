local Lighting = game:GetService("Lighting")

Lighting.TimeOfDay = "14:00:00"
Lighting.ClockTime = 14
Lighting:SetMinutesAfterMidnight(14 * 60) 
Lighting.ClockTime = 14
Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
    Lighting.ClockTime = 14
end)

Lighting.Brightness = 3
Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
Lighting.Ambient = Color3.fromRGB(255, 255, 255)
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1

-- 停用霧效果
Lighting.FogStart = 1e6
Lighting.FogEnd = 1e7
Lighting.FogColor = Color3.fromRGB(255, 255, 255)

if Lighting.Technology ~= Enum.Technology.Future then
    Lighting.Technology = Enum.Technology.Future
end

Lighting.GlobalShadows = false