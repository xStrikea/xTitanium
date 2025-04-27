-- --A URLs Code:
-- loadstring(game:HttpGet(''))()
--
-- web.get{url = "https://example.com/script.lua"}

-- --Multiple URLs
-- loadstring(game:HttpGet(''))()
--
-- web.get{
-- "https://example.com/script1.lua",
-- "https://example.com/script2.lua",
-- "https://example.com/script3.lua"
--}


web = {}

function web.get(args)
    assert(args, "[web.get] Missing arguments")

    if type(args.url) == "string" then
        -- A URL
        return loadstring(game:HttpGet(args.url))()
    elseif type(args) == "table" then
        -- Multiple URLs
        for _, url in ipairs(args) do
            loadstring(game:HttpGet(url))()
        end
    else
        error("[web.get] Invalid arguments")
    end
end

