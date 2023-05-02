--[=[
	@within util
]=]
local function eprint(...: any)
	local args = { ... }

	for i, arg in args do
		args[i] = stdio.format(arg)
	end

	stdio.ewrite(stdio.color("red"))

	for _, arg in args do
		stdio.ewrite(`	{arg}`)
	end

	stdio.ewrite(`{stdio.color("reset")}\n`)
end

return eprint
