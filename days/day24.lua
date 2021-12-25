
function day24_reg_get(key, reg) 
	if key == 'w' then 
		return reg.w
	elseif key == 'x' then 
		return reg.x
	elseif key == 'y' then 
		return reg.y
	elseif key == 'z' then 
		return reg.z
	end
	return nil
end

function day24_reg_set(key, val,reg) 
	if key == 'w' then 
		reg.w = val
	elseif key == 'x' then 
		reg.x = val 
	elseif key == 'y' then
		reg.y = val 
	elseif key == 'z' then 
		reg.z = val
	end
	return
end

function day24_trunc(val) 
	if val < 0 then 
		return math.ceil(val)
	elseif val > 0 then 
		return math.floor(val)
	else 
		return 0
	end
end

function day24_pow10(val) 
	-- currently works for me under Lua 5.4, supposedly deprecated in future 
	return math.floor(math.pow(10, val))
end

function day24_input(val) 
	local input = {}
	for i = 14,1,-1 do 
		local digit = math.floor(val/day24_pow10(i-1)) % 10
		table.insert(input,digit)
	end
	return input
end


function day24_run(prog, inp, registers, limit, start, input_index)
	
	local inp_index = input_index == nil and 1 or input_index
	
	
	for i = start ~= nil and start or 1,#prog do 
		if limit ~= nil and limit == i then 
			break
		end
		if prog[i].op == 'inp' then
			day24_reg_set(prog[i].a, inp[inp_index], registers)
			inp_index = inp_index + 1
		elseif prog[i].op == 'add' then 
			if not prog[i].b_int then 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) + day24_reg_get(prog[i].b, registers), registers)
			else 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) + prog[i].b_val, registers)
			end
		elseif prog[i].op == 'mul' then 
			if not prog[i].b_int then 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) * day24_reg_get(prog[i].b, registers), registers)
			else 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) * prog[i].b_val, registers)
			end
		elseif prog[i].op == 'div' then 
			if not prog[i].b_int then 
				day24_reg_set(prog[i].a,  day24_trunc(day24_reg_get(prog[i].a, registers) / day24_reg_get(prog[i].b, registers)), registers)
			else 
				day24_reg_set(prog[i].a,  day24_trunc(day24_reg_get(prog[i].a, registers) / prog[i].b_val), registers)
			end
		elseif prog[i].op == 'mod' then 
			if not prog[i].b_int then 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) % day24_reg_get(prog[i].b, registers), registers)
			else 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) % prog[i].b_val, registers)
			end
		elseif prog[i].op == 'eql' then 
			if not prog[i].b_int then 
				day24_reg_set(prog[i].a,  day24_trunc(day24_reg_get(prog[i].a, registers) == day24_reg_get(prog[i].b, registers) and 1 or 0), registers)
			else 
				day24_reg_set(prog[i].a,  day24_reg_get(prog[i].a, registers) == prog[i].b_val and 1 or 0, registers)
			end
		else 
			print("SOMETHING BAD HAS HAPPENED")
		end
	end
end


function day24_inst(line) 
	local inst = {}
	inst.op = string.sub(line, 1,3)
	inst.a = string.sub(line, 5,5) 
	inst.b_int = false
	inst.b_val = 0
	inst.b = nil
	local b = string.sub(line,7)
	if tonumber(b) ~= nil then 
		inst.b_int = true
		inst.b_val = tonumber(b) 
	else 
		inst.b_int = false
		inst.b = b
	end
	return inst
end

-- I'm sure shortcut to the solution exists if you understand what the puzzle program is doing, but I 
-- haven't figured it out yet. I can see that there are steps that increase the value of z, and steps 
-- that reduce it if the input value matches x, and z won't reach zero unless the input is correct
-- on each of the reduction steps. The following works, anyway, but is presumably non-optimal and 
-- not generalized
function day24_part1(instructions) 

	-- determined by inspection of partial execution, z is low after these positions on my puzzle input
	-- i don't think this generalizes to other puzzle inputs
	local k34_x = {{1,4},{2,5},{3,6},{4,7}, {5,4}, {6,9}}
	local k78_x = {{9,1}}
	local k1011_x = {{1,3},{2,4}, {3,5}, {4,6}, {5,7}, {6,8}, {7,9}}
	
	-- that only leaves 8 digits unknown. How bad can that be to iterate over until a match is found? 
	-- Take the largest of each predetermined digit group and for all other digits iterate descending
	for k1 = 9,1,-1 do 
		for k2 = 9,1,-1 do 
			for k34 = #k34_x,#k34_x do 
				for k5 = 9,1,-1 do
					for k6 = 9,1,-1 do 
						for k78 = #k78_x,#k78_x do 
							for k9 = 9,1,-1 do 
								for k1011 = #k1011_x,#k1011_x do
									for k12 = 9,1,-1 do 
										for k13 = 9,1,-1 do
											for k14 = 9,1,-1 do 
												local input = {k1,k2,k34_x[k34][1],k34_x[k34][2],k5,k6,k78_x[k78][1], k78_x[k78][2], k9, k1011_x[k1011][1], k1011_x[k1011][2], k12, k13, k14}
												local r = {w=0,x=0,y=0,z=0} 
												day24_run(instructions, input, r)
												if r.z < 1 then 
													local result = ''
													
													for i = 1, #input do 
														result = result .. tostring(input[i])
													end
													return result
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	return 'Not found'
end

function day24_part2(instructions) 

	-- determined by inspection of partial execution, z is low after these positions on my puzzle input
	-- i don't think this generalizes to other puzzle inputs
	local k34_x = {{1,4},{2,5},{3,6},{4,7}, {5,4}, {6,9}}
	local k78_x = {{9,1}}
	local k1011_x = {{1,3},{2,4}, {3,5}, {4,6}, {5,7}, {6,8}, {7,9}}
	
	local tries = 0
	
	-- Take the smallest of each predetermined digit group and for all other digits iterate ascending
	-- This is definitely not quick, but it does work.
	for k1 = 1,9 do 
		for k2 = 1,9 do 
			for k34 = 1,1 do 
				for k5 = 1,9 do
					for k6 = 1,9 do 
						for k78 = 1,1 do 
							for k9 = 1,9 do 
								for k1011 = 1,1 do
									for k12 = 1,9 do 
										for k13 = 1,9 do
											for k14 = 1,9 do 
												local input = {k1,k2,k34_x[k34][1],k34_x[k34][2],k5,k6,k78_x[k78][1], k78_x[k78][2], k9, k1011_x[k1011][1], k1011_x[k1011][2], k12, k13, k14}
												local r = {w=0,x=0,y=0,z=0} 
												day24_run(instructions, input, r)
												if r.z < 1 then 
													local result = ''
													
													for i = 1, #input do 
														result = result .. tostring(input[i])
													end
													return result
												end
												
												tries = tries + 1
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	return 'Not found'
end

function day24(path) 
	local lines = readLines(path)
	
	local instructions = {}
	for i = 1, #lines do 
		instructions[#instructions + 1] = day24_inst(lines[i])
	end
	
	local part1 = day24_part1(instructions)
	print(string.format("Part 1: %s", part1))
	
	local part2 = day24_part2(instructions)
	print(string.format("Part 2: %s", part2))
	
 end
 