local downloadAsset = require("downloadAsset")
local fs = require("@lune/fs") :: typeof(fs)
local roblox = require("proxy")

--[=[
	@within roblox

	Reads a place file from the Roblox website
]=]
local function readPlaceAsset(placeId: number, path: string?): DataModel
	local file = "temp.rbxl"

	if path then
		file = path
	end

	local ok = false
	local dataModel: DataModel

	repeat
		downloadAsset(placeId, file)
		ok, dataModel = pcall(roblox.readPlaceFile, file)
	until ok

	if path == nil then
		fs.removeFile(file)
	end

	return dataModel
end

return readPlaceAsset
