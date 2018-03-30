local component = require("component")
local internet = require("internet")
local fs = require("filesystem")
local shell = require("shell")

local config = {
  ["err_nointnternet"] = "installxaf requires an internet card",
  ["xaf"] = "https://raw.githubusercontent.com/ACSD/OCPrograms/master/gmlcustom/gml.tar",
  ["tar"] = "https://raw.githubusercontent.com/ACSD/OCPrograms/master/gmlcustom/tar.lua"
}
if not component.isAvailable("internet") then io.stderr:write(config.err_nointernet) print("") return end

local curdir = shell.getWorkingDirectory() local tardir = "/usr/lib"
if not fs.exists(tardir) then fs.makeDirectory(tardir) end
if not fs.exists(tardir .. "/xaf.tar") then 
	shell.execute("wget '" .. config.xaf .. "' " .. tardir .. "/gmlcustom.tar", _ENV) 
end
if not fs.exists(tardir .. "/tar.lua") then 
	shell.execute("wget '" .. config.tar .. "' " .. tardir .. "/tar.lua", _ENV) 
end
shell.setWorkingDirectory(tardir)
shell.execute("tar -x -f -v gmlcustom.tar", _ENV)
shell.execute("rm " .. tardir .. "/gmlcustom.tar", _ENV)
shell.execute("rm " .. tardir .. "/tar.lua", _ENV)
shell.setWorkingDirectory(curdir)
