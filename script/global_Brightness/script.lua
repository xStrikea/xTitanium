local Lighting = game:GetService("Lighting")

local originalSettings = {
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
}

_G.__bright_enabled = true
_G.__bright_multiplier = 1.5

local brightSettings = {
	Ambient = Color3.new(1, 1, 1),
	OutdoorAmbient = Color3.new(1, 1, 1),
	Brightness = 5
}

local function applyBrightness()
	if _G.__bright_enabled then
		Lighting.Ambient = brightSettings.Ambient * _G.__bright_multiplier
		Lighting.OutdoorAmbient = brightSettings.OutdoorAmbient * _G.__bright_multiplier
		Lighting.Brightness = brightSettings.Brightness * _G.__bright_multiplier
	else
		Lighting.Ambient = originalSettings.Ambient
		Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
		Lighting.Brightness = originalSettings.Brightness
	end
end

_G.SetBrightness = function(multiplier)
	_G.__bright_multiplier = multiplier
	applyBrightness()
end

_G.SetEnabled = function(enabled)
	_G.__bright_enabled = enabled
	applyBrightness()
end

applyBrightness()