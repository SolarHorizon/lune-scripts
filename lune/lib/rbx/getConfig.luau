local mergeDeep = require("../util/mergeDeep")
local locate = require("../util/locateYamlFile")
local serde = require("@lune/serde") :: typeof(serde)

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

--[=[
	@within rbx

	Gets the rbx config from the `rbx.yml` file found in the current directory.
	If one does not exist, it will return a default config.
]=]
local function getConfig(): RbxConfig
	local config = table.clone(default)

	local file = locate("rbx")

	if file then
		local content = fs.readFile(file)
		config = mergeDeep(default, serde.decode("yaml", content))
	end

	return config
end

return getConfig
