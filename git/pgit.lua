local git = {}

function git:contents(repo,dir)
    if not require("component").isAvailable("internet") then io.stderr:write("gitprimitive requires an internet card to run.") return end
    local internet = require("internet")
    
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
end
function git:download(repo, file) print("downloading "..file)
    local url="https://raw.github.com/"..repo.."/master"..file
    local result,response=pcall(internet.request,url) if result then
        local raw="" for chunk in response do raw=raw..chunk end
        print("writing to "..target..files[i])
        local fout=io.open(target..files[i],"w")
        fout:write(raw) fout:close()
    else print("failed, skipping") end
end
function git:load(manifest, i)
    if type(manifest) == "table" then
        for k, v in pairs(manifest) do
            print(i, k, type(k), v, type(v))
            if type(v) == "table" then
                git:load(v, i .. "    ")
            end
                        
        end
    end
end
return git
