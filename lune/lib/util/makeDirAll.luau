--[=[
	@within util
]=]
local function makeDirAll(path: string)
	print(`Creating new directory: {path}`)

	local segments = string.split(path, "/")
	local dir = process.cwd

	for _, segment in segments do
		local nextDir = `{dir}/{segment}`

		if not fs.isDir(nextDir) then
			fs.writeDir(nextDir)
		end

		dir = nextDir
	end
end

return makeDirAll
