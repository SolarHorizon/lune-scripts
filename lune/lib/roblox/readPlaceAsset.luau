local downloadAsset = require("downloadAsset")
local fs = require("@lune/fs") :: typeof(fs)
local roblox = require("proxy")

--[=[
	@within roblox

	Reads a place file from the Roblox website
]=]
local function readPlaceAsset(placeId: number, file: string): DataModel
	downloadAsset(placeId, file)

	local dataModel = roblox.readPlaceFile(file)

	fs.removeFile(file)

	return dataModel
end

return readPlaceAsset
