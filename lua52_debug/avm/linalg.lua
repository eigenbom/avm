--[[
Linear algebra routines  

Functions for operating on numerical vectors and matrices up to 4 dimensions  
]]
---@class linalg_module
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


-----------------------------------------------------------
-- Dependencies
-----------------------------------------------------------

-- Math library dependencies
-- Override these to use a different math library or set as nil to remove the dependency
local math = require 'math'
local math_sqrt = math.sqrt

-----------------------------------------------------------
-- Basic constructors
-----------------------------------------------------------

---2d-vector of zeros
---@return number,number
function M.vec2_zero()
	return 0,0
end

---3d-vector of zeros
---@return number,number,number
function M.vec3_zero()
	return 0,0,0
end

---4d-vector of zeros
---@return number,number,number,number
function M.vec4_zero()
	return 0,0,0,0
end

---2x2 matrix of zeros
---@return number,number,number,number
function M.mat2_zero()
	return 0,0,0,0
end

---3x3 matrix of zeros
---@return number,number,number,number,number,number,number,number,number
function M.mat3_zero()
	return 0,0,0, 0,0,0, 0,0,0
end

---4x4 matrix of zeros
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mat4_zero()
	return 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
end

---2x2 identity matrix
---@return number,number,number,number
function M.mat2_identity()
	return 1,0,0,1
end

---3x3 identity matrix
---@return number,number,number,number,number,number,number,number,number
function M.mat3_identity()
	return 1,0,0, 0,1,0, 0,0,1
end

---4x4 identity matrix
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mat4_identity()
	return 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1
end

-----------------------------------------------------------
-- Other constructors
-----------------------------------------------------------

---3x3 translation matrix
---@param x number
---@param y number
---@return number,number,number,number,number,number,number,number,number
function M.mat3_translate(x,y)
	_debug.check("x", x, 'number')
	_debug.check("y", y, 'number')
	assert(type(x)=="number", "expected number, did you mean translatei?")
	return 1,0,0, 0,1,0, x,y,1
end

---3x3 scaling matrix
---@param x number
---@param y number
---@param z number
---@return number,number,number,number,number,number,number,number,number
function M.mat3_scale(x,y,z)
	_debug.check("x", x, 'number')
	_debug.check("y", y, 'number')
	_debug.check("z", z, 'number')
	return x,0,0, 0,y,0, 0,0,z
end

---3x3 rotation matrix
---@param radians number
---@param axis_x number
---@param axis_y number
---@param axis_z number
---@return number,number,number,number,number,number,number,number,number
function M.mat3_rotate_around_axis(radians, axis_x, axis_y, axis_z)
	_debug.check("radians", radians, 'number')
	_debug.check("axis_x", axis_x, 'number')
	_debug.check("axis_y", axis_y, 'number')
	_debug.check("axis_z", axis_z, 'number')
	local s, c = math.sin(radians), math.cos(radians)
	local x, y, z = axis_x, axis_y, axis_z
	local oc = 1-c
	return x*x*oc+c, x*y*oc+z*s, x*z*oc-y*s,
		y*x*oc-z*s, y*y*oc+c, y*z*oc+x*s,
		z*x*oc+y*s, z*y*oc-x*s, z*z*oc+c
end

---4x4 translation matrix
---@param x number
---@param y number
---@param z number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mat4_translate(x,y,z)
	_debug.check("x", x, 'number')
	return 1,0,0,0, 0,1,0,0, 0,0,1,0, x,y,z,1
end

---4x4 scaling matrix
---@param x number
---@param y number
---@param z number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mat4_scale(x,y,z)
	_debug.check("x", x, 'number')
	_debug.check("y", y, 'number')
	_debug.check("z", z, 'number')
	return x,0,0,0, 0,y,0,0, 0,0,z,0, 0,0,0,1
end

---4x4 rotation matrix
---@param radians number
---@param axis_x number
---@param axis_y number
---@param axis_z number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mat4_rotate_around_axis(radians, axis_x, axis_y, axis_z)
	_debug.check("radians", radians, 'number')
	_debug.check("axis_x", axis_x, 'number')
	_debug.check("axis_y", axis_y, 'number')
	_debug.check("axis_z", axis_z, 'number')
	local s, c = math.sin(radians), math.cos(radians)
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
---@param a1 number
---@param a2 number
---@param b1 number
---@param b2 number
---@return number,number
function M.add_2(a1, a2, b1, b2)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	return a1 + b1, a2 + b2
end

---Apply the addition operator to two 2d-vectors
---@param a avm.vec2
---@param b avm.vec2
---@return number,number
function M.add_vec2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1] + b[1], a[2] + b[2]
end

---Apply the addition operator to two 2d-vectors in a slice
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.add_vec2_ex(a, a_index, b, b_index) end
	
---Apply the addition operator to two 2d-vectors in a slice and store the result in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.add_vec2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]+b[bo+1]
		dest[o+2] = a[ao+2]+b[bo+2]
	else
		return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2]
	end
end

---Apply the addition operator to a 2d-vector and a constant
---@param a avm.vec2
---@param c number
---@return number,number
function M.add_vec2_constant(a, c)
	_debug.check_array("a", a, 1, 2)
	_debug.check("c", c, 'number')
	return a[1] + c, a[2] + c
end

---Apply the addition operator to a 2d-vector in a slice and a constant
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.add_vec2_constant_ex(a, a_index, c) end

---Apply the addition operator to a 2d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.add_vec2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] + c
		dest[o+2] = a[ao+2] + c
	else
		return a[ao+1] + c, a[ao+2] + c
	end
end

---Apply the addition operator to two 3-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param b1 number
---@param b2 number
---@param b3 number
---@return number,number,number
function M.add_3(a1, a2, a3, b1, b2, b3)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	return a1 + b1, a2 + b2, a3 + b3
end

---Apply the addition operator to two 3d-vectors
---@param a avm.vec3
---@param b avm.vec3
---@return number,number,number
function M.add_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1] + b[1], a[2] + b[2], a[3] + b[3]
end

---Apply the addition operator to two 3d-vectors in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_vec3_ex(a, a_index, b, b_index) end
	
---Apply the addition operator to two 3d-vectors in a slice and store the result in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.add_vec3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]+b[bo+1]
		dest[o+2] = a[ao+2]+b[bo+2]
		dest[o+3] = a[ao+3]+b[bo+3]
	else
		return a[ao+1]+b[bo+1], a[ao+2]+b[bo+2], a[ao+3]+b[bo+3]
	end
end

---Apply the addition operator to a 3d-vector and a constant
---@param a avm.vec3
---@param c number
---@return number,number,number
function M.add_vec3_constant(a, c)
	_debug.check_array("a", a, 1, 3)
	_debug.check("c", c, 'number')
	return a[1] + c, a[2] + c, a[3] + c
end

---Apply the addition operator to a 3d-vector in a slice and a constant
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_vec3_constant_ex(a, a_index, c) end

---Apply the addition operator to a 3d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.add_vec3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] + c
		dest[o+2] = a[ao+2] + c
		dest[o+3] = a[ao+3] + c
	else
		return a[ao+1] + c, a[ao+2] + c, a[ao+3] + c
	end
end

---Apply the addition operator to two 4-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@param b1 number
---@param b2 number
---@param b3 number
---@param b4 number
---@return number,number,number,number
function M.add_4(a1, a2, a3, a4, b1, b2, b3, b4)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("a4", a4, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	_debug.check("b4", b4, 'number')
	return a1 + b1, a2 + b2, a3 + b3, a4 + b4
end

---Apply the addition operator to two 4d-vectors
---@param a avm.vec4
---@param b avm.vec4
---@return number,number,number,number
function M.add_vec4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4]
end

---Apply the addition operator to two 4d-vectors in a slice
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_vec4_ex(a, a_index, b, b_index) end
	
---Apply the addition operator to two 4d-vectors in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.add_vec4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.vec4
---@param c number
---@return number,number,number,number
function M.add_vec4_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] + c, a[2] + c, a[3] + c, a[4] + c
end

---Apply the addition operator to a 4d-vector in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_vec4_constant_ex(a, a_index, c) end

---Apply the addition operator to a 4d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.add_vec4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a1 number
---@param a2 number
---@param b1 number
---@param b2 number
---@return number,number
function M.sub_2(a1, a2, b1, b2)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	return a1 - b1, a2 - b2
end

---Apply the subtraction operator to two 2d-vectors
---@param a avm.vec2
---@param b avm.vec2
---@return number,number
function M.sub_vec2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1] - b[1], a[2] - b[2]
end

---Apply the subtraction operator to two 2d-vectors in a slice
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.sub_vec2_ex(a, a_index, b, b_index) end
	
---Apply the subtraction operator to two 2d-vectors in a slice and store the result in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.sub_vec2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]-b[bo+1]
		dest[o+2] = a[ao+2]-b[bo+2]
	else
		return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2]
	end
end

---Apply the subtraction operator to a 2d-vector and a constant
---@param a avm.vec2
---@param c number
---@return number,number
function M.sub_vec2_constant(a, c)
	_debug.check_array("a", a, 1, 2)
	_debug.check("c", c, 'number')
	return a[1] - c, a[2] - c
end

---Apply the subtraction operator to a 2d-vector in a slice and a constant
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.sub_vec2_constant_ex(a, a_index, c) end

---Apply the subtraction operator to a 2d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.sub_vec2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] - c
		dest[o+2] = a[ao+2] - c
	else
		return a[ao+1] - c, a[ao+2] - c
	end
end

---Apply the subtraction operator to two 3-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param b1 number
---@param b2 number
---@param b3 number
---@return number,number,number
function M.sub_3(a1, a2, a3, b1, b2, b3)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	return a1 - b1, a2 - b2, a3 - b3
end

---Apply the subtraction operator to two 3d-vectors
---@param a avm.vec3
---@param b avm.vec3
---@return number,number,number
function M.sub_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1] - b[1], a[2] - b[2], a[3] - b[3]
end

---Apply the subtraction operator to two 3d-vectors in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_vec3_ex(a, a_index, b, b_index) end
	
---Apply the subtraction operator to two 3d-vectors in a slice and store the result in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.sub_vec3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]-b[bo+1]
		dest[o+2] = a[ao+2]-b[bo+2]
		dest[o+3] = a[ao+3]-b[bo+3]
	else
		return a[ao+1]-b[bo+1], a[ao+2]-b[bo+2], a[ao+3]-b[bo+3]
	end
end

---Apply the subtraction operator to a 3d-vector and a constant
---@param a avm.vec3
---@param c number
---@return number,number,number
function M.sub_vec3_constant(a, c)
	_debug.check_array("a", a, 1, 3)
	_debug.check("c", c, 'number')
	return a[1] - c, a[2] - c, a[3] - c
end

---Apply the subtraction operator to a 3d-vector in a slice and a constant
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_vec3_constant_ex(a, a_index, c) end

---Apply the subtraction operator to a 3d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.sub_vec3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] - c
		dest[o+2] = a[ao+2] - c
		dest[o+3] = a[ao+3] - c
	else
		return a[ao+1] - c, a[ao+2] - c, a[ao+3] - c
	end
end

---Apply the subtraction operator to two 4-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@param b1 number
---@param b2 number
---@param b3 number
---@param b4 number
---@return number,number,number,number
function M.sub_4(a1, a2, a3, a4, b1, b2, b3, b4)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("a4", a4, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	_debug.check("b4", b4, 'number')
	return a1 - b1, a2 - b2, a3 - b3, a4 - b4
end

---Apply the subtraction operator to two 4d-vectors
---@param a avm.vec4
---@param b avm.vec4
---@return number,number,number,number
function M.sub_vec4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4]
end

---Apply the subtraction operator to two 4d-vectors in a slice
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_vec4_ex(a, a_index, b, b_index) end
	
---Apply the subtraction operator to two 4d-vectors in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.sub_vec4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.vec4
---@param c number
---@return number,number,number,number
function M.sub_vec4_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] - c, a[2] - c, a[3] - c, a[4] - c
end

---Apply the subtraction operator to a 4d-vector in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_vec4_constant_ex(a, a_index, c) end

---Apply the subtraction operator to a 4d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.sub_vec4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a1 number
---@param a2 number
---@param b1 number
---@param b2 number
---@return number,number
function M.mul_2(a1, a2, b1, b2)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	return a1 * b1, a2 * b2
end

---Apply the multiplication operator to two 2d-vectors
---@param a avm.vec2
---@param b avm.vec2
---@return number,number
function M.mul_vec2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1] * b[1], a[2] * b[2]
end

---Apply the multiplication operator to two 2d-vectors in a slice
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.mul_vec2_ex(a, a_index, b, b_index) end
	
---Apply the multiplication operator to two 2d-vectors in a slice and store the result in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.mul_vec2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]*b[bo+1]
		dest[o+2] = a[ao+2]*b[bo+2]
	else
		return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2]
	end
end

---Apply the multiplication operator to a 2d-vector and a constant
---@param a avm.vec2
---@param c number
---@return number,number
function M.mul_vec2_constant(a, c)
	_debug.check_array("a", a, 1, 2)
	_debug.check("c", c, 'number')
	return a[1] * c, a[2] * c
end

---Apply the multiplication operator to a 2d-vector in a slice and a constant
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.mul_vec2_constant_ex(a, a_index, c) end

---Apply the multiplication operator to a 2d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.mul_vec2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] * c
		dest[o+2] = a[ao+2] * c
	else
		return a[ao+1] * c, a[ao+2] * c
	end
end

---Apply the multiplication operator to two 3-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param b1 number
---@param b2 number
---@param b3 number
---@return number,number,number
function M.mul_3(a1, a2, a3, b1, b2, b3)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	return a1 * b1, a2 * b2, a3 * b3
end

---Apply the multiplication operator to two 3d-vectors
---@param a avm.vec3
---@param b avm.vec3
---@return number,number,number
function M.mul_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1] * b[1], a[2] * b[2], a[3] * b[3]
end

---Apply the multiplication operator to two 3d-vectors in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_vec3_ex(a, a_index, b, b_index) end
	
---Apply the multiplication operator to two 3d-vectors in a slice and store the result in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.mul_vec3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]*b[bo+1]
		dest[o+2] = a[ao+2]*b[bo+2]
		dest[o+3] = a[ao+3]*b[bo+3]
	else
		return a[ao+1]*b[bo+1], a[ao+2]*b[bo+2], a[ao+3]*b[bo+3]
	end
end

---Apply the multiplication operator to a 3d-vector and a constant
---@param a avm.vec3
---@param c number
---@return number,number,number
function M.mul_vec3_constant(a, c)
	_debug.check_array("a", a, 1, 3)
	_debug.check("c", c, 'number')
	return a[1] * c, a[2] * c, a[3] * c
end

---Apply the multiplication operator to a 3d-vector in a slice and a constant
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_vec3_constant_ex(a, a_index, c) end

---Apply the multiplication operator to a 3d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.mul_vec3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] * c
		dest[o+2] = a[ao+2] * c
		dest[o+3] = a[ao+3] * c
	else
		return a[ao+1] * c, a[ao+2] * c, a[ao+3] * c
	end
end

---Apply the multiplication operator to two 4-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@param b1 number
---@param b2 number
---@param b3 number
---@param b4 number
---@return number,number,number,number
function M.mul_4(a1, a2, a3, a4, b1, b2, b3, b4)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("a4", a4, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	_debug.check("b4", b4, 'number')
	return a1 * b1, a2 * b2, a3 * b3, a4 * b4
end

---Apply the multiplication operator to two 4d-vectors
---@param a avm.vec4
---@param b avm.vec4
---@return number,number,number,number
function M.mul_vec4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4]
end

---Apply the multiplication operator to two 4d-vectors in a slice
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_vec4_ex(a, a_index, b, b_index) end
	
---Apply the multiplication operator to two 4d-vectors in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.mul_vec4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.vec4
---@param c number
---@return number,number,number,number
function M.mul_vec4_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] * c, a[2] * c, a[3] * c, a[4] * c
end

---Apply the multiplication operator to a 4d-vector in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_vec4_constant_ex(a, a_index, c) end

---Apply the multiplication operator to a 4d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.mul_vec4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a1 number
---@param a2 number
---@param b1 number
---@param b2 number
---@return number,number
function M.div_2(a1, a2, b1, b2)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	return a1 / b1, a2 / b2
end

---Apply the division operator to two 2d-vectors
---@param a avm.vec2
---@param b avm.vec2
---@return number,number
function M.div_vec2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1] / b[1], a[2] / b[2]
end

---Apply the division operator to two 2d-vectors in a slice
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.div_vec2_ex(a, a_index, b, b_index) end
	
---Apply the division operator to two 2d-vectors in a slice and store the result in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.div_vec2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]/b[bo+1]
		dest[o+2] = a[ao+2]/b[bo+2]
	else
		return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2]
	end
end

---Apply the division operator to a 2d-vector and a constant
---@param a avm.vec2
---@param c number
---@return number,number
function M.div_vec2_constant(a, c)
	_debug.check_array("a", a, 1, 2)
	_debug.check("c", c, 'number')
	return a[1] / c, a[2] / c
end

---Apply the division operator to a 2d-vector in a slice and a constant
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.div_vec2_constant_ex(a, a_index, c) end

---Apply the division operator to a 2d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.div_vec2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] / c
		dest[o+2] = a[ao+2] / c
	else
		return a[ao+1] / c, a[ao+2] / c
	end
end

---Apply the division operator to two 3-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param b1 number
---@param b2 number
---@param b3 number
---@return number,number,number
function M.div_3(a1, a2, a3, b1, b2, b3)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	return a1 / b1, a2 / b2, a3 / b3
end

---Apply the division operator to two 3d-vectors
---@param a avm.vec3
---@param b avm.vec3
---@return number,number,number
function M.div_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1] / b[1], a[2] / b[2], a[3] / b[3]
end

---Apply the division operator to two 3d-vectors in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_vec3_ex(a, a_index, b, b_index) end
	
---Apply the division operator to two 3d-vectors in a slice and store the result in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.div_vec3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]/b[bo+1]
		dest[o+2] = a[ao+2]/b[bo+2]
		dest[o+3] = a[ao+3]/b[bo+3]
	else
		return a[ao+1]/b[bo+1], a[ao+2]/b[bo+2], a[ao+3]/b[bo+3]
	end
end

---Apply the division operator to a 3d-vector and a constant
---@param a avm.vec3
---@param c number
---@return number,number,number
function M.div_vec3_constant(a, c)
	_debug.check_array("a", a, 1, 3)
	_debug.check("c", c, 'number')
	return a[1] / c, a[2] / c, a[3] / c
end

---Apply the division operator to a 3d-vector in a slice and a constant
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_vec3_constant_ex(a, a_index, c) end

---Apply the division operator to a 3d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.div_vec3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] / c
		dest[o+2] = a[ao+2] / c
		dest[o+3] = a[ao+3] / c
	else
		return a[ao+1] / c, a[ao+2] / c, a[ao+3] / c
	end
end

---Apply the division operator to two 4-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@param b1 number
---@param b2 number
---@param b3 number
---@param b4 number
---@return number,number,number,number
function M.div_4(a1, a2, a3, a4, b1, b2, b3, b4)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("a4", a4, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	_debug.check("b4", b4, 'number')
	return a1 / b1, a2 / b2, a3 / b3, a4 / b4
end

---Apply the division operator to two 4d-vectors
---@param a avm.vec4
---@param b avm.vec4
---@return number,number,number,number
function M.div_vec4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4]
end

---Apply the division operator to two 4d-vectors in a slice
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_vec4_ex(a, a_index, b, b_index) end
	
---Apply the division operator to two 4d-vectors in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.div_vec4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.vec4
---@param c number
---@return number,number,number,number
function M.div_vec4_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] / c, a[2] / c, a[3] / c, a[4] / c
end

---Apply the division operator to a 4d-vector in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_vec4_constant_ex(a, a_index, c) end

---Apply the division operator to a 4d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.div_vec4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a1 number
---@param a2 number
---@param b1 number
---@param b2 number
---@return number,number
function M.pow_2(a1, a2, b1, b2)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	return a1 ^ b1, a2 ^ b2
end

---Apply the exponentiation operator to two 2d-vectors
---@param a avm.vec2
---@param b avm.vec2
---@return number,number
function M.pow_vec2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1] ^ b[1], a[2] ^ b[2]
end

---Apply the exponentiation operator to two 2d-vectors in a slice
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.pow_vec2_ex(a, a_index, b, b_index) end
	
---Apply the exponentiation operator to two 2d-vectors in a slice and store the result in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.pow_vec2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]^b[bo+1]
		dest[o+2] = a[ao+2]^b[bo+2]
	else
		return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2]
	end
end

---Apply the exponentiation operator to a 2d-vector and a constant
---@param a avm.vec2
---@param c number
---@return number,number
function M.pow_vec2_constant(a, c)
	_debug.check_array("a", a, 1, 2)
	_debug.check("c", c, 'number')
	return a[1] ^ c, a[2] ^ c
end

---Apply the exponentiation operator to a 2d-vector in a slice and a constant
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.pow_vec2_constant_ex(a, a_index, c) end

---Apply the exponentiation operator to a 2d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param c number
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.pow_vec2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] ^ c
		dest[o+2] = a[ao+2] ^ c
	else
		return a[ao+1] ^ c, a[ao+2] ^ c
	end
end

---Apply the exponentiation operator to two 3-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param b1 number
---@param b2 number
---@param b3 number
---@return number,number,number
function M.pow_3(a1, a2, a3, b1, b2, b3)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	return a1 ^ b1, a2 ^ b2, a3 ^ b3
end

---Apply the exponentiation operator to two 3d-vectors
---@param a avm.vec3
---@param b avm.vec3
---@return number,number,number
function M.pow_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3]
end

---Apply the exponentiation operator to two 3d-vectors in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_vec3_ex(a, a_index, b, b_index) end
	
---Apply the exponentiation operator to two 3d-vectors in a slice and store the result in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.pow_vec3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1]^b[bo+1]
		dest[o+2] = a[ao+2]^b[bo+2]
		dest[o+3] = a[ao+3]^b[bo+3]
	else
		return a[ao+1]^b[bo+1], a[ao+2]^b[bo+2], a[ao+3]^b[bo+3]
	end
end

---Apply the exponentiation operator to a 3d-vector and a constant
---@param a avm.vec3
---@param c number
---@return number,number,number
function M.pow_vec3_constant(a, c)
	_debug.check_array("a", a, 1, 3)
	_debug.check("c", c, 'number')
	return a[1] ^ c, a[2] ^ c, a[3] ^ c
end

---Apply the exponentiation operator to a 3d-vector in a slice and a constant
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_vec3_constant_ex(a, a_index, c) end

---Apply the exponentiation operator to a 3d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param c number
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.pow_vec3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		local o = dest_index and (dest_index - 1) or 0
		dest[o+1] = a[ao+1] ^ c
		dest[o+2] = a[ao+2] ^ c
		dest[o+3] = a[ao+3] ^ c
	else
		return a[ao+1] ^ c, a[ao+2] ^ c, a[ao+3] ^ c
	end
end

---Apply the exponentiation operator to two 4-tuples
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@param b1 number
---@param b2 number
---@param b3 number
---@param b4 number
---@return number,number,number,number
function M.pow_4(a1, a2, a3, a4, b1, b2, b3, b4)
	_debug.check("a1", a1, 'number')
	_debug.check("a2", a2, 'number')
	_debug.check("a3", a3, 'number')
	_debug.check("a4", a4, 'number')
	_debug.check("b1", b1, 'number')
	_debug.check("b2", b2, 'number')
	_debug.check("b3", b3, 'number')
	_debug.check("b4", b4, 'number')
	return a1 ^ b1, a2 ^ b2, a3 ^ b3, a4 ^ b4
end

---Apply the exponentiation operator to two 4d-vectors
---@param a avm.vec4
---@param b avm.vec4
---@return number,number,number,number
function M.pow_vec4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4]
end

---Apply the exponentiation operator to two 4d-vectors in a slice
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_vec4_ex(a, a_index, b, b_index) end
	
---Apply the exponentiation operator to two 4d-vectors in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.pow_vec4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.vec4
---@param c number
---@return number,number,number,number
function M.pow_vec4_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c
end

---Apply the exponentiation operator to a 4d-vector in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_vec4_constant_ex(a, a_index, c) end

---Apply the exponentiation operator to a 4d-vector in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.pow_vec4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.vec2
---@return number,number
function M.negate_vec2(a)
	_debug.check_array("a", a, 1, 2)
	return -a[1],-a[2]
end

---Negate a 2d-vector in a slice
---@param a avm.seq_number2
---@param a_index integer
---@return number,number
---@diagnostic disable-next-line: missing-return
function M.negate_vec2_ex(a, a_index) end

---Negate a 2d-vector in a slice and store the result in a destination
---@param a avm.seq_number2
---@param a_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.negate_vec2_ex(a, a_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	local ao = a_index
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		array.set_2(dest, dest_index or 1, -a[ao],-a[1+ao])
	else
		return -a[ao],-a[1+ao]
	end
end

---Negate a 3d-vector
---@param a avm.vec3
---@return number,number,number
function M.negate_vec3(a)
	_debug.check_array("a", a, 1, 3)
	return -a[1],-a[2],-a[3]
end

---Negate a 3d-vector in a slice
---@param a avm.seq_number3
---@param a_index integer
---@return number,number,number
---@diagnostic disable-next-line: missing-return
function M.negate_vec3_ex(a, a_index) end

---Negate a 3d-vector in a slice and store the result in a destination
---@param a avm.seq_number3
---@param a_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.negate_vec3_ex(a, a_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	local ao = a_index
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		array.set_3(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao])
	else
		return -a[ao],-a[1+ao],-a[2+ao]
	end
end

---Negate a 4d-vector
---@param a avm.vec4
---@return number,number,number,number
function M.negate_vec4(a)
	_debug.check_array("a", a, 1, 4)
	return -a[1],-a[2],-a[3],-a[4]
end

---Negate a 4d-vector in a slice
---@param a avm.seq_number4
---@param a_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.negate_vec4_ex(a, a_index) end

---Negate a 4d-vector in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.negate_vec4_ex(a, a_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	local ao = a_index
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
		array.set_4(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao])
	else
		return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao]
	end
end

---true if the vectors are equal (differ by epsilon or less)
---@param a avm.vec2
---@param b avm.vec2
---@param epsilon? number
function M.equals_vec2(a, b, epsilon)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return array.all_almost_equals_ex(a, 1, 2, b, 1, epsilon)
end
 
---true if the vectors in a slice are equal (differ by epsilon or less)
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param epsilon? number
function M.equals_vec2_ex(a, a_index, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	return array.all_almost_equals_ex(a, a_index, 2, b, b_index, epsilon)
end

---true if the vectors are equal (differ by epsilon or less)
---@param a avm.vec3
---@param b avm.vec3
---@param epsilon? number
function M.equals_vec3(a, b, epsilon)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return array.all_almost_equals_ex(a, 1, 3, b, 1, epsilon)
end
 
---true if the vectors in a slice are equal (differ by epsilon or less)
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param epsilon? number
function M.equals_vec3_ex(a, a_index, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	return array.all_almost_equals_ex(a, a_index, 3, b, b_index, epsilon)
end

---true if the vectors are equal (differ by epsilon or less)
---@param a avm.vec4
---@param b avm.vec4
---@param epsilon? number
function M.equals_vec4(a, b, epsilon)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return array.all_almost_equals_ex(a, 1, 4, b, 1, epsilon)
end
 
---true if the vectors in a slice are equal (differ by epsilon or less)
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param epsilon? number
function M.equals_vec4_ex(a, a_index, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	return array.all_almost_equals_ex(a, a_index, 4, b, b_index, epsilon)
end


---Apply the addition operator to each element in two 2x2 matrices
---
---@param a avm.mat2
---@param b avm.mat2
---@return number,number,number,number
function M.add_mat2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4]
end

---Apply the addition operator to each element in two 2x2 matrices in a slice
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_mat2_ex(a, a_index, b, b_index) end
	
---Apply the addition operator to each element in two 2d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.add_mat2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat2
---@param c number
---@return number,number,number,number
function M.add_mat2_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] + c, a[2] + c, a[3] + c, a[4] + c
end

---Apply the addition operator to each element in a 2x2 matrix in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_mat2_constant_ex(a, a_index, c) end

---Apply the addition operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.add_mat2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat3
---@param b avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.add_mat3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4], a[5] + b[5], a[6] + b[6], a[7] + b[7], a[8] + b[8], a[9] + b[9]
end

---Apply the addition operator to each element in two 3x3 matrices in a slice
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_mat3_ex(a, a_index, b, b_index) end
	
---Apply the addition operator to each element in two 3d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number9
---@param b_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.add_mat3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat3
---@param c number
---@return number,number,number,number,number,number,number,number,number
function M.add_mat3_constant(a, c)
	_debug.check_array("a", a, 1, 9)
	_debug.check("c", c, 'number')
	return a[1] + c, a[2] + c, a[3] + c, a[4] + c, a[5] + c, a[6] + c, a[7] + c, a[8] + c, a[9] + c
end

---Apply the addition operator to each element in a 3x3 matrix in a slice and a constant
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_mat3_constant_ex(a, a_index, c) end

---Apply the addition operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.add_mat3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat4
---@param b avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.add_mat4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
	return a[1] + b[1], a[2] + b[2], a[3] + b[3], a[4] + b[4], a[5] + b[5], a[6] + b[6], a[7] + b[7], a[8] + b[8], a[9] + b[9], a[10] + b[10], a[11] + b[11], a[12] + b[12], a[13] + b[13], a[14] + b[14], a[15] + b[15], a[16] + b[16]
end

---Apply the addition operator to each element in two 4x4 matrices in a slice
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_mat4_ex(a, a_index, b, b_index) end
	
---Apply the addition operator to each element in two 4d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number16
---@param b_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.add_mat4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat4
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.add_mat4_constant(a, c)
	_debug.check_array("a", a, 1, 16)
	_debug.check("c", c, 'number')
	return a[1] + c, a[2] + c, a[3] + c, a[4] + c, a[5] + c, a[6] + c, a[7] + c, a[8] + c, a[9] + c, a[10] + c, a[11] + c, a[12] + c, a[13] + c, a[14] + c, a[15] + c, a[16] + c
end

---Apply the addition operator to each element in a 4x4 matrix in a slice and a constant
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.add_mat4_constant_ex(a, a_index, c) end

---Apply the addition operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.add_mat4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat2
---@param b avm.mat2
---@return number,number,number,number
function M.sub_mat2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4]
end

---Apply the subtraction operator to each element in two 2x2 matrices in a slice
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_mat2_ex(a, a_index, b, b_index) end
	
---Apply the subtraction operator to each element in two 2d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.sub_mat2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat2
---@param c number
---@return number,number,number,number
function M.sub_mat2_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] - c, a[2] - c, a[3] - c, a[4] - c
end

---Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_mat2_constant_ex(a, a_index, c) end

---Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.sub_mat2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat3
---@param b avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.sub_mat3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4], a[5] - b[5], a[6] - b[6], a[7] - b[7], a[8] - b[8], a[9] - b[9]
end

---Apply the subtraction operator to each element in two 3x3 matrices in a slice
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_mat3_ex(a, a_index, b, b_index) end
	
---Apply the subtraction operator to each element in two 3d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number9
---@param b_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.sub_mat3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat3
---@param c number
---@return number,number,number,number,number,number,number,number,number
function M.sub_mat3_constant(a, c)
	_debug.check_array("a", a, 1, 9)
	_debug.check("c", c, 'number')
	return a[1] - c, a[2] - c, a[3] - c, a[4] - c, a[5] - c, a[6] - c, a[7] - c, a[8] - c, a[9] - c
end

---Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_mat3_constant_ex(a, a_index, c) end

---Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.sub_mat3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat4
---@param b avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.sub_mat4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
	return a[1] - b[1], a[2] - b[2], a[3] - b[3], a[4] - b[4], a[5] - b[5], a[6] - b[6], a[7] - b[7], a[8] - b[8], a[9] - b[9], a[10] - b[10], a[11] - b[11], a[12] - b[12], a[13] - b[13], a[14] - b[14], a[15] - b[15], a[16] - b[16]
end

---Apply the subtraction operator to each element in two 4x4 matrices in a slice
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_mat4_ex(a, a_index, b, b_index) end
	
---Apply the subtraction operator to each element in two 4d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number16
---@param b_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.sub_mat4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat4
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.sub_mat4_constant(a, c)
	_debug.check_array("a", a, 1, 16)
	_debug.check("c", c, 'number')
	return a[1] - c, a[2] - c, a[3] - c, a[4] - c, a[5] - c, a[6] - c, a[7] - c, a[8] - c, a[9] - c, a[10] - c, a[11] - c, a[12] - c, a[13] - c, a[14] - c, a[15] - c, a[16] - c
end

---Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.sub_mat4_constant_ex(a, a_index, c) end

---Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.sub_mat4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@see linalg_module.matmul_mat2_mat2
---@param a avm.mat2
---@param b avm.mat2
---@return number,number,number,number
function M.mul_mat2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4]
end

---Apply the multiplication operator to each element in two 2x2 matrices in a slice
---
---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
---
---@see linalg_module.matmul_mat2_mat2
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_mat2_ex(a, a_index, b, b_index) end
	
---Apply the multiplication operator to each element in two 2d-vectors in a slice and store the result in a destination
---
---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
---
---@see linalg_module.matmul_mat2_mat2
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.mul_mat2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat2
---@param c number
---@return number,number,number,number
function M.mul_mat2_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] * c, a[2] * c, a[3] * c, a[4] * c
end

---Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_mat2_constant_ex(a, a_index, c) end

---Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.mul_mat2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@see linalg_module.matmul_mat3_mat3
---@param a avm.mat3
---@param b avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.mul_mat3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4], a[5] * b[5], a[6] * b[6], a[7] * b[7], a[8] * b[8], a[9] * b[9]
end

---Apply the multiplication operator to each element in two 3x3 matrices in a slice
---
---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
---
---@see linalg_module.matmul_mat3_mat3
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_mat3_ex(a, a_index, b, b_index) end
	
---Apply the multiplication operator to each element in two 3d-vectors in a slice and store the result in a destination
---
---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
---
---@see linalg_module.matmul_mat3_mat3
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number9
---@param b_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.mul_mat3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat3
---@param c number
---@return number,number,number,number,number,number,number,number,number
function M.mul_mat3_constant(a, c)
	_debug.check_array("a", a, 1, 9)
	_debug.check("c", c, 'number')
	return a[1] * c, a[2] * c, a[3] * c, a[4] * c, a[5] * c, a[6] * c, a[7] * c, a[8] * c, a[9] * c
end

---Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_mat3_constant_ex(a, a_index, c) end

---Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.mul_mat3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@see linalg_module.matmul_mat4_mat4
---@param a avm.mat4
---@param b avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mul_mat4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
	return a[1] * b[1], a[2] * b[2], a[3] * b[3], a[4] * b[4], a[5] * b[5], a[6] * b[6], a[7] * b[7], a[8] * b[8], a[9] * b[9], a[10] * b[10], a[11] * b[11], a[12] * b[12], a[13] * b[13], a[14] * b[14], a[15] * b[15], a[16] * b[16]
end

---Apply the multiplication operator to each element in two 4x4 matrices in a slice
---
---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
---
---@see linalg_module.matmul_mat4_mat4
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_mat4_ex(a, a_index, b, b_index) end
	
---Apply the multiplication operator to each element in two 4d-vectors in a slice and store the result in a destination
---
---Note: This is element-wise multiplication, for standard matrix multiplication see `linalg_module.matmul`
---
---@see linalg_module.matmul_mat4_mat4
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number16
---@param b_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.mul_mat4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat4
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.mul_mat4_constant(a, c)
	_debug.check_array("a", a, 1, 16)
	_debug.check("c", c, 'number')
	return a[1] * c, a[2] * c, a[3] * c, a[4] * c, a[5] * c, a[6] * c, a[7] * c, a[8] * c, a[9] * c, a[10] * c, a[11] * c, a[12] * c, a[13] * c, a[14] * c, a[15] * c, a[16] * c
end

---Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.mul_mat4_constant_ex(a, a_index, c) end

---Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.mul_mat4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat2
---@param b avm.mat2
---@return number,number,number,number
function M.div_mat2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4]
end

---Apply the division operator to each element in two 2x2 matrices in a slice
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_mat2_ex(a, a_index, b, b_index) end
	
---Apply the division operator to each element in two 2d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.div_mat2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat2
---@param c number
---@return number,number,number,number
function M.div_mat2_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] / c, a[2] / c, a[3] / c, a[4] / c
end

---Apply the division operator to each element in a 2x2 matrix in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_mat2_constant_ex(a, a_index, c) end

---Apply the division operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.div_mat2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat3
---@param b avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.div_mat3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4], a[5] / b[5], a[6] / b[6], a[7] / b[7], a[8] / b[8], a[9] / b[9]
end

---Apply the division operator to each element in two 3x3 matrices in a slice
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_mat3_ex(a, a_index, b, b_index) end
	
---Apply the division operator to each element in two 3d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number9
---@param b_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.div_mat3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat3
---@param c number
---@return number,number,number,number,number,number,number,number,number
function M.div_mat3_constant(a, c)
	_debug.check_array("a", a, 1, 9)
	_debug.check("c", c, 'number')
	return a[1] / c, a[2] / c, a[3] / c, a[4] / c, a[5] / c, a[6] / c, a[7] / c, a[8] / c, a[9] / c
end

---Apply the division operator to each element in a 3x3 matrix in a slice and a constant
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_mat3_constant_ex(a, a_index, c) end

---Apply the division operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.div_mat3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat4
---@param b avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.div_mat4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
	return a[1] / b[1], a[2] / b[2], a[3] / b[3], a[4] / b[4], a[5] / b[5], a[6] / b[6], a[7] / b[7], a[8] / b[8], a[9] / b[9], a[10] / b[10], a[11] / b[11], a[12] / b[12], a[13] / b[13], a[14] / b[14], a[15] / b[15], a[16] / b[16]
end

---Apply the division operator to each element in two 4x4 matrices in a slice
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_mat4_ex(a, a_index, b, b_index) end
	
---Apply the division operator to each element in two 4d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number16
---@param b_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.div_mat4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat4
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.div_mat4_constant(a, c)
	_debug.check_array("a", a, 1, 16)
	_debug.check("c", c, 'number')
	return a[1] / c, a[2] / c, a[3] / c, a[4] / c, a[5] / c, a[6] / c, a[7] / c, a[8] / c, a[9] / c, a[10] / c, a[11] / c, a[12] / c, a[13] / c, a[14] / c, a[15] / c, a[16] / c
end

---Apply the division operator to each element in a 4x4 matrix in a slice and a constant
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.div_mat4_constant_ex(a, a_index, c) end

---Apply the division operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.div_mat4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat2
---@param b avm.mat2
---@return number,number,number,number
function M.pow_mat2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4]
end

---Apply the exponentiation operator to each element in two 2x2 matrices in a slice
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_mat2_ex(a, a_index, b, b_index) end
	
---Apply the exponentiation operator to each element in two 2d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.pow_mat2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat2
---@param c number
---@return number,number,number,number
function M.pow_mat2_constant(a, c)
	_debug.check_array("a", a, 1, 4)
	_debug.check("c", c, 'number')
	return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c
end

---Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_mat2_constant_ex(a, a_index, c) end

---Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param c number
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.pow_mat2_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
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
---@param a avm.mat3
---@param b avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.pow_mat3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4], a[5] ^ b[5], a[6] ^ b[6], a[7] ^ b[7], a[8] ^ b[8], a[9] ^ b[9]
end

---Apply the exponentiation operator to each element in two 3x3 matrices in a slice
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_mat3_ex(a, a_index, b, b_index) end
	
---Apply the exponentiation operator to each element in two 3d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number9
---@param a_index integer
---@param b avm.seq_number9
---@param b_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.pow_mat3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat3
---@param c number
---@return number,number,number,number,number,number,number,number,number
function M.pow_mat3_constant(a, c)
	_debug.check_array("a", a, 1, 9)
	_debug.check("c", c, 'number')
	return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c, a[5] ^ c, a[6] ^ c, a[7] ^ c, a[8] ^ c, a[9] ^ c
end

---Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_mat3_constant_ex(a, a_index, c) end

---Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number9
---@param a_index integer
---@param c number
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.pow_mat3_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
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
---@param a avm.mat4
---@param b avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.pow_mat4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
	return a[1] ^ b[1], a[2] ^ b[2], a[3] ^ b[3], a[4] ^ b[4], a[5] ^ b[5], a[6] ^ b[6], a[7] ^ b[7], a[8] ^ b[8], a[9] ^ b[9], a[10] ^ b[10], a[11] ^ b[11], a[12] ^ b[12], a[13] ^ b[13], a[14] ^ b[14], a[15] ^ b[15], a[16] ^ b[16]
end

---Apply the exponentiation operator to each element in two 4x4 matrices in a slice
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_mat4_ex(a, a_index, b, b_index) end
	
---Apply the exponentiation operator to each element in two 4d-vectors in a slice and store the result in a destination
---
---@param a avm.seq_number16
---@param a_index integer
---@param b avm.seq_number16
---@param b_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.pow_mat4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1
	local bo = b_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat4
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.pow_mat4_constant(a, c)
	_debug.check_array("a", a, 1, 16)
	_debug.check("c", c, 'number')
	return a[1] ^ c, a[2] ^ c, a[3] ^ c, a[4] ^ c, a[5] ^ c, a[6] ^ c, a[7] ^ c, a[8] ^ c, a[9] ^ c, a[10] ^ c, a[11] ^ c, a[12] ^ c, a[13] ^ c, a[14] ^ c, a[15] ^ c, a[16] ^ c
end

---Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.pow_mat4_constant_ex(a, a_index, c) end

---Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant and store in a destination
---@param a avm.seq_number16
---@param a_index integer
---@param c number
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.pow_mat4_constant_ex(a, a_index, c, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check("c", c, 'number')
	local ao = a_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
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
---@param a avm.mat2
---@return number,number,number,number
function M.negate_mat2(a)
	_debug.check_array("a", a, 1, 2)
	return -a[1],-a[2],-a[3],-a[4]
end

---Negate a 2x2 matrix in a slice
---@param a avm.seq_number4
---@param a_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.negate_mat2_ex(a, a_index) end

---Negate a 2x2 matrix in a slice and store the result in a destination
---@param a avm.seq_number4
---@param a_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.negate_mat2_ex(a, a_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	local ao = a_index
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
		array.set_4(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao])
	else
		return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao]
	end
end

---Negate a 3x3 matrix
---@param a avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.negate_mat3(a)
	_debug.check_array("a", a, 1, 3)
	return -a[1],-a[2],-a[3],-a[4],-a[5],-a[6],-a[7],-a[8],-a[9]
end

---Negate a 3x3 matrix in a slice
---@param a avm.seq_number9
---@param a_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.negate_mat3_ex(a, a_index) end

---Negate a 3x3 matrix in a slice and store the result in a destination
---@param a avm.seq_number9
---@param a_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.negate_mat3_ex(a, a_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	local ao = a_index
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
		array.set_9(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao])
	else
		return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao]
	end
end

---Negate a 4x4 matrix
---@param a avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.negate_mat4(a)
	_debug.check_array("a", a, 1, 4)
	return -a[1],-a[2],-a[3],-a[4],-a[5],-a[6],-a[7],-a[8],-a[9],-a[10],-a[11],-a[12],-a[13],-a[14],-a[15],-a[16]
end

---Negate a 4x4 matrix in a slice
---@param a avm.seq_number16
---@param a_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: missing-return
function M.negate_mat4_ex(a, a_index) end

---Negate a 4x4 matrix in a slice and store the result in a destination
---@param a avm.seq_number16
---@param a_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.negate_mat4_ex(a, a_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	local ao = a_index
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
		array.set_16(dest, dest_index or 1, -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao],-a[9+ao],-a[10+ao],-a[11+ao],-a[12+ao],-a[13+ao],-a[14+ao],-a[15+ao])
	else
		return -a[ao],-a[1+ao],-a[2+ao],-a[3+ao],-a[4+ao],-a[5+ao],-a[6+ao],-a[7+ao],-a[8+ao],-a[9+ao],-a[10+ao],-a[11+ao],-a[12+ao],-a[13+ao],-a[14+ao],-a[15+ao]
	end
end

---true if the matrices are equal (differ by epsilon or less)
---@param a avm.mat2
---@param b avm.mat2
---@param epsilon? number
function M.equals_mat2(a, b, epsilon)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return array.all_almost_equals_ex(a, 1, 4, b, 1, epsilon)
end
 
---true if the matrices in a slice are equal (differ by epsilon or less)
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@param epsilon? number
function M.equals_mat2_ex(a, a_index, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	return array.all_almost_equals_ex(a, a_index, 4, b, b_index, epsilon)
end

---true if the matrices are equal (differ by epsilon or less)
---@param a avm.mat3
---@param b avm.mat3
---@param epsilon? number
function M.equals_mat3(a, b, epsilon)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return array.all_almost_equals_ex(a, 1, 9, b, 1, epsilon)
end
 
---true if the matrices in a slice are equal (differ by epsilon or less)
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param epsilon? number
function M.equals_mat3_ex(a, a_index, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	return array.all_almost_equals_ex(a, a_index, 9, b, b_index, epsilon)
end

---true if the matrices are equal (differ by epsilon or less)
---@param a avm.mat4
---@param b avm.mat4
---@param epsilon? number
function M.equals_mat4(a, b, epsilon)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
	return array.all_almost_equals_ex(a, 1, 16, b, 1, epsilon)
end
 
---true if the matrices in a slice are equal (differ by epsilon or less)
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@param epsilon? number
function M.equals_mat4_ex(a, a_index, b, b_index, epsilon)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	return array.all_almost_equals_ex(a, a_index, 16, b, b_index, epsilon)
end


-----------------------------------------------------------
-- Vector length, normalisation, inner product and cross product
-----------------------------------------------------------

---2d vector length (magnitude)
---@param a1 number
---@param a2 number
---@return number
function M.length_2(a1, a2)
	return math_sqrt(M.length_squared_2(a1, a2))
end

---2d vector length (magnitude)
---@param v avm.vec2
---@return number
function M.length_vec2(v)
	_debug.check_array("v", v, 1, 2)
	return math_sqrt(M.length_squared_vec2(v))
end

---2d vector length (magnitude) in a slice
---@param v avm.seq_number2
---@param v_index integer
---@return number
function M.length_vec2_slice(v, v_index)
	_debug.check_array("v", v, v_index, 2)
	return math_sqrt(M.length_squared_vec2_slice(v, v_index))
end

---2d vector length (magnitude) squared
---@param a1 number
---@param a2 number
---@return number
function M.length_squared_2(a1, a2)
	return a1*a1 + a2*a2
end

---2d vector length (magnitude) squared
---@param v avm.vec2
---@return number
function M.length_squared_vec2(v)
	_debug.check_array("v", v, 1, 2)
	return v[1]*v[1] + v[2]*v[2]
end

---2d vector length (magnitude) squared in a slice
---@param v avm.seq_number2
---@param v_index integer
---@return number
function M.length_squared_vec2_slice(v, v_index)
	_debug.check_array("v", v, v_index, 2)
	local o = v_index - 1
	return v[1]*v[1] + v[2]*v[2]
end

---3d vector length (magnitude)
---@param a1 number
---@param a2 number
---@param a3 number
---@return number
function M.length_3(a1, a2, a3)
	return math_sqrt(M.length_squared_3(a1, a2, a3))
end

---3d vector length (magnitude)
---@param v avm.vec3
---@return number
function M.length_vec3(v)
	_debug.check_array("v", v, 1, 3)
	return math_sqrt(M.length_squared_vec3(v))
end

---3d vector length (magnitude) in a slice
---@param v avm.seq_number3
---@param v_index integer
---@return number
function M.length_vec3_slice(v, v_index)
	_debug.check_array("v", v, v_index, 3)
	return math_sqrt(M.length_squared_vec3_slice(v, v_index))
end

---3d vector length (magnitude) squared
---@param a1 number
---@param a2 number
---@param a3 number
---@return number
function M.length_squared_3(a1, a2, a3)
	return a1*a1 + a2*a2 + a3*a3
end

---3d vector length (magnitude) squared
---@param v avm.vec3
---@return number
function M.length_squared_vec3(v)
	_debug.check_array("v", v, 1, 3)
	return v[1]*v[1] + v[2]*v[2] + v[3]*v[3]
end

---3d vector length (magnitude) squared in a slice
---@param v avm.seq_number3
---@param v_index integer
---@return number
function M.length_squared_vec3_slice(v, v_index)
	_debug.check_array("v", v, v_index, 3)
	local o = v_index - 1
	return v[1]*v[1] + v[2]*v[2] + v[3]*v[3]
end

---4d vector length (magnitude)
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@return number
function M.length_4(a1, a2, a3, a4)
	return math_sqrt(M.length_squared_4(a1, a2, a3, a4))
end

---4d vector length (magnitude)
---@param v avm.vec4
---@return number
function M.length_vec4(v)
	_debug.check_array("v", v, 1, 4)
	return math_sqrt(M.length_squared_vec4(v))
end

---4d vector length (magnitude) in a slice
---@param v avm.seq_number4
---@param v_index integer
---@return number
function M.length_vec4_slice(v, v_index)
	_debug.check_array("v", v, v_index, 4)
	return math_sqrt(M.length_squared_vec4_slice(v, v_index))
end

---4d vector length (magnitude) squared
---@param a1 number
---@param a2 number
---@param a3 number
---@param a4 number
---@return number
function M.length_squared_4(a1, a2, a3, a4)
	return a1*a1 + a2*a2 + a3*a3 + a4*a4
end

---4d vector length (magnitude) squared
---@param v avm.vec4
---@return number
function M.length_squared_vec4(v)
	_debug.check_array("v", v, 1, 4)
	return v[1]*v[1] + v[2]*v[2] + v[3]*v[3] + v[4]*v[4]
end

---4d vector length (magnitude) squared in a slice
---@param v avm.seq_number4
---@param v_index integer
---@return number
function M.length_squared_vec4_slice(v, v_index)
	_debug.check_array("v", v, v_index, 4)
	local o = v_index - 1
	return v[1]*v[1] + v[2]*v[2] + v[3]*v[3] + v[4]*v[4]
end

---Normalise 2d vector
---@param v1 number
---@param v2 number
---@return number,number
function M.normalise_2(v1, v2)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	local len = M.length_2(v1, v2)
	return v1/len, v2/len
end

---Normalise 2d vector
---@param v avm.vec2
---@return number,number
function M.normalise_vec2(v)
	_debug.check_array("v", v, 1, 2)
	local len = M.length_vec2(v)
	return v[1]/len, v[2]/len
end

---Normalise 2d vector in a slice
---@param v avm.seq_number2
---@param v_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.normalise_vec2_ex(v, v_index) end

---Normalise 2d vector in a slice into a destination
---@param v avm.seq_number2
---@param v_index integer
---@param dest avm.seq_number2
---@param dest_index? integer
---@return nil
function M.normalise_vec2_ex(v, v_index, dest, dest_index)
	_debug.check_array("v", v, v_index, 2)
	local len = M.length_vec2_slice(v, v_index)
	local vo = v_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 2)
		array.set_2(dest, dest_index or 1, v[vo+1]/len, v[vo+2]/len)
	else
		return v[vo+1]/len, v[vo+2]/len
	end
end

---Normalise 3d vector
---@param v1 number
---@param v2 number
---@param v3 number
---@return number,number,number
function M.normalise_3(v1, v2, v3)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	_debug.check("v3", v3, 'number')
	local len = M.length_3(v1, v2, v3)
	return v1/len, v2/len, v3/len
end

---Normalise 3d vector
---@param v avm.vec3
---@return number,number,number
function M.normalise_vec3(v)
	_debug.check_array("v", v, 1, 3)
	local len = M.length_vec3(v)
	return v[1]/len, v[2]/len, v[3]/len
end

---Normalise 3d vector in a slice
---@param v avm.seq_number3
---@param v_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.normalise_vec3_ex(v, v_index) end

---Normalise 3d vector in a slice into a destination
---@param v avm.seq_number3
---@param v_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.normalise_vec3_ex(v, v_index, dest, dest_index)
	_debug.check_array("v", v, v_index, 3)
	local len = M.length_vec3_slice(v, v_index)
	local vo = v_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		array.set_3(dest, dest_index or 1, v[vo+1]/len, v[vo+2]/len, v[vo+3]/len)
	else
		return v[vo+1]/len, v[vo+2]/len, v[vo+3]/len
	end
end

---Normalise 4d vector
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@return number,number,number,number
function M.normalise_4(v1, v2, v3, v4)
	_debug.check("v1", v1, 'number')
	_debug.check("v2", v2, 'number')
	_debug.check("v3", v3, 'number')
	_debug.check("v4", v4, 'number')
	local len = M.length_4(v1, v2, v3, v4)
	return v1/len, v2/len, v3/len, v4/len
end

---Normalise 4d vector
---@param v avm.vec4
---@return number,number,number,number
function M.normalise_vec4(v)
	_debug.check_array("v", v, 1, 4)
	local len = M.length_vec4(v)
	return v[1]/len, v[2]/len, v[3]/len, v[4]/len
end

---Normalise 4d vector in a slice
---@param v avm.seq_number4
---@param v_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.normalise_vec4_ex(v, v_index) end

---Normalise 4d vector in a slice into a destination
---@param v avm.seq_number4
---@param v_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.normalise_vec4_ex(v, v_index, dest, dest_index)
	_debug.check_array("v", v, v_index, 4)
	local len = M.length_vec4_slice(v, v_index)
	local vo = v_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
		array.set_4(dest, dest_index or 1, v[vo+1]/len, v[vo+2]/len, v[vo+3]/len, v[vo+4]/len)
	else
		return v[vo+1]/len, v[vo+2]/len, v[vo+3]/len, v[vo+4]/len
	end
end

---Inner product of 2d vectors
---@param a1 number
---@param a2 number
---@param b1 number
---@param b2 number
---@return number
function M.inner_product_2(a1, a2, b1, b2)
	return a1*b1 + a2*b2
end

---Inner product of 3d vectors
---@param a1 number
---@param a2 number
---@param a3 number
---@param b1 number
---@param b2 number
---@param b3 number
---@return number
function M.inner_product_3(a1, a2, a3, b1, b2, b3)
	return a1*b1 + a2*b2 + a3*b3
end

---Inner product of 2d vector
---@param a avm.vec2
---@param b avm.vec2
---@return number
function M.inner_product_vec2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1]+a[2]*b[2]
end

---Inner product of 2d vector in a slice
---@param a avm.seq_number2
---@param a_index integer
---@param b avm.seq_number2
---@param b_index integer
---@return number
function M.inner_product_vec2_slice(a, a_index, b, b_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1
	local bo = b_index - 1
	return a[ao+1]*b[bo+1]+a[ao+2]*b[bo+2]
end

---Inner product of 3d vector
---@param a avm.vec3
---@param b avm.vec3
---@return number
function M.inner_product_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]
end

---Inner product of 3d vector in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number
function M.inner_product_vec3_slice(a, a_index, b, b_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	return a[ao+1]*b[bo+1]+a[ao+2]*b[bo+2]+a[ao+3]*b[bo+3]
end

---Inner product of 4d vector
---@param a avm.vec4
---@param b avm.vec4
---@return number
function M.inner_product_vec4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1]+a[2]*b[2]+a[3]*b[3]+a[4]*b[4]
end

---Inner product of 4d vector in a slice
---@param a avm.seq_number4
---@param a_index integer
---@param b avm.seq_number4
---@param b_index integer
---@return number
function M.inner_product_vec4_slice(a, a_index, b, b_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1
	local bo = b_index - 1
	return a[ao+1]*b[bo+1]+a[ao+2]*b[bo+2]+a[ao+3]*b[bo+3]+a[ao+4]*b[bo+4]
end

---Cross product of 3d vector
---@param ax number
---@param ay number
---@param az number
---@param bx number
---@param by number
---@param bz number
---@return number, number, number
function M.cross_product_tuple3(ax, ay, az, bx, by, bz)
	return ay*bz - az*by, az*bx - ax*bz, ax*by - ay*bx
end

---Cross product of 3d vector
---@param a avm.vec3
---@param b avm.vec3
---@return number,number,number
function M.cross_product_vec3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[2]*b[3] - a[3]*b[2],
		a[3]*b[1] - a[1]*b[3],
		a[1]*b[2] - a[2]*b[1]
end

---Cross product of 3d vector in a slice
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@return number, number, number
---@diagnostic disable-next-line: unused-local, missing-return
function M.cross_product_vec3_ex(a, a_index, b, b_index) end

---Cross product of 3d vector in a slice into a destination
---@param a avm.seq_number3
---@param a_index integer
---@param b avm.seq_number3
---@param b_index integer
---@param dest avm.seq_number3
---@param dest_index? integer
---@return nil
function M.cross_product_vec3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1
	local bo = b_index - 1
	local x, y, z = a[ao+2]*b[bo+3] - a[ao+3]*b[bo+2],
		a[ao+3]*b[bo+1] - a[ao+1]*b[bo+3],
		a[ao+1]*b[bo+2] - a[ao+2]*b[bo+1]
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 3)
		array.set_3(dest, dest_index or 1, x, y, z)
	else
		return x, y, z
	end
end

--------------------------------------------------------------------------------
-- Matrix operations
--------------------------------------------------------------------------------

---Transpose a 1x1 matrix and return a 1x1 matrix
---@param src avm.mat1
---@return number -- (mat1)
function M.transpose_mat1(src)
	_debug.check_array("src", src, 1, 1)
	return src[1]
end

---Transpose a 1x1 matrix and return a 1x1 matrix
---@param src avm.mat1x1
---@return number -- (mat1x1)
function M.transpose_mat1x1(src)
	_debug.check_array("src", src, 1, 1)
	return src[1]
end

---Transpose a 2x1 matrix and return a 1x2 matrix
---@param src avm.mat2x1
---@return number,number -- (mat1x2)
function M.transpose_mat2x1(src)
	_debug.check_array("src", src, 1, 2)
	return src[1], src[2]
end

---Transpose a 3x1 matrix and return a 1x3 matrix
---@param src avm.mat3x1
---@return number,number,number -- (mat1x3)
function M.transpose_mat3x1(src)
	_debug.check_array("src", src, 1, 3)
	return src[1], src[2], src[3]
end

---Transpose a 4x1 matrix and return a 1x4 matrix
---@param src avm.mat4x1
---@return number,number,number,number -- (mat1x4)
function M.transpose_mat4x1(src)
	_debug.check_array("src", src, 1, 4)
	return src[1], src[2], src[3], src[4]
end

---Transpose a 1x2 matrix and return a 2x1 matrix
---@param src avm.mat1x2
---@return number,number -- (mat2x1)
function M.transpose_mat1x2(src)
	_debug.check_array("src", src, 1, 2)
	return src[1], src[2]
end

---Transpose a 2x2 matrix and return a 2x2 matrix
---@param src avm.mat2
---@return number,number,number,number -- (mat2)
function M.transpose_mat2(src)
	_debug.check_array("src", src, 1, 4)
	return src[1], src[3], src[2], src[4]
end

---Transpose a 2x2 matrix and return a 2x2 matrix
---@param src avm.mat2x2
---@return number,number,number,number -- (mat2x2)
function M.transpose_mat2x2(src)
	_debug.check_array("src", src, 1, 4)
	return src[1], src[3], src[2], src[4]
end

---Transpose a 3x2 matrix and return a 2x3 matrix
---@param src avm.mat3x2
---@return number,number,number,number,number,number -- (mat2x3)
function M.transpose_mat3x2(src)
	_debug.check_array("src", src, 1, 6)
	return src[1], src[3], src[5], src[2], src[4], src[6]
end

---Transpose a 4x2 matrix and return a 2x4 matrix
---@param src avm.mat4x2
---@return number,number,number,number,number,number,number,number -- (mat2x4)
function M.transpose_mat4x2(src)
	_debug.check_array("src", src, 1, 8)
	return src[1], src[3], src[5], src[7], src[2], src[4], src[6], src[8]
end

---Transpose a 1x3 matrix and return a 3x1 matrix
---@param src avm.mat1x3
---@return number,number,number -- (mat3x1)
function M.transpose_mat1x3(src)
	_debug.check_array("src", src, 1, 3)
	return src[1], src[2], src[3]
end

---Transpose a 2x3 matrix and return a 3x2 matrix
---@param src avm.mat2x3
---@return number,number,number,number,number,number -- (mat3x2)
function M.transpose_mat2x3(src)
	_debug.check_array("src", src, 1, 6)
	return src[1], src[4], src[2], src[5], src[3], src[6]
end

---Transpose a 3x3 matrix and return a 3x3 matrix
---@param src avm.mat3
---@return number,number,number,number,number,number,number,number,number -- (mat3)
function M.transpose_mat3(src)
	_debug.check_array("src", src, 1, 9)
	return src[1], src[4], src[7], src[2], src[5], src[8], src[3], src[6], src[9]
end

---Transpose a 3x3 matrix and return a 3x3 matrix
---@param src avm.mat3x3
---@return number,number,number,number,number,number,number,number,number -- (mat3x3)
function M.transpose_mat3x3(src)
	_debug.check_array("src", src, 1, 9)
	return src[1], src[4], src[7], src[2], src[5], src[8], src[3], src[6], src[9]
end

---Transpose a 4x3 matrix and return a 3x4 matrix
---@param src avm.mat4x3
---@return number,number,number,number,number,number,number,number,number,number,number,number -- (mat3x4)
function M.transpose_mat4x3(src)
	_debug.check_array("src", src, 1, 12)
	return src[1], src[4], src[7], src[10], src[2], src[5], src[8], src[11], src[3], src[6], src[9], src[12]
end

---Transpose a 1x4 matrix and return a 4x1 matrix
---@param src avm.mat1x4
---@return number,number,number,number -- (mat4x1)
function M.transpose_mat1x4(src)
	_debug.check_array("src", src, 1, 4)
	return src[1], src[2], src[3], src[4]
end

---Transpose a 2x4 matrix and return a 4x2 matrix
---@param src avm.mat2x4
---@return number,number,number,number,number,number,number,number -- (mat4x2)
function M.transpose_mat2x4(src)
	_debug.check_array("src", src, 1, 8)
	return src[1], src[5], src[2], src[6], src[3], src[7], src[4], src[8]
end

---Transpose a 3x4 matrix and return a 4x3 matrix
---@param src avm.mat3x4
---@return number,number,number,number,number,number,number,number,number,number,number,number -- (mat4x3)
function M.transpose_mat3x4(src)
	_debug.check_array("src", src, 1, 12)
	return src[1], src[5], src[9], src[2], src[6], src[10], src[3], src[7], src[11], src[4], src[8], src[12]
end

---Transpose a 4x4 matrix and return a 4x4 matrix
---@param src avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number -- (mat4)
function M.transpose_mat4(src)
	_debug.check_array("src", src, 1, 16)
	return src[1], src[5], src[9], src[13], src[2], src[6], src[10], src[14], src[3], src[7], src[11], src[15], src[4], src[8], src[12], src[16]
end

---Transpose a 4x4 matrix and return a 4x4 matrix
---@param src avm.mat4x4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number -- (mat4x4)
function M.transpose_mat4x4(src)
	_debug.check_array("src", src, 1, 16)
	return src[1], src[5], src[9], src[13], src[2], src[6], src[10], src[14], src[3], src[7], src[11], src[15], src[4], src[8], src[12], src[16]
end

---Transpose a 2x2 matrix and return a 2x2 matrix
---@param src avm.seq_number4
---@param src_index integer
---@return number,number,number,number -- (mat2)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat2_ex(src, src_index) end

---Transpose a 2x2 matrix into a 2x2 matrix in a destination
---@param src avm.seq_number4
---@param src_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.transpose_mat2_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 4)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
		array.set_4(dest, dest_index or 1, src[so+1], src[so+3], src[so+2], src[so+4])
	else
		return src[so+1], src[so+3], src[so+2], src[so+4]
	end
end

---Transpose a 2x2 matrix and return a 2x2 matrix
---@param src avm.seq_number4
---@param src_index integer
---@return number,number,number,number -- (mat2x2)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat2x2_ex(src, src_index) end

---Transpose a 2x2 matrix into a 2x2 matrix in a destination
---@param src avm.seq_number4
---@param src_index integer
---@param dest avm.seq_number4
---@param dest_index? integer
---@return nil
function M.transpose_mat2x2_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 4)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 4)
		array.set_4(dest, dest_index or 1, src[so+1], src[so+3], src[so+2], src[so+4])
	else
		return src[so+1], src[so+3], src[so+2], src[so+4]
	end
end

---Transpose a 3x2 matrix and return a 2x3 matrix
---@param src avm.seq_number6
---@param src_index integer
---@return number,number,number,number,number,number -- (mat2x3)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat3x2_ex(src, src_index) end

---Transpose a 3x2 matrix into a 2x3 matrix in a destination
---@param src avm.seq_number6
---@param src_index integer
---@param dest avm.seq_number6
---@param dest_index? integer
---@return nil
function M.transpose_mat3x2_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 6)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 6)
		array.set_6(dest, dest_index or 1, src[so+1], src[so+3], src[so+5], src[so+2], src[so+4], src[so+6])
	else
		return src[so+1], src[so+3], src[so+5], src[so+2], src[so+4], src[so+6]
	end
end

---Transpose a 4x2 matrix and return a 2x4 matrix
---@param src avm.seq_number8
---@param src_index integer
---@return number,number,number,number,number,number,number,number -- (mat2x4)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat4x2_ex(src, src_index) end

---Transpose a 4x2 matrix into a 2x4 matrix in a destination
---@param src avm.seq_number8
---@param src_index integer
---@param dest avm.seq_number8
---@param dest_index? integer
---@return nil
function M.transpose_mat4x2_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 8)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 8)
		array.set_8(dest, dest_index or 1, src[so+1], src[so+3], src[so+5], src[so+7], src[so+2], src[so+4], src[so+6], src[so+8])
	else
		return src[so+1], src[so+3], src[so+5], src[so+7], src[so+2], src[so+4], src[so+6], src[so+8]
	end
end

---Transpose a 2x3 matrix and return a 3x2 matrix
---@param src avm.seq_number6
---@param src_index integer
---@return number,number,number,number,number,number -- (mat3x2)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat2x3_ex(src, src_index) end

---Transpose a 2x3 matrix into a 3x2 matrix in a destination
---@param src avm.seq_number6
---@param src_index integer
---@param dest avm.seq_number6
---@param dest_index? integer
---@return nil
function M.transpose_mat2x3_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 6)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 6)
		array.set_6(dest, dest_index or 1, src[so+1], src[so+4], src[so+2], src[so+5], src[so+3], src[so+6])
	else
		return src[so+1], src[so+4], src[so+2], src[so+5], src[so+3], src[so+6]
	end
end

---Transpose a 3x3 matrix and return a 3x3 matrix
---@param src avm.seq_number9
---@param src_index integer
---@return number,number,number,number,number,number,number,number,number -- (mat3)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat3_ex(src, src_index) end

---Transpose a 3x3 matrix into a 3x3 matrix in a destination
---@param src avm.seq_number9
---@param src_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.transpose_mat3_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 9)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
		array.set_9(dest, dest_index or 1, src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9])
	else
		return src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9]
	end
end

---Transpose a 3x3 matrix and return a 3x3 matrix
---@param src avm.seq_number9
---@param src_index integer
---@return number,number,number,number,number,number,number,number,number -- (mat3x3)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat3x3_ex(src, src_index) end

---Transpose a 3x3 matrix into a 3x3 matrix in a destination
---@param src avm.seq_number9
---@param src_index integer
---@param dest avm.seq_number9
---@param dest_index? integer
---@return nil
function M.transpose_mat3x3_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 9)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 9)
		array.set_9(dest, dest_index or 1, src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9])
	else
		return src[so+1], src[so+4], src[so+7], src[so+2], src[so+5], src[so+8], src[so+3], src[so+6], src[so+9]
	end
end

---Transpose a 4x3 matrix and return a 3x4 matrix
---@param src avm.seq_number12
---@param src_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number -- (mat3x4)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat4x3_ex(src, src_index) end

---Transpose a 4x3 matrix into a 3x4 matrix in a destination
---@param src avm.seq_number12
---@param src_index integer
---@param dest avm.seq_number12
---@param dest_index? integer
---@return nil
function M.transpose_mat4x3_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 12)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 12)
		array.set_12(dest, dest_index or 1, src[so+1], src[so+4], src[so+7], src[so+10], src[so+2], src[so+5], src[so+8], src[so+11], src[so+3], src[so+6], src[so+9], src[so+12])
	else
		return src[so+1], src[so+4], src[so+7], src[so+10], src[so+2], src[so+5], src[so+8], src[so+11], src[so+3], src[so+6], src[so+9], src[so+12]
	end
end

---Transpose a 2x4 matrix and return a 4x2 matrix
---@param src avm.seq_number8
---@param src_index integer
---@return number,number,number,number,number,number,number,number -- (mat4x2)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat2x4_ex(src, src_index) end

---Transpose a 2x4 matrix into a 4x2 matrix in a destination
---@param src avm.seq_number8
---@param src_index integer
---@param dest avm.seq_number8
---@param dest_index? integer
---@return nil
function M.transpose_mat2x4_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 8)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 8)
		array.set_8(dest, dest_index or 1, src[so+1], src[so+5], src[so+2], src[so+6], src[so+3], src[so+7], src[so+4], src[so+8])
	else
		return src[so+1], src[so+5], src[so+2], src[so+6], src[so+3], src[so+7], src[so+4], src[so+8]
	end
end

---Transpose a 3x4 matrix and return a 4x3 matrix
---@param src avm.seq_number12
---@param src_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number -- (mat4x3)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat3x4_ex(src, src_index) end

---Transpose a 3x4 matrix into a 4x3 matrix in a destination
---@param src avm.seq_number12
---@param src_index integer
---@param dest avm.seq_number12
---@param dest_index? integer
---@return nil
function M.transpose_mat3x4_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 12)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 12)
		array.set_12(dest, dest_index or 1, src[so+1], src[so+5], src[so+9], src[so+2], src[so+6], src[so+10], src[so+3], src[so+7], src[so+11], src[so+4], src[so+8], src[so+12])
	else
		return src[so+1], src[so+5], src[so+9], src[so+2], src[so+6], src[so+10], src[so+3], src[so+7], src[so+11], src[so+4], src[so+8], src[so+12]
	end
end

---Transpose a 4x4 matrix and return a 4x4 matrix
---@param src avm.seq_number16
---@param src_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number -- (mat4)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat4_ex(src, src_index) end

---Transpose a 4x4 matrix into a 4x4 matrix in a destination
---@param src avm.seq_number16
---@param src_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.transpose_mat4_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 16)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
		array.set_16(dest, dest_index or 1, src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16])
	else
		return src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16]
	end
end

---Transpose a 4x4 matrix and return a 4x4 matrix
---@param src avm.seq_number16
---@param src_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number -- (mat4x4)
---@diagnostic disable-next-line: missing-return
function M.transpose_mat4x4_ex(src, src_index) end

---Transpose a 4x4 matrix into a 4x4 matrix in a destination
---@param src avm.seq_number16
---@param src_index integer
---@param dest avm.seq_number16
---@param dest_index? integer
---@return nil
function M.transpose_mat4x4_ex(src, src_index, dest, dest_index)
	_debug.check_array("src", src, src_index, 16)
	local so = src_index - 1
	if dest then
		_debug.check_array("dest", dest, dest_index or 1, 16)
		array.set_16(dest, dest_index or 1, src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16])
	else
		return src[so+1], src[so+5], src[so+9], src[so+13], src[so+2], src[so+6], src[so+10], src[so+14], src[so+3], src[so+7], src[so+11], src[so+15], src[so+4], src[so+8], src[so+12], src[so+16]
	end
end


---Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix
---
---@param a avm.mat1x1
---@param b avm.mat1x1
---@return number
function M.matmul_mat1x1_mat1x1(a, b)
	_debug.check_array("a", a, 1, 1)
	_debug.check_array("b", b, 1, 1)
	return a[1]*b[1]
end

---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x1_mat1x1_ex(a, a_index, b, b_index) end

---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x1_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 1)
	_debug.check_array("b", b, b_index, 1)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
		dest[o+1] = a[ao+1]*b[bo+1]
	else
		return a[ao+1]*b[bo+1]
	end
end

---Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix
---
---@param a avm.mat1
---@param b avm.mat1
---@return number
function M.matmul_mat1_mat1(a, b)
	_debug.check_array("a", a, 1, 1)
	_debug.check_array("b", b, 1, 1)
	return a[1]*b[1]
end

---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1_mat1_ex(a, a_index, b, b_index) end

---Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1_mat1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 1)
	_debug.check_array("b", b, b_index, 1)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
		dest[o+1] = a[ao+1]*b[bo+1]
	else
		return a[ao+1]*b[bo+1]
	end
end

---Multiply a 1x1 matrix with a 2x1 matrix and return a 2x1 matrix
---
---@param a avm.mat1x1
---@param b avm.mat2x1
---@return number,number
function M.matmul_mat1x1_mat2x1(a, b)
	_debug.check_array("a", a, 1, 1)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1], a[1]*b[2]
end

---Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x1_mat2x1_ex(a, a_index, b, b_index) end

---Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x1_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 1)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
		dest[o+1] = a[ao+1]*b[bo+1]
		dest[o+2] = a[ao+1]*b[bo+2]
	else
		return a[ao+1]*b[bo+1], a[ao+1]*b[bo+2]
	end
end

---Multiply a 1x1 matrix with a 3x1 matrix and return a 3x1 matrix
---
---@param a avm.mat1x1
---@param b avm.mat3x1
---@return number,number,number
function M.matmul_mat1x1_mat3x1(a, b)
	_debug.check_array("a", a, 1, 1)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1], a[1]*b[2], a[1]*b[3]
end

---Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x1_mat3x1_ex(a, a_index, b, b_index) end

---Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x1_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 1)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
		dest[o+1] = a[ao+1]*b[bo+1]
		dest[o+2] = a[ao+1]*b[bo+2]
		dest[o+3] = a[ao+1]*b[bo+3]
	else
		return a[ao+1]*b[bo+1], a[ao+1]*b[bo+2], a[ao+1]*b[bo+3]
	end
end

---Multiply a 1x1 matrix with a 4x1 matrix and return a 4x1 matrix
---
---@param a avm.mat1x1
---@param b avm.mat4x1
---@return number,number,number,number
function M.matmul_mat1x1_mat4x1(a, b)
	_debug.check_array("a", a, 1, 1)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1], a[1]*b[2], a[1]*b[3], a[1]*b[4]
end

---Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x1_mat4x1_ex(a, a_index, b, b_index) end

---Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x1_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 1)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat2x1
---@param b avm.mat1x2
---@return number
function M.matmul_mat2x1_mat1x2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1] + a[2]*b[2]
end

---Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x1_mat1x2_ex(a, a_index, b, b_index) end

---Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x1_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
	else
		return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
	end
end

---Multiply a 2x1 matrix with a 2x2 matrix and return a 2x1 matrix
---
---@param a avm.mat2x1
---@param b avm.mat2x2
---@return number,number
function M.matmul_mat2x1_mat2x2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[2]*b[2], a[1]*b[3] + a[2]*b[4]
end

---Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x1_mat2x2_ex(a, a_index, b, b_index) end

---Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x1_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2]
		dest[o+2] = a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4]
	else
		return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2], a[ao+1]*b[bo+3] + a[ao+2]*b[bo+4]
	end
end

---Multiply a 2x1 matrix with a 3x2 matrix and return a 3x1 matrix
---
---@param a avm.mat2x1
---@param b avm.mat3x2
---@return number,number,number
function M.matmul_mat2x1_mat3x2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[2]*b[2], a[1]*b[3] + a[2]*b[4], a[1]*b[5] + a[2]*b[6]
end

---Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x1_mat3x2_ex(a, a_index, b, b_index) end

---Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x1_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x1
---@param b avm.mat4x2
---@return number,number,number,number
function M.matmul_mat2x1_mat4x2(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[2]*b[2], a[1]*b[3] + a[2]*b[4], a[1]*b[5] + a[2]*b[6], a[1]*b[7] + a[2]*b[8]
end

---Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x1_mat4x2_ex(a, a_index, b, b_index) end

---Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x1_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat3x1
---@param b avm.mat1x3
---@return number
function M.matmul_mat3x1_mat1x3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
end

---Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x1_mat1x3_ex(a, a_index, b, b_index) end

---Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x1_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
	else
		return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
	end
end

---Multiply a 3x1 matrix with a 2x3 matrix and return a 2x1 matrix
---
---@param a avm.mat3x1
---@param b avm.mat2x3
---@return number,number
function M.matmul_mat3x1_mat2x3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3], a[1]*b[4] + a[2]*b[5] + a[3]*b[6]
end

---Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x1_mat2x3_ex(a, a_index, b, b_index) end

---Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x1_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3]
		dest[o+2] = a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6]
	else
		return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3],
			a[ao+1]*b[bo+4] + a[ao+2]*b[bo+5] + a[ao+3]*b[bo+6]
	end
end

---Multiply a 3x1 matrix with a 3x3 matrix and return a 3x1 matrix
---
---@param a avm.mat3x1
---@param b avm.mat3x3
---@return number,number,number
function M.matmul_mat3x1_mat3x3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 9)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3], a[1]*b[4] + a[2]*b[5] + a[3]*b[6],
	a[1]*b[7] + a[2]*b[8] + a[3]*b[9]
end

---Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x1_mat3x3_ex(a, a_index, b, b_index) end

---Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x1_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x1
---@param b avm.mat4x3
---@return number,number,number,number
function M.matmul_mat3x1_mat4x3(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 12)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3], a[1]*b[4] + a[2]*b[5] + a[3]*b[6],
	a[1]*b[7] + a[2]*b[8] + a[3]*b[9], a[1]*b[10] + a[2]*b[11] + a[3]*b[12]
end

---Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x1_mat4x3_ex(a, a_index, b, b_index) end

---Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x1_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat4x1
---@param b avm.mat1x4
---@return number
function M.matmul_mat4x1_mat1x4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4]
end

---Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x1_mat1x4_ex(a, a_index, b, b_index) end

---Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x1_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
	else
		return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
	end
end

---Multiply a 4x1 matrix with a 2x4 matrix and return a 2x1 matrix
---
---@param a avm.mat4x1
---@param b avm.mat2x4
---@return number,number
function M.matmul_mat4x1_mat2x4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4],
	a[1]*b[5] + a[2]*b[6] + a[3]*b[7] + a[4]*b[8]
end

---Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x1_mat2x4_ex(a, a_index, b, b_index) end

---Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x1_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4]
		dest[o+2] = a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8]
	else
		return a[ao+1]*b[bo+1] + a[ao+2]*b[bo+2] + a[ao+3]*b[bo+3] + a[ao+4]*b[bo+4],
			a[ao+1]*b[bo+5] + a[ao+2]*b[bo+6] + a[ao+3]*b[bo+7] + a[ao+4]*b[bo+8]
	end
end

---Multiply a 4x1 matrix with a 3x4 matrix and return a 3x1 matrix
---
---@param a avm.mat4x1
---@param b avm.mat3x4
---@return number,number,number
function M.matmul_mat4x1_mat3x4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 12)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4],
	a[1]*b[5] + a[2]*b[6] + a[3]*b[7] + a[4]*b[8],
	a[1]*b[9] + a[2]*b[10] + a[3]*b[11] + a[4]*b[12]
end

---Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x1_mat3x4_ex(a, a_index, b, b_index) end

---Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x1_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x1
---@param b avm.mat4x4
---@return number,number,number,number
function M.matmul_mat4x1_mat4x4(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 16)
	return a[1]*b[1] + a[2]*b[2] + a[3]*b[3] + a[4]*b[4],
	a[1]*b[5] + a[2]*b[6] + a[3]*b[7] + a[4]*b[8],
	a[1]*b[9] + a[2]*b[10] + a[3]*b[11] + a[4]*b[12],
	a[1]*b[13] + a[2]*b[14] + a[3]*b[15] + a[4]*b[16]
end

---Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x1_mat4x4_ex(a, a_index, b, b_index) end

---Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x1_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat1x2
---@param b avm.mat1x1
---@return number,number
function M.matmul_mat1x2_mat1x1(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 1)
	return a[1]*b[1], a[2]*b[1]
end

---Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x2_mat1x1_ex(a, a_index, b, b_index) end

---Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x2_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 1)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
		dest[o+1] = a[ao+1]*b[bo+1]
		dest[o+2] = a[ao+2]*b[bo+1]
	else
		return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1]
	end
end

---Multiply a 1x2 matrix with a 2x1 matrix and return a 2x2 matrix
---
---@param a avm.mat1x2
---@param b avm.mat2x1
---@return number,number,number,number
function M.matmul_mat1x2_mat2x1(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1], a[2]*b[1], a[1]*b[2], a[2]*b[2]
end

---Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x2_mat2x1_ex(a, a_index, b, b_index) end

---Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x2_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x2
---@param b avm.mat3x1
---@return number,number,number,number,number,number
function M.matmul_mat1x2_mat3x1(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1], a[2]*b[1], a[1]*b[2], a[2]*b[2], a[1]*b[3], a[2]*b[3]
end

---Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x2_mat3x1_ex(a, a_index, b, b_index) end

---Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x2_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x2
---@param b avm.mat4x1
---@return number,number,number,number,number,number,number,number
function M.matmul_mat1x2_mat4x1(a, b)
	_debug.check_array("a", a, 1, 2)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1], a[2]*b[1], a[1]*b[2], a[2]*b[2], a[1]*b[3], a[2]*b[3], a[1]*b[4], a[2]*b[4]
end

---Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x2_mat4x1_ex(a, a_index, b, b_index) end

---Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x2_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 2)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat2x2
---@param b avm.mat1x2
---@return number,number
function M.matmul_mat2x2_mat1x2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2]
end

---Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x2_mat1x2_ex(a, a_index, b, b_index) end

---Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x2_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2]
		dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
	else
		return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2], a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2]
	end
end

---Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix
---
---@param a avm.mat2x2
---@param b avm.mat2x2
---@return number,number,number,number
function M.matmul_mat2x2_mat2x2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4], a[2]*b[3] + a[4]*b[4]
end

---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x2_mat2x2_ex(a, a_index, b, b_index) end

---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x2_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2
---@param b avm.mat2
---@return number,number,number,number
function M.matmul_mat2_mat2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4], a[2]*b[3] + a[4]*b[4]
end

---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2_mat2_ex(a, a_index, b, b_index) end

---Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2_mat2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x2
---@param b avm.mat3x2
---@return number,number,number,number,number,number
function M.matmul_mat2x2_mat3x2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4],
	a[2]*b[3] + a[4]*b[4], a[1]*b[5] + a[3]*b[6], a[2]*b[5] + a[4]*b[6]
end

---Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x2_mat3x2_ex(a, a_index, b, b_index) end

---Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x2_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x2
---@param b avm.mat4x2
---@return number,number,number,number,number,number,number,number
function M.matmul_mat2x2_mat4x2(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[3]*b[2], a[2]*b[1] + a[4]*b[2], a[1]*b[3] + a[3]*b[4],
	a[2]*b[3] + a[4]*b[4], a[1]*b[5] + a[3]*b[6], a[2]*b[5] + a[4]*b[6],
	a[1]*b[7] + a[3]*b[8], a[2]*b[7] + a[4]*b[8]
end

---Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x2_mat4x2_ex(a, a_index, b, b_index) end

---Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x2_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat3x2
---@param b avm.mat1x3
---@return number,number
function M.matmul_mat3x2_mat1x3(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3]
end

---Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x2_mat1x3_ex(a, a_index, b, b_index) end

---Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x2_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3]
		dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
	else
		return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3],
			a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3]
	end
end

---Multiply a 3x2 matrix with a 2x3 matrix and return a 2x2 matrix
---
---@param a avm.mat3x2
---@param b avm.mat2x3
---@return number,number,number,number
function M.matmul_mat3x2_mat2x3(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3],
	a[1]*b[4] + a[3]*b[5] + a[5]*b[6], a[2]*b[4] + a[4]*b[5] + a[6]*b[6]
end

---Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x2_mat2x3_ex(a, a_index, b, b_index) end

---Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x2_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x2
---@param b avm.mat3x3
---@return number,number,number,number,number,number
function M.matmul_mat3x2_mat3x3(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 9)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3],
	a[1]*b[4] + a[3]*b[5] + a[5]*b[6], a[2]*b[4] + a[4]*b[5] + a[6]*b[6],
	a[1]*b[7] + a[3]*b[8] + a[5]*b[9], a[2]*b[7] + a[4]*b[8] + a[6]*b[9]
end

---Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x2_mat3x3_ex(a, a_index, b, b_index) end

---Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x2_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x2
---@param b avm.mat4x3
---@return number,number,number,number,number,number,number,number
function M.matmul_mat3x2_mat4x3(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 12)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3], a[2]*b[1] + a[4]*b[2] + a[6]*b[3],
	a[1]*b[4] + a[3]*b[5] + a[5]*b[6], a[2]*b[4] + a[4]*b[5] + a[6]*b[6],
	a[1]*b[7] + a[3]*b[8] + a[5]*b[9], a[2]*b[7] + a[4]*b[8] + a[6]*b[9],
	a[1]*b[10] + a[3]*b[11] + a[5]*b[12], a[2]*b[10] + a[4]*b[11] + a[6]*b[12]
end

---Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x2_mat4x3_ex(a, a_index, b, b_index) end

---Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x2_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat4x2
---@param b avm.mat1x4
---@return number,number
function M.matmul_mat4x2_mat1x4(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
	a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4]
end

---Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x2_mat1x4_ex(a, a_index, b, b_index) end

---Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x2_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
		dest[o+1] = a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4]
		dest[o+2] = a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
	else
		return a[ao+1]*b[bo+1] + a[ao+3]*b[bo+2] + a[ao+5]*b[bo+3] + a[ao+7]*b[bo+4],
			a[ao+2]*b[bo+1] + a[ao+4]*b[bo+2] + a[ao+6]*b[bo+3] + a[ao+8]*b[bo+4]
	end
end

---Multiply a 4x2 matrix with a 2x4 matrix and return a 2x2 matrix
---
---@param a avm.mat4x2
---@param b avm.mat2x4
---@return number,number,number,number
function M.matmul_mat4x2_mat2x4(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
	a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4],
	a[1]*b[5] + a[3]*b[6] + a[5]*b[7] + a[7]*b[8],
	a[2]*b[5] + a[4]*b[6] + a[6]*b[7] + a[8]*b[8]
end

---Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x2_mat2x4_ex(a, a_index, b, b_index) end

---Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x2_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x2
---@param b avm.mat3x4
---@return number,number,number,number,number,number
function M.matmul_mat4x2_mat3x4(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 12)
	return a[1]*b[1] + a[3]*b[2] + a[5]*b[3] + a[7]*b[4],
	a[2]*b[1] + a[4]*b[2] + a[6]*b[3] + a[8]*b[4],
	a[1]*b[5] + a[3]*b[6] + a[5]*b[7] + a[7]*b[8],
	a[2]*b[5] + a[4]*b[6] + a[6]*b[7] + a[8]*b[8],
	a[1]*b[9] + a[3]*b[10] + a[5]*b[11] + a[7]*b[12],
	a[2]*b[9] + a[4]*b[10] + a[6]*b[11] + a[8]*b[12]
end

---Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x2_mat3x4_ex(a, a_index, b, b_index) end

---Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x2_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x2
---@param b avm.mat4x4
---@return number,number,number,number,number,number,number,number
function M.matmul_mat4x2_mat4x4(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 16)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x2_mat4x4_ex(a, a_index, b, b_index) end

---Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x2_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat1x3
---@param b avm.mat1x1
---@return number,number,number
function M.matmul_mat1x3_mat1x1(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 1)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1]
end

---Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x3_mat1x1_ex(a, a_index, b, b_index) end

---Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x3_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 1)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
		dest[o+1] = a[ao+1]*b[bo+1]
		dest[o+2] = a[ao+2]*b[bo+1]
		dest[o+3] = a[ao+3]*b[bo+1]
	else
		return a[ao+1]*b[bo+1], a[ao+2]*b[bo+1], a[ao+3]*b[bo+1]
	end
end

---Multiply a 1x3 matrix with a 2x1 matrix and return a 2x3 matrix
---
---@param a avm.mat1x3
---@param b avm.mat2x1
---@return number,number,number,number,number,number
function M.matmul_mat1x3_mat2x1(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2]
end

---Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x3_mat2x1_ex(a, a_index, b, b_index) end

---Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x3_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x3
---@param b avm.mat3x1
---@return number,number,number,number,number,number,number,number,number
function M.matmul_mat1x3_mat3x1(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[1]*b[3], a[2]*b[3], a[3]*b[3]
end

---Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x3_mat3x1_ex(a, a_index, b, b_index) end

---Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x3_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x3
---@param b avm.mat4x1
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat1x3_mat4x1(a, b)
	_debug.check_array("a", a, 1, 3)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[1]*b[3], a[2]*b[3],
	a[3]*b[3], a[1]*b[4], a[2]*b[4], a[3]*b[4]
end

---Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x3_mat4x1_ex(a, a_index, b, b_index) end

---Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x3_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 3)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat2x3
---@param b avm.mat1x2
---@return number,number,number
function M.matmul_mat2x3_mat1x2(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2]
end

---Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x3_mat1x2_ex(a, a_index, b, b_index) end

---Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x3_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x3
---@param b avm.mat2x2
---@return number,number,number,number,number,number
function M.matmul_mat2x3_mat2x2(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2],
	a[1]*b[3] + a[4]*b[4], a[2]*b[3] + a[5]*b[4], a[3]*b[3] + a[6]*b[4]
end

---Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x3_mat2x2_ex(a, a_index, b, b_index) end

---Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x3_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x3
---@param b avm.mat3x2
---@return number,number,number,number,number,number,number,number,number
function M.matmul_mat2x3_mat3x2(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2],
	a[1]*b[3] + a[4]*b[4], a[2]*b[3] + a[5]*b[4], a[3]*b[3] + a[6]*b[4],
	a[1]*b[5] + a[4]*b[6], a[2]*b[5] + a[5]*b[6], a[3]*b[5] + a[6]*b[6]
end

---Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x3_mat3x2_ex(a, a_index, b, b_index) end

---Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x3_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x3
---@param b avm.mat4x2
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat2x3_mat4x2(a, b)
	_debug.check_array("a", a, 1, 6)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[4]*b[2], a[2]*b[1] + a[5]*b[2], a[3]*b[1] + a[6]*b[2],
	a[1]*b[3] + a[4]*b[4], a[2]*b[3] + a[5]*b[4], a[3]*b[3] + a[6]*b[4],
	a[1]*b[5] + a[4]*b[6], a[2]*b[5] + a[5]*b[6], a[3]*b[5] + a[6]*b[6],
	a[1]*b[7] + a[4]*b[8], a[2]*b[7] + a[5]*b[8], a[3]*b[7] + a[6]*b[8]
end

---Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x3_mat4x2_ex(a, a_index, b, b_index) end

---Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x3_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 6)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat3x3
---@param b avm.mat1x3
---@return number,number,number
function M.matmul_mat3x3_mat1x3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3]
end

---Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x3_mat1x3_ex(a, a_index, b, b_index) end

---Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x3_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x3
---@param b avm.mat2x3
---@return number,number,number,number,number,number
function M.matmul_mat3x3_mat2x3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
	a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6]
end

---Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x3_mat2x3_ex(a, a_index, b, b_index) end

---Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x3_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x3
---@param b avm.mat3x3
---@return number,number,number,number,number,number,number,number,number
function M.matmul_mat3x3_mat3x3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
	a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6],
	a[1]*b[7] + a[4]*b[8] + a[7]*b[9], a[2]*b[7] + a[5]*b[8] + a[8]*b[9],
	a[3]*b[7] + a[6]*b[8] + a[9]*b[9]
end

---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x3_mat3x3_ex(a, a_index, b, b_index) end

---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x3_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3
---@param b avm.mat3
---@return number,number,number,number,number,number,number,number,number
function M.matmul_mat3_mat3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 9)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
	a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6],
	a[1]*b[7] + a[4]*b[8] + a[7]*b[9], a[2]*b[7] + a[5]*b[8] + a[8]*b[9],
	a[3]*b[7] + a[6]*b[8] + a[9]*b[9]
end

---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3_mat3_ex(a, a_index, b, b_index) end

---Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3_mat3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x3
---@param b avm.mat4x3
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat3x3_mat4x3(a, b)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("b", b, 1, 12)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3], a[2]*b[1] + a[5]*b[2] + a[8]*b[3],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3], a[1]*b[4] + a[4]*b[5] + a[7]*b[6],
	a[2]*b[4] + a[5]*b[5] + a[8]*b[6], a[3]*b[4] + a[6]*b[5] + a[9]*b[6],
	a[1]*b[7] + a[4]*b[8] + a[7]*b[9], a[2]*b[7] + a[5]*b[8] + a[8]*b[9],
	a[3]*b[7] + a[6]*b[8] + a[9]*b[9], a[1]*b[10] + a[4]*b[11] + a[7]*b[12],
	a[2]*b[10] + a[5]*b[11] + a[8]*b[12], a[3]*b[10] + a[6]*b[11] + a[9]*b[12]
end

---Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x3_mat4x3_ex(a, a_index, b, b_index) end

---Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x3_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat4x3
---@param b avm.mat1x4
---@return number,number,number
function M.matmul_mat4x3_mat1x4(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3] + a[10]*b[4],
	a[2]*b[1] + a[5]*b[2] + a[8]*b[3] + a[11]*b[4],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3] + a[12]*b[4]
end

---Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x3_mat1x4_ex(a, a_index, b, b_index) end

---Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x3_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x3
---@param b avm.mat2x4
---@return number,number,number,number,number,number
function M.matmul_mat4x3_mat2x4(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[4]*b[2] + a[7]*b[3] + a[10]*b[4],
	a[2]*b[1] + a[5]*b[2] + a[8]*b[3] + a[11]*b[4],
	a[3]*b[1] + a[6]*b[2] + a[9]*b[3] + a[12]*b[4],
	a[1]*b[5] + a[4]*b[6] + a[7]*b[7] + a[10]*b[8],
	a[2]*b[5] + a[5]*b[6] + a[8]*b[7] + a[11]*b[8],
	a[3]*b[5] + a[6]*b[6] + a[9]*b[7] + a[12]*b[8]
end

---Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x3_mat2x4_ex(a, a_index, b, b_index) end

---Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x3_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x3
---@param b avm.mat3x4
---@return number,number,number,number,number,number,number,number,number
function M.matmul_mat4x3_mat3x4(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 12)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x3_mat3x4_ex(a, a_index, b, b_index) end

---Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x3_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x3
---@param b avm.mat4x4
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat4x3_mat4x4(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 16)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x3_mat4x4_ex(a, a_index, b, b_index) end

---Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x3_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat1x4
---@param b avm.mat1x1
---@return number,number,number,number
function M.matmul_mat1x4_mat1x1(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 1)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1]
end

---Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x4_mat1x1_ex(a, a_index, b, b_index) end

---Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x4_mat1x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 1)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x4
---@param b avm.mat2x1
---@return number,number,number,number,number,number,number,number
function M.matmul_mat1x4_mat2x1(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[4]*b[2]
end

---Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x4_mat2x1_ex(a, a_index, b, b_index) end

---Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x4_mat2x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x4
---@param b avm.mat3x1
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat1x4_mat3x1(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[4]*b[2],
	a[1]*b[3], a[2]*b[3], a[3]*b[3], a[4]*b[3]
end

---Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x4_mat3x1_ex(a, a_index, b, b_index) end

---Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x4_mat3x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat1x4
---@param b avm.mat4x1
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat1x4_mat4x1(a, b)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1], a[2]*b[1], a[3]*b[1], a[4]*b[1], a[1]*b[2], a[2]*b[2], a[3]*b[2], a[4]*b[2],
	a[1]*b[3], a[2]*b[3], a[3]*b[3], a[4]*b[3], a[1]*b[4], a[2]*b[4], a[3]*b[4], a[4]*b[4]
end

---Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat1x4_mat4x1_ex(a, a_index, b, b_index) end

---Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat1x4_mat4x1_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 1)
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
---@param a avm.mat2x4
---@param b avm.mat1x2
---@return number,number,number,number
function M.matmul_mat2x4_mat1x2(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 2)
	return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2], a[4]*b[1] + a[8]*b[2]
end

---Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x4_mat1x2_ex(a, a_index, b, b_index) end

---Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x4_mat1x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 2)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x4
---@param b avm.mat2x2
---@return number,number,number,number,number,number,number,number
function M.matmul_mat2x4_mat2x2(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2],
	a[4]*b[1] + a[8]*b[2], a[1]*b[3] + a[5]*b[4], a[2]*b[3] + a[6]*b[4],
	a[3]*b[3] + a[7]*b[4], a[4]*b[3] + a[8]*b[4]
end

---Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x4_mat2x2_ex(a, a_index, b, b_index) end

---Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x4_mat2x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x4
---@param b avm.mat3x2
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat2x4_mat3x2(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2],
	a[4]*b[1] + a[8]*b[2], a[1]*b[3] + a[5]*b[4], a[2]*b[3] + a[6]*b[4],
	a[3]*b[3] + a[7]*b[4], a[4]*b[3] + a[8]*b[4], a[1]*b[5] + a[5]*b[6],
	a[2]*b[5] + a[6]*b[6], a[3]*b[5] + a[7]*b[6], a[4]*b[5] + a[8]*b[6]
end

---Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x4_mat3x2_ex(a, a_index, b, b_index) end

---Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x4_mat3x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat2x4
---@param b avm.mat4x2
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat2x4_mat4x2(a, b)
	_debug.check_array("a", a, 1, 8)
	_debug.check_array("b", b, 1, 8)
	return a[1]*b[1] + a[5]*b[2], a[2]*b[1] + a[6]*b[2], a[3]*b[1] + a[7]*b[2],
	a[4]*b[1] + a[8]*b[2], a[1]*b[3] + a[5]*b[4], a[2]*b[3] + a[6]*b[4],
	a[3]*b[3] + a[7]*b[4], a[4]*b[3] + a[8]*b[4], a[1]*b[5] + a[5]*b[6],
	a[2]*b[5] + a[6]*b[6], a[3]*b[5] + a[7]*b[6], a[4]*b[5] + a[8]*b[6],
	a[1]*b[7] + a[5]*b[8], a[2]*b[7] + a[6]*b[8], a[3]*b[7] + a[7]*b[8], a[4]*b[7] + a[8]*b[8]
end

---Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2x4_mat4x2_ex(a, a_index, b, b_index) end

---Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat2x4_mat4x2_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 8)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 4)
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
---@param a avm.mat3x4
---@param b avm.mat1x3
---@return number,number,number,number
function M.matmul_mat3x4_mat1x3(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 3)
	return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
	a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3]
end

---Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x4_mat1x3_ex(a, a_index, b, b_index) end

---Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x4_mat1x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 3)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x4
---@param b avm.mat2x3
---@return number,number,number,number,number,number,number,number
function M.matmul_mat3x4_mat2x3(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 6)
	return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
	a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3],
	a[1]*b[4] + a[5]*b[5] + a[9]*b[6], a[2]*b[4] + a[6]*b[5] + a[10]*b[6],
	a[3]*b[4] + a[7]*b[5] + a[11]*b[6], a[4]*b[4] + a[8]*b[5] + a[12]*b[6]
end

---Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x4_mat2x3_ex(a, a_index, b, b_index) end

---Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x4_mat2x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 6)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x4
---@param b avm.mat3x3
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat3x4_mat3x3(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 9)
	return a[1]*b[1] + a[5]*b[2] + a[9]*b[3], a[2]*b[1] + a[6]*b[2] + a[10]*b[3],
	a[3]*b[1] + a[7]*b[2] + a[11]*b[3], a[4]*b[1] + a[8]*b[2] + a[12]*b[3],
	a[1]*b[4] + a[5]*b[5] + a[9]*b[6], a[2]*b[4] + a[6]*b[5] + a[10]*b[6],
	a[3]*b[4] + a[7]*b[5] + a[11]*b[6], a[4]*b[4] + a[8]*b[5] + a[12]*b[6],
	a[1]*b[7] + a[5]*b[8] + a[9]*b[9], a[2]*b[7] + a[6]*b[8] + a[10]*b[9],
	a[3]*b[7] + a[7]*b[8] + a[11]*b[9], a[4]*b[7] + a[8]*b[8] + a[12]*b[9]
end

---Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x4_mat3x3_ex(a, a_index, b, b_index) end

---Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x4_mat3x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 9)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat3x4
---@param b avm.mat4x3
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat3x4_mat4x3(a, b)
	_debug.check_array("a", a, 1, 12)
	_debug.check_array("b", b, 1, 12)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3x4_mat4x3_ex(a, a_index, b, b_index) end

---Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat3x4_mat4x3_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 12)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 9)
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
---@param a avm.mat4x4
---@param b avm.mat1x4
---@return number,number,number,number
function M.matmul_mat4x4_mat1x4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 4)
	return a[1]*b[1] + a[5]*b[2] + a[9]*b[3] + a[13]*b[4],
	a[2]*b[1] + a[6]*b[2] + a[10]*b[3] + a[14]*b[4],
	a[3]*b[1] + a[7]*b[2] + a[11]*b[3] + a[15]*b[4],
	a[4]*b[1] + a[8]*b[2] + a[12]*b[3] + a[16]*b[4]
end

---Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x4_mat1x4_ex(a, a_index, b, b_index) end

---Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x4_mat1x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 4)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x4
---@param b avm.mat2x4
---@return number,number,number,number,number,number,number,number
function M.matmul_mat4x4_mat2x4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 8)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x4_mat2x4_ex(a, a_index, b, b_index) end

---Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x4_mat2x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 8)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x4
---@param b avm.mat3x4
---@return number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat4x4_mat3x4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 12)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x4_mat3x4_ex(a, a_index, b, b_index) end

---Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x4_mat3x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 12)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4x4
---@param b avm.mat4x4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat4x4_mat4x4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4x4_mat4x4_ex(a, a_index, b, b_index) end

---Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4x4_mat4x4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat4
---@param b avm.mat4
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function M.matmul_mat4_mat4(a, b)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("b", b, 1, 16)
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
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4_mat4_ex(a, a_index, b, b_index) end

---Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination
---
---NOTE: `dest` cannot overlap `a` or `b` or results will be undefined
---
---@param a avm.seq_number
---@param a_index integer
---@param b avm.seq_number
---@param b_index integer
---@param dest avm.seq_number
---@param dest_index? integer
---@return nil
function M.matmul_mat4_mat4_ex(a, a_index, b, b_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("b", b, b_index, 16)
	local ao = a_index - 1 -- index offset into a
	local bo = b_index - 1 -- index offset into b
	if dest then
		local o = dest_index and (dest_index - 1) or 0 -- index offset into dest
		_debug.check_array("dest", dest, o+1, 16)
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
---@param a avm.mat2
---@param v avm.vec2
---@return number,number
function M.matmul_mat2_vec2(a, v)
	_debug.check_array("a", a, 1, 4)
	_debug.check_array("v", v, 1, 2)
	local e1 = a[1]*v[1] + a[3]*v[2]
	local e2 = a[2]*v[1] + a[4]*v[2]
	return e1, e2
end

---Multiply a 2x2 matrix in a slice and a 2d vector in a slice and return a 2d vector
---
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat2_vec2_ex(a, a_index, v, v_index) end

---Multiply a 2x2 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination
---
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@param dest avm.seq_number
---@param dest_index? integer
function M.matmul_mat2_vec2_ex(a, a_index, v, v_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 4)
	_debug.check_array("v", v, v_index, 2)
	local ao = a_index - 1
	local vo = v_index - 1
	local e1 = a[ao+1]*v[vo+1] + a[ao+3]*v[vo+2]
	local e2 = a[ao+2]*v[vo+1] + a[ao+4]*v[vo+2]
	if dest then
		_debug.check_array("dest", dest)
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
---@param a avm.mat3
---@param v avm.vec2
---@return number,number
function M.matmul_mat3_vec2(a, v)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("v", v, 1, 2)
	local e1 = a[1]*v[1] + a[4]*v[2] + a[7]
	local e2 = a[2]*v[1] + a[5]*v[2] + a[8]
	return e1, e2
end

---Multiply a 3x3 matrix in a slice and a 2d vector in a slice and return a 2d vector
---
---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3_vec2_ex(a, a_index, v, v_index) end

---Multiply a 3x3 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination
---
---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@param dest avm.seq_number
---@param dest_index? integer
function M.matmul_mat3_vec2_ex(a, a_index, v, v_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("v", v, v_index, 2)
	local ao = a_index - 1
	local vo = v_index - 1
	local e1 = a[ao+1]*v[vo+1] + a[ao+4]*v[vo+2] + a[ao+7]
	local e2 = a[ao+2]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+8]
	if dest then
		_debug.check_array("dest", dest)
		local o = dest_index and (dest_index - 1) or 0
		dest[o + 1] = e1
		dest[o + 2] = e2
	else
		return e1, e2
	end
end

---Multiply a 3x3 matrix and a 3d vector and return a 3d vector
---
---@param a avm.mat3
---@param v avm.vec3
---@return number,number,number
function M.matmul_mat3_vec3(a, v)
	_debug.check_array("a", a, 1, 9)
	_debug.check_array("v", v, 1, 3)
	local e1 = a[1]*v[1] + a[4]*v[2] + a[7]*v[3]
	local e2 = a[2]*v[1] + a[5]*v[2] + a[8]*v[3]
	local e3 = a[3]*v[1] + a[6]*v[2] + a[9]*v[3]
	return e1, e2, e3
end

---Multiply a 3x3 matrix in a slice and a 3d vector in a slice and return a 3d vector
---
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat3_vec3_ex(a, a_index, v, v_index) end

---Multiply a 3x3 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination
---
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@param dest avm.seq_number
---@param dest_index? integer
function M.matmul_mat3_vec3_ex(a, a_index, v, v_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 9)
	_debug.check_array("v", v, v_index, 3)
	local ao = a_index - 1
	local vo = v_index - 1
	local e1 = a[ao+1]*v[vo+1] + a[ao+4]*v[vo+2] + a[ao+7]*v[vo+3]
	local e2 = a[ao+2]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+8]*v[vo+3]
	local e3 = a[ao+3]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+9]*v[vo+3]
	if dest then
		_debug.check_array("dest", dest)
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
---@param a avm.mat4
---@param v avm.vec2
---@return number,number
function M.matmul_mat4_vec2(a, v)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("v", v, 1, 2)
	local e1 = a[1]*v[1] + a[5]*v[2] + a[9] + a[13]
	local e2 = a[2]*v[1] + a[6]*v[2] + a[10] + a[14]
	return e1, e2
end

---Multiply a 4x4 matrix in a slice and a 2d vector in a slice and return a 2d vector
---
---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@return number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4_vec2_ex(a, a_index, v, v_index) end

---Multiply a 4x4 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination
---
---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@param dest avm.seq_number
---@param dest_index? integer
function M.matmul_mat4_vec2_ex(a, a_index, v, v_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("v", v, v_index, 2)
	local ao = a_index - 1
	local vo = v_index - 1
	local e1 = a[ao+1]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+9] + a[ao+13]
	local e2 = a[ao+2]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+10] + a[ao+14]
	if dest then
		_debug.check_array("dest", dest)
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
---@param a avm.mat4
---@param v avm.vec3
---@return number,number,number
function M.matmul_mat4_vec3(a, v)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("v", v, 1, 3)
	local e1 = a[1]*v[1] + a[5]*v[2] + a[9]*v[3] + a[13]
	local e2 = a[2]*v[1] + a[6]*v[2] + a[10]*v[3] + a[14]
	local e3 = a[3]*v[1] + a[7]*v[2] + a[11]*v[3] + a[15]
	return e1, e2, e3
end

---Multiply a 4x4 matrix in a slice and a 3d vector in a slice and return a 3d vector
---
---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@return number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4_vec3_ex(a, a_index, v, v_index) end

---Multiply a 4x4 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination
---
---Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@param dest avm.seq_number
---@param dest_index? integer
function M.matmul_mat4_vec3_ex(a, a_index, v, v_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("v", v, v_index, 3)
	local ao = a_index - 1
	local vo = v_index - 1
	local e1 = a[ao+1]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+9]*v[vo+3] + a[ao+13]
	local e2 = a[ao+2]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+10]*v[vo+3] + a[ao+14]
	local e3 = a[ao+3]*v[vo+1] + a[ao+7]*v[vo+2] + a[ao+11]*v[vo+3] + a[ao+15]
	if dest then
		_debug.check_array("dest", dest)
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
---@param a avm.mat4
---@param v avm.vec4
---@return number,number,number,number
function M.matmul_mat4_vec4(a, v)
	_debug.check_array("a", a, 1, 16)
	_debug.check_array("v", v, 1, 4)
	local e1 = a[1]*v[1] + a[5]*v[2] + a[9]*v[3] + a[13]*v[4]
	local e2 = a[2]*v[1] + a[6]*v[2] + a[10]*v[3] + a[14]*v[4]
	local e3 = a[3]*v[1] + a[7]*v[2] + a[11]*v[3] + a[15]*v[4]
	local e4 = a[4]*v[1] + a[8]*v[2] + a[12]*v[3] + a[16]*v[4]
	return e1, e2, e3, e4
end

---Multiply a 4x4 matrix in a slice and a 4d vector in a slice and return a 4d vector
---
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@return number,number,number,number
---@diagnostic disable-next-line: unused-local, missing-return
function M.matmul_mat4_vec4_ex(a, a_index, v, v_index) end

---Multiply a 4x4 matrix in a slice and a 4d vector in an array or slice into a 4d vector in a destination
---
---@param a avm.seq_number
---@param a_index integer
---@param v avm.seq_number
---@param v_index integer
---@param dest avm.seq_number
---@param dest_index? integer
function M.matmul_mat4_vec4_ex(a, a_index, v, v_index, dest, dest_index)
	_debug.check_array("a", a, a_index, 16)
	_debug.check_array("v", v, v_index, 4)
	local ao = a_index - 1
	local vo = v_index - 1
	local e1 = a[ao+1]*v[vo+1] + a[ao+5]*v[vo+2] + a[ao+9]*v[vo+3] + a[ao+13]*v[vo+4]
	local e2 = a[ao+2]*v[vo+1] + a[ao+6]*v[vo+2] + a[ao+10]*v[vo+3] + a[ao+14]*v[vo+4]
	local e3 = a[ao+3]*v[vo+1] + a[ao+7]*v[vo+2] + a[ao+11]*v[vo+3] + a[ao+15]*v[vo+4]
	local e4 = a[ao+4]*v[vo+1] + a[ao+8]*v[vo+2] + a[ao+12]*v[vo+3] + a[ao+16]*v[vo+4]
	if dest then
		_debug.check_array("dest", dest)
		local o = dest_index and (dest_index - 1) or 0
		dest[o + 1] = e1
		dest[o + 2] = e2
		dest[o + 3] = e3
		dest[o + 4] = e4
	else
		return e1, e2, e3, e4
	end
end



return M
