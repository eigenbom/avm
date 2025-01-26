
--[[
Vector operations and types  

Classes and functions for working with 3-d vectors  


]]
---@class vector_3_module
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


---3D vector constructed from a tuple
---
---@class avm.vector_3: avm.number3
---@operator add(avm.number3|number): avm.vector_3
---@operator sub(avm.number3|number): avm.vector_3
---@operator mul(avm.number3|number): avm.vector_3
---@operator div(avm.number3|number): avm.vector_3
---@operator unm():avm.vector_3
---@field n 3
local vector_3 = {}


-----------------------------------------------------------
-- Vector creation
-----------------------------------------------------------

---Create a new vector_3 with given values
---@param v1 number
---@param v2 number
---@param v3 number
---@return avm.vector_3
function M.new(v1, v2, v3)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	_debug.check("v3", v3, 'number')
	return setmetatable({v1, v2, v3}, vector_3)
end

--[=[
---Create a vector_3_slice class that views into an array or slice
---@param src avm.seq_number
---@param src_index? integer
---@return avm.vector_3_slice
function M.slice(src, src_index)
	_debug.check_array("src", src, src_index or 1, 3)
	local index = src_index or 1
	return setmetatable({_src = src, _o=index-1}, vector_3_slice) --[[@as avm.vector_3_slice]]
end
--]=]

function vector_3:__index(key)
	if key == 'n' then
		return 3
	else
		return vector_3[key]
	end
end

function vector_3:__tostring()
	return string.format("%f, %f, %f", self:get())
end

function vector_3:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3:copy_into(dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number
function vector_3:get()
	return self[1], self[2], self[3]
end

---Set values from a tuple
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set(v1, v2, v3)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	_debug.check("v3", v3, 'number')
	self[1], self[2], self[3] = v1, v2, v3
end

---Apply add element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3:add(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self[1]+v1,self[2]+v2,self[3]+v3)
end

---Apply add element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3:add_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self[1]+v1,self[2]+v2,self[3]+v3)
end

---Apply sub element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3:sub(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self[1]-v1,self[2]-v2,self[3]-v3)
end

---Apply sub element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3:sub_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self[1]-v1,self[2]-v2,self[3]-v3)
end

---Apply mul element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3:mul(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self[1]*v1,self[2]*v2,self[3]*v3)
end

---Apply mul element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3:mul_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self[1]*v1,self[2]*v2,self[3]*v3)
end

---Apply div element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3:div(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self[1]/v1,self[2]/v2,self[3]/v3)
end

---Apply div element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3:div_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
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
---@return number
function vector_3:x()
	return self[1]
end

---Get elements of the vector
---@return number
function vector_3:y()
	return self[2]
end

---Get elements of the vector
---@return number
function vector_3:z()
	return self[3]
end

---Get elements of the vector
---@return number,number
function vector_3:xx()
	return self[1], self[1]
end

---Get elements of the vector
---@return number,number
function vector_3:xy()
	return self[1], self[2]
end

---Get elements of the vector
---@return number,number
function vector_3:xz()
	return self[1], self[3]
end

---Get elements of the vector
---@return number,number
function vector_3:yx()
	return self[2], self[1]
end

---Get elements of the vector
---@return number,number
function vector_3:yy()
	return self[2], self[2]
end

---Get elements of the vector
---@return number,number
function vector_3:yz()
	return self[2], self[3]
end

---Get elements of the vector
---@return number,number
function vector_3:zx()
	return self[3], self[1]
end

---Get elements of the vector
---@return number,number
function vector_3:zy()
	return self[3], self[2]
end

---Get elements of the vector
---@return number,number
function vector_3:zz()
	return self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xxx()
	return self[1], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xxy()
	return self[1], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xxz()
	return self[1], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xyx()
	return self[1], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xyy()
	return self[1], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xyz()
	return self[1], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xzx()
	return self[1], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xzy()
	return self[1], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:xzz()
	return self[1], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yxx()
	return self[2], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yxy()
	return self[2], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yxz()
	return self[2], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yyx()
	return self[2], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yyy()
	return self[2], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yyz()
	return self[2], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yzx()
	return self[2], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yzy()
	return self[2], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:yzz()
	return self[2], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zxx()
	return self[3], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zxy()
	return self[3], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zxz()
	return self[3], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zyx()
	return self[3], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zyy()
	return self[3], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zyz()
	return self[3], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zzx()
	return self[3], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zzy()
	return self[3], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_3:zzz()
	return self[3], self[3], self[3]
end

---Set elements of the vector
---@param v1 number
function vector_3:set_x(v1)
	self[1] = v1
end

---Set elements of the vector
---@param v1 number
function vector_3:set_y(v1)
	self[2] = v1
end

---Set elements of the vector
---@param v1 number
function vector_3:set_z(v1)
	self[3] = v1
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3:set_xy(v1, v2)
	self[1], self[2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3:set_xz(v1, v2)
	self[1], self[3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3:set_yx(v1, v2)
	self[2], self[1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3:set_yz(v1, v2)
	self[2], self[3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3:set_zx(v1, v2)
	self[3], self[1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3:set_zy(v1, v2)
	self[3], self[2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set_xyz(v1, v2, v3)
	self[1], self[2], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set_xzy(v1, v2, v3)
	self[1], self[3], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set_yxz(v1, v2, v3)
	self[2], self[1], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set_yzx(v1, v2, v3)
	self[2], self[3], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set_zxy(v1, v2, v3)
	self[3], self[1], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3:set_zyx(v1, v2, v3)
	self[3], self[2], self[1] = v1, v2, v3
end


--[[
function vector_3_slice:__index(key)
	if type(key) == 'number' and key >= 1 and key <= 3 then
		---@diagnostic disable-next-line: undefined-field
		return self._src[self._o+key]
	elseif key == 'n' then
			return 3
	else
		return vector_3_slice[key]
	end
end
function vector_3_slice:__newindex(key, value)
	if type(key) == 'number' and key >= 1 and key <= 3 then
		---@diagnostic disable-next-line: undefined-field
		self._src[self._o+key] = value
	elseif key == 'n' then
			error("cannot set 'n' field in vector_3_slice")
	else
		rawset(self, key, value)
	end
end

function vector_3_slice:__tostring()
	return string.format("%f, %f, %f", self:get())
end

function vector_3_slice:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3_slice:copy_into(dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number
function vector_3_slice:get()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Set values from a tuple
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set(v1, v2, v3)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	_debug.check("v3", v3, 'number')
	self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
end

---Apply add element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3_slice:add(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3)
end

---Apply add element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3_slice:add_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3)
end

---Apply sub element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3_slice:sub(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3)
end

---Apply sub element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3_slice:sub_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3)
end

---Apply mul element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3_slice:mul(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3)
end

---Apply mul element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3_slice:mul_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
	array.set_3(dest, dest_index or 1, self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3)
end

---Apply div element-wise and return a new vector_3
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@return avm.vector_3
function vector_3_slice:div(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	return M.new(self._src[self._o+1]/v1,self._src[self._o+2]/v2,self._src[self._o+3]/v3)
end

---Apply div element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number3|number
---@param dest avm.seq_number3
---@param dest_index? integer
function vector_3_slice:div_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3 ---@type number,number,number
	if not is_number then
		---@cast v avm.number3
		_debug.check_array("v", v, 1, 3)
		v1, v2, v3 = v[1],v[2],v[3]
	else
		---@cast v number
		v1, v2, v3 = v, v, v
	end
	_debug.check_array("dest", dest, dest_index or 1, 3)
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
---@return number
function vector_3_slice:x()
	return self._src[self._o+1]
end

---Get elements of the vector
---@return number
function vector_3_slice:y()
	return self._src[self._o+2]
end

---Get elements of the vector
---@return number
function vector_3_slice:z()
	return self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:xx()
	return self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:xy()
	return self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:xz()
	return self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:yx()
	return self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:yy()
	return self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:yz()
	return self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:zx()
	return self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:zy()
	return self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_3_slice:zz()
	return self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xxx()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xxy()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xxz()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xyx()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xyy()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xyz()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xzx()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xzy()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:xzz()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yxx()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yxy()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yxz()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yyx()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yyy()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yyz()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yzx()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yzy()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:yzz()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zxx()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zxy()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zxz()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zyx()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zyy()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zyz()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zzx()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zzy()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_3_slice:zzz()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
end

---Set elements of the vector
---@param v1 number
function vector_3_slice:set_x(v1)
	self._src[self._o+1] = v1
end

---Set elements of the vector
---@param v1 number
function vector_3_slice:set_y(v1)
	self._src[self._o+2] = v1
end

---Set elements of the vector
---@param v1 number
function vector_3_slice:set_z(v1)
	self._src[self._o+3] = v1
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3_slice:set_xy(v1, v2)
	self._src[self._o+1], self._src[self._o+2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3_slice:set_xz(v1, v2)
	self._src[self._o+1], self._src[self._o+3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3_slice:set_yx(v1, v2)
	self._src[self._o+2], self._src[self._o+1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3_slice:set_yz(v1, v2)
	self._src[self._o+2], self._src[self._o+3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3_slice:set_zx(v1, v2)
	self._src[self._o+3], self._src[self._o+1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_3_slice:set_zy(v1, v2)
	self._src[self._o+3], self._src[self._o+2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set_xyz(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set_xzy(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set_yxz(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set_yzx(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set_zxy(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_3_slice:set_zyx(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3
end

--]]

return M