--[[
Iterator  

Special purpose iterators  
]]
---@class iterator_module
local M = {}

-----------------------------------------------------------
-- Constants and Dependencies
-----------------------------------------------------------

-- Math library
local math = require("math")
local math_ceil = assert(math.ceil)
local math_min = assert(math.min)

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
---@diagnostic disable-next-line: unused-local
local avm_path = (...):match("(.-)[^%.]+$")

---@module 'avm._debug'
local _debug = require(avm_path .. "_debug")

---@module 'avm.array'
local array = require(avm_path .. "array")
---@module 'avm.view'
local view = require(avm_path .. "view")

---Disable warnings for _ex type overloaded functions
---@diagnostic disable: redundant-return-value, duplicate-set-field

-----------------------------------------------------------
-- Iteration
-----------------------------------------------------------

---Create an iterator over an array that returns consecutive tuples of 2 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T
function M.group_2(src)
	_debug.check_array_and_size("src", src)
	return M.group_2_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 2 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T
function M.group_2_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 2)
	return function()
		while i<n do
			local j = 2*i+src_index
			i = i+1
			return i, src[j], src[j+1]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 3 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T
function M.group_3(src)
	_debug.check_array_and_size("src", src)
	return M.group_3_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 3 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T
function M.group_3_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 3)
	return function()
		while i<n do
			local j = 3*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 4 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T
function M.group_4(src)
	_debug.check_array_and_size("src", src)
	return M.group_4_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 4 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T
function M.group_4_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 4)
	return function()
		while i<n do
			local j = 4*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 5 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T
function M.group_5(src)
	_debug.check_array_and_size("src", src)
	return M.group_5_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 5 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T
function M.group_5_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 5)
	return function()
		while i<n do
			local j = 5*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 6 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T
function M.group_6(src)
	_debug.check_array_and_size("src", src)
	return M.group_6_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 6 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T
function M.group_6_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 6)
	return function()
		while i<n do
			local j = 6*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 7 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T
function M.group_7(src)
	_debug.check_array_and_size("src", src)
	return M.group_7_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 7 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T
function M.group_7_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 7)
	return function()
		while i<n do
			local j = 7*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 8 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T
function M.group_8(src)
	_debug.check_array_and_size("src", src)
	return M.group_8_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 8 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T
function M.group_8_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 8)
	return function()
		while i<n do
			local j = 8*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 9 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T
function M.group_9(src)
	_debug.check_array_and_size("src", src)
	return M.group_9_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 9 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T
function M.group_9_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 9)
	return function()
		while i<n do
			local j = 9*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 10 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T
function M.group_10(src)
	_debug.check_array_and_size("src", src)
	return M.group_10_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 10 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T
function M.group_10_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 10)
	return function()
		while i<n do
			local j = 10*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 11 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T
function M.group_11(src)
	_debug.check_array_and_size("src", src)
	return M.group_11_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 11 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T
function M.group_11_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 11)
	return function()
		while i<n do
			local j = 11*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 12 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_12(src)
	_debug.check_array_and_size("src", src)
	return M.group_12_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 12 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_12_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 12)
	return function()
		while i<n do
			local j = 12*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 13 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_13(src)
	_debug.check_array_and_size("src", src)
	return M.group_13_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 13 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_13_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 13)
	return function()
		while i<n do
			local j = 13*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 14 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_14(src)
	_debug.check_array_and_size("src", src)
	return M.group_14_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 14 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_14_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 14)
	return function()
		while i<n do
			local j = 14*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12], src[j+13]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 15 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_15(src)
	_debug.check_array_and_size("src", src)
	return M.group_15_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 15 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_15_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 15)
	return function()
		while i<n do
			local j = 15*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12], src[j+13], src[j+14]
		end
	end
end

---Create an iterator over an array that returns consecutive tuples of 16 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_16(src)
	_debug.check_array_and_size("src", src)
	return M.group_16_ex(src, 1, array.length(src))
end

---Create an iterator over a slice that returns consecutive tuples of 16 elements
---
---NOTE: the returned index is the index of *the group*
---
---@generic T
---@param src avm.seq<T>
---@param src_index integer
---@param src_count integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.group_16_ex(src, src_index, src_count)
	_debug.check_seq("src", src, src_index, src_count)
	local i = 0
	local n = math_ceil(src_count / 16)
	return function()
		while i<n do
			local j = 16*i+src_index
			i = i+1
			return i, src[j], src[j+1], src[j+2], src[j+3], src[j+4], src[j+5], src[j+6], src[j+7], src[j+8], src[j+9], src[j+10], src[j+11], src[j+12], src[j+13], src[j+14], src[j+15]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T
function M.zip_1(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/1)
	return function()
		while i<n do
			local j = 1*i+1
			i = i+1
			return i, a[j], b[j]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T
function M.zip_1_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/1)
	return function()
		while i<n do
			local aj = 1*i+a_index
			local bj = 1*i+b_index
			i = i+1
			return i, a[aj], b[bj]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T
function M.zip_2(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/2)
	return function()
		while i<n do
			local j = 2*i+1
			i = i+1
			return i, a[j], a[j+1], b[j], b[j+1]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T
function M.zip_2_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/2)
	return function()
		while i<n do
			local aj = 2*i+a_index
			local bj = 2*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], b[bj], b[bj+1]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T
function M.zip_3(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/3)
	return function()
		while i<n do
			local j = 3*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], b[j], b[j+1], b[j+2]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T
function M.zip_3_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/3)
	return function()
		while i<n do
			local aj = 3*i+a_index
			local bj = 3*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], b[bj], b[bj+1], b[bj+2]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T
function M.zip_4(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/4)
	return function()
		while i<n do
			local j = 4*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], b[j], b[j+1], b[j+2], b[j+3]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T
function M.zip_4_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/4)
	return function()
		while i<n do
			local aj = 4*i+a_index
			local bj = 4*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], b[bj], b[bj+1], b[bj+2], b[bj+3]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T
function M.zip_5(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/5)
	return function()
		while i<n do
			local j = 5*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], b[j], b[j+1], b[j+2], b[j+3], b[j+4]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T
function M.zip_5_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/5)
	return function()
		while i<n do
			local aj = 5*i+a_index
			local bj = 5*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_6(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/6)
	return function()
		while i<n do
			local j = 6*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_6_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/6)
	return function()
		while i<n do
			local aj = 6*i+a_index
			local bj = 6*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_7(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/7)
	return function()
		while i<n do
			local j = 7*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_7_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/7)
	return function()
		while i<n do
			local aj = 7*i+a_index
			local bj = 7*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_8(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/8)
	return function()
		while i<n do
			local j = 8*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_8_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/8)
	return function()
		while i<n do
			local aj = 8*i+a_index
			local bj = 8*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_9(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/9)
	return function()
		while i<n do
			local j = 9*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_9_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/9)
	return function()
		while i<n do
			local aj = 9*i+a_index
			local bj = 9*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_10(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/10)
	return function()
		while i<n do
			local j = 10*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_10_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/10)
	return function()
		while i<n do
			local aj = 10*i+a_index
			local bj = 10*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_11(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/11)
	return function()
		while i<n do
			local j = 11*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_11_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/11)
	return function()
		while i<n do
			local aj = 11*i+a_index
			local bj = 11*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_12(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/12)
	return function()
		while i<n do
			local j = 12*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_12_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/12)
	return function()
		while i<n do
			local aj = 12*i+a_index
			local bj = 12*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_13(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/13)
	return function()
		while i<n do
			local j = 13*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_13_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/13)
	return function()
		while i<n do
			local aj = 13*i+a_index
			local bj = 13*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_14(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/14)
	return function()
		while i<n do
			local j = 14*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], a[j+13], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12], b[j+13]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_14_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/14)
	return function()
		while i<n do
			local aj = 14*i+a_index
			local bj = 14*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], a[aj+13], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12], b[bj+13]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_15(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/15)
	return function()
		while i<n do
			local j = 15*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], a[j+13], a[j+14], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12], b[j+13], b[j+14]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_15_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/15)
	return function()
		while i<n do
			local aj = 15*i+a_index
			local bj = 15*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], a[aj+13], a[aj+14], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12], b[bj+13], b[bj+14]
		end
	end
end

---Create an iterator over two arrays that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.array<T>
---@param b avm.array<T>
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_16(a, b)
	_debug.check_array_and_size("a", a)
	_debug.check_array("b", b, 1, array.length(a))
	local i = 0
	local n = math_ceil(math_min(array.length(a),array.length(b))/16)
	return function()
		while i<n do
			local j = 16*i+1
			i = i+1
			return i, a[j], a[j+1], a[j+2], a[j+3], a[j+4], a[j+5], a[j+6], a[j+7], a[j+8], a[j+9], a[j+10], a[j+11], a[j+12], a[j+13], a[j+14], a[j+15], b[j], b[j+1], b[j+2], b[j+3], b[j+4], b[j+5], b[j+6], b[j+7], b[j+8], b[j+9], b[j+10], b[j+11], b[j+12], b[j+13], b[j+14], b[j+15]
		end
	end
end

---Create an iterator over two slices that returns
---```
---i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
---```
---where `i` is the index of the group,
---`a_i_j` is the `j`'th element of group `i` of `a` and
---`b_i_j` is the `j`'th element of group `i` of `b`
---
---@generic T
---@param a avm.seq<T>
---@param a_index integer
---@param a_count integer
---@param b avm.seq<T>
---@param b_index integer
---@return fun():integer,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T
function M.zip_16_ex(a, a_index, a_count, b, b_index)
	_debug.check_seq("a", a, a_index, a_count)
	_debug.check_seq("b", b, b_index, a_count)
	local i = 0
	local n = math_ceil(a_count/16)
	return function()
		while i<n do
			local aj = 16*i+a_index
			local bj = 16*i+b_index
			i = i+1
			return i, a[aj], a[aj+1], a[aj+2], a[aj+3], a[aj+4], a[aj+5], a[aj+6], a[aj+7], a[aj+8], a[aj+9], a[aj+10], a[aj+11], a[aj+12], a[aj+13], a[aj+14], a[aj+15], b[bj], b[bj+1], b[bj+2], b[bj+3], b[bj+4], b[bj+5], b[bj+6], b[bj+7], b[bj+8], b[bj+9], b[bj+10], b[bj+11], b[bj+12], b[bj+13], b[bj+14], b[bj+15]
		end
	end
end

return M