local roblox = require("@lune/roblox")

local instance = require("../std/instance")

type Options = {
	exclude: instance.FilterOptions,
}

local function workspaceAndLighting(game: roblox.DataModel, options: Options?)
	local filter =
		instance.createFilter(if options then options.exclude else nil)

	return {
		Workspace = filter(game:GetService("Workspace")),
		Lighting = filter(game:GetService("Lighting")),
	}
end

return workspaceAndLighting
