
--[[
Matrix operations and types  

Classes and functions for working with matrices  


]]
---@class matrix_4_module
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
---@diagnostic disable-next-line: unused-local
local avm_path = (...):match("(.-)[^%.]+$")

---@module 'avm.array'
local array = require(avm_path .. "array")
---@module 'avm.linalg'
local linalg = require(avm_path .. "linalg")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field


---4x4 matrix in column-major order constructed from a tuple
---
---@class avm.matrix_4: avm.number16
---@operator add(avm.number16|number): avm.matrix_4
---@operator sub(avm.number16|number): avm.matrix_4
---@operator mul(avm.number16|number): avm.matrix_4
---@operator div(avm.number16|number): avm.matrix_4
---@operator unm():avm.matrix_4
local matrix_4 = {}

---A 4x4 matrix in column-major order that views into an array or slice
---
---@class avm.matrix_4_slice: avm.number16
---@operator add(avm.number16|number): avm.matrix_4
---@operator sub(avm.number16|number): avm.matrix_4
---@operator mul(avm.number16|number): avm.matrix_4
---@operator div(avm.number16|number): avm.matrix_4
---@operator unm():avm.matrix_4_slice
---@field private _src avm.seq_number16
---@field private _o integer
local matrix_4_slice = {}


-----------------------------------------------------------
-- Matrix creation
-----------------------------------------------------------

---Create a new matrix_4
---Parameter `e_ij` determines the value of `i'th` column `j'th` row
---@param e_11 number
---@param e_12 number
---@param e_13 number
---@param e_14 number
---@param e_21 number
---@param e_22 number
---@param e_23 number
---@param e_24 number
---@param e_31 number
---@param e_32 number
---@param e_33 number
---@param e_34 number
---@param e_41 number
---@param e_42 number
---@param e_43 number
---@param e_44 number
---@return avm.matrix_4
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
	return string.format("%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f", self:get())
end

function matrix_4:copy()
	return M.new(self:get())
end

---@param dest avm.seq_number16
---@param dest_index? integer
function matrix_4:copy_into(dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_16(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number
function matrix_4:get()
	return self[1], self[2], self[3], self[4], self[5], self[6], self[7], self[8], self[9], self[10], self[11], self[12], self[13], self[14], self[15], self[16]
end

---Set values from a tuple
---
---Parameter `e_ij` determines the value of `i'th` column `j'th` row
---@param e_11 number
---@param e_12 number
---@param e_13 number
---@param e_14 number
---@param e_21 number
---@param e_22 number
---@param e_23 number
---@param e_24 number
---@param e_31 number
---@param e_32 number
---@param e_33 number
---@param e_34 number
---@param e_41 number
---@param e_42 number
---@param e_43 number
---@param e_44 number
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
---@param m avm.number16|number
---@return avm.matrix_4
function matrix_4:add(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9],self[10]+m[10],self[11]+m[11],self[12]+m[12],self[13]+m[13],self[14]+m[14],self[15]+m[15],self[16]+m[16])
	else
		---@cast m number
		return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m,self[10]+m,self[11]+m,self[12]+m,self[13]+m,self[14]+m,self[15]+m,self[16]+m)
	end
	
end

---Apply addition element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@param dest avm.seq_number16
---@param dest_index? integer
function matrix_4:add_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_16(dest, dest_index or 1, self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4],self[5]+m[5],self[6]+m[6],self[7]+m[7],self[8]+m[8],self[9]+m[9],self[10]+m[10],self[11]+m[11],self[12]+m[12],self[13]+m[13],self[14]+m[14],self[15]+m[15],self[16]+m[16])
	else
		---@cast m number
		array.set_16(dest, dest_index or 1, self[1]+m,self[2]+m,self[3]+m,self[4]+m,self[5]+m,self[6]+m,self[7]+m,self[8]+m,self[9]+m,self[10]+m,self[11]+m,self[12]+m,self[13]+m,self[14]+m,self[15]+m,self[16]+m)
	end
end

---Apply subtraction element-wise and return a new matrix_4
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@return avm.matrix_4
function matrix_4:sub(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9],self[10]-m[10],self[11]-m[11],self[12]-m[12],self[13]-m[13],self[14]-m[14],self[15]-m[15],self[16]-m[16])
	else
		---@cast m number
		return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m,self[10]-m,self[11]-m,self[12]-m,self[13]-m,self[14]-m,self[15]-m,self[16]-m)
	end
	
end

---Apply subtraction element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@param dest avm.seq_number16
---@param dest_index? integer
function matrix_4:sub_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_16(dest, dest_index or 1, self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4],self[5]-m[5],self[6]-m[6],self[7]-m[7],self[8]-m[8],self[9]-m[9],self[10]-m[10],self[11]-m[11],self[12]-m[12],self[13]-m[13],self[14]-m[14],self[15]-m[15],self[16]-m[16])
	else
		---@cast m number
		array.set_16(dest, dest_index or 1, self[1]-m,self[2]-m,self[3]-m,self[4]-m,self[5]-m,self[6]-m,self[7]-m,self[8]-m,self[9]-m,self[10]-m,self[11]-m,self[12]-m,self[13]-m,self[14]-m,self[15]-m,self[16]-m)
	end
end

---Apply multiplication element-wise and return a new matrix_4
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@return avm.matrix_4
function matrix_4:mul(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9],self[10]*m[10],self[11]*m[11],self[12]*m[12],self[13]*m[13],self[14]*m[14],self[15]*m[15],self[16]*m[16])
	else
		---@cast m number
		return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m,self[10]*m,self[11]*m,self[12]*m,self[13]*m,self[14]*m,self[15]*m,self[16]*m)
	end
	
end

---Apply multiplication element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@param dest avm.seq_number16
---@param dest_index? integer
function matrix_4:mul_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_16(dest, dest_index or 1, self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4],self[5]*m[5],self[6]*m[6],self[7]*m[7],self[8]*m[8],self[9]*m[9],self[10]*m[10],self[11]*m[11],self[12]*m[12],self[13]*m[13],self[14]*m[14],self[15]*m[15],self[16]*m[16])
	else
		---@cast m number
		array.set_16(dest, dest_index or 1, self[1]*m,self[2]*m,self[3]*m,self[4]*m,self[5]*m,self[6]*m,self[7]*m,self[8]*m,self[9]*m,self[10]*m,self[11]*m,self[12]*m,self[13]*m,self[14]*m,self[15]*m,self[16]*m)
	end
end

---Apply division element-wise and return a new matrix_4
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@return avm.matrix_4
function matrix_4:div(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9],self[10]/m[10],self[11]/m[11],self[12]/m[12],self[13]/m[13],self[14]/m[14],self[15]/m[15],self[16]/m[16])
	else
		---@cast m number
		return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m,self[5]/m,self[6]/m,self[7]/m,self[8]/m,self[9]/m,self[10]/m,self[11]/m,self[12]/m,self[13]/m,self[14]/m,self[15]/m,self[16]/m)
	end
	
end

---Apply division element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number16|number
---@param dest avm.seq_number16
---@param dest_index? integer
function matrix_4:div_into(m, dest, dest_index)
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number16
		assert(m, "bad argument 'm' (expected array or sequence, got nil)")
		array.set_16(dest, dest_index or 1, self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4],self[5]/m[5],self[6]/m[6],self[7]/m[7],self[8]/m[8],self[9]/m[9],self[10]/m[10],self[11]/m[11],self[12]/m[12],self[13]/m[13],self[14]/m[14],self[15]/m[15],self[16]/m[16])
	else
		---@cast m number
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
---@param m avm.number16
---@return avm.matrix_4
function matrix_4:matmul(m)
	assert(m, "bad argument 'm' (expected array or sequence, got nil)")
	return M.new(linalg.matmul_mat4_mat4(self, m))
end

---Multiply with a matrix and store the result in a destination
---
---@param m avm.number16
---@param dest avm.seq_number16
---@param dest_index? integer
function matrix_4:matmul_into(m, dest, dest_index)
	assert(m, "bad argument 'm' (expected array or sequence, got nil)")
	assert(dest, "bad argument 'dest' (expected array or sequence, got nil)")
	array.set_16(dest, dest_index or 1, linalg.matmul_mat4_mat4(self, m))
end



return M