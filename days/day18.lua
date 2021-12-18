function day18_magnitude(a)
	local index = 1
	local depth = 0
	local number = tonumber(a)
	if number ~= nil then 
		return number
	end
	while true do 
		if string.sub(a, index, index) == '[' then 
			depth = depth + 1
		elseif string.sub(a,index,index) == ']' then 
			depth = depth - 1
		elseif string.sub(a,index,index) == ',' and depth == 1 then 
			return (day18_magnitude(string.sub(a, 2, index-1)) * 3) + (day18_magnitude(string.sub(a, index+1, string.len(a) - 1)) * 2) 
		end
		index = index + 1
	end
end

-- a bit of a mess, but it works
function day18_reduce(a)
	local explode = false
	local split = false
	local depth = 0
	local index = 1
	-- explode pass
	while index <= string.len(a) and not explode do  
		if string.sub(a,index,index) == '[' then 
			depth = depth + 1
			local is_leaf = true
			local index2 = index + 1
			while(string.sub(a,index2,index2) ~= ']') do
				if string.sub(a,index2,index2) == '[' then 
					is_leaf = false
					break
				end
				index2 = index2 + 1
			end
			if is_leaf and depth > 4 then 
				explode = true
				local comma = index+1
				while string.sub(a,comma,comma) ~= ',' do 
					comma = comma + 1
				end
				local left = tonumber(string.sub(a,index+1,comma-1))
				local right = tonumber(string.sub(a,comma+1, index2-1))
				
				local right_index = index2 + 1
				while true do 
					if right_index == string.len(a) then
						break
					end
					local chr = string.sub(a,right_index,right_index)
					if chr ~= '[' and chr ~= ']' and chr ~= ',' then 
						local right_index2 = right_index
						local chr2 = string.sub(a, right_index2, right_index2)
						while chr2 ~= '[' and chr2 ~= ']' and chr2 ~= ',' do
							right_index2 = right_index2 + 1
							chr2 = string.sub(a,right_index2, right_index2)
						end
						right_index2 = right_index2 - 1
						local right_val = tonumber(string.sub(a, right_index, right_index2))
						a = string.sub(a,1,right_index-1) .. (right + right_val) .. string.sub(a,right_index2 + 1)
						break
					end
					right_index = right_index + 1
				end
				
				a = string.sub(a, 1, index-1) .. '0' .. string.sub(a, index2 + 1)
				
				local left_index = index - 1
				while true do 
					
					if left_index == 0 then
						break
					end
					local chr = string.sub(a,left_index,left_index)
					if chr ~= '[' and chr ~= ']' and chr ~= ',' then 
						local left_index2 = left_index
						local chr2 = string.sub(a, left_index2, left_index2)
						while chr2 ~= '[' and chr2 ~= ']' and chr2 ~= ',' do
							left_index2 = left_index2 - 1
							chr2 = string.sub(a,left_index2, left_index2)
						end
						left_index2 = left_index2 + 1
						local left_val = tonumber(string.sub(a, left_index2, left_index))
						a = string.sub(a,1,left_index2-1) .. (left + left_val) .. string.sub(a,left_index + 1)
						break
					end
					left_index = left_index - 1
				end
				
			end 
		elseif string.sub(a,index,index) == ']' then 
			depth = depth - 1
		end
		index = index + 1
	end -- end explode pass
	
	-- split pass
	index = 1
	depth = 0
	while index <= string.len(a) and not explode and not split do  
		if string.sub(a,index,index) == '[' then 
			depth = depth + 1
		elseif string.sub(a,index,index) == ']' then 
			depth = depth - 1
		elseif string.sub(a,index,index) ~= ',' then 
			local index2 = index 
			local chr = string.sub(a, index2, index2)
			while chr ~= '[' and chr ~= ']' and chr ~= ',' do 
				index2 = index2 + 1
				chr = string.sub(a, index2, index2)
			end
			index2 = index2 - 1
			local val = tonumber(string.sub(a, index, index2))
			if val > 9 then 
				a = string.sub(a, 1, index-1) .. '[' .. (math.floor(val/2)) .. ',' .. (math.ceil(val/2)) .. ']' .. string.sub(a, index2 +1)
				split = true 
				break
			end
		end		
		index = index + 1
	end -- end split pass
	
	return a, (split or explode)	
end

function day18_add(a,b)
	local depth = 0
	local index = 1
	while index <= string.len(a) do 
		if string.sub(a,index,index) == '[' then 
			depth = depth + 1
		elseif(string.sub(a,index,index) == ']') then 
			if depth == 1 and string.sub(a,index,index) == ']' then 
				local result = '['..a.."," .. b ..']'
				return result
			end
			depth = depth - 1
		end
		
		index = index + 1
	end
end

function day18(path) 
	local lines = readLines(path)
	
	local totalfish = lines[1]
	for i = 2,#lines do 
		totalfish = day18_add(totalfish, lines[i])
		while true do
			local reduced = false
			totalfish,reduced = day18_reduce(totalfish)
			if not reduced then break end
		end
	end
	local part1 = day18_magnitude(totalfish)
	print(string.format("Part 1: %d", part1))
	
	local part2 = 0
	for i = 1,#lines do 
		for j = 1,#lines do 
			if i ~= j then 
				local fishsum = day18_add(lines[i],lines[j])
				while true do 
					local reduced = false
					fishsum,reduced = day18_reduce(fishsum)
					if not reduced then break end
				end
				local magnitude = day18_magnitude(fishsum)
				if magnitude > part2 then 
					part2 = magnitude
				end
			end
		end
	end
	
	print(string.format("Part 2: %d", part2))
 
 end
 