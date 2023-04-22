local None = require("None")

local function mergeDeep(...: any)
	local new = {}

	for index = 1, select("#", ...) do
		local tbl = select(index, ...)

		if tbl ~= nil then
			assert(
				typeof(tbl) == "table",
				`mergeDeep can only be used on tables. Got {typeof(tbl)} at index {index}`
			)

			for key, value in tbl do
				if value == None then
					new[key] = nil
				else
					new[key] = value
				end
			end
		end
	end
end

return mergeDeep
