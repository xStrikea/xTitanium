local FileAPI = require(Your_ModuleScript_location)

local contents = FileAPI.listContents()
if contents then
    for _, item in ipairs(contents) do
        print("Name: " .. item.name .. ", Type: " .. item.type .. ", URL: " .. item.url)
    end
end

local fileURL = "RAW URL of the file"
local fileContent = FileAPI.getFile(fileURL)
if fileContent then
    print("Document content: " .. fileContent)
end