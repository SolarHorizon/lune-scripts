--[=[
	@within roblox
	@prop proxy roblox

	A proxy for @lune/roblox which provides types until lune requires are fixed
]=]

type roblox = {
	getAuthCookie: () -> string?,
	readModelFile: (filePath: string) -> { Instance },
	readPlaceFile: (filePath: string) -> DataModel,
	writeModelFile: (filePath: string, instances: { Instance }) -> (),
	writePlaceFile: (filePath: string, dataModel: DataModel) -> (),
	Instance: typeof(Instance),
}

return require("@lune/roblox") :: roblox
