-- Anti-Kick Patch
local mt = getrawmetatable(game)
if setreadonly then setreadonly(mt, false) end
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if tostring(self) == "Kick" or method == "Kick" then
        warn("[Anti-Kick] Kick attempt blocked!")
        return
    end
    return oldNamecall(self, ...)
end)
if setreadonly then setreadonly(mt, true) end
warn("[Anti-Kick] Patch applied.")