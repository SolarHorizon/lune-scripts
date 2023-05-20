local net = require("@lune/net") :: typeof(net)
local roblox = require("proxy")

--[=[
	@within roblox

	Downloads an asset from the Roblox website
]=]
local function downloadAsset(assetId: number, file: string)
	local cookie = roblox.getAuthCookie()

	if cookie == nil then
		if
			not stdio.prompt(
				"confirm",
				"Could not locate auth cookie in environment. Would you like to continue?"
			)
		then
			process.exit()
		end

		cookie =
			stdio.prompt("text", "Please input your auth cookie to continue.")
	end

	assert(cookie ~= nil, "Failed to get auth cookie")

	local response = net.request({
		url = "https://assetdelivery.roblox.com/v1/asset/",
		headers = {
			["Cookie"] = cookie,
		},
		query = {
			id = tostring(assetId),
		},
	})

	assert(
		response.ok,
		`An error occured while fetching the place file: \n{response.body}`
	)

	fs.writeFile(file, response.body)
end

return downloadAsset
