local net = require("@lune/net") :: typeof(net)
local roblox = require("proxy")

--[=[
	@within roblox

	Downloads an asset from the Roblox website
]=]
local function downloadAsset(assetId: number, file: string)
	local cookie = roblox.getAuthCookie()

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
