type roblox = {
	getAuthCookie: () -> string?,
	readModelFile: (filePath: string) -> { Instance },
	readPlaceFile: (filePath: string) -> DataModel,
	writeModelFile: (filePath: string, instances: { Instance }) -> (),
	writePlaceFile: (filePath: string, dataModel: DataModel) -> (),
}

return require("@lune/roblox") :: roblox
