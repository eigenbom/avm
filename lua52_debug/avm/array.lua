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
---@class array_module
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
local avm_path = (...):match("(.-)[^%.]+$")
---@module 'avm._debug'
local _debug = require(avm_path .. "_debug")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field

-----------------------------------------------------------
-- Constants and Dependencies
-----------------------------------------------------------

-- Epsilon for floating point comparisons used in "almost_" functions
local epsilon_default = 1e-9

-- Math library
local math = require 'math'
local math_abs = math.abs
local math_ceil = math.ceil
local math_min = math.min
local math_max = math.max

-----------------------------------------------------------
-- Extension API
-----------------------------------------------------------

---Determines if src is an array
---
---Optionally redefine this to support custom platform and userdata
---@param src any
---@return boolean
function M.is_array(src)
	return type(src) == 'table' or type(src) == 'cdata'
end

---Returns the length of an array
---
---Optionally redefine this to support custom platform and userdata
---@param src any
---@return integer
function M.length(src)
	assert(type(src) ~= 'cdata', "bad argument 'src' (cdata has no length)")
	return #src
end

---Create a new an array with an initial length
---
---Optionally redefine this to support custom platform and userdata
---@generic T
---@param type `T`
---@param length integer
---@return avm.array<T>
function M.new_array(type, length)
	local dest = {}
	for i=1,length do
		dest[i] = 0
	end
	return dest
end

---TODO: This function should only grow array if the array checks are on
---Grow an array or sequence to span the range [index, index + count - 1]
---
---Optionally redefine this to support custom platform and userdata
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param dest_count integer
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
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return avm.array<T>
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
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@param dest avm.seq<T>
---@param dest_index integer
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
---@param count integer
---@return avm.array<number>
function M.zeros(count)
	return M.fill(0.0, count)
end

---create an array filled with a constant value
---@generic T
---@param constant T
---@param count integer
---@return avm.array<T>
function M.fill(constant, count)
	local dest = M.new_array(type(constant),count)
	for i=1,count do
		dest[i] = constant
	end
	return dest
end

---fill a sequence with a constant
---@generic T
---@param constant T
---@param count integer
---@param dest avm.seq<T>
---@param dest_index? integer
function M.fill_into(constant, count, dest, dest_index)
	local index = dest_index or 1
	_debug.check_array("dest", dest, index, count)
	for i=0,count-1 do
		dest[index+i] = constant
	end
end

---create an array with sequential values in `from .. to` in `step_size` increments
---@generic T
---@param from T
---@param to T
---@param step_size? T -- default = 1
---@return avm.array<T>
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
---@generic T
---@param from number
---@param to number
---@param step_size number
---@param dest avm.seq<T>
---@param dest_index? integer
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

---@see array_module.length

-----------------------------------------------------------
-- Copying, slicing, reversing
-----------------------------------------------------------

---Copy an array elements into a new array
---@generic T
---@param src avm.array<T>
---@return avm.array<T>
function M.copy(src)
	_debug.check_array_and_size("src", src)
	return M.copy_array(src, 1, M.length(src))
end

---Copy a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return avm.array<T>
---@diagnostic disable-next-line: unused-local, missing-return
function M.copy_ex(src, src_index, src_count) end

---Copy a slice to a destination
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.copy_ex(src, src_index, src_count, dest, dest_index)
	_debug.check_array("src", src, src_index, src_count)
	local dest_or_new = dest and (_debug.check_array("dest", dest,dest_index or 1,src_count) or dest) or M.new_array(type(src[src_index]), src_count+(dest_index or 1 or 1)-1)
	-- _debug.check_array("dest", dest)
	M.copy_array_into(src, src_index, src_count, dest_or_new, dest_index or 1)
	return dest_or_new
end

--Reverse an array
---@generic T
---@param src avm.array<T>
---@return avm.array<T>
function M.reverse(src)
	_debug.check_array_and_size("src", src)
	local n = M.length(src)
	local dest = M.new_array(type(src[1]),n)
	for i=1,n do
		dest[i] = src[n-i+1]
	end
	return dest
end

--Reverse a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return avm.array<T>
---@diagnostic disable-next-line: unused-local, missing-return
function M.reverse_ex(src, src_index, src_count) end

--Reverse a slice into a destination
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.reverse_ex(src, src_index, src_count, dest, dest_index)
	_debug.check_array("src", src, src_index, src_count)
	local src_offset = src_index - 1
	local dest_offset = dest_index and (dest_index - 1) or 0
	local n = src_count
	dest = dest and (_debug.check_array("dest", dest,dest_offset+1,n) or dest) or M.new_array(type(src[src_index]), n+(dest_offset+1 or 1)-1)
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
---@see array_module.flatten
---@param src any
---@param dest_size integer[]
---@return table
function M.reshape(src, dest_size)
	check_valid_reshape_size(dest_size)
	local dest = {}
	M.reshape_into(src, dest_size, dest)
	return dest
end

---Reshape a table or an array into a destination
---
---@see array_module.reshape
---@see array_module.flatten
---@param src any
---@param dest_size integer[]
---@param dest any
---@param dest_index? integer
function M.reshape_into(src, dest_size, dest, dest_index)
	check_valid_reshape_size(dest_size)

	local dest_dim = #dest_size
	local dest_iter = M.fill(1, dest_dim)
	local dest_offset = dest_index and (dest_index - 1) or 0
	local src_size = {}
	do
		local tbl = src ---@type table
		while type(tbl) == "table" do
			table.insert(src_size, #tbl)
			tbl = tbl[1]
		end
	end
	local src_dim = #src_size
	local src_iter = M.fill(1, src_dim)

	while true do
		-- copy element, e.g., dest[{0,0,0}] = src[i]
		local value = src ---@type table|number
		for d=1,src_dim do
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
---@see array_module.reshape
---@param src any
---@return any[]
function M.flatten(src)
	local src_size = {}
	do
		local tbl = src ---@type table
		while type(tbl) == "table" do
			table.insert(src_size, #tbl)
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
---@see array_module.reshape
---@param src any
---@param dest any
---@param dest_index? integer
function M.flatten_into(src, dest, dest_index)
	_debug.check_array("dest", dest)
	
	local src_size = {}
	do
		local tbl = src ---@type table
		while type(tbl) == "table" do
			table.insert(src_size, #tbl)
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
---@see array_module.set_2
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@vararg T
function M.set(dest, dest_index, ...)
	local n = select("#", ...)
	_debug.check_array("dest", dest, dest_index, n)
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
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
function M.set_1(dest, dest_index, v1)
	_debug.check_array("dest", dest, dest_index, 1)
	dest[dest_index] = v1
end

---Set 2 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
function M.set_2(dest, dest_index, v1, v2)
	_debug.check_array("dest", dest, dest_index, 2)
	dest[dest_index], dest[dest_index+1] = v1, v2
end

---Set 3 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
function M.set_3(dest, dest_index, v1, v2, v3)
	_debug.check_array("dest", dest, dest_index, 3)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2] = v1, v2, v3
end

---Set 4 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
function M.set_4(dest, dest_index, v1, v2, v3, v4)
	_debug.check_array("dest", dest, dest_index, 4)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3] = v1, v2, v3, v4
end

---Set 5 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
function M.set_5(dest, dest_index, v1, v2, v3, v4, v5)
	_debug.check_array("dest", dest, dest_index, 5)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4] = v1, v2, v3, v4, v5
end

---Set 6 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
function M.set_6(dest, dest_index, v1, v2, v3, v4, v5, v6)
	_debug.check_array("dest", dest, dest_index, 6)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5] = v1, v2, v3, v4, v5, v6
end

---Set 7 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
function M.set_7(dest, dest_index, v1, v2, v3, v4, v5, v6, v7)
	_debug.check_array("dest", dest, dest_index, 7)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6] = v1, v2, v3, v4, v5, v6, v7
end

---Set 8 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
function M.set_8(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8)
	_debug.check_array("dest", dest, dest_index, 8)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7] = v1, v2, v3, v4, v5, v6, v7, v8
end

---Set 9 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
function M.set_9(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9)
	_debug.check_array("dest", dest, dest_index, 9)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8] = v1, v2, v3, v4, v5, v6, v7, v8, v9
end

---Set 10 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
function M.set_10(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
	_debug.check_array("dest", dest, dest_index, 10)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
end

---Set 11 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
function M.set_11(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
	_debug.check_array("dest", dest, dest_index, 11)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
end

---Set 12 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
function M.set_12(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
	_debug.check_array("dest", dest, dest_index, 12)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
end

---Set 13 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
function M.set_13(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13)
	_debug.check_array("dest", dest, dest_index, 13)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
end

---Set 14 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
---@param v14 T
function M.set_14(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14)
	_debug.check_array("dest", dest, dest_index, 14)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12], dest[dest_index+13] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
end

---Set 15 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
---@param v14 T
---@param v15 T
function M.set_15(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15)
	_debug.check_array("dest", dest, dest_index, 15)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12], dest[dest_index+13], dest[dest_index+14] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
end

---Set 16 values in a slice
---```
---dest[dest_index] = v1
---...
---dest[dest_index + n] = vn
---```
---@see array_module.set
---@generic T
---@param dest avm.seq<T>
---@param dest_index integer
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
---@param v14 T
---@param v15 T
---@param v16 T
function M.set_16(dest, dest_index, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
	_debug.check_array("dest", dest, dest_index, 16)
	dest[dest_index], dest[dest_index+1], dest[dest_index+2], dest[dest_index+3], dest[dest_index+4], dest[dest_index+5], dest[dest_index+6], dest[dest_index+7], dest[dest_index+8], dest[dest_index+9], dest[dest_index+10], dest[dest_index+11], dest[dest_index+12], dest[dest_index+13], dest[dest_index+14], dest[dest_index+15] = v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
end


---Get 2 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T
function M.get_2(src, src_index)
	_debug.check_array("src", src, src_index, 2)
	return src[src_index], src[src_index+1]
end

---Get 3 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T
function M.get_3(src, src_index)
	_debug.check_array("src", src, src_index, 3)
	return src[src_index], src[src_index+1], src[src_index+2]
end

---Get 4 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T
function M.get_4(src, src_index)
	_debug.check_array("src", src, src_index, 4)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3]
end

---Get 5 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T
function M.get_5(src, src_index)
	_debug.check_array("src", src, src_index, 5)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4]
end

---Get 6 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T
function M.get_6(src, src_index)
	_debug.check_array("src", src, src_index, 6)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5]
end

---Get 7 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T
function M.get_7(src, src_index)
	_debug.check_array("src", src, src_index, 7)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6]
end

---Get 8 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T
function M.get_8(src, src_index)
	_debug.check_array("src", src, src_index, 8)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7]
end

---Get 9 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T
function M.get_9(src, src_index)
	_debug.check_array("src", src, src_index, 9)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8]
end

---Get 10 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T
function M.get_10(src, src_index)
	_debug.check_array("src", src, src_index, 10)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9]
end

---Get 11 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T,T
function M.get_11(src, src_index)
	_debug.check_array("src", src, src_index, 11)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10]
end

---Get 12 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T,T,T
function M.get_12(src, src_index)
	_debug.check_array("src", src, src_index, 12)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11]
end

---Get 13 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T,T,T,T
function M.get_13(src, src_index)
	_debug.check_array("src", src, src_index, 13)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12]
end

---Get 14 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.get_14(src, src_index)
	_debug.check_array("src", src, src_index, 14)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12], src[src_index+13]
end

---Get 15 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.get_15(src, src_index)
	_debug.check_array("src", src, src_index, 15)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12], src[src_index+13], src[src_index+14]
end

---Get 16 values from a slice
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@return T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.get_16(src, src_index)
	_debug.check_array("src", src, src_index, 16)
	return src[src_index], src[src_index+1], src[src_index+2], src[src_index+3], src[src_index+4], src[src_index+5], src[src_index+6], src[src_index+7], src[src_index+8], src[src_index+9], src[src_index+10], src[src_index+11], src[src_index+12], src[src_index+13], src[src_index+14], src[src_index+15]
end


---Unpack 2 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T
function M.unpack_2(src)
	_debug.check_array("src", src, 1, 2)
	return src[1], src[2]
end

---Unpack 3 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T
function M.unpack_3(src)
	_debug.check_array("src", src, 1, 3)
	return src[1], src[2], src[3]
end

---Unpack 4 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T
function M.unpack_4(src)
	_debug.check_array("src", src, 1, 4)
	return src[1], src[2], src[3], src[4]
end

---Unpack 5 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T
function M.unpack_5(src)
	_debug.check_array("src", src, 1, 5)
	return src[1], src[2], src[3], src[4], src[5]
end

---Unpack 6 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T
function M.unpack_6(src)
	_debug.check_array("src", src, 1, 6)
	return src[1], src[2], src[3], src[4], src[5], src[6]
end

---Unpack 7 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T
function M.unpack_7(src)
	_debug.check_array("src", src, 1, 7)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7]
end

---Unpack 8 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T
function M.unpack_8(src)
	_debug.check_array("src", src, 1, 8)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8]
end

---Unpack 9 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T
function M.unpack_9(src)
	_debug.check_array("src", src, 1, 9)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9]
end

---Unpack 10 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T
function M.unpack_10(src)
	_debug.check_array("src", src, 1, 10)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10]
end

---Unpack 11 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T,T
function M.unpack_11(src)
	_debug.check_array("src", src, 1, 11)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11]
end

---Unpack 12 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T,T,T
function M.unpack_12(src)
	_debug.check_array("src", src, 1, 12)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12]
end

---Unpack 13 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T,T,T,T
function M.unpack_13(src)
	_debug.check_array("src", src, 1, 13)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13]
end

---Unpack 14 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.unpack_14(src)
	_debug.check_array("src", src, 1, 14)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13], src[14]
end

---Unpack 15 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.unpack_15(src)
	_debug.check_array("src", src, 1, 15)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13], src[14], src[15]
end

---Unpack 16 values from an array
---@generic T
---@param src avm.array<T> 
---@return T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.unpack_16(src)
	_debug.check_array("src", src, 1, 16)
	return src[1], src[2], src[3], src[4], src[5], src[6], src[7], src[8], src[9], src[10], src[11], src[12], src[13], src[14], src[15], src[16]
end


---Push values onto an array
---
---also see `push_1()`, `push_2()`, `push_3()`, etc.
---@generic T
---@param dest avm.array<T>
---@vararg T
function M.push(dest, ...)
	_debug.check_array_and_size("dest", dest)
	local n = M.length(dest)
	local count = select("#", ...)
	M.grow_array(dest, 1, n+count)
	for i=1,count do
		dest[n+i] = select(i, ...)
	end
end

---Push 1 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
function M.push_1(dest, v1)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+1)
	M.set_1(dest, len+1, v1)
end

---Push 2 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
function M.push_2(dest, v1, v2)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+2)
	M.set_2(dest, len+1, v1, v2)
end

---Push 3 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
function M.push_3(dest, v1, v2, v3)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+3)
	M.set_3(dest, len+1, v1, v2, v3)
end

---Push 4 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
function M.push_4(dest, v1, v2, v3, v4)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+4)
	M.set_4(dest, len+1, v1, v2, v3, v4)
end

---Push 5 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
function M.push_5(dest, v1, v2, v3, v4, v5)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+5)
	M.set_5(dest, len+1, v1, v2, v3, v4, v5)
end

---Push 6 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
function M.push_6(dest, v1, v2, v3, v4, v5, v6)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+6)
	M.set_6(dest, len+1, v1, v2, v3, v4, v5, v6)
end

---Push 7 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
function M.push_7(dest, v1, v2, v3, v4, v5, v6, v7)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+7)
	M.set_7(dest, len+1, v1, v2, v3, v4, v5, v6, v7)
end

---Push 8 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
function M.push_8(dest, v1, v2, v3, v4, v5, v6, v7, v8)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+8)
	M.set_8(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8)
end

---Push 9 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
function M.push_9(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+9)
	M.set_9(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9)
end

---Push 10 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
function M.push_10(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+10)
	M.set_10(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
end

---Push 11 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
function M.push_11(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+11)
	M.set_11(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11)
end

---Push 12 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
function M.push_12(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+12)
	M.set_12(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12)
end

---Push 13 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
function M.push_13(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+13)
	M.set_13(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13)
end

---Push 14 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
---@param v14 T
function M.push_14(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+14)
	M.set_14(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14)
end

---Push 15 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
---@param v14 T
---@param v15 T
function M.push_15(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+15)
	M.set_15(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15)
end

---Push 16 value(s) onto an array
---@generic T
---@param dest avm.array<T>
---@param v1 T
---@param v2 T
---@param v3 T
---@param v4 T
---@param v5 T
---@param v6 T
---@param v7 T
---@param v8 T
---@param v9 T
---@param v10 T
---@param v11 T
---@param v12 T
---@param v13 T
---@param v14 T
---@param v15 T
---@param v16 T
function M.push_16(dest, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
	local len = M.length(dest)
	M.grow_array(dest, 1, len+16)
	M.set_16(dest, len+1, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16)
end


---Pop a value off the end of an array and return it
---
---Equivalent to `table.remove(src)`
---
---@see array_module.pop_1
---@see array_module.pop_2
---@see array_module.pop_3
---
---@generic T
---@param src avm.array<T>
---@return T
function M.pop(src)
	return M.pop_1(src)
end

---Pop 1 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T
function M.pop_1(src)
	_debug.check_array("src", src, 1, 1)
	local index = M.length(src)-1+1
	local v1 = src[index]
	table.remove(src)
	return v1
end

---Pop 2 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T
function M.pop_2(src)
	_debug.check_array("src", src, 1, 2)
	local index = M.length(src)-2+1
	local v1 = src[index]
	local v2 = src[index+1]
	table.remove(src)
	table.remove(src)
	return v1, v2
end

---Pop 3 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T
function M.pop_3(src)
	_debug.check_array("src", src, 1, 3)
	local index = M.length(src)-3+1
	local v1 = src[index]
	local v2 = src[index+1]
	local v3 = src[index+2]
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3
end

---Pop 4 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T
function M.pop_4(src)
	_debug.check_array("src", src, 1, 4)
	local index = M.length(src)-4+1
	local v1 = src[index]
	local v2 = src[index+1]
	local v3 = src[index+2]
	local v4 = src[index+3]
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4
end

---Pop 5 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T
function M.pop_5(src)
	_debug.check_array("src", src, 1, 5)
	local index = M.length(src)-5+1
	local v1 = src[index]
	local v2 = src[index+1]
	local v3 = src[index+2]
	local v4 = src[index+3]
	local v5 = src[index+4]
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5
end

---Pop 6 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T
function M.pop_6(src)
	_debug.check_array("src", src, 1, 6)
	local index = M.length(src)-6+1
	local v1 = src[index]
	local v2 = src[index+1]
	local v3 = src[index+2]
	local v4 = src[index+3]
	local v5 = src[index+4]
	local v6 = src[index+5]
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6
end

---Pop 7 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T
function M.pop_7(src)
	_debug.check_array("src", src, 1, 7)
	local index = M.length(src)-7+1
	local v1 = src[index]
	local v2 = src[index+1]
	local v3 = src[index+2]
	local v4 = src[index+3]
	local v5 = src[index+4]
	local v6 = src[index+5]
	local v7 = src[index+6]
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7
end

---Pop 8 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T
function M.pop_8(src)
	_debug.check_array("src", src, 1, 8)
	local index = M.length(src)-8+1
	local v1 = src[index]
	local v2 = src[index+1]
	local v3 = src[index+2]
	local v4 = src[index+3]
	local v5 = src[index+4]
	local v6 = src[index+5]
	local v7 = src[index+6]
	local v8 = src[index+7]
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8
end

---Pop 9 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T
function M.pop_9(src)
	_debug.check_array("src", src, 1, 9)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9
end

---Pop 10 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T
function M.pop_10(src)
	_debug.check_array("src", src, 1, 10)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10
end

---Pop 11 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T, T
function M.pop_11(src)
	_debug.check_array("src", src, 1, 11)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11
end

---Pop 12 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T, T, T
function M.pop_12(src)
	_debug.check_array("src", src, 1, 12)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
end

---Pop 13 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T, T, T, T
function M.pop_13(src)
	_debug.check_array("src", src, 1, 13)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13
end

---Pop 14 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T, T, T, T, T
function M.pop_14(src)
	_debug.check_array("src", src, 1, 14)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
end

---Pop 15 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T, T, T, T, T, T
function M.pop_15(src)
	_debug.check_array("src", src, 1, 15)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15
end

---Pop 16 value(s) off the end of an array and return them
---
---@generic T
---@param src avm.array<T>
---@return T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T
function M.pop_16(src)
	_debug.check_array("src", src, 1, 16)
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
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	table.remove(src)
	return v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16
end


-----------------------------------------------------------
-- Append, join
-----------------------------------------------------------

---Append an array `src` onto the end of an array `dest`
---
---Equivalent to `copy_into(src, dest, length(dest))`
---
---@see array_module.extend
---@generic T
---@param src avm.array<T>
---@param dest avm.array<T>
function M.append(src, dest)
	_debug.check_array_and_size("src", src)
	if src ~= dest then
		_debug.check_array_and_size("dest", dest)
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
---@see array_module.append
---@generic T
---@param dest avm.array<T>
---@param src avm.array<T>
function M.extend(dest, src)
	M.append(src, dest)
end

---Create an array with elements `[a_1, ..., a_n, b_1, ..., b_n]`
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return avm.array<T>
function M.join(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array_and_size("b", b)
	local a_count = M.length(a)
	local b_count = M.length(b)
	local dest = M.new_array(type(a[1]),a_count+b_count)
	M.copy_ex(a, 1, a_count, dest)
	M.copy_ex(b, 1, b_count, dest, 1 + a_count)
	return dest
end

---Return an array with elements `[a_i, ..., a_(i+count), b_i, ..., b_(i+count)]`
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param b_count integer
---@return avm.array<T>
function M.join_ex(a, a_index, a_count, b, b_index, b_count)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, b_count)
	local dest = M.new_array(type(a[a_index]), a_count + b_count)
	M.copy_ex(a, a_index, a_count, dest)
	M.copy_ex(b, b_index, b_count, dest, a_count)
	return dest
end

-----------------------------------------------------------
-- Equality comparison
-----------------------------------------------------------

---true if the arrays are equal and #a==#b
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
function M.all_equals(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array_and_size("b", b)
	local len_a = M.length(a)
	local len_b = M.length(b)
	if len_a ~= len_b then
		return false
	end
	return M.all_equals_ex(a, 1, len_a, b, 1)
end

---true if the slices are equal
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
function M.all_equals_ex(a, a_index, a_count, b, b_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
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
---@param a avm.array<number>
---@param b avm.array<number>
---@param epsilon? number
function M.all_almost_equals(a, b, epsilon)
	_debug.check_array_and_size("a", a)
	_debug.check_array_and_size("b", b)
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
---@param a avm.seq_number
---@param a_index integer
---@param a_count integer
---@param b avm.seq_number
---@param b_index integer
---@param epsilon? number
function M.all_almost_equals_ex(a, a_index, a_count, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
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
---@param a avm.array<number>
---@param b avm.array<number>
---@param epsilon? number
function M.all_almost_equals_with_nan(a, b, epsilon)
	_debug.check_array_and_size("a", a)
	_debug.check_array_and_size("b", b)
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
---@generic T
---@param a avm.array<T>
---@param constant T
function M.all_equals_constant(a, constant)
	_debug.check_array_and_size("a", a)
	return M.all_equals_constant_ex(a, 1, M.length(a), constant)
end

-- true if all the elements are equal to the constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param constant T
function M.all_equals_constant_ex(a, a_index, a_count, constant)
	_debug.check_array("a", a, a_index, a_count)
	for i=a_index,a_index+a_count-1 do
		if a[i] ~= constant then
			return false
		end
	end
	return true
end

-- true if all the elements are almost equal to the constant (differ by epsilon or less)
---@param a avm.array<number>
---@param constant number
---@param epsilon? number
function M.all_almost_equals_constant(a, constant, epsilon)
	_debug.check_array_and_size("a", a)
	return M.all_almost_equals_constant_ex(a, 1, M.length(a), constant, epsilon)
end

-- true if all the elements are almost equal to the constant (differ by epsilon or less)
---@param a avm.seq_number
---@param a_index integer
---@param a_count integer
---@param constant number
---@param epsilon? number
function M.all_almost_equals_constant_ex(a, a_index, a_count, constant, epsilon)
	_debug.check_array("a", a, a_index, a_count)
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
---@generic T
---@param count integer
---@param f fun(index:integer):T
---@return avm.array<T>
function M.generate(count, f)
	local dest = M.new_array(type(f(1)), count)
	for i=1,count do
		dest[i] = f(i)
	end
	return dest
end

---Fill a destination with elements
---`f(i)` for `i` in `[1,count]`
---@generic T
---@param count integer
---@param f fun(index:integer):T
---@param dest avm.seq<T>
---@param dest_index? integer
function M.generate_into(count, f, dest, dest_index)
	_debug.check_array("dest", dest)
	local o = dest_index and (dest_index-1) or 0
	for i=1,count do
		dest[o+i] = f(i)
	end
end

---Apply a function to each element of the arrays and return an array
---`f(a1[i])` for each `i` over the range `[1, #a1]`
---@generic T1, U
---@param a1 avm.array<T1>
---@param f fun(v1:T1):U
---@return avm.array<U>
function M.map(f, a1)
	_debug.check_array("a1", a1)
	local n = M.length(a1)
	local dest = M.new_array(type(f(a1[1])),n)
	for i=1,n do
		dest[i] = f(a1[i])
	end
	return dest
end

---Apply a function to each element of the sequences and return an array
---@see array_module.map
---@generic T1, U
---@param f fun(v1:T1):U
---@param a1 avm.seq<T1>
---@param a1_index integer
---@param a1_count integer
---@return avm.array<U>
---@diagnostic disable-next-line: unused-local, missing-return
function M.map_ex(f, a1, a1_index, a1_count) end

---Apply a function to each element of the sequences and fill a target a destination
---@see array_module.map
---@generic T1, U
---@param f fun(v1:T1):U
---@param a1 avm.seq<T1>
---@param a1_index integer
---@param a1_count integer
---@param dest avm.seq<U>
---@param dest_index? integer
function M.map_ex(f, a1, a1_index, a1_count, dest, dest_index)
	_debug.check_array("a1", a1)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a1_count) or dest) or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
	local o = dest_index and (dest_index-1) or 0
	local a1_o = a1_index - 1
	for i=1,a1_count do
		dest[o+i] = f(a1[a1_o+i])
	end
	return dest
end

---Apply a function to each element of the arrays and return an array
---`f(a1[i], a2[i])` for each `i` over the range `[1, #a1]`
---@generic T1, T2, U
---@param a1 avm.array<T1>
---@param a2 avm.array<T2>
---@param f fun(v1:T1,v2:T2):U
---@return avm.array<U>
function M.map_2(f, a1, a2)
	_debug.check_array("a1", a1)
	_debug.check_array("a2", a2)
	local n = M.length(a1)
	local dest = M.new_array(type(f(a1[1], a2[1])),n)
	for i=1,n do
		dest[i] = f(a1[i], a2[i])
	end
	return dest
end

---Apply a function to each element of the sequences and return an array
---@see array_module.map_2
---@generic T1, T2, U
---@param f fun(v1:T1,v2:T2):U
---@param a1 avm.seq<T1>
---@param a2 avm.seq<T2>
---@param a2_index integer
---@return avm.array<U>
---@diagnostic disable-next-line: unused-local, missing-return
function M.map_2_ex(f, a1, a1_index, a1_count, a2, a2_index) end

---Apply a function to each element of the sequences and fill a target a destination
---@see array_module.map_2
---@generic T1, T2, U
---@param f fun(v1:T1,v2:T2):U
---@param a1 avm.seq<T1>
---@param a2 avm.seq<T2>
---@param a2_index integer
---@param dest avm.seq<U>
---@param dest_index? integer
function M.map_2_ex(f, a1, a1_index, a1_count, a2, a2_index, dest, dest_index)
	_debug.check_array("a1", a1)
	_debug.check_array("a2", a2)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a1_count) or dest) or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
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
---@generic T1, T2, T3, U
---@param a1 avm.array<T1>
---@param a2 avm.array<T2>
---@param a3 avm.array<T3>
---@param f fun(v1:T1,v2:T2,v3:T3):U
---@return avm.array<U>
function M.map_3(f, a1, a2, a3)
	_debug.check_array("a1", a1)
	_debug.check_array("a2", a2)
	_debug.check_array("a3", a3)
	local n = M.length(a1)
	local dest = M.new_array(type(f(a1[1], a2[1], a3[1])),n)
	for i=1,n do
		dest[i] = f(a1[i], a2[i], a3[i])
	end
	return dest
end

---Apply a function to each element of the sequences and return an array
---@see array_module.map_3
---@generic T1, T2, T3, U
---@param f fun(v1:T1,v2:T2,v3:T3):U
---@param a1 avm.seq<T1>
---@param a2 avm.seq<T2>
---@param a3 avm.seq<T3>
---@param a3_index integer
---@return avm.array<U>
---@diagnostic disable-next-line: unused-local, missing-return
function M.map_3_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index) end

---Apply a function to each element of the sequences and fill a target a destination
---@see array_module.map_3
---@generic T1, T2, T3, U
---@param f fun(v1:T1,v2:T2,v3:T3):U
---@param a1 avm.seq<T1>
---@param a2 avm.seq<T2>
---@param a3 avm.seq<T3>
---@param a3_index integer
---@param dest avm.seq<U>
---@param dest_index? integer
function M.map_3_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index, dest, dest_index)
	_debug.check_array("a1", a1)
	_debug.check_array("a2", a2)
	_debug.check_array("a3", a3)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a1_count) or dest) or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
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
---@generic T1, T2, T3, T4, U
---@param a1 avm.array<T1>
---@param a2 avm.array<T2>
---@param a3 avm.array<T3>
---@param a4 avm.array<T4>
---@param f fun(v1:T1,v2:T2,v3:T3,v4:T4):U
---@return avm.array<U>
function M.map_4(f, a1, a2, a3, a4)
	_debug.check_array("a1", a1)
	_debug.check_array("a2", a2)
	_debug.check_array("a3", a3)
	_debug.check_array("a4", a4)
	local n = M.length(a1)
	local dest = M.new_array(type(f(a1[1], a2[1], a3[1], a4[1])),n)
	for i=1,n do
		dest[i] = f(a1[i], a2[i], a3[i], a4[i])
	end
	return dest
end

---Apply a function to each element of the sequences and return an array
---@see array_module.map_4
---@generic T1, T2, T3, T4, U
---@param f fun(v1:T1,v2:T2,v3:T3,v4:T4):U
---@param a1 avm.seq<T1>
---@param a2 avm.seq<T2>
---@param a3 avm.seq<T3>
---@param a4 avm.seq<T4>
---@param a4_index integer
---@return avm.array<U>
---@diagnostic disable-next-line: unused-local, missing-return
function M.map_4_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index, a4, a4_index) end

---Apply a function to each element of the sequences and fill a target a destination
---@see array_module.map_4
---@generic T1, T2, T3, T4, U
---@param f fun(v1:T1,v2:T2,v3:T3,v4:T4):U
---@param a1 avm.seq<T1>
---@param a2 avm.seq<T2>
---@param a3 avm.seq<T3>
---@param a4 avm.seq<T4>
---@param a4_index integer
---@param dest avm.seq<U>
---@param dest_index? integer
function M.map_4_ex(f, a1, a1_index, a1_count, a2, a2_index, a3, a3_index, a4, a4_index, dest, dest_index)
	_debug.check_array("a1", a1)
	_debug.check_array("a2", a2)
	_debug.check_array("a3", a3)
	_debug.check_array("a4", a4)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a1_count) or dest) or M.new_array(type(a1), a1_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<number>
function M.add(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<number>
function M.add_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.add
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.add_ex(a, a_index, a_count, b, b_index) end

---Apply the addition operator to two slices and store the result in a destination
---@see array_module.add
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.add_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.add_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.add_constant_ex(a, a_index, a_count, c) end

---Apply the addition operator to each element of a slice with a constant and store the result in a destination
---@see array_module.add_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.add_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<number>
function M.sub(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<number>
function M.sub_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.sub
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.sub_ex(a, a_index, a_count, b, b_index) end

---Apply the subtraction operator to two slices and store the result in a destination
---@see array_module.sub
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.sub_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.sub_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.sub_constant_ex(a, a_index, a_count, c) end

---Apply the subtraction operator to each element of a slice with a constant and store the result in a destination
---@see array_module.sub_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.sub_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<number>
function M.mul(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<number>
function M.mul_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.mul
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.mul_ex(a, a_index, a_count, b, b_index) end

---Apply the multiplication operator to two slices and store the result in a destination
---@see array_module.mul
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.mul_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.mul_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.mul_constant_ex(a, a_index, a_count, c) end

---Apply the multiplication operator to each element of a slice with a constant and store the result in a destination
---@see array_module.mul_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.mul_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<number>
function M.div(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<number>
function M.div_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.div
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.div_ex(a, a_index, a_count, b, b_index) end

---Apply the division operator to two slices and store the result in a destination
---@see array_module.div
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.div_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.div_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.div_constant_ex(a, a_index, a_count, c) end

---Apply the division operator to each element of a slice with a constant and store the result in a destination
---@see array_module.div_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.div_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<number>
function M.mod(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<number>
function M.mod_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.mod
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.mod_ex(a, a_index, a_count, b, b_index) end

---Apply the modulus operator to two slices and store the result in a destination
---@see array_module.mod
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.mod_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.mod_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.mod_constant_ex(a, a_index, a_count, c) end

---Apply the modulus operator to each element of a slice with a constant and store the result in a destination
---@see array_module.mod_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.mod_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<number>
function M.pow(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<number>
function M.pow_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.pow
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.pow_ex(a, a_index, a_count, b, b_index) end

---Apply the exponentiation operator to two slices and store the result in a destination
---@see array_module.pow
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.pow_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.pow_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<number>
---@diagnostic disable-next-line: unused-local, missing-return
function M.pow_constant_ex(a, a_index, a_count, c) end

---Apply the exponentiation operator to each element of a slice with a constant and store the result in a destination
---@see array_module.pow_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.pow_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.equal(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.equal_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.equal_ex(a, a_index, a_count, b, b_index) end

---Apply the equal operator to two slices and store the result in a destination
---@see array_module.equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.equal_constant_ex(a, a_index, a_count, c) end

---Apply the equal operator to each element of a slice with a constant and store the result in a destination
---@see array_module.equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.not_equal(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.not_equal_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.not_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.not_equal_ex(a, a_index, a_count, b, b_index) end

---Apply the not equal operator to two slices and store the result in a destination
---@see array_module.not_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.not_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.not_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.not_equal_constant_ex(a, a_index, a_count, c) end

---Apply the not equal operator to each element of a slice with a constant and store the result in a destination
---@see array_module.not_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.not_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.less_than(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.less_than_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.less_than
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.less_than_ex(a, a_index, a_count, b, b_index) end

---Apply the less than operator to two slices and store the result in a destination
---@see array_module.less_than
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.less_than_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.less_than_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.less_than_constant_ex(a, a_index, a_count, c) end

---Apply the less than operator to each element of a slice with a constant and store the result in a destination
---@see array_module.less_than_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.less_than_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.less_than_or_equal(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.less_than_or_equal_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.less_than_or_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.less_than_or_equal_ex(a, a_index, a_count, b, b_index) end

---Apply the less than or equal to operator to two slices and store the result in a destination
---@see array_module.less_than_or_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.less_than_or_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.less_than_or_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.less_than_or_equal_constant_ex(a, a_index, a_count, c) end

---Apply the less than or equal to operator to each element of a slice with a constant and store the result in a destination
---@see array_module.less_than_or_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.less_than_or_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.greater_than(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.greater_than_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.greater_than
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.greater_than_ex(a, a_index, a_count, b, b_index) end

---Apply the greater than operator to two slices and store the result in a destination
---@see array_module.greater_than
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.greater_than_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.greater_than_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.greater_than_constant_ex(a, a_index, a_count, c) end

---Apply the greater than operator to each element of a slice with a constant and store the result in a destination
---@see array_module.greater_than_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.greater_than_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.greater_than_or_equal(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.greater_than_or_equal_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.greater_than_or_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.greater_than_or_equal_ex(a, a_index, a_count, b, b_index) end

---Apply the greater than or equal to operator to two slices and store the result in a destination
---@see array_module.greater_than_or_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.greater_than_or_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.greater_than_or_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.greater_than_or_equal_constant_ex(a, a_index, a_count, c) end

---Apply the greater than or equal to operator to each element of a slice with a constant and store the result in a destination
---@see array_module.greater_than_or_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.greater_than_or_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<T>
function M.min(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<T>
function M.min_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.min
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<T>
---@diagnostic disable-next-line: unused-local, missing-return
function M.min_ex(a, a_index, a_count, b, b_index) end

---Apply the minimum operator to two slices and store the result in a destination
---@see array_module.min
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.min_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.min_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<T>
---@diagnostic disable-next-line: unused-local, missing-return
function M.min_constant_ex(a, a_index, a_count, c) end

---Apply the minimum operator to each element of a slice with a constant and store the result in a destination
---@see array_module.min_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.min_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.array<T>
function M.max(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return avm.array<T>
function M.max_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.max
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.array<T>
---@diagnostic disable-next-line: unused-local, missing-return
function M.max_ex(a, a_index, a_count, b, b_index) end

---Apply the maximum operator to two slices and store the result in a destination
---@see array_module.max
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.max_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.max_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return avm.array<T>
---@diagnostic disable-next-line: unused-local, missing-return
function M.max_constant_ex(a, a_index, a_count, c) end

---Apply the maximum operator to each element of a slice with a constant and store the result in a destination
---@see array_module.max_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.max_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return boolean[]
function M.almost_equal(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
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
---@generic T
---@param a avm.array<T>
---@param c T|avm.array<T>
---@return boolean[]
function M.almost_equal_constant(a, c)
	_debug.check_array_and_size("a", a)
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
---@see array_module.almost_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.almost_equal_ex(a, a_index, a_count, b, b_index) end

---Apply the almost equal operator to two slices and store the result in a destination
---@see array_module.almost_equal
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.almost_equal_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@see array_module.almost_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@return boolean[]
---@diagnostic disable-next-line: unused-local, missing-return
function M.almost_equal_constant_ex(a, a_index, a_count, c) end

---Apply the almost equal operator to each element of a slice with a constant and store the result in a destination
---@see array_module.almost_equal_constant
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param c T
---@param dest avm.seq<boolean>
---@param dest_index? integer
---@return nil
function M.almost_equal_constant_ex(a, a_index, a_count, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@return avm.seq<boolean>
function M.almost_equal_with_nan(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
	local n = M.length(a)
	local dest = M.new_array('boolean',n)
	for i=1,n do
		local a_, b_ = a[i], b[i]
		dest[i] = (a_ ~= a_ and b_ ~= b) or (math_abs(a_ - b_) < epsilon_default)
	end
	return dest
end

---Apply the almost equal (but NaN==NaN) operator to two slices and return the result
---@see array_module.almost_equal_with_nan
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return avm.seq<boolean>
---@diagnostic disable-next-line: unused-local, missing-return
function M.almost_equal_with_nan_ex(a, a_index, a_count, b, b_index) end

---Apply the almost equal (but NaN==NaN) operator to two slices and store the result in a destination
---@see array_module.almost_equal_with_nan
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param dest boolean[]
---@param dest_index? integer
---@return nil
function M.almost_equal_with_nan_ex(a, a_index, a_count, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@param c avm.seq<T>
---@return avm.array<T>
function M.mul_add(a, b, c)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b)
	_debug.check_array("c", c)
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
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param c avm.seq<T>
---@param c_index integer
function M.mul_add_ex(a, a_index, a_count, b, b_index, c, c_index) end

---Perform the multiply-add operation on three slices into a destination
---
---`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param c avm.seq<T>
---@param c_index integer
---@param dest avm.seq<T>
---@param dest_index? integer
function M.mul_add_ex(a, a_index, a_count, b, b_index, c, c_index, dest, dest_index)
	_debug.check_array_and_size("a", a)
	_debug.check_array_and_size("b", b)
	_debug.check_array_and_size("c", c)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@param c T|avm.array<T>
---@return avm.array<T>
function M.mul_add_constant(a, b, c)
	_debug.check_array_and_size("a", a)
	local n = M.length(a)
	_debug.check_array("b", b, 1, n)
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
		_debug.check("c", c, 'number')
		for i=1,n do
			dest[i] = a[i]+b[i]*c
		end
	end
	return dest
end

---Perform the multiply-add operation on two slices and a constant and return an array
---
---`{a[i]+b[i]*c}` for all `i` in `[1, #a]`
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param c T|avm.array<T>
---@return avm.array<T>
---@diagnostic disable-next-line: missing-return
function M.mul_add_constant_ex(a, a_index, a_count, b, b_index, c) end

---Perform the multiply-add operation on two slices and a constant into a destination
---
---`{a[i]+b[i]*c}` for all `i` in `[1, #a]`
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param c T|avm.array<T>
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.mul_add_constant_ex(a, a_index, a_count, b, b_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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
		_debug.check("c", c, 'number')
		for i=1,n do
			dest[o+i] = a[ao+i]+b[bo+i]*c
		end
	end

	return dest
end

---Linearly interpolate between arrays and return an array
---
---`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`
---@generic T
---@param a avm.array<T>
---@param b avm.seq<T>
---@param t number
---@return avm.array<T>
function M.lerp(a, b, t)
	_debug.check_array_and_size("a", a)
	local n = M.length(a)
	_debug.check_array("b", b, 1, n)
	_debug.check("t", t, 'number')
	local dest = M.new_array(type(a[1]),n)
	for i=1,n do
		dest[i] = a[i]*(1-t)+b[i]*t
	end
	return dest
end

---Linearly interpolate between slices and return an array
---
---`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param t number
---@return avm.array<T>
---@diagnostic disable-next-line: missing-return
function M.lerp_ex(a, a_index, a_count, b, b_index, t) end

---Linearly interpolate between slices into a destination
---
---`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@param t number
---@param dest avm.seq<T>
---@param dest_index? integer
---@return nil
function M.lerp_ex(a, a_index, a_count, b, b_index, t, dest, dest_index)
	_debug.check_array("a", a, a_index, a_count)
	_debug.check_array("b", b, b_index, a_count)
	_debug.check("t", t, 'number')
	dest = dest and (_debug.check_array("dest", dest,dest_index or 1,a_count) or dest) or M.new_array(type(a[a_index]), a_count+(dest_index or 1 or 1)-1)
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