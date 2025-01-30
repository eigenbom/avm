
--[[
Matrix operations and types  

Classes and functions for working with matrices  

]]
---@class matrix_2_module
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
---@module 'avm.linalg'
local linalg = require(avm_path .. "linalg")
---@module 'avm.format'
local format = require(avm_path .. "format")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field

---2x2 matrix in column-major order constructed from a tuple
---
---@class avm.matrix_2: avm.number4
---@operator add(avm.number4|number): avm.matrix_2
---@operator sub(avm.number4|number): avm.matrix_2
---@operator mul(avm.number4|number): avm.matrix_2
---@operator div(avm.number4|number): avm.matrix_2
---@operator unm():avm.matrix_2
local matrix_2 = {}

---A 2x2 matrix in column-major order that views into an array or slice
---
---@class avm.matrix_2_slice: avm.number4
---@operator add(avm.number4|number): avm.matrix_2
---@operator sub(avm.number4|number): avm.matrix_2
---@operator mul(avm.number4|number): avm.matrix_2
---@operator div(avm.number4|number): avm.matrix_2
---@operator unm():avm.matrix_2_slice
---@field private _src avm.seq_number4
---@field private _o integer
local matrix_2_slice = {}

-----------------------------------------------------------
-- Matrix creation
-----------------------------------------------------------

---Create a new matrix_2
---Parameter `e_ij` determines the value of `i'th` column `j'th` row
---@param e_11 number
---@param e_12 number
---@param e_21 number
---@param e_22 number
---@return avm.matrix_2
function M.new(e_11, e_12, e_21, e_22)
	_debug.check("e_11", e_11, 'number')
	_debug.check("e_12", e_12, 'number')
	_debug.check("e_21", e_21, 'number')
	_debug.check("e_22", e_22, 'number')
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

---@param dest avm.seq_number4
---@param dest_index? integer
function matrix_2:copy_into(dest, dest_index)
	_debug.check_seq("dest", dest, dest_index, 4)
	array.set_4(dest, dest_index or 1, self:get())
end

---Get values as a tuple
---@return number,number,number,number
function matrix_2:get()
	return self[1], self[2], self[3], self[4]
end

---Set values from a tuple
---
---Parameter `e_ij` determines the value of `i'th` column `j'th` row
---@param e_11 number
---@param e_12 number
---@param e_21 number
---@param e_22 number
function matrix_2:set(e_11, e_12, e_21, e_22)
	_debug.check("e_11", e_11, 'number')
	_debug.check("e_12", e_12, 'number')
	_debug.check("e_21", e_21, 'number')
	_debug.check("e_22", e_22, 'number')
	self[1], self[2], self[3], self[4] = e_11, e_12, e_21, e_22
end
---Apply addition element-wise and return a new matrix_2
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@return avm.matrix_2
function matrix_2:add(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4])
	else
		---@cast m number
		return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m)
	end
	
end

---Apply addition element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function matrix_2:add_into(m, dest, dest_index)
	_debug.check_seq("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		array.set_4(dest, dest_index or 1, self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4])
	else
		---@cast m number
		array.set_4(dest, dest_index or 1, self[1]+m,self[2]+m,self[3]+m,self[4]+m)
	end
end

---Apply subtraction element-wise and return a new matrix_2
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@return avm.matrix_2
function matrix_2:sub(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4])
	else
		---@cast m number
		return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m)
	end
	
end

---Apply subtraction element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function matrix_2:sub_into(m, dest, dest_index)
	_debug.check_seq("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		array.set_4(dest, dest_index or 1, self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4])
	else
		---@cast m number
		array.set_4(dest, dest_index or 1, self[1]-m,self[2]-m,self[3]-m,self[4]-m)
	end
end

---Apply multiplication element-wise and return a new matrix_2
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@return avm.matrix_2
function matrix_2:mul(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4])
	else
		---@cast m number
		return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m)
	end
	
end

---Apply multiplication element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function matrix_2:mul_into(m, dest, dest_index)
	_debug.check_seq("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		array.set_4(dest, dest_index or 1, self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4])
	else
		---@cast m number
		array.set_4(dest, dest_index or 1, self[1]*m,self[2]*m,self[3]*m,self[4]*m)
	end
end

---Apply division element-wise and return a new matrix_2
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@return avm.matrix_2
function matrix_2:div(m)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4])
	else
		---@cast m number
		return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m)
	end
	
end

---Apply division element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
---@param m avm.number4|number
---@param dest avm.seq_number4
---@param dest_index? integer
function matrix_2:div_into(m, dest, dest_index)
	_debug.check_seq("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
		---@cast m avm.number4
		_debug.check_seq("m", m, 1, 4)
		array.set_4(dest, dest_index or 1, self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4])
	else
		---@cast m number
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
---@param m avm.number4
---@return avm.matrix_2
function matrix_2:matmul(m)
	_debug.check_seq("m", m, 1, 4)
	return M.new(linalg.matmul_mat2_mat2(self, m))
end

---Multiply with a matrix and store the result in a destination
---
---@param m avm.number4
---@param dest avm.seq_number4
---@param dest_index? integer
function matrix_2:matmul_into(m, dest, dest_index)
	_debug.check_seq("m", m, 1, 4)
	_debug.check_seq("dest", dest, dest_index or 1, 4)
	array.set_4(dest, dest_index or 1, linalg.matmul_mat2_mat2(self, m))
end

return M