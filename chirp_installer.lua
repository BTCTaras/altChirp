-- Chirp Installer
-- By Lemmmy

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

local function run()
	display({	
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.lightBlue,
			text	= string.rep(string.char(175), #"Chirp")
		},
		{
			colour 	= colours.grey,
			text	= "Preparing installer..."
		},
	})

	if fs.exists("chirp") or fs.exists("chirp.temp") or (fs.exists("chirp.d/") and fs.isDir("chirp.d/")) then
		display({	
			{
				colour 	= colours.lightBlue,
				text	= "Chirp"
			},
			{
				colour 	= colours.lightBlue,
				text	= string.rep(string.char(175), #"Chirp")
			},
			{
				colour 	= colours.grey,
				text	= "An existing Chirp installation"
			},
			{
				colour 	= colours.grey,
				text	= "has been found."
			},
			{
				colour 	= colours.grey,
				text	= ""
			},
			{
				colour 	= colours.grey,
				text	= "Remove it? y/n"
			},
			{
				colour 	= colours.grey,
				text	= ""
			},
		})

		local input = read()

		if input:lower() == "y" then
			fs.delete("chirp")
			fs.delete("chirp.temp")
			fs.delete("chirp/")
		else 
			term.setCursorPos(1, 1)
			term.setBackgroundColour(bgc)
			term.clear()
			term.setTextColour(colours.red)
			write("Chirp installation aborted.")
			term.setTextColour(tc)
			print("\n")

			return
		end
	end

	display({	
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.lightBlue,
			text	= string.rep(string.char(175), #"Chirp")
		},
		{
			colour 	= colours.grey,
			text	= "Contacting server..."
		},
	})

	local success, message = http.checkURL("http://chirp.lemmmy.pw")

	if not success then
		error("Error contacting Chirp servers.\n\nError: " .. message)
	end

	display({	
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.lightBlue,
			text	= string.rep(string.char(175), #"Chirp")
		},
		{
			colour 	= colours.grey,
			text	= "Downloading Chirp..."
		},
	})

	local downloader = http.get("http://chirp.lemmmy.pw/download/chirp")

	if not downloader then
		error("Failed to download Chirp.")
	end

	local tempFile = fs.open("chirp.temp", "w")

	tempFile.write(downloader.readAll())
	tempFile.close()

	display({	
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.lightBlue,
			text	= string.rep(string.char(175), #"Chirp")
		},
		{
			colour 	= colours.grey,
			text	= "Installing Chirp..."
		},
	})

	local launcherCode = "shell.run(\"./chirp.d/chirp.lua\")"
	local launcherFile = fs.open("./chirp", "w")

	launcherFile.write(launcherCode)
	launcherFile.close()

	shell.run("chirp.temp", "./chirp.d/")

	display({	
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.lightBlue,
			text	= string.rep(string.char(175), #"Chirp")
		},
		{
			colour 	= colours.grey,
			text	= "Cleaning up..."
		},
	})

	fs.delete("chirp.temp")

	term.setCursorPos(1, 1)
	term.setBackgroundColour(bgc)
	term.clear()
	term.setTextColour(tc)
	write("Thanks for installing Chirp! You can now run it using the ")
	term.setTextColour(colours.yellow)
	write("chirp")
	term.setTextColour(tc)
	print(" command.")
	print("")
end

local status, message = pcall(run)

if not status then
	term.setBackgroundColour(colours.white)
	term.clear()

	local lines = {
		{
			colour 	= colours.lightBlue,
			text	= "Chirp"
		},
		{
			colour 	= colours.red,
			text	= "Install Error"
		},
		{
			colour 	= colours.red,
			text	= string.rep(string.char(175), #"Install Error")
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
end