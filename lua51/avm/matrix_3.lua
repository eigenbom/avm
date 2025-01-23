
--[[
Matrix operations and types  

Classes and functions for working with matrices  


]]
---@class matrix_3_module
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
local avm_path = (...):match("(.-)[^%.]+$")
---@module 'avm._debug'
local _debug = require(avm_path .. "_debug")
---@module 'avm.array'
local array = require(avm_path .. "array")
---@module 'avm.linalg'
local linalg = require(avm_path .. "linalg")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field


---3x3 matrix in column-major order constructed from a tuple
---
---@class avm.matrix_3: avm.number9
---@operator add(avm.number9|number): avm.matrix_3
---@operator sub(avm.number9|number): avm.matrix_3
---@operator mul(avm.number9|number): avm.matrix_3
---@operator div(avm.number9|number): avm.matrix_3
---@operator unm():avm.matrix_3
---@field n 9
local matrix_3 = {}

---A 3x3 matrix in column-major order that views into an array or slice
---
---@class avm.matrix_3_slice: avm.number9
---@operator add(avm.number9|number): avm.matrix_3
---@operator sub(avm.number9|number): avm.matrix_3
---@operator mul(avm.number9|number): avm.matrix_3
---@operator div(avm.number9|number): avm.matrix_3
---@operator unm():avm.matrix_3_slice
---@field n 9
---@field private _src avm.seq_number9
---@field private _o integer
local matrix_3_slice = {}


-----------------------------------------------------------
-- Matrix creation
-----------------------------------------------------------

---Create a new matrix_3
---Parameter `e_ij` determines the value of `i'th` column `j'th` row
---@param e_11 number
---@param e_12 number
---@param e_13 number
---@param e_21 number
---@param e_22 number
---@param e_23 number
---@param e_31 number
---@param e_32 number
---@param e_33 number
---@return avm.matrix_3
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

function matrix_3:__index(key)
	if key == 'n' then
		return 9
	else
		return matrix_3[key]
	end
end

function matrix_3:__tostring()
	return string.format("%f, %f, %f, %f, %f, %f, %f, %f, %f", self:get())
end

function matrix_3:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number9
---@param dest_index? integer
function matrix_3:copy_into(dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_9(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number,number,number,number,number,number,number
function matrix_3:get()
	return self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9]
end

---Set values from a tuple
---
---Parameter `e_ij` determines the value of `i'th` column `j'th` row
---@param e_11 number
---@param e_12 number
---@param e_13 number
---@param e_21 number
---@param e_22 number
---@param e_23 number
---@param e_31 number
---@param e_32 number
---@param e_33 number
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
---@param m avm.number9|number
---@return avm.matrix_3
function matrix_3:add(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9])
	else
		---@cast m number
		return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m)
	end
	
end

---Apply addition element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@param dest avm.seq_number9
---@param dest_index? integer
function matrix_3:add_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_9(dest, dest_index or 1, self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9])
	else
		---@cast m number
		array.set_9(dest, dest_index or 1, self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m)
	end
end

---Apply subtraction element-wise and return a new matrix_3
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@return avm.matrix_3
function matrix_3:sub(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9])
	else
		---@cast m number
		return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m)
	end
	
end

---Apply subtraction element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@param dest avm.seq_number9
---@param dest_index? integer
function matrix_3:sub_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_9(dest, dest_index or 1, self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9])
	else
		---@cast m number
		array.set_9(dest, dest_index or 1, self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m)
	end
end

---Apply multiplication element-wise and return a new matrix_3
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@return avm.matrix_3
function matrix_3:mul(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9])
	else
		---@cast m number
		return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m)
	end
	
end

---Apply multiplication element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@param dest avm.seq_number9
---@param dest_index? integer
function matrix_3:mul_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_9(dest, dest_index or 1, self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9])
	else
		---@cast m number
		array.set_9(dest, dest_index or 1, self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m)
	end
end

---Apply division element-wise and return a new matrix_3
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@return avm.matrix_3
function matrix_3:div(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9])
	else
		---@cast m number
		return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m,self[5]/m,self[6]/m,self[7]/m,self[8]/m,self[9]/m)
	end
	
end

---Apply division element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number9|number
---@param dest avm.seq_number9
---@param dest_index? integer
function matrix_3:div_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number9
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_9(dest, dest_index or 1, self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9])
	else
		---@cast m number
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
---@param m avm.number9
---@return avm.matrix_3
function matrix_3:matmul(m)
	assert(m, "bad argument 'm' (expected array or sequence, got nil)")
	return M.new(linalg.matmul_mat3_mat3(self, m))
end

---Multiply with a matrix and store the result in a destination
---
---@param m avm.number9
---@param dest avm.seq_number9
---@param dest_index? integer
function matrix_3:matmul_into(m, dest, dest_index)
	assert(m, "bad argument 'm' (expected array or sequence, got nil)")
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_9(dest, dest_index or 1, linalg.matmul_mat3_mat3(self, m))
end



return M