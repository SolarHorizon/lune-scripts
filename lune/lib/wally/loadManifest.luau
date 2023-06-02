local serde = require("@lune/serde") :: typeof(serde)
local dependency = require("dependency")

--local manifest = serde.decode("toml", fs.readFile(manifestPath or MANIFEST))
--local dependency = manifest.dependencies.Matter

--local author = string.match(dependency, "^[^/]+")
--local package = string.match(dependency, "")

--local version = string.match(dependency, "@[%S]+$")

export type Dependency = dependency.Dependency

-- TODO: SemVer class
type SemVer = string

type Package<Version> = {
	authors: { string },
	description: string,
	exclude: { string },
	include: { string },
	license: string,
	name: string,
	realm: "server" | "shared" | "dev",
	registry: string,
	version: Version,
}

type Place = { ["shared-packages"]: string }

type RawManifest = {
	package: Package<string>,
	place: Place,
	dependencies: { [string]: string },
}

export type Manifest = {
	package: Package<SemVer>,
	place: Place,
	dependencies: { [string]: Dependency? },
}

local function loadManifest(path: string?): Manifest
	local content: RawManifest =
		serde.decode("toml", fs.readFile(path or "./wally.toml"))

	local manifest = {
		package = content.package,
		place = content.place,
		dependencies = {},
	}

	for name, dep in content.dependencies do
		local resolved = dependency(dep)
		assert(resolved, `Could not resolve dependency: {dep}`)
		manifest.dependencies[name] = resolved
	end

	return manifest
end

return loadManifest
