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

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
local avm_path = (...):match("(.-)[^%.]+$")

---Disable warnings for _ex type overloaded functions

-----------------------------------------------------------
-- Constants and Dependencies
-----------------------------------------------------------

-- Epsilon for floating point comparisons used in "almost_" functions
local epsilon_default = 1e-9

-- Math library
local math = require("math")
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
	return (src.n or #src)
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

return M