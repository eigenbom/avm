setup_busted_helpers(assert)

local array = require("avm.array")
local config = require("avm.config")
local format = require("avm.format")
local linalg = require("avm.linalg")

describe("array creation", function()
	it("creates zeros", function()
		local zeros = array.zeros(3)
		-- NB: zeros is type array
		assert.is_true(#zeros == 3 and zeros[1]==0 and zeros[2]==0 and zeros[3]==0)
	end)

	it("can fill", function()
		local a = array.fill(1, 3)
		assert.is_true(#a == 3)
		assert.is_same(a, {1, 1, 1})

		-- fill range
		array.fill_into(2, 1, a)
		assert.is_same(a, {2, 1, 1})
	end)

	it("copies", function()
		local ones = array.fill(1, 3)
		local copy_ones = array.copy(ones)
		-- not the same array, but identical elements
		assert.are.not_equals(copy_ones, ones)
		assert.are.same(copy_ones, ones)
	end)

	it("copies slices", function()
		local ones = array.fill(1, 3)
		local copy_ones = array.copy_ex(ones, 1, 2)
		assert.are.same(copy_ones, {1,1})

		local copy_into_ones = array.new_array('number', 2)
		array.copy_ex(ones, 1, 2, copy_into_ones)
		assert.are.same(copy_into_ones, {1,1})
	end)
end)

describe("array set and push", function()
	it("can set", function()
		local a = {1,2,3,4,5}
		array.set(a, 1, 2,3,4,5,6)
		array.set_2(a, 3, 0, 0)
		assert.are.same(a, {2,3,0,0,6})
	end)

	it("can set up to 16", function()
		for i=2,16 do
			local a = array.range(1,i)
			array["set_" .. i](a, 1, unpack(array.fill(9,i)))
			assert.is_true(array.all_equals_constant(a, 9))
		end
	end)

	it("can push", function()
		local a = {1,2,3}
		array.push(a, 4,5,6)
		assert.are.same(a, {1,2,3,4,5,6})
	end)

	it("can push up to 16", function()
		for i=1,16 do
			local a = array.range(1,i)
			array["push_" .. i](a, unpack(array.fill(9,i)))
			-- first part remains the same
			assert.is_true(array.all_equals_ex(a, 1, i, array.range(1,i), 1))
			-- the rest is 9
			assert.is_true(array.all_equals_constant_ex(a, i+1, i, 9))
		end
	end)
end)

describe("array get and unpack", function()
	it("can get_2", function()
		local a = {5,4,3,2,1}
		local x, y = array.get_2(a, 2)
		assert.are.same(x, 4)
		assert.are.same(y, 3)
	end)

	it("can get up to 16", function()
		for i=2,16 do
			local a = array.range(1,i+1)
			local res = { array["get_" .. i](a, 2) }
			assert.are.same(res, array.range(2,i+1))
		end
	end)

	it("can unpack up to 16", function()
		for i=2,16 do
			local a = array.range(1,i)
			local res = { array["unpack_" .. i](a) }
			assert.are.same(res, array.range(1,i))
		end
	end)
end)

describe("array copy", function()
	it("can copy range", function()
		local mostly_zeros = array.zeros(8)
		array.fill_into(1, 3, mostly_zeros) -- {1,1,1,0,0,0,0,0}
		local mostly_ones = array.copy_ex(mostly_zeros, 1, 4) -- {1,1,1,0}
		assert.are.equals(array.length(mostly_ones), 4)
		assert.are.equals(format.array(mostly_ones), "1, 1, 1, 0")
	end)

	it("can copy range into", function()
		local a = array.range(1, 10)
		assert.are.same(a, {1,2,3,4,5,6,7,8,9,10})

		array.copy_ex(a, 1, 3, a, 5)
		assert.are.same(a, {1,2,3,4,1,2,3,8,9,10})
	end)
end )

describe("array sequence", function()
	it("can create sequence", function()
		local first_ten_numbers = array.range(1, 10)
		assert.are.same(first_ten_numbers, {1,2,3,4,5,6,7,8,9,10})

		local prev_ten_numbers = array.range(-1, -10, -1)
		assert.are.same(prev_ten_numbers, {-1,-2,-3,-4,-5,-6,-7,-8,-9,-10})
		
		local unit_interval = array.range(0, 1, 0.1)
		assert.almost_equals(unit_interval, {0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0})

		-- NB: Can't guarantee we get the final `to` value
		local thirds = array.range(0, .9, 1/3)
		assert.almost_equals(thirds, {0, 1/3, 2/3})
	end)

	it("can fill sequence", function()
		local a = array.zeros(100)
		array.range_into(1, 10, 1, a, 5) -- a[5..14] = {1,2,3,4,5,6,7,8,9,10}
		assert.are.same(array.copy_ex(a, 1, 16), {0,0,0,0,1,2,3,4,5,6,7,8,9,10,0,0})
	end )
end)

describe("array arithmetic", function()
	it("can add", function()
		local a = array.range(1, 10)
		local b = array.range(10, 1, -1)
		local c = array.add(a, b)
		assert.is_true(array.all_equals_constant(c, 11))

		local d = array.new_array('number', 10)
		array.add_ex(a, 1, #a, b, 1, d)
		assert.is_true(array.all_equals_constant(d, 11))
	end)

	it("can add constant", function()
		local a = array.range(1, 10)
		local b = array.add_constant(a, 1)
		assert.are.same(b, array.range(2, 11))

		local c = array.new_array('number', 10)
		array.add_constant_ex(a, 1, #a, 1, c)
		assert.are.same(c, array.range(2, 11))
	end)

	it("can sub", function()
		local a = array.range(1, 10)
		local b = array.range(10, 19)
		local c = array.sub(a, b)
		assert.is_true(array.all_equals_constant(c, -9))

		local d = array.new_array('number', 10)
		array.sub_ex(a, 1, #a, b, 1, d)
		assert.is_true(array.all_equals_constant(d, -9))
	end)

	it("can sub constant", function()
		local a = array.range(1, 10)
		local b = array.sub_constant(a, 1)
		assert.are.same(b, array.range(0, 9))

		local c = array.new_array('number', 10)
		array.sub_constant_ex(a, 1, #a, 1, c)
		assert.are.same(c, array.range(0, 9))
	end)
end )

describe("array append and join", function()
	it("can append", function()
		-- appending and joining
		local a = {1, 2, 3}
		local b = {4, 5, 6}
		array.append(b, a)
		assert.are.same(a, {1,2,3,4,5,6})
	end)

	it("can join", function()
		local a = {1, 2, 3}
		local b = {4, 5, 6}
		local c = array.join(a, b)
		assert.are.same(c, {1,2,3,4,5,6})
		assert.are.same(a, {1,2,3}) -- a was unaffected
	end)
	
	it("can append self", function()
		local a = {1, 2, 3}
		array.append(a, a)
		assert.are.same(array.length(a), 6)
		assert.are.same(a, {1,2,3,1,2,3})
	end)
end)

describe("array operations", function()
	it("can reverse", function()
		local a = {1, 2, 3}
		local b = array.reverse(a)
		assert.are.same(b, {3, 2, 1})
	end)

	it("can reverse into", function()
		local a = {1, 2, 3}
		local b = array.new_array('number', 3)
		array.reverse_ex(a, 1, #a, b)
		assert.are.same(b, {3, 2, 1})
	end)
end)

describe("array almost equals constant", function()
	it("all_almost_equals_constant", function()
		-- Test an almost equal to '1' array
		local a = {1.01, 1.05, 0.95, 1, 1, 1.001}
		assert.is_true(array.all_almost_equals_constant(a, 1, .1))
		assert.is_false(array.all_almost_equals_constant(a, 1)) -- default epsilon is tiny
		-- Test the last section with finer precision
		assert.is_false(array.all_almost_equals_constant_ex(a, 1, 3, 1, .01))
		assert.is_true(array.all_almost_equals_constant_ex(a, 4, 3, 1, .01))
	end)
end)

describe("works on custom array wrappers", function()
	--- metatable for general length array views
	local array_wrapper_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._array[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._array[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end
	}

	--- metatable for general length array views
	local array_wrapper_with_len_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._array[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._array[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		__len = function(self)
			return self._n -- custom metamethod
		end
	}

	--- metatable for fixed length array views
	local array3_wrapper_mt = {
		__index = function(self, index)
			if type(index) == 'number' then
				return self._array[self._i + index - 1]
			else
				return rawget(self, index)
			end
		end,
		__newindex = function(self, index, value)
			if type(index) == 'number' then
				self._array[self._i + index - 1] = value
			else
				rawset(self, index, value)
			end
		end,
		__len = function(self)
			return 3
		end
	}

	it("supports __index", function()
		local zeros = {0,0,0}
		local zeros_view = setmetatable({ _array = zeros, _i = 1, n = 3 }, array_wrapper_mt)
		assert.is_equal(zeros_view[1], 0)
		assert.is_equal(zeros_view[2], 0)
	end)

	it("supports an .n field and __newindex", function()
		-- array or view copy function
		local function copy(from, to)
			for i=1,(from.n or #from) do
				to[i] = from[i]
			end
		end

		local src = {1,2,3,4,5,6,7,8,9}
		local src_view = setmetatable({ _array = src, _i = 1, n = 3 }, array_wrapper_mt)
		local target_view = setmetatable({ _array = src, _i = 7, n = 3 }, array_wrapper_mt)

		-- copy range 1-3 to range 7-9
		copy(src_view, target_view)
		assert.is_same(src, {1,2,3,4,5,6,1,2,3})
	end)

	it("supports __len metamethod", function()

		local zeros = {0,0,0}
		local zeros_view = setmetatable({ _array = zeros, _i = 1, _n = 3 }, array_wrapper_with_len_mt)

		if #zeros_view == 3 then
			-- test platform supports __len metamethod
			assert.is_same(#zeros_view, 3)
			assert.is_same(array.length(zeros_view), 3)

			if config.NO_LEN_METAMETHOD then
				zeros_view.n = 2 -- override
				assert.is_same(array.length(zeros_view), 2)
			end
		end
	end )

	it("can reduce data with view_n", function()
		local viewable_data = {1,2,3,4,5,6,7,8,9}
		local view = setmetatable( {_array = viewable_data, _i = 4}, array3_wrapper_mt )
		assert.is_same({view[1],view[2],view[3]}, {4, 5, 6})
	end)
end)

describe("array functional", function()
	it("can generate", function()
		local a = array.generate(5, function(i) return i end)
		assert.are.same(a, {1,2,3,4,5})

		local b = array.new_array('number', 5)
		array.generate_into(5, function(i) return i*0.1 end, b)
		assert.almost_equals(b, {.1,.2,.3,.4,.5})

		local z = array.generate(0, function(i) return i*0.1 end)
		assert.is_same(z, {})

		local three_hellos = array.generate(3, function(i) return "Hello!" end)
		assert.is_same(three_hellos, {"Hello!", "Hello!", "Hello!"})
	end )

	local map_f1 = function(x) return x*2; end
	local map_f2 = function(x, y) return x-y; end
	local map_f3 = function(x, y, z) return x-y*z; end
	local map_f4 = function(x, y, z, w) return w + map_f3(x,y,z); end

	it("can do maps", function()
		assert.almost_equals(array.map(map_f1, {1,2,3}), {2,4,6})
		assert.almost_equals(array.map_2(map_f2, {1,2,3}, {1,2,3}), {0,0,0})
		assert.almost_equals(array.map_3(map_f3, {1,2,3}, {1,2,3}, {1,0,0}), {0,2,3})
		assert.almost_equals(array.map_4(map_f4, {1,2,3}, {1,2,3}, {1,0,0}, {1,2,3}), {1,4,6})
	end )

	it("can do map ex", function()
		assert.almost_equals(array.map_ex(map_f1, {1,2,3}, 1, 3), {2,4,6})
		assert.almost_equals(array.map_2_ex(map_f2, {1,2,3}, 1, 3, {1,2,3}, 1), {0,0,0})
		assert.almost_equals(array.map_3_ex(map_f3, {1,2,3}, 1, 3, {1,2,3}, 1, {1,0,0}, 1), {0,2,3})
		assert.almost_equals(array.map_4_ex(map_f4, {1,2,3}, 1, 3, {1,2,3}, 1, {1,0,0}, 1, {1,2,3}, 1), {1,4,6})
		
		local dest = array.new_array('number', 3)
		local subtract = function(x, y) return x-y; end
		array.map_2_ex(subtract, {1,2,3}, 1, 3, {1,2,3}, 1, dest, 1 )
		assert.almost_equals(dest, {0,0,0})
	end )
end)

local has_ffi, ffi = pcall(require, "ffi")
if has_ffi and config.SUPPORT_CDATA then
	describe("works with ffi", function()
		it("works", function ()
			local length = 12
			local cdata_arr = ffi.new("int[?]", length)
			array.fill_into(3, length, cdata_arr, 0) --NB: 0-based
			local arr = {}
			for i=1,length do
				arr[i] = cdata_arr[i-1] --NB: 0-based
			end
			assert.are.same(arr, {3,3,3,3,3,3,3,3,3,3,3,3})
		end)
	end)
end

describe("array reshape", function()
	it("flattens", function()
		local a = {{1,2,3},{4,5,6}}
		local b = array.reshape(a, {6})
		assert.are.same(b, {1,2,3,4,5,6})
	end)

	it("fattens", function()
		local a = {1,2,3,4,5,6}
		local b = array.reshape(a, {3, 2})
		assert.are.same(b, {{1,2},{3,4},{5,6}})
	end)

	it("reshapes", function()
		local a = {{1,2},{3,4},{5,6}}
		local b = array.reshape(a, {2, 3})
		assert.are.same(b, {{1,2,3},{4,5,6}})
	end)

	it("reshapes_into", function()
		local a = {{1,2},{3,4},{5,6}}
		local b = {{9,9,9}} -- has existing data
		array.reshape_into(a, {2, 3}, b, 2)
		assert.are.same(b, {{9,9,9}, {1,2,3}, {4,5,6}})
	end)

	it("flattens (shorthand)", function()
		local a = {}
		local b = array.flatten(a)
		assert.are.same(b, {})
	end)

	it("flattens (shorthand)", function()
		local a = {{1,2,3},{4,5,6}}
		local b = array.flatten(a)
		assert.are.same(b, {1,2,3,4,5,6})
	end)
	
	it("flattens (shorthand)", function()
		local a = {{{1,2},{3,4}},{{5,6},{7,8}}}
		local b = array.flatten(a)
		assert.are.same(b, {1,2,3,4,5,6,7,8})
	end)

	it("flattens into (shorthand)", function()
		local a = {{{1,2},{3,4}},{{5,6},{7,8}}}
		local b = {9,9,9}
		array.flatten_into(a, b, 4)
		assert.are.same(b, {9,9,9,1,2,3,4,5,6,7,8})
	end)
end)

describe("array types", function()
	it("has type annotations", function()
		-- Can use array<T> annotation to identify a general array
		---@type avm.array<number>
		local numbers_array = { 1, 2, 3 }
		
		-- Can use fixed_array3<T> annotation to identify a fixed-length array
		---@type avm.fixed_array3<number>
		local numbers_array3 = { 1, 2, 3 }

		-- There's only a semantic difference, some functions take a fixed_array3/vec3, e.g., 
		assert.are.same(linalg.length_squared_vec3(numbers_array3), 14)

		-- T can be anything
		---@type avm.array<string>
		local strings_array = { "hello", "world" }
		-- Most functions in AVM assume numbers, but some are type generic
		local backwards = array.map(function(str) return string.reverse(str) end, strings_array)
		assert.are.same(backwards, { "olleh", "dlrow" })

		-- More complex map type
		local people = { "John", "Mary", "Ben" }
		local ages = { 20, 30, 40 }
		---@param name string
		---@param age number
		local function create_record(name, age)
			return name .. " is " .. tostring(age)
		end
		local records = array.map_2(create_record, people, ages)
		assert.are.same(type(records[1]), "string")
		assert.are.same(records[1], "John is 20")
	end)

	it("supports integer arrays and number arrays in some functions", function()
		local first_ten_integers = array.range(1, 10)
		-- NOTE: inferred type of first_ten_integers is integer[] in some IDEs
		if type(1)=="integer" then
			-- NOTE: actual type of first_ten_integers is integer[] in some Lua VMs
			assert.are.same(type(first_ten_integers[1]), "integer")
		else
			assert.are.same(type(first_ten_integers[1]), "number")
		end

		local first_ten_reals = array.range(1.0,10)
		assert.are.same(type(first_ten_reals[1]), "number")
	end)
end)

describe("will throw errors", function()
	it("errors if expecting an array with length", function()
		local infinite_threes_array = {
			__index = function(self, key)
				if type(key) == 'number' then
					return 3
				end
			end
		}
		local threes = setmetatable({}, infinite_threes_array)
		assert.are.same(threes[1], 3)
		assert.are.same(threes[-99], 3)
		assert.are.same(threes[999], 3)
		assert.are.same(#threes, 0) -- has zero length

		---@diagnostic disable-next-line: missing-parameter
		assert.has_error(function() array.copy() end)
	end)
end)

if config.CHECK_PARAMS then
	describe("will check arrays", function()
		-- TODO:
	end)
end