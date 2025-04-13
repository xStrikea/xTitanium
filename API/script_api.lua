local HttpService = game:GetService("HttpService")

local FileAPI = {}
FileAPI.baseURL = "https://api.github.com/repos/xStrikea/xTitanium/contents/script"

local function loadEnv()
    local envVariables = {}
    local envFile = io.open(".env", "r")

    if not envFile then
        warn(".env files error")
        return nil
    end

    for line in envFile:lines() do
        local key, value = line:match("(%w+)=(.+)")
        if key and value then
            envVariables[key] = value
        end
    end

    envFile:close()
    return envVariables
end

local env = loadEnv()
local token = env and env.API_TOKEN

function FileAPI.listContents(folderURL)
    folderURL = folderURL or FileAPI.baseURL
    local headers = {}
    if token then
        headers["Authorization"] = "token " .. token
    end

    local success, result = pcall(function()
        return HttpService:GetAsync(folderURL, Enum.HttpRequestType.GET, headers)
    end)

    if success then
        local contents = HttpService:JSONDecode(result)
        local items = {}
        for _, item in ipairs(contents) do
            table.insert(items, {name = item.name, type = item.type, url = item.download_url or item.url})
            if item.type == "dir" then
                local subItems = FileAPI.listContents(item.url)
                for _, subItem in ipairs(subItems) do
                    table.insert(items, subItem)
                end
            end
        end
        return items
    else
        warn("API URL ERROR: " .. result)
        return nil
    end
end

function FileAPI.getFile(url)
    local headers = {}
    if token then
        headers["Authorization"] = "token " .. token
    end

    local success, result = pcall(function()
        return HttpService:GetAsync(url, Enum.HttpRequestType.GET, headers)
    end)

    if success then
        return result
    else
        warn("FILES ERROR: " .. result)
        return nil
    end
end

return FileAPI
