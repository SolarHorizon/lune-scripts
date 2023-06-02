local function getFileName(path: string)
	local segments = string.split(path, "/")
	table.remove(segments, #segments)
	return table.concat(segments, "/")
end

return getFileName
