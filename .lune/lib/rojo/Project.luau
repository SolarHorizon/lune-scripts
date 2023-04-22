--# selene: allow(incorrect_standard_library_use)
local GAME_API = "https://api.roblox.com/universes"

local roblox = require("@lune/roblox") :: any

local makeDirAll = require("../util/makeDirAll")
local getProjectName = require("getProjectName")
local open = require("../util/open")
local loadManifest = require("manifest/load")

type ProjectType = "place" | "model"
type BuildFormat = "binary" | "xml"

type ProjectImpl = {
	__index: ProjectImpl,
	fromFile: (filePath: string) -> Project,
	fromName: (filePath: string) -> Project,
	build: (self: Project, format: BuildFormat?) -> string,
	deploy: (self: Project) -> (),
	load: (self: Project) -> Instance,
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

local Project = {} :: ProjectImpl
Project.__index = Project

function Project.fromFile(file)
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

function Project.fromName(name)
	return Project.fromFile(`{process.cwd}/{name}.project.json`)
end

function Project:build(format)
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

function Project:open()
	assert(
		self.type == "place",
		`Could not open "{self.name}" because it is a model.`
	)
	open(self:build())
end

function Project:load(): DataModel | Instance
	local file = self:build()

	return if self.type == "place"
		then roblox.readPlaceFile(file) :: DataModel
		else roblox.readModelFile(file) :: Instance
end

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
		url = `{GAME_API}/v1/{self.gameId}/places/{self.placeId}/versions`,
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
