local function locateYamlFile(name: string): string?
	local extensions = { "yaml", "yml" }

	for _, ext in extensions do
		local location = `{process.cwd}/{name}.{ext}`

		if fs.isFile(location) then
			return location
		end
	end

	return nil
end

return locateYamlFile
