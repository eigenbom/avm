--[[
Views  

A view is a special array or sequence that maps into a subset of another array or sequence.  

The views in this module can be used to:  
* Pass subsets of arrays to AVM functions, such as interleaved data or reversed values  
* Provide array wrappers for objects, e.g., `M.slice(cdata, 0, 10)` will make an array wrapper for the first 10 elements of a cdata array  

]]
---@class view_module
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



-----------------------------------------------------------
-- Slice
-----------------------------------------------------------

local slice_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	__len = function(self) return rawget(self, 'n') end
}

---Create a view into `src` that starts at `index` and has `count` elements
---
---Example:
---```lua
---local a = {1,2,3,4,5,6,7,8,9,10}
---local b = view.slice(a, 2, 3)
---print(b[1], b[2], b[3]) --> 2 3 4
---```
---
---Note: Most array functions already have `_slice` forms so this object is rarely needed
---@generic T
---@param src avm.seq<T>
---@param index integer
---@param count integer
---@return avm.fixed_array<T>
function M.slice(src, index, count)
	return setmetatable({_src=src, _i=index, n=count}, slice_mt)
end

-----------------------------------------------------------
-- Strided View
-----------------------------------------------------------

local strided_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + (index - 1)*self._s]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + (index - 1)*self._s] = value
		else
			rawset(self, index, value)
		end
	end,
	__len = function(self) return rawget(self, 'n') end
}

---Create a view into `src` that starts at `index` and skips `stride` elements
---
---Example:
---```lua
---local a = {1,2,3,4,5,6}
---local index, stride, count = 1, 2, 3
---local b = view.stride(a, index, stride, count)
---print(b[1], b[2], b[3]) --> 1 3 5
---```
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@param stride integer
---@param count integer
---@return avm.fixed_array<T>
function M.stride(src, index, stride, count)
	assert(stride ~= 0, "bad argument 'stride' (must be non-zero)")
	assert(src, "bad argument 'src' (expected array or sequence, got nil)")
	return setmetatable({_src=src, _i=index, _s=stride, n=count}, strided_mt)
end

---Create a view into `src` that reverses the elements
-- Can optionally start at `index` and reverse for `count` elements
---
---Example:
---```lua
---local a = {1,2,3,4,5,6,7,8,9,10}
---local b = view.reverse(a)
---print(b[1], b[2], b[3]) --> 10 9 8
---```
---
---@generic T
---@param src avm.array<T>|avm.seq<T>
---@param index? integer
---@param count? integer
---@return avm.fixed_array<T>
function M.reverse(src, index, count)
	local n = count or array.length(src)
	index = index or n
	count = count or n
	assert(src, "bad argument 'src' (expected array or sequence, got nil)")
	return setmetatable({_src=src, _i=index, _s=-1, n=count}, strided_mt)
end

-----------------------------------------------------------
-- Interleaved View
-----------------------------------------------------------

local interleaved_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			local group_adv = math.ceil(index / self._g)-1
			local subgroup_index = (index-1) % self._g
			return self._src[self._i + group_adv*self._s + subgroup_index]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			local group_adv = math.ceil(index / self._g)-1
			local subgroup_index = (index-1) % self._g
			self._src[self._i + group_adv*self._s + subgroup_index] = value
		else
			rawset(self, index, value)
		end
	end,
	__len = function(self) return rawget(self, 'n') end
}

---Create a view over interleaved data, collecting `group_size` elements starting at `index` and skipping `stride` elements
---
---Example:
---```
---local a = {1,2, x,x, 5,6, x,x, 9,10}
---local b = view.interleaved(a, 1, 2, 2, 3)
---print(b[1], b[2], b[3], b[4], b[5], b[6]) --> 1 2 5 6 9 10
---```
---@generic T
---@param src avm.seq<T>
---@param index integer
---@param group_size integer
---@param stride integer
---@param count integer
---@return avm.fixed_array<T>
function M.interleave(src, index, group_size, stride, count)
	assert(group_size > 0, "bad argument 'group_size' (must be greater than 0)")
	assert(stride ~= 0, "bad argument 'stride' (must be non-zero)")
	return setmetatable({_src=src, _i=index, _g=group_size, _s=stride, n=count}, interleaved_mt)
end

-----------------------------------------------------------
-- Fixed size views
-----------------------------------------------------------

local slice1_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 1 end
}

local slice2_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 2 end
}

local slice3_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 3 end
}

local slice4_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 4 end
}

local slice5_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 5 end
}

local slice6_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 6 end
}

local slice7_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 7 end
}

local slice8_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 8 end
}

local slice9_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 9 end
}

local slice10_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 10 end
}

local slice11_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 11 end
}

local slice12_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 12 end
}

local slice13_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 13 end
}

local slice14_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 14 end
}

local slice15_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 15 end
}

local slice16_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value
		else
			rawset(self, index, value)
		end
	end,
	function(self) return 16 end
}

---Create a view of size `1` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array1<T>
function M.slice_1(src, index)
	return setmetatable({_src=src, _i=index}, slice1_mt)
end

---Create a view of size `2` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array2<T>
function M.slice_2(src, index)
	return setmetatable({_src=src, _i=index}, slice2_mt)
end

---Create a view of size `3` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array3<T>
function M.slice_3(src, index)
	return setmetatable({_src=src, _i=index}, slice3_mt)
end

---Create a view of size `4` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array4<T>
function M.slice_4(src, index)
	return setmetatable({_src=src, _i=index}, slice4_mt)
end

---Create a view of size `5` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array5<T>
function M.slice_5(src, index)
	return setmetatable({_src=src, _i=index}, slice5_mt)
end

---Create a view of size `6` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array6<T>
function M.slice_6(src, index)
	return setmetatable({_src=src, _i=index}, slice6_mt)
end

---Create a view of size `7` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array7<T>
function M.slice_7(src, index)
	return setmetatable({_src=src, _i=index}, slice7_mt)
end

---Create a view of size `8` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array8<T>
function M.slice_8(src, index)
	return setmetatable({_src=src, _i=index}, slice8_mt)
end

---Create a view of size `9` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array9<T>
function M.slice_9(src, index)
	return setmetatable({_src=src, _i=index}, slice9_mt)
end

---Create a view of size `10` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array10<T>
function M.slice_10(src, index)
	return setmetatable({_src=src, _i=index}, slice10_mt)
end

---Create a view of size `11` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array11<T>
function M.slice_11(src, index)
	return setmetatable({_src=src, _i=index}, slice11_mt)
end

---Create a view of size `12` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array12<T>
function M.slice_12(src, index)
	return setmetatable({_src=src, _i=index}, slice12_mt)
end

---Create a view of size `13` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array13<T>
function M.slice_13(src, index)
	return setmetatable({_src=src, _i=index}, slice13_mt)
end

---Create a view of size `14` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array14<T>
function M.slice_14(src, index)
	return setmetatable({_src=src, _i=index}, slice14_mt)
end

---Create a view of size `15` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array15<T>
function M.slice_15(src, index)
	return setmetatable({_src=src, _i=index}, slice15_mt)
end

---Create a view of size `16` that maps into `src` starting from `index`
---
---@generic T
---@param src avm.seq<T>
---@param index integer
---@return avm.fixed_array16<T>
function M.slice_16(src, index)
	return setmetatable({_src=src, _i=index}, slice16_mt)
end


return M