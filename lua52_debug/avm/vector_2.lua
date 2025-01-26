
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
---@class vector_2_module
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
---@diagnostic disable-next-line: unused-local
local avm_path = (...):match("(.-)[^%.]+$")

---@module 'avm._debug'
local _debug = require(avm_path .. "_debug")

---@module 'avm.array'
local array = require(avm_path .. "array")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field


---2D vector constructed from a tuple
---
---@class avm.vector_2: avm.number2
---@operator add(avm.number2|number): avm.vector_2
---@operator sub(avm.number2|number): avm.vector_2
---@operator mul(avm.number2|number): avm.vector_2
---@operator div(avm.number2|number): avm.vector_2
---@operator unm():avm.vector_2
local vector_2 = {}


-----------------------------------------------------------
-- Vector creation
-----------------------------------------------------------

---Create a new vector_2 with given values
---@param v1 number
---@param v2 number
---@return avm.vector_2
function M.new(v1, v2)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	return setmetatable({v1, v2}, vector_2)
end

--[=[
---Create a vector_2_slice class that views into an array or slice
---@param src avm.seq_number
---@param src_index? integer
---@return avm.vector_2_slice
function M.slice(src, src_index)
	_debug.check_array("src", src, src_index or 1, 2)
	local index = src_index or 1
	return setmetatable({_src = src, _o=index-1}, vector_2_slice) --[[@as avm.vector_2_slice]]
end
--]=]

vector_2.__index = vector_2
vector_2.__len = function()
	return 2
end

function vector_2:__tostring()
	return string.format("%f, %f", self:get())
end

function vector_2:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2:copy_into(dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number
function vector_2:get()
	return self[1], self[2]
end

---Set values from a tuple
---@param v1 number
---@param v2 number
function vector_2:set(v1, v2)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	self[1], self[2] = v1, v2
end

---Apply add element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2:add(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self[1]+v1,self[2]+v2)
end

---Apply add element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2:add_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self[1]+v1,self[2]+v2)
end

---Apply sub element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2:sub(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self[1]-v1,self[2]-v2)
end

---Apply sub element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2:sub_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self[1]-v1,self[2]-v2)
end

---Apply mul element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2:mul(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self[1]*v1,self[2]*v2)
end

---Apply mul element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2:mul_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self[1]*v1,self[2]*v2)
end

---Apply div element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2:div(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self[1]/v1,self[2]/v2)
end

---Apply div element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2:div_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
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
---@return number
function vector_2:x()
	return self[1]
end

---Get elements of the vector
---@return number
function vector_2:y()
	return self[2]
end

---Get elements of the vector
---@return number,number
function vector_2:xx()
	return self[1], self[1]
end

---Get elements of the vector
---@return number,number
function vector_2:xy()
	return self[1], self[2]
end

---Get elements of the vector
---@return number,number
function vector_2:yx()
	return self[2], self[1]
end

---Get elements of the vector
---@return number,number
function vector_2:yy()
	return self[2], self[2]
end

---Set elements of the vector
---@param v1 number
function vector_2:set_x(v1)
	self[1] = v1
end

---Set elements of the vector
---@param v1 number
function vector_2:set_y(v1)
	self[2] = v1
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_2:set_xy(v1, v2)
	self[1], self[2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_2:set_yx(v1, v2)
	self[2], self[1] = v1, v2
end


--[[
function vector_2_slice:__index(key)
	if type(key) == 'number' and key >= 1 and key <= 2 then
		---@diagnostic disable-next-line: undefined-field
		return self._src[self._o+key]
	else
		return vector_2_slice[key]
	end
end
function vector_2_slice:__newindex(key, value)
	if type(key) == 'number' and key >= 1 and key <= 2 then
		---@diagnostic disable-next-line: undefined-field
		self._src[self._o+key] = value
	else
		rawset(self, key, value)
	end
end

function vector_2_slice:__len()
	return 2
end

function vector_2_slice:__tostring()
	return string.format("%f, %f", self:get())
end

function vector_2_slice:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2_slice:copy_into(dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number
function vector_2_slice:get()
	return self._src[self._o+1], self._src[self._o+2]
end

---Set values from a tuple
---@param v1 number
---@param v2 number
function vector_2_slice:set(v1, v2)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	self._src[self._o+1], self._src[self._o+2] = v1, v2
end

---Apply add element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2_slice:add(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self._src[self._o+1]+v1,self._src[self._o+2]+v2)
end

---Apply add element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2_slice:add_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self._src[self._o+1]+v1,self._src[self._o+2]+v2)
end

---Apply sub element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2_slice:sub(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self._src[self._o+1]-v1,self._src[self._o+2]-v2)
end

---Apply sub element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2_slice:sub_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self._src[self._o+1]-v1,self._src[self._o+2]-v2)
end

---Apply mul element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2_slice:mul(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self._src[self._o+1]*v1,self._src[self._o+2]*v2)
end

---Apply mul element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2_slice:mul_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
	array.set_2(dest, dest_index or 1, self._src[self._o+1]*v1,self._src[self._o+2]*v2)
end

---Apply div element-wise and return a new vector_2
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@return avm.vector_2
function vector_2_slice:div(v)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	return M.new(self._src[self._o+1]/v1,self._src[self._o+2]/v2)
end

---Apply div element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number2|number
---@param dest avm.seq_number2
---@param dest_index? integer
function vector_2_slice:div_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2 ---@type number,number
	if not is_number then
		---@cast v avm.number2
		_debug.check_array("v", v, 1, 2)
		v1, v2 = v[1],v[2]
	else
		---@cast v number
		v1, v2 = v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 2)
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
---@return number
function vector_2_slice:x()
	return self._src[self._o+1]
end

---Get elements of the vector
---@return number
function vector_2_slice:y()
	return self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_2_slice:xx()
	return self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_2_slice:xy()
	return self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_2_slice:yx()
	return self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_2_slice:yy()
	return self._src[self._o+2], self._src[self._o+2]
end

---Set elements of the vector
---@param v1 number
function vector_2_slice:set_x(v1)
	self._src[self._o+1] = v1
end

---Set elements of the vector
---@param v1 number
function vector_2_slice:set_y(v1)
	self._src[self._o+2] = v1
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_2_slice:set_xy(v1, v2)
	self._src[self._o+1], self._src[self._o+2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_2_slice:set_yx(v1, v2)
	self._src[self._o+2], self._src[self._o+1] = v1, v2
end

--]]

return M