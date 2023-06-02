local loadManifest = require("../wally/loadManifest")

local PACKAGES_PATH = "./Packages"

local function createTypes(typesPath: string?)
	local typesFile = typesPath or ".lune/lib/matter/types.luau"
	assert(
		fs.isFile(typesFile),
		`Could not find the Matter types file! \n\tPath: {typesFile}`
	)

	local types = fs.readFile(typesFile)

	local manifest = loadManifest()

	local package = manifest.dependencies.Matter
	assert(package, "wally.toml does not include Matter as a dependency")

	assert(fs.isDir(PACKAGES_PATH), `{PACKAGES_PATH} is not a directory`)

	local moduleName =
		string.lower(`{package.author}_{package.name}@{package.version}`)

	fs.writeFile(`{PACKAGES_PATH}/Matter.lua`, string.format(types, moduleName))
end

return createTypes
