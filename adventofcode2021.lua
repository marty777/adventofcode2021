-- Advent of Code 2021 in Lua - martin.thorne@gmail.com

require("days/day1")
require("days/day2")
require("days/day3")

function usage()
	print("Usage:")
	print("lua adventofcode2021.lua [DAY] [INPUT FILE PATH]")
end

-- just accepts 0 - 15 for standard and bright forground text colorCode
-- anything outside that range produces a reset code
function colorCode(number)
	local escape = string.char(27, 91)
	if number < 0 or number > 15 then 
		return escape .. 'm'
	else 
		return escape .. "38;5;" .. number .. 'm'
	end
end

function readLines(path)
	local lines = {}
	local i = 1
	for line in io.lines(path) do 
		lines[i] = line
		i = i + 1
	end
	return lines
end

function header(day)
	print('----------------------------------------------------------------------------')
	print([[    _      _             _          __    ___         _       ___ __ ___ _ 
   /_\  __| |_ _____ _ _| |_   ___ / _|  / __|___  __| |___  |_  )  \_  ) |
  / _ \/ _` \ V / -_) ' \  _| / _ \  _| | (__/ _ \/ _` / -_)  / / () / /| |
 /_/ \_\__,_|\_/\___|_||_\__| \___/_|    \___\___/\__,_\___| /___\__/___|_|
                                                                           ]])
	print(string.format("----------------------------------- DAY %d ---------------------------------"..(day < 10 and '-' or ''), day))
end


local MAXDAY = 3
local days = {}
days[1] = day1
days[2] = day2
days[3] = day3

if #arg < 2 then
	print(#arg)
	usage()
	os.exit()
end

local day = tonumber(arg[1]) 
if day == null then
	usage()
	os.exit()
end
local path = arg[2]

if (day) > MAXDAY then
	usage()
	os.exit()
end

-- test if data file exists at path
local f = io.open(path,"r")
if f == null then
	usage()
	os.exit()
else 
	io.close(f)
	header(day)
	start = os.clock()
	days[day](path)
	finish = os.clock()
	print(string.format("Elapsed time: %.2f ms", (finish - start)*1000))
end
