--[[
Views  

A view is a special array or sequence that maps into a subset of another array or sequence.  

The views in this module can be used to:  
* Pass subsets of arrays to AVM functions, such as interleaved data or reversed values  
* Provide array wrappers for objects, e.g., `M.slice(cdata, 0, 10)` will make an array wrapper for the first 10 elements of a cdata array  

]]
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
local avm_path = (...):match("(.-)[^%.]+$")

local _debug = require(avm_path .. "_debug")

local array = require(avm_path .. "array")

---Disable warnings for _ex type overloaded functions

-----------------------------------------------------------
-- Dependencies
-----------------------------------------------------------

-- Math library dependencies
-- Override these to use a different math library or set as nil to remove the dependency
local math = require("math")
local math_ceil = assert(math.ceil)

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
	__len = nil
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
---Note: Most array functions have `_ex` forms so this object is a convenience only
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
	__len = nil
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
function M.stride(src, index, stride, count)
	assert(stride ~= 0, "bad argument 'stride' (must be non-zero)")
	_debug.check_seq("src", src, index, count*stride-1)
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
function M.reverse(src, index, count)
	local n = count or array.length(src)
	index = index or n
	count = count or n
	_debug.check_seq("src", src, index-count+1, count)
	return setmetatable({_src=src, _i=index, _s=-1, n=count}, strided_mt)
end

-----------------------------------------------------------
-- Interleaved View
-----------------------------------------------------------

local interleaved_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			local group_adv = math_ceil(index / self._g)-1
			local subgroup_index = (index-1) % self._g
			return self._src[self._i + group_adv*self._s + subgroup_index]
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			local group_adv = math_ceil(index / self._g)-1
			local subgroup_index = (index-1) % self._g
			self._src[self._i + group_adv*self._s + subgroup_index] = value
		else
			rawset(self, index, value)
		end
	end,
	__len = nil
}

---Create a view over interleaved data, collecting `group_size` elements starting at `index` and skipping `stride` elements
---
---Example:
---```
---local a = {1,2, x,x, 5,6, x,x, 9,10}
---local b = view.interleaved(a, 1, 2, 2, 3)
---print(b[1], b[2], b[3], b[4], b[5], b[6]) --> 1 2 5 6 9 10
---```
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
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 1
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice1")
		else
			rawset(self, index, value)
		end
	end
}

local slice2_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 2
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice2")
		else
			rawset(self, index, value)
		end
	end
}

local slice3_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 3
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice3")
		else
			rawset(self, index, value)
		end
	end
}

local slice4_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 4
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice4")
		else
			rawset(self, index, value)
		end
	end
}

local slice5_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 5
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice5")
		else
			rawset(self, index, value)
		end
	end
}

local slice6_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 6
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice6")
		else
			rawset(self, index, value)
		end
	end
}

local slice7_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 7
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice7")
		else
			rawset(self, index, value)
		end
	end
}

local slice8_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 8
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice8")
		else
			rawset(self, index, value)
		end
	end
}

local slice9_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 9
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice9")
		else
			rawset(self, index, value)
		end
	end
}

local slice10_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 10
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice10")
		else
			rawset(self, index, value)
		end
	end
}

local slice11_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 11
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice11")
		else
			rawset(self, index, value)
		end
	end
}

local slice12_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 12
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice12")
		else
			rawset(self, index, value)
		end
	end
}

local slice13_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 13
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice13")
		else
			rawset(self, index, value)
		end
	end
}

local slice14_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 14
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice14")
		else
			rawset(self, index, value)
		end
	end
}

local slice15_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 15
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice15")
		else
			rawset(self, index, value)
		end
	end
}

local slice16_mt = {
	__index = function(self, index)
		if type(index) == 'number' then
			return self._src[self._i + index - 1]		elseif index == 'n' then
			return 16
		else
			return rawget(self, index)
		end
	end,
	__newindex = function(self, index, value)
		if type(index) == 'number' then
			self._src[self._i + index - 1] = value		elseif index == 'n' then
			error("cannot set 'n' field in slice16")
		else
			rawset(self, index, value)
		end
	end
}

---Create a view of size `1` that maps into `src` starting from `index`
---
function M.slice_1(src, index)
	return setmetatable({_src=src, _i=index}, slice1_mt)
end

---Create a view of size `2` that maps into `src` starting from `index`
---
function M.slice_2(src, index)
	return setmetatable({_src=src, _i=index}, slice2_mt)
end

---Create a view of size `3` that maps into `src` starting from `index`
---
function M.slice_3(src, index)
	return setmetatable({_src=src, _i=index}, slice3_mt)
end

---Create a view of size `4` that maps into `src` starting from `index`
---
function M.slice_4(src, index)
	return setmetatable({_src=src, _i=index}, slice4_mt)
end

---Create a view of size `5` that maps into `src` starting from `index`
---
function M.slice_5(src, index)
	return setmetatable({_src=src, _i=index}, slice5_mt)
end

---Create a view of size `6` that maps into `src` starting from `index`
---
function M.slice_6(src, index)
	return setmetatable({_src=src, _i=index}, slice6_mt)
end

---Create a view of size `7` that maps into `src` starting from `index`
---
function M.slice_7(src, index)
	return setmetatable({_src=src, _i=index}, slice7_mt)
end

---Create a view of size `8` that maps into `src` starting from `index`
---
function M.slice_8(src, index)
	return setmetatable({_src=src, _i=index}, slice8_mt)
end

---Create a view of size `9` that maps into `src` starting from `index`
---
function M.slice_9(src, index)
	return setmetatable({_src=src, _i=index}, slice9_mt)
end

---Create a view of size `10` that maps into `src` starting from `index`
---
function M.slice_10(src, index)
	return setmetatable({_src=src, _i=index}, slice10_mt)
end

---Create a view of size `11` that maps into `src` starting from `index`
---
function M.slice_11(src, index)
	return setmetatable({_src=src, _i=index}, slice11_mt)
end

---Create a view of size `12` that maps into `src` starting from `index`
---
function M.slice_12(src, index)
	return setmetatable({_src=src, _i=index}, slice12_mt)
end

---Create a view of size `13` that maps into `src` starting from `index`
---
function M.slice_13(src, index)
	return setmetatable({_src=src, _i=index}, slice13_mt)
end

---Create a view of size `14` that maps into `src` starting from `index`
---
function M.slice_14(src, index)
	return setmetatable({_src=src, _i=index}, slice14_mt)
end

---Create a view of size `15` that maps into `src` starting from `index`
---
function M.slice_15(src, index)
	return setmetatable({_src=src, _i=index}, slice15_mt)
end

---Create a view of size `16` that maps into `src` starting from `index`
---
function M.slice_16(src, index)
	return setmetatable({_src=src, _i=index}, slice16_mt)
end

return M