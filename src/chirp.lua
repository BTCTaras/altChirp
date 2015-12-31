local bgc = term.getBackgroundColour()
local tc = term.getTextColour()

local w, h = term.getSize()

local function display(lines)
	term.setBackgroundColour(colours.white)
	term.clear()

	for i, v in ipairs(lines) do
		local x = v.x and v.x or (w - #v.text) / 2 + 1
		local y = ((h - #lines) / 2) + i

		term.setCursorPos(x, y)
		term.setTextColour(v.colour)
		write(v.text)
	end
end

local function main()
	error("SHIT")
end

local success, message = pcall(main)

if not success then
	local lines = {
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.red,
			text	= "Fatal Error"
		},
		{
			colour 	= colours.red,
			text	= string.rep(string.char(175), #"Fatal Error")
		},
		{
			colour 	= colours.white,
			text	= ""
		},
		{
			colour 	= colours.red,
			text	= message,
			x		= 1
		},
		{
			colour 	= colours.white,
			text	= ""
		},
		{
			colour 	= colours.white,
			text	= ""
		},
		{
			colour 	= colours.white,
			text	= ""
		},
		{
			colour 	= colours.white,
			text	= ""
		}
	}
	
	display(lines)

	local bottomText = "Press any key to continue..."
	term.setCursorPos((w - #bottomText) / 2 + 1, h)
	term.setTextColour(colours.lightGrey)
	write(bottomText)
	read("")
	term.setBackgroundColour(bgc)
	term.setTextColour(tc)
	term.setCursorPos(1, 1)
	term.clear()
end