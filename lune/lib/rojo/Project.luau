--# selene: allow(incorrect_standard_library_use)
local roblox = require("@lune/roblox") :: any

local makeDirAll = require("../util/makeDirAll")
local getProjectName = require("getProjectName")
local open = require("../util/open")
local loadManifest = require("loadManifest")

--[=[
	@within rojo
	@prop Project Project
]=]

--[=[
	@within Project
	@type ProjectType "place" | "model"
]=]
type ProjectType = "place" | "model"

--[=[
	@within Project
	@type BuildFormat "binary" | "xml"
]=]
type BuildFormat = "binary" | "xml"

type ProjectImpl = {
	__index: ProjectImpl,
	fromFile: (filePath: string) -> Project,
	fromName: (filePath: string) -> Project,
	build: (self: Project, format: BuildFormat?) -> string,
	deploy: (self: Project) -> (),
	load: (self: Project) -> unknown,
	open: (self: Project) -> (),
}

export type Project = typeof(setmetatable(
	{} :: {
		path: string,
		name: string,
		type: ProjectType,
		gameId: number?,
		placeId: number?,
	},
	{} :: ProjectImpl
))

--[=[
	@within Project
	@prop path string
]=]

--[=[
	@within Project
	@prop name string
]=]

--[=[
	@within Project
	@prop type ProjectType
]=]

--[=[
	@within Project
	@prop gameId number?
]=]

--[=[
	@within Project
	@prop placeId number?
]=]

--[=[
	@class Project

	```lua
	local Project = require("lib/rojo/Project")
	```
]=]
local Project = {} :: ProjectImpl
Project.__index = Project

--[=[
	@within Project
]=]
function Project.fromFile(file: string): Project
	local manifest = loadManifest(file)
	local className = manifest.tree["$className"]

	local self = {
		name = getProjectName(file) :: string,
		gameId = manifest.gameId,
		placeId = manifest.placeId,
		path = file,
		type = (
				if className == "DataModel" then "place" else "model"
			) :: ProjectType,
	}

	if self.type == "place" then
		self.placeId = manifest.placeId
		self.gameId = manifest.gameId
	end

	return setmetatable(self, Project)
end

--[=[
	@within Project
]=]
function Project.fromName(name: string): Project
	return Project.fromFile(`{process.cwd}/{name}.project.json`)
end

--[=[
	@within Project
]=]
function Project:build(format: BuildFormat?): string
	local extension = if self.type == "model" then "rbxm" else "rbxl"

	if format == "xml" then
		extension = extension .. "x"
	end

	local output = `{process.cwd}/build/{self.name}.{extension}`

	makeDirAll(output)

	local result = process.spawn("rojo", {
		"build",
		self.path,
		"--output",
		output,
	})

	assert(
		result.ok,
		`An error occured while building the project.\n{result.stderr}`
	)

	if result.stdout then
		print(result.stdout)
	end

	return output
end

--[=[
	@within Project
]=]
function Project:open()
	assert(
		self.type == "place",
		`Could not open "{self.name}" because it is a model.`
	)
	open(self:build())
end

--[=[
	@within Project
	@method load
]=]
function Project:load(): unknown
	local file = self:build()

	if self.type == "place" then
		return roblox.readPlaceFile(file)
	end

	local instance = roblox.readModelFile(file)

	assert(
		#instance < 2,
		`Model file for project {self.name} has more than one root instance.`
	)
	assert(
		#instance > 0,
		`Model file for project {self.name} has more than one root instance.`
	)

	return instance[1]
end

--[=[
	@within Project
]=]
function Project:deploy()
	assert(
		self.type == "place",
		`Could not deploy "{self.name}" because it is a model.`
	)
	assert(
		self.gameId ~= nil,
		`Could not deploy "{self.name}" because it does not have a gameId.`
	)
	assert(
		self.placeId ~= nil,
		`Could not deploy "{self.name}" because it does not have a placeId.`
	)

	local file = self:build()

	local response = net.request({
		url = `https://api.roblox.com/universes/v1/{self.gameId}/places/{self.placeId}/versions`,
		headers = {
			["x-api-key"] = process.env.DEPLOY_KEY,
			["Content-Type"] = "application/octet-stream",
		},
		query = {
			versionType = "Published",
		},
		body = file,
	})

	if not response.ok then
		print(`An error occured while deploying {self.name}`)
		print(response)
	end
end

return Project
