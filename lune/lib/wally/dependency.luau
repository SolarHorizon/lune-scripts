export type Dependency = {
	author: string,
	name: string,
	version: string,
}

local function dependency(str: string): Dependency
	return {
		author = string.match(str, "(.+)/"),
		name = string.match(str, "/(.+)@"),
		version = string.match(str, "@(.+)"),
	}
end

return dependency
