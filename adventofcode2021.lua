-- Advent of Code 2021 in Lua - martin.thorne@gmail.com

require("days/day1")
require("days/day2")
require("days/day3")
require("days/day4")
require("days/day5")
require("days/day6")
require("days/day7")
require("days/day8")
require("days/day9")
require("days/day10")
require("days/day11")
require("days/day12")
require("days/day13")
require("days/day14")
require("days/day15")
require("days/day16")
require("days/day17")
require("days/day18")
require("days/day19")
require("days/day20")
require("days/day21")
require("days/day22")
require("days/day23")
require("days/day24")
require("days/day25")

function usage(maxday)
	print("Usage:")
	print("lua adventofcode2021.lua [DAY] [INPUT FILE PATH]")
	print(string.format("Available days: 1-%d",maxday))
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

local days = {}
days[1] = day1
days[2] = day2
days[3] = day3
days[4] = day4
days[5] = day5
days[6] = day6
days[7] = day7
days[8] = day8
days[9] = day9
days[10] = day10
days[11] = day11
days[12] = day12
days[13] = day13
days[14] = day14
days[15] = day15
days[16] = day16
days[17] = day17
days[18] = day18
days[19] = day19
days[20] = day20
days[21] = day21
days[22] = day22
days[23] = day23
days[24] = day24
days[25] = day25

if #arg < 2 then
	print(#arg)
	usage(#days)
	os.exit()
end

local day = tonumber(arg[1]) 
if day == null then
	usage(#days)
	os.exit()
end
local path = arg[2]

if (day) > #days then
	usage(#days)
	os.exit()
end

-- test if data file exists at path
local f = io.open(path,"r")
if f == null then
	usage(#days)
	os.exit()
else 
	io.close(f)
	header(day)
	start = os.clock()
	days[day](path)
	finish = os.clock()
	print(string.format("Elapsed time: %.2f ms", (finish - start)*1000))
end
