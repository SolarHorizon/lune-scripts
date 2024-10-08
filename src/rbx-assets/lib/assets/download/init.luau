local Result = require("@lib/Result")
local request = require("@lib/request/sync")
local withCookie = require("@lib/rbx-api/withCookie")

local gt = require("@pkg/greentea")

local Error = require("../../Error")
local cache = require("../cache")
local rbxDecode = require("./rbxDecode")

local Ok = Result.Ok

export type Place = {
	name: string,
	placeId: number,
	version: number,
}

local function fetch(cookie, place, url, ignoreCache)
	if not ignoreCache then
		local content = cache.get(place.placeId, place.version)

		if content then
			return Ok(content)
		end
	end

	return request({
		url = url,
		method = "GET",
		headers = { Cookie = cookie },
	}):mapErr(function(err)
		return Error.DownloadPlaceError(place.name, tostring(err))
	end)
end

local download = withCookie(
	function(cookie, place: Place, url: string, ignoreCache: boolean?)
		return fetch(cookie, place, url, ignoreCache):andThen(function(body)
			return rbxDecode(body, "place", gt.isA.DataModel()):inspect(
				function()
					cache.put(place.placeId, place.version, body)
				end
			)
		end)
	end
)

return download
