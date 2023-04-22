--# selene: allow(incorrect_standard_library_use)
local serde = require("@lune/serde") :: any

local function createComponent(name: string, ...: string)
	print("create:", name)

	name = string.gsub(name, "^%l", string.upper)

	local groups = { ... }
	local content = {}

	if #groups > 0 then
		for i, groupName in groups do
			groups[i] = string.lower(groupName)
		end

		content.groups = groups
	end

	print(`Creating component {name}...`)

	fs.writeFile(
		`src/shared/components/{name}.json`,
		serde.encode("json", content)
	)
end

return createComponent
