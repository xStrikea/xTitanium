local HttpService = game:GetService("HttpService")

local FileAPI = {}
FileAPI.baseURL = "https://api.github.com/repos/xStrikea/xTitanium/contents/script"

function FileAPI.listContents(folderURL)
    folderURL = folderURL or FileAPI.baseURL
    local success, result = pcall(function()
        return HttpService:GetAsync(folderURL)
    end)

    if success then
        local contents = HttpService:JSONDecode(result)
        local items = {}
        for _, item in ipairs(contents) do
            table.insert(items, {name = item.name, type = item.type, url = item.download_url or item.url})
            if item.type == "dir" then
                -- 遞歸檢索子文件夾
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