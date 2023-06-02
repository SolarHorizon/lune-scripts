local function copyDeep<T>(dictionary: T): T
	local new = {}

	for key, value in dictionary :: any do
		if type(value) == "table" then
			new[key] = copyDeep(value)
		else
			new[key] = value
		end
	end

	return new :: any
end

return copyDeep
