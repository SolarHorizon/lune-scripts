local function getFileName(path: string)
	local segments = string.split(path, "/")
	return segments[#segments]
end

return getFileName
