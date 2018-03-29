local git = {}
if not require("component").isAvailable("internet") then io.stderr:write("gitprimitive requires an internet card to run.") return end
local internet = require("internet")
--[[function git:contents(repo,dir)
    print("fetching contents for "..repo..dir)
    local url="https://api.github.com/repos/"..repo.."/contents"..dir
    local result,response=pcall(internet.request,url)
    local raw="" local files={} local directories={}

    if result then for chunk in response do raw=raw..chunk end
    else error("you've been cut off. Serves you right.") end

    response=nil raw=raw:gsub("%[","{"):gsub("%]","}"):gsub("(\".-\"):(.-[,{}])",function(a,b) return "["..a.."]="..b end)
    local t=load("return "..raw)()

    for i=1,#t do
        if t[i].type=="dir" then
            table.insert(directories,dir.."/"..t[i].name)

            local subfiles,subdirs=git:contents(repo,dir.."/"..t[i].name)
            for i=1,#subfiles do table.insert(files,subfiles[i]) end
            for i=1,#subdirs do table.insert(directories,subdirs[i]) end
        else files[#files+1]=dir.."/"..t[i].name end
    end return files, directories
end TODO --]]

function git:raw(repo, file)
    return "https://raw.githubusercontent.com/"..repo.."/master"..file
end

function git:download(repo, file, target) print("downloading " .. file .. " from " .. repo)
    local url=git:raw(repo, file) print("url is ", url) --TODO remove debug print
    local result,response=pcall(internet.request,url) if result then
        local raw="" for chunk in response do raw=raw..chunk end
        print("writing to "..target)
        local fout=io.open(target,"w") fout:write(raw) fout:close()
    else print("failed, skipping") end
end

function git:loadmanifest(manifest, i)
    local files = {} local directories = {}
    if type(manifest) == "table" then
        for k, v in pairs(manifest) do
            if type(v) == "string" then files[#files + 1] = i .. "/" .. v end
            if type(v) == "table" then 
                directories[#directories + 1 ] = i .. "/" .. k
                for _, f in pairs(git:loadmanifest(v, i .. "/" .. k)) do 
                    files[#files + 1] = f
                end 
            end
        end
    end
    return files, directories
end

return git
