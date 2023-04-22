local openers = {
	linux = { cmd = "xdg-open" },
	macos = { cmd = "open" },
	windows = { cmd = "pwsh", "-c", "Start-Process" },
}

local function open(file: string)
	local opener = openers[process.os]

	if process.env.OPENER then
		opener = { cmd = process.env.OPENER }
	end

	return process.spawn(opener.cmd, { table.unpack(opener, 2), file })
end

return open
