local loadManifest = require("../wally/loadManifest")

local function createTypes(manifestPath: string?, packagesPath: string?)
	local types = fs.readFile(".lune/lib/matter/types.luau")

	local manifest = loadManifest(manifestPath)

	local package = manifest.dependencies.Matter
	assert(package, "wally.toml does not include Matter as a dependency")

	local packages = packagesPath or "./Packages"
	assert(fs.isDir(packages), `{packagesPath} is not a directory`)

	local moduleName =
		string.lower(`{package.author}_{package.name}@{package.version}`)

	local requireLine =
		`return require(script.Parent._Index["{moduleName}"]["matter"])`

	fs.writeFile(`{packages}/Matter.lua`, `{types}\n{requireLine}`)
end

return createTypes
