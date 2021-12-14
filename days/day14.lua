
function day14_insert(node, value) 
	local temp = node.next
	newnode = {}
	newnode.val = value
	newnode.next = temp
	node.next = newnode
end

function day14_histmerge(hist, histA)
	for k,v in pairs(histA) do 
		if hist[k] == nil then 
			hist[k] = v
		else 
			hist[k] = hist[k] + v
		end
	end
end

function day14_listcopy(listA) 
	local node = listA 
	local node2 = {}
	local node2root = node2
	listB = node2
	while node.next ~= nil do
		--print("copy", node.val)
		node2.val = node.val
		local nextnode = {}
		node2.next = nextnode
		node2 = nextnode
		node = node.next
	end
	node2.val = node.val
	return node2root
end

function day14_listprint(list) 
	local node = list
	while(node ~= nil) do 
		io.write(node.val)
		node = node.next
	end
	print("")
end

-- expand to 10 steps
function day14_expand1(inserts, cache)
	-- expansion as linked list for each substitution
	for k,v in pairs(inserts) do 
		local nodeA = {}
		local nodeB = {}
		nodeA.val = string.sub(k,1,1)
		nodeB.val = string.sub(k,2,2)
		nodeA.next = nodeB
		nodeB.next = nil
		local hist = {}
		day14_oneorincrement(hist, nodeA.val)
		day14_oneorincrement(hist, nodeB.val)
		for i = 1,10 do 
			local node = nodeA
			while node.next ~= nil do
				local key = node.val .. node.next.val
				if inserts[key] ~= nil then
					day14_oneorincrement(hist, inserts[key])
					day14_insert(node, inserts[key])
					node = node.next
				end
				node = node.next
			end
		end
		cache[k] = {}
		cache[k]['10'] = {}
		cache[k]['10'].hist = hist
		cache[k]['10'].list = nodeA
		
	end
end

-- expand to 20 steps
function day14_expand2(inserts, cache) 
	for k,v in pairs(inserts) do 
		local nodeA = cache[k]['10'].list
		local hist = {} 
		local nodeB = day14_listcopy(nodeA)
		local node = nodeB
		while node.next ~= nil do
			local key = node.val .. node.next.val
			local startNode = node
			local endNode = node.next
			if inserts[key] ~= nil then
				local insertcopy = day14_listcopy(cache[key]['10'].list)
				local start = node.val 
				local startNode = node
				local endNode = node.next
				insertcopy = insertcopy.next
				startNode.next = insertcopy
				while insertcopy.next.next ~= nil do 
					insertcopy = insertcopy.next
				end
				insertcopy.next = endNode
				node = insertcopy
				day14_histmerge(hist, cache[key]['10'].hist)
				day14_zeroordecrement(hist, start) -- remove extra start node count
			end
			node = node.next
		end
		day14_oneorincrement(hist, nodeB.val)
		cache[k]['20'] = {}
		cache[k]['20'].hist = hist
		cache[k]['20'].list = nodeB
	end
end



-- obtain histogram for 40 steps
function day14_expand3(k, inserts, cache) 
	if cache[k] ~= nil and cache[k]['40'] then 
		return cache[k]['40'].hist
	end
	
	local nodeA = cache[k]['20'].list 
	local hist = {}
	local nodeB = day14_listcopy(nodeA)
	local node = nodeB
	while node.next ~= nil do 
		local key = node.val .. node.next.val
		local startNode = node 
		local endNode = node.next
		if inserts[key] ~= nil then
			day14_histmerge(hist, cache[key]['20'].hist)
			day14_zeroordecrement(hist, startNode.val)
		end	
		node = node.next
	end
	day14_oneorincrement(hist, string.sub(k,1,1))
	cache[k]['40'] = {}
	cache[k]['40'].hist = hist
	return hist
end

function day14_oneorincrement(tbl,key)
	if tbl[key] == nil then 
		tbl[key] = 1
	else
		tbl[key] = tbl[key] + 1
	end
	
end

function day14_zeroordecrement(tbl,key)
	if tbl[key] == nil or tbl[key] < 1 then 
		tbl[key] = 0
	else
		tbl[key] = tbl[key] - 1
	end
	
end

 function day14(path) 
	local lines = readLines(path)
	
	local template = lines[1]
	local inserts = {}
	for i = 3,#lines do 
		inserts[string.sub(lines[i],1,2)] = string.sub(lines[i],7,7)
	end
	
	local part1 = 0
	local part2 = 1
	
	local cache = {}
	local lo = -1
	local hi = -1 
	local hist1 = {}
	local hist2 = {}
	day14_expand1(inserts,cache)
	for i = 1,string.len(template)-1 do 
		local key = string.sub(template, i, i+1)
		local hist_temp = cache[key]['10'].hist
		day14_histmerge(hist1, hist_temp)
		hist1[string.sub(template,i,i)] = hist1[string.sub(template,i,i)] - 1
	end
	hist1[string.sub(template, 1, 1)] = hist1[string.sub(template, 1, 1)] + 1
	for k,v in pairs(hist1) do 
		if lo == -1 or v < lo then 
			lo = v
		end
		if hi == -1 or v > hi then 
			hi = v
		end
	end
	part1 = hi - lo
	print(string.format("Part 1: %d", part1))
	
	lo = -1
	hi = -1
	day14_expand2(inserts,cache)
	
	for i = 1,string.len(template)-1 do 
		local key = string.sub(template, i, i+1)
		local hist_temp = day14_expand3(key, inserts, cache)
		day14_histmerge(hist2, hist_temp)
		hist2[string.sub(template,i,i)] = hist2[string.sub(template,i,i)] - 1
	end
	hist2[string.sub(template, 1, 1)] = hist2[string.sub(template, 1, 1)] + 1
	
	
	for k,v in pairs(hist2) do 
		if lo == -1 or v < lo then 
			lo = v
		end
		if hi == -1 or v > hi then 
			hi = v
		end
	end
	
	part2 = hi - lo
	
	print(string.format("Part 2: %d", part2))
 
 end
 
