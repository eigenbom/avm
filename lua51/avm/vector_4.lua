
--[[
Vector operations and types  

Classes and functions for working with 4-d vectors  


]]
---@class vector_4_module
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
---@diagnostic disable-next-line: unused-local
local avm_path = (...):match("(.-)[^%.]+$")

---@module 'avm.array'
local array = require(avm_path .. "array")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field


---4D vector constructed from a tuple
---
---@class avm.vector_4: avm.number4
---@operator add(avm.number4|number): avm.vector_4
---@operator sub(avm.number4|number): avm.vector_4
---@operator mul(avm.number4|number): avm.vector_4
---@operator div(avm.number4|number): avm.vector_4
---@operator unm():avm.vector_4
---@field n 4
local vector_4 = {}


-----------------------------------------------------------
-- Vector creation
-----------------------------------------------------------

---Create a new vector_4 with given values
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@return avm.vector_4
function M.new(v1, v2, v3, v4)
	assert(v1, "bad argument 'v1' (expected number, got nil)")
	assert(v2, "bad argument 'v2' (expected number, got nil)")
	assert(v3, "bad argument 'v3' (expected number, got nil)")
	assert(v4, "bad argument 'v4' (expected number, got nil)")
	return setmetatable({v1, v2, v3, v4}, vector_4)
end

--[=[
---Create a vector_4_slice class that views into an array or slice
---@param src avm.seq_number
---@param src_index? integer
---@return avm.vector_4_slice
function M.slice(src, src_index)
	assert(src, "bad argument 'src' (expected array or sequence, got nil)")
	local index = src_index or 1
	return setmetatable({_src = src, _o=index-1}, vector_4_slice) --[[@as avm.vector_4_slice]]
end
--]=]

function vector_4:__index(key)
	if key == 'n' then
		return 4
	else
		return vector_4[key]
	end
end

function vector_4:__tostring()
	return string.format("%f, %f, %f, %f", self:get())
end

function vector_4:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4:copy_into(dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number,number
function vector_4:get()
	return self[1], self[2], self[3], self[4]
end

---Set values from a tuple
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
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
---@param v avm.number4|number
---@return avm.vector_4
function vector_4:add(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self[1]+v1,self[2]+v2,self[3]+v3,self[4]+v4)
end

---Apply add element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4:add_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self[1]+v1,self[2]+v2,self[3]+v3,self[4]+v4)
end

---Apply sub element-wise and return a new vector_4
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@return avm.vector_4
function vector_4:sub(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self[1]-v1,self[2]-v2,self[3]-v3,self[4]-v4)
end

---Apply sub element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4:sub_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self[1]-v1,self[2]-v2,self[3]-v3,self[4]-v4)
end

---Apply mul element-wise and return a new vector_4
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@return avm.vector_4
function vector_4:mul(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self[1]*v1,self[2]*v2,self[3]*v3,self[4]*v4)
end

---Apply mul element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4:mul_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self[1]*v1,self[2]*v2,self[3]*v3,self[4]*v4)
end

---Apply div element-wise and return a new vector_4
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@return avm.vector_4
function vector_4:div(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self[1]/v1,self[2]/v2,self[3]/v3,self[4]/v4)
end

---Apply div element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4:div_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
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
---@return number
function vector_4:x()
	return self[1]
end

---Get elements of the vector
---@return number
function vector_4:y()
	return self[2]
end

---Get elements of the vector
---@return number
function vector_4:z()
	return self[3]
end

---Get elements of the vector
---@return number
function vector_4:w()
	return self[4]
end

---Get elements of the vector
---@return number,number
function vector_4:xx()
	return self[1], self[1]
end

---Get elements of the vector
---@return number,number
function vector_4:xy()
	return self[1], self[2]
end

---Get elements of the vector
---@return number,number
function vector_4:xz()
	return self[1], self[3]
end

---Get elements of the vector
---@return number,number
function vector_4:xw()
	return self[1], self[4]
end

---Get elements of the vector
---@return number,number
function vector_4:yx()
	return self[2], self[1]
end

---Get elements of the vector
---@return number,number
function vector_4:yy()
	return self[2], self[2]
end

---Get elements of the vector
---@return number,number
function vector_4:yz()
	return self[2], self[3]
end

---Get elements of the vector
---@return number,number
function vector_4:yw()
	return self[2], self[4]
end

---Get elements of the vector
---@return number,number
function vector_4:zx()
	return self[3], self[1]
end

---Get elements of the vector
---@return number,number
function vector_4:zy()
	return self[3], self[2]
end

---Get elements of the vector
---@return number,number
function vector_4:zz()
	return self[3], self[3]
end

---Get elements of the vector
---@return number,number
function vector_4:zw()
	return self[3], self[4]
end

---Get elements of the vector
---@return number,number
function vector_4:wx()
	return self[4], self[1]
end

---Get elements of the vector
---@return number,number
function vector_4:wy()
	return self[4], self[2]
end

---Get elements of the vector
---@return number,number
function vector_4:wz()
	return self[4], self[3]
end

---Get elements of the vector
---@return number,number
function vector_4:ww()
	return self[4], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xxx()
	return self[1], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xxy()
	return self[1], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xxz()
	return self[1], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xxw()
	return self[1], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xyx()
	return self[1], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xyy()
	return self[1], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xyz()
	return self[1], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xyw()
	return self[1], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xzx()
	return self[1], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xzy()
	return self[1], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xzz()
	return self[1], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xzw()
	return self[1], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xwx()
	return self[1], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xwy()
	return self[1], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xwz()
	return self[1], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:xww()
	return self[1], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yxx()
	return self[2], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yxy()
	return self[2], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yxz()
	return self[2], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yxw()
	return self[2], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yyx()
	return self[2], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yyy()
	return self[2], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yyz()
	return self[2], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yyw()
	return self[2], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yzx()
	return self[2], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yzy()
	return self[2], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yzz()
	return self[2], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yzw()
	return self[2], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:ywx()
	return self[2], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:ywy()
	return self[2], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:ywz()
	return self[2], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:yww()
	return self[2], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zxx()
	return self[3], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zxy()
	return self[3], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zxz()
	return self[3], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zxw()
	return self[3], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zyx()
	return self[3], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zyy()
	return self[3], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zyz()
	return self[3], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zyw()
	return self[3], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zzx()
	return self[3], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zzy()
	return self[3], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zzz()
	return self[3], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zzw()
	return self[3], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zwx()
	return self[3], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zwy()
	return self[3], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zwz()
	return self[3], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:zww()
	return self[3], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wxx()
	return self[4], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wxy()
	return self[4], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wxz()
	return self[4], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wxw()
	return self[4], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wyx()
	return self[4], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wyy()
	return self[4], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wyz()
	return self[4], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wyw()
	return self[4], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wzx()
	return self[4], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wzy()
	return self[4], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wzz()
	return self[4], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wzw()
	return self[4], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wwx()
	return self[4], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wwy()
	return self[4], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number
function vector_4:wwz()
	return self[4], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number
function vector_4:www()
	return self[4], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxxx()
	return self[1], self[1], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxxy()
	return self[1], self[1], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxxz()
	return self[1], self[1], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxxw()
	return self[1], self[1], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxyx()
	return self[1], self[1], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxyy()
	return self[1], self[1], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxyz()
	return self[1], self[1], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxyw()
	return self[1], self[1], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxzx()
	return self[1], self[1], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxzy()
	return self[1], self[1], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxzz()
	return self[1], self[1], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxzw()
	return self[1], self[1], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxwx()
	return self[1], self[1], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxwy()
	return self[1], self[1], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxwz()
	return self[1], self[1], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xxww()
	return self[1], self[1], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyxx()
	return self[1], self[2], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyxy()
	return self[1], self[2], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyxz()
	return self[1], self[2], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyxw()
	return self[1], self[2], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyyx()
	return self[1], self[2], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyyy()
	return self[1], self[2], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyyz()
	return self[1], self[2], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyyw()
	return self[1], self[2], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyzx()
	return self[1], self[2], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyzy()
	return self[1], self[2], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyzz()
	return self[1], self[2], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyzw()
	return self[1], self[2], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xywx()
	return self[1], self[2], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xywy()
	return self[1], self[2], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xywz()
	return self[1], self[2], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xyww()
	return self[1], self[2], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzxx()
	return self[1], self[3], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzxy()
	return self[1], self[3], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzxz()
	return self[1], self[3], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzxw()
	return self[1], self[3], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzyx()
	return self[1], self[3], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzyy()
	return self[1], self[3], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzyz()
	return self[1], self[3], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzyw()
	return self[1], self[3], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzzx()
	return self[1], self[3], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzzy()
	return self[1], self[3], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzzz()
	return self[1], self[3], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzzw()
	return self[1], self[3], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzwx()
	return self[1], self[3], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzwy()
	return self[1], self[3], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzwz()
	return self[1], self[3], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xzww()
	return self[1], self[3], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwxx()
	return self[1], self[4], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwxy()
	return self[1], self[4], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwxz()
	return self[1], self[4], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwxw()
	return self[1], self[4], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwyx()
	return self[1], self[4], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwyy()
	return self[1], self[4], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwyz()
	return self[1], self[4], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwyw()
	return self[1], self[4], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwzx()
	return self[1], self[4], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwzy()
	return self[1], self[4], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwzz()
	return self[1], self[4], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwzw()
	return self[1], self[4], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwwx()
	return self[1], self[4], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwwy()
	return self[1], self[4], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwwz()
	return self[1], self[4], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:xwww()
	return self[1], self[4], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxxx()
	return self[2], self[1], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxxy()
	return self[2], self[1], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxxz()
	return self[2], self[1], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxxw()
	return self[2], self[1], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxyx()
	return self[2], self[1], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxyy()
	return self[2], self[1], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxyz()
	return self[2], self[1], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxyw()
	return self[2], self[1], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxzx()
	return self[2], self[1], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxzy()
	return self[2], self[1], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxzz()
	return self[2], self[1], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxzw()
	return self[2], self[1], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxwx()
	return self[2], self[1], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxwy()
	return self[2], self[1], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxwz()
	return self[2], self[1], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yxww()
	return self[2], self[1], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyxx()
	return self[2], self[2], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyxy()
	return self[2], self[2], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyxz()
	return self[2], self[2], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyxw()
	return self[2], self[2], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyyx()
	return self[2], self[2], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyyy()
	return self[2], self[2], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyyz()
	return self[2], self[2], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyyw()
	return self[2], self[2], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyzx()
	return self[2], self[2], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyzy()
	return self[2], self[2], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyzz()
	return self[2], self[2], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyzw()
	return self[2], self[2], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yywx()
	return self[2], self[2], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yywy()
	return self[2], self[2], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yywz()
	return self[2], self[2], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yyww()
	return self[2], self[2], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzxx()
	return self[2], self[3], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzxy()
	return self[2], self[3], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzxz()
	return self[2], self[3], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzxw()
	return self[2], self[3], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzyx()
	return self[2], self[3], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzyy()
	return self[2], self[3], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzyz()
	return self[2], self[3], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzyw()
	return self[2], self[3], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzzx()
	return self[2], self[3], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzzy()
	return self[2], self[3], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzzz()
	return self[2], self[3], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzzw()
	return self[2], self[3], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzwx()
	return self[2], self[3], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzwy()
	return self[2], self[3], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzwz()
	return self[2], self[3], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:yzww()
	return self[2], self[3], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywxx()
	return self[2], self[4], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywxy()
	return self[2], self[4], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywxz()
	return self[2], self[4], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywxw()
	return self[2], self[4], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywyx()
	return self[2], self[4], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywyy()
	return self[2], self[4], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywyz()
	return self[2], self[4], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywyw()
	return self[2], self[4], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywzx()
	return self[2], self[4], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywzy()
	return self[2], self[4], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywzz()
	return self[2], self[4], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywzw()
	return self[2], self[4], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywwx()
	return self[2], self[4], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywwy()
	return self[2], self[4], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywwz()
	return self[2], self[4], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:ywww()
	return self[2], self[4], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxxx()
	return self[3], self[1], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxxy()
	return self[3], self[1], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxxz()
	return self[3], self[1], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxxw()
	return self[3], self[1], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxyx()
	return self[3], self[1], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxyy()
	return self[3], self[1], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxyz()
	return self[3], self[1], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxyw()
	return self[3], self[1], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxzx()
	return self[3], self[1], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxzy()
	return self[3], self[1], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxzz()
	return self[3], self[1], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxzw()
	return self[3], self[1], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxwx()
	return self[3], self[1], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxwy()
	return self[3], self[1], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxwz()
	return self[3], self[1], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zxww()
	return self[3], self[1], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyxx()
	return self[3], self[2], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyxy()
	return self[3], self[2], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyxz()
	return self[3], self[2], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyxw()
	return self[3], self[2], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyyx()
	return self[3], self[2], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyyy()
	return self[3], self[2], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyyz()
	return self[3], self[2], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyyw()
	return self[3], self[2], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyzx()
	return self[3], self[2], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyzy()
	return self[3], self[2], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyzz()
	return self[3], self[2], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyzw()
	return self[3], self[2], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zywx()
	return self[3], self[2], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zywy()
	return self[3], self[2], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zywz()
	return self[3], self[2], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zyww()
	return self[3], self[2], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzxx()
	return self[3], self[3], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzxy()
	return self[3], self[3], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzxz()
	return self[3], self[3], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzxw()
	return self[3], self[3], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzyx()
	return self[3], self[3], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzyy()
	return self[3], self[3], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzyz()
	return self[3], self[3], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzyw()
	return self[3], self[3], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzzx()
	return self[3], self[3], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzzy()
	return self[3], self[3], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzzz()
	return self[3], self[3], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzzw()
	return self[3], self[3], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzwx()
	return self[3], self[3], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzwy()
	return self[3], self[3], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzwz()
	return self[3], self[3], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zzww()
	return self[3], self[3], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwxx()
	return self[3], self[4], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwxy()
	return self[3], self[4], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwxz()
	return self[3], self[4], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwxw()
	return self[3], self[4], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwyx()
	return self[3], self[4], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwyy()
	return self[3], self[4], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwyz()
	return self[3], self[4], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwyw()
	return self[3], self[4], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwzx()
	return self[3], self[4], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwzy()
	return self[3], self[4], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwzz()
	return self[3], self[4], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwzw()
	return self[3], self[4], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwwx()
	return self[3], self[4], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwwy()
	return self[3], self[4], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwwz()
	return self[3], self[4], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:zwww()
	return self[3], self[4], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxxx()
	return self[4], self[1], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxxy()
	return self[4], self[1], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxxz()
	return self[4], self[1], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxxw()
	return self[4], self[1], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxyx()
	return self[4], self[1], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxyy()
	return self[4], self[1], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxyz()
	return self[4], self[1], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxyw()
	return self[4], self[1], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxzx()
	return self[4], self[1], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxzy()
	return self[4], self[1], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxzz()
	return self[4], self[1], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxzw()
	return self[4], self[1], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxwx()
	return self[4], self[1], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxwy()
	return self[4], self[1], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxwz()
	return self[4], self[1], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wxww()
	return self[4], self[1], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyxx()
	return self[4], self[2], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyxy()
	return self[4], self[2], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyxz()
	return self[4], self[2], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyxw()
	return self[4], self[2], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyyx()
	return self[4], self[2], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyyy()
	return self[4], self[2], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyyz()
	return self[4], self[2], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyyw()
	return self[4], self[2], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyzx()
	return self[4], self[2], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyzy()
	return self[4], self[2], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyzz()
	return self[4], self[2], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyzw()
	return self[4], self[2], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wywx()
	return self[4], self[2], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wywy()
	return self[4], self[2], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wywz()
	return self[4], self[2], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wyww()
	return self[4], self[2], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzxx()
	return self[4], self[3], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzxy()
	return self[4], self[3], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzxz()
	return self[4], self[3], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzxw()
	return self[4], self[3], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzyx()
	return self[4], self[3], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzyy()
	return self[4], self[3], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzyz()
	return self[4], self[3], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzyw()
	return self[4], self[3], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzzx()
	return self[4], self[3], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzzy()
	return self[4], self[3], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzzz()
	return self[4], self[3], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzzw()
	return self[4], self[3], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzwx()
	return self[4], self[3], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzwy()
	return self[4], self[3], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzwz()
	return self[4], self[3], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wzww()
	return self[4], self[3], self[4], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwxx()
	return self[4], self[4], self[1], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwxy()
	return self[4], self[4], self[1], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwxz()
	return self[4], self[4], self[1], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwxw()
	return self[4], self[4], self[1], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwyx()
	return self[4], self[4], self[2], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwyy()
	return self[4], self[4], self[2], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwyz()
	return self[4], self[4], self[2], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwyw()
	return self[4], self[4], self[2], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwzx()
	return self[4], self[4], self[3], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwzy()
	return self[4], self[4], self[3], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwzz()
	return self[4], self[4], self[3], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwzw()
	return self[4], self[4], self[3], self[4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwwx()
	return self[4], self[4], self[4], self[1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwwy()
	return self[4], self[4], self[4], self[2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwwz()
	return self[4], self[4], self[4], self[3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4:wwww()
	return self[4], self[4], self[4], self[4]
end

---Set elements of the vector
---@param v1 number
function vector_4:set_x(v1)
	self[1] = v1
end

---Set elements of the vector
---@param v1 number
function vector_4:set_y(v1)
	self[2] = v1
end

---Set elements of the vector
---@param v1 number
function vector_4:set_z(v1)
	self[3] = v1
end

---Set elements of the vector
---@param v1 number
function vector_4:set_w(v1)
	self[4] = v1
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_xy(v1, v2)
	self[1], self[2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_xz(v1, v2)
	self[1], self[3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_xw(v1, v2)
	self[1], self[4] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_yx(v1, v2)
	self[2], self[1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_yz(v1, v2)
	self[2], self[3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_yw(v1, v2)
	self[2], self[4] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_zx(v1, v2)
	self[3], self[1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_zy(v1, v2)
	self[3], self[2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_zw(v1, v2)
	self[3], self[4] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_wx(v1, v2)
	self[4], self[1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_wy(v1, v2)
	self[4], self[2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4:set_wz(v1, v2)
	self[4], self[3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_xyz(v1, v2, v3)
	self[1], self[2], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_xyw(v1, v2, v3)
	self[1], self[2], self[4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_xzy(v1, v2, v3)
	self[1], self[3], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_xzw(v1, v2, v3)
	self[1], self[3], self[4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_xwy(v1, v2, v3)
	self[1], self[4], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_xwz(v1, v2, v3)
	self[1], self[4], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_yxz(v1, v2, v3)
	self[2], self[1], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_yxw(v1, v2, v3)
	self[2], self[1], self[4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_yzx(v1, v2, v3)
	self[2], self[3], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_yzw(v1, v2, v3)
	self[2], self[3], self[4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_ywx(v1, v2, v3)
	self[2], self[4], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_ywz(v1, v2, v3)
	self[2], self[4], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_zxy(v1, v2, v3)
	self[3], self[1], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_zxw(v1, v2, v3)
	self[3], self[1], self[4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_zyx(v1, v2, v3)
	self[3], self[2], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_zyw(v1, v2, v3)
	self[3], self[2], self[4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_zwx(v1, v2, v3)
	self[3], self[4], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_zwy(v1, v2, v3)
	self[3], self[4], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_wxy(v1, v2, v3)
	self[4], self[1], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_wxz(v1, v2, v3)
	self[4], self[1], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_wyx(v1, v2, v3)
	self[4], self[2], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_wyz(v1, v2, v3)
	self[4], self[2], self[3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_wzx(v1, v2, v3)
	self[4], self[3], self[1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4:set_wzy(v1, v2, v3)
	self[4], self[3], self[2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_xyzw(v1, v2, v3, v4)
	self[1], self[2], self[3], self[4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_xywz(v1, v2, v3, v4)
	self[1], self[2], self[4], self[3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_xzyw(v1, v2, v3, v4)
	self[1], self[3], self[2], self[4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_xzwy(v1, v2, v3, v4)
	self[1], self[3], self[4], self[2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_xwyz(v1, v2, v3, v4)
	self[1], self[4], self[2], self[3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_xwzy(v1, v2, v3, v4)
	self[1], self[4], self[3], self[2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_yxzw(v1, v2, v3, v4)
	self[2], self[1], self[3], self[4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_yxwz(v1, v2, v3, v4)
	self[2], self[1], self[4], self[3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_yzxw(v1, v2, v3, v4)
	self[2], self[3], self[1], self[4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_yzwx(v1, v2, v3, v4)
	self[2], self[3], self[4], self[1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_ywxz(v1, v2, v3, v4)
	self[2], self[4], self[1], self[3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_ywzx(v1, v2, v3, v4)
	self[2], self[4], self[3], self[1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_zxyw(v1, v2, v3, v4)
	self[3], self[1], self[2], self[4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_zxwy(v1, v2, v3, v4)
	self[3], self[1], self[4], self[2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_zyxw(v1, v2, v3, v4)
	self[3], self[2], self[1], self[4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_zywx(v1, v2, v3, v4)
	self[3], self[2], self[4], self[1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_zwxy(v1, v2, v3, v4)
	self[3], self[4], self[1], self[2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_zwyx(v1, v2, v3, v4)
	self[3], self[4], self[2], self[1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_wxyz(v1, v2, v3, v4)
	self[4], self[1], self[2], self[3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_wxzy(v1, v2, v3, v4)
	self[4], self[1], self[3], self[2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_wyxz(v1, v2, v3, v4)
	self[4], self[2], self[1], self[3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_wyzx(v1, v2, v3, v4)
	self[4], self[2], self[3], self[1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_wzxy(v1, v2, v3, v4)
	self[4], self[3], self[1], self[2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4:set_wzyx(v1, v2, v3, v4)
	self[4], self[3], self[2], self[1] = v1, v2, v3, v4
end


--[[
function vector_4_slice:__index(key)
	if type(key) == 'number' and key >= 1 and key <= 4 then
		---@diagnostic disable-next-line: undefined-field
		return self._src[self._o+key]
	elseif key == 'n' then
			return 4
	else
		return vector_4_slice[key]
	end
end
function vector_4_slice:__newindex(key, value)
	if type(key) == 'number' and key >= 1 and key <= 4 then
		---@diagnostic disable-next-line: undefined-field
		self._src[self._o+key] = value
	elseif key == 'n' then
			error("cannot set 'n' field in vector_4_slice")
	else
		rawset(self, key, value)
	end
end

function vector_4_slice:__tostring()
	return string.format("%f, %f, %f, %f", self:get())
end

function vector_4_slice:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4_slice:copy_into(dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number,number
function vector_4_slice:get()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
end

---Set values from a tuple
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
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
---@param v avm.number4|number
---@return avm.vector_4
function vector_4_slice:add(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3,self._src[self._o+4]+v4)
end

---Apply add element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4_slice:add_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self._src[self._o+1]+v1,self._src[self._o+2]+v2,self._src[self._o+3]+v3,self._src[self._o+4]+v4)
end

---Apply sub element-wise and return a new vector_4
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@return avm.vector_4
function vector_4_slice:sub(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3,self._src[self._o+4]-v4)
end

---Apply sub element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4_slice:sub_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self._src[self._o+1]-v1,self._src[self._o+2]-v2,self._src[self._o+3]-v3,self._src[self._o+4]-v4)
end

---Apply mul element-wise and return a new vector_4
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@return avm.vector_4
function vector_4_slice:mul(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3,self._src[self._o+4]*v4)
end

---Apply mul element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4_slice:mul_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_4(dest, dest_index or 1, self._src[self._o+1]*v1,self._src[self._o+2]*v2,self._src[self._o+3]*v3,self._src[self._o+4]*v4)
end

---Apply div element-wise and return a new vector_4
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@return avm.vector_4
function vector_4_slice:div(v)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
		v1, v2, v3, v4 = v, v, v, v
	end
	return M.new(self._src[self._o+1]/v1,self._src[self._o+2]/v2,self._src[self._o+3]/v3,self._src[self._o+4]/v4)
end

---Apply div element-wise and store the result in dest
---
---Parameter `v` can be a number or array
---@param v avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function vector_4_slice:div_into(v, dest, dest_index)
	local is_number = type(v) == 'number'
	local v1, v2, v3, v4 ---@type number,number,number,number
	if not is_number then
		---@cast v avm.number4
		assert(v, "bad argument 'v' (expected array or sequence, got nil)")
		v1, v2, v3, v4 = v[1],v[2],v[3],v[4]
	else
		---@cast v number
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
---@return number
function vector_4_slice:x()
	return self._src[self._o+1]
end

---Get elements of the vector
---@return number
function vector_4_slice:y()
	return self._src[self._o+2]
end

---Get elements of the vector
---@return number
function vector_4_slice:z()
	return self._src[self._o+3]
end

---Get elements of the vector
---@return number
function vector_4_slice:w()
	return self._src[self._o+4]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:xx()
	return self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:xy()
	return self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:xz()
	return self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:xw()
	return self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:yx()
	return self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:yy()
	return self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:yz()
	return self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:yw()
	return self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:zx()
	return self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:zy()
	return self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:zz()
	return self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:zw()
	return self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:wx()
	return self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:wy()
	return self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:wz()
	return self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number
function vector_4_slice:ww()
	return self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xxx()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xxy()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xxz()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xxw()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xyx()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xyy()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xyz()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xyw()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xzx()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xzy()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xzz()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xzw()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xwx()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xwy()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xwz()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:xww()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yxx()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yxy()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yxz()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yxw()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yyx()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yyy()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yyz()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yyw()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yzx()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yzy()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yzz()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yzw()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:ywx()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:ywy()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:ywz()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:yww()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zxx()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zxy()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zxz()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zxw()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zyx()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zyy()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zyz()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zyw()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zzx()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zzy()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zzz()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zzw()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zwx()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zwy()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zwz()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:zww()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wxx()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wxy()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wxz()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wxw()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wyx()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wyy()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wyz()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wyw()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wzx()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wzy()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wzz()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wzw()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wwx()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wwy()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:wwz()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number
function vector_4_slice:www()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxxx()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxxy()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxxz()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxxw()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxyx()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxyy()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxyz()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxyw()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxzx()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxzy()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxzz()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxzw()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxwx()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxwy()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxwz()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xxww()
	return self._src[self._o+1], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyxx()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyxy()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyxz()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyxw()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyyx()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyyy()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyyz()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyyw()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyzx()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyzy()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyzz()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyzw()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xywx()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xywy()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xywz()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xyww()
	return self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzxx()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzxy()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzxz()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzxw()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzyx()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzyy()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzyz()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzyw()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzzx()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzzy()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzzz()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzzw()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzwx()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzwy()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzwz()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xzww()
	return self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwxx()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwxy()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwxz()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwxw()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwyx()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwyy()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwyz()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwyw()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwzx()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwzy()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwzz()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwzw()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwwx()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwwy()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwwz()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:xwww()
	return self._src[self._o+1], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxxx()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxxy()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxxz()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxxw()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxyx()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxyy()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxyz()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxyw()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxzx()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxzy()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxzz()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxzw()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxwx()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxwy()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxwz()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yxww()
	return self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyxx()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyxy()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyxz()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyxw()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyyx()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyyy()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyyz()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyyw()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyzx()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyzy()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyzz()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyzw()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yywx()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yywy()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yywz()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yyww()
	return self._src[self._o+2], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzxx()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzxy()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzxz()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzxw()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzyx()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzyy()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzyz()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzyw()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzzx()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzzy()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzzz()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzzw()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzwx()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzwy()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzwz()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:yzww()
	return self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywxx()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywxy()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywxz()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywxw()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywyx()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywyy()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywyz()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywyw()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywzx()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywzy()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywzz()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywzw()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywwx()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywwy()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywwz()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:ywww()
	return self._src[self._o+2], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxxx()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxxy()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxxz()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxxw()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxyx()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxyy()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxyz()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxyw()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxzx()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxzy()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxzz()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxzw()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxwx()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxwy()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxwz()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zxww()
	return self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyxx()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyxy()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyxz()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyxw()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyyx()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyyy()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyyz()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyyw()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyzx()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyzy()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyzz()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyzw()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zywx()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zywy()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zywz()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zyww()
	return self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzxx()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzxy()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzxz()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzxw()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzyx()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzyy()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzyz()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzyw()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzzx()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzzy()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzzz()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzzw()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzwx()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzwy()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzwz()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zzww()
	return self._src[self._o+3], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwxx()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwxy()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwxz()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwxw()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwyx()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwyy()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwyz()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwyw()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwzx()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwzy()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwzz()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwzw()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwwx()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwwy()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwwz()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:zwww()
	return self._src[self._o+3], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxxx()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxxy()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxxz()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxxw()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxyx()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxyy()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxyz()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxyw()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxzx()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxzy()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxzz()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxzw()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxwx()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxwy()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxwz()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wxww()
	return self._src[self._o+4], self._src[self._o+1], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyxx()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyxy()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyxz()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyxw()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyyx()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyyy()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyyz()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyyw()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyzx()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyzy()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyzz()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyzw()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wywx()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wywy()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wywz()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wyww()
	return self._src[self._o+4], self._src[self._o+2], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzxx()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzxy()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzxz()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzxw()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzyx()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzyy()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzyz()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzyw()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzzx()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzzy()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzzz()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzzw()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzwx()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzwy()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzwz()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wzww()
	return self._src[self._o+4], self._src[self._o+3], self._src[self._o+4], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwxx()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwxy()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwxz()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwxw()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+1], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwyx()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwyy()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwyz()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwyw()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+2], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwzx()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwzy()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwzz()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwzw()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+3], self._src[self._o+4]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwwx()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+1]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwwy()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+2]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwwz()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+3]
end

---Get elements of the vector
---@return number,number,number,number
function vector_4_slice:wwww()
	return self._src[self._o+4], self._src[self._o+4], self._src[self._o+4], self._src[self._o+4]
end

---Set elements of the vector
---@param v1 number
function vector_4_slice:set_x(v1)
	self._src[self._o+1] = v1
end

---Set elements of the vector
---@param v1 number
function vector_4_slice:set_y(v1)
	self._src[self._o+2] = v1
end

---Set elements of the vector
---@param v1 number
function vector_4_slice:set_z(v1)
	self._src[self._o+3] = v1
end

---Set elements of the vector
---@param v1 number
function vector_4_slice:set_w(v1)
	self._src[self._o+4] = v1
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_xy(v1, v2)
	self._src[self._o+1], self._src[self._o+2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_xz(v1, v2)
	self._src[self._o+1], self._src[self._o+3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_xw(v1, v2)
	self._src[self._o+1], self._src[self._o+4] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_yx(v1, v2)
	self._src[self._o+2], self._src[self._o+1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_yz(v1, v2)
	self._src[self._o+2], self._src[self._o+3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_yw(v1, v2)
	self._src[self._o+2], self._src[self._o+4] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_zx(v1, v2)
	self._src[self._o+3], self._src[self._o+1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_zy(v1, v2)
	self._src[self._o+3], self._src[self._o+2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_zw(v1, v2)
	self._src[self._o+3], self._src[self._o+4] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_wx(v1, v2)
	self._src[self._o+4], self._src[self._o+1] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_wy(v1, v2)
	self._src[self._o+4], self._src[self._o+2] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
function vector_4_slice:set_wz(v1, v2)
	self._src[self._o+4], self._src[self._o+3] = v1, v2
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_xyz(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_xyw(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_xzy(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_xzw(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_xwy(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_xwz(v1, v2, v3)
	self._src[self._o+1], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_yxz(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_yxw(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_yzx(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_yzw(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_ywx(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_ywz(v1, v2, v3)
	self._src[self._o+2], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_zxy(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_zxw(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_zyx(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_zyw(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_zwx(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_zwy(v1, v2, v3)
	self._src[self._o+3], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_wxy(v1, v2, v3)
	self._src[self._o+4], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_wxz(v1, v2, v3)
	self._src[self._o+4], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_wyx(v1, v2, v3)
	self._src[self._o+4], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_wyz(v1, v2, v3)
	self._src[self._o+4], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_wzx(v1, v2, v3)
	self._src[self._o+4], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
function vector_4_slice:set_wzy(v1, v2, v3)
	self._src[self._o+4], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_xyzw(v1, v2, v3, v4)
	self._src[self._o+1], self._src[self._o+2], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_xywz(v1, v2, v3, v4)
	self._src[self._o+1], self._src[self._o+2], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_xzyw(v1, v2, v3, v4)
	self._src[self._o+1], self._src[self._o+3], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_xzwy(v1, v2, v3, v4)
	self._src[self._o+1], self._src[self._o+3], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_xwyz(v1, v2, v3, v4)
	self._src[self._o+1], self._src[self._o+4], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_xwzy(v1, v2, v3, v4)
	self._src[self._o+1], self._src[self._o+4], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_yxzw(v1, v2, v3, v4)
	self._src[self._o+2], self._src[self._o+1], self._src[self._o+3], self._src[self._o+4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_yxwz(v1, v2, v3, v4)
	self._src[self._o+2], self._src[self._o+1], self._src[self._o+4], self._src[self._o+3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_yzxw(v1, v2, v3, v4)
	self._src[self._o+2], self._src[self._o+3], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_yzwx(v1, v2, v3, v4)
	self._src[self._o+2], self._src[self._o+3], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_ywxz(v1, v2, v3, v4)
	self._src[self._o+2], self._src[self._o+4], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_ywzx(v1, v2, v3, v4)
	self._src[self._o+2], self._src[self._o+4], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_zxyw(v1, v2, v3, v4)
	self._src[self._o+3], self._src[self._o+1], self._src[self._o+2], self._src[self._o+4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_zxwy(v1, v2, v3, v4)
	self._src[self._o+3], self._src[self._o+1], self._src[self._o+4], self._src[self._o+2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_zyxw(v1, v2, v3, v4)
	self._src[self._o+3], self._src[self._o+2], self._src[self._o+1], self._src[self._o+4] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_zywx(v1, v2, v3, v4)
	self._src[self._o+3], self._src[self._o+2], self._src[self._o+4], self._src[self._o+1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_zwxy(v1, v2, v3, v4)
	self._src[self._o+3], self._src[self._o+4], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_zwyx(v1, v2, v3, v4)
	self._src[self._o+3], self._src[self._o+4], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_wxyz(v1, v2, v3, v4)
	self._src[self._o+4], self._src[self._o+1], self._src[self._o+2], self._src[self._o+3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_wxzy(v1, v2, v3, v4)
	self._src[self._o+4], self._src[self._o+1], self._src[self._o+3], self._src[self._o+2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_wyxz(v1, v2, v3, v4)
	self._src[self._o+4], self._src[self._o+2], self._src[self._o+1], self._src[self._o+3] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_wyzx(v1, v2, v3, v4)
	self._src[self._o+4], self._src[self._o+2], self._src[self._o+3], self._src[self._o+1] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_wzxy(v1, v2, v3, v4)
	self._src[self._o+4], self._src[self._o+3], self._src[self._o+1], self._src[self._o+2] = v1, v2, v3, v4
end

---Set elements of the vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
function vector_4_slice:set_wzyx(v1, v2, v3, v4)
	self._src[self._o+4], self._src[self._o+3], self._src[self._o+2], self._src[self._o+1] = v1, v2, v3, v4
end

--]]

return M