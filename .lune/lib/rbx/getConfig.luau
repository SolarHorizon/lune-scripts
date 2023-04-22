local mergeDeep = require("../util/mergeDeep")
local locate = require("../util/locateYamlFile")

export type RbxConfig = {
	build: { default: { string } },
	run: { default: string },
}

local default = {
	build = {
		default = {
			"default",
		},
	},
	run = {
		default = "default",
	},
	-- test = {
	-- 	port = 25428,
	-- 	roots = {
	-- 		"ReplicatedStorage",
	-- 		"ServerStorage",
	-- 	},
	-- },
}

local function getConfig(): RbxConfig
	local config = table.clone(default)

	local file = locate("rbx")

	if file then
		config = mergeDeep(default, fs.readFile(file))
	end

	return config
end

return getConfig
