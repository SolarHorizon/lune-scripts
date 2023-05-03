--[=[
	@within util

	Like `fs.removeDir`, except it will not error when the directory doesn't 
	exist.
]=]
local function removeDir(path: string)
	if fs.isDir(path) then
		fs.removeDir(path)
	end
end

return removeDir
