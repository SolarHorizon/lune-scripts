--# selene: allow(incorrect_standard_library_use)
local createComponent = require("lib/matter/createComponent")

local function parseGroups(groups)
	if groups == "" then
		return {}
	end

	return string.split(groups, " ")
end

if #process.args == 0 then
	local name = stdio.prompt("text", "Enter component name:")

	if fs.isFile(`src/shared/components/{name}.json`) then
		local continue = stdio.prompt(
			"confirm",
			"A component with that name already exists. Overwrite it?"
		)

		if not continue then
			return process.exit(1)
		end
	end

	local replicated =
		stdio.prompt("confirm", "Should this component be replicated?")

	local groups = parseGroups(
		stdio.prompt("text", "Enter component groups (space separated):")
	)

	if replicated then
		table.insert(groups, "replicated")
	end

	return createComponent(name, unpack(groups))
end

createComponent(table.unpack(process.args))
