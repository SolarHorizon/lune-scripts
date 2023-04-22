--# selene: allow(incorrect_standard_library_use)
local Project = require("lib/rojo/Project")
local getConfig = require("lib/rbx/getConfig")

local places = process.args

local function build(projects: { string })
	for _, name in projects do
		Project.fromName(name):build()
	end
end

if #places == 0 then
	build(getConfig().build.default)
else
	build(places)
end
