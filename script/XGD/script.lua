local patches = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
}

for _, url in ipairs(patches) do
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
end

warn("[Godmode Loader] All patches have been loaded.")