setup_busted_helpers(assert)

local array = require("avm.array")
local vector_2 = require("avm.vector_2")
local config = require("avm.config")
-- local view = require("avm.view")

-- shorthand
local vec2 = vector_2.new

describe("vector_2 basics", function()
	it("vector_2.new", function()
		local v = vec2(1, 2)

		-- element access is via indexes
		assert.is_equal(v[1], 1)
		assert.is_equal(v[2], 2)
		assert.is_equal(v[3], nil)

		-- Length is 2
		if config.NO_LEN_METAMETHOD then
			---@diagnostic disable-next-line: undefined-field
			assert.is_equal(v.n, 2)
		else
			assert.is_equal(#v, 2)
		end
		assert.is_equal(array.length(v), 2)
	end)

	it("can be copied", function()
		local v = vec2(1, 2)
		local v2 = v:copy()
		assert.is_equal(v2[1], 1)
		assert.is_equal(v2[2], 2)
	end)

	it("has swizzle accessors", function()
		local v = vec2(1, 2)
		assert.is_equal(v:x(), 1)
		assert.is_equal(v:y(), 2)

		assert.is_same({v:xy()}, {1,2})
		assert.is_same({v:yx()}, {2,1})
		assert.is_same({v:yy()}, {2,2})

		-- assign to new vec2
		local xy = vec2(v:xy())
		assert.is_true(array.all_equals(xy, {v:xy()}))
	end)

	it("can set by swizzle functions", function()
		local v = vec2(1, 2)
		-- swap x and y
		v:set_yx(v:xy())
		assert.is_true(array.all_equals(v, {2,1}))
	end)
end)

--[[
describe("vector_2 slice", function()
	it("slice constructor", function()
		local data = {1, 2, 3, 4, 5, 6}
		local v = vector_2.slice(data, 3)

		-- element access is via indexes
		assert.is_equal(v[1], 3)
		assert.is_equal(v[2], 4)
		assert.is_equal(v[3], nil) -- regular table access when index is out of bounds

		-- Length is 2
		if config.NO_LEN_METAMETHOD then
			---@diagnostic disable-next-line: undefined-field
			assert.is_equal(v.n, 2)
		else
			assert.is_equal(#v, 2)
		end
		assert.is_equal(array.length(v), 2)
	end)

	it("slice is mutable", function()
		local data = {1, 2, 3, 4, 5, 6}
		local v = vector_2.slice(data, 3)
		v[1] = 99
		v[2] = 75
		assert.is_same(data, {1, 2, 99, 75, 5, 6})
		assert.is_same({v:xy()}, {99, 75})

		-- When accessing out of bounds, a new key is added to the table
		-- and the viewed data is unchanged
		v[3] = 55
		assert.is_same(data, {1, 2, 99, 75, 5, 6})
		assert.is_same(v[3], 55)
	end)
end)
--]]

describe("vector_2 algebra", function()
	it("return type is new vector_2", function()
		local v = vec2(1, 2)
		local v2 = v:add(vec2(3, 4))
		assert.is_equal(getmetatable(v), getmetatable(v2))
	end)

	it("addition and subtraction", function()
		local v = vec2(1, 2)
		local v2 = v:add(vec2(3, 4))
		assert.is_same({v2:xy()}, {4, 6})
	end)

	it("has unary minus", function()
		local v = vec2(1, 2)
		local v2 = -v
		assert.is_same({v2:xy()}, {-1, -2})
	end)
end)

describe("vector_2 algebraic metamethods", function()
	it("return type is new vector_2", function()
		local v = vec2(1, 2)
		local v2 = v + vec2(3, 4)
		assert.is_same({v2:xy()}, {4, 6})
	end)
end)