local HttpService = game:GetService("HttpService")

local FileAPI = {}
FileAPI.baseURL = "https://api.github.com/repos/xStrikea/xTitanium/contents/script"

function FileAPI.listContents()
    local success, result = pcall(function()
        return HttpService:GetAsync(FileAPI.baseURL)
    end)

    if success then
        local contents = HttpService:JSONDecode(result)
        local items = {}
        for _, item in ipairs(contents) do
            table.insert(items, {name = item.name, type = item.type, url = item.download_url or item.url})
        end
        return items
    else
        warn("API URL ERROR: " .. result)
        return nil
    end
end

function FileAPI.getFile(url)
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        return result
    else
        warn("FILES ERROR: " .. result)
        return nil
    end
end

return FileAPI