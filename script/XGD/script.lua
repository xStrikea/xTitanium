local baseURL = "https://raw.githubusercontent.com/xStrikea/xTitanium/refs/heads/main/patch/XGD/"
local patches = {
    "antick.lua",
    "antideath.lua",
    "antifall.lua",
    "antifly.lua",
    "antinextbot.lua",
    "autofixhumanoid.lua",
    "autoheal.lua"
}

for _, file in ipairs(patches) do
    local url = baseURL .. file
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        warn("[Godmode Loader] Loaded: " .. file)
    else
        warn("[Godmode Loader] Failed to load: " .. file .. "\nReason: " .. tostring(result))
    end
end

warn("[Godmode Loader] All patches attempted.")