--# selene: allow(incorrect_standard_library_use)
local Project = require("lib/rojo/Project")
local getConfig = require("lib/rbx/getConfig")

local places = process.args

local function deploy(projects: { string })
	for _, name in projects do
		Project.fromName(name):deploy()
	end
end

if #places == 0 then
	deploy(getConfig().build.default)
else
	deploy(places)
end
