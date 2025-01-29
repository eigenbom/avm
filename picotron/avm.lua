--[[
	AVM library (flattened)
	https://github.com/eigenbom/avm
	
	This distribution:
	* Has been flattened into a single file
	* Has a global 'avm' table containing all modules
	* Has type annotations removed
--]]
avm = {}

-- Module array.lua
do
	--[[
	Functions for working with numerical arrays  
	
	Examples:  
	```lua  
	-- Create a new array `a` with values {1,2,3,4,5,6,7,8,9,10}  
	-- Create a new array `b` with values {10,9,8,7,6,5,4,3,2,1}  
	local a = array.range(1, 10)  
	local b = array.range(10, 1, -1)  
	
	-- Add them together  
	local c = array.add(a, b)  
	
	-- Check every element is equal to 11  
	assert(array.all_equals_constant(c, 11))  
	```  
	]]
	local M = {}
	
	---Disable warnings for _ex type overloaded functions
	
	-----------------------------------------------------------
	-- Constants and Dependencies
	-----------------------------------------------------------
	
	-- Epsilon for floating point comparisons used in "almost_" functions
	local epsilon_default = 1e-9
	
	-- Math library
	local math_abs = assert(math.abs)
	local math_ceil = assert(math.ceil)
	local math_min = assert(math.min)
	local math_max = assert(math.max)
	
	-----------------------------------------------------------
	-- Extension API
	-----------------------------------------------------------
	
	---Determines if src is an array
	---
	---Optionally redefine this to support custom platform and userdata
	function M.is_array(src)
		return type(src) == 'table' or type(src) == 'cdata'
	end
	
	---Returns the length of an array
	---
	---Optionally redefine this to support custom platform and userdata
	function M.length(src)
		assert(type(src) ~= 'cdata', "bad argument 'src' (cdata has no length)")
		return #src
	end
	
	---Create a new an array with an initial length
	---
	---Optionally redefine this to support custom platform and userdata
	function M.new_array(type, length)
		local dest = {}
		for i=1,length do
			dest[i] = 0
		end
		return dest
	end
	
	---Grow an array or sequence to span the range [index, index + count - 1]
	---
	---Optionally redefine this to support custom platform and userdata
	function M.grow_array(dest, dest_index, dest_count)
		for i=dest_index,dest_index+dest_count-1 do
			if dest[i] == nil then
				dest[i] = 0
			end
		end
	end
	
	---Copy an array
	---
	---Defaults to copying each element within a for loop
	---
	---Optionally redefine this to support custom platform and userdata
	function M.copy_array(src, src_index, src_count)
		local dest = M.new_array(type(src[src_index]),src_count)
		local offset = src_index - 1
		for i=1,src_count do
			dest[i] = src[offset + i]
		end
		return dest
	end
	
	---Copy an array
	---
	---Defaults to copying each element within a for loop
	---
	---Optionally redefine this to support custom platform and userdata
	function M.copy_array_into(src, src_index, src_count, dest, dest_index)
		local o = dest_index - 1
		local so = src_index - 1
		M.grow_array(dest, dest_index, src_count)
		for i=1,src_count do
			dest[o+i] = src[so+i]
		end
	end
	
	-----------------------------------------------------------
	-- Creation
	-----------------------------------------------------------
	
	---create an array of zeros
	function M.zeros(count)
		return M.fill(0.0, count)
	end
	
	---create an array filled with a constant value
	function M.fill(constant, count)
		local dest = M.new_array(type(constant),count)
		for i=1,count do
			dest[i] = constant
		end
		return dest
	end
	
	---fill a sequence with a constant
	function M.fill_into(constant, count, dest, dest_index)
		local index = dest_index or 1
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		for i=0,count-1 do
			dest[index+i] = constant
		end
	end
	
	---create an array with sequential values in `from .. to` in `step_size` increments
	function M.range(from, to, step_size)
		step_size = step_size or (from < to and 1 or -1)
		assert(step_size ~= 0, "bad argument 'step_size' (must be non-zero)")
		if step_size > 0 then
			assert(from <= to, "bad argument 'from' (must be <= 'to' when step_size > 0)")
		else
			assert(from >= to, "bad argument 'from' (must be >= 'to' when step_size < 0)")
		end
		local n = math_ceil((to - from) / step_size)
		local dest = M.new_array(type(from), n)
		local index = 1
		for value=from,to,step_size do
			dest[index] = value
			index = index + 1
		end
		return dest
	end
	
	---fill a destination with sequential values in `from .. to` in `step_size` increments
	function M.range_into(from, to, step_size, dest, dest_index)
		local index = dest_index or 1
		for value=from,to,step_size do
			dest[index] = value
			index = index + 1
		end
	end
	
	-----------------------------------------------------------
	-- Query
	-----------------------------------------------------------
	
	-----------------------------------------------------------
	-- Copying, slicing, reversing
	-----------------------------------------------------------
	
	---Copy an array elements into a new array
	function M.copy(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.copy_array(src, 1, M.length(src))
	end
	
	---Copy a slice
	function M.copy_ex(src, src_index, src_count) end
	
	---Copy a slice to a destination
	function M.copy_ex(src, src_index, src_count, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local dest_or_new = dest or M.new_array(type(src[src_index]), src_count+(dest_index or 1 or 1)-1)
		-- assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		M.copy_array_into(src, src_index, src_count, dest_or_new, dest_index or 1)
		return dest_or_new
	end
	
	--Reverse an array
	function M.reverse(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local n = M.length(src)
		local dest = M.new_array(type(src[1]),n)
		for i=1,n do
			dest[i] = src[n-i+1]
		end
		return dest
	end
	
	--Reverse a slice
	function M.reverse_ex(src, src_index, src_count) end
	
	--Reverse a slice into a destination
	function M.reverse_ex(src, src_index, src_count, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local src_offset = src_index - 1
		local dest_offset = dest_index and (dest_index - 1) or 0
		local n = src_count
		dest = dest or M.new_array(type(src[src_index]), n+(dest_offset+1 or 1)-1)
		for i=1,n do
			dest[dest_offset+i] = src[src_offset + n-i+1]
		end
		return dest
	end
	
	local function check_valid_reshape_size(dest_size)
		assert(type(dest_size) == "table", "bad argument 'dest_size' (table expected, got type " .. type(dest_size) .. ")")
		assert(#dest_size > 0, "bad argument 'dest_size' (dest_size must have at least one element)")
		for i=1,#dest_size do
			assert(dest_size[i] >= 0, "bad argument 'dest_size' (all dest_size values must be positive)")
		end
	end
	
	---Reshape a table or an array from nested arrays to a flat array or vice versa
	---
	---Examples:
	---* `reshape({1,2,3,4,5,6}, {3,2})` -> `{{1,2},{3,4},{5,6}}`
	---* `reshape({{1,2,3},{4,5,6}}}, {6})` -> `{1,2,3,4,5,6}`
	---
	function M.reshape(src, dest_size)
		check_valid_reshape_size(dest_size)
		local dest = {}
		M.reshape_into(src, dest_size, dest)
		return dest
	end
	
	---Reshape a table or an array into a destination
	---
	function M.reshape_into(src, dest_size, dest, dest_index)
		check_valid_reshape_size(dest_size)
	
		local dest_dim = #dest_size
		local dest_iter = M.fill(1, dest_dim)
		local dest_offset = dest_index and (dest_index - 1) or 0
		local src_size = {}
		do
			local tbl = src 		while type(tbl) == "table" do
				src_size[#src_size+1] = #tbl
				tbl = tbl[1]
			end
		end
		local src_dim = #src_size
		local src_iter = M.fill(1, src_dim)
	
		while true do
			-- copy element, e.g., dest[{0,0,0}] = src[i]
			local value = src 		for d=1,src_dim do
				local sub_index = src_iter[d]
				value = value[sub_index]
			end
	
			do
				local tbl = dest
				for d=1,dest_dim do
					local sub_index = dest_iter[d] + (d==1 and dest_offset or 0)
					if not tbl[sub_index] then
						tbl[sub_index] = (d==dest_dim) and value or {}
					end
					tbl = tbl[sub_index]
				end
			end
	
			-- increment dest_iter
			for d=dest_dim,1,-1 do
				local sub_index = dest_iter[d]
				if sub_index < dest_size[d] then
					dest_iter[d] = sub_index + 1
					break
				else
					dest_iter[d] = 1
				end
			end
			if M.all_equals_constant(dest_iter, 1) then
				break
			end
	
			-- increment src_iter
			for d=src_dim,1,-1 do
				local sub_index = src_iter[d]
				if sub_index < src_size[d] then
					src_iter[d] = sub_index + 1
					break
				else
					src_iter[d] = 1
				end
			end
			if M.all_equals_constant(src_iter, 1) then
				break
			end
		end
	
		return dest
	end
	
	---Flatten a table of data
	---
	---Example:
	---* `flatten({{1,2,3},{4,5,6}}})` -> `{1,2,3,4,5,6}`
	function M.flatten(src)
		local src_size = {}
		do
			local tbl = src 		while type(tbl) == "table" do
				src_size[#src_size+1] = #tbl
				tbl = tbl[1]
			end
		end
	
		local dest_size = 1
		for i=1,#src_size do
			dest_size = dest_size * src_size[i]
		end
	
		if dest_size == 0 then
			return {}
		end
	
		local dest = {}
		M.reshape_into(src, {dest_size}, dest)
		return dest
	end
	
	---Flatten a table of data into a destination
	---
	---Example:
	---* `flatten({{1,2,3},{4,5,6}}})` -> `{1,2,3,4,5,6}`
	function M.flatten_into(src, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		
		local src_size = {}
		do
			local tbl = src 		while type(tbl) == "table" do
				src_size[#src_size+1] = #tbl
				tbl = tbl[1]
			end
		end
	
		local dest_size = 1
		for i=1,#src_size do
			dest_size = dest_size * src_size[i]
		end
	
		if dest_size > 0 then
			M.reshape_into(src, {dest_size}, dest, dest_index)
		end
	end
	
	-----------------------------------------------------------
	-- Set, get, push, pop
	-----------------------------------------------------------
	
	---Set values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set(dest, dest_index, ...)
		local n = select("#", ...)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local o = dest_index - 1
		for i=1,n do
			dest[i+o] = select(i, ...)
		end
	end
	
	---Set 1 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_1(dest, dest_index, v1)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index] = v1
	end
	
	---Set 2 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_2(dest, dest_index, v1, v2)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1] = v1, v2
	end
	
	---Set 3 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_3(dest, dest_index, v1, v2, v3)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2] = v1, v2, v3
	end
	
	---Set 4 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_4(dest, dest_index, v1, v2, v3, v4)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3] = v1, v2, v3, v4
	end
	
	---Set 5 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_5(dest, dest_index, v1, v2, v3, v4, v5)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4] = v1, v2, v3, v4, v5
	end
	
	---Set 6 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_6(dest, dest_index, v1, v2, v3, v4, v5, v6)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5] = v1, v2, v3, v4, v5, v6
	end
	
	---Set 7 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_7(dest, dest_index, v1, v2, v3, v4, v5, v6, v7)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6] = v1, v2, v3, v4, v5, v6, v7
	end
	
	---Set 8 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_8(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7] = v1, v2, v3, v4, v5, v6, v7, v8
	end
	
	---Set 9 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_9(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8] = v1, v2, v3, v4, v5, v6, v7, v8, v9
	end
	
	---Set 10 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_10(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
	end
	
	---Set 11 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_11(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
	end
	
	---Set 12 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_12(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
	end
	
	---Set 13 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_13(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
	end
	
	---Set 14 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_14(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12], dest[dest_index+13] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
	end
	
	---Set 15 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_15(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12], dest[dest_index+13], dest[dest_index+14] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
	end
	
	---Set 16 values in a slice
	---```
	---dest[dest_index] = v1
	---...
	---dest[dest_index + n] = vn
	---```
	function M.set_16(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12], dest[dest_index+13], dest[dest_index+14], dest[dest_index+15] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
	end
	
	---Get 2 values from a slice
	function M.get_2(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1]
	end
	
	---Get 3 values from a slice
	function M.get_3(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2]
	end
	
	---Get 4 values from a slice
	function M.get_4(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3]
	end
	
	---Get 5 values from a slice
	function M.get_5(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4]
	end
	
	---Get 6 values from a slice
	function M.get_6(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5]
	end
	
	---Get 7 values from a slice
	function M.get_7(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6]
	end
	
	---Get 8 values from a slice
	function M.get_8(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7]
	end
	
	---Get 9 values from a slice
	function M.get_9(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8]
	end
	
	---Get 10 values from a slice
	function M.get_10(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9]
	end
	
	---Get 11 values from a slice
	function M.get_11(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10]
	end
	
	---Get 12 values from a slice
	function M.get_12(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11]
	end
	
	---Get 13 values from a slice
	function M.get_13(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12]
	end
	
	---Get 14 values from a slice
	function M.get_14(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12], src[src_index+13]
	end
	
	---Get 15 values from a slice
	function M.get_15(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12], src[src_index+13], src[src_index+14]
	end
	
	---Get 16 values from a slice
	function M.get_16(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12], src[src_index+13], src[src_index+14], src[src_index+15]
	end
	
	---Unpack 2 values from an array
	function M.unpack_2(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2]
	end
	
	---Unpack 3 values from an array
	function M.unpack_3(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3]
	end
	
	---Unpack 4 values from an array
	function M.unpack_4(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4]
	end
	
	---Unpack 5 values from an array
	function M.unpack_5(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5]
	end
	
	---Unpack 6 values from an array
	function M.unpack_6(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6]
	end
	
	---Unpack 7 values from an array
	function M.unpack_7(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7]
	end
	
	---Unpack 8 values from an array
	function M.unpack_8(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8]
	end
	
	---Unpack 9 values from an array
	function M.unpack_9(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9]
	end
	
	---Unpack 10 values from an array
	function M.unpack_10(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10]
	end
	
	---Unpack 11 values from an array
	function M.unpack_11(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11]
	end
	
	---Unpack 12 values from an array
	function M.unpack_12(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12]
	end
	
	---Unpack 13 values from an array
	function M.unpack_13(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13]
	end
	
	---Unpack 14 values from an array
	function M.unpack_14(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13], src[14]
	end
	
	---Unpack 15 values from an array
	function M.unpack_15(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13], src[14], src[15]
	end
	
	---Unpack 16 values from an array
	function M.unpack_16(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13], src[14], src[15], src[16]
	end
	
	---Push values onto an array
	---
	---also see `push_1()`, `push_2()`, `push_3()`, etc.
	function M.push(dest, ...)
		assert(dest, "bad argument 'dest' (expected array, got nil)")
		local n = M.length(dest)
		local count = select("#", ...)
		M.grow_array(dest, 1, n+count)
		for i=1,count do
			dest[n+i] = select(i, ...)
		end
	end
	
	---Push 1 value(s) onto an array
	function M.push_1(dest, v1)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+1)
		M.set_1(dest, len+1, v1)
	end
	
	---Push 2 value(s) onto an array
	function M.push_2(dest, v1, v2)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+2)
		M.set_2(dest, len+1, v1, v2)
	end
	
	---Push 3 value(s) onto an array
	function M.push_3(dest, v1, v2, v3)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+3)
		M.set_3(dest, len+1, v1, v2, v3)
	end
	
	---Push 4 value(s) onto an array
	function M.push_4(dest, v1, v2, v3, v4)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+4)
		M.set_4(dest, len+1, v1, v2, v3, v4)
	end
	
	---Push 5 value(s) onto an array
	function M.push_5(dest, v1, v2, v3, v4, v5)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+5)
		M.set_5(dest, len+1, v1, v2, v3, v4, v5)
	end
	
	---Push 6 value(s) onto an array
	function M.push_6(dest, v1, v2, v3, v4, v5, v6)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+6)
		M.set_6(dest, len+1, v1, v2, v3, v4, v5, v6)
	end
	
	---Push 7 value(s) onto an array
	function M.push_7(dest, v1, v2, v3, v4, v5, v6, v7)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+7)
		M.set_7(dest, len+1, v1, v2, v3, v4, v5, v6, v7)
	end
	
	---Push 8 value(s) onto an array
	function M.push_8(dest, v1, v2, v3, v4, v5, v6, v7, v8)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+8)
		M.set_8(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8)
	end
	
	---Push 9 value(s) onto an array
	function M.push_9(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+9)
		M.set_9(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9)
	end
	
	---Push 10 value(s) onto an array
	function M.push_10(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+10)
		M.set_10(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
	end
	
	---Push 11 value(s) onto an array
	function M.push_11(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+11)
		M.set_11(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
	end
	
	---Push 12 value(s) onto an array
	function M.push_12(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+12)
		M.set_12(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
	end
	
	---Push 13 value(s) onto an array
	function M.push_13(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+13)
		M.set_13(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13)
	end
	
	---Push 14 value(s) onto an array
	function M.push_14(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+14)
		M.set_14(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14)
	end
	
	---Push 15 value(s) onto an array
	function M.push_15(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+15)
		M.set_15(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15)
	end
	
	---Push 16 value(s) onto an array
	function M.push_16(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
		local len = M.length(dest)
		M.grow_array(dest, 1, len+16)
		M.set_16(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
	end
	
	---Pop a value off the end of an array and return it
	---
	---
	function M.pop(src)
		return M.pop_1(src)
	end
	
	---Pop 1 value(s) off the end of an array and return them
	---
	function M.pop_1(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-1+1
		local v1 = src[index]
		src[index] = nil
		return v1
	end
	
	---Pop 2 value(s) off the end of an array and return them
	---
	function M.pop_2(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-2+1
		local v1 = src[index]
		local v2 = src[index+1]
		src[index+1] = nil
		src[index] = nil
		return v1, v2
	end
	
	---Pop 3 value(s) off the end of an array and return them
	---
	function M.pop_3(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-3+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3
	end
	
	---Pop 4 value(s) off the end of an array and return them
	---
	function M.pop_4(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-4+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4
	end
	
	---Pop 5 value(s) off the end of an array and return them
	---
	function M.pop_5(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-5+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5
	end
	
	---Pop 6 value(s) off the end of an array and return them
	---
	function M.pop_6(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-6+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6
	end
	
	---Pop 7 value(s) off the end of an array and return them
	---
	function M.pop_7(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-7+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7
	end
	
	---Pop 8 value(s) off the end of an array and return them
	---
	function M.pop_8(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-8+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8
	end
	
	---Pop 9 value(s) off the end of an array and return them
	---
	function M.pop_9(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-9+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9
	end
	
	---Pop 10 value(s) off the end of an array and return them
	---
	function M.pop_10(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-10+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
	end
	
	---Pop 11 value(s) off the end of an array and return them
	---
	function M.pop_11(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-11+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		local v11 = src[index+10]
		src[index+10] = nil
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
	end
	
	---Pop 12 value(s) off the end of an array and return them
	---
	function M.pop_12(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-12+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		local v11 = src[index+10]
		local v12 = src[index+11]
		src[index+11] = nil
		src[index+10] = nil
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
	end
	
	---Pop 13 value(s) off the end of an array and return them
	---
	function M.pop_13(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-13+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		local v11 = src[index+10]
		local v12 = src[index+11]
		local v13 = src[index+12]
		src[index+12] = nil
		src[index+11] = nil
		src[index+10] = nil
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
	end
	
	---Pop 14 value(s) off the end of an array and return them
	---
	function M.pop_14(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-14+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		local v11 = src[index+10]
		local v12 = src[index+11]
		local v13 = src[index+12]
		local v14 = src[index+13]
		src[index+13] = nil
		src[index+12] = nil
		src[index+11] = nil
		src[index+10] = nil
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
	end
	
	---Pop 15 value(s) off the end of an array and return them
	---
	function M.pop_15(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-15+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		local v11 = src[index+10]
		local v12 = src[index+11]
		local v13 = src[index+12]
		local v14 = src[index+13]
		local v15 = src[index+14]
		src[index+14] = nil
		src[index+13] = nil
		src[index+12] = nil
		src[index+11] = nil
		src[index+10] = nil
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
	end
	
	---Pop 16 value(s) off the end of an array and return them
	---
	function M.pop_16(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		local index = M.length(src)-16+1
		local v1 = src[index]
		local v2 = src[index+1]
		local v3 = src[index+2]
		local v4 = src[index+3]
		local v5 = src[index+4]
		local v6 = src[index+5]
		local v7 = src[index+6]
		local v8 = src[index+7]
		local v9 = src[index+8]
		local v10 = src[index+9]
		local v11 = src[index+10]
		local v12 = src[index+11]
		local v13 = src[index+12]
		local v14 = src[index+13]
		local v15 = src[index+14]
		local v16 = src[index+15]
		src[index+15] = nil
		src[index+14] = nil
		src[index+13] = nil
		src[index+12] = nil
		src[index+11] = nil
		src[index+10] = nil
		src[index+9] = nil
		src[index+8] = nil
		src[index+7] = nil
		src[index+6] = nil
		src[index+5] = nil
		src[index+4] = nil
		src[index+3] = nil
		src[index+2] = nil
		src[index+1] = nil
		src[index] = nil
		return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
	end
	
	-----------------------------------------------------------
	-- Append, join
	-----------------------------------------------------------
	
	---Append an array `src` onto the end of an array `dest`
	---
	---Equivalent to `copy_into(src, dest, length(dest))`
	---
	function M.append(src, dest)
		assert(src, "bad argument 'src' (expected array, got nil)")
		if src ~= dest then
			assert(dest, "bad argument 'dest' (expected array, got nil)")
		end
		local src_len = M.length(src)
		local dest_len = (src ~= dest) and M.length(dest) or src_len
		if src_len > 0 then
			M.grow_array(dest, 1, dest_len + src_len)
			M.copy_ex(src, 1, src_len, dest, 1 + dest_len)
		end
	end
	
	---Extend an array `dest` with `src`
	---
	---Equivalent to `copy_into(src, dest, length(dest))`
	---
	function M.extend(dest, src)
		M.append(src, dest)
	end
	
	---Create an array with elements `[a_1, ..., a_n, b_1, ..., b_n]`
	function M.join(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local a_count = M.length(a)
		local b_count = M.length(b)
		local dest = M.new_array(type(a[1]),a_count+b_count)
		M.copy_ex(a, 1, a_count, dest)
		M.copy_ex(b, 1, b_count, dest, 1 + a_count)
		return dest
	end
	
	---Return an array with elements `[a_i, ..., a_(i+count), b_i, ..., b_(i+count)]`
	function M.join_ex(a, a_index, a_count, b, b_index, b_count)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local dest = M.new_array(type(a[a_index]), a_count + b_count)
		M.copy_ex(a, a_index, a_count, dest)
		M.copy_ex(b, b_index, b_count, dest, a_count)
		return dest
	end
	
	-----------------------------------------------------------
	-- Equality comparison
	-----------------------------------------------------------
	
	---true if the arrays are equal and #a==#b
	function M.all_equals(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local len_a = M.length(a)
		local len_b = M.length(b)
		if len_a ~= len_b then
			return false
		end
		return M.all_equals_ex(a, 1, len_a, b, 1)
	end
	
	---true if the slices are equal
	function M.all_equals_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		for i=1,a_count do
			if a[ao+i] ~= b[bo+i] then
				return false
			end
		end
		return true
	end
	
	---true if the arrays are almost equal (differ by epsilon or less)
	function M.all_almost_equals(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local len_a = M.length(a)
		local len_b = M.length(b)
		if len_a ~= len_b then
			return false
		end
		local eps = epsilon or epsilon_default
		for i=1,len_a do
			if math_abs(a[i]-b[i])>eps then
				return false
			end
		end
		return true
	end
	
	---true if a[1,#a] and b[1,#a] are almost equal (differ by epsilon or less)
	function M.all_almost_equals_ex(a, a_index, a_count, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local eps = epsilon or epsilon_default
		local ao = a_index - 1
		local bo = b_index - 1
		for i=1,a_count do
			if math_abs(a[ao+i]-b[bo+i])>eps then
				return false
			end
		end
		return true
	end
	
	---true if a[1,#a] and b[1,#a] are almost equal (differ by epsilon or less)
	---
	---nan is considered equal to itself
	function M.all_almost_equals_with_nan(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local eps = epsilon or epsilon_default
		for i=1,M.length(a) do
			local a_, b_ = a[i], b[i]
			if not (a_ ~= a_ and b_ ~= b) and math_abs(a_-b_) > eps then
				return false
			end
		end
		return true
	end
	
	-- true if all the elements are equal to the constant
	function M.all_equals_constant(a, constant)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return M.all_equals_constant_ex(a, 1, M.length(a), constant)
	end
	
	-- true if all the elements are equal to the constant
	function M.all_equals_constant_ex(a, a_index, a_count, constant)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		for i=a_index,a_index+a_count-1 do
			if a[i] ~= constant then
				return false
			end
		end
		return true
	end
	
	-- true if all the elements are almost equal to the constant (differ by epsilon or less)
	function M.all_almost_equals_constant(a, constant, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return M.all_almost_equals_constant_ex(a, 1, M.length(a), constant, epsilon)
	end
	
	-- true if all the elements are almost equal to the constant (differ by epsilon or less)
	function M.all_almost_equals_constant_ex(a, a_index, a_count, constant, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local eps = epsilon or epsilon_default
		for i=a_index,a_index+a_count-1 do
			if math_abs(a[i] - constant) > eps then
				return false
			end
		end
		return true
	end
	
	-----------------------------------------------------------
	-- Generation and map operations
	-----------------------------------------------------------
	
	---Return a new an array with elements
	---`f(i)` for `i` in `[1,count]`
	function M.generate(count, f)
		local dest = M.new_array(type(f(1)), count)
		for i=1,count do
			dest[i] = f(i)
		end
		return dest
	end
	
	---Fill a destination with elements
	---`f(i)` for `i` in `[1,count]`
	function M.generate_into(count, f, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local o = dest_index and (dest_index-1) or 0
		for i=1,count do
			dest[o+i] = f(i)
		end
	end
	
	---Apply a function to each element of the arrays and return an array
	---`f(a1[i])` for each `i` over the range `[1, #a1]`
	function M.map(f, a1)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		local n = M.length(a1)
		local dest = M.new_array(type(f(a1[1])),n)
		for i=1,n do
			dest[i] = f(a1[i])
		end
		return dest
	end
	
	---Apply a function to each element of the sequences and return an array
	function M.map_ex(f, a1, a1_index, a1_count) end
	
	---Apply a function to each element of the sequences and fill a target a destination
	function M.map_ex(f, a1, a1_index, a1_count, dest, dest_index)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local a1_o = a1_index - 1
		for i=1,a1_count do
			dest[o+i] = f(a1[a1_o+i])
		end
		return dest
	end
	
	---Apply a function to each element of the arrays and return an array
	---`f(a1[i], a2[i])` for each `i` over the range `[1, #a1]`
	function M.map_2(f, a1, a2)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		assert(a2, "bad argument 'a2' (expected array or sequence, got nil)")
		local n = M.length(a1)
		local dest = M.new_array(type(f(a1[1], a2[1])),n)
		for i=1,n do
			dest[i] = f(a1[i], a2[i])
		end
		return dest
	end
	
	---Apply a function to each element of the sequences and return an array
	function M.map_2_ex(f, a1, a1_index, a1_count, a2, a2_index) end
	
	---Apply a function to each element of the sequences and fill a target a destination
	function M.map_2_ex(f, a1, a1_index, a1_count, a2, a2_index, dest, dest_index)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		assert(a2, "bad argument 'a2' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local a1_o = a1_index - 1
		local a2_o = a2_index - 1
		for i=1,a1_count do
			dest[o+i] = f(a1[a1_o+i], a2[a2_o+i])
		end
		return dest
	end
	
	---Apply a function to each element of the arrays and return an array
	---`f(a1[i], a2[i], a3[i])` for each `i` over the range `[1, #a1]`
	function M.map_3(f, a1, a2, a3)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		assert(a2, "bad argument 'a2' (expected array or sequence, got nil)")
		assert(a3, "bad argument 'a3' (expected array or sequence, got nil)")
		local n = M.length(a1)
		local dest = M.new_array(type(f(a1[1], a2[1], a3[1])),n)
		for i=1,n do
			dest[i] = f(a1[i], a2[i], a3[i])
		end
		return dest
	end
	
	---Apply a function to each element of the sequences and return an array
	function M.map_3_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index) end
	
	---Apply a function to each element of the sequences and fill a target a destination
	function M.map_3_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index, dest, dest_index)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		assert(a2, "bad argument 'a2' (expected array or sequence, got nil)")
		assert(a3, "bad argument 'a3' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local a1_o = a1_index - 1
		local a2_o = a2_index - 1
		local a3_o = a3_index - 1
		for i=1,a1_count do
			dest[o+i] = f(a1[a1_o+i], a2[a2_o+i], a3[a3_o+i])
		end
		return dest
	end
	
	---Apply a function to each element of the arrays and return an array
	---`f(a1[i], a2[i], a3[i], a4[i])` for each `i` over the range `[1, #a1]`
	function M.map_4(f, a1, a2, a3, a4)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		assert(a2, "bad argument 'a2' (expected array or sequence, got nil)")
		assert(a3, "bad argument 'a3' (expected array or sequence, got nil)")
		assert(a4, "bad argument 'a4' (expected array or sequence, got nil)")
		local n = M.length(a1)
		local dest = M.new_array(type(f(a1[1], a2[1], a3[1], a4[1])),n)
		for i=1,n do
			dest[i] = f(a1[i], a2[i], a3[i], a4[i])
		end
		return dest
	end
	
	---Apply a function to each element of the sequences and return an array
	function M.map_4_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index, a4, a4_index) end
	
	---Apply a function to each element of the sequences and fill a target a destination
	function M.map_4_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index, a4, a4_index, dest, dest_index)
		assert(a1, "bad argument 'a1' (expected array or sequence, got nil)")
		assert(a2, "bad argument 'a2' (expected array or sequence, got nil)")
		assert(a3, "bad argument 'a3' (expected array or sequence, got nil)")
		assert(a4, "bad argument 'a4' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local a1_o = a1_index - 1
		local a2_o = a2_index - 1
		local a3_o = a3_index - 1
		local a4_o = a4_index - 1
		for i=1,a1_count do
			dest[o+i] = f(a1[a1_o+i], a2[a2_o+i], a3[a3_o+i], a4[a4_o+i])
		end
		return dest
	end
	
	-----------------------------------------------------------
	-- Element-wise binary operations
	-----------------------------------------------------------
	
	---Apply the addition operator to two arrays
	---
	---`{a[i]+b[i]}` for all `i` in `[1, #a]`
	function M.add(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		for i=1,n do
			dest[i] = a[i]+b[i]
		end
		return dest
	end
	
	---Apply the addition operator to each element of an array with a constant
	---
	---`{a[i]+c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.add_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]+c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]+c
			end
		end
		return dest
	end
	
	---Apply the addition operator to two slices and return the result
	---
	function M.add_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the addition operator to two slices and store the result in a destination
	---
	function M.add_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]+b[bo+i]
		end
		return dest
	end
	
	---Apply the addition operator to each element of a slice with a constant
	function M.add_constant_ex(a, a_index, a_count, c) end
	
	---Apply the addition operator to each element of a slice with a constant and store the result in a destination
	function M.add_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]+c
		end
	end
	
	---Apply the subtraction operator to two arrays
	---
	---`{a[i]-b[i]}` for all `i` in `[1, #a]`
	function M.sub(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		for i=1,n do
			dest[i] = a[i]-b[i]
		end
		return dest
	end
	
	---Apply the subtraction operator to each element of an array with a constant
	---
	---`{a[i]-c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.sub_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]-c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]-c
			end
		end
		return dest
	end
	
	---Apply the subtraction operator to two slices and return the result
	---
	function M.sub_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the subtraction operator to two slices and store the result in a destination
	---
	function M.sub_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]-b[bo+i]
		end
		return dest
	end
	
	---Apply the subtraction operator to each element of a slice with a constant
	function M.sub_constant_ex(a, a_index, a_count, c) end
	
	---Apply the subtraction operator to each element of a slice with a constant and store the result in a destination
	function M.sub_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]-c
		end
	end
	
	---Apply the multiplication operator to two arrays
	---
	---`{a[i]*b[i]}` for all `i` in `[1, #a]`
	function M.mul(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		for i=1,n do
			dest[i] = a[i]*b[i]
		end
		return dest
	end
	
	---Apply the multiplication operator to each element of an array with a constant
	---
	---`{a[i]*c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.mul_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]*c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]*c
			end
		end
		return dest
	end
	
	---Apply the multiplication operator to two slices and return the result
	---
	function M.mul_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the multiplication operator to two slices and store the result in a destination
	---
	function M.mul_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]*b[bo+i]
		end
		return dest
	end
	
	---Apply the multiplication operator to each element of a slice with a constant
	function M.mul_constant_ex(a, a_index, a_count, c) end
	
	---Apply the multiplication operator to each element of a slice with a constant and store the result in a destination
	function M.mul_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]*c
		end
	end
	
	---Apply the division operator to two arrays
	---
	---`{a[i]/b[i]}` for all `i` in `[1, #a]`
	function M.div(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		for i=1,n do
			dest[i] = a[i]/b[i]
		end
		return dest
	end
	
	---Apply the division operator to each element of an array with a constant
	---
	---`{a[i]/c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.div_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]/c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]/c
			end
		end
		return dest
	end
	
	---Apply the division operator to two slices and return the result
	---
	function M.div_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the division operator to two slices and store the result in a destination
	---
	function M.div_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]/b[bo+i]
		end
		return dest
	end
	
	---Apply the division operator to each element of a slice with a constant
	function M.div_constant_ex(a, a_index, a_count, c) end
	
	---Apply the division operator to each element of a slice with a constant and store the result in a destination
	function M.div_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]/c
		end
	end
	
	---Apply the modulus operator to two arrays
	---
	---`{a[i]%b[i]}` for all `i` in `[1, #a]`
	function M.mod(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		for i=1,n do
			dest[i] = a[i]%b[i]
		end
		return dest
	end
	
	---Apply the modulus operator to each element of an array with a constant
	---
	---`{a[i]%c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.mod_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]%c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]%c
			end
		end
		return dest
	end
	
	---Apply the modulus operator to two slices and return the result
	---
	function M.mod_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the modulus operator to two slices and store the result in a destination
	---
	function M.mod_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]%b[bo+i]
		end
		return dest
	end
	
	---Apply the modulus operator to each element of a slice with a constant
	function M.mod_constant_ex(a, a_index, a_count, c) end
	
	---Apply the modulus operator to each element of a slice with a constant and store the result in a destination
	function M.mod_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]%c
		end
	end
	
	---Apply the exponentiation operator to two arrays
	---
	---`{a[i]^b[i]}` for all `i` in `[1, #a]`
	function M.pow(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		for i=1,n do
			dest[i] = a[i]^b[i]
		end
		return dest
	end
	
	---Apply the exponentiation operator to each element of an array with a constant
	---
	---`{a[i]^c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.pow_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('number', n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]^c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]^c
			end
		end
		return dest
	end
	
	---Apply the exponentiation operator to two slices and return the result
	---
	function M.pow_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the exponentiation operator to two slices and store the result in a destination
	---
	function M.pow_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]^b[bo+i]
		end
		return dest
	end
	
	---Apply the exponentiation operator to each element of a slice with a constant
	function M.pow_constant_ex(a, a_index, a_count, c) end
	
	---Apply the exponentiation operator to each element of a slice with a constant and store the result in a destination
	function M.pow_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]^c
		end
	end
	
	---Apply the equal operator to two arrays
	---
	---`{a[i]==b[i]}` for all `i` in `[1, #a]`
	function M.equal(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = a[i]==b[i]
		end
		return dest
	end
	
	---Apply the equal operator to each element of an array with a constant
	---
	---`{a[i]==c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.equal_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]==c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]==c
			end
		end
		return dest
	end
	
	---Apply the equal operator to two slices and return the result
	---
	function M.equal_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the equal operator to two slices and store the result in a destination
	---
	function M.equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]==b[bo+i]
		end
		return dest
	end
	
	---Apply the equal operator to each element of a slice with a constant
	function M.equal_constant_ex(a, a_index, a_count, c) end
	
	---Apply the equal operator to each element of a slice with a constant and store the result in a destination
	function M.equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]==c
		end
	end
	
	---Apply the not equal operator to two arrays
	---
	---`{a[i]~=b[i]}` for all `i` in `[1, #a]`
	function M.not_equal(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = a[i]~=b[i]
		end
		return dest
	end
	
	---Apply the not equal operator to each element of an array with a constant
	---
	---`{a[i]~=c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.not_equal_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]~=c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]~=c
			end
		end
		return dest
	end
	
	---Apply the not equal operator to two slices and return the result
	---
	function M.not_equal_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the not equal operator to two slices and store the result in a destination
	---
	function M.not_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]~=b[bo+i]
		end
		return dest
	end
	
	---Apply the not equal operator to each element of a slice with a constant
	function M.not_equal_constant_ex(a, a_index, a_count, c) end
	
	---Apply the not equal operator to each element of a slice with a constant and store the result in a destination
	function M.not_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]~=c
		end
	end
	
	---Apply the less than operator to two arrays
	---
	---`{a[i]<b[i]}` for all `i` in `[1, #a]`
	function M.less_than(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = a[i]<b[i]
		end
		return dest
	end
	
	---Apply the less than operator to each element of an array with a constant
	---
	---`{a[i]<c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.less_than_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]<c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]<c
			end
		end
		return dest
	end
	
	---Apply the less than operator to two slices and return the result
	---
	function M.less_than_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the less than operator to two slices and store the result in a destination
	---
	function M.less_than_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]<b[bo+i]
		end
		return dest
	end
	
	---Apply the less than operator to each element of a slice with a constant
	function M.less_than_constant_ex(a, a_index, a_count, c) end
	
	---Apply the less than operator to each element of a slice with a constant and store the result in a destination
	function M.less_than_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]<c
		end
	end
	
	---Apply the less than or equal to operator to two arrays
	---
	---`{a[i]<=b[i]}` for all `i` in `[1, #a]`
	function M.less_than_or_equal(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = a[i]<=b[i]
		end
		return dest
	end
	
	---Apply the less than or equal to operator to each element of an array with a constant
	---
	---`{a[i]<=c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.less_than_or_equal_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]<=c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]<=c
			end
		end
		return dest
	end
	
	---Apply the less than or equal to operator to two slices and return the result
	---
	function M.less_than_or_equal_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the less than or equal to operator to two slices and store the result in a destination
	---
	function M.less_than_or_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]<=b[bo+i]
		end
		return dest
	end
	
	---Apply the less than or equal to operator to each element of a slice with a constant
	function M.less_than_or_equal_constant_ex(a, a_index, a_count, c) end
	
	---Apply the less than or equal to operator to each element of a slice with a constant and store the result in a destination
	function M.less_than_or_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]<=c
		end
	end
	
	---Apply the greater than operator to two arrays
	---
	---`{a[i]>b[i]}` for all `i` in `[1, #a]`
	function M.greater_than(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = a[i]>b[i]
		end
		return dest
	end
	
	---Apply the greater than operator to each element of an array with a constant
	---
	---`{a[i]>c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.greater_than_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]>c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]>c
			end
		end
		return dest
	end
	
	---Apply the greater than operator to two slices and return the result
	---
	function M.greater_than_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the greater than operator to two slices and store the result in a destination
	---
	function M.greater_than_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]>b[bo+i]
		end
		return dest
	end
	
	---Apply the greater than operator to each element of a slice with a constant
	function M.greater_than_constant_ex(a, a_index, a_count, c) end
	
	---Apply the greater than operator to each element of a slice with a constant and store the result in a destination
	function M.greater_than_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]>c
		end
	end
	
	---Apply the greater than or equal to operator to two arrays
	---
	---`{a[i]>=b[i]}` for all `i` in `[1, #a]`
	function M.greater_than_or_equal(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = a[i]>=b[i]
		end
		return dest
	end
	
	---Apply the greater than or equal to operator to each element of an array with a constant
	---
	---`{a[i]>=c}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.greater_than_or_equal_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]>=c[j]
				end
			end
		else
			for i=1,n do
				dest[i] = a[i]>=c
			end
		end
		return dest
	end
	
	---Apply the greater than or equal to operator to two slices and return the result
	---
	function M.greater_than_or_equal_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the greater than or equal to operator to two slices and store the result in a destination
	---
	function M.greater_than_or_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]>=b[bo+i]
		end
		return dest
	end
	
	---Apply the greater than or equal to operator to each element of a slice with a constant
	function M.greater_than_or_equal_constant_ex(a, a_index, a_count, c) end
	
	---Apply the greater than or equal to operator to each element of a slice with a constant and store the result in a destination
	function M.greater_than_or_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]>=c
		end
	end
	
	---Apply the minimum operator to two arrays
	---
	---`{min(a[i],b[i])}` for all `i` in `[1, #a]`
	function M.min(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array(type(a[1]), n)
		for i=1,n do
			dest[i] = math_min(a[i], b[i])
		end
		return dest
	end
	
	---Apply the minimum operator to each element of an array with a constant
	---
	---`{min(a[i],c)}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.min_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array(type(a[1]), n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = math_min(a[k], c[j])
				end
			end
		else
			for i=1,n do
				dest[i] = math_min(a[i], c)
			end
		end
		return dest
	end
	
	---Apply the minimum operator to two slices and return the result
	---
	function M.min_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the minimum operator to two slices and store the result in a destination
	---
	function M.min_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = math_min(a[ao+i], b[bo+i])
		end
		return dest
	end
	
	---Apply the minimum operator to each element of a slice with a constant
	function M.min_constant_ex(a, a_index, a_count, c) end
	
	---Apply the minimum operator to each element of a slice with a constant and store the result in a destination
	function M.min_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = math_min(a[ao+i], c)
		end
	end
	
	---Apply the maximum operator to two arrays
	---
	---`{max(a[i],b[i])}` for all `i` in `[1, #a]`
	function M.max(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array(type(a[1]), n)
		for i=1,n do
			dest[i] = math_max(a[i], b[i])
		end
		return dest
	end
	
	---Apply the maximum operator to each element of an array with a constant
	---
	---`{max(a[i],c)}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.max_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array(type(a[1]), n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = math_max(a[k], c[j])
				end
			end
		else
			for i=1,n do
				dest[i] = math_max(a[i], c)
			end
		end
		return dest
	end
	
	---Apply the maximum operator to two slices and return the result
	---
	function M.max_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the maximum operator to two slices and store the result in a destination
	---
	function M.max_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = math_max(a[ao+i], b[bo+i])
		end
		return dest
	end
	
	---Apply the maximum operator to each element of a slice with a constant
	function M.max_constant_ex(a, a_index, a_count, c) end
	
	---Apply the maximum operator to each element of a slice with a constant and store the result in a destination
	function M.max_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = math_max(a[ao+i], c)
		end
	end
	
	---Apply the almost equal operator to two arrays
	---
	---`{|a[i]-b[i]| < eps}` for all `i` in `[1, #a]`
	function M.almost_equal(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			dest[i] = math_abs(a[i] - b[i]) < epsilon_default
		end
		return dest
	end
	
	---Apply the almost equal operator to each element of an array with a constant
	---
	---`{|a[i]-c| < eps}` for all `i` in `[1, #a]`
	---
	---If `c` is an array its values are used in sequence across `a`
	---
	---Example:
	---```lua
	-----Add a vector (x,y) to 2d-positions stored in a flat array
	---add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
	---```
	function M.almost_equal_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = math_abs(a[k] - c[j]) < epsilon_default
				end
			end
		else
			for i=1,n do
				dest[i] = math_abs(a[i] - c) < epsilon_default
			end
		end
		return dest
	end
	
	---Apply the almost equal operator to two slices and return the result
	---
	function M.almost_equal_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the almost equal operator to two slices and store the result in a destination
	---
	function M.almost_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			dest[o+i] = math_abs(a[ao+i] - b[bo+i]) < epsilon_default
		end
		return dest
	end
	
	---Apply the almost equal operator to each element of a slice with a constant
	function M.almost_equal_constant_ex(a, a_index, a_count, c) end
	
	---Apply the almost equal operator to each element of a slice with a constant and store the result in a destination
	function M.almost_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index - 1) or 0
		local ao = (a_index - 1)
		local n = a_count
		for i=1,n do
			dest[o+i] = math_abs(a[ao+i] - c) < epsilon_default
		end
	end
	
	---Apply the almost equal (but NaN==NaN) operator to two arrays
	---
	---`{|a[i]-b[i]| < eps}` for all `i` in `[1, #a]`
	function M.almost_equal_with_nan(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array('boolean',n)
		for i=1,n do
			local a_, b_ = a[i], b[i]
			dest[i] = (a_ ~= a_ and b_ ~= b) or (math_abs(a_ - b_) < epsilon_default)
		end
		return dest
	end
	
	---Apply the almost equal (but NaN==NaN) operator to two slices and return the result
	---
	function M.almost_equal_with_nan_ex(a, a_index, a_count, b, b_index) end
	
	---Apply the almost equal (but NaN==NaN) operator to two slices and store the result in a destination
	---
	function M.almost_equal_with_nan_ex(a, a_index, a_count, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local ao = (a_index - 1)
		local bo = (b_index - 1)
		local o = dest_index and (dest_index - 1) or 0
		local n = a_count
		for i=1,n do
			local a_, b_ = a[ao+i], b[bo+i]
			dest[o+i] = (a_ ~= a_ and b_ ~= b) or (math_abs(a_ - b_) < epsilon_default)
		end
		return dest
	end
	
	---Perform the multiply-add operation on three arrays and return an array
	---
	---`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`
	function M.mul_add(a, b, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected array or sequence, got nil)")
		local n = M.length(a)
		local dest = M.new_array(type(a[1]),n)
		for i=1,n do
			dest[i] = a[i]+b[i]*c[i]
		end
		return dest
	end
	
	---Perform the multiply-add operation on three slices and return an array
	---
	---`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`
	function M.mul_add_ex(a, a_index, a_count, b, b_index, c, c_index) end
	
	---Perform the multiply-add operation on three slices into a destination
	---
	---`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`
	function M.mul_add_ex(a, a_index, a_count, b, b_index, c, c_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected array, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local ao = a_index - 1
		local bo = b_index - 1
		local co = c_index - 1
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]+b[bo+i]*c[co+i]
		end
		return dest
	end
	
	---Perform the multiply-add operation on two arrays and a constant and return an array
	---
	---`{a[i]+b[i]*c}` for all `i` in `[1, #a]`
	function M.mul_add_constant(a, b, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		assert(b, "bad argument 'b' (expected array, got nil)")
		local dest = M.new_array(type(a[1]),n)
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[k] = a[k]+b[k]*c[j]
				end
			end
		else
			assert(c, "bad argument 'c' (expected number, got nil)")
			for i=1,n do
				dest[i] = a[i]+b[i]*c
			end
		end
		return dest
	end
	
	---Perform the multiply-add operation on two slices and a constant and return an array
	---
	---`{a[i]+b[i]*c}` for all `i` in `[1, #a]`
	function M.mul_add_constant_ex(a, a_index, a_count, b, b_index, c) end
	
	---Perform the multiply-add operation on two slices and a constant into a destination
	---
	---`{a[i]+b[i]*c}` for all `i` in `[1, #a]`
	function M.mul_add_constant_ex(a, a_index, a_count, b, b_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local ao = a_index - 1
		local bo = b_index - 1
		local n = a_count
		if type(c)=="table" or M.is_array(c) then
			local c_count = M.length(c)
			for i=1,n,c_count do
				for j=1,c_count do
					local k = i+j-1
					dest[o+k] = a[ao+k]+b[bo+k]*c[j]
				end
			end
		else
			assert(c, "bad argument 'c' (expected number, got nil)")
			for i=1,n do
				dest[o+i] = a[ao+i]+b[bo+i]*c
			end
		end
	
		return dest
	end
	
	---Linearly interpolate between arrays and return an array
	---
	---`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`
	function M.lerp(a, b, t)
		assert(a, "bad argument 'a' (expected array, got nil)")
		local n = M.length(a)
		assert(b, "bad argument 'b' (expected array, got nil)")
		assert(t, "bad argument 't' (expected number, got nil)")
		local dest = M.new_array(type(a[1]),n)
		for i=1,n do
			dest[i] = a[i]*(1-t)+b[i]*t
		end
		return dest
	end
	
	---Linearly interpolate between slices and return an array
	---
	---`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`
	function M.lerp_ex(a, a_index, a_count, b, b_index, t) end
	
	---Linearly interpolate between slices into a destination
	---
	---`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`
	function M.lerp_ex(a, a_index, a_count, b, b_index, t, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		assert(t, "bad argument 't' (expected number, got nil)")
		dest = dest or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
		local o = dest_index and (dest_index-1) or 0
		local ao = a_index - 1
		local bo = b_index - 1
		local n = a_count
		for i=1,n do
			dest[o+i] = a[ao+i]*(1-t)+b[bo+i]*t
		end
		return dest
	end
	
	avm.array = M
	
end

-- Module format.lua
do
	--[[
	Format  
	
	Functions for converting arrays into readable strings  
	]]
	local M = {}
	
	local array = avm.array
	
	---Disable warnings for _ex type overloaded functions
	
	-----------------------------------------------------------
	-- Dependencies
	-----------------------------------------------------------
	
	-- Table library
	local table_concat = assert(table.concat)
	local table_unpack = assert(table.unpack)
	
	-- Math library
	local math_max = assert(math.max)
	
	-- String library
	local string_format = assert(string.format)
	local string_rep = assert(string.rep)
	
	-----------------------------------------------------------
	-- Basic stringification
	-----------------------------------------------------------
	
	---Format an array as a string of comma-separated values
	---Example:
	---```
	---format.array({1,2,3}) --> "1, 2, 3"
	---```
	function M.array(src, separator, format)
		return M.slice(src, 1, array.length(src), separator, format)
	end
	
	---Format a slice as a string of comma-separated values
	---Example:
	---```
	---format.slice({1,2,3,4}, 1, 3) --> "1, 2, 3"
	---```
	function M.slice(src, src_index, src_count, separator, format)
		local max_index = src_index + src_count - 1
		local strings = {}
		if format then
			for i=src_index,max_index do
				strings[#strings+1] = string_format(format, src[i])
			end
		else
			for i=src_index,max_index do
				strings[#strings+1] = tostring(src[i])
			end
		end
		return table_concat(strings, separator or ", ")
	end
	
	-----------------------------------------------------------
	-- Matrix stringification
	-----------------------------------------------------------
	
	---Format a slice as a 2d matrix
	---
	---By default will assume the data is in column-major order, but this can be changed with the option `row_major_order = true`
	---
	function M.matrix(src, src_index, num_cols, num_rows, format, options)
		local row_major_order = options and options.row_major_order
		local result = {}
		for row=1,num_rows do
			local row_str = {}
			for col=1,num_cols do
				local index = row_major_order and (src_index - 1 + col+(row-1)*num_cols) or (src_index - 1 + row+(col-1)*num_rows)
				if format then
					row_str[#row_str+1] = string_format(format, src[index])
				else
					row_str[#row_str+1] = tostring(src[index])
				end
			end
			result[#result+1] = table_concat(row_str, ", ")
		end
		return table_concat(result, "\n")
	end
	
	---Format matrix
	function M.mat1x1(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 1, 1, format)
	end
	
	---Format matrix
	function M.mat1x2(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 1, 2, format)
	end
	
	---Format matrix
	function M.mat1x3(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 1, 3, format)
	end
	
	---Format matrix
	function M.mat1x4(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 1, 4, format)
	end
	
	---Format matrix
	function M.mat2x1(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 2, 1, format)
	end
	
	---Format matrix
	function M.mat2x2(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 2, 2, format)
	end
	
	---Format matrix
	function M.mat2x3(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 2, 3, format)
	end
	
	---Format matrix
	function M.mat2x4(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 2, 4, format)
	end
	
	---Format matrix
	function M.mat3x1(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 3, 1, format)
	end
	
	---Format matrix
	function M.mat3x2(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 3, 2, format)
	end
	
	---Format matrix
	function M.mat3x3(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 3, 3, format)
	end
	
	---Format matrix
	function M.mat3x4(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 3, 4, format)
	end
	
	---Format matrix
	function M.mat4x1(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 4, 1, format)
	end
	
	---Format matrix
	function M.mat4x2(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 4, 2, format)
	end
	
	---Format matrix
	function M.mat4x3(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 4, 3, format)
	end
	
	---Format matrix
	function M.mat4x4(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 4, 4, format)
	end
	
	---Format matrix
	function M.mat1(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 1, 1, format)
	end
	
	---Format matrix
	function M.mat2(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 2, 2, format)
	end
	
	---Format matrix
	function M.mat3(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 3, 3, format)
	end
	
	---Format matrix
	function M.mat4(src, format)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.matrix(src, 1, 4, 4, format)
	end
	
	-----------------------------------------------------------
	-- Readable tables of data
	-----------------------------------------------------------
	
	---Tabulate multiple arrays of data
	---
	---Each column is a table with some or all of the following fields:
	---* `data` - the sequence or array of data
	---* `index?` - the index of the first element in the sequence (default = 1)
	---* `count?` - the number of elements in the sequence (default = #data)
	---* `group_size?` - the number of elements in each group (default = 1)
	---* `label?` - the column label (default = "")
	---* `format?` - the format string for each element (default = "%s")
	---
	---Example output for 3 arrays storing position, index and mass:
	---```
	---    pos     idx   mass
	---1 | 0,0,0 | 0   | 1
	---2 | 0,1,0 | 1   | 1 
	---3 | 2,0,1 | 2   | 1.5
	---```
	function M.tabulated(table_format, num_rows, column_1, ...)
		-- TODO: Auto-fit column widths etc
		local num_cols = select("#", ...)
		local result = {}
		local max_line_length = 5
		local max_row_label_width = #tostring(num_rows)
		local column_padding = 4
		local column_padding_string = string_rep(" ", column_padding)
	
		for i=0,num_cols do
			local column = i==0 and column_1 or select(i, ...)
			assert(column.data, "bad argument 'column.data' (expected value, got nil)")
		end
	
		for row_index=-1,num_rows do
			if row_index == 0 then
				-- Separator (placeholder)
				assert(#result+1==2)
				result[#result+1] = "PLACEHOLDER"
			else
				local row = row_index > 0 and {string_format("%" .. max_row_label_width .. "d", row_index)} or {""}
				for column_index=0,num_cols do
					local column = column_index==0 and column_1 or select(column_index, ...)
	
					if row_index == -1 then
						-- print label
						row[#row+1] = string_rep(" ", max_row_label_width) .. (column.label or "-")
					elseif row_index == 0 then
						-- print space
					else
						local group_size = column.group_size or 1
						local start_index = column.index or 1
						local index = start_index + (row_index-1)*group_size
						local max_index = column.count and (start_index-1+column.count) or array.length(column.data)
						if index > max_index then
							row[#row+1] = "-"
						else
							if column.format then
								row[#row+1] = string_format(column.format, table_unpack(column.data, index, index+group_size-1))
							else
								local entry = {}
								for i=index,index+group_size-1 do
									local value = column.data[i]
									entry[#entry+1] = tostring(value)
								end
								row[#row+1] = table_concat(entry, " ")
							end
						end
					end
				end
				local row_as_string = table_concat(row, column_padding_string)
				result[#result+1] = row_as_string
				max_line_length = math_max(max_line_length, #row_as_string)
			end
		end
		-- Adjust header separator width
		result[2] = string_rep("-", max_line_length)
		return table_concat(result, "\n")
	end
	
	avm.format = M
	
end

-- Module linalg.lua
do
	--[[
	Linear algebra routines  
	
	Functions for operating on numerical vectors and matrices up to 4 dimensions  
	]]
	local M = {}
	
	local array = avm.array
	
	---Disable warnings for _ex type overloaded functions
	
	-----------------------------------------------------------
	-- Dependencies
	-----------------------------------------------------------
	
	-- Math library dependencies
	-- Override these to use a different math library or set as nil to remove the dependency
	local math_sqrt = assert(math.sqrt)
	local math_sin = assert(math.sin)
	local math_cos = assert(math.cos)
	
	-----------------------------------------------------------
	-- Basic constructors
	-----------------------------------------------------------
	
	---2d-vector of zeros
	function M.vec2_zero()
		return 0,0
	end
	
	---3d-vector of zeros
	function M.vec3_zero()
		return 0,0,0
	end
	
	---4d-vector of zeros
	function M.vec4_zero()
		return 0,0,0,0
	end
	
	---2x2 matrix of zeros
	function M.mat2_zero()
		return 0,0,0,0
	end
	
	---3x3 matrix of zeros
	function M.mat3_zero()
		return 0,0,0, 0,0,0, 0,0,0
	end
	
	---4x4 matrix of zeros
	function M.mat4_zero()
		return 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
	end
	
	---2x2 identity matrix
	function M.mat2_identity()
		return 1,0,0,1
	end
	
	---3x3 identity matrix
	function M.mat3_identity()
		return 1,0,0, 0,1,0, 0,0,1
	end
	
	---4x4 identity matrix
	function M.mat4_identity()
		return 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1
	end
	
	-----------------------------------------------------------
	-- Other constructors
	-----------------------------------------------------------
	
	---3x3 translation matrix
	function M.mat3_translate(x,y)
		assert(x, "bad argument 'x' (expected number, got nil)")
		assert(y, "bad argument 'y' (expected number, got nil)")
		assert(type(x)=="number", "expected number, did you mean translatei?")
		return 1,0,0, 0,1,0, x,y,1
	end
	
	---3x3 scaling matrix
	function M.mat3_scale(x,y,z)
		assert(x, "bad argument 'x' (expected number, got nil)")
		assert(y, "bad argument 'y' (expected number, got nil)")
		assert(z, "bad argument 'z' (expected number, got nil)")
		return x,0,0, 0,y,0, 0,0,z
	end
	
	---3x3 rotation matrix
	function M.mat3_rotate_around_axis(radians, axis_x, axis_y, axis_z)
		assert(radians, "bad argument 'radians' (expected number, got nil)")
		assert(axis_x, "bad argument 'axis_x' (expected number, got nil)")
		assert(axis_y, "bad argument 'axis_y' (expected number, got nil)")
		assert(axis_z, "bad argument 'axis_z' (expected number, got nil)")
		local s, c = math_sin(radians), math_cos(radians)
		local x, y, z = axis_x, axis_y, axis_z
		local oc = 1-c
		return x*x*oc+c, x*y*oc+z*s, x*z*oc-y*s,
			y*x*oc-z*s, y*y*oc+c, y*z*oc+x*s,
			z*x*oc+y*s, z*y*oc-x*s, z*z*oc+c
	end
	
	---4x4 translation matrix
	function M.mat4_translate(x,y,z)
		assert(x, "bad argument 'x' (expected number, got nil)")
		return 1,0,0,0, 0,1,0,0, 0,0,1,0, x,y,z,1
	end
	
	---4x4 scaling matrix
	function M.mat4_scale(x,y,z)
		assert(x, "bad argument 'x' (expected number, got nil)")
		assert(y, "bad argument 'y' (expected number, got nil)")
		assert(z, "bad argument 'z' (expected number, got nil)")
		return x,0,0,0, 0,y,0,0, 0,0,z,0, 0,0,0,1
	end
	
	---4x4 rotation matrix
	function M.mat4_rotate_around_axis(radians, axis_x, axis_y, axis_z)
		assert(radians, "bad argument 'radians' (expected number, got nil)")
		assert(axis_x, "bad argument 'axis_x' (expected number, got nil)")
		assert(axis_y, "bad argument 'axis_y' (expected number, got nil)")
		assert(axis_z, "bad argument 'axis_z' (expected number, got nil)")
		local s, c = math_sin(radians), math_cos(radians)
		local oc = 1-c
		local x, y, z = axis_x, axis_y, axis_z
		return x*x*oc+c, x*y*oc+z*s, x*z*oc-y*s, 0,
			y*x*oc-z*s, y*y*oc+c, y*z*oc+x*s, 0,
			z*x*oc+y*s, z*y*oc-x*s, z*z*oc+c, 0,
			0, 0, 0, 1
	end
	
	-----------------------------------------------------------
	-- Element-wise operators
	-----------------------------------------------------------
	
	---Apply the addition operator to two 2-tuples
	function M.add_2(a1, a2, b1, b2)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		return a1 + b1, a2 + b2
	end
	
	---Apply the addition operator to two 2d-vectors
	function M.add_vec2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] + b[1], a[2] + b[2]
	end
	
	---Apply the addition operator to two 2d-vectors in a slice
	function M.add_vec2_ex(a, a_index, b, b_index) end
		
	---Apply the addition operator to two 2d-vectors in a slice and store the result in a destination
	function M.add_vec2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]+b[bo+1]
			dest[o+2] = a[ao+2]+b[bo+2]
		else
			return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2]
		end
	end
	
	---Apply the addition operator to a 2d-vector and a constant
	function M.add_vec2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] + c, a[2] + c
	end
	
	---Apply the addition operator to a 2d-vector in a slice and a constant
	function M.add_vec2_constant_ex(a, a_index, c) end
	
	---Apply the addition operator to a 2d-vector in a slice and a constant and store in a destination
	function M.add_vec2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] + c
			dest[o+2] = a[ao+2] + c
		else
			return a[ao+1] + c, a[ao+2] + c
		end
	end
	
	---Apply the addition operator to two 3-tuples
	function M.add_3(a1, a2, a3, b1, b2, b3)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		return a1 + b1, a2 + b2, a3 + b3
	end
	
	---Apply the addition operator to two 3d-vectors
	function M.add_vec3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] + b[1], a[2] + b[2], a[3] + b[3]
	end
	
	---Apply the addition operator to two 3d-vectors in a slice
	function M.add_vec3_ex(a, a_index, b, b_index) end
		
	---Apply the addition operator to two 3d-vectors in a slice and store the result in a destination
	function M.add_vec3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]+b[bo+1]
			dest[o+2] = a[ao+2]+b[bo+2]
			dest[o+3] = a[ao+3]+b[bo+3]
		else
			return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2], a[ao+3]+b[bo+3]
		end
	end
	
	---Apply the addition operator to a 3d-vector and a constant
	function M.add_vec3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] + c, a[2] + c, a[3] + c
	end
	
	---Apply the addition operator to a 3d-vector in a slice and a constant
	function M.add_vec3_constant_ex(a, a_index, c) end
	
	---Apply the addition operator to a 3d-vector in a slice and a constant and store in a destination
	function M.add_vec3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] + c
			dest[o+2] = a[ao+2] + c
			dest[o+3] = a[ao+3] + c
		else
			return a[ao+1] + c, a[ao+2] + c, a[ao+3] + c
		end
	end
	
	---Apply the addition operator to two 4-tuples
	function M.add_4(a1, a2, a3, a4, b1, b2, b3, b4)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(a4, "bad argument 'a4' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		assert(b4, "bad argument 'b4' (expected number, got nil)")
		return a1 + b1, a2 + b2, a3 + b3, a4 + b4
	end
	
	---Apply the addition operator to two 4d-vectors
	function M.add_vec4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4]
	end
	
	---Apply the addition operator to two 4d-vectors in a slice
	function M.add_vec4_ex(a, a_index, b, b_index) end
		
	---Apply the addition operator to two 4d-vectors in a slice and store the result in a destination
	function M.add_vec4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]+b[bo+1]
			dest[o+2] = a[ao+2]+b[bo+2]
			dest[o+3] = a[ao+3]+b[bo+3]
			dest[o+4] = a[ao+4]+b[bo+4]
		else
			return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2], a[ao+3]+b[bo+3], a[ao+4]+b[bo+4]
		end
	end
	
	---Apply the addition operator to a 4d-vector and a constant
	function M.add_vec4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] + c, a[2] + c, a[3] + c, a[4] + c
	end
	
	---Apply the addition operator to a 4d-vector in a slice and a constant
	function M.add_vec4_constant_ex(a, a_index, c) end
	
	---Apply the addition operator to a 4d-vector in a slice and a constant and store in a destination
	function M.add_vec4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] + c
			dest[o+2] = a[ao+2] + c
			dest[o+3] = a[ao+3] + c
			dest[o+4] = a[ao+4] + c
		else
			return a[ao+1] + c, a[ao+2] + c, a[ao+3] + c, a[ao+4] + c
		end
	end
	
	---Apply the subtraction operator to two 2-tuples
	function M.sub_2(a1, a2, b1, b2)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		return a1 - b1, a2 - b2
	end
	
	---Apply the subtraction operator to two 2d-vectors
	function M.sub_vec2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] - b[1], a[2] - b[2]
	end
	
	---Apply the subtraction operator to two 2d-vectors in a slice
	function M.sub_vec2_ex(a, a_index, b, b_index) end
		
	---Apply the subtraction operator to two 2d-vectors in a slice and store the result in a destination
	function M.sub_vec2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]-b[bo+1]
			dest[o+2] = a[ao+2]-b[bo+2]
		else
			return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2]
		end
	end
	
	---Apply the subtraction operator to a 2d-vector and a constant
	function M.sub_vec2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] - c, a[2] - c
	end
	
	---Apply the subtraction operator to a 2d-vector in a slice and a constant
	function M.sub_vec2_constant_ex(a, a_index, c) end
	
	---Apply the subtraction operator to a 2d-vector in a slice and a constant and store in a destination
	function M.sub_vec2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] - c
			dest[o+2] = a[ao+2] - c
		else
			return a[ao+1] - c, a[ao+2] - c
		end
	end
	
	---Apply the subtraction operator to two 3-tuples
	function M.sub_3(a1, a2, a3, b1, b2, b3)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		return a1 - b1, a2 - b2, a3 - b3
	end
	
	---Apply the subtraction operator to two 3d-vectors
	function M.sub_vec3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] - b[1], a[2] - b[2], a[3] - b[3]
	end
	
	---Apply the subtraction operator to two 3d-vectors in a slice
	function M.sub_vec3_ex(a, a_index, b, b_index) end
		
	---Apply the subtraction operator to two 3d-vectors in a slice and store the result in a destination
	function M.sub_vec3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]-b[bo+1]
			dest[o+2] = a[ao+2]-b[bo+2]
			dest[o+3] = a[ao+3]-b[bo+3]
		else
			return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2], a[ao+3]-b[bo+3]
		end
	end
	
	---Apply the subtraction operator to a 3d-vector and a constant
	function M.sub_vec3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] - c, a[2] - c, a[3] - c
	end
	
	---Apply the subtraction operator to a 3d-vector in a slice and a constant
	function M.sub_vec3_constant_ex(a, a_index, c) end
	
	---Apply the subtraction operator to a 3d-vector in a slice and a constant and store in a destination
	function M.sub_vec3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] - c
			dest[o+2] = a[ao+2] - c
			dest[o+3] = a[ao+3] - c
		else
			return a[ao+1] - c, a[ao+2] - c, a[ao+3] - c
		end
	end
	
	---Apply the subtraction operator to two 4-tuples
	function M.sub_4(a1, a2, a3, a4, b1, b2, b3, b4)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(a4, "bad argument 'a4' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		assert(b4, "bad argument 'b4' (expected number, got nil)")
		return a1 - b1, a2 - b2, a3 - b3, a4 - b4
	end
	
	---Apply the subtraction operator to two 4d-vectors
	function M.sub_vec4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4]
	end
	
	---Apply the subtraction operator to two 4d-vectors in a slice
	function M.sub_vec4_ex(a, a_index, b, b_index) end
		
	---Apply the subtraction operator to two 4d-vectors in a slice and store the result in a destination
	function M.sub_vec4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]-b[bo+1]
			dest[o+2] = a[ao+2]-b[bo+2]
			dest[o+3] = a[ao+3]-b[bo+3]
			dest[o+4] = a[ao+4]-b[bo+4]
		else
			return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2], a[ao+3]-b[bo+3], a[ao+4]-b[bo+4]
		end
	end
	
	---Apply the subtraction operator to a 4d-vector and a constant
	function M.sub_vec4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] - c, a[2] - c, a[3] - c, a[4] - c
	end
	
	---Apply the subtraction operator to a 4d-vector in a slice and a constant
	function M.sub_vec4_constant_ex(a, a_index, c) end
	
	---Apply the subtraction operator to a 4d-vector in a slice and a constant and store in a destination
	function M.sub_vec4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] - c
			dest[o+2] = a[ao+2] - c
			dest[o+3] = a[ao+3] - c
			dest[o+4] = a[ao+4] - c
		else
			return a[ao+1] - c, a[ao+2] - c, a[ao+3] - c, a[ao+4] - c
		end
	end
	
	---Apply the multiplication operator to two 2-tuples
	function M.mul_2(a1, a2, b1, b2)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		return a1 * b1, a2 * b2
	end
	
	---Apply the multiplication operator to two 2d-vectors
	function M.mul_vec2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] * b[1], a[2] * b[2]
	end
	
	---Apply the multiplication operator to two 2d-vectors in a slice
	function M.mul_vec2_ex(a, a_index, b, b_index) end
		
	---Apply the multiplication operator to two 2d-vectors in a slice and store the result in a destination
	function M.mul_vec2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+2]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2]
		end
	end
	
	---Apply the multiplication operator to a 2d-vector and a constant
	function M.mul_vec2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] * c, a[2] * c
	end
	
	---Apply the multiplication operator to a 2d-vector in a slice and a constant
	function M.mul_vec2_constant_ex(a, a_index, c) end
	
	---Apply the multiplication operator to a 2d-vector in a slice and a constant and store in a destination
	function M.mul_vec2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] * c
			dest[o+2] = a[ao+2] * c
		else
			return a[ao+1] * c, a[ao+2] * c
		end
	end
	
	---Apply the multiplication operator to two 3-tuples
	function M.mul_3(a1, a2, a3, b1, b2, b3)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		return a1 * b1, a2 * b2, a3 * b3
	end
	
	---Apply the multiplication operator to two 3d-vectors
	function M.mul_vec3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] * b[1], a[2] * b[2], a[3] * b[3]
	end
	
	---Apply the multiplication operator to two 3d-vectors in a slice
	function M.mul_vec3_ex(a, a_index, b, b_index) end
		
	---Apply the multiplication operator to two 3d-vectors in a slice and store the result in a destination
	function M.mul_vec3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+3]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2], a[ao+3]*b[bo+3]
		end
	end
	
	---Apply the multiplication operator to a 3d-vector and a constant
	function M.mul_vec3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] * c, a[2] * c, a[3] * c
	end
	
	---Apply the multiplication operator to a 3d-vector in a slice and a constant
	function M.mul_vec3_constant_ex(a, a_index, c) end
	
	---Apply the multiplication operator to a 3d-vector in a slice and a constant and store in a destination
	function M.mul_vec3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] * c
			dest[o+2] = a[ao+2] * c
			dest[o+3] = a[ao+3] * c
		else
			return a[ao+1] * c, a[ao+2] * c, a[ao+3] * c
		end
	end
	
	---Apply the multiplication operator to two 4-tuples
	function M.mul_4(a1, a2, a3, a4, b1, b2, b3, b4)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(a4, "bad argument 'a4' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		assert(b4, "bad argument 'b4' (expected number, got nil)")
		return a1 * b1, a2 * b2, a3 * b3, a4 * b4
	end
	
	---Apply the multiplication operator to two 4d-vectors
	function M.mul_vec4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4]
	end
	
	---Apply the multiplication operator to two 4d-vectors in a slice
	function M.mul_vec4_ex(a, a_index, b, b_index) end
		
	---Apply the multiplication operator to two 4d-vectors in a slice and store the result in a destination
	function M.mul_vec4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+4]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2], a[ao+3]*b[bo+3], a[ao+4]*b[bo+4]
		end
	end
	
	---Apply the multiplication operator to a 4d-vector and a constant
	function M.mul_vec4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] * c, a[2] * c, a[3] * c, a[4] * c
	end
	
	---Apply the multiplication operator to a 4d-vector in a slice and a constant
	function M.mul_vec4_constant_ex(a, a_index, c) end
	
	---Apply the multiplication operator to a 4d-vector in a slice and a constant and store in a destination
	function M.mul_vec4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] * c
			dest[o+2] = a[ao+2] * c
			dest[o+3] = a[ao+3] * c
			dest[o+4] = a[ao+4] * c
		else
			return a[ao+1] * c, a[ao+2] * c, a[ao+3] * c, a[ao+4] * c
		end
	end
	
	---Apply the division operator to two 2-tuples
	function M.div_2(a1, a2, b1, b2)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		return a1 / b1, a2 / b2
	end
	
	---Apply the division operator to two 2d-vectors
	function M.div_vec2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] / b[1], a[2] / b[2]
	end
	
	---Apply the division operator to two 2d-vectors in a slice
	function M.div_vec2_ex(a, a_index, b, b_index) end
		
	---Apply the division operator to two 2d-vectors in a slice and store the result in a destination
	function M.div_vec2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]/b[bo+1]
			dest[o+2] = a[ao+2]/b[bo+2]
		else
			return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2]
		end
	end
	
	---Apply the division operator to a 2d-vector and a constant
	function M.div_vec2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] / c, a[2] / c
	end
	
	---Apply the division operator to a 2d-vector in a slice and a constant
	function M.div_vec2_constant_ex(a, a_index, c) end
	
	---Apply the division operator to a 2d-vector in a slice and a constant and store in a destination
	function M.div_vec2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] / c
			dest[o+2] = a[ao+2] / c
		else
			return a[ao+1] / c, a[ao+2] / c
		end
	end
	
	---Apply the division operator to two 3-tuples
	function M.div_3(a1, a2, a3, b1, b2, b3)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		return a1 / b1, a2 / b2, a3 / b3
	end
	
	---Apply the division operator to two 3d-vectors
	function M.div_vec3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] / b[1], a[2] / b[2], a[3] / b[3]
	end
	
	---Apply the division operator to two 3d-vectors in a slice
	function M.div_vec3_ex(a, a_index, b, b_index) end
		
	---Apply the division operator to two 3d-vectors in a slice and store the result in a destination
	function M.div_vec3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]/b[bo+1]
			dest[o+2] = a[ao+2]/b[bo+2]
			dest[o+3] = a[ao+3]/b[bo+3]
		else
			return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2], a[ao+3]/b[bo+3]
		end
	end
	
	---Apply the division operator to a 3d-vector and a constant
	function M.div_vec3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] / c, a[2] / c, a[3] / c
	end
	
	---Apply the division operator to a 3d-vector in a slice and a constant
	function M.div_vec3_constant_ex(a, a_index, c) end
	
	---Apply the division operator to a 3d-vector in a slice and a constant and store in a destination
	function M.div_vec3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] / c
			dest[o+2] = a[ao+2] / c
			dest[o+3] = a[ao+3] / c
		else
			return a[ao+1] / c, a[ao+2] / c, a[ao+3] / c
		end
	end
	
	---Apply the division operator to two 4-tuples
	function M.div_4(a1, a2, a3, a4, b1, b2, b3, b4)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(a4, "bad argument 'a4' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		assert(b4, "bad argument 'b4' (expected number, got nil)")
		return a1 / b1, a2 / b2, a3 / b3, a4 / b4
	end
	
	---Apply the division operator to two 4d-vectors
	function M.div_vec4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4]
	end
	
	---Apply the division operator to two 4d-vectors in a slice
	function M.div_vec4_ex(a, a_index, b, b_index) end
		
	---Apply the division operator to two 4d-vectors in a slice and store the result in a destination
	function M.div_vec4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]/b[bo+1]
			dest[o+2] = a[ao+2]/b[bo+2]
			dest[o+3] = a[ao+3]/b[bo+3]
			dest[o+4] = a[ao+4]/b[bo+4]
		else
			return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2], a[ao+3]/b[bo+3], a[ao+4]/b[bo+4]
		end
	end
	
	---Apply the division operator to a 4d-vector and a constant
	function M.div_vec4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] / c, a[2] / c, a[3] / c, a[4] / c
	end
	
	---Apply the division operator to a 4d-vector in a slice and a constant
	function M.div_vec4_constant_ex(a, a_index, c) end
	
	---Apply the division operator to a 4d-vector in a slice and a constant and store in a destination
	function M.div_vec4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] / c
			dest[o+2] = a[ao+2] / c
			dest[o+3] = a[ao+3] / c
			dest[o+4] = a[ao+4] / c
		else
			return a[ao+1] / c, a[ao+2] / c, a[ao+3] / c, a[ao+4] / c
		end
	end
	
	---Apply the exponentiation operator to two 2-tuples
	function M.pow_2(a1, a2, b1, b2)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		return a1 ^ b1, a2 ^ b2
	end
	
	---Apply the exponentiation operator to two 2d-vectors
	function M.pow_vec2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] ^ b[1], a[2] ^ b[2]
	end
	
	---Apply the exponentiation operator to two 2d-vectors in a slice
	function M.pow_vec2_ex(a, a_index, b, b_index) end
		
	---Apply the exponentiation operator to two 2d-vectors in a slice and store the result in a destination
	function M.pow_vec2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]^b[bo+1]
			dest[o+2] = a[ao+2]^b[bo+2]
		else
			return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2]
		end
	end
	
	---Apply the exponentiation operator to a 2d-vector and a constant
	function M.pow_vec2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] ^ c, a[2] ^ c
	end
	
	---Apply the exponentiation operator to a 2d-vector in a slice and a constant
	function M.pow_vec2_constant_ex(a, a_index, c) end
	
	---Apply the exponentiation operator to a 2d-vector in a slice and a constant and store in a destination
	function M.pow_vec2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] ^ c
			dest[o+2] = a[ao+2] ^ c
		else
			return a[ao+1] ^ c, a[ao+2] ^ c
		end
	end
	
	---Apply the exponentiation operator to two 3-tuples
	function M.pow_3(a1, a2, a3, b1, b2, b3)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		return a1 ^ b1, a2 ^ b2, a3 ^ b3
	end
	
	---Apply the exponentiation operator to two 3d-vectors
	function M.pow_vec3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3]
	end
	
	---Apply the exponentiation operator to two 3d-vectors in a slice
	function M.pow_vec3_ex(a, a_index, b, b_index) end
		
	---Apply the exponentiation operator to two 3d-vectors in a slice and store the result in a destination
	function M.pow_vec3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]^b[bo+1]
			dest[o+2] = a[ao+2]^b[bo+2]
			dest[o+3] = a[ao+3]^b[bo+3]
		else
			return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2], a[ao+3]^b[bo+3]
		end
	end
	
	---Apply the exponentiation operator to a 3d-vector and a constant
	function M.pow_vec3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] ^ c, a[2] ^ c, a[3] ^ c
	end
	
	---Apply the exponentiation operator to a 3d-vector in a slice and a constant
	function M.pow_vec3_constant_ex(a, a_index, c) end
	
	---Apply the exponentiation operator to a 3d-vector in a slice and a constant and store in a destination
	function M.pow_vec3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] ^ c
			dest[o+2] = a[ao+2] ^ c
			dest[o+3] = a[ao+3] ^ c
		else
			return a[ao+1] ^ c, a[ao+2] ^ c, a[ao+3] ^ c
		end
	end
	
	---Apply the exponentiation operator to two 4-tuples
	function M.pow_4(a1, a2, a3, a4, b1, b2, b3, b4)
		assert(a1, "bad argument 'a1' (expected number, got nil)")
		assert(a2, "bad argument 'a2' (expected number, got nil)")
		assert(a3, "bad argument 'a3' (expected number, got nil)")
		assert(a4, "bad argument 'a4' (expected number, got nil)")
		assert(b1, "bad argument 'b1' (expected number, got nil)")
		assert(b2, "bad argument 'b2' (expected number, got nil)")
		assert(b3, "bad argument 'b3' (expected number, got nil)")
		assert(b4, "bad argument 'b4' (expected number, got nil)")
		return a1 ^ b1, a2 ^ b2, a3 ^ b3, a4 ^ b4
	end
	
	---Apply the exponentiation operator to two 4d-vectors
	function M.pow_vec4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4]
	end
	
	---Apply the exponentiation operator to two 4d-vectors in a slice
	function M.pow_vec4_ex(a, a_index, b, b_index) end
		
	---Apply the exponentiation operator to two 4d-vectors in a slice and store the result in a destination
	function M.pow_vec4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]^b[bo+1]
			dest[o+2] = a[ao+2]^b[bo+2]
			dest[o+3] = a[ao+3]^b[bo+3]
			dest[o+4] = a[ao+4]^b[bo+4]
		else
			return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2], a[ao+3]^b[bo+3], a[ao+4]^b[bo+4]
		end
	end
	
	---Apply the exponentiation operator to a 4d-vector and a constant
	function M.pow_vec4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c
	end
	
	---Apply the exponentiation operator to a 4d-vector in a slice and a constant
	function M.pow_vec4_constant_ex(a, a_index, c) end
	
	---Apply the exponentiation operator to a 4d-vector in a slice and a constant and store in a destination
	function M.pow_vec4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] ^ c
			dest[o+2] = a[ao+2] ^ c
			dest[o+3] = a[ao+3] ^ c
			dest[o+4] = a[ao+4] ^ c
		else
			return a[ao+1] ^ c, a[ao+2] ^ c, a[ao+3] ^ c, a[ao+4] ^ c
		end
	end
	
	---Negate a 2d-vector
	function M.negate_vec2(a)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return -a[1],-a[2]
	end
	
	---Negate a 2d-vector in a slice
	function M.negate_vec2_ex(a, a_index) end
	
	---Negate a 2d-vector in a slice and store the result in a destination
	function M.negate_vec2_ex(a, a_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local ao = a_index
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_2(dest, dest_index or 1, -a[ao],-a[1+ao])
		else
			return -a[ao],-a[1+ao]
		end
	end
	
	---Negate a 3d-vector
	function M.negate_vec3(a)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return -a[1],-a[2],-a[3]
	end
	
	---Negate a 3d-vector in a slice
	function M.negate_vec3_ex(a, a_index) end
	
	---Negate a 3d-vector in a slice and store the result in a destination
	function M.negate_vec3_ex(a, a_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local ao = a_index
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_3(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao])
		else
			return -a[ao],-a[1+ao],-a[2+ao]
		end
	end
	
	---Negate a 4d-vector
	function M.negate_vec4(a)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return -a[1],-a[2],-a[3],-a[4]
	end
	
	---Negate a 4d-vector in a slice
	function M.negate_vec4_ex(a, a_index) end
	
	---Negate a 4d-vector in a slice and store the result in a destination
	function M.negate_vec4_ex(a, a_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local ao = a_index
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao])
		else
			return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao]
		end
	end
	
	---true if the vectors are equal (differ by epsilon or less)
	function M.equals_vec2(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return array.all_almost_equals_ex(a, 1, 2, b, 1, epsilon)
	end
	 
	---true if the vectors in a slice are equal (differ by epsilon or less)
	function M.equals_vec2_ex(a, a_index, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return array.all_almost_equals_ex(a, a_index, 2, b, b_index, epsilon)
	end
	
	---true if the vectors are equal (differ by epsilon or less)
	function M.equals_vec3(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return array.all_almost_equals_ex(a, 1, 3, b, 1, epsilon)
	end
	 
	---true if the vectors in a slice are equal (differ by epsilon or less)
	function M.equals_vec3_ex(a, a_index, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return array.all_almost_equals_ex(a, a_index, 3, b, b_index, epsilon)
	end
	
	---true if the vectors are equal (differ by epsilon or less)
	function M.equals_vec4(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return array.all_almost_equals_ex(a, 1, 4, b, 1, epsilon)
	end
	 
	---true if the vectors in a slice are equal (differ by epsilon or less)
	function M.equals_vec4_ex(a, a_index, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return array.all_almost_equals_ex(a, a_index, 4, b, b_index, epsilon)
	end
	
	---Apply the addition operator to each element in two 2x2 matrices
	---
	function M.add_mat2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4]
	end
	
	---Apply the addition operator to each element in two 2x2 matrices in a slice
	---
	function M.add_mat2_ex(a, a_index, b, b_index) end
		
	---Apply the addition operator to each element in two 2d-vectors in a slice and store the result in a destination
	---
	function M.add_mat2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]+b[bo+1]
			dest[o+2] = a[ao+2]+b[bo+2]
			dest[o+3] = a[ao+3]+b[bo+3]
			dest[o+4] = a[ao+4]+b[bo+4]
		else
			return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2], a[ao+3]+b[bo+3], a[ao+4]+b[bo+4]
		end
	end
	
	---Apply the addition operator to each element in a 2x2 matrix and a constant
	function M.add_mat2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] + c, a[2] + c, a[3] + c, a[4] + c
	end
	
	---Apply the addition operator to each element in a 2x2 matrix in a slice and a constant
	function M.add_mat2_constant_ex(a, a_index, c) end
	
	---Apply the addition operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
	function M.add_mat2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] + c
			dest[o+2] = a[ao+2] + c
			dest[o+3] = a[ao+3] + c
			dest[o+4] = a[ao+4] + c
		else
			return a[ao+1] + c, a[ao+2] + c, a[ao+3] + c, a[ao+4] + c
		end
	end
	
	---Apply the addition operator to each element in two 3x3 matrices
	---
	function M.add_mat3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4], a[5] + b[5], a[6] + b[6], a[7] + b[7], a[8] + b[8], a[9] + b[9]
	end
	
	---Apply the addition operator to each element in two 3x3 matrices in a slice
	---
	function M.add_mat3_ex(a, a_index, b, b_index) end
		
	---Apply the addition operator to each element in two 3d-vectors in a slice and store the result in a destination
	---
	function M.add_mat3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]+b[bo+1]
			dest[o+2] = a[ao+2]+b[bo+2]
			dest[o+3] = a[ao+3]+b[bo+3]
			dest[o+4] = a[ao+4]+b[bo+4]
			dest[o+5] = a[ao+5]+b[bo+5]
			dest[o+6] = a[ao+6]+b[bo+6]
			dest[o+7] = a[ao+7]+b[bo+7]
			dest[o+8] = a[ao+8]+b[bo+8]
			dest[o+9] = a[ao+9]+b[bo+9]
		else
			return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2], a[ao+3]+b[bo+3], a[ao+4]+b[bo+4], a[ao+5]+b[bo+5], a[ao+6]+b[bo+6], a[ao+7]+b[bo+7], a[ao+8]+b[bo+8], a[ao+9]+b[bo+9]
		end
	end
	
	---Apply the addition operator to each element in a 3x3 matrix and a constant
	function M.add_mat3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] + c, a[2] + c, a[3] + c, a[4] + c, a[5] + c, a[6] + c, a[7] + c, a[8] + c, a[9] + c
	end
	
	---Apply the addition operator to each element in a 3x3 matrix in a slice and a constant
	function M.add_mat3_constant_ex(a, a_index, c) end
	
	---Apply the addition operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
	function M.add_mat3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] + c
			dest[o+2] = a[ao+2] + c
			dest[o+3] = a[ao+3] + c
			dest[o+4] = a[ao+4] + c
			dest[o+5] = a[ao+5] + c
			dest[o+6] = a[ao+6] + c
			dest[o+7] = a[ao+7] + c
			dest[o+8] = a[ao+8] + c
			dest[o+9] = a[ao+9] + c
		else
			return a[ao+1] + c, a[ao+2] + c, a[ao+3] + c, a[ao+4] + c, a[ao+5] + c, a[ao+6] + c, a[ao+7] + c, a[ao+8] + c, a[ao+9] + c
		end
	end
	
	---Apply the addition operator to each element in two 4x4 matrices
	---
	function M.add_mat4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4], a[5] + b[5], a[6] + b[6], a[7] + b[7], a[8] + b[8], a[9] + b[9], a[10] + b[10], a[11] + b[11], a[12] + b[12], a[13] + b[13], a[14] + b[14], a[15] + b[15], a[16] + b[16]
	end
	
	---Apply the addition operator to each element in two 4x4 matrices in a slice
	---
	function M.add_mat4_ex(a, a_index, b, b_index) end
		
	---Apply the addition operator to each element in two 4d-vectors in a slice and store the result in a destination
	---
	function M.add_mat4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]+b[bo+1]
			dest[o+2] = a[ao+2]+b[bo+2]
			dest[o+3] = a[ao+3]+b[bo+3]
			dest[o+4] = a[ao+4]+b[bo+4]
			dest[o+5] = a[ao+5]+b[bo+5]
			dest[o+6] = a[ao+6]+b[bo+6]
			dest[o+7] = a[ao+7]+b[bo+7]
			dest[o+8] = a[ao+8]+b[bo+8]
			dest[o+9] = a[ao+9]+b[bo+9]
			dest[o+10] = a[ao+10]+b[bo+10]
			dest[o+11] = a[ao+11]+b[bo+11]
			dest[o+12] = a[ao+12]+b[bo+12]
			dest[o+13] = a[ao+13]+b[bo+13]
			dest[o+14] = a[ao+14]+b[bo+14]
			dest[o+15] = a[ao+15]+b[bo+15]
			dest[o+16] = a[ao+16]+b[bo+16]
		else
			return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2], a[ao+3]+b[bo+3], a[ao+4]+b[bo+4], a[ao+5]+b[bo+5], a[ao+6]+b[bo+6], a[ao+7]+b[bo+7], a[ao+8]+b[bo+8], a[ao+9]+b[bo+9], a[ao+10]+b[bo+10], a[ao+11]+b[bo+11], a[ao+12]+b[bo+12], a[ao+13]+b[bo+13], a[ao+14]+b[bo+14], a[ao+15]+b[bo+15], a[ao+16]+b[bo+16]
		end
	end
	
	---Apply the addition operator to each element in a 4x4 matrix and a constant
	function M.add_mat4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] + c, a[2] + c, a[3] + c, a[4] + c, a[5] + c, a[6] + c, a[7] + c, a[8] + c, a[9] + c, a[10] + c, a[11] + c, a[12] + c, a[13] + c, a[14] + c, a[15] + c, a[16] + c
	end
	
	---Apply the addition operator to each element in a 4x4 matrix in a slice and a constant
	function M.add_mat4_constant_ex(a, a_index, c) end
	
	---Apply the addition operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
	function M.add_mat4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] + c
			dest[o+2] = a[ao+2] + c
			dest[o+3] = a[ao+3] + c
			dest[o+4] = a[ao+4] + c
			dest[o+5] = a[ao+5] + c
			dest[o+6] = a[ao+6] + c
			dest[o+7] = a[ao+7] + c
			dest[o+8] = a[ao+8] + c
			dest[o+9] = a[ao+9] + c
			dest[o+10] = a[ao+10] + c
			dest[o+11] = a[ao+11] + c
			dest[o+12] = a[ao+12] + c
			dest[o+13] = a[ao+13] + c
			dest[o+14] = a[ao+14] + c
			dest[o+15] = a[ao+15] + c
			dest[o+16] = a[ao+16] + c
		else
			return a[ao+1] + c, a[ao+2] + c, a[ao+3] + c, a[ao+4] + c, a[ao+5] + c, a[ao+6] + c, a[ao+7] + c, a[ao+8] + c, a[ao+9] + c, a[ao+10] + c, a[ao+11] + c, a[ao+12] + c, a[ao+13] + c, a[ao+14] + c, a[ao+15] + c, a[ao+16] + c
		end
	end
	
	---Apply the subtraction operator to each element in two 2x2 matrices
	---
	function M.sub_mat2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4]
	end
	
	---Apply the subtraction operator to each element in two 2x2 matrices in a slice
	---
	function M.sub_mat2_ex(a, a_index, b, b_index) end
		
	---Apply the subtraction operator to each element in two 2d-vectors in a slice and store the result in a destination
	---
	function M.sub_mat2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]-b[bo+1]
			dest[o+2] = a[ao+2]-b[bo+2]
			dest[o+3] = a[ao+3]-b[bo+3]
			dest[o+4] = a[ao+4]-b[bo+4]
		else
			return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2], a[ao+3]-b[bo+3], a[ao+4]-b[bo+4]
		end
	end
	
	---Apply the subtraction operator to each element in a 2x2 matrix and a constant
	function M.sub_mat2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] - c, a[2] - c, a[3] - c, a[4] - c
	end
	
	---Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant
	function M.sub_mat2_constant_ex(a, a_index, c) end
	
	---Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
	function M.sub_mat2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] - c
			dest[o+2] = a[ao+2] - c
			dest[o+3] = a[ao+3] - c
			dest[o+4] = a[ao+4] - c
		else
			return a[ao+1] - c, a[ao+2] - c, a[ao+3] - c, a[ao+4] - c
		end
	end
	
	---Apply the subtraction operator to each element in two 3x3 matrices
	---
	function M.sub_mat3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4], a[5] - b[5], a[6] - b[6], a[7] - b[7], a[8] - b[8], a[9] - b[9]
	end
	
	---Apply the subtraction operator to each element in two 3x3 matrices in a slice
	---
	function M.sub_mat3_ex(a, a_index, b, b_index) end
		
	---Apply the subtraction operator to each element in two 3d-vectors in a slice and store the result in a destination
	---
	function M.sub_mat3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]-b[bo+1]
			dest[o+2] = a[ao+2]-b[bo+2]
			dest[o+3] = a[ao+3]-b[bo+3]
			dest[o+4] = a[ao+4]-b[bo+4]
			dest[o+5] = a[ao+5]-b[bo+5]
			dest[o+6] = a[ao+6]-b[bo+6]
			dest[o+7] = a[ao+7]-b[bo+7]
			dest[o+8] = a[ao+8]-b[bo+8]
			dest[o+9] = a[ao+9]-b[bo+9]
		else
			return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2], a[ao+3]-b[bo+3], a[ao+4]-b[bo+4], a[ao+5]-b[bo+5], a[ao+6]-b[bo+6], a[ao+7]-b[bo+7], a[ao+8]-b[bo+8], a[ao+9]-b[bo+9]
		end
	end
	
	---Apply the subtraction operator to each element in a 3x3 matrix and a constant
	function M.sub_mat3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] - c, a[2] - c, a[3] - c, a[4] - c, a[5] - c, a[6] - c, a[7] - c, a[8] - c, a[9] - c
	end
	
	---Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant
	function M.sub_mat3_constant_ex(a, a_index, c) end
	
	---Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
	function M.sub_mat3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] - c
			dest[o+2] = a[ao+2] - c
			dest[o+3] = a[ao+3] - c
			dest[o+4] = a[ao+4] - c
			dest[o+5] = a[ao+5] - c
			dest[o+6] = a[ao+6] - c
			dest[o+7] = a[ao+7] - c
			dest[o+8] = a[ao+8] - c
			dest[o+9] = a[ao+9] - c
		else
			return a[ao+1] - c, a[ao+2] - c, a[ao+3] - c, a[ao+4] - c, a[ao+5] - c, a[ao+6] - c, a[ao+7] - c, a[ao+8] - c, a[ao+9] - c
		end
	end
	
	---Apply the subtraction operator to each element in two 4x4 matrices
	---
	function M.sub_mat4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4], a[5] - b[5], a[6] - b[6], a[7] - b[7], a[8] - b[8], a[9] - b[9], a[10] - b[10], a[11] - b[11], a[12] - b[12], a[13] - b[13], a[14] - b[14], a[15] - b[15], a[16] - b[16]
	end
	
	---Apply the subtraction operator to each element in two 4x4 matrices in a slice
	---
	function M.sub_mat4_ex(a, a_index, b, b_index) end
		
	---Apply the subtraction operator to each element in two 4d-vectors in a slice and store the result in a destination
	---
	function M.sub_mat4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]-b[bo+1]
			dest[o+2] = a[ao+2]-b[bo+2]
			dest[o+3] = a[ao+3]-b[bo+3]
			dest[o+4] = a[ao+4]-b[bo+4]
			dest[o+5] = a[ao+5]-b[bo+5]
			dest[o+6] = a[ao+6]-b[bo+6]
			dest[o+7] = a[ao+7]-b[bo+7]
			dest[o+8] = a[ao+8]-b[bo+8]
			dest[o+9] = a[ao+9]-b[bo+9]
			dest[o+10] = a[ao+10]-b[bo+10]
			dest[o+11] = a[ao+11]-b[bo+11]
			dest[o+12] = a[ao+12]-b[bo+12]
			dest[o+13] = a[ao+13]-b[bo+13]
			dest[o+14] = a[ao+14]-b[bo+14]
			dest[o+15] = a[ao+15]-b[bo+15]
			dest[o+16] = a[ao+16]-b[bo+16]
		else
			return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2], a[ao+3]-b[bo+3], a[ao+4]-b[bo+4], a[ao+5]-b[bo+5], a[ao+6]-b[bo+6], a[ao+7]-b[bo+7], a[ao+8]-b[bo+8], a[ao+9]-b[bo+9], a[ao+10]-b[bo+10], a[ao+11]-b[bo+11], a[ao+12]-b[bo+12], a[ao+13]-b[bo+13], a[ao+14]-b[bo+14], a[ao+15]-b[bo+15], a[ao+16]-b[bo+16]
		end
	end
	
	---Apply the subtraction operator to each element in a 4x4 matrix and a constant
	function M.sub_mat4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] - c, a[2] - c, a[3] - c, a[4] - c, a[5] - c, a[6] - c, a[7] - c, a[8] - c, a[9] - c, a[10] - c, a[11] - c, a[12] - c, a[13] - c, a[14] - c, a[15] - c, a[16] - c
	end
	
	---Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant
	function M.sub_mat4_constant_ex(a, a_index, c) end
	
	---Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
	function M.sub_mat4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] - c
			dest[o+2] = a[ao+2] - c
			dest[o+3] = a[ao+3] - c
			dest[o+4] = a[ao+4] - c
			dest[o+5] = a[ao+5] - c
			dest[o+6] = a[ao+6] - c
			dest[o+7] = a[ao+7] - c
			dest[o+8] = a[ao+8] - c
			dest[o+9] = a[ao+9] - c
			dest[o+10] = a[ao+10] - c
			dest[o+11] = a[ao+11] - c
			dest[o+12] = a[ao+12] - c
			dest[o+13] = a[ao+13] - c
			dest[o+14] = a[ao+14] - c
			dest[o+15] = a[ao+15] - c
			dest[o+16] = a[ao+16] - c
		else
			return a[ao+1] - c, a[ao+2] - c, a[ao+3] - c, a[ao+4] - c, a[ao+5] - c, a[ao+6] - c, a[ao+7] - c, a[ao+8] - c, a[ao+9] - c, a[ao+10] - c, a[ao+11] - c, a[ao+12] - c, a[ao+13] - c, a[ao+14] - c, a[ao+15] - c, a[ao+16] - c
		end
	end
	
	---Apply the multiplication operator to each element in two 2x2 matrices
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4]
	end
	
	---Apply the multiplication operator to each element in two 2x2 matrices in a slice
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat2_ex(a, a_index, b, b_index) end
		
	---Apply the multiplication operator to each element in two 2d-vectors in a slice and store the result in a destination
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+4]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2], a[ao+3]*b[bo+3], a[ao+4]*b[bo+4]
		end
	end
	
	---Apply the multiplication operator to each element in a 2x2 matrix and a constant
	function M.mul_mat2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] * c, a[2] * c, a[3] * c, a[4] * c
	end
	
	---Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant
	function M.mul_mat2_constant_ex(a, a_index, c) end
	
	---Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
	function M.mul_mat2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] * c
			dest[o+2] = a[ao+2] * c
			dest[o+3] = a[ao+3] * c
			dest[o+4] = a[ao+4] * c
		else
			return a[ao+1] * c, a[ao+2] * c, a[ao+3] * c, a[ao+4] * c
		end
	end
	
	---Apply the multiplication operator to each element in two 3x3 matrices
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4], a[5] * b[5], a[6] * b[6], a[7] * b[7], a[8] * b[8], a[9] * b[9]
	end
	
	---Apply the multiplication operator to each element in two 3x3 matrices in a slice
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat3_ex(a, a_index, b, b_index) end
		
	---Apply the multiplication operator to each element in two 3d-vectors in a slice and store the result in a destination
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+5]*b[bo+5]
			dest[o+6] = a[ao+6]*b[bo+6]
			dest[o+7] = a[ao+7]*b[bo+7]
			dest[o+8] = a[ao+8]*b[bo+8]
			dest[o+9] = a[ao+9]*b[bo+9]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2], a[ao+3]*b[bo+3], a[ao+4]*b[bo+4], a[ao+5]*b[bo+5], a[ao+6]*b[bo+6], a[ao+7]*b[bo+7], a[ao+8]*b[bo+8], a[ao+9]*b[bo+9]
		end
	end
	
	---Apply the multiplication operator to each element in a 3x3 matrix and a constant
	function M.mul_mat3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] * c, a[2] * c, a[3] * c, a[4] * c, a[5] * c, a[6] * c, a[7] * c, a[8] * c, a[9] * c
	end
	
	---Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant
	function M.mul_mat3_constant_ex(a, a_index, c) end
	
	---Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
	function M.mul_mat3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] * c
			dest[o+2] = a[ao+2] * c
			dest[o+3] = a[ao+3] * c
			dest[o+4] = a[ao+4] * c
			dest[o+5] = a[ao+5] * c
			dest[o+6] = a[ao+6] * c
			dest[o+7] = a[ao+7] * c
			dest[o+8] = a[ao+8] * c
			dest[o+9] = a[ao+9] * c
		else
			return a[ao+1] * c, a[ao+2] * c, a[ao+3] * c, a[ao+4] * c, a[ao+5] * c, a[ao+6] * c, a[ao+7] * c, a[ao+8] * c, a[ao+9] * c
		end
	end
	
	---Apply the multiplication operator to each element in two 4x4 matrices
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4], a[5] * b[5], a[6] * b[6], a[7] * b[7], a[8] * b[8], a[9] * b[9], a[10] * b[10], a[11] * b[11], a[12] * b[12], a[13] * b[13], a[14] * b[14], a[15] * b[15], a[16] * b[16]
	end
	
	---Apply the multiplication operator to each element in two 4x4 matrices in a slice
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat4_ex(a, a_index, b, b_index) end
		
	---Apply the multiplication operator to each element in two 4d-vectors in a slice and store the result in a destination
	---
	---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
	---
	function M.mul_mat4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+5]*b[bo+5]
			dest[o+6] = a[ao+6]*b[bo+6]
			dest[o+7] = a[ao+7]*b[bo+7]
			dest[o+8] = a[ao+8]*b[bo+8]
			dest[o+9] = a[ao+9]*b[bo+9]
			dest[o+10] = a[ao+10]*b[bo+10]
			dest[o+11] = a[ao+11]*b[bo+11]
			dest[o+12] = a[ao+12]*b[bo+12]
			dest[o+13] = a[ao+13]*b[bo+13]
			dest[o+14] = a[ao+14]*b[bo+14]
			dest[o+15] = a[ao+15]*b[bo+15]
			dest[o+16] = a[ao+16]*b[bo+16]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2], a[ao+3]*b[bo+3], a[ao+4]*b[bo+4], a[ao+5]*b[bo+5], a[ao+6]*b[bo+6], a[ao+7]*b[bo+7], a[ao+8]*b[bo+8], a[ao+9]*b[bo+9], a[ao+10]*b[bo+10], a[ao+11]*b[bo+11], a[ao+12]*b[bo+12], a[ao+13]*b[bo+13], a[ao+14]*b[bo+14], a[ao+15]*b[bo+15], a[ao+16]*b[bo+16]
		end
	end
	
	---Apply the multiplication operator to each element in a 4x4 matrix and a constant
	function M.mul_mat4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] * c, a[2] * c, a[3] * c, a[4] * c, a[5] * c, a[6] * c, a[7] * c, a[8] * c, a[9] * c, a[10] * c, a[11] * c, a[12] * c, a[13] * c, a[14] * c, a[15] * c, a[16] * c
	end
	
	---Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant
	function M.mul_mat4_constant_ex(a, a_index, c) end
	
	---Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
	function M.mul_mat4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] * c
			dest[o+2] = a[ao+2] * c
			dest[o+3] = a[ao+3] * c
			dest[o+4] = a[ao+4] * c
			dest[o+5] = a[ao+5] * c
			dest[o+6] = a[ao+6] * c
			dest[o+7] = a[ao+7] * c
			dest[o+8] = a[ao+8] * c
			dest[o+9] = a[ao+9] * c
			dest[o+10] = a[ao+10] * c
			dest[o+11] = a[ao+11] * c
			dest[o+12] = a[ao+12] * c
			dest[o+13] = a[ao+13] * c
			dest[o+14] = a[ao+14] * c
			dest[o+15] = a[ao+15] * c
			dest[o+16] = a[ao+16] * c
		else
			return a[ao+1] * c, a[ao+2] * c, a[ao+3] * c, a[ao+4] * c, a[ao+5] * c, a[ao+6] * c, a[ao+7] * c, a[ao+8] * c, a[ao+9] * c, a[ao+10] * c, a[ao+11] * c, a[ao+12] * c, a[ao+13] * c, a[ao+14] * c, a[ao+15] * c, a[ao+16] * c
		end
	end
	
	---Apply the division operator to each element in two 2x2 matrices
	---
	function M.div_mat2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4]
	end
	
	---Apply the division operator to each element in two 2x2 matrices in a slice
	---
	function M.div_mat2_ex(a, a_index, b, b_index) end
		
	---Apply the division operator to each element in two 2d-vectors in a slice and store the result in a destination
	---
	function M.div_mat2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]/b[bo+1]
			dest[o+2] = a[ao+2]/b[bo+2]
			dest[o+3] = a[ao+3]/b[bo+3]
			dest[o+4] = a[ao+4]/b[bo+4]
		else
			return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2], a[ao+3]/b[bo+3], a[ao+4]/b[bo+4]
		end
	end
	
	---Apply the division operator to each element in a 2x2 matrix and a constant
	function M.div_mat2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] / c, a[2] / c, a[3] / c, a[4] / c
	end
	
	---Apply the division operator to each element in a 2x2 matrix in a slice and a constant
	function M.div_mat2_constant_ex(a, a_index, c) end
	
	---Apply the division operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
	function M.div_mat2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] / c
			dest[o+2] = a[ao+2] / c
			dest[o+3] = a[ao+3] / c
			dest[o+4] = a[ao+4] / c
		else
			return a[ao+1] / c, a[ao+2] / c, a[ao+3] / c, a[ao+4] / c
		end
	end
	
	---Apply the division operator to each element in two 3x3 matrices
	---
	function M.div_mat3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4], a[5] / b[5], a[6] / b[6], a[7] / b[7], a[8] / b[8], a[9] / b[9]
	end
	
	---Apply the division operator to each element in two 3x3 matrices in a slice
	---
	function M.div_mat3_ex(a, a_index, b, b_index) end
		
	---Apply the division operator to each element in two 3d-vectors in a slice and store the result in a destination
	---
	function M.div_mat3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]/b[bo+1]
			dest[o+2] = a[ao+2]/b[bo+2]
			dest[o+3] = a[ao+3]/b[bo+3]
			dest[o+4] = a[ao+4]/b[bo+4]
			dest[o+5] = a[ao+5]/b[bo+5]
			dest[o+6] = a[ao+6]/b[bo+6]
			dest[o+7] = a[ao+7]/b[bo+7]
			dest[o+8] = a[ao+8]/b[bo+8]
			dest[o+9] = a[ao+9]/b[bo+9]
		else
			return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2], a[ao+3]/b[bo+3], a[ao+4]/b[bo+4], a[ao+5]/b[bo+5], a[ao+6]/b[bo+6], a[ao+7]/b[bo+7], a[ao+8]/b[bo+8], a[ao+9]/b[bo+9]
		end
	end
	
	---Apply the division operator to each element in a 3x3 matrix and a constant
	function M.div_mat3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] / c, a[2] / c, a[3] / c, a[4] / c, a[5] / c, a[6] / c, a[7] / c, a[8] / c, a[9] / c
	end
	
	---Apply the division operator to each element in a 3x3 matrix in a slice and a constant
	function M.div_mat3_constant_ex(a, a_index, c) end
	
	---Apply the division operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
	function M.div_mat3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] / c
			dest[o+2] = a[ao+2] / c
			dest[o+3] = a[ao+3] / c
			dest[o+4] = a[ao+4] / c
			dest[o+5] = a[ao+5] / c
			dest[o+6] = a[ao+6] / c
			dest[o+7] = a[ao+7] / c
			dest[o+8] = a[ao+8] / c
			dest[o+9] = a[ao+9] / c
		else
			return a[ao+1] / c, a[ao+2] / c, a[ao+3] / c, a[ao+4] / c, a[ao+5] / c, a[ao+6] / c, a[ao+7] / c, a[ao+8] / c, a[ao+9] / c
		end
	end
	
	---Apply the division operator to each element in two 4x4 matrices
	---
	function M.div_mat4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4], a[5] / b[5], a[6] / b[6], a[7] / b[7], a[8] / b[8], a[9] / b[9], a[10] / b[10], a[11] / b[11], a[12] / b[12], a[13] / b[13], a[14] / b[14], a[15] / b[15], a[16] / b[16]
	end
	
	---Apply the division operator to each element in two 4x4 matrices in a slice
	---
	function M.div_mat4_ex(a, a_index, b, b_index) end
		
	---Apply the division operator to each element in two 4d-vectors in a slice and store the result in a destination
	---
	function M.div_mat4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]/b[bo+1]
			dest[o+2] = a[ao+2]/b[bo+2]
			dest[o+3] = a[ao+3]/b[bo+3]
			dest[o+4] = a[ao+4]/b[bo+4]
			dest[o+5] = a[ao+5]/b[bo+5]
			dest[o+6] = a[ao+6]/b[bo+6]
			dest[o+7] = a[ao+7]/b[bo+7]
			dest[o+8] = a[ao+8]/b[bo+8]
			dest[o+9] = a[ao+9]/b[bo+9]
			dest[o+10] = a[ao+10]/b[bo+10]
			dest[o+11] = a[ao+11]/b[bo+11]
			dest[o+12] = a[ao+12]/b[bo+12]
			dest[o+13] = a[ao+13]/b[bo+13]
			dest[o+14] = a[ao+14]/b[bo+14]
			dest[o+15] = a[ao+15]/b[bo+15]
			dest[o+16] = a[ao+16]/b[bo+16]
		else
			return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2], a[ao+3]/b[bo+3], a[ao+4]/b[bo+4], a[ao+5]/b[bo+5], a[ao+6]/b[bo+6], a[ao+7]/b[bo+7], a[ao+8]/b[bo+8], a[ao+9]/b[bo+9], a[ao+10]/b[bo+10], a[ao+11]/b[bo+11], a[ao+12]/b[bo+12], a[ao+13]/b[bo+13], a[ao+14]/b[bo+14], a[ao+15]/b[bo+15], a[ao+16]/b[bo+16]
		end
	end
	
	---Apply the division operator to each element in a 4x4 matrix and a constant
	function M.div_mat4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] / c, a[2] / c, a[3] / c, a[4] / c, a[5] / c, a[6] / c, a[7] / c, a[8] / c, a[9] / c, a[10] / c, a[11] / c, a[12] / c, a[13] / c, a[14] / c, a[15] / c, a[16] / c
	end
	
	---Apply the division operator to each element in a 4x4 matrix in a slice and a constant
	function M.div_mat4_constant_ex(a, a_index, c) end
	
	---Apply the division operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
	function M.div_mat4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] / c
			dest[o+2] = a[ao+2] / c
			dest[o+3] = a[ao+3] / c
			dest[o+4] = a[ao+4] / c
			dest[o+5] = a[ao+5] / c
			dest[o+6] = a[ao+6] / c
			dest[o+7] = a[ao+7] / c
			dest[o+8] = a[ao+8] / c
			dest[o+9] = a[ao+9] / c
			dest[o+10] = a[ao+10] / c
			dest[o+11] = a[ao+11] / c
			dest[o+12] = a[ao+12] / c
			dest[o+13] = a[ao+13] / c
			dest[o+14] = a[ao+14] / c
			dest[o+15] = a[ao+15] / c
			dest[o+16] = a[ao+16] / c
		else
			return a[ao+1] / c, a[ao+2] / c, a[ao+3] / c, a[ao+4] / c, a[ao+5] / c, a[ao+6] / c, a[ao+7] / c, a[ao+8] / c, a[ao+9] / c, a[ao+10] / c, a[ao+11] / c, a[ao+12] / c, a[ao+13] / c, a[ao+14] / c, a[ao+15] / c, a[ao+16] / c
		end
	end
	
	---Apply the exponentiation operator to each element in two 2x2 matrices
	---
	function M.pow_mat2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4]
	end
	
	---Apply the exponentiation operator to each element in two 2x2 matrices in a slice
	---
	function M.pow_mat2_ex(a, a_index, b, b_index) end
		
	---Apply the exponentiation operator to each element in two 2d-vectors in a slice and store the result in a destination
	---
	function M.pow_mat2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]^b[bo+1]
			dest[o+2] = a[ao+2]^b[bo+2]
			dest[o+3] = a[ao+3]^b[bo+3]
			dest[o+4] = a[ao+4]^b[bo+4]
		else
			return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2], a[ao+3]^b[bo+3], a[ao+4]^b[bo+4]
		end
	end
	
	---Apply the exponentiation operator to each element in a 2x2 matrix and a constant
	function M.pow_mat2_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c
	end
	
	---Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant
	function M.pow_mat2_constant_ex(a, a_index, c) end
	
	---Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
	function M.pow_mat2_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] ^ c
			dest[o+2] = a[ao+2] ^ c
			dest[o+3] = a[ao+3] ^ c
			dest[o+4] = a[ao+4] ^ c
		else
			return a[ao+1] ^ c, a[ao+2] ^ c, a[ao+3] ^ c, a[ao+4] ^ c
		end
	end
	
	---Apply the exponentiation operator to each element in two 3x3 matrices
	---
	function M.pow_mat3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4], a[5] ^ b[5], a[6] ^ b[6], a[7] ^ b[7], a[8] ^ b[8], a[9] ^ b[9]
	end
	
	---Apply the exponentiation operator to each element in two 3x3 matrices in a slice
	---
	function M.pow_mat3_ex(a, a_index, b, b_index) end
		
	---Apply the exponentiation operator to each element in two 3d-vectors in a slice and store the result in a destination
	---
	function M.pow_mat3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]^b[bo+1]
			dest[o+2] = a[ao+2]^b[bo+2]
			dest[o+3] = a[ao+3]^b[bo+3]
			dest[o+4] = a[ao+4]^b[bo+4]
			dest[o+5] = a[ao+5]^b[bo+5]
			dest[o+6] = a[ao+6]^b[bo+6]
			dest[o+7] = a[ao+7]^b[bo+7]
			dest[o+8] = a[ao+8]^b[bo+8]
			dest[o+9] = a[ao+9]^b[bo+9]
		else
			return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2], a[ao+3]^b[bo+3], a[ao+4]^b[bo+4], a[ao+5]^b[bo+5], a[ao+6]^b[bo+6], a[ao+7]^b[bo+7], a[ao+8]^b[bo+8], a[ao+9]^b[bo+9]
		end
	end
	
	---Apply the exponentiation operator to each element in a 3x3 matrix and a constant
	function M.pow_mat3_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c, a[5] ^ c, a[6] ^ c, a[7] ^ c, a[8] ^ c, a[9] ^ c
	end
	
	---Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant
	function M.pow_mat3_constant_ex(a, a_index, c) end
	
	---Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
	function M.pow_mat3_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] ^ c
			dest[o+2] = a[ao+2] ^ c
			dest[o+3] = a[ao+3] ^ c
			dest[o+4] = a[ao+4] ^ c
			dest[o+5] = a[ao+5] ^ c
			dest[o+6] = a[ao+6] ^ c
			dest[o+7] = a[ao+7] ^ c
			dest[o+8] = a[ao+8] ^ c
			dest[o+9] = a[ao+9] ^ c
		else
			return a[ao+1] ^ c, a[ao+2] ^ c, a[ao+3] ^ c, a[ao+4] ^ c, a[ao+5] ^ c, a[ao+6] ^ c, a[ao+7] ^ c, a[ao+8] ^ c, a[ao+9] ^ c
		end
	end
	
	---Apply the exponentiation operator to each element in two 4x4 matrices
	---
	function M.pow_mat4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4], a[5] ^ b[5], a[6] ^ b[6], a[7] ^ b[7], a[8] ^ b[8], a[9] ^ b[9], a[10] ^ b[10], a[11] ^ b[11], a[12] ^ b[12], a[13] ^ b[13], a[14] ^ b[14], a[15] ^ b[15], a[16] ^ b[16]
	end
	
	---Apply the exponentiation operator to each element in two 4x4 matrices in a slice
	---
	function M.pow_mat4_ex(a, a_index, b, b_index) end
		
	---Apply the exponentiation operator to each element in two 4d-vectors in a slice and store the result in a destination
	---
	function M.pow_mat4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1]^b[bo+1]
			dest[o+2] = a[ao+2]^b[bo+2]
			dest[o+3] = a[ao+3]^b[bo+3]
			dest[o+4] = a[ao+4]^b[bo+4]
			dest[o+5] = a[ao+5]^b[bo+5]
			dest[o+6] = a[ao+6]^b[bo+6]
			dest[o+7] = a[ao+7]^b[bo+7]
			dest[o+8] = a[ao+8]^b[bo+8]
			dest[o+9] = a[ao+9]^b[bo+9]
			dest[o+10] = a[ao+10]^b[bo+10]
			dest[o+11] = a[ao+11]^b[bo+11]
			dest[o+12] = a[ao+12]^b[bo+12]
			dest[o+13] = a[ao+13]^b[bo+13]
			dest[o+14] = a[ao+14]^b[bo+14]
			dest[o+15] = a[ao+15]^b[bo+15]
			dest[o+16] = a[ao+16]^b[bo+16]
		else
			return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2], a[ao+3]^b[bo+3], a[ao+4]^b[bo+4], a[ao+5]^b[bo+5], a[ao+6]^b[bo+6], a[ao+7]^b[bo+7], a[ao+8]^b[bo+8], a[ao+9]^b[bo+9], a[ao+10]^b[bo+10], a[ao+11]^b[bo+11], a[ao+12]^b[bo+12], a[ao+13]^b[bo+13], a[ao+14]^b[bo+14], a[ao+15]^b[bo+15], a[ao+16]^b[bo+16]
		end
	end
	
	---Apply the exponentiation operator to each element in a 4x4 matrix and a constant
	function M.pow_mat4_constant(a, c)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c, a[5] ^ c, a[6] ^ c, a[7] ^ c, a[8] ^ c, a[9] ^ c, a[10] ^ c, a[11] ^ c, a[12] ^ c, a[13] ^ c, a[14] ^ c, a[15] ^ c, a[16] ^ c
	end
	
	---Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant
	function M.pow_mat4_constant_ex(a, a_index, c) end
	
	---Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
	function M.pow_mat4_constant_ex(a, a_index, c, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(c, "bad argument 'c' (expected number, got nil)")
		local ao = a_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o+1] = a[ao+1] ^ c
			dest[o+2] = a[ao+2] ^ c
			dest[o+3] = a[ao+3] ^ c
			dest[o+4] = a[ao+4] ^ c
			dest[o+5] = a[ao+5] ^ c
			dest[o+6] = a[ao+6] ^ c
			dest[o+7] = a[ao+7] ^ c
			dest[o+8] = a[ao+8] ^ c
			dest[o+9] = a[ao+9] ^ c
			dest[o+10] = a[ao+10] ^ c
			dest[o+11] = a[ao+11] ^ c
			dest[o+12] = a[ao+12] ^ c
			dest[o+13] = a[ao+13] ^ c
			dest[o+14] = a[ao+14] ^ c
			dest[o+15] = a[ao+15] ^ c
			dest[o+16] = a[ao+16] ^ c
		else
			return a[ao+1] ^ c, a[ao+2] ^ c, a[ao+3] ^ c, a[ao+4] ^ c, a[ao+5] ^ c, a[ao+6] ^ c, a[ao+7] ^ c, a[ao+8] ^ c, a[ao+9] ^ c, a[ao+10] ^ c, a[ao+11] ^ c, a[ao+12] ^ c, a[ao+13] ^ c, a[ao+14] ^ c, a[ao+15] ^ c, a[ao+16] ^ c
		end
	end
	
	---Negate a 2x2 matrix
	function M.negate_mat2(a)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return -a[1],-a[2],-a[3],-a[4]
	end
	
	---Negate a 2x2 matrix in a slice
	function M.negate_mat2_ex(a, a_index) end
	
	---Negate a 2x2 matrix in a slice and store the result in a destination
	function M.negate_mat2_ex(a, a_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local ao = a_index
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao])
		else
			return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao]
		end
	end
	
	---Negate a 3x3 matrix
	function M.negate_mat3(a)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return -a[1],-a[2],-a[3],-a[4],-a[5],-a[6],-a[7],-a[8],-a[9]
	end
	
	---Negate a 3x3 matrix in a slice
	function M.negate_mat3_ex(a, a_index) end
	
	---Negate a 3x3 matrix in a slice and store the result in a destination
	function M.negate_mat3_ex(a, a_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local ao = a_index
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao])
		else
			return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao]
		end
	end
	
	---Negate a 4x4 matrix
	function M.negate_mat4(a)
		assert(a, "bad argument 'a' (expected array, got nil)")
		return -a[1],-a[2],-a[3],-a[4],-a[5],-a[6],-a[7],-a[8],-a[9],-a[10],-a[11],-a[12],-a[13],-a[14],-a[15],-a[16]
	end
	
	---Negate a 4x4 matrix in a slice
	function M.negate_mat4_ex(a, a_index) end
	
	---Negate a 4x4 matrix in a slice and store the result in a destination
	function M.negate_mat4_ex(a, a_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		local ao = a_index
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao],-a[9+ao],-a[10+ao],-a[11+ao],-a[12+ao],-a[13+ao],-a[14+ao],-a[15+ao])
		else
			return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao],-a[9+ao],-a[10+ao],-a[11+ao],-a[12+ao],-a[13+ao],-a[14+ao],-a[15+ao]
		end
	end
	
	---true if the matrices are equal (differ by epsilon or less)
	function M.equals_mat2(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return array.all_almost_equals_ex(a, 1, 4, b, 1, epsilon)
	end
	 
	---true if the matrices in a slice are equal (differ by epsilon or less)
	function M.equals_mat2_ex(a, a_index, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return array.all_almost_equals_ex(a, a_index, 4, b, b_index, epsilon)
	end
	
	---true if the matrices are equal (differ by epsilon or less)
	function M.equals_mat3(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return array.all_almost_equals_ex(a, 1, 9, b, 1, epsilon)
	end
	 
	---true if the matrices in a slice are equal (differ by epsilon or less)
	function M.equals_mat3_ex(a, a_index, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return array.all_almost_equals_ex(a, a_index, 9, b, b_index, epsilon)
	end
	
	---true if the matrices are equal (differ by epsilon or less)
	function M.equals_mat4(a, b, epsilon)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		return array.all_almost_equals_ex(a, 1, 16, b, 1, epsilon)
	end
	 
	---true if the matrices in a slice are equal (differ by epsilon or less)
	function M.equals_mat4_ex(a, a_index, b, b_index, epsilon)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return array.all_almost_equals_ex(a, a_index, 16, b, b_index, epsilon)
	end
	
	-----------------------------------------------------------
	-- Vector length, normalisation, inner product and cross product
	-----------------------------------------------------------
	
	---2d vector length (magnitude)
	function M.length_2(a1, a2)
		return math_sqrt(M.length_squared_2(a1, a2))
	end
	
	---2d vector length (magnitude)
	function M.length_vec2(v)
		assert(v, "bad argument 'v' (expected array, got nil)")
		return math_sqrt(M.length_squared_vec2(v))
	end
	
	---2d vector length (magnitude) in a slice
	function M.length_vec2_slice(v, v_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		return math_sqrt(M.length_squared_vec2_slice(v, v_index))
	end
	
	---2d vector length (magnitude) squared
	function M.length_squared_2(a1, a2)
		return a1*a1 + a2*a2
	end
	
	---2d vector length (magnitude) squared
	function M.length_squared_vec2(v)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		return v[1]*v[1] + v[2]*v[2]
	end
	
	---2d vector length (magnitude) squared in a slice
	function M.length_squared_vec2_slice(v, v_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local o = v_index - 1
		return v[1]*v[1] + v[2]*v[2]
	end
	
	---3d vector length (magnitude)
	function M.length_3(a1, a2, a3)
		return math_sqrt(M.length_squared_3(a1, a2, a3))
	end
	
	---3d vector length (magnitude)
	function M.length_vec3(v)
		assert(v, "bad argument 'v' (expected array, got nil)")
		return math_sqrt(M.length_squared_vec3(v))
	end
	
	---3d vector length (magnitude) in a slice
	function M.length_vec3_slice(v, v_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		return math_sqrt(M.length_squared_vec3_slice(v, v_index))
	end
	
	---3d vector length (magnitude) squared
	function M.length_squared_3(a1, a2, a3)
		return a1*a1 + a2*a2 + a3*a3
	end
	
	---3d vector length (magnitude) squared
	function M.length_squared_vec3(v)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		return v[1]*v[1] + v[2]*v[2] + v[3]*v[3]
	end
	
	---3d vector length (magnitude) squared in a slice
	function M.length_squared_vec3_slice(v, v_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local o = v_index - 1
		return v[1]*v[1] + v[2]*v[2] + v[3]*v[3]
	end
	
	---4d vector length (magnitude)
	function M.length_4(a1, a2, a3, a4)
		return math_sqrt(M.length_squared_4(a1, a2, a3, a4))
	end
	
	---4d vector length (magnitude)
	function M.length_vec4(v)
		assert(v, "bad argument 'v' (expected array, got nil)")
		return math_sqrt(M.length_squared_vec4(v))
	end
	
	---4d vector length (magnitude) in a slice
	function M.length_vec4_slice(v, v_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		return math_sqrt(M.length_squared_vec4_slice(v, v_index))
	end
	
	---4d vector length (magnitude) squared
	function M.length_squared_4(a1, a2, a3, a4)
		return a1*a1 + a2*a2 + a3*a3 + a4*a4
	end
	
	---4d vector length (magnitude) squared
	function M.length_squared_vec4(v)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		return v[1]*v[1] + v[2]*v[2] + v[3]*v[3] + v[4]*v[4]
	end
	
	---4d vector length (magnitude) squared in a slice
	function M.length_squared_vec4_slice(v, v_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local o = v_index - 1
		return v[1]*v[1] + v[2]*v[2] + v[3]*v[3] + v[4]*v[4]
	end
	
	---Normalise 2d vector
	function M.normalise_2(v1, v2)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		local len = M.length_2(v1, v2)
		return v1/len, v2/len
	end
	
	---Normalise 2d vector
	function M.normalise_vec2(v)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local len = M.length_vec2(v)
		return v[1]/len, v[2]/len
	end
	
	---Normalise 2d vector in a slice
	function M.normalise_vec2_ex(v, v_index) end
	
	---Normalise 2d vector in a slice into a destination
	function M.normalise_vec2_ex(v, v_index, dest, dest_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local len = M.length_vec2_slice(v, v_index)
		local vo = v_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_2(dest, dest_index or 1, v[vo+1]/len, v[vo+2]/len)
		else
			return v[vo+1]/len, v[vo+2]/len
		end
	end
	
	---Normalise 3d vector
	function M.normalise_3(v1, v2, v3)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		local len = M.length_3(v1, v2, v3)
		return v1/len, v2/len, v3/len
	end
	
	---Normalise 3d vector
	function M.normalise_vec3(v)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local len = M.length_vec3(v)
		return v[1]/len, v[2]/len, v[3]/len
	end
	
	---Normalise 3d vector in a slice
	function M.normalise_vec3_ex(v, v_index) end
	
	---Normalise 3d vector in a slice into a destination
	function M.normalise_vec3_ex(v, v_index, dest, dest_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local len = M.length_vec3_slice(v, v_index)
		local vo = v_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_3(dest, dest_index or 1, v[vo+1]/len, v[vo+2]/len, v[vo+3]/len)
		else
			return v[vo+1]/len, v[vo+2]/len, v[vo+3]/len
		end
	end
	
	---Normalise 4d vector
	function M.normalise_4(v1, v2, v3, v4)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		assert(v4, "bad argument 'v4' (expected number, got nil)")
		local len = M.length_4(v1, v2, v3, v4)
		return v1/len, v2/len, v3/len, v4/len
	end
	
	---Normalise 4d vector
	function M.normalise_vec4(v)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local len = M.length_vec4(v)
		return v[1]/len, v[2]/len, v[3]/len, v[4]/len
	end
	
	---Normalise 4d vector in a slice
	function M.normalise_vec4_ex(v, v_index) end
	
	---Normalise 4d vector in a slice into a destination
	function M.normalise_vec4_ex(v, v_index, dest, dest_index)
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local len = M.length_vec4_slice(v, v_index)
		local vo = v_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, v[vo+1]/len, v[vo+2]/len, v[vo+3]/len, v[vo+4]/len)
		else
			return v[vo+1]/len, v[vo+2]/len, v[vo+3]/len, v[vo+4]/len
		end
	end
	
	---Inner product of 2d vectors
	function M.inner_product_2(a1, a2, b1, b2)
		return a1*b1 + a2*b2
	end
	
	---Inner product of 3d vectors
	function M.inner_product_3(a1, a2, a3, b1, b2, b3)
		return a1*b1 + a2*b2 + a3*b3
	end
	
	---Inner product of 2d vector
	function M.inner_product_vec2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1]+a[2]*b[2]
	end
	
	---Inner product of 2d vector in a slice
	function M.inner_product_vec2_slice(a, a_index, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		return a[ao+1]*b[bo+1]+a[ao+2]*b[bo+2]
	end
	
	---Inner product of 3d vector
	function M.inner_product_vec3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
	end
	
	---Inner product of 3d vector in a slice
	function M.inner_product_vec3_slice(a, a_index, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		return a[ao+1]*b[bo+1]+a[ao+2]*b[bo+2]+a[ao+3]*b[bo+3]
	end
	
	---Inner product of 4d vector
	function M.inner_product_vec4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4]
	end
	
	---Inner product of 4d vector in a slice
	function M.inner_product_vec4_slice(a, a_index, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		return a[ao+1]*b[bo+1]+a[ao+2]*b[bo+2]+a[ao+3]*b[bo+3]+a[ao+4]*b[bo+4]
	end
	
	---Cross product of 3d vector
	function M.cross_product_tuple3(ax, ay, az, bx, by, bz)
		return ay*bz - az*by, az*bx - ax*bz, ax*by - ay*bx
	end
	
	---Cross product of 3d vector
	function M.cross_product_vec3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[2]*b[3] - a[3]*b[2],
			a[3]*b[1] - a[1]*b[3],
			a[1]*b[2] - a[2]*b[1]
	end
	
	---Cross product of 3d vector in a slice
	function M.cross_product_vec3_ex(a, a_index, b, b_index) end
	
	---Cross product of 3d vector in a slice into a destination
	function M.cross_product_vec3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local bo = b_index - 1
		local x, y, z = a[ao+2]*b[bo+3] - a[ao+3]*b[bo+2],
			a[ao+3]*b[bo+1] - a[ao+1]*b[bo+3],
			a[ao+1]*b[bo+2] - a[ao+2]*b[bo+1]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_3(dest, dest_index or 1, x, y, z)
		else
			return x, y, z
		end
	end
	
	--------------------------------------------------------------------------------
	-- Matrix operations
	--------------------------------------------------------------------------------
	
	---Transpose a 1x1 matrix and return a 1x1 matrix
	function M.transpose_mat1(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1]
	end
	
	---Transpose a 1x1 matrix and return a 1x1 matrix
	function M.transpose_mat1x1(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1]
	end
	
	---Transpose a 2x1 matrix and return a 1x2 matrix
	function M.transpose_mat2x1(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[2]
	end
	
	---Transpose a 3x1 matrix and return a 1x3 matrix
	function M.transpose_mat3x1(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[2], src[3]
	end
	
	---Transpose a 4x1 matrix and return a 1x4 matrix
	function M.transpose_mat4x1(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[2], src[3], src[4]
	end
	
	---Transpose a 1x2 matrix and return a 2x1 matrix
	function M.transpose_mat1x2(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[2]
	end
	
	---Transpose a 2x2 matrix and return a 2x2 matrix
	function M.transpose_mat2(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[3], src[2], src[4]
	end
	
	---Transpose a 2x2 matrix and return a 2x2 matrix
	function M.transpose_mat2x2(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[3], src[2], src[4]
	end
	
	---Transpose a 3x2 matrix and return a 2x3 matrix
	function M.transpose_mat3x2(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[3], src[5], src[2], src[4], src[6]
	end
	
	---Transpose a 4x2 matrix and return a 2x4 matrix
	function M.transpose_mat4x2(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[3], src[5], src[7], src[2], src[4], src[6], src[8]
	end
	
	---Transpose a 1x3 matrix and return a 3x1 matrix
	function M.transpose_mat1x3(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[2], src[3]
	end
	
	---Transpose a 2x3 matrix and return a 3x2 matrix
	function M.transpose_mat2x3(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[4], src[2], src[5], src[3], src[6]
	end
	
	---Transpose a 3x3 matrix and return a 3x3 matrix
	function M.transpose_mat3(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[4], src[7], src[2], src[5], src[8], src[3], src[6], src[9]
	end
	
	---Transpose a 3x3 matrix and return a 3x3 matrix
	function M.transpose_mat3x3(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[4], src[7], src[2], src[5], src[8], src[3], src[6], src[9]
	end
	
	---Transpose a 4x3 matrix and return a 3x4 matrix
	function M.transpose_mat4x3(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[4], src[7], src[10], src[2], src[5], src[8], src[11], src[3], src[6], src[9], src[12]
	end
	
	---Transpose a 1x4 matrix and return a 4x1 matrix
	function M.transpose_mat1x4(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[2], src[3], src[4]
	end
	
	---Transpose a 2x4 matrix and return a 4x2 matrix
	function M.transpose_mat2x4(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[5], src[2], src[6], src[3], src[7], src[4], src[8]
	end
	
	---Transpose a 3x4 matrix and return a 4x3 matrix
	function M.transpose_mat3x4(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[5], src[9], src[2], src[6], src[10], src[3], src[7], src[11], src[4], src[8], src[12]
	end
	
	---Transpose a 4x4 matrix and return a 4x4 matrix
	function M.transpose_mat4(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[5], src[9], src[13], src[2], src[6], src[10], src[14], src[3], src[7], src[11], src[15], src[4], src[8], src[12], src[16]
	end
	
	---Transpose a 4x4 matrix and return a 4x4 matrix
	function M.transpose_mat4x4(src)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return src[1], src[5], src[9], src[13], src[2], src[6], src[10], src[14], src[3], src[7], src[11], src[15], src[4], src[8], src[12], src[16]
	end
	
	---Transpose a 2x2 matrix and return a 2x2 matrix
	function M.transpose_mat2_ex(src, src_index) end
	
	---Transpose a 2x2 matrix into a 2x2 matrix in a destination
	function M.transpose_mat2_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, src[so+1], src[so+3], src[so+2], src[so+4])
		else
			return src[so+1], src[so+3], src[so+2], src[so+4]
		end
	end
	
	---Transpose a 2x2 matrix and return a 2x2 matrix
	function M.transpose_mat2x2_ex(src, src_index) end
	
	---Transpose a 2x2 matrix into a 2x2 matrix in a destination
	function M.transpose_mat2x2_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, src[so+1], src[so+3], src[so+2], src[so+4])
		else
			return src[so+1], src[so+3], src[so+2], src[so+4]
		end
	end
	
	---Transpose a 3x2 matrix and return a 2x3 matrix
	function M.transpose_mat3x2_ex(src, src_index) end
	
	---Transpose a 3x2 matrix into a 2x3 matrix in a destination
	function M.transpose_mat3x2_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_6(dest, dest_index or 1, src[so+1], src[so+3], src[so+5], src[so+2], src[so+4], src[so+6])
		else
			return src[so+1], src[so+3], src[so+5], src[so+2], src[so+4], src[so+6]
		end
	end
	
	---Transpose a 4x2 matrix and return a 2x4 matrix
	function M.transpose_mat4x2_ex(src, src_index) end
	
	---Transpose a 4x2 matrix into a 2x4 matrix in a destination
	function M.transpose_mat4x2_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_8(dest, dest_index or 1, src[so+1], src[so+3], src[so+5], src[so+7], src[so+2], src[so+4], src[so+6], src[so+8])
		else
			return src[so+1], src[so+3], src[so+5], src[so+7], src[so+2], src[so+4], src[so+6], src[so+8]
		end
	end
	
	---Transpose a 2x3 matrix and return a 3x2 matrix
	function M.transpose_mat2x3_ex(src, src_index) end
	
	---Transpose a 2x3 matrix into a 3x2 matrix in a destination
	function M.transpose_mat2x3_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_6(dest, dest_index or 1, src[so+1], src[so+4], src[so+2], src[so+5], src[so+3], src[so+6])
		else
			return src[so+1], src[so+4], src[so+2], src[so+5], src[so+3], src[so+6]
		end
	end
	
	---Transpose a 3x3 matrix and return a 3x3 matrix
	function M.transpose_mat3_ex(src, src_index) end
	
	---Transpose a 3x3 matrix into a 3x3 matrix in a destination
	function M.transpose_mat3_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9])
		else
			return src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9]
		end
	end
	
	---Transpose a 3x3 matrix and return a 3x3 matrix
	function M.transpose_mat3x3_ex(src, src_index) end
	
	---Transpose a 3x3 matrix into a 3x3 matrix in a destination
	function M.transpose_mat3x3_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9])
		else
			return src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9]
		end
	end
	
	---Transpose a 4x3 matrix and return a 3x4 matrix
	function M.transpose_mat4x3_ex(src, src_index) end
	
	---Transpose a 4x3 matrix into a 3x4 matrix in a destination
	function M.transpose_mat4x3_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_12(dest, dest_index or 1, src[so+1], src[so+4], src[so+7], src[so+10], src[so+2], src[so+5], src[so+8], src[so+11], src[so+3], src[so+6], src[so+9], src[so+12])
		else
			return src[so+1], src[so+4], src[so+7], src[so+10], src[so+2], src[so+5], src[so+8], src[so+11], src[so+3], src[so+6], src[so+9], src[so+12]
		end
	end
	
	---Transpose a 2x4 matrix and return a 4x2 matrix
	function M.transpose_mat2x4_ex(src, src_index) end
	
	---Transpose a 2x4 matrix into a 4x2 matrix in a destination
	function M.transpose_mat2x4_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_8(dest, dest_index or 1, src[so+1], src[so+5], src[so+2], src[so+6], src[so+3], src[so+7], src[so+4], src[so+8])
		else
			return src[so+1], src[so+5], src[so+2], src[so+6], src[so+3], src[so+7], src[so+4], src[so+8]
		end
	end
	
	---Transpose a 3x4 matrix and return a 4x3 matrix
	function M.transpose_mat3x4_ex(src, src_index) end
	
	---Transpose a 3x4 matrix into a 4x3 matrix in a destination
	function M.transpose_mat3x4_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_12(dest, dest_index or 1, src[so+1], src[so+5], src[so+9], src[so+2], src[so+6], src[so+10], src[so+3], src[so+7], src[so+11], src[so+4], src[so+8], src[so+12])
		else
			return src[so+1], src[so+5], src[so+9], src[so+2], src[so+6], src[so+10], src[so+3], src[so+7], src[so+11], src[so+4], src[so+8], src[so+12]
		end
	end
	
	---Transpose a 4x4 matrix and return a 4x4 matrix
	function M.transpose_mat4_ex(src, src_index) end
	
	---Transpose a 4x4 matrix into a 4x4 matrix in a destination
	function M.transpose_mat4_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16])
		else
			return src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16]
		end
	end
	
	---Transpose a 4x4 matrix and return a 4x4 matrix
	function M.transpose_mat4x4_ex(src, src_index) end
	
	---Transpose a 4x4 matrix into a 4x4 matrix in a destination
	function M.transpose_mat4x4_ex(src, src_index, dest, dest_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local so = src_index - 1
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16])
		else
			return src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16]
		end
	end
	
	---Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix
	---
	function M.matmul_mat1x1_mat1x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1]
	end
	
	---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix
	---
	function M.matmul_mat1x1_mat1x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x1_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
		else
			return a[ao+1]*b[bo+1]
		end
	end
	
	---Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix
	---
	function M.matmul_mat1_mat1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1]
	end
	
	---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix
	---
	function M.matmul_mat1_mat1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1_mat1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
		else
			return a[ao+1]*b[bo+1]
		end
	end
	
	---Multiply a 1x1 matrix with a 2x1 matrix and return a 2x1 matrix
	---
	function M.matmul_mat1x1_mat2x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[1]*b[2]
	end
	
	---Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix
	---
	function M.matmul_mat1x1_mat2x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x1_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+1]*b[bo+2]
		else
			return a[ao+1]*b[bo+1], a[ao+1]*b[bo+2]
		end
	end
	
	---Multiply a 1x1 matrix with a 3x1 matrix and return a 3x1 matrix
	---
	function M.matmul_mat1x1_mat3x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[1]*b[2], a[1]*b[3]
	end
	
	---Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix
	---
	function M.matmul_mat1x1_mat3x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x1_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+1]*b[bo+2]
			dest[o+3] = a[ao+1]*b[bo+3]
		else
			return a[ao+1]*b[bo+1], a[ao+1]*b[bo+2], a[ao+1]*b[bo+3]
		end
	end
	
	---Multiply a 1x1 matrix with a 4x1 matrix and return a 4x1 matrix
	---
	function M.matmul_mat1x1_mat4x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[1]*b[2], a[1]*b[3], a[1]*b[4]
	end
	
	---Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix
	---
	function M.matmul_mat1x1_mat4x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x1_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+1]*b[bo+2]
			dest[o+3] = a[ao+1]*b[bo+3]
			dest[o+4] = a[ao+1]*b[bo+4]
		else
			return a[ao+1]*b[bo+1], a[ao+1]*b[bo+2], a[ao+1]*b[bo+3], a[ao+1]*b[bo+4]
		end
	end
	
	---Multiply a 2x1 matrix with a 1x2 matrix and return a 1x1 matrix
	---
	function M.matmul_mat2x1_mat1x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2]
	end
	
	---Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix
	---
	function M.matmul_mat2x1_mat1x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x1_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
		end
	end
	
	---Multiply a 2x1 matrix with a 2x2 matrix and return a 2x1 matrix
	---
	function M.matmul_mat2x1_mat2x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2], a[1]*b[3] + a[2]*b[4]
	end
	
	---Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix
	---
	function M.matmul_mat2x1_mat2x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x1_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
			dest[o+2] = a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4]
		end
	end
	
	---Multiply a 2x1 matrix with a 3x2 matrix and return a 3x1 matrix
	---
	function M.matmul_mat2x1_mat3x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2], a[1]*b[3] + a[2]*b[4], a[1]*b[5] + a[2]*b[6]
	end
	
	---Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix
	---
	function M.matmul_mat2x1_mat3x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x1_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
			dest[o+2] = a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4]
			dest[o+3] = a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6]
		end
	end
	
	---Multiply a 2x1 matrix with a 4x2 matrix and return a 4x1 matrix
	---
	function M.matmul_mat2x1_mat4x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2], a[1]*b[3] + a[2]*b[4], a[1]*b[5] + a[2]*b[6], a[1]*b[7] + a[2]*b[8]
	end
	
	---Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix
	---
	function M.matmul_mat2x1_mat4x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x1_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
			dest[o+2] = a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4]
			dest[o+3] = a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6]
			dest[o+4] = a[ao+1]*b[bo+7] + a[ao+2]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6], a[ao+1]*b[bo+7] + a[ao+2]*b[bo+8]
		end
	end
	
	---Multiply a 3x1 matrix with a 1x3 matrix and return a 1x1 matrix
	---
	function M.matmul_mat3x1_mat1x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
	end
	
	---Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix
	---
	function M.matmul_mat3x1_mat1x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x1_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
		end
	end
	
	---Multiply a 3x1 matrix with a 2x3 matrix and return a 2x1 matrix
	---
	function M.matmul_mat3x1_mat2x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3], a[1]*b[4] + a[2]*b[5] + a[3]*b[6]
	end
	
	---Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix
	---
	function M.matmul_mat3x1_mat2x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x1_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
			dest[o+2] = a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6]
		end
	end
	
	---Multiply a 3x1 matrix with a 3x3 matrix and return a 3x1 matrix
	---
	function M.matmul_mat3x1_mat3x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3], a[1]*b[4] + a[2]*b[5] + a[3]*b[6],
		a[1]*b[7] + a[2]*b[8] + a[3]*b[9]
	end
	
	---Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix
	---
	function M.matmul_mat3x1_mat3x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x1_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
			dest[o+2] = a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6]
			dest[o+3] = a[ao+1]*b[bo+7] + a[ao+2]*b[bo+8] + a[ao+3]*b[bo+9]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+2]*b[bo+8] + a[ao+3]*b[bo+9]
		end
	end
	
	---Multiply a 3x1 matrix with a 4x3 matrix and return a 4x1 matrix
	---
	function M.matmul_mat3x1_mat4x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3], a[1]*b[4] + a[2]*b[5] + a[3]*b[6],
		a[1]*b[7] + a[2]*b[8] + a[3]*b[9], a[1]*b[10] + a[2]*b[11] + a[3]*b[12]
	end
	
	---Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix
	---
	function M.matmul_mat3x1_mat4x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x1_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
			dest[o+2] = a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6]
			dest[o+3] = a[ao+1]*b[bo+7] + a[ao+2]*b[bo+8] + a[ao+3]*b[bo+9]
			dest[o+4] = a[ao+1]*b[bo+10] + a[ao+2]*b[bo+11] + a[ao+3]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+2]*b[bo+8] + a[ao+3]*b[bo+9],
				a[ao+1]*b[bo+10] + a[ao+2]*b[bo+11] + a[ao+3]*b[bo+12]
		end
	end
	
	---Multiply a 4x1 matrix with a 1x4 matrix and return a 1x1 matrix
	---
	function M.matmul_mat4x1_mat1x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
	end
	
	---Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix
	---
	function M.matmul_mat4x1_mat1x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x1_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
		end
	end
	
	---Multiply a 4x1 matrix with a 2x4 matrix and return a 2x1 matrix
	---
	function M.matmul_mat4x1_mat2x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4],
		a[1]*b[5] + a[2]*b[6] + a[3]*b[7] + a[4]*b[8]
	end
	
	---Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix
	---
	function M.matmul_mat4x1_mat2x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x1_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+2] = a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8]
		end
	end
	
	---Multiply a 4x1 matrix with a 3x4 matrix and return a 3x1 matrix
	---
	function M.matmul_mat4x1_mat3x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4],
		a[1]*b[5] + a[2]*b[6] + a[3]*b[7] + a[4]*b[8],
		a[1]*b[9] + a[2]*b[10] + a[3]*b[11] + a[4]*b[12]
	end
	
	---Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix
	---
	function M.matmul_mat4x1_mat3x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x1_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+2] = a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8]
			dest[o+3] = a[ao+1]*b[bo+9] + a[ao+2]*b[bo+10] + a[ao+3]*b[bo+11] + a[ao+4]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+2]*b[bo+10] + a[ao+3]*b[bo+11] + a[ao+4]*b[bo+12]
		end
	end
	
	---Multiply a 4x1 matrix with a 4x4 matrix and return a 4x1 matrix
	---
	function M.matmul_mat4x1_mat4x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4],
		a[1]*b[5] + a[2]*b[6] + a[3]*b[7] + a[4]*b[8],
		a[1]*b[9] + a[2]*b[10] + a[3]*b[11] + a[4]*b[12],
		a[1]*b[13] + a[2]*b[14] + a[3]*b[15] + a[4]*b[16]
	end
	
	---Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix
	---
	function M.matmul_mat4x1_mat4x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x1_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+2] = a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8]
			dest[o+3] = a[ao+1]*b[bo+9] + a[ao+2]*b[bo+10] + a[ao+3]*b[bo+11] + a[ao+4]*b[bo+12]
			dest[o+4] = a[ao+1]*b[bo+13] + a[ao+2]*b[bo+14] + a[ao+3]*b[bo+15] + a[ao+4]*b[bo+16]
		else
			return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+2]*b[bo+10] + a[ao+3]*b[bo+11] + a[ao+4]*b[bo+12],
				a[ao+1]*b[bo+13] + a[ao+2]*b[bo+14] + a[ao+3]*b[bo+15] + a[ao+4]*b[bo+16]
		end
	end
	
	---Multiply a 1x2 matrix with a 1x1 matrix and return a 1x2 matrix
	---
	function M.matmul_mat1x2_mat1x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1]
	end
	
	---Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix
	---
	function M.matmul_mat1x2_mat1x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x2_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1]
		end
	end
	
	---Multiply a 1x2 matrix with a 2x1 matrix and return a 2x2 matrix
	---
	function M.matmul_mat1x2_mat2x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[1]*b[2], a[2]*b[2]
	end
	
	---Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix
	---
	function M.matmul_mat1x2_mat2x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x2_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+1]*b[bo+2]
			dest[o+4] = a[ao+2]*b[bo+2]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+1]*b[bo+2], a[ao+2]*b[bo+2]
		end
	end
	
	---Multiply a 1x2 matrix with a 3x1 matrix and return a 3x2 matrix
	---
	function M.matmul_mat1x2_mat3x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[1]*b[2], a[2]*b[2], a[1]*b[3], a[2]*b[3]
	end
	
	---Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix
	---
	function M.matmul_mat1x2_mat3x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x2_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+1]*b[bo+2]
			dest[o+4] = a[ao+2]*b[bo+2]
			dest[o+5] = a[ao+1]*b[bo+3]
			dest[o+6] = a[ao+2]*b[bo+3]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+1]*b[bo+2], a[ao+2]*b[bo+2], a[ao+1]*b[bo+3], a[ao+2]*b[bo+3]
		end
	end
	
	---Multiply a 1x2 matrix with a 4x1 matrix and return a 4x2 matrix
	---
	function M.matmul_mat1x2_mat4x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[1]*b[2], a[2]*b[2], a[1]*b[3], a[2]*b[3], a[1]*b[4], a[2]*b[4]
	end
	
	---Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix
	---
	function M.matmul_mat1x2_mat4x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x2_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+1]*b[bo+2]
			dest[o+4] = a[ao+2]*b[bo+2]
			dest[o+5] = a[ao+1]*b[bo+3]
			dest[o+6] = a[ao+2]*b[bo+3]
			dest[o+7] = a[ao+1]*b[bo+4]
			dest[o+8] = a[ao+2]*b[bo+4]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+1]*b[bo+2], a[ao+2]*b[bo+2], a[ao+1]*b[bo+3],
				a[ao+2]*b[bo+3], a[ao+1]*b[bo+4], a[ao+2]*b[bo+4]
		end
	end
	
	---Multiply a 2x2 matrix with a 1x2 matrix and return a 1x2 matrix
	---
	function M.matmul_mat2x2_mat1x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2]
	end
	
	---Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix
	---
	function M.matmul_mat2x2_mat1x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x2_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
		end
	end
	
	---Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix
	---
	function M.matmul_mat2x2_mat2x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4], a[2]*b[3] + a[4]*b[4]
	end
	
	---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix
	---
	function M.matmul_mat2x2_mat2x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x2_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+3] = a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4]
			dest[o+4] = a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4]
		end
	end
	
	---Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix
	---
	function M.matmul_mat2_mat2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4], a[2]*b[3] + a[4]*b[4]
	end
	
	---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix
	---
	function M.matmul_mat2_mat2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2_mat2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+3] = a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4]
			dest[o+4] = a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4]
		end
	end
	
	---Multiply a 2x2 matrix with a 3x2 matrix and return a 3x2 matrix
	---
	function M.matmul_mat2x2_mat3x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4],
		a[2]*b[3] + a[4]*b[4], a[1]*b[5] + a[3]*b[6], a[2]*b[5] + a[4]*b[6]
	end
	
	---Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix
	---
	function M.matmul_mat2x2_mat3x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x2_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+3] = a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4]
			dest[o+4] = a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6]
			dest[o+6] = a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6], a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6]
		end
	end
	
	---Multiply a 2x2 matrix with a 4x2 matrix and return a 4x2 matrix
	---
	function M.matmul_mat2x2_mat4x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4],
		a[2]*b[3] + a[4]*b[4], a[1]*b[5] + a[3]*b[6], a[2]*b[5] + a[4]*b[6],
		a[1]*b[7] + a[3]*b[8], a[2]*b[7] + a[4]*b[8]
	end
	
	---Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix
	---
	function M.matmul_mat2x2_mat4x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x2_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+3] = a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4]
			dest[o+4] = a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6]
			dest[o+6] = a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6]
			dest[o+7] = a[ao+1]*b[bo+7] + a[ao+3]*b[bo+8]
			dest[o+8] = a[ao+2]*b[bo+7] + a[ao+4]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+3]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6], a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+3]*b[bo+8], a[ao+2]*b[bo+7] + a[ao+4]*b[bo+8]
		end
	end
	
	---Multiply a 3x2 matrix with a 1x3 matrix and return a 1x2 matrix
	---
	function M.matmul_mat3x2_mat1x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3]
	end
	
	---Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix
	---
	function M.matmul_mat3x2_mat1x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x2_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
		end
	end
	
	---Multiply a 3x2 matrix with a 2x3 matrix and return a 2x2 matrix
	---
	function M.matmul_mat3x2_mat2x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3],
		a[1]*b[4] + a[3]*b[5] + a[5]*b[6], a[2]*b[4] + a[4]*b[5] + a[6]*b[6]
	end
	
	---Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix
	---
	function M.matmul_mat3x2_mat2x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x2_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
			dest[o+3] = a[ao+1]*b[bo+4] + a[ao+3]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+4] = a[ao+2]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+6]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+3]*b[bo+5] + a[ao+5]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+6]*b[bo+6]
		end
	end
	
	---Multiply a 3x2 matrix with a 3x3 matrix and return a 3x2 matrix
	---
	function M.matmul_mat3x2_mat3x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3],
		a[1]*b[4] + a[3]*b[5] + a[5]*b[6], a[2]*b[4] + a[4]*b[5] + a[6]*b[6],
		a[1]*b[7] + a[3]*b[8] + a[5]*b[9], a[2]*b[7] + a[4]*b[8] + a[6]*b[9]
	end
	
	---Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix
	---
	function M.matmul_mat3x2_mat3x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x2_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
			dest[o+3] = a[ao+1]*b[bo+4] + a[ao+3]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+4] = a[ao+2]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+6]*b[bo+6]
			dest[o+5] = a[ao+1]*b[bo+7] + a[ao+3]*b[bo+8] + a[ao+5]*b[bo+9]
			dest[o+6] = a[ao+2]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+6]*b[bo+9]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+3]*b[bo+5] + a[ao+5]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+6]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+3]*b[bo+8] + a[ao+5]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+6]*b[bo+9]
		end
	end
	
	---Multiply a 3x2 matrix with a 4x3 matrix and return a 4x2 matrix
	---
	function M.matmul_mat3x2_mat4x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3],
		a[1]*b[4] + a[3]*b[5] + a[5]*b[6], a[2]*b[4] + a[4]*b[5] + a[6]*b[6],
		a[1]*b[7] + a[3]*b[8] + a[5]*b[9], a[2]*b[7] + a[4]*b[8] + a[6]*b[9],
		a[1]*b[10] + a[3]*b[11] + a[5]*b[12], a[2]*b[10] + a[4]*b[11] + a[6]*b[12]
	end
	
	---Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix
	---
	function M.matmul_mat3x2_mat4x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x2_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
			dest[o+3] = a[ao+1]*b[bo+4] + a[ao+3]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+4] = a[ao+2]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+6]*b[bo+6]
			dest[o+5] = a[ao+1]*b[bo+7] + a[ao+3]*b[bo+8] + a[ao+5]*b[bo+9]
			dest[o+6] = a[ao+2]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+6]*b[bo+9]
			dest[o+7] = a[ao+1]*b[bo+10] + a[ao+3]*b[bo+11] + a[ao+5]*b[bo+12]
			dest[o+8] = a[ao+2]*b[bo+10] + a[ao+4]*b[bo+11] + a[ao+6]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+3]*b[bo+5] + a[ao+5]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+6]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+3]*b[bo+8] + a[ao+5]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+6]*b[bo+9],
				a[ao+1]*b[bo+10] + a[ao+3]*b[bo+11] + a[ao+5]*b[bo+12],
				a[ao+2]*b[bo+10] + a[ao+4]*b[bo+11] + a[ao+6]*b[bo+12]
		end
	end
	
	---Multiply a 4x2 matrix with a 1x4 matrix and return a 1x2 matrix
	---
	function M.matmul_mat4x2_mat1x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
		a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4]
	end
	
	---Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix
	---
	function M.matmul_mat4x2_mat1x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x2_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
		end
	end
	
	---Multiply a 4x2 matrix with a 2x4 matrix and return a 2x2 matrix
	---
	function M.matmul_mat4x2_mat2x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
		a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4],
		a[1]*b[5] + a[3]*b[6] + a[5]*b[7] + a[7]*b[8],
		a[2]*b[5] + a[4]*b[6] + a[6]*b[7] + a[8]*b[8]
	end
	
	---Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix
	---
	function M.matmul_mat4x2_mat2x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x2_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
			dest[o+3] = a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6] + a[ao+5]*b[bo+7] + a[ao+7]*b[bo+8]
			dest[o+4] = a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+6]*b[bo+7] + a[ao+8]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6] + a[ao+5]*b[bo+7] + a[ao+7]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+6]*b[bo+7] + a[ao+8]*b[bo+8]
		end
	end
	
	---Multiply a 4x2 matrix with a 3x4 matrix and return a 3x2 matrix
	---
	function M.matmul_mat4x2_mat3x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
		a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4],
		a[1]*b[5] + a[3]*b[6] + a[5]*b[7] + a[7]*b[8],
		a[2]*b[5] + a[4]*b[6] + a[6]*b[7] + a[8]*b[8],
		a[1]*b[9] + a[3]*b[10] + a[5]*b[11] + a[7]*b[12],
		a[2]*b[9] + a[4]*b[10] + a[6]*b[11] + a[8]*b[12]
	end
	
	---Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix
	---
	function M.matmul_mat4x2_mat3x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x2_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
			dest[o+3] = a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6] + a[ao+5]*b[bo+7] + a[ao+7]*b[bo+8]
			dest[o+4] = a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+6]*b[bo+7] + a[ao+8]*b[bo+8]
			dest[o+5] = a[ao+1]*b[bo+9] + a[ao+3]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+7]*b[bo+12]
			dest[o+6] = a[ao+2]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+8]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6] + a[ao+5]*b[bo+7] + a[ao+7]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+6]*b[bo+7] + a[ao+8]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+3]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+7]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+8]*b[bo+12]
		end
	end
	
	---Multiply a 4x2 matrix with a 4x4 matrix and return a 4x2 matrix
	---
	function M.matmul_mat4x2_mat4x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
		a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4],
		a[1]*b[5] + a[3]*b[6] + a[5]*b[7] + a[7]*b[8],
		a[2]*b[5] + a[4]*b[6] + a[6]*b[7] + a[8]*b[8],
		a[1]*b[9] + a[3]*b[10] + a[5]*b[11] + a[7]*b[12],
		a[2]*b[9] + a[4]*b[10] + a[6]*b[11] + a[8]*b[12],
		a[1]*b[13] + a[3]*b[14] + a[5]*b[15] + a[7]*b[16],
		a[2]*b[13] + a[4]*b[14] + a[6]*b[15] + a[8]*b[16]
	end
	
	---Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix
	---
	function M.matmul_mat4x2_mat4x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x2_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
			dest[o+3] = a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6] + a[ao+5]*b[bo+7] + a[ao+7]*b[bo+8]
			dest[o+4] = a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+6]*b[bo+7] + a[ao+8]*b[bo+8]
			dest[o+5] = a[ao+1]*b[bo+9] + a[ao+3]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+7]*b[bo+12]
			dest[o+6] = a[ao+2]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+8]*b[bo+12]
			dest[o+7] = a[ao+1]*b[bo+13] + a[ao+3]*b[bo+14] + a[ao+5]*b[bo+15] + a[ao+7]*b[bo+16]
			dest[o+8] = a[ao+2]*b[bo+13] + a[ao+4]*b[bo+14] + a[ao+6]*b[bo+15] + a[ao+8]*b[bo+16]
		else
			return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+3]*b[bo+6] + a[ao+5]*b[bo+7] + a[ao+7]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+6]*b[bo+7] + a[ao+8]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+3]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+7]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+8]*b[bo+12],
				a[ao+1]*b[bo+13] + a[ao+3]*b[bo+14] + a[ao+5]*b[bo+15] + a[ao+7]*b[bo+16],
				a[ao+2]*b[bo+13] + a[ao+4]*b[bo+14] + a[ao+6]*b[bo+15] + a[ao+8]*b[bo+16]
		end
	end
	
	---Multiply a 1x3 matrix with a 1x1 matrix and return a 1x3 matrix
	---
	function M.matmul_mat1x3_mat1x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1]
	end
	
	---Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix
	---
	function M.matmul_mat1x3_mat1x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x3_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1]
		end
	end
	
	---Multiply a 1x3 matrix with a 2x1 matrix and return a 2x3 matrix
	---
	function M.matmul_mat1x3_mat2x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2]
	end
	
	---Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix
	---
	function M.matmul_mat1x3_mat2x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x3_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+1]*b[bo+2]
			dest[o+5] = a[ao+2]*b[bo+2]
			dest[o+6] = a[ao+3]*b[bo+2]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+1]*b[bo+2], a[ao+2]*b[bo+2], a[ao+3]*b[bo+2]
		end
	end
	
	---Multiply a 1x3 matrix with a 3x1 matrix and return a 3x3 matrix
	---
	function M.matmul_mat1x3_mat3x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[1]*b[3], a[2]*b[3], a[3]*b[3]
	end
	
	---Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix
	---
	function M.matmul_mat1x3_mat3x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x3_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+1]*b[bo+2]
			dest[o+5] = a[ao+2]*b[bo+2]
			dest[o+6] = a[ao+3]*b[bo+2]
			dest[o+7] = a[ao+1]*b[bo+3]
			dest[o+8] = a[ao+2]*b[bo+3]
			dest[o+9] = a[ao+3]*b[bo+3]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+1]*b[bo+2], a[ao+2]*b[bo+2],
				a[ao+3]*b[bo+2], a[ao+1]*b[bo+3], a[ao+2]*b[bo+3], a[ao+3]*b[bo+3]
		end
	end
	
	---Multiply a 1x3 matrix with a 4x1 matrix and return a 4x3 matrix
	---
	function M.matmul_mat1x3_mat4x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[1]*b[3], a[2]*b[3],
		a[3]*b[3], a[1]*b[4], a[2]*b[4], a[3]*b[4]
	end
	
	---Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix
	---
	function M.matmul_mat1x3_mat4x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x3_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+1]*b[bo+2]
			dest[o+5] = a[ao+2]*b[bo+2]
			dest[o+6] = a[ao+3]*b[bo+2]
			dest[o+7] = a[ao+1]*b[bo+3]
			dest[o+8] = a[ao+2]*b[bo+3]
			dest[o+9] = a[ao+3]*b[bo+3]
			dest[o+10] = a[ao+1]*b[bo+4]
			dest[o+11] = a[ao+2]*b[bo+4]
			dest[o+12] = a[ao+3]*b[bo+4]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+1]*b[bo+2], a[ao+2]*b[bo+2],
				a[ao+3]*b[bo+2], a[ao+1]*b[bo+3], a[ao+2]*b[bo+3], a[ao+3]*b[bo+3], a[ao+1]*b[bo+4],
				a[ao+2]*b[bo+4], a[ao+3]*b[bo+4]
		end
	end
	
	---Multiply a 2x3 matrix with a 1x2 matrix and return a 1x3 matrix
	---
	function M.matmul_mat2x3_mat1x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2]
	end
	
	---Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix
	---
	function M.matmul_mat2x3_mat1x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x3_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2]
		end
	end
	
	---Multiply a 2x3 matrix with a 2x2 matrix and return a 2x3 matrix
	---
	function M.matmul_mat2x3_mat2x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2],
		a[1]*b[3] + a[4]*b[4], a[2]*b[3] + a[5]*b[4], a[3]*b[3] + a[6]*b[4]
	end
	
	---Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix
	---
	function M.matmul_mat2x3_mat2x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x3_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+4] = a[ao+1]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+2]*b[bo+3] + a[ao+5]*b[bo+4]
			dest[o+6] = a[ao+3]*b[bo+3] + a[ao+6]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+2]*b[bo+3] + a[ao+5]*b[bo+4], a[ao+3]*b[bo+3] + a[ao+6]*b[bo+4]
		end
	end
	
	---Multiply a 2x3 matrix with a 3x2 matrix and return a 3x3 matrix
	---
	function M.matmul_mat2x3_mat3x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2],
		a[1]*b[3] + a[4]*b[4], a[2]*b[3] + a[5]*b[4], a[3]*b[3] + a[6]*b[4],
		a[1]*b[5] + a[4]*b[6], a[2]*b[5] + a[5]*b[6], a[3]*b[5] + a[6]*b[6]
	end
	
	---Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix
	---
	function M.matmul_mat2x3_mat3x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x3_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+4] = a[ao+1]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+2]*b[bo+3] + a[ao+5]*b[bo+4]
			dest[o+6] = a[ao+3]*b[bo+3] + a[ao+6]*b[bo+4]
			dest[o+7] = a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6]
			dest[o+8] = a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+9] = a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+2]*b[bo+3] + a[ao+5]*b[bo+4], a[ao+3]*b[bo+3] + a[ao+6]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6], a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6],
				a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6]
		end
	end
	
	---Multiply a 2x3 matrix with a 4x2 matrix and return a 4x3 matrix
	---
	function M.matmul_mat2x3_mat4x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2],
		a[1]*b[3] + a[4]*b[4], a[2]*b[3] + a[5]*b[4], a[3]*b[3] + a[6]*b[4],
		a[1]*b[5] + a[4]*b[6], a[2]*b[5] + a[5]*b[6], a[3]*b[5] + a[6]*b[6],
		a[1]*b[7] + a[4]*b[8], a[2]*b[7] + a[5]*b[8], a[3]*b[7] + a[6]*b[8]
	end
	
	---Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix
	---
	function M.matmul_mat2x3_mat4x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x3_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+4] = a[ao+1]*b[bo+3] + a[ao+4]*b[bo+4]
			dest[o+5] = a[ao+2]*b[bo+3] + a[ao+5]*b[bo+4]
			dest[o+6] = a[ao+3]*b[bo+3] + a[ao+6]*b[bo+4]
			dest[o+7] = a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6]
			dest[o+8] = a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+9] = a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6]
			dest[o+10] = a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8]
			dest[o+11] = a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8]
			dest[o+12] = a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+4]*b[bo+4],
				a[ao+2]*b[bo+3] + a[ao+5]*b[bo+4], a[ao+3]*b[bo+3] + a[ao+6]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6], a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6],
				a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6], a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8],
				a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8], a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8]
		end
	end
	
	---Multiply a 3x3 matrix with a 1x3 matrix and return a 1x3 matrix
	---
	function M.matmul_mat3x3_mat1x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3]
	end
	
	---Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix
	---
	function M.matmul_mat3x3_mat1x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x3_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3]
		end
	end
	
	---Multiply a 3x3 matrix with a 2x3 matrix and return a 2x3 matrix
	---
	function M.matmul_mat3x3_mat2x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
		a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6]
	end
	
	---Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix
	---
	function M.matmul_mat3x3_mat2x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x3_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+4] = a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6]
			dest[o+5] = a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6]
			dest[o+6] = a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6]
		end
	end
	
	---Multiply a 3x3 matrix with a 3x3 matrix and return a 3x3 matrix
	---
	function M.matmul_mat3x3_mat3x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
		a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6],
		a[1]*b[7] + a[4]*b[8] + a[7]*b[9], a[2]*b[7] + a[5]*b[8] + a[8]*b[9],
		a[3]*b[7] + a[6]*b[8] + a[9]*b[9]
	end
	
	---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix
	---
	function M.matmul_mat3x3_mat3x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x3_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+4] = a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6]
			dest[o+5] = a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6]
			dest[o+6] = a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6]
			dest[o+7] = a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+7]*b[bo+9]
			dest[o+8] = a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+8]*b[bo+9]
			dest[o+9] = a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+9]*b[bo+9]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+7]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+8]*b[bo+9],
				a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+9]*b[bo+9]
		end
	end
	
	---Multiply a 3x3 matrix with a 3x3 matrix and return a 3x3 matrix
	---
	function M.matmul_mat3_mat3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
		a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6],
		a[1]*b[7] + a[4]*b[8] + a[7]*b[9], a[2]*b[7] + a[5]*b[8] + a[8]*b[9],
		a[3]*b[7] + a[6]*b[8] + a[9]*b[9]
	end
	
	---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix
	---
	function M.matmul_mat3_mat3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3_mat3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+4] = a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6]
			dest[o+5] = a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6]
			dest[o+6] = a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6]
			dest[o+7] = a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+7]*b[bo+9]
			dest[o+8] = a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+8]*b[bo+9]
			dest[o+9] = a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+9]*b[bo+9]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+7]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+8]*b[bo+9],
				a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+9]*b[bo+9]
		end
	end
	
	---Multiply a 3x3 matrix with a 4x3 matrix and return a 4x3 matrix
	---
	function M.matmul_mat3x3_mat4x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
		a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6],
		a[1]*b[7] + a[4]*b[8] + a[7]*b[9], a[2]*b[7] + a[5]*b[8] + a[8]*b[9],
		a[3]*b[7] + a[6]*b[8] + a[9]*b[9], a[1]*b[10] + a[4]*b[11] + a[7]*b[12],
		a[2]*b[10] + a[5]*b[11] + a[8]*b[12], a[3]*b[10] + a[6]*b[11] + a[9]*b[12]
	end
	
	---Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix
	---
	function M.matmul_mat3x3_mat4x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x3_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+4] = a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6]
			dest[o+5] = a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6]
			dest[o+6] = a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6]
			dest[o+7] = a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+7]*b[bo+9]
			dest[o+8] = a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+8]*b[bo+9]
			dest[o+9] = a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+9]*b[bo+9]
			dest[o+10] = a[ao+1]*b[bo+10] + a[ao+4]*b[bo+11] + a[ao+7]*b[bo+12]
			dest[o+11] = a[ao+2]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+8]*b[bo+12]
			dest[o+12] = a[ao+3]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+9]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+4]*b[bo+5] + a[ao+7]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+8]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+9]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+4]*b[bo+8] + a[ao+7]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+8]*b[bo+9],
				a[ao+3]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+9]*b[bo+9],
				a[ao+1]*b[bo+10] + a[ao+4]*b[bo+11] + a[ao+7]*b[bo+12],
				a[ao+2]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+8]*b[bo+12],
				a[ao+3]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+9]*b[bo+12]
		end
	end
	
	---Multiply a 4x3 matrix with a 1x4 matrix and return a 1x3 matrix
	---
	function M.matmul_mat4x3_mat1x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3] + a[10]*b[4],
		a[2]*b[1] + a[5]*b[2] + a[8]*b[3] + a[11]*b[4],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3] + a[12]*b[4]
	end
	
	---Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix
	---
	function M.matmul_mat4x3_mat1x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x3_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4]
		end
	end
	
	---Multiply a 4x3 matrix with a 2x4 matrix and return a 2x3 matrix
	---
	function M.matmul_mat4x3_mat2x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3] + a[10]*b[4],
		a[2]*b[1] + a[5]*b[2] + a[8]*b[3] + a[11]*b[4],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3] + a[12]*b[4],
		a[1]*b[5] + a[4]*b[6] + a[7]*b[7] + a[10]*b[8],
		a[2]*b[5] + a[5]*b[6] + a[8]*b[7] + a[11]*b[8],
		a[3]*b[5] + a[6]*b[6] + a[9]*b[7] + a[12]*b[8]
	end
	
	---Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix
	---
	function M.matmul_mat4x3_mat2x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x3_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4]
			dest[o+4] = a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+7]*b[bo+7] + a[ao+10]*b[bo+8]
			dest[o+5] = a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+8]*b[bo+7] + a[ao+11]*b[bo+8]
			dest[o+6] = a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+12]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+7]*b[bo+7] + a[ao+10]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+8]*b[bo+7] + a[ao+11]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+12]*b[bo+8]
		end
	end
	
	---Multiply a 4x3 matrix with a 3x4 matrix and return a 3x3 matrix
	---
	function M.matmul_mat4x3_mat3x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3] + a[10]*b[4],
		a[2]*b[1] + a[5]*b[2] + a[8]*b[3] + a[11]*b[4],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3] + a[12]*b[4],
		a[1]*b[5] + a[4]*b[6] + a[7]*b[7] + a[10]*b[8],
		a[2]*b[5] + a[5]*b[6] + a[8]*b[7] + a[11]*b[8],
		a[3]*b[5] + a[6]*b[6] + a[9]*b[7] + a[12]*b[8],
		a[1]*b[9] + a[4]*b[10] + a[7]*b[11] + a[10]*b[12],
		a[2]*b[9] + a[5]*b[10] + a[8]*b[11] + a[11]*b[12],
		a[3]*b[9] + a[6]*b[10] + a[9]*b[11] + a[12]*b[12]
	end
	
	---Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix
	---
	function M.matmul_mat4x3_mat3x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x3_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4]
			dest[o+4] = a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+7]*b[bo+7] + a[ao+10]*b[bo+8]
			dest[o+5] = a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+8]*b[bo+7] + a[ao+11]*b[bo+8]
			dest[o+6] = a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+12]*b[bo+8]
			dest[o+7] = a[ao+1]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+7]*b[bo+11] + a[ao+10]*b[bo+12]
			dest[o+8] = a[ao+2]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+8]*b[bo+11] + a[ao+11]*b[bo+12]
			dest[o+9] = a[ao+3]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+12]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+7]*b[bo+7] + a[ao+10]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+8]*b[bo+7] + a[ao+11]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+12]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+7]*b[bo+11] + a[ao+10]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+8]*b[bo+11] + a[ao+11]*b[bo+12],
				a[ao+3]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+12]*b[bo+12]
		end
	end
	
	---Multiply a 4x3 matrix with a 4x4 matrix and return a 4x3 matrix
	---
	function M.matmul_mat4x3_mat4x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[4]*b[2] + a[7]*b[3] + a[10]*b[4],
		a[2]*b[1] + a[5]*b[2] + a[8]*b[3] + a[11]*b[4],
		a[3]*b[1] + a[6]*b[2] + a[9]*b[3] + a[12]*b[4],
		a[1]*b[5] + a[4]*b[6] + a[7]*b[7] + a[10]*b[8],
		a[2]*b[5] + a[5]*b[6] + a[8]*b[7] + a[11]*b[8],
		a[3]*b[5] + a[6]*b[6] + a[9]*b[7] + a[12]*b[8],
		a[1]*b[9] + a[4]*b[10] + a[7]*b[11] + a[10]*b[12],
		a[2]*b[9] + a[5]*b[10] + a[8]*b[11] + a[11]*b[12],
		a[3]*b[9] + a[6]*b[10] + a[9]*b[11] + a[12]*b[12],
		a[1]*b[13] + a[4]*b[14] + a[7]*b[15] + a[10]*b[16],
		a[2]*b[13] + a[5]*b[14] + a[8]*b[15] + a[11]*b[16],
		a[3]*b[13] + a[6]*b[14] + a[9]*b[15] + a[12]*b[16]
	end
	
	---Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix
	---
	function M.matmul_mat4x3_mat4x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x3_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4]
			dest[o+4] = a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+7]*b[bo+7] + a[ao+10]*b[bo+8]
			dest[o+5] = a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+8]*b[bo+7] + a[ao+11]*b[bo+8]
			dest[o+6] = a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+12]*b[bo+8]
			dest[o+7] = a[ao+1]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+7]*b[bo+11] + a[ao+10]*b[bo+12]
			dest[o+8] = a[ao+2]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+8]*b[bo+11] + a[ao+11]*b[bo+12]
			dest[o+9] = a[ao+3]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+12]*b[bo+12]
			dest[o+10] = a[ao+1]*b[bo+13] + a[ao+4]*b[bo+14] + a[ao+7]*b[bo+15] + a[ao+10]*b[bo+16]
			dest[o+11] = a[ao+2]*b[bo+13] + a[ao+5]*b[bo+14] + a[ao+8]*b[bo+15] + a[ao+11]*b[bo+16]
			dest[o+12] = a[ao+3]*b[bo+13] + a[ao+6]*b[bo+14] + a[ao+9]*b[bo+15] + a[ao+12]*b[bo+16]
		else
			return a[ao+1]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+7]*b[bo+3] + a[ao+10]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+8]*b[bo+3] + a[ao+11]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+12]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+4]*b[bo+6] + a[ao+7]*b[bo+7] + a[ao+10]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+8]*b[bo+7] + a[ao+11]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+12]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+4]*b[bo+10] + a[ao+7]*b[bo+11] + a[ao+10]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+8]*b[bo+11] + a[ao+11]*b[bo+12],
				a[ao+3]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+12]*b[bo+12],
				a[ao+1]*b[bo+13] + a[ao+4]*b[bo+14] + a[ao+7]*b[bo+15] + a[ao+10]*b[bo+16],
				a[ao+2]*b[bo+13] + a[ao+5]*b[bo+14] + a[ao+8]*b[bo+15] + a[ao+11]*b[bo+16],
				a[ao+3]*b[bo+13] + a[ao+6]*b[bo+14] + a[ao+9]*b[bo+15] + a[ao+12]*b[bo+16]
		end
	end
	
	---Multiply a 1x4 matrix with a 1x1 matrix and return a 1x4 matrix
	---
	function M.matmul_mat1x4_mat1x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1]
	end
	
	---Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix
	---
	function M.matmul_mat1x4_mat1x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x4_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+4]*b[bo+1]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+4]*b[bo+1]
		end
	end
	
	---Multiply a 1x4 matrix with a 2x1 matrix and return a 2x4 matrix
	---
	function M.matmul_mat1x4_mat2x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[4]*b[2]
	end
	
	---Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix
	---
	function M.matmul_mat1x4_mat2x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x4_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+4]*b[bo+1]
			dest[o+5] = a[ao+1]*b[bo+2]
			dest[o+6] = a[ao+2]*b[bo+2]
			dest[o+7] = a[ao+3]*b[bo+2]
			dest[o+8] = a[ao+4]*b[bo+2]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+4]*b[bo+1], a[ao+1]*b[bo+2],
				a[ao+2]*b[bo+2], a[ao+3]*b[bo+2], a[ao+4]*b[bo+2]
		end
	end
	
	---Multiply a 1x4 matrix with a 3x1 matrix and return a 3x4 matrix
	---
	function M.matmul_mat1x4_mat3x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[4]*b[2],
		a[1]*b[3], a[2]*b[3], a[3]*b[3], a[4]*b[3]
	end
	
	---Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix
	---
	function M.matmul_mat1x4_mat3x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x4_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+4]*b[bo+1]
			dest[o+5] = a[ao+1]*b[bo+2]
			dest[o+6] = a[ao+2]*b[bo+2]
			dest[o+7] = a[ao+3]*b[bo+2]
			dest[o+8] = a[ao+4]*b[bo+2]
			dest[o+9] = a[ao+1]*b[bo+3]
			dest[o+10] = a[ao+2]*b[bo+3]
			dest[o+11] = a[ao+3]*b[bo+3]
			dest[o+12] = a[ao+4]*b[bo+3]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+4]*b[bo+1], a[ao+1]*b[bo+2],
				a[ao+2]*b[bo+2], a[ao+3]*b[bo+2], a[ao+4]*b[bo+2], a[ao+1]*b[bo+3], a[ao+2]*b[bo+3],
				a[ao+3]*b[bo+3], a[ao+4]*b[bo+3]
		end
	end
	
	---Multiply a 1x4 matrix with a 4x1 matrix and return a 4x4 matrix
	---
	function M.matmul_mat1x4_mat4x1(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[4]*b[2],
		a[1]*b[3], a[2]*b[3], a[3]*b[3], a[4]*b[3], a[1]*b[4], a[2]*b[4], a[3]*b[4], a[4]*b[4]
	end
	
	---Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix
	---
	function M.matmul_mat1x4_mat4x1_ex(a, a_index, b, b_index) end
	
	---Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat1x4_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1]
			dest[o+2] = a[ao+2]*b[bo+1]
			dest[o+3] = a[ao+3]*b[bo+1]
			dest[o+4] = a[ao+4]*b[bo+1]
			dest[o+5] = a[ao+1]*b[bo+2]
			dest[o+6] = a[ao+2]*b[bo+2]
			dest[o+7] = a[ao+3]*b[bo+2]
			dest[o+8] = a[ao+4]*b[bo+2]
			dest[o+9] = a[ao+1]*b[bo+3]
			dest[o+10] = a[ao+2]*b[bo+3]
			dest[o+11] = a[ao+3]*b[bo+3]
			dest[o+12] = a[ao+4]*b[bo+3]
			dest[o+13] = a[ao+1]*b[bo+4]
			dest[o+14] = a[ao+2]*b[bo+4]
			dest[o+15] = a[ao+3]*b[bo+4]
			dest[o+16] = a[ao+4]*b[bo+4]
		else
			return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1], a[ao+4]*b[bo+1], a[ao+1]*b[bo+2],
				a[ao+2]*b[bo+2], a[ao+3]*b[bo+2], a[ao+4]*b[bo+2], a[ao+1]*b[bo+3], a[ao+2]*b[bo+3],
				a[ao+3]*b[bo+3], a[ao+4]*b[bo+3], a[ao+1]*b[bo+4], a[ao+2]*b[bo+4], a[ao+3]*b[bo+4], a[ao+4]*b[bo+4]
		end
	end
	
	---Multiply a 2x4 matrix with a 1x2 matrix and return a 1x4 matrix
	---
	function M.matmul_mat2x4_mat1x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2], a[4]*b[1] + a[8]*b[2]
	end
	
	---Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix
	---
	function M.matmul_mat2x4_mat1x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x4_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2], a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2]
		end
	end
	
	---Multiply a 2x4 matrix with a 2x2 matrix and return a 2x4 matrix
	---
	function M.matmul_mat2x4_mat2x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2],
		a[4]*b[1] + a[8]*b[2], a[1]*b[3] + a[5]*b[4], a[2]*b[3] + a[6]*b[4],
		a[3]*b[3] + a[7]*b[4], a[4]*b[3] + a[8]*b[4]
	end
	
	---Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix
	---
	function M.matmul_mat2x4_mat2x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x4_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2]
			dest[o+5] = a[ao+1]*b[bo+3] + a[ao+5]*b[bo+4]
			dest[o+6] = a[ao+2]*b[bo+3] + a[ao+6]*b[bo+4]
			dest[o+7] = a[ao+3]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+8] = a[ao+4]*b[bo+3] + a[ao+8]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2], a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+5]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+6]*b[bo+4],
				a[ao+3]*b[bo+3] + a[ao+7]*b[bo+4], a[ao+4]*b[bo+3] + a[ao+8]*b[bo+4]
		end
	end
	
	---Multiply a 2x4 matrix with a 3x2 matrix and return a 3x4 matrix
	---
	function M.matmul_mat2x4_mat3x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2],
		a[4]*b[1] + a[8]*b[2], a[1]*b[3] + a[5]*b[4], a[2]*b[3] + a[6]*b[4],
		a[3]*b[3] + a[7]*b[4], a[4]*b[3] + a[8]*b[4], a[1]*b[5] + a[5]*b[6],
		a[2]*b[5] + a[6]*b[6], a[3]*b[5] + a[7]*b[6], a[4]*b[5] + a[8]*b[6]
	end
	
	---Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix
	---
	function M.matmul_mat2x4_mat3x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x4_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2]
			dest[o+5] = a[ao+1]*b[bo+3] + a[ao+5]*b[bo+4]
			dest[o+6] = a[ao+2]*b[bo+3] + a[ao+6]*b[bo+4]
			dest[o+7] = a[ao+3]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+8] = a[ao+4]*b[bo+3] + a[ao+8]*b[bo+4]
			dest[o+9] = a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+10] = a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6]
			dest[o+11] = a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6]
			dest[o+12] = a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2], a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+5]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+6]*b[bo+4],
				a[ao+3]*b[bo+3] + a[ao+7]*b[bo+4], a[ao+4]*b[bo+3] + a[ao+8]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6], a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6],
				a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6], a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6]
		end
	end
	
	---Multiply a 2x4 matrix with a 4x2 matrix and return a 4x4 matrix
	---
	function M.matmul_mat2x4_mat4x2(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2],
		a[4]*b[1] + a[8]*b[2], a[1]*b[3] + a[5]*b[4], a[2]*b[3] + a[6]*b[4],
		a[3]*b[3] + a[7]*b[4], a[4]*b[3] + a[8]*b[4], a[1]*b[5] + a[5]*b[6],
		a[2]*b[5] + a[6]*b[6], a[3]*b[5] + a[7]*b[6], a[4]*b[5] + a[8]*b[6],
		a[1]*b[7] + a[5]*b[8], a[2]*b[7] + a[6]*b[8], a[3]*b[7] + a[7]*b[8], a[4]*b[7] + a[8]*b[8]
	end
	
	---Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix
	---
	function M.matmul_mat2x4_mat4x2_ex(a, a_index, b, b_index) end
	
	---Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat2x4_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2]
			dest[o+5] = a[ao+1]*b[bo+3] + a[ao+5]*b[bo+4]
			dest[o+6] = a[ao+2]*b[bo+3] + a[ao+6]*b[bo+4]
			dest[o+7] = a[ao+3]*b[bo+3] + a[ao+7]*b[bo+4]
			dest[o+8] = a[ao+4]*b[bo+3] + a[ao+8]*b[bo+4]
			dest[o+9] = a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6]
			dest[o+10] = a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6]
			dest[o+11] = a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6]
			dest[o+12] = a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6]
			dest[o+13] = a[ao+1]*b[bo+7] + a[ao+5]*b[bo+8]
			dest[o+14] = a[ao+2]*b[bo+7] + a[ao+6]*b[bo+8]
			dest[o+15] = a[ao+3]*b[bo+7] + a[ao+7]*b[bo+8]
			dest[o+16] = a[ao+4]*b[bo+7] + a[ao+8]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2], a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2],
				a[ao+1]*b[bo+3] + a[ao+5]*b[bo+4], a[ao+2]*b[bo+3] + a[ao+6]*b[bo+4],
				a[ao+3]*b[bo+3] + a[ao+7]*b[bo+4], a[ao+4]*b[bo+3] + a[ao+8]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6], a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6],
				a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6], a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+5]*b[bo+8], a[ao+2]*b[bo+7] + a[ao+6]*b[bo+8],
				a[ao+3]*b[bo+7] + a[ao+7]*b[bo+8], a[ao+4]*b[bo+7] + a[ao+8]*b[bo+8]
		end
	end
	
	---Multiply a 3x4 matrix with a 1x3 matrix and return a 1x4 matrix
	---
	function M.matmul_mat3x4_mat1x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3]
	end
	
	---Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix
	---
	function M.matmul_mat3x4_mat1x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x4_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3]
		end
	end
	
	---Multiply a 3x4 matrix with a 2x3 matrix and return a 2x4 matrix
	---
	function M.matmul_mat3x4_mat2x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3],
		a[1]*b[4] + a[5]*b[5] + a[9]*b[6], a[2]*b[4] + a[6]*b[5] + a[10]*b[6],
		a[3]*b[4] + a[7]*b[5] + a[11]*b[6], a[4]*b[4] + a[8]*b[5] + a[12]*b[6]
	end
	
	---Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix
	---
	function M.matmul_mat3x4_mat2x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x4_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3]
			dest[o+5] = a[ao+1]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+9]*b[bo+6]
			dest[o+6] = a[ao+2]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+10]*b[bo+6]
			dest[o+7] = a[ao+3]*b[bo+4] + a[ao+7]*b[bo+5] + a[ao+11]*b[bo+6]
			dest[o+8] = a[ao+4]*b[bo+4] + a[ao+8]*b[bo+5] + a[ao+12]*b[bo+6]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+9]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+10]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+7]*b[bo+5] + a[ao+11]*b[bo+6],
				a[ao+4]*b[bo+4] + a[ao+8]*b[bo+5] + a[ao+12]*b[bo+6]
		end
	end
	
	---Multiply a 3x4 matrix with a 3x3 matrix and return a 3x4 matrix
	---
	function M.matmul_mat3x4_mat3x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3],
		a[1]*b[4] + a[5]*b[5] + a[9]*b[6], a[2]*b[4] + a[6]*b[5] + a[10]*b[6],
		a[3]*b[4] + a[7]*b[5] + a[11]*b[6], a[4]*b[4] + a[8]*b[5] + a[12]*b[6],
		a[1]*b[7] + a[5]*b[8] + a[9]*b[9], a[2]*b[7] + a[6]*b[8] + a[10]*b[9],
		a[3]*b[7] + a[7]*b[8] + a[11]*b[9], a[4]*b[7] + a[8]*b[8] + a[12]*b[9]
	end
	
	---Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix
	---
	function M.matmul_mat3x4_mat3x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x4_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3]
			dest[o+5] = a[ao+1]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+9]*b[bo+6]
			dest[o+6] = a[ao+2]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+10]*b[bo+6]
			dest[o+7] = a[ao+3]*b[bo+4] + a[ao+7]*b[bo+5] + a[ao+11]*b[bo+6]
			dest[o+8] = a[ao+4]*b[bo+4] + a[ao+8]*b[bo+5] + a[ao+12]*b[bo+6]
			dest[o+9] = a[ao+1]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+9]*b[bo+9]
			dest[o+10] = a[ao+2]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+10]*b[bo+9]
			dest[o+11] = a[ao+3]*b[bo+7] + a[ao+7]*b[bo+8] + a[ao+11]*b[bo+9]
			dest[o+12] = a[ao+4]*b[bo+7] + a[ao+8]*b[bo+8] + a[ao+12]*b[bo+9]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+9]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+10]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+7]*b[bo+5] + a[ao+11]*b[bo+6],
				a[ao+4]*b[bo+4] + a[ao+8]*b[bo+5] + a[ao+12]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+9]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+10]*b[bo+9],
				a[ao+3]*b[bo+7] + a[ao+7]*b[bo+8] + a[ao+11]*b[bo+9],
				a[ao+4]*b[bo+7] + a[ao+8]*b[bo+8] + a[ao+12]*b[bo+9]
		end
	end
	
	---Multiply a 3x4 matrix with a 4x3 matrix and return a 4x4 matrix
	---
	function M.matmul_mat3x4_mat4x3(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3],
		a[1]*b[4] + a[5]*b[5] + a[9]*b[6], a[2]*b[4] + a[6]*b[5] + a[10]*b[6],
		a[3]*b[4] + a[7]*b[5] + a[11]*b[6], a[4]*b[4] + a[8]*b[5] + a[12]*b[6],
		a[1]*b[7] + a[5]*b[8] + a[9]*b[9], a[2]*b[7] + a[6]*b[8] + a[10]*b[9],
		a[3]*b[7] + a[7]*b[8] + a[11]*b[9], a[4]*b[7] + a[8]*b[8] + a[12]*b[9],
		a[1]*b[10] + a[5]*b[11] + a[9]*b[12], a[2]*b[10] + a[6]*b[11] + a[10]*b[12],
		a[3]*b[10] + a[7]*b[11] + a[11]*b[12], a[4]*b[10] + a[8]*b[11] + a[12]*b[12]
	end
	
	---Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix
	---
	function M.matmul_mat3x4_mat4x3_ex(a, a_index, b, b_index) end
	
	---Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat3x4_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3]
			dest[o+5] = a[ao+1]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+9]*b[bo+6]
			dest[o+6] = a[ao+2]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+10]*b[bo+6]
			dest[o+7] = a[ao+3]*b[bo+4] + a[ao+7]*b[bo+5] + a[ao+11]*b[bo+6]
			dest[o+8] = a[ao+4]*b[bo+4] + a[ao+8]*b[bo+5] + a[ao+12]*b[bo+6]
			dest[o+9] = a[ao+1]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+9]*b[bo+9]
			dest[o+10] = a[ao+2]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+10]*b[bo+9]
			dest[o+11] = a[ao+3]*b[bo+7] + a[ao+7]*b[bo+8] + a[ao+11]*b[bo+9]
			dest[o+12] = a[ao+4]*b[bo+7] + a[ao+8]*b[bo+8] + a[ao+12]*b[bo+9]
			dest[o+13] = a[ao+1]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+9]*b[bo+12]
			dest[o+14] = a[ao+2]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+10]*b[bo+12]
			dest[o+15] = a[ao+3]*b[bo+10] + a[ao+7]*b[bo+11] + a[ao+11]*b[bo+12]
			dest[o+16] = a[ao+4]*b[bo+10] + a[ao+8]*b[bo+11] + a[ao+12]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3],
				a[ao+1]*b[bo+4] + a[ao+5]*b[bo+5] + a[ao+9]*b[bo+6],
				a[ao+2]*b[bo+4] + a[ao+6]*b[bo+5] + a[ao+10]*b[bo+6],
				a[ao+3]*b[bo+4] + a[ao+7]*b[bo+5] + a[ao+11]*b[bo+6],
				a[ao+4]*b[bo+4] + a[ao+8]*b[bo+5] + a[ao+12]*b[bo+6],
				a[ao+1]*b[bo+7] + a[ao+5]*b[bo+8] + a[ao+9]*b[bo+9],
				a[ao+2]*b[bo+7] + a[ao+6]*b[bo+8] + a[ao+10]*b[bo+9],
				a[ao+3]*b[bo+7] + a[ao+7]*b[bo+8] + a[ao+11]*b[bo+9],
				a[ao+4]*b[bo+7] + a[ao+8]*b[bo+8] + a[ao+12]*b[bo+9],
				a[ao+1]*b[bo+10] + a[ao+5]*b[bo+11] + a[ao+9]*b[bo+12],
				a[ao+2]*b[bo+10] + a[ao+6]*b[bo+11] + a[ao+10]*b[bo+12],
				a[ao+3]*b[bo+10] + a[ao+7]*b[bo+11] + a[ao+11]*b[bo+12],
				a[ao+4]*b[bo+10] + a[ao+8]*b[bo+11] + a[ao+12]*b[bo+12]
		end
	end
	
	---Multiply a 4x4 matrix with a 1x4 matrix and return a 1x4 matrix
	---
	function M.matmul_mat4x4_mat1x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
		a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
		a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4]
	end
	
	---Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix
	---
	function M.matmul_mat4x4_mat1x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x4_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4]
		end
	end
	
	---Multiply a 4x4 matrix with a 2x4 matrix and return a 2x4 matrix
	---
	function M.matmul_mat4x4_mat2x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
		a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
		a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4],
		a[1]*b[5] + a[5]*b[6] + a[9]*b[7] + a[13]*b[8],
		a[2]*b[5] + a[6]*b[6] + a[10]*b[7] + a[14]*b[8],
		a[3]*b[5] + a[7]*b[6] + a[11]*b[7] + a[15]*b[8],
		a[4]*b[5] + a[8]*b[6] + a[12]*b[7] + a[16]*b[8]
	end
	
	---Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix
	---
	function M.matmul_mat4x4_mat2x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x4_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4]
			dest[o+5] = a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8]
			dest[o+6] = a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8]
			dest[o+7] = a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8]
			dest[o+8] = a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8],
				a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8]
		end
	end
	
	---Multiply a 4x4 matrix with a 3x4 matrix and return a 3x4 matrix
	---
	function M.matmul_mat4x4_mat3x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
		a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
		a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4],
		a[1]*b[5] + a[5]*b[6] + a[9]*b[7] + a[13]*b[8],
		a[2]*b[5] + a[6]*b[6] + a[10]*b[7] + a[14]*b[8],
		a[3]*b[5] + a[7]*b[6] + a[11]*b[7] + a[15]*b[8],
		a[4]*b[5] + a[8]*b[6] + a[12]*b[7] + a[16]*b[8],
		a[1]*b[9] + a[5]*b[10] + a[9]*b[11] + a[13]*b[12],
		a[2]*b[9] + a[6]*b[10] + a[10]*b[11] + a[14]*b[12],
		a[3]*b[9] + a[7]*b[10] + a[11]*b[11] + a[15]*b[12],
		a[4]*b[9] + a[8]*b[10] + a[12]*b[11] + a[16]*b[12]
	end
	
	---Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix
	---
	function M.matmul_mat4x4_mat3x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x4_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4]
			dest[o+5] = a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8]
			dest[o+6] = a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8]
			dest[o+7] = a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8]
			dest[o+8] = a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8]
			dest[o+9] = a[ao+1]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+13]*b[bo+12]
			dest[o+10] = a[ao+2]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+10]*b[bo+11] + a[ao+14]*b[bo+12]
			dest[o+11] = a[ao+3]*b[bo+9] + a[ao+7]*b[bo+10] + a[ao+11]*b[bo+11] + a[ao+15]*b[bo+12]
			dest[o+12] = a[ao+4]*b[bo+9] + a[ao+8]*b[bo+10] + a[ao+12]*b[bo+11] + a[ao+16]*b[bo+12]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8],
				a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+13]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+10]*b[bo+11] + a[ao+14]*b[bo+12],
				a[ao+3]*b[bo+9] + a[ao+7]*b[bo+10] + a[ao+11]*b[bo+11] + a[ao+15]*b[bo+12],
				a[ao+4]*b[bo+9] + a[ao+8]*b[bo+10] + a[ao+12]*b[bo+11] + a[ao+16]*b[bo+12]
		end
	end
	
	---Multiply a 4x4 matrix with a 4x4 matrix and return a 4x4 matrix
	---
	function M.matmul_mat4x4_mat4x4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
		a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
		a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4],
		a[1]*b[5] + a[5]*b[6] + a[9]*b[7] + a[13]*b[8],
		a[2]*b[5] + a[6]*b[6] + a[10]*b[7] + a[14]*b[8],
		a[3]*b[5] + a[7]*b[6] + a[11]*b[7] + a[15]*b[8],
		a[4]*b[5] + a[8]*b[6] + a[12]*b[7] + a[16]*b[8],
		a[1]*b[9] + a[5]*b[10] + a[9]*b[11] + a[13]*b[12],
		a[2]*b[9] + a[6]*b[10] + a[10]*b[11] + a[14]*b[12],
		a[3]*b[9] + a[7]*b[10] + a[11]*b[11] + a[15]*b[12],
		a[4]*b[9] + a[8]*b[10] + a[12]*b[11] + a[16]*b[12],
		a[1]*b[13] + a[5]*b[14] + a[9]*b[15] + a[13]*b[16],
		a[2]*b[13] + a[6]*b[14] + a[10]*b[15] + a[14]*b[16],
		a[3]*b[13] + a[7]*b[14] + a[11]*b[15] + a[15]*b[16],
		a[4]*b[13] + a[8]*b[14] + a[12]*b[15] + a[16]*b[16]
	end
	
	---Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix
	---
	function M.matmul_mat4x4_mat4x4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4x4_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4]
			dest[o+5] = a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8]
			dest[o+6] = a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8]
			dest[o+7] = a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8]
			dest[o+8] = a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8]
			dest[o+9] = a[ao+1]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+13]*b[bo+12]
			dest[o+10] = a[ao+2]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+10]*b[bo+11] + a[ao+14]*b[bo+12]
			dest[o+11] = a[ao+3]*b[bo+9] + a[ao+7]*b[bo+10] + a[ao+11]*b[bo+11] + a[ao+15]*b[bo+12]
			dest[o+12] = a[ao+4]*b[bo+9] + a[ao+8]*b[bo+10] + a[ao+12]*b[bo+11] + a[ao+16]*b[bo+12]
			dest[o+13] = a[ao+1]*b[bo+13] + a[ao+5]*b[bo+14] + a[ao+9]*b[bo+15] + a[ao+13]*b[bo+16]
			dest[o+14] = a[ao+2]*b[bo+13] + a[ao+6]*b[bo+14] + a[ao+10]*b[bo+15] + a[ao+14]*b[bo+16]
			dest[o+15] = a[ao+3]*b[bo+13] + a[ao+7]*b[bo+14] + a[ao+11]*b[bo+15] + a[ao+15]*b[bo+16]
			dest[o+16] = a[ao+4]*b[bo+13] + a[ao+8]*b[bo+14] + a[ao+12]*b[bo+15] + a[ao+16]*b[bo+16]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8],
				a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+13]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+10]*b[bo+11] + a[ao+14]*b[bo+12],
				a[ao+3]*b[bo+9] + a[ao+7]*b[bo+10] + a[ao+11]*b[bo+11] + a[ao+15]*b[bo+12],
				a[ao+4]*b[bo+9] + a[ao+8]*b[bo+10] + a[ao+12]*b[bo+11] + a[ao+16]*b[bo+12],
				a[ao+1]*b[bo+13] + a[ao+5]*b[bo+14] + a[ao+9]*b[bo+15] + a[ao+13]*b[bo+16],
				a[ao+2]*b[bo+13] + a[ao+6]*b[bo+14] + a[ao+10]*b[bo+15] + a[ao+14]*b[bo+16],
				a[ao+3]*b[bo+13] + a[ao+7]*b[bo+14] + a[ao+11]*b[bo+15] + a[ao+15]*b[bo+16],
				a[ao+4]*b[bo+13] + a[ao+8]*b[bo+14] + a[ao+12]*b[bo+15] + a[ao+16]*b[bo+16]
		end
	end
	
	---Multiply a 4x4 matrix with a 4x4 matrix and return a 4x4 matrix
	---
	function M.matmul_mat4_mat4(a, b)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		return a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
		a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
		a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
		a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4],
		a[1]*b[5] + a[5]*b[6] + a[9]*b[7] + a[13]*b[8],
		a[2]*b[5] + a[6]*b[6] + a[10]*b[7] + a[14]*b[8],
		a[3]*b[5] + a[7]*b[6] + a[11]*b[7] + a[15]*b[8],
		a[4]*b[5] + a[8]*b[6] + a[12]*b[7] + a[16]*b[8],
		a[1]*b[9] + a[5]*b[10] + a[9]*b[11] + a[13]*b[12],
		a[2]*b[9] + a[6]*b[10] + a[10]*b[11] + a[14]*b[12],
		a[3]*b[9] + a[7]*b[10] + a[11]*b[11] + a[15]*b[12],
		a[4]*b[9] + a[8]*b[10] + a[12]*b[11] + a[16]*b[12],
		a[1]*b[13] + a[5]*b[14] + a[9]*b[15] + a[13]*b[16],
		a[2]*b[13] + a[6]*b[14] + a[10]*b[15] + a[14]*b[16],
		a[3]*b[13] + a[7]*b[14] + a[11]*b[15] + a[15]*b[16],
		a[4]*b[13] + a[8]*b[14] + a[12]*b[15] + a[16]*b[16]
	end
	
	---Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix
	---
	function M.matmul_mat4_mat4_ex(a, a_index, b, b_index) end
	
	---Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination
	---
	---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
	---
	function M.matmul_mat4_mat4_ex(a, a_index, b, b_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local ao = a_index - 1 -- index offset into a
		local bo = b_index - 1 -- index offset into b
		if dest then
			local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			dest[o+1] = a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4]
			dest[o+2] = a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4]
			dest[o+3] = a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4]
			dest[o+4] = a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4]
			dest[o+5] = a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8]
			dest[o+6] = a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8]
			dest[o+7] = a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8]
			dest[o+8] = a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8]
			dest[o+9] = a[ao+1]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+13]*b[bo+12]
			dest[o+10] = a[ao+2]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+10]*b[bo+11] + a[ao+14]*b[bo+12]
			dest[o+11] = a[ao+3]*b[bo+9] + a[ao+7]*b[bo+10] + a[ao+11]*b[bo+11] + a[ao+15]*b[bo+12]
			dest[o+12] = a[ao+4]*b[bo+9] + a[ao+8]*b[bo+10] + a[ao+12]*b[bo+11] + a[ao+16]*b[bo+12]
			dest[o+13] = a[ao+1]*b[bo+13] + a[ao+5]*b[bo+14] + a[ao+9]*b[bo+15] + a[ao+13]*b[bo+16]
			dest[o+14] = a[ao+2]*b[bo+13] + a[ao+6]*b[bo+14] + a[ao+10]*b[bo+15] + a[ao+14]*b[bo+16]
			dest[o+15] = a[ao+3]*b[bo+13] + a[ao+7]*b[bo+14] + a[ao+11]*b[bo+15] + a[ao+15]*b[bo+16]
			dest[o+16] = a[ao+4]*b[bo+13] + a[ao+8]*b[bo+14] + a[ao+12]*b[bo+15] + a[ao+16]*b[bo+16]
		else
			return a[ao+1]*b[bo+1] + a[ao+5]*b[bo+2] + a[ao+9]*b[bo+3] + a[ao+13]*b[bo+4],
				a[ao+2]*b[bo+1] + a[ao+6]*b[bo+2] + a[ao+10]*b[bo+3] + a[ao+14]*b[bo+4],
				a[ao+3]*b[bo+1] + a[ao+7]*b[bo+2] + a[ao+11]*b[bo+3] + a[ao+15]*b[bo+4],
				a[ao+4]*b[bo+1] + a[ao+8]*b[bo+2] + a[ao+12]*b[bo+3] + a[ao+16]*b[bo+4],
				a[ao+1]*b[bo+5] + a[ao+5]*b[bo+6] + a[ao+9]*b[bo+7] + a[ao+13]*b[bo+8],
				a[ao+2]*b[bo+5] + a[ao+6]*b[bo+6] + a[ao+10]*b[bo+7] + a[ao+14]*b[bo+8],
				a[ao+3]*b[bo+5] + a[ao+7]*b[bo+6] + a[ao+11]*b[bo+7] + a[ao+15]*b[bo+8],
				a[ao+4]*b[bo+5] + a[ao+8]*b[bo+6] + a[ao+12]*b[bo+7] + a[ao+16]*b[bo+8],
				a[ao+1]*b[bo+9] + a[ao+5]*b[bo+10] + a[ao+9]*b[bo+11] + a[ao+13]*b[bo+12],
				a[ao+2]*b[bo+9] + a[ao+6]*b[bo+10] + a[ao+10]*b[bo+11] + a[ao+14]*b[bo+12],
				a[ao+3]*b[bo+9] + a[ao+7]*b[bo+10] + a[ao+11]*b[bo+11] + a[ao+15]*b[bo+12],
				a[ao+4]*b[bo+9] + a[ao+8]*b[bo+10] + a[ao+12]*b[bo+11] + a[ao+16]*b[bo+12],
				a[ao+1]*b[bo+13] + a[ao+5]*b[bo+14] + a[ao+9]*b[bo+15] + a[ao+13]*b[bo+16],
				a[ao+2]*b[bo+13] + a[ao+6]*b[bo+14] + a[ao+10]*b[bo+15] + a[ao+14]*b[bo+16],
				a[ao+3]*b[bo+13] + a[ao+7]*b[bo+14] + a[ao+11]*b[bo+15] + a[ao+15]*b[bo+16],
				a[ao+4]*b[bo+13] + a[ao+8]*b[bo+14] + a[ao+12]*b[bo+15] + a[ao+16]*b[bo+16]
		end
	end
	
	---Multiply a 2x2 matrix and a 2d vector and return a 2d vector
	---
	function M.matmul_mat2_vec2(a, v)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local e1 = a[1]*v[1] + a[3]*v[2]
		local e2 = a[2]*v[1] + a[4]*v[2]
		return e1, e2
	end
	
	---Multiply a 2x2 matrix in a slice and a 2d vector in a slice and return a 2d vector
	---
	function M.matmul_mat2_vec2_ex(a, a_index, v, v_index) end
	
	---Multiply a 2x2 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination
	---
	function M.matmul_mat2_vec2_ex(a, a_index, v, v_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local vo = v_index - 1
		local e1 = a[ao+1]*v[vo+1] + a[ao+3]*v[vo+2]
		local e2 = a[ao+2]*v[vo+1] + a[ao+4]*v[vo+2]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o + 1] = e1
			dest[o + 2] = e2
		else
			return e1, e2
		end
	end
	
	---Multiply a 3x3 matrix and a 2d vector and return a 2d vector
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat3_vec2(a, v)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local e1 = a[1]*v[1] + a[4]*v[2] + a[7]
		local e2 = a[2]*v[1] + a[5]*v[2] + a[8]
		return e1, e2
	end
	
	---Multiply a 3x3 matrix in a slice and a 2d vector in a slice and return a 2d vector
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat3_vec2_ex(a, a_index, v, v_index) end
	
	---Multiply a 3x3 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat3_vec2_ex(a, a_index, v, v_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local vo = v_index - 1
		local e1 = a[ao+1]*v[vo+1] + a[ao+4]*v[vo+2] + a[ao+7]
		local e2 = a[ao+2]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+8]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o + 1] = e1
			dest[o + 2] = e2
		else
			return e1, e2
		end
	end
	
	---Multiply a 3x3 matrix and a 3d vector and return a 3d vector
	---
	function M.matmul_mat3_vec3(a, v)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local e1 = a[1]*v[1] + a[4]*v[2] + a[7]*v[3]
		local e2 = a[2]*v[1] + a[5]*v[2] + a[8]*v[3]
		local e3 = a[3]*v[1] + a[6]*v[2] + a[9]*v[3]
		return e1, e2, e3
	end
	
	---Multiply a 3x3 matrix in a slice and a 3d vector in a slice and return a 3d vector
	---
	function M.matmul_mat3_vec3_ex(a, a_index, v, v_index) end
	
	---Multiply a 3x3 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination
	---
	function M.matmul_mat3_vec3_ex(a, a_index, v, v_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local vo = v_index - 1
		local e1 = a[ao+1]*v[vo+1] + a[ao+4]*v[vo+2] + a[ao+7]*v[vo+3]
		local e2 = a[ao+2]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+8]*v[vo+3]
		local e3 = a[ao+3]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+9]*v[vo+3]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o + 1] = e1
			dest[o + 2] = e2
			dest[o + 3] = e3
		else
			return e1, e2, e3
		end
	end
	
	---Multiply a 4x4 matrix and a 2d vector and return a 2d vector
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat4_vec2(a, v)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local e1 = a[1]*v[1] + a[5]*v[2] + a[9] + a[13]
		local e2 = a[2]*v[1] + a[6]*v[2] + a[10] + a[14]
		return e1, e2
	end
	
	---Multiply a 4x4 matrix in a slice and a 2d vector in a slice and return a 2d vector
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat4_vec2_ex(a, a_index, v, v_index) end
	
	---Multiply a 4x4 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat4_vec2_ex(a, a_index, v, v_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local vo = v_index - 1
		local e1 = a[ao+1]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+9] + a[ao+13]
		local e2 = a[ao+2]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+10] + a[ao+14]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o + 1] = e1
			dest[o + 2] = e2
		else
			return e1, e2
		end
	end
	
	---Multiply a 4x4 matrix and a 3d vector and return a 3d vector
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat4_vec3(a, v)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local e1 = a[1]*v[1] + a[5]*v[2] + a[9]*v[3] + a[13]
		local e2 = a[2]*v[1] + a[6]*v[2] + a[10]*v[3] + a[14]
		local e3 = a[3]*v[1] + a[7]*v[2] + a[11]*v[3] + a[15]
		return e1, e2, e3
	end
	
	---Multiply a 4x4 matrix in a slice and a 3d vector in a slice and return a 3d vector
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat4_vec3_ex(a, a_index, v, v_index) end
	
	---Multiply a 4x4 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination
	---
	---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
	function M.matmul_mat4_vec3_ex(a, a_index, v, v_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local vo = v_index - 1
		local e1 = a[ao+1]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+9]*v[vo+3] + a[ao+13]
		local e2 = a[ao+2]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+10]*v[vo+3] + a[ao+14]
		local e3 = a[ao+3]*v[vo+1] + a[ao+7]*v[vo+2] + a[ao+11]*v[vo+3] + a[ao+15]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o + 1] = e1
			dest[o + 2] = e2
			dest[o + 3] = e3
		else
			return e1, e2, e3
		end
	end
	
	---Multiply a 4x4 matrix and a 4d vector and return a 4d vector
	---
	function M.matmul_mat4_vec4(a, v)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local e1 = a[1]*v[1] + a[5]*v[2] + a[9]*v[3] + a[13]*v[4]
		local e2 = a[2]*v[1] + a[6]*v[2] + a[10]*v[3] + a[14]*v[4]
		local e3 = a[3]*v[1] + a[7]*v[2] + a[11]*v[3] + a[15]*v[4]
		local e4 = a[4]*v[1] + a[8]*v[2] + a[12]*v[3] + a[16]*v[4]
		return e1, e2, e3, e4
	end
	
	---Multiply a 4x4 matrix in a slice and a 4d vector in a slice and return a 4d vector
	---
	function M.matmul_mat4_vec4_ex(a, a_index, v, v_index) end
	
	---Multiply a 4x4 matrix in a slice and a 4d vector in an array or slice into a 4d vector in a destination
	---
	function M.matmul_mat4_vec4_ex(a, a_index, v, v_index, dest, dest_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		local ao = a_index - 1
		local vo = v_index - 1
		local e1 = a[ao+1]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+9]*v[vo+3] + a[ao+13]*v[vo+4]
		local e2 = a[ao+2]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+10]*v[vo+3] + a[ao+14]*v[vo+4]
		local e3 = a[ao+3]*v[vo+1] + a[ao+7]*v[vo+2] + a[ao+11]*v[vo+3] + a[ao+15]*v[vo+4]
		local e4 = a[ao+4]*v[vo+1] + a[ao+8]*v[vo+2] + a[ao+12]*v[vo+3] + a[ao+16]*v[vo+4]
		if dest then
			assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
			local o = dest_index and (dest_index - 1) or 0
			dest[o + 1] = e1
			dest[o + 2] = e2
			dest[o + 3] = e3
			dest[o + 4] = e4
		else
			return e1, e2, e3, e4
		end
	end
	
	avm.linalg = M
	
end

-- Module view.lua
do
	--[[
	Views  
	
	A view is a special array or sequence that maps into a subset of another array or sequence.  
	
	The views in this module can be used to:  
	* Pass subsets of arrays to AVM functions, such as interleaved data or reversed values  
	* Provide array wrappers for objects, e.g., `M.slice(cdata, 0, 10)` will make an array wrapper for the first 10 elements of a cdata array  
	
	]]
	local M = {}
	
	local array = avm.array
	
	---Disable warnings for _ex type overloaded functions
	
	-----------------------------------------------------------
	-- Dependencies
	-----------------------------------------------------------
	
	-- Math library dependencies
	-- Override these to use a different math library or set as nil to remove the dependency
	local math_ceil = assert(math.ceil)
	
	-----------------------------------------------------------
	-- Slice
	-----------------------------------------------------------
	
	local slice_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		__len = function(self) return rawget(self, 'n') end
	}
	
	---Create a view into `src` that starts at `index` and has `count` elements
	---
	---Example:
	---```lua
	---local a = {1,2,3,4,5,6,7,8,9,10}
	---local b = view.slice(a, 2, 3)
	---print(b[1], b[2], b[3]) --> 2 3 4
	---```
	---
	---Note: Most array functions have `_ex` forms so this object is a convenience only
	function M.slice(src, index, count)
		return setmetatable({_src=src, _i=index, n=count}, slice_mt)
	end
	
	-----------------------------------------------------------
	-- Strided View
	-----------------------------------------------------------
	
	local strided_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + (index - 1)*self._s]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + (index - 1)*self._s] = value
			else
				rawset(self, index, value)
			end
		end,
		__len = function(self) return rawget(self, 'n') end
	}
	
	---Create a view into `src` that starts at `index` and skips `stride` elements
	---
	---Example:
	---```lua
	---local a = {1,2,3,4,5,6}
	---local index, stride, count = 1, 2, 3
	---local b = view.stride(a, index, stride, count)
	---print(b[1], b[2], b[3]) --> 1 3 5
	---```
	---
	function M.stride(src, index, stride, count)
		assert(stride ~= 0, "bad argument 'stride' (must be non-zero)")
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return setmetatable({_src=src, _i=index, _s=stride, n=count}, strided_mt)
	end
	
	---Create a view into `src` that reverses the elements
	-- Can optionally start at `index` and reverse for `count` elements
	---
	---Example:
	---```lua
	---local a = {1,2,3,4,5,6,7,8,9,10}
	---local b = view.reverse(a)
	---print(b[1], b[2], b[3]) --> 10 9 8
	---```
	---
	function M.reverse(src, index, count)
		local n = count or array.length(src)
		index = index or n
		count = count or n
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		return setmetatable({_src=src, _i=index, _s=-1, n=count}, strided_mt)
	end
	
	-----------------------------------------------------------
	-- Interleaved View
	-----------------------------------------------------------
	
	local interleaved_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				local group_adv = math_ceil(index / self._g)-1
				local subgroup_index = (index-1) % self._g
				return self._src[self._i + group_adv*self._s + subgroup_index]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				local group_adv = math_ceil(index / self._g)-1
				local subgroup_index = (index-1) % self._g
				self._src[self._i + group_adv*self._s + subgroup_index] = value
			else
				rawset(self, index, value)
			end
		end,
		__len = function(self) return rawget(self, 'n') end
	}
	
	---Create a view over interleaved data, collecting `group_size` elements starting at `index` and skipping `stride` elements
	---
	---Example:
	---```
	---local a = {1,2, x,x, 5,6, x,x, 9,10}
	---local b = view.interleaved(a, 1, 2, 2, 3)
	---print(b[1], b[2], b[3], b[4], b[5], b[6]) --> 1 2 5 6 9 10
	---```
	function M.interleave(src, index, group_size, stride, count)
		assert(group_size > 0, "bad argument 'group_size' (must be greater than 0)")
		assert(stride ~= 0, "bad argument 'stride' (must be non-zero)")
		return setmetatable({_src=src, _i=index, _g=group_size, _s=stride, n=count}, interleaved_mt)
	end
	
	-----------------------------------------------------------
	-- Fixed size views
	-----------------------------------------------------------
	
	local slice1_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 1 end
	}
	
	local slice2_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 2 end
	}
	
	local slice3_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 3 end
	}
	
	local slice4_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 4 end
	}
	
	local slice5_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 5 end
	}
	
	local slice6_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 6 end
	}
	
	local slice7_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 7 end
	}
	
	local slice8_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 8 end
	}
	
	local slice9_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 9 end
	}
	
	local slice10_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 10 end
	}
	
	local slice11_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 11 end
	}
	
	local slice12_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 12 end
	}
	
	local slice13_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 13 end
	}
	
	local slice14_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 14 end
	}
	
	local slice15_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 15 end
	}
	
	local slice16_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._src[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._src[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		function(self) return 16 end
	}
	
	---Create a view of size `1` that maps into `src` starting from `index`
	---
	function M.slice_1(src, index)
		return setmetatable({_src=src, _i=index}, slice1_mt)
	end
	
	---Create a view of size `2` that maps into `src` starting from `index`
	---
	function M.slice_2(src, index)
		return setmetatable({_src=src, _i=index}, slice2_mt)
	end
	
	---Create a view of size `3` that maps into `src` starting from `index`
	---
	function M.slice_3(src, index)
		return setmetatable({_src=src, _i=index}, slice3_mt)
	end
	
	---Create a view of size `4` that maps into `src` starting from `index`
	---
	function M.slice_4(src, index)
		return setmetatable({_src=src, _i=index}, slice4_mt)
	end
	
	---Create a view of size `5` that maps into `src` starting from `index`
	---
	function M.slice_5(src, index)
		return setmetatable({_src=src, _i=index}, slice5_mt)
	end
	
	---Create a view of size `6` that maps into `src` starting from `index`
	---
	function M.slice_6(src, index)
		return setmetatable({_src=src, _i=index}, slice6_mt)
	end
	
	---Create a view of size `7` that maps into `src` starting from `index`
	---
	function M.slice_7(src, index)
		return setmetatable({_src=src, _i=index}, slice7_mt)
	end
	
	---Create a view of size `8` that maps into `src` starting from `index`
	---
	function M.slice_8(src, index)
		return setmetatable({_src=src, _i=index}, slice8_mt)
	end
	
	---Create a view of size `9` that maps into `src` starting from `index`
	---
	function M.slice_9(src, index)
		return setmetatable({_src=src, _i=index}, slice9_mt)
	end
	
	---Create a view of size `10` that maps into `src` starting from `index`
	---
	function M.slice_10(src, index)
		return setmetatable({_src=src, _i=index}, slice10_mt)
	end
	
	---Create a view of size `11` that maps into `src` starting from `index`
	---
	function M.slice_11(src, index)
		return setmetatable({_src=src, _i=index}, slice11_mt)
	end
	
	---Create a view of size `12` that maps into `src` starting from `index`
	---
	function M.slice_12(src, index)
		return setmetatable({_src=src, _i=index}, slice12_mt)
	end
	
	---Create a view of size `13` that maps into `src` starting from `index`
	---
	function M.slice_13(src, index)
		return setmetatable({_src=src, _i=index}, slice13_mt)
	end
	
	---Create a view of size `14` that maps into `src` starting from `index`
	---
	function M.slice_14(src, index)
		return setmetatable({_src=src, _i=index}, slice14_mt)
	end
	
	---Create a view of size `15` that maps into `src` starting from `index`
	---
	function M.slice_15(src, index)
		return setmetatable({_src=src, _i=index}, slice15_mt)
	end
	
	---Create a view of size `16` that maps into `src` starting from `index`
	---
	function M.slice_16(src, index)
		return setmetatable({_src=src, _i=index}, slice16_mt)
	end
	
	avm.view = M
	
end

-- Module iterator.lua
do
	--[[
	Iterator  
	
	Special purpose iterators  
	]]
	local M = {}
	
	-----------------------------------------------------------
	-- Constants and Dependencies
	-----------------------------------------------------------
	
	-- Math library
	local math_ceil = assert(math.ceil)
	local math_min = assert(math.min)
	
	local array = avm.array
	
	local view = avm.view
	
	---Disable warnings for _ex type overloaded functions
	
	-----------------------------------------------------------
	-- Iteration
	-----------------------------------------------------------
	
	---Create an iterator over an array that returns consecutive tuples of 2 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_2(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_2_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 2 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_2_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 2)
		return function()
			while i<n do
				local j = 2*i+src_index
				i = i+1
				return i, src[j], src[j+1]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 3 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_3(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_3_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 3 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_3_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 3)
		return function()
			while i<n do
				local j = 3*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 4 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_4(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_4_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 4 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_4_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 4)
		return function()
			while i<n do
				local j = 4*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 5 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_5(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_5_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 5 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_5_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 5)
		return function()
			while i<n do
				local j = 5*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 6 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_6(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_6_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 6 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_6_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 6)
		return function()
			while i<n do
				local j = 6*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 7 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_7(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_7_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 7 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_7_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 7)
		return function()
			while i<n do
				local j = 7*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 8 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_8(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_8_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 8 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_8_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 8)
		return function()
			while i<n do
				local j = 8*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 9 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_9(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_9_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 9 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_9_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 9)
		return function()
			while i<n do
				local j = 9*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 10 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_10(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_10_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 10 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_10_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 10)
		return function()
			while i<n do
				local j = 10*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 11 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_11(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_11_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 11 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_11_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 11)
		return function()
			while i<n do
				local j = 11*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 12 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_12(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_12_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 12 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_12_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 12)
		return function()
			while i<n do
				local j = 12*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 13 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_13(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_13_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 13 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_13_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 13)
		return function()
			while i<n do
				local j = 13*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 14 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_14(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_14_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 14 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_14_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 14)
		return function()
			while i<n do
				local j = 14*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12], src[j+13]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 15 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_15(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_15_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 15 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_15_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 15)
		return function()
			while i<n do
				local j = 15*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12], src[j+13], src[j+14]
			end
		end
	end
	
	---Create an iterator over an array that returns consecutive tuples of 16 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_16(src)
		assert(src, "bad argument 'src' (expected array, got nil)")
		return M.group_16_ex(src, 1, array.length(src))
	end
	
	---Create an iterator over a slice that returns consecutive tuples of 16 elements
	---
	---NOTE: the returned index is the index of *the group*
	---
	function M.group_16_ex(src, src_index, src_count)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(src_count / 16)
		return function()
			while i<n do
				local j = 16*i+src_index
				i = i+1
				return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12], src[j+13], src[j+14], src[j+15]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_1(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/1)
		return function()
			while i<n do
				local j = 1*i+1
				i = i+1
				return i, a[j], b[j]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_1_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/1)
		return function()
			while i<n do
				local aj = 1*i+a_index
				local bj = 1*i+b_index
				i = i+1
				return i, a[aj], b[bj]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_2(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/2)
		return function()
			while i<n do
				local j = 2*i+1
				i = i+1
				return i, a[j], a[j+1], b[j], b[j+1]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_2_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/2)
		return function()
			while i<n do
				local aj = 2*i+a_index
				local bj = 2*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], b[bj], b[bj+1]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_3(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/3)
		return function()
			while i<n do
				local j = 3*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], b[j], b[j+1], b[j+2]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_3_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/3)
		return function()
			while i<n do
				local aj = 3*i+a_index
				local bj = 3*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], b[bj], b[bj+1], b[bj+2]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_4(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/4)
		return function()
			while i<n do
				local j = 4*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], b[j], b[j+1], b[j+2], b[j+3]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_4_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/4)
		return function()
			while i<n do
				local aj = 4*i+a_index
				local bj = 4*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], b[bj], b[bj+1], b[bj+2], b[bj+3]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_5(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/5)
		return function()
			while i<n do
				local j = 5*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], b[j], b[j+1], b[j+2], b[j+3], b[j+4]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_5_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/5)
		return function()
			while i<n do
				local aj = 5*i+a_index
				local bj = 5*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_6(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/6)
		return function()
			while i<n do
				local j = 6*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_6_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/6)
		return function()
			while i<n do
				local aj = 6*i+a_index
				local bj = 6*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_7(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/7)
		return function()
			while i<n do
				local j = 7*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_7_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/7)
		return function()
			while i<n do
				local aj = 7*i+a_index
				local bj = 7*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_8(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/8)
		return function()
			while i<n do
				local j = 8*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_8_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/8)
		return function()
			while i<n do
				local aj = 8*i+a_index
				local bj = 8*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_9(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/9)
		return function()
			while i<n do
				local j = 9*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_9_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/9)
		return function()
			while i<n do
				local aj = 9*i+a_index
				local bj = 9*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_10(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/10)
		return function()
			while i<n do
				local j = 10*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_10_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/10)
		return function()
			while i<n do
				local aj = 10*i+a_index
				local bj = 10*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_11(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/11)
		return function()
			while i<n do
				local j = 11*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_11_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/11)
		return function()
			while i<n do
				local aj = 11*i+a_index
				local bj = 11*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_12(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/12)
		return function()
			while i<n do
				local j = 12*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_12_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/12)
		return function()
			while i<n do
				local aj = 12*i+a_index
				local bj = 12*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_13(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/13)
		return function()
			while i<n do
				local j = 13*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_13_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/13)
		return function()
			while i<n do
				local aj = 13*i+a_index
				local bj = 13*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_14(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/14)
		return function()
			while i<n do
				local j = 14*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], a[j+13], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12], b[j+13]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_14_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/14)
		return function()
			while i<n do
				local aj = 14*i+a_index
				local bj = 14*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], a[aj+13], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12], b[bj+13]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_15(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/15)
		return function()
			while i<n do
				local j = 15*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], a[j+13], a[j+14], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12], b[j+13], b[j+14]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_15_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/15)
		return function()
			while i<n do
				local aj = 15*i+a_index
				local bj = 15*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], a[aj+13], a[aj+14], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12], b[bj+13], b[bj+14]
			end
		end
	end
	
	---Create an iterator over two arrays that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_16(a, b)
		assert(a, "bad argument 'a' (expected array, got nil)")
		assert(b, "bad argument 'b' (expected array, got nil)")
		local i = 0
		local n = math_ceil(math_min(array.length(a),array.length(b))/16)
		return function()
			while i<n do
				local j = 16*i+1
				i = i+1
				return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], a[j+13], a[j+14], a[j+15], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12], b[j+13], b[j+14], b[j+15]
			end
		end
	end
	
	---Create an iterator over two slices that returns
	---```
	---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
	---```
	---where `i` is the index of the group,
	---`a_i_j` is the `j`'th element of group `i` of `a` and
	---`b_i_j` is the `j`'th element of group `i` of `b`
	---
	function M.zip_16_ex(a, a_index, a_count, b, b_index)
		assert(a, "bad argument 'a' (expected array or sequence, got nil)")
		assert(b, "bad argument 'b' (expected array or sequence, got nil)")
		local i = 0
		local n = math_ceil(a_count/16)
		return function()
			while i<n do
				local aj = 16*i+a_index
				local bj = 16*i+b_index
				i = i+1
				return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], a[aj+13], a[aj+14], a[aj+15], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12], b[bj+13], b[bj+14], b[bj+15]
			end
		end
	end
	
	avm.iterator = M
	
end

-- Module vector_2.lua
do
	
	--[[
	Vector operations and types  
	
	Classes and functions for working with 2-d vectors  
	
	Usage:  
	```lua  
		-- Create a new vector  
		local v1 = vector_2.new(1, 3)  
	
		-- Get elements via indices, x(), y(), or xy()  
		print(v1[1], v1[2]) --> "1 3"  
		print(v1:x(), v1:y()) --> "1 3"  
		print(v:xy()) --> "1 3"  
	
		-- Set an element  
		v1:set_y(2)  
		print(v1:xy()) --> "1 2"  
	
		-- Sum vectors using add() or + operator  
		local v2 = vector_2.new(3, 4)  
		local v3 = v1 + v2 -- or v1:add(v2)  
		print(v3:xy()) --> "4 6"  
	
		-- Multiply v3 by a constant `-1` and store result directly in v3  
		v3:mul_into(-1, v3)  
		print(v3:xy()) --> "-4 -6"  
	
		-- Vectors are arrays so can use array functions  
		local arr = array.copy(v3)  
		assert(arr[1] == -4 and arr[2] == -6)  
	
		-- Use linear algebra functions  
		local dot = linalg.inner_product_vec2(v1, v2)  
		assert(dot == 11)  
	```  
	
	]]
	local M = {}
	
	local array = avm.array
	
	local format = avm.format
	
	---Disable warnings for _ex type overloaded functions
	
	---2D vector constructed from a tuple
	---
	local vector_2 = {}
	
	-----------------------------------------------------------
	-- Vector creation
	-----------------------------------------------------------
	
	---Create a new vector_2 with given values
	function M.new(v1, v2)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		return setmetatable({v1, v2}, vector_2)
	end
	
	--[=[
	---Create a vector_2_slice class that views into an array or slice
	function M.slice(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local index = src_index or 1
		return setmetatable({_src = src, _o=index-1}, vector_2_slice) --[[end
	--]=]
	
	vector_2.__index = vector_2
	vector_2.__len = function()
		return 2
	end
	
	function vector_2:__tostring()
		return format.array("${format_string}", self)
	end
	
	function vector_2:copy()
		return M.new(self:get())
	end
	
	function vector_2:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function vector_2:get()
		return self[1], self[2]
	end
	
	---Set values from a tuple
	function vector_2:set(v1, v2)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		self[1], self[2] = v1, v2
	end
	
	---Apply add element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2:add(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self[1]+v1,self[2]+v2)
	end
	
	---Apply add element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2:add_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self[1]+v1,self[2]+v2)
	end
	
	---Apply sub element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2:sub(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self[1]-v1,self[2]-v2)
	end
	
	---Apply sub element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2:sub_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self[1]-v1,self[2]-v2)
	end
	
	---Apply mul element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2:mul(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self[1]*v1,self[2]*v2)
	end
	
	---Apply mul element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2:mul_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self[1]*v1,self[2]*v2)
	end
	
	---Apply div element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2:div(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self[1]/v1,self[2]/v2)
	end
	
	---Apply div element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2:div_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self[1]/v1,self[2]/v2)
	end
	
	--- Operator metamethods
	vector_2.__add = vector_2.add
	vector_2.__sub = vector_2.sub
	vector_2.__mul = vector_2.mul
	vector_2.__div = vector_2.div
	vector_2.__unm = function(v) return v:mul(-1) end
	
	-----------------------------------------------------------
	-- Element access
	-----------------------------------------------------------
	
	---Get elements of the vector
	function vector_2:x()
		return self[1]
	end
	
	---Get elements of the vector
	function vector_2:y()
		return self[2]
	end
	
	---Get elements of the vector
	function vector_2:xx()
		return self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_2:xy()
		return self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_2:yx()
		return self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_2:yy()
		return self[2], self[2]
	end
	
	---Set elements of the vector
	function vector_2:set_x(v1)
		self[1] = v1
	end
	
	---Set elements of the vector
	function vector_2:set_y(v1)
		self[2] = v1
	end
	
	---Set elements of the vector
	function vector_2:set_xy(v1, v2)
		self[1], self[2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_2:set_yx(v1, v2)
		self[2], self[1] = v1, v2
	end
	
	--[[
	function vector_2_slice:__index(key)
		if type(key) == 'number' and key >= 1 and key <= 2 then
				return self._src[self._o+key]
		else
			return vector_2_slice[key]
		end
	end
	function vector_2_slice:__newindex(key, value)
		if type(key) == 'number' and key >= 1 and key <= 2 then
				self._src[self._o+key] = value
		else
			rawset(self, key, value)
		end
	end
	
	function vector_2_slice:__len()
		return 2
	end
	
	function vector_2_slice:__tostring()
		return format.array("${format_string}", self)
	end
	
	function vector_2_slice:copy()
		return M.new(self:get())
	end
	
	function vector_2_slice:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function vector_2_slice:get()
		return self._src[self._o+1], self._src[self._o+2]
	end
	
	---Set values from a tuple
	function vector_2_slice:set(v1, v2)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		self._src[self._o+1], self._src[self._o+2] = v1, v2
	end
	
	---Apply add element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:add(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self._src[self._o+1]+v1,self._src[self._o+2]+v2)
	end
	
	---Apply add element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:add_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self._src[self._o+1]+v1,self._src[self._o+2]+v2)
	end
	
	---Apply sub element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:sub(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self._src[self._o+1]-v1,self._src[self._o+2]-v2)
	end
	
	---Apply sub element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:sub_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self._src[self._o+1]-v1,self._src[self._o+2]-v2)
	end
	
	---Apply mul element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:mul(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self._src[self._o+1]*v1,self._src[self._o+2]*v2)
	end
	
	---Apply mul element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:mul_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self._src[self._o+1]*v1,self._src[self._o+2]*v2)
	end
	
	---Apply div element-wise and return a new vector_2
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:div(v)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		return M.new(self._src[self._o+1]/v1,self._src[self._o+2]/v2)
	end
	
	---Apply div element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_2_slice:div_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2 = v[1],v[2]
		else
				v1, v2 = v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_2(dest, dest_index or 1, self._src[self._o+1]/v1,self._src[self._o+2]/v2)
	end
	
	--- Operator metamethods
	vector_2_slice.__add = vector_2_slice.add
	vector_2_slice.__sub = vector_2_slice.sub
	vector_2_slice.__mul = vector_2_slice.mul
	vector_2_slice.__div = vector_2_slice.div
	vector_2_slice.__unm = function(v) return v:mul(-1) end
	
	-----------------------------------------------------------
	-- Element access
	-----------------------------------------------------------
	
	---Get elements of the vector
	function vector_2_slice:x()
		return self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_2_slice:y()
		return self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_2_slice:xx()
		return self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_2_slice:xy()
		return self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_2_slice:yx()
		return self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_2_slice:yy()
		return self._src[self._o+2], self._src[self._o+2]
	end
	
	---Set elements of the vector
	function vector_2_slice:set_x(v1)
		self._src[self._o+1] = v1
	end
	
	---Set elements of the vector
	function vector_2_slice:set_y(v1)
		self._src[self._o+2] = v1
	end
	
	---Set elements of the vector
	function vector_2_slice:set_xy(v1, v2)
		self._src[self._o+1], self._src[self._o+2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_2_slice:set_yx(v1, v2)
		self._src[self._o+2], self._src[self._o+1] = v1, v2
	end
	
	--]]
	
	avm.vector_2 = M
	
end

-- Module vector_3.lua
do
	
	--[[
	Vector operations and types  
	
	Classes and functions for working with 3-d vectors  
	
	]]
	local M = {}
	
	local array = avm.array
	
	local format = avm.format
	
	---Disable warnings for _ex type overloaded functions
	
	---3D vector constructed from a tuple
	---
	local vector_3 = {}
	
	-----------------------------------------------------------
	-- Vector creation
	-----------------------------------------------------------
	
	---Create a new vector_3 with given values
	function M.new(v1, v2, v3)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		return setmetatable({v1, v2, v3}, vector_3)
	end
	
	--[=[
	---Create a vector_3_slice class that views into an array or slice
	function M.slice(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local index = src_index or 1
		return setmetatable({_src = src, _o=index-1}, vector_3_slice) --[[end
	--]=]
	
	vector_3.__index = vector_3
	vector_3.__len = function()
		return 3
	end
	
	function vector_3:__tostring()
		return format.array("${format_string}", self)
	end
	
	function vector_3:copy()
		return M.new(self:get())
	end
	
	function vector_3:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function vector_3:get()
		return self[1], self[2], self[3]
	end
	
	---Set values from a tuple
	function vector_3:set(v1, v2, v3)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		self[1], self[2], self[3] = v1, v2, v3
	end
	
	---Apply add element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3:add(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self[1]+v1,self[2]+v2,self[3]+v3)
	end
	
	---Apply add element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3:add_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self[1]+v1,self[2]+v2,self[3]+v3)
	end
	
	---Apply sub element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3:sub(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self[1]-v1,self[2]-v2,self[3]-v3)
	end
	
	---Apply sub element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3:sub_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self[1]-v1,self[2]-v2,self[3]-v3)
	end
	
	---Apply mul element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3:mul(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self[1]*v1,self[2]*v2,self[3]*v3)
	end
	
	---Apply mul element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3:mul_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self[1]*v1,self[2]*v2,self[3]*v3)
	end
	
	---Apply div element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3:div(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self[1]/v1,self[2]/v2,self[3]/v3)
	end
	
	---Apply div element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3:div_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self[1]/v1,self[2]/v2,self[3]/v3)
	end
	
	--- Operator metamethods
	vector_3.__add = vector_3.add
	vector_3.__sub = vector_3.sub
	vector_3.__mul = vector_3.mul
	vector_3.__div = vector_3.div
	vector_3.__unm = function(v) return v:mul(-1) end
	
	-----------------------------------------------------------
	-- Element access
	-----------------------------------------------------------
	
	---Get elements of the vector
	function vector_3:x()
		return self[1]
	end
	
	---Get elements of the vector
	function vector_3:y()
		return self[2]
	end
	
	---Get elements of the vector
	function vector_3:z()
		return self[3]
	end
	
	---Get elements of the vector
	function vector_3:xx()
		return self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_3:xy()
		return self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_3:xz()
		return self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_3:yx()
		return self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_3:yy()
		return self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_3:yz()
		return self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_3:zx()
		return self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_3:zy()
		return self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_3:zz()
		return self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_3:xxx()
		return self[1], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_3:xxy()
		return self[1], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_3:xxz()
		return self[1], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_3:xyx()
		return self[1], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_3:xyy()
		return self[1], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_3:xyz()
		return self[1], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_3:xzx()
		return self[1], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_3:xzy()
		return self[1], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_3:xzz()
		return self[1], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_3:yxx()
		return self[2], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_3:yxy()
		return self[2], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_3:yxz()
		return self[2], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_3:yyx()
		return self[2], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_3:yyy()
		return self[2], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_3:yyz()
		return self[2], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_3:yzx()
		return self[2], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_3:yzy()
		return self[2], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_3:yzz()
		return self[2], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_3:zxx()
		return self[3], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_3:zxy()
		return self[3], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_3:zxz()
		return self[3], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_3:zyx()
		return self[3], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_3:zyy()
		return self[3], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_3:zyz()
		return self[3], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_3:zzx()
		return self[3], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_3:zzy()
		return self[3], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_3:zzz()
		return self[3], self[3], self[3]
	end
	
	---Set elements of the vector
	function vector_3:set_x(v1)
		self[1] = v1
	end
	
	---Set elements of the vector
	function vector_3:set_y(v1)
		self[2] = v1
	end
	
	---Set elements of the vector
	function vector_3:set_z(v1)
		self[3] = v1
	end
	
	---Set elements of the vector
	function vector_3:set_xy(v1, v2)
		self[1], self[2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3:set_xz(v1, v2)
		self[1], self[3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3:set_yx(v1, v2)
		self[2], self[1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3:set_yz(v1, v2)
		self[2], self[3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3:set_zx(v1, v2)
		self[3], self[1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3:set_zy(v1, v2)
		self[3], self[2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3:set_xyz(v1, v2, v3)
		self[1], self[2], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3:set_xzy(v1, v2, v3)
		self[1], self[3], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3:set_yxz(v1, v2, v3)
		self[2], self[1], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3:set_yzx(v1, v2, v3)
		self[2], self[3], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3:set_zxy(v1, v2, v3)
		self[3], self[1], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3:set_zyx(v1, v2, v3)
		self[3], self[2], self[1] = v1, v2, v3
	end
	
	--[[
	function vector_3_slice:__index(key)
		if type(key) == 'number' and key >= 1 and key <= 3 then
				return self._src[self._o+key]
		else
			return vector_3_slice[key]
		end
	end
	function vector_3_slice:__newindex(key, value)
		if type(key) == 'number' and key >= 1 and key <= 3 then
				self._src[self._o+key] = value
		else
			rawset(self, key, value)
		end
	end
	
	function vector_3_slice:__len()
		return 3
	end
	
	function vector_3_slice:__tostring()
		return format.array("${format_string}", self)
	end
	
	function vector_3_slice:copy()
		return M.new(self:get())
	end
	
	function vector_3_slice:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function vector_3_slice:get()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Set values from a tuple
	function vector_3_slice:set(v1, v2, v3)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
	end
	
	---Apply add element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:add(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3)
	end
	
	---Apply add element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:add_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3)
	end
	
	---Apply sub element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:sub(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3)
	end
	
	---Apply sub element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:sub_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3)
	end
	
	---Apply mul element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:mul(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3)
	end
	
	---Apply mul element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:mul_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3)
	end
	
	---Apply div element-wise and return a new vector_3
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:div(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		return M.new(self._src[self._o+1]/v1,self._src[self._o+2]/v2,self._src[self._o+3]/v3)
	end
	
	---Apply div element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_3_slice:div_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3 = v[1],v[2],v[3]
		else
				v1, v2, v3 = v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_3(dest, dest_index or 1, self._src[self._o+1]/v1,self._src[self._o+2]/v2,self._src[self._o+3]/v3)
	end
	
	--- Operator metamethods
	vector_3_slice.__add = vector_3_slice.add
	vector_3_slice.__sub = vector_3_slice.sub
	vector_3_slice.__mul = vector_3_slice.mul
	vector_3_slice.__div = vector_3_slice.div
	vector_3_slice.__unm = function(v) return v:mul(-1) end
	
	-----------------------------------------------------------
	-- Element access
	-----------------------------------------------------------
	
	---Get elements of the vector
	function vector_3_slice:x()
		return self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:y()
		return self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:z()
		return self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:xx()
		return self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:xy()
		return self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:xz()
		return self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:yx()
		return self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:yy()
		return self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:yz()
		return self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:zx()
		return self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:zy()
		return self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:zz()
		return self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:xxx()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:xxy()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:xxz()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:xyx()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:xyy()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:xyz()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:xzx()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:xzy()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:xzz()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:yxx()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:yxy()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:yxz()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:yyx()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:yyy()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:yyz()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:yzx()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:yzy()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:yzz()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:zxx()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:zxy()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:zxz()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:zyx()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:zyy()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:zyz()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_3_slice:zzx()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_3_slice:zzy()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_3_slice:zzz()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Set elements of the vector
	function vector_3_slice:set_x(v1)
		self._src[self._o+1] = v1
	end
	
	---Set elements of the vector
	function vector_3_slice:set_y(v1)
		self._src[self._o+2] = v1
	end
	
	---Set elements of the vector
	function vector_3_slice:set_z(v1)
		self._src[self._o+3] = v1
	end
	
	---Set elements of the vector
	function vector_3_slice:set_xy(v1, v2)
		self._src[self._o+1], self._src[self._o+2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3_slice:set_xz(v1, v2)
		self._src[self._o+1], self._src[self._o+3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3_slice:set_yx(v1, v2)
		self._src[self._o+2], self._src[self._o+1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3_slice:set_yz(v1, v2)
		self._src[self._o+2], self._src[self._o+3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3_slice:set_zx(v1, v2)
		self._src[self._o+3], self._src[self._o+1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3_slice:set_zy(v1, v2)
		self._src[self._o+3], self._src[self._o+2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_3_slice:set_xyz(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3_slice:set_xzy(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3_slice:set_yxz(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3_slice:set_yzx(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3_slice:set_zxy(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_3_slice:set_zyx(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3
	end
	
	--]]
	
	avm.vector_3 = M
	
end

-- Module vector_4.lua
do
	
	--[[
	Vector operations and types  
	
	Classes and functions for working with 4-d vectors  
	
	]]
	local M = {}
	
	local array = avm.array
	
	local format = avm.format
	
	---Disable warnings for _ex type overloaded functions
	
	---4D vector constructed from a tuple
	---
	local vector_4 = {}
	
	-----------------------------------------------------------
	-- Vector creation
	-----------------------------------------------------------
	
	---Create a new vector_4 with given values
	function M.new(v1, v2, v3, v4)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		assert(v4, "bad argument 'v4' (expected number, got nil)")
		return setmetatable({v1, v2, v3, v4}, vector_4)
	end
	
	--[=[
	---Create a vector_4_slice class that views into an array or slice
	function M.slice(src, src_index)
		assert(src, "bad argument 'src' (expected array or sequence, got nil)")
		local index = src_index or 1
		return setmetatable({_src = src, _o=index-1}, vector_4_slice) --[[end
	--]=]
	
	vector_4.__index = vector_4
	vector_4.__len = function()
		return 4
	end
	
	function vector_4:__tostring()
		return format.array("${format_string}", self)
	end
	
	function vector_4:copy()
		return M.new(self:get())
	end
	
	function vector_4:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function vector_4:get()
		return self[1], self[2], self[3], self[4]
	end
	
	---Set values from a tuple
	function vector_4:set(v1, v2, v3, v4)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		assert(v4, "bad argument 'v4' (expected number, got nil)")
		self[1], self[2], self[3], self[4] = v1, v2, v3, v4
	end
	
	---Apply add element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4:add(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self[1]+v1,self[2]+v2,self[3]+v3,self[4]+v4)
	end
	
	---Apply add element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4:add_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self[1]+v1,self[2]+v2,self[3]+v3,self[4]+v4)
	end
	
	---Apply sub element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4:sub(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self[1]-v1,self[2]-v2,self[3]-v3,self[4]-v4)
	end
	
	---Apply sub element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4:sub_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self[1]-v1,self[2]-v2,self[3]-v3,self[4]-v4)
	end
	
	---Apply mul element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4:mul(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self[1]*v1,self[2]*v2,self[3]*v3,self[4]*v4)
	end
	
	---Apply mul element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4:mul_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self[1]*v1,self[2]*v2,self[3]*v3,self[4]*v4)
	end
	
	---Apply div element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4:div(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self[1]/v1,self[2]/v2,self[3]/v3,self[4]/v4)
	end
	
	---Apply div element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4:div_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self[1]/v1,self[2]/v2,self[3]/v3,self[4]/v4)
	end
	
	--- Operator metamethods
	vector_4.__add = vector_4.add
	vector_4.__sub = vector_4.sub
	vector_4.__mul = vector_4.mul
	vector_4.__div = vector_4.div
	vector_4.__unm = function(v) return v:mul(-1) end
	
	-----------------------------------------------------------
	-- Element access
	-----------------------------------------------------------
	
	---Get elements of the vector
	function vector_4:x()
		return self[1]
	end
	
	---Get elements of the vector
	function vector_4:y()
		return self[2]
	end
	
	---Get elements of the vector
	function vector_4:z()
		return self[3]
	end
	
	---Get elements of the vector
	function vector_4:w()
		return self[4]
	end
	
	---Get elements of the vector
	function vector_4:xx()
		return self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xy()
		return self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xz()
		return self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xw()
		return self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yx()
		return self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yy()
		return self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yz()
		return self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yw()
		return self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zx()
		return self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zy()
		return self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zz()
		return self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zw()
		return self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wx()
		return self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wy()
		return self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wz()
		return self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:ww()
		return self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xxx()
		return self[1], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xxy()
		return self[1], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xxz()
		return self[1], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xxw()
		return self[1], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xyx()
		return self[1], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xyy()
		return self[1], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xyz()
		return self[1], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xyw()
		return self[1], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xzx()
		return self[1], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xzy()
		return self[1], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xzz()
		return self[1], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xzw()
		return self[1], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xwx()
		return self[1], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xwy()
		return self[1], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xwz()
		return self[1], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xww()
		return self[1], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yxx()
		return self[2], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yxy()
		return self[2], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yxz()
		return self[2], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yxw()
		return self[2], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yyx()
		return self[2], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yyy()
		return self[2], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yyz()
		return self[2], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yyw()
		return self[2], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yzx()
		return self[2], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yzy()
		return self[2], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yzz()
		return self[2], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yzw()
		return self[2], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:ywx()
		return self[2], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:ywy()
		return self[2], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:ywz()
		return self[2], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yww()
		return self[2], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zxx()
		return self[3], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zxy()
		return self[3], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zxz()
		return self[3], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zxw()
		return self[3], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zyx()
		return self[3], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zyy()
		return self[3], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zyz()
		return self[3], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zyw()
		return self[3], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zzx()
		return self[3], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zzy()
		return self[3], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zzz()
		return self[3], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zzw()
		return self[3], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zwx()
		return self[3], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zwy()
		return self[3], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zwz()
		return self[3], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zww()
		return self[3], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wxx()
		return self[4], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wxy()
		return self[4], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wxz()
		return self[4], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wxw()
		return self[4], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wyx()
		return self[4], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wyy()
		return self[4], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wyz()
		return self[4], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wyw()
		return self[4], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wzx()
		return self[4], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wzy()
		return self[4], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wzz()
		return self[4], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wzw()
		return self[4], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wwx()
		return self[4], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wwy()
		return self[4], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wwz()
		return self[4], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:www()
		return self[4], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xxxx()
		return self[1], self[1], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xxxy()
		return self[1], self[1], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xxxz()
		return self[1], self[1], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xxxw()
		return self[1], self[1], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xxyx()
		return self[1], self[1], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xxyy()
		return self[1], self[1], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xxyz()
		return self[1], self[1], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xxyw()
		return self[1], self[1], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xxzx()
		return self[1], self[1], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xxzy()
		return self[1], self[1], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xxzz()
		return self[1], self[1], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xxzw()
		return self[1], self[1], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xxwx()
		return self[1], self[1], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xxwy()
		return self[1], self[1], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xxwz()
		return self[1], self[1], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xxww()
		return self[1], self[1], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xyxx()
		return self[1], self[2], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xyxy()
		return self[1], self[2], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xyxz()
		return self[1], self[2], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xyxw()
		return self[1], self[2], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xyyx()
		return self[1], self[2], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xyyy()
		return self[1], self[2], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xyyz()
		return self[1], self[2], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xyyw()
		return self[1], self[2], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xyzx()
		return self[1], self[2], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xyzy()
		return self[1], self[2], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xyzz()
		return self[1], self[2], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xyzw()
		return self[1], self[2], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xywx()
		return self[1], self[2], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xywy()
		return self[1], self[2], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xywz()
		return self[1], self[2], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xyww()
		return self[1], self[2], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xzxx()
		return self[1], self[3], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xzxy()
		return self[1], self[3], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xzxz()
		return self[1], self[3], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xzxw()
		return self[1], self[3], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xzyx()
		return self[1], self[3], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xzyy()
		return self[1], self[3], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xzyz()
		return self[1], self[3], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xzyw()
		return self[1], self[3], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xzzx()
		return self[1], self[3], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xzzy()
		return self[1], self[3], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xzzz()
		return self[1], self[3], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xzzw()
		return self[1], self[3], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xzwx()
		return self[1], self[3], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xzwy()
		return self[1], self[3], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xzwz()
		return self[1], self[3], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xzww()
		return self[1], self[3], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xwxx()
		return self[1], self[4], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xwxy()
		return self[1], self[4], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xwxz()
		return self[1], self[4], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xwxw()
		return self[1], self[4], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xwyx()
		return self[1], self[4], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xwyy()
		return self[1], self[4], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xwyz()
		return self[1], self[4], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xwyw()
		return self[1], self[4], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xwzx()
		return self[1], self[4], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xwzy()
		return self[1], self[4], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xwzz()
		return self[1], self[4], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xwzw()
		return self[1], self[4], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:xwwx()
		return self[1], self[4], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:xwwy()
		return self[1], self[4], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:xwwz()
		return self[1], self[4], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:xwww()
		return self[1], self[4], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yxxx()
		return self[2], self[1], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yxxy()
		return self[2], self[1], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yxxz()
		return self[2], self[1], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yxxw()
		return self[2], self[1], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yxyx()
		return self[2], self[1], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yxyy()
		return self[2], self[1], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yxyz()
		return self[2], self[1], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yxyw()
		return self[2], self[1], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yxzx()
		return self[2], self[1], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yxzy()
		return self[2], self[1], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yxzz()
		return self[2], self[1], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yxzw()
		return self[2], self[1], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yxwx()
		return self[2], self[1], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yxwy()
		return self[2], self[1], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yxwz()
		return self[2], self[1], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yxww()
		return self[2], self[1], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yyxx()
		return self[2], self[2], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yyxy()
		return self[2], self[2], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yyxz()
		return self[2], self[2], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yyxw()
		return self[2], self[2], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yyyx()
		return self[2], self[2], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yyyy()
		return self[2], self[2], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yyyz()
		return self[2], self[2], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yyyw()
		return self[2], self[2], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yyzx()
		return self[2], self[2], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yyzy()
		return self[2], self[2], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yyzz()
		return self[2], self[2], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yyzw()
		return self[2], self[2], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yywx()
		return self[2], self[2], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yywy()
		return self[2], self[2], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yywz()
		return self[2], self[2], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yyww()
		return self[2], self[2], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yzxx()
		return self[2], self[3], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yzxy()
		return self[2], self[3], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yzxz()
		return self[2], self[3], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yzxw()
		return self[2], self[3], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yzyx()
		return self[2], self[3], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yzyy()
		return self[2], self[3], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yzyz()
		return self[2], self[3], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yzyw()
		return self[2], self[3], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yzzx()
		return self[2], self[3], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yzzy()
		return self[2], self[3], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yzzz()
		return self[2], self[3], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yzzw()
		return self[2], self[3], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:yzwx()
		return self[2], self[3], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:yzwy()
		return self[2], self[3], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:yzwz()
		return self[2], self[3], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:yzww()
		return self[2], self[3], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:ywxx()
		return self[2], self[4], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:ywxy()
		return self[2], self[4], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:ywxz()
		return self[2], self[4], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:ywxw()
		return self[2], self[4], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:ywyx()
		return self[2], self[4], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:ywyy()
		return self[2], self[4], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:ywyz()
		return self[2], self[4], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:ywyw()
		return self[2], self[4], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:ywzx()
		return self[2], self[4], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:ywzy()
		return self[2], self[4], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:ywzz()
		return self[2], self[4], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:ywzw()
		return self[2], self[4], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:ywwx()
		return self[2], self[4], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:ywwy()
		return self[2], self[4], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:ywwz()
		return self[2], self[4], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:ywww()
		return self[2], self[4], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zxxx()
		return self[3], self[1], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zxxy()
		return self[3], self[1], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zxxz()
		return self[3], self[1], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zxxw()
		return self[3], self[1], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zxyx()
		return self[3], self[1], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zxyy()
		return self[3], self[1], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zxyz()
		return self[3], self[1], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zxyw()
		return self[3], self[1], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zxzx()
		return self[3], self[1], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zxzy()
		return self[3], self[1], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zxzz()
		return self[3], self[1], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zxzw()
		return self[3], self[1], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zxwx()
		return self[3], self[1], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zxwy()
		return self[3], self[1], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zxwz()
		return self[3], self[1], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zxww()
		return self[3], self[1], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zyxx()
		return self[3], self[2], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zyxy()
		return self[3], self[2], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zyxz()
		return self[3], self[2], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zyxw()
		return self[3], self[2], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zyyx()
		return self[3], self[2], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zyyy()
		return self[3], self[2], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zyyz()
		return self[3], self[2], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zyyw()
		return self[3], self[2], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zyzx()
		return self[3], self[2], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zyzy()
		return self[3], self[2], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zyzz()
		return self[3], self[2], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zyzw()
		return self[3], self[2], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zywx()
		return self[3], self[2], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zywy()
		return self[3], self[2], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zywz()
		return self[3], self[2], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zyww()
		return self[3], self[2], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zzxx()
		return self[3], self[3], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zzxy()
		return self[3], self[3], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zzxz()
		return self[3], self[3], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zzxw()
		return self[3], self[3], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zzyx()
		return self[3], self[3], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zzyy()
		return self[3], self[3], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zzyz()
		return self[3], self[3], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zzyw()
		return self[3], self[3], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zzzx()
		return self[3], self[3], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zzzy()
		return self[3], self[3], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zzzz()
		return self[3], self[3], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zzzw()
		return self[3], self[3], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zzwx()
		return self[3], self[3], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zzwy()
		return self[3], self[3], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zzwz()
		return self[3], self[3], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zzww()
		return self[3], self[3], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zwxx()
		return self[3], self[4], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zwxy()
		return self[3], self[4], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zwxz()
		return self[3], self[4], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zwxw()
		return self[3], self[4], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zwyx()
		return self[3], self[4], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zwyy()
		return self[3], self[4], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zwyz()
		return self[3], self[4], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zwyw()
		return self[3], self[4], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zwzx()
		return self[3], self[4], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zwzy()
		return self[3], self[4], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zwzz()
		return self[3], self[4], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zwzw()
		return self[3], self[4], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:zwwx()
		return self[3], self[4], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:zwwy()
		return self[3], self[4], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:zwwz()
		return self[3], self[4], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:zwww()
		return self[3], self[4], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wxxx()
		return self[4], self[1], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wxxy()
		return self[4], self[1], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wxxz()
		return self[4], self[1], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wxxw()
		return self[4], self[1], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wxyx()
		return self[4], self[1], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wxyy()
		return self[4], self[1], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wxyz()
		return self[4], self[1], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wxyw()
		return self[4], self[1], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wxzx()
		return self[4], self[1], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wxzy()
		return self[4], self[1], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wxzz()
		return self[4], self[1], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wxzw()
		return self[4], self[1], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wxwx()
		return self[4], self[1], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wxwy()
		return self[4], self[1], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wxwz()
		return self[4], self[1], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wxww()
		return self[4], self[1], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wyxx()
		return self[4], self[2], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wyxy()
		return self[4], self[2], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wyxz()
		return self[4], self[2], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wyxw()
		return self[4], self[2], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wyyx()
		return self[4], self[2], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wyyy()
		return self[4], self[2], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wyyz()
		return self[4], self[2], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wyyw()
		return self[4], self[2], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wyzx()
		return self[4], self[2], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wyzy()
		return self[4], self[2], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wyzz()
		return self[4], self[2], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wyzw()
		return self[4], self[2], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wywx()
		return self[4], self[2], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wywy()
		return self[4], self[2], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wywz()
		return self[4], self[2], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wyww()
		return self[4], self[2], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wzxx()
		return self[4], self[3], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wzxy()
		return self[4], self[3], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wzxz()
		return self[4], self[3], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wzxw()
		return self[4], self[3], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wzyx()
		return self[4], self[3], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wzyy()
		return self[4], self[3], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wzyz()
		return self[4], self[3], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wzyw()
		return self[4], self[3], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wzzx()
		return self[4], self[3], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wzzy()
		return self[4], self[3], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wzzz()
		return self[4], self[3], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wzzw()
		return self[4], self[3], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wzwx()
		return self[4], self[3], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wzwy()
		return self[4], self[3], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wzwz()
		return self[4], self[3], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wzww()
		return self[4], self[3], self[4], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wwxx()
		return self[4], self[4], self[1], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wwxy()
		return self[4], self[4], self[1], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wwxz()
		return self[4], self[4], self[1], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wwxw()
		return self[4], self[4], self[1], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wwyx()
		return self[4], self[4], self[2], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wwyy()
		return self[4], self[4], self[2], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wwyz()
		return self[4], self[4], self[2], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wwyw()
		return self[4], self[4], self[2], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wwzx()
		return self[4], self[4], self[3], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wwzy()
		return self[4], self[4], self[3], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wwzz()
		return self[4], self[4], self[3], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wwzw()
		return self[4], self[4], self[3], self[4]
	end
	
	---Get elements of the vector
	function vector_4:wwwx()
		return self[4], self[4], self[4], self[1]
	end
	
	---Get elements of the vector
	function vector_4:wwwy()
		return self[4], self[4], self[4], self[2]
	end
	
	---Get elements of the vector
	function vector_4:wwwz()
		return self[4], self[4], self[4], self[3]
	end
	
	---Get elements of the vector
	function vector_4:wwww()
		return self[4], self[4], self[4], self[4]
	end
	
	---Set elements of the vector
	function vector_4:set_x(v1)
		self[1] = v1
	end
	
	---Set elements of the vector
	function vector_4:set_y(v1)
		self[2] = v1
	end
	
	---Set elements of the vector
	function vector_4:set_z(v1)
		self[3] = v1
	end
	
	---Set elements of the vector
	function vector_4:set_w(v1)
		self[4] = v1
	end
	
	---Set elements of the vector
	function vector_4:set_xy(v1, v2)
		self[1], self[2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_xz(v1, v2)
		self[1], self[3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_xw(v1, v2)
		self[1], self[4] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_yx(v1, v2)
		self[2], self[1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_yz(v1, v2)
		self[2], self[3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_yw(v1, v2)
		self[2], self[4] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_zx(v1, v2)
		self[3], self[1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_zy(v1, v2)
		self[3], self[2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_zw(v1, v2)
		self[3], self[4] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_wx(v1, v2)
		self[4], self[1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_wy(v1, v2)
		self[4], self[2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_wz(v1, v2)
		self[4], self[3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4:set_xyz(v1, v2, v3)
		self[1], self[2], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_xyw(v1, v2, v3)
		self[1], self[2], self[4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_xzy(v1, v2, v3)
		self[1], self[3], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_xzw(v1, v2, v3)
		self[1], self[3], self[4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_xwy(v1, v2, v3)
		self[1], self[4], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_xwz(v1, v2, v3)
		self[1], self[4], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_yxz(v1, v2, v3)
		self[2], self[1], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_yxw(v1, v2, v3)
		self[2], self[1], self[4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_yzx(v1, v2, v3)
		self[2], self[3], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_yzw(v1, v2, v3)
		self[2], self[3], self[4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_ywx(v1, v2, v3)
		self[2], self[4], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_ywz(v1, v2, v3)
		self[2], self[4], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_zxy(v1, v2, v3)
		self[3], self[1], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_zxw(v1, v2, v3)
		self[3], self[1], self[4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_zyx(v1, v2, v3)
		self[3], self[2], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_zyw(v1, v2, v3)
		self[3], self[2], self[4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_zwx(v1, v2, v3)
		self[3], self[4], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_zwy(v1, v2, v3)
		self[3], self[4], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_wxy(v1, v2, v3)
		self[4], self[1], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_wxz(v1, v2, v3)
		self[4], self[1], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_wyx(v1, v2, v3)
		self[4], self[2], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_wyz(v1, v2, v3)
		self[4], self[2], self[3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_wzx(v1, v2, v3)
		self[4], self[3], self[1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_wzy(v1, v2, v3)
		self[4], self[3], self[2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4:set_xyzw(v1, v2, v3, v4)
		self[1], self[2], self[3], self[4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_xywz(v1, v2, v3, v4)
		self[1], self[2], self[4], self[3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_xzyw(v1, v2, v3, v4)
		self[1], self[3], self[2], self[4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_xzwy(v1, v2, v3, v4)
		self[1], self[3], self[4], self[2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_xwyz(v1, v2, v3, v4)
		self[1], self[4], self[2], self[3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_xwzy(v1, v2, v3, v4)
		self[1], self[4], self[3], self[2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_yxzw(v1, v2, v3, v4)
		self[2], self[1], self[3], self[4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_yxwz(v1, v2, v3, v4)
		self[2], self[1], self[4], self[3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_yzxw(v1, v2, v3, v4)
		self[2], self[3], self[1], self[4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_yzwx(v1, v2, v3, v4)
		self[2], self[3], self[4], self[1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_ywxz(v1, v2, v3, v4)
		self[2], self[4], self[1], self[3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_ywzx(v1, v2, v3, v4)
		self[2], self[4], self[3], self[1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_zxyw(v1, v2, v3, v4)
		self[3], self[1], self[2], self[4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_zxwy(v1, v2, v3, v4)
		self[3], self[1], self[4], self[2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_zyxw(v1, v2, v3, v4)
		self[3], self[2], self[1], self[4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_zywx(v1, v2, v3, v4)
		self[3], self[2], self[4], self[1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_zwxy(v1, v2, v3, v4)
		self[3], self[4], self[1], self[2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_zwyx(v1, v2, v3, v4)
		self[3], self[4], self[2], self[1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_wxyz(v1, v2, v3, v4)
		self[4], self[1], self[2], self[3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_wxzy(v1, v2, v3, v4)
		self[4], self[1], self[3], self[2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_wyxz(v1, v2, v3, v4)
		self[4], self[2], self[1], self[3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_wyzx(v1, v2, v3, v4)
		self[4], self[2], self[3], self[1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_wzxy(v1, v2, v3, v4)
		self[4], self[3], self[1], self[2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4:set_wzyx(v1, v2, v3, v4)
		self[4], self[3], self[2], self[1] = v1, v2, v3, v4
	end
	
	--[[
	function vector_4_slice:__index(key)
		if type(key) == 'number' and key >= 1 and key <= 4 then
				return self._src[self._o+key]
		else
			return vector_4_slice[key]
		end
	end
	function vector_4_slice:__newindex(key, value)
		if type(key) == 'number' and key >= 1 and key <= 4 then
				self._src[self._o+key] = value
		else
			rawset(self, key, value)
		end
	end
	
	function vector_4_slice:__len()
		return 4
	end
	
	function vector_4_slice:__tostring()
		return format.array("${format_string}", self)
	end
	
	function vector_4_slice:copy()
		return M.new(self:get())
	end
	
	function vector_4_slice:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function vector_4_slice:get()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Set values from a tuple
	function vector_4_slice:set(v1, v2, v3, v4)
		assert(v1, "bad argument 'v1' (expected number, got nil)")
		assert(v2, "bad argument 'v2' (expected number, got nil)")
		assert(v3, "bad argument 'v3' (expected number, got nil)")
		assert(v4, "bad argument 'v4' (expected number, got nil)")
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Apply add element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:add(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3,self._src[self._o+4]+v4)
	end
	
	---Apply add element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:add_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3,self._src[self._o+4]+v4)
	end
	
	---Apply sub element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:sub(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3,self._src[self._o+4]-v4)
	end
	
	---Apply sub element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:sub_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3,self._src[self._o+4]-v4)
	end
	
	---Apply mul element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:mul(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3,self._src[self._o+4]*v4)
	end
	
	---Apply mul element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:mul_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3,self._src[self._o+4]*v4)
	end
	
	---Apply div element-wise and return a new vector_4
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:div(v)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		return M.new(self._src[self._o+1]/v1,self._src[self._o+2]/v2,self._src[self._o+3]/v3,self._src[self._o+4]/v4)
	end
	
	---Apply div element-wise and store the result in dest
	---
	---Parameter `v` can be a number or array
	function vector_4_slice:div_into(v, dest, dest_index)
		local is_number = type(v) == 'number'
		local v1, v2, v3, v4 	if not is_number then
				assert(v, "bad argument 'v' (expected array or sequence, got nil)")
			v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
		else
				v1, v2, v3, v4 = v, v, v, v
		end
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self._src[self._o+1]/v1,self._src[self._o+2]/v2,self._src[self._o+3]/v3,self._src[self._o+4]/v4)
	end
	
	--- Operator metamethods
	vector_4_slice.__add = vector_4_slice.add
	vector_4_slice.__sub = vector_4_slice.sub
	vector_4_slice.__mul = vector_4_slice.mul
	vector_4_slice.__div = vector_4_slice.div
	vector_4_slice.__unm = function(v) return v:mul(-1) end
	
	-----------------------------------------------------------
	-- Element access
	-----------------------------------------------------------
	
	---Get elements of the vector
	function vector_4_slice:x()
		return self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:y()
		return self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:z()
		return self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:w()
		return self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xx()
		return self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xy()
		return self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xz()
		return self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xw()
		return self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yx()
		return self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yy()
		return self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yz()
		return self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yw()
		return self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zx()
		return self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zy()
		return self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zz()
		return self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zw()
		return self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wx()
		return self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wy()
		return self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wz()
		return self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:ww()
		return self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxx()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxy()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxz()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxw()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyx()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyy()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyz()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyw()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzx()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzy()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzz()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzw()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwx()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwy()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwz()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xww()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxx()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxy()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxz()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxw()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyx()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyy()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyz()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyw()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzx()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzy()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzz()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzw()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywx()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywy()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywz()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yww()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxx()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxy()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxz()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxw()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyx()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyy()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyz()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyw()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzx()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzy()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzz()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzw()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwx()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwy()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwz()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zww()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxx()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxy()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxz()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxw()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyx()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyy()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyz()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyw()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzx()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzy()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzz()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzw()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwx()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwy()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwz()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:www()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxxx()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxxy()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxxz()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxxw()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxyx()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxyy()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxyz()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxyw()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxzx()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxzy()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxzz()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxzw()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxwx()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxwy()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxwz()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xxww()
		return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyxx()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyxy()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyxz()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyxw()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyyx()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyyy()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyyz()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyyw()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyzx()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyzy()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyzz()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyzw()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xywx()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xywy()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xywz()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xyww()
		return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzxx()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzxy()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzxz()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzxw()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzyx()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzyy()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzyz()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzyw()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzzx()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzzy()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzzz()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzzw()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzwx()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzwy()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzwz()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xzww()
		return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwxx()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwxy()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwxz()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwxw()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwyx()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwyy()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwyz()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwyw()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwzx()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwzy()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwzz()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwzw()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwwx()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwwy()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwwz()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:xwww()
		return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxxx()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxxy()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxxz()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxxw()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxyx()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxyy()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxyz()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxyw()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxzx()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxzy()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxzz()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxzw()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxwx()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxwy()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxwz()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yxww()
		return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyxx()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyxy()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyxz()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyxw()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyyx()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyyy()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyyz()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyyw()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyzx()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyzy()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyzz()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyzw()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yywx()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yywy()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yywz()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yyww()
		return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzxx()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzxy()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzxz()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzxw()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzyx()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzyy()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzyz()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzyw()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzzx()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzzy()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzzz()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzzw()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzwx()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzwy()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzwz()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:yzww()
		return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywxx()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywxy()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywxz()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywxw()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywyx()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywyy()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywyz()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywyw()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywzx()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywzy()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywzz()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywzw()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywwx()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywwy()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywwz()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:ywww()
		return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxxx()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxxy()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxxz()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxxw()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxyx()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxyy()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxyz()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxyw()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxzx()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxzy()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxzz()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxzw()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxwx()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxwy()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxwz()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zxww()
		return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyxx()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyxy()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyxz()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyxw()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyyx()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyyy()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyyz()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyyw()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyzx()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyzy()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyzz()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyzw()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zywx()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zywy()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zywz()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zyww()
		return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzxx()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzxy()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzxz()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzxw()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzyx()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzyy()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzyz()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzyw()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzzx()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzzy()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzzz()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzzw()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzwx()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzwy()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzwz()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zzww()
		return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwxx()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwxy()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwxz()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwxw()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwyx()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwyy()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwyz()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwyw()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwzx()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwzy()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwzz()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwzw()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwwx()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwwy()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwwz()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:zwww()
		return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxxx()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxxy()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxxz()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxxw()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxyx()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxyy()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxyz()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxyw()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxzx()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxzy()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxzz()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxzw()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxwx()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxwy()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxwz()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wxww()
		return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyxx()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyxy()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyxz()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyxw()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyyx()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyyy()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyyz()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyyw()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyzx()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyzy()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyzz()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyzw()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wywx()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wywy()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wywz()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wyww()
		return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzxx()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzxy()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzxz()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzxw()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzyx()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzyy()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzyz()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzyw()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzzx()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzzy()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzzz()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzzw()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzwx()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzwy()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzwz()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wzww()
		return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwxx()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwxy()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwxz()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwxw()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwyx()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwyy()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwyz()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwyw()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwzx()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwzy()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwzz()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwzw()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwwx()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwwy()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwwz()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
	end
	
	---Get elements of the vector
	function vector_4_slice:wwww()
		return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
	end
	
	---Set elements of the vector
	function vector_4_slice:set_x(v1)
		self._src[self._o+1] = v1
	end
	
	---Set elements of the vector
	function vector_4_slice:set_y(v1)
		self._src[self._o+2] = v1
	end
	
	---Set elements of the vector
	function vector_4_slice:set_z(v1)
		self._src[self._o+3] = v1
	end
	
	---Set elements of the vector
	function vector_4_slice:set_w(v1)
		self._src[self._o+4] = v1
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xy(v1, v2)
		self._src[self._o+1], self._src[self._o+2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xz(v1, v2)
		self._src[self._o+1], self._src[self._o+3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xw(v1, v2)
		self._src[self._o+1], self._src[self._o+4] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yx(v1, v2)
		self._src[self._o+2], self._src[self._o+1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yz(v1, v2)
		self._src[self._o+2], self._src[self._o+3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yw(v1, v2)
		self._src[self._o+2], self._src[self._o+4] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zx(v1, v2)
		self._src[self._o+3], self._src[self._o+1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zy(v1, v2)
		self._src[self._o+3], self._src[self._o+2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zw(v1, v2)
		self._src[self._o+3], self._src[self._o+4] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wx(v1, v2)
		self._src[self._o+4], self._src[self._o+1] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wy(v1, v2)
		self._src[self._o+4], self._src[self._o+2] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wz(v1, v2)
		self._src[self._o+4], self._src[self._o+3] = v1, v2
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xyz(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xyw(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xzy(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xzw(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xwy(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xwz(v1, v2, v3)
		self._src[self._o+1], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yxz(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yxw(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yzx(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yzw(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_ywx(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_ywz(v1, v2, v3)
		self._src[self._o+2], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zxy(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zxw(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zyx(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zyw(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zwx(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zwy(v1, v2, v3)
		self._src[self._o+3], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wxy(v1, v2, v3)
		self._src[self._o+4], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wxz(v1, v2, v3)
		self._src[self._o+4], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wyx(v1, v2, v3)
		self._src[self._o+4], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wyz(v1, v2, v3)
		self._src[self._o+4], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wzx(v1, v2, v3)
		self._src[self._o+4], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wzy(v1, v2, v3)
		self._src[self._o+4], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xyzw(v1, v2, v3, v4)
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xywz(v1, v2, v3, v4)
		self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xzyw(v1, v2, v3, v4)
		self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xzwy(v1, v2, v3, v4)
		self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xwyz(v1, v2, v3, v4)
		self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_xwzy(v1, v2, v3, v4)
		self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yxzw(v1, v2, v3, v4)
		self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yxwz(v1, v2, v3, v4)
		self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yzxw(v1, v2, v3, v4)
		self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_yzwx(v1, v2, v3, v4)
		self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_ywxz(v1, v2, v3, v4)
		self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_ywzx(v1, v2, v3, v4)
		self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zxyw(v1, v2, v3, v4)
		self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zxwy(v1, v2, v3, v4)
		self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zyxw(v1, v2, v3, v4)
		self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zywx(v1, v2, v3, v4)
		self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zwxy(v1, v2, v3, v4)
		self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_zwyx(v1, v2, v3, v4)
		self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wxyz(v1, v2, v3, v4)
		self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wxzy(v1, v2, v3, v4)
		self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wyxz(v1, v2, v3, v4)
		self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wyzx(v1, v2, v3, v4)
		self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wzxy(v1, v2, v3, v4)
		self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3, v4
	end
	
	---Set elements of the vector
	function vector_4_slice:set_wzyx(v1, v2, v3, v4)
		self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3, v4
	end
	
	--]]
	
	avm.vector_4 = M
	
end

-- Module matrix_2.lua
do
	
	--[[
	Matrix operations and types  
	
	Classes and functions for working with matrices  
	
	]]
	local M = {}
	
	local array = avm.array
	
	local linalg = avm.linalg
	
	local format = avm.format
	
	---Disable warnings for _ex type overloaded functions
	
	---2x2 matrix in column-major order constructed from a tuple
	---
	local matrix_2 = {}
	
	---A 2x2 matrix in column-major order that views into an array or slice
	---
	local matrix_2_slice = {}
	
	-----------------------------------------------------------
	-- Matrix creation
	-----------------------------------------------------------
	
	---Create a new matrix_2
	---Parameter `e_ij` determines the value of `i'th` column `j'th` row
	function M.new(e_11, e_12, e_21, e_22)
		assert(e_11, "bad argument 'e_11' (expected number, got nil)")
		assert(e_12, "bad argument 'e_12' (expected number, got nil)")
		assert(e_21, "bad argument 'e_21' (expected number, got nil)")
		assert(e_22, "bad argument 'e_22' (expected number, got nil)")
		return setmetatable({e_11, e_12, e_21, e_22}, matrix_2)
	end
	
	matrix_2.__index = matrix_2
	matrix_2.__len = function()
		return 4
	end
	
	function matrix_2:__tostring()
		return format.array(self)
	end
	
	function matrix_2:copy()
		return M.new(self:get())
	end
	
	function matrix_2:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function matrix_2:get()
		return self[1], self[2], self[3], self[4]
	end
	
	---Set values from a tuple
	---
	---Parameter `e_ij` determines the value of `i'th` column `j'th` row
	function matrix_2:set(e_11, e_12, e_21, e_22)
		assert(e_11, "bad argument 'e_11' (expected number, got nil)")
		assert(e_12, "bad argument 'e_12' (expected number, got nil)")
		assert(e_21, "bad argument 'e_21' (expected number, got nil)")
		assert(e_22, "bad argument 'e_22' (expected number, got nil)")
		self[1], self[2], self[3], self[4] = e_11, e_12, e_21, e_22
	end
	---Apply addition element-wise and return a new matrix_2
	---
	---Parameter `m` can be a number or array
	function matrix_2:add(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4])
		else
				return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m)
		end
		
	end
	
	---Apply addition element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_2:add_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4])
		else
				array.set_4(dest, dest_index or 1, self[1]+m,self[2]+m,self[3]+m,self[4]+m)
		end
	end
	
	---Apply subtraction element-wise and return a new matrix_2
	---
	---Parameter `m` can be a number or array
	function matrix_2:sub(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4])
		else
				return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m)
		end
		
	end
	
	---Apply subtraction element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_2:sub_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4])
		else
				array.set_4(dest, dest_index or 1, self[1]-m,self[2]-m,self[3]-m,self[4]-m)
		end
	end
	
	---Apply multiplication element-wise and return a new matrix_2
	---
	---Parameter `m` can be a number or array
	function matrix_2:mul(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4])
		else
				return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m)
		end
		
	end
	
	---Apply multiplication element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_2:mul_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4])
		else
				array.set_4(dest, dest_index or 1, self[1]*m,self[2]*m,self[3]*m,self[4]*m)
		end
	end
	
	---Apply division element-wise and return a new matrix_2
	---
	---Parameter `m` can be a number or array
	function matrix_2:div(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4])
		else
				return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m)
		end
		
	end
	
	---Apply division element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_2:div_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_4(dest, dest_index or 1, self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4])
		else
				array.set_4(dest, dest_index or 1, self[1]/m,self[2]/m,self[3]/m,self[4]/m)
		end
	end
	
	--- Operator metamethods
	matrix_2.__add = matrix_2.add
	matrix_2.__sub = matrix_2.sub
	matrix_2.__mul = matrix_2.mul
	matrix_2.__div = matrix_2.div
	matrix_2.__unm = function(m) return m:mul(-1) end
	
	---Multiply with a matrix and return the result
	---
	function matrix_2:matmul(m)
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(linalg.matmul_mat2_mat2(self, m))
	end
	
	---Multiply with a matrix and store the result in a destination
	---
	function matrix_2:matmul_into(m, dest, dest_index)
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_4(dest, dest_index or 1, linalg.matmul_mat2_mat2(self, m))
	end
	
	avm.matrix_2 = M
	
end

-- Module matrix_3.lua
do
	
	--[[
	Matrix operations and types  
	
	Classes and functions for working with matrices  
	
	]]
	local M = {}
	
	local array = avm.array
	
	local linalg = avm.linalg
	
	local format = avm.format
	
	---Disable warnings for _ex type overloaded functions
	
	---3x3 matrix in column-major order constructed from a tuple
	---
	local matrix_3 = {}
	
	---A 3x3 matrix in column-major order that views into an array or slice
	---
	local matrix_3_slice = {}
	
	-----------------------------------------------------------
	-- Matrix creation
	-----------------------------------------------------------
	
	---Create a new matrix_3
	---Parameter `e_ij` determines the value of `i'th` column `j'th` row
	function M.new(e_11, e_12, e_13, e_21, e_22, e_23, e_31, e_32, e_33)
		assert(e_11, "bad argument 'e_11' (expected number, got nil)")
		assert(e_12, "bad argument 'e_12' (expected number, got nil)")
		assert(e_13, "bad argument 'e_13' (expected number, got nil)")
		assert(e_21, "bad argument 'e_21' (expected number, got nil)")
		assert(e_22, "bad argument 'e_22' (expected number, got nil)")
		assert(e_23, "bad argument 'e_23' (expected number, got nil)")
		assert(e_31, "bad argument 'e_31' (expected number, got nil)")
		assert(e_32, "bad argument 'e_32' (expected number, got nil)")
		assert(e_33, "bad argument 'e_33' (expected number, got nil)")
		return setmetatable({e_11, e_12, e_13, e_21, e_22, e_23, e_31, e_32, e_33}, matrix_3)
	end
	
	matrix_3.__index = matrix_3
	matrix_3.__len = function()
		return 9
	end
	
	function matrix_3:__tostring()
		return format.array(self)
	end
	
	function matrix_3:copy()
		return M.new(self:get())
	end
	
	function matrix_3:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_9(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function matrix_3:get()
		return self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9]
	end
	
	---Set values from a tuple
	---
	---Parameter `e_ij` determines the value of `i'th` column `j'th` row
	function matrix_3:set(e_11, e_12, e_13, e_21, e_22, e_23, e_31, e_32, e_33)
		assert(e_11, "bad argument 'e_11' (expected number, got nil)")
		assert(e_12, "bad argument 'e_12' (expected number, got nil)")
		assert(e_13, "bad argument 'e_13' (expected number, got nil)")
		assert(e_21, "bad argument 'e_21' (expected number, got nil)")
		assert(e_22, "bad argument 'e_22' (expected number, got nil)")
		assert(e_23, "bad argument 'e_23' (expected number, got nil)")
		assert(e_31, "bad argument 'e_31' (expected number, got nil)")
		assert(e_32, "bad argument 'e_32' (expected number, got nil)")
		assert(e_33, "bad argument 'e_33' (expected number, got nil)")
		self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9] = e_11, e_12, e_13, e_21, e_22, e_23, e_31, e_32, e_33
	end
	---Apply addition element-wise and return a new matrix_3
	---
	---Parameter `m` can be a number or array
	function matrix_3:add(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9])
		else
				return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m)
		end
		
	end
	
	---Apply addition element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_3:add_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9])
		else
				array.set_9(dest, dest_index or 1, self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m)
		end
	end
	
	---Apply subtraction element-wise and return a new matrix_3
	---
	---Parameter `m` can be a number or array
	function matrix_3:sub(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9])
		else
				return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m)
		end
		
	end
	
	---Apply subtraction element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_3:sub_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9])
		else
				array.set_9(dest, dest_index or 1, self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m)
		end
	end
	
	---Apply multiplication element-wise and return a new matrix_3
	---
	---Parameter `m` can be a number or array
	function matrix_3:mul(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9])
		else
				return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m)
		end
		
	end
	
	---Apply multiplication element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_3:mul_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9])
		else
				array.set_9(dest, dest_index or 1, self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m)
		end
	end
	
	---Apply division element-wise and return a new matrix_3
	---
	---Parameter `m` can be a number or array
	function matrix_3:div(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9])
		else
				return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m,self[5]/m,self[6]/m,self[7]/m,self[8]/m,self[9]/m)
		end
		
	end
	
	---Apply division element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_3:div_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_9(dest, dest_index or 1, self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9])
		else
				array.set_9(dest, dest_index or 1, self[1]/m,self[2]/m,self[3]/m,self[4]/m,self[5]/m,self[6]/m,self[7]/m,self[8]/m,self[9]/m)
		end
	end
	
	--- Operator metamethods
	matrix_3.__add = matrix_3.add
	matrix_3.__sub = matrix_3.sub
	matrix_3.__mul = matrix_3.mul
	matrix_3.__div = matrix_3.div
	matrix_3.__unm = function(m) return m:mul(-1) end
	
	---Multiply with a matrix and return the result
	---
	function matrix_3:matmul(m)
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(linalg.matmul_mat3_mat3(self, m))
	end
	
	---Multiply with a matrix and store the result in a destination
	---
	function matrix_3:matmul_into(m, dest, dest_index)
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_9(dest, dest_index or 1, linalg.matmul_mat3_mat3(self, m))
	end
	
	avm.matrix_3 = M
	
end

-- Module matrix_4.lua
do
	
	--[[
	Matrix operations and types  
	
	Classes and functions for working with matrices  
	
	]]
	local M = {}
	
	local array = avm.array
	
	local linalg = avm.linalg
	
	local format = avm.format
	
	---Disable warnings for _ex type overloaded functions
	
	---4x4 matrix in column-major order constructed from a tuple
	---
	local matrix_4 = {}
	
	---A 4x4 matrix in column-major order that views into an array or slice
	---
	local matrix_4_slice = {}
	
	-----------------------------------------------------------
	-- Matrix creation
	-----------------------------------------------------------
	
	---Create a new matrix_4
	---Parameter `e_ij` determines the value of `i'th` column `j'th` row
	function M.new(e_11, e_12, e_13, e_14, e_21, e_22, e_23, e_24, e_31, e_32, e_33, e_34, e_41, e_42, e_43, e_44)
		assert(e_11, "bad argument 'e_11' (expected number, got nil)")
		assert(e_12, "bad argument 'e_12' (expected number, got nil)")
		assert(e_13, "bad argument 'e_13' (expected number, got nil)")
		assert(e_14, "bad argument 'e_14' (expected number, got nil)")
		assert(e_21, "bad argument 'e_21' (expected number, got nil)")
		assert(e_22, "bad argument 'e_22' (expected number, got nil)")
		assert(e_23, "bad argument 'e_23' (expected number, got nil)")
		assert(e_24, "bad argument 'e_24' (expected number, got nil)")
		assert(e_31, "bad argument 'e_31' (expected number, got nil)")
		assert(e_32, "bad argument 'e_32' (expected number, got nil)")
		assert(e_33, "bad argument 'e_33' (expected number, got nil)")
		assert(e_34, "bad argument 'e_34' (expected number, got nil)")
		assert(e_41, "bad argument 'e_41' (expected number, got nil)")
		assert(e_42, "bad argument 'e_42' (expected number, got nil)")
		assert(e_43, "bad argument 'e_43' (expected number, got nil)")
		assert(e_44, "bad argument 'e_44' (expected number, got nil)")
		return setmetatable({e_11, e_12, e_13, e_14, e_21, e_22, e_23, e_24, e_31, e_32, e_33, e_34, e_41, e_42, e_43, e_44}, matrix_4)
	end
	
	matrix_4.__index = matrix_4
	matrix_4.__len = function()
		return 16
	end
	
	function matrix_4:__tostring()
		return format.array(self)
	end
	
	function matrix_4:copy()
		return M.new(self:get())
	end
	
	function matrix_4:copy_into(dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_16(dest, dest_index or 1, self:get())
	end
	
	---Get values as a tuple
	function matrix_4:get()
		return self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9], self[10], self[11], self[12], self[13], self[14], self[15], self[16]
	end
	
	---Set values from a tuple
	---
	---Parameter `e_ij` determines the value of `i'th` column `j'th` row
	function matrix_4:set(e_11, e_12, e_13, e_14, e_21, e_22, e_23, e_24, e_31, e_32, e_33, e_34, e_41, e_42, e_43, e_44)
		assert(e_11, "bad argument 'e_11' (expected number, got nil)")
		assert(e_12, "bad argument 'e_12' (expected number, got nil)")
		assert(e_13, "bad argument 'e_13' (expected number, got nil)")
		assert(e_14, "bad argument 'e_14' (expected number, got nil)")
		assert(e_21, "bad argument 'e_21' (expected number, got nil)")
		assert(e_22, "bad argument 'e_22' (expected number, got nil)")
		assert(e_23, "bad argument 'e_23' (expected number, got nil)")
		assert(e_24, "bad argument 'e_24' (expected number, got nil)")
		assert(e_31, "bad argument 'e_31' (expected number, got nil)")
		assert(e_32, "bad argument 'e_32' (expected number, got nil)")
		assert(e_33, "bad argument 'e_33' (expected number, got nil)")
		assert(e_34, "bad argument 'e_34' (expected number, got nil)")
		assert(e_41, "bad argument 'e_41' (expected number, got nil)")
		assert(e_42, "bad argument 'e_42' (expected number, got nil)")
		assert(e_43, "bad argument 'e_43' (expected number, got nil)")
		assert(e_44, "bad argument 'e_44' (expected number, got nil)")
		self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9], self[10], self[11], self[12], self[13], self[14], self[15], self[16] = e_11, e_12, e_13, e_14, e_21, e_22, e_23, e_24, e_31, e_32, e_33, e_34, e_41, e_42, e_43, e_44
	end
	---Apply addition element-wise and return a new matrix_4
	---
	---Parameter `m` can be a number or array
	function matrix_4:add(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9],self[10]+m[10],self[11]+m[11],self[12]+m[12],self[13]+m[13],self[14]+m[14],self[15]+m[15],self[16]+m[16])
		else
				return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m,self[10]+m,self[11]+m,self[12]+m,self[13]+m,self[14]+m,self[15]+m,self[16]+m)
		end
		
	end
	
	---Apply addition element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_4:add_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9],self[10]+m[10],self[11]+m[11],self[12]+m[12],self[13]+m[13],self[14]+m[14],self[15]+m[15],self[16]+m[16])
		else
				array.set_16(dest, dest_index or 1, self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m,self[10]+m,self[11]+m,self[12]+m,self[13]+m,self[14]+m,self[15]+m,self[16]+m)
		end
	end
	
	---Apply subtraction element-wise and return a new matrix_4
	---
	---Parameter `m` can be a number or array
	function matrix_4:sub(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9],self[10]-m[10],self[11]-m[11],self[12]-m[12],self[13]-m[13],self[14]-m[14],self[15]-m[15],self[16]-m[16])
		else
				return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m,self[10]-m,self[11]-m,self[12]-m,self[13]-m,self[14]-m,self[15]-m,self[16]-m)
		end
		
	end
	
	---Apply subtraction element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_4:sub_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9],self[10]-m[10],self[11]-m[11],self[12]-m[12],self[13]-m[13],self[14]-m[14],self[15]-m[15],self[16]-m[16])
		else
				array.set_16(dest, dest_index or 1, self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m,self[10]-m,self[11]-m,self[12]-m,self[13]-m,self[14]-m,self[15]-m,self[16]-m)
		end
	end
	
	---Apply multiplication element-wise and return a new matrix_4
	---
	---Parameter `m` can be a number or array
	function matrix_4:mul(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9],self[10]*m[10],self[11]*m[11],self[12]*m[12],self[13]*m[13],self[14]*m[14],self[15]*m[15],self[16]*m[16])
		else
				return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m,self[10]*m,self[11]*m,self[12]*m,self[13]*m,self[14]*m,self[15]*m,self[16]*m)
		end
		
	end
	
	---Apply multiplication element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_4:mul_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9],self[10]*m[10],self[11]*m[11],self[12]*m[12],self[13]*m[13],self[14]*m[14],self[15]*m[15],self[16]*m[16])
		else
				array.set_16(dest, dest_index or 1, self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m,self[10]*m,self[11]*m,self[12]*m,self[13]*m,self[14]*m,self[15]*m,self[16]*m)
		end
	end
	
	---Apply division element-wise and return a new matrix_4
	---
	---Parameter `m` can be a number or array
	function matrix_4:div(m)
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9],self[10]/m[10],self[11]/m[11],self[12]/m[12],self[13]/m[13],self[14]/m[14],self[15]/m[15],self[16]/m[16])
		else
				return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m,self[5]/m,self[6]/m,self[7]/m,self[8]/m,self[9]/m,self[10]/m,self[11]/m,self[12]/m,self[13]/m,self[14]/m,self[15]/m,self[16]/m)
		end
		
	end
	
	---Apply division element-wise and store the result in a destination
	---
	---Parameter `m` can be a number or array
	function matrix_4:div_into(m, dest, dest_index)
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		local is_number = type(m) == 'number'
		if not is_number then
				assert(m, "bad argument 'm' (expected array or sequence, got nil)")
			array.set_16(dest, dest_index or 1, self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9],self[10]/m[10],self[11]/m[11],self[12]/m[12],self[13]/m[13],self[14]/m[14],self[15]/m[15],self[16]/m[16])
		else
				array.set_16(dest, dest_index or 1, self[1]/m,self[2]/m,self[3]/m,self[4]/m,self[5]/m,self[6]/m,self[7]/m,self[8]/m,self[9]/m,self[10]/m,self[11]/m,self[12]/m,self[13]/m,self[14]/m,self[15]/m,self[16]/m)
		end
	end
	
	--- Operator metamethods
	matrix_4.__add = matrix_4.add
	matrix_4.__sub = matrix_4.sub
	matrix_4.__mul = matrix_4.mul
	matrix_4.__div = matrix_4.div
	matrix_4.__unm = function(m) return m:mul(-1) end
	
	---Multiply with a matrix and return the result
	---
	function matrix_4:matmul(m)
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(linalg.matmul_mat4_mat4(self, m))
	end
	
	---Multiply with a matrix and store the result in a destination
	---
	function matrix_4:matmul_into(m, dest, dest_index)
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
		array.set_16(dest, dest_index or 1, linalg.matmul_mat4_mat4(self, m))
	end
	
	avm.matrix_4 = M
	
end

