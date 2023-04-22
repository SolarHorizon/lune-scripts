--# selene: allow(incorrect_standard_library_use)
local Project = require("lib/rojo/Project")
local getConfig = require("lib/rbx/getConfig")

local place = process.args[1]

if place == nil then
	place = getConfig().run.default
end

Project.fromName(place):open()
