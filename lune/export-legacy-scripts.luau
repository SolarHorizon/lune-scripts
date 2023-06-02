--# selene:allow(incorrect_standard_library_use)
local readPlaceAsset = require("lib/roblox/readPlaceAsset")
local makeDirAll = require("lib/util/makeDirAll")
local getParentDir = require("lib/util/getParentDir")
local roblox = require("lib/roblox/proxy")

local SCRIPT_FILE_EXT = "luau"

local function sanitizeForPath(path: string): string
	return string.gsub(string.gsub(path, "%.", "/"), "[^%w_/]", "_")
end

local function hasScriptDescendant(instance: Instance): boolean
	for _, v in instance:GetDescendants() do
		if v:IsA("LuaSourceContainer") then
			return true
		end
	end

	return false
end

local function exportLegacyScripts(placeIdOrPath: number | string)
	local game: DataModel

	if typeof(placeIdOrPath) == "number" then
		print("Downloading place asset...")
		game = readPlaceAsset(placeIdOrPath)
	else
		print("Reading from file...")
		game = roblox.readPlaceFile(placeIdOrPath)
	end

	local usedNames = {}
	local rootPath = `legacy-export/{game.Name}`

	makeDirAll(rootPath)

	print("Beginning export...")

	for _, v in game:GetDescendants() do
		if v:IsA("LuaSourceContainer") then
			local path = `{rootPath}/{sanitizeForPath(v:GetFullName())}`

			if usedNames[path] then
				usedNames[path] += 1
				path = `{path}_{usedNames[path]}`
			else
				usedNames[path] = 1
			end

			if hasScriptDescendant(v) then
				path = `{path}/init`
			end

			if v:IsA("Script") then
				if v:IsA("LocalScript") then
					path = `{path}.client`
				else
					path = `{path}.server`
				end
			elseif not v:IsA("ModuleScript") then
				print(`Skipping {v.ClassName} "{v.Name}"`)
				return
			end

			path = `{path}.{SCRIPT_FILE_EXT}`

			print(`Exporting {v.ClassName} "{v.Name}"...\n\tLocation:{path}`)

			makeDirAll(getParentDir(path))
			fs.writeFile(path, v.Source)
		end
	end
end

assert(process.args[1], "export-legacy-scripts requires a path or place ID")

if process.args[1] then
	local placeId = tonumber(process.args[1])
	exportLegacyScripts(placeId or process.args[1])
end
