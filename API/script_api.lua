local HttpService = game:GetService("HttpService")

local FileAPI = {}
FileAPI.baseURL = "https://api.github.com/repos/xStrikea/xTitanium/contents/script"
FileAPI._cache = {}
FileAPI._env = nil

local function loadEnv()
    local envVariables = {}
    local envFile = io.open("../.env", "r")

    if not envFile then
        warn("[FileAPI]:.env error")
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

local function getToken()
    return FileAPI._env and FileAPI._env.API_TOKEN
end

function FileAPI.reloadEnv()
    FileAPI._env = loadEnv()
    FileAPI._cache = {} 
end

local function hasValidExtension(filename, extensions)
    if not extensions then return true end
    for _, ext in ipairs(extensions) do
        if filename:lower():match("%." .. ext:lower() .. "$") then
            return true
        end
    end
    return false
end

-- 遞迴列出 GitHub 內容
function FileAPI.listContents(folderURL, recursive, extensions, filesOnly, maxDepth, currentDepth, useCache)
    folderURL = folderURL or FileAPI.baseURL
    recursive = recursive ~= false
    filesOnly = filesOnly or false
    maxDepth = maxDepth or math.huge
    currentDepth = currentDepth or 1
    useCache = useCache ~= false

    if useCache and FileAPI._cache[folderURL] then
        return FileAPI._cache[folderURL]
    end

    local headers = {}
    local token = getToken()
    if token then
        headers["Authorization"] = "token " .. token
    end

    local success, result = pcall(function()
        return HttpService:GetAsync(folderURL, Enum.HttpRequestType.GET, headers)
    end)

    if not success then
        warn("[FileAPI]:error " .. result)
        return nil
    end

    local contents = HttpService:JSONDecode(result)
    local items = {}

    for _, item in ipairs(contents) do
        local isFile = item.type == "file"
        local isDir = item.type == "dir"

        if isFile and hasValidExtension(item.name, extensions) then
            table.insert(items, {
                name = item.name,
                type = "file",
                url = item.download_url,
            })
        elseif isDir and recursive and currentDepth < maxDepth then
            local subItems = FileAPI.listContents(item.url, recursive, extensions, filesOnly, maxDepth, currentDepth + 1, useCache)
            if subItems then
                for _, subItem in ipairs(subItems) do
                    table.insert(items, subItem)
                end
            end
        elseif not filesOnly and not extensions then
            table.insert(items, {
                name = item.name,
                type = item.type,
                url = item.download_url or item.url,
            })
        end
    end

    if useCache then
        FileAPI._cache[folderURL] = items
    end

    return items
end

function FileAPI.getFile(url, useCache)
    useCache = useCache ~= false

    if useCache and FileAPI._cache[url] then
        return FileAPI._cache[url]
    end

    local headers = {}
    local token = getToken()
    if token then
        headers["Authorization"] = "token " .. token
    end

    local success, result = pcall(function()
        return HttpService:GetAsync(url, Enum.HttpRequestType.GET, headers)
    end)

    if not success then
        warn("[FileAPI]:error" .. result)
        return nil
    end

    if useCache then
        FileAPI._cache[url] = result
    end

    return result
end

return FileAPI