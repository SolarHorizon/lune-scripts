--[=[
	@within util
]=]
local function getFileName(path: string): string
	local segments = string.split(path, "/")
	return segments[#segments]
end

return getFileName
