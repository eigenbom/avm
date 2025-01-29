
--[[
Matrix operations and types  

Classes and functions for working with matrices  

]]
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
local avm_path = (...):match("(.-)[^%.]+$")

local _debug = require(avm_path .. "_debug")

local array = require(avm_path .. "array")
local linalg = require(avm_path .. "linalg")
local format = require(avm_path .. "format")

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
	_debug.check("e_11", e_11, 'number')
	_debug.check("e_12", e_12, 'number')
	_debug.check("e_21", e_21, 'number')
	_debug.check("e_22", e_22, 'number')
	return setmetatable({e_11, e_12, e_21, e_22}, matrix_2)
end

function matrix_2:__index(key)
	if key == 'n' then
		return 4
	else
		return matrix_2[key]
	end
end

function matrix_2:__tostring()
	return format.array(self)
end

function matrix_2:copy()
	return M.new(self:get())
end

function matrix_2:copy_into(dest, dest_index)
	_debug.check_array("dest", dest, dest_index, 4)
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
	_debug.check("e_11", e_11, 'number')
	_debug.check("e_12", e_12, 'number')
	_debug.check("e_21", e_21, 'number')
	_debug.check("e_22", e_22, 'number')
	self[1], self[2], self[3], self[4] = e_11, e_12, e_21, e_22
end
---Apply addition element-wise and return a new matrix_2
---
---Parameter `m` can be a number or array
function matrix_2:add(m)
	local is_number = type(m) == 'number'
	if not is_number then
			_debug.check_array("m", m, 1, 4)
		return M.new(self[1]+m[1],self[2]+m[2],self[3]+m[3],self[4]+m[4])
	else
			return M.new(self[1]+m,self[2]+m,self[3]+m,self[4]+m)
	end
	
end

---Apply addition element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
function matrix_2:add_into(m, dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
			_debug.check_array("m", m, 1, 4)
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
			_debug.check_array("m", m, 1, 4)
		return M.new(self[1]-m[1],self[2]-m[2],self[3]-m[3],self[4]-m[4])
	else
			return M.new(self[1]-m,self[2]-m,self[3]-m,self[4]-m)
	end
	
end

---Apply subtraction element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
function matrix_2:sub_into(m, dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
			_debug.check_array("m", m, 1, 4)
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
			_debug.check_array("m", m, 1, 4)
		return M.new(self[1]*m[1],self[2]*m[2],self[3]*m[3],self[4]*m[4])
	else
			return M.new(self[1]*m,self[2]*m,self[3]*m,self[4]*m)
	end
	
end

---Apply multiplication element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
function matrix_2:mul_into(m, dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
			_debug.check_array("m", m, 1, 4)
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
			_debug.check_array("m", m, 1, 4)
		return M.new(self[1]/m[1],self[2]/m[2],self[3]/m[3],self[4]/m[4])
	else
			return M.new(self[1]/m,self[2]/m,self[3]/m,self[4]/m)
	end
	
end

---Apply division element-wise and store the result in a destination
---
---Parameter `m` can be a number or array
function matrix_2:div_into(m, dest, dest_index)
	_debug.check_array("dest", dest, dest_index or 1, 4)
	local is_number = type(m) == 'number'
	if not is_number then
			_debug.check_array("m", m, 1, 4)
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
	_debug.check_array("m", m, 1, 4)
	return M.new(linalg.matmul_mat2_mat2(self, m))
end

---Multiply with a matrix and store the result in a destination
---
function matrix_2:matmul_into(m, dest, dest_index)
	_debug.check_array("m", m, 1, 4)
	_debug.check_array("dest", dest, dest_index or 1, 4)
	array.set_4(dest, dest_index or 1, linalg.matmul_mat2_mat2(self, m))
end

return M