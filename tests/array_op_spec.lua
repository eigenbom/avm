setup_busted_helpers(assert)

local array = require("avm.array")

describe("array arithmetic", function()
	local a = { 1,2,3 }
	local b = { 4,5,6 }

	it("can do element-wise arithmetic", function()
		-- element-wise arithmetic
		assert.are.same(array.add(a, b), {5,7,9})
		assert.are.same(array.sub(a, b), {-3,-3,-3})
		assert.are.same(array.mul(a, b), {4,10,18})
		assert.almost_equals(array.div(a, b), {.25,.4,.5})
	end)

	it("can do arithmetic into slice", function()
		-- element-wise arithmetic
		local x = {0, 0, 0, 0, 0}
		local v = array.add_ex({1,2,3}, 1, 3, {2,3,4}, 1, x, 2)
		assert.are.same(x, {0,3,5,7,0})
	end)

	it("can do constant arithmetic", function()
		-- constant arithmetic
		assert.are.same(array.add_constant(a, 1), {2,3,4})
		assert.are.same(array.sub_constant(a, 1), {0,1,2})
		assert.are.same(array.mul_constant(a, 2), {2,4,6})
		assert.almost_equals(array.div_constant(a, 2), {.5,1,1.5})

		-- Constant can be an array
		assert.are.same(array.add_constant({1,2,3,4}, {1,2}), {2,4,4,6})

		-- Inferred type in Lua Language Server should be array<number>
		---@diagnostic disable-next-line: unused-local
		local a_plus_one = array.add_constant(a, 1)
	end)
end)


describe("array equality", function()
	local epsilon = 1e-10 -- (smaller than epsilon_default)
	
	it("can check almost equality with nan", function()
		local nan = 0/0
		local x = {1, nan, 3, 4, 5}
		local y = {1+epsilon, nan, 3, 4, 5}
		assert.are.same(array.almost_equal_with_nan(x, y), {true, true, true, true, true})
	end )
end)

describe("array op special", function()
	it("can do mul add constant", function()
		-- Simulate 3 2d particles moving with velocities
		local p_t1 = { 0, 0, 0, 0, 0, 0 }
		local v = { 0, 0, 1, 0, 0, 1 }
		local timestep = .1
		local p_t2 = array.mul_add_constant(p_t1, v, timestep)
		assert.almost_equals(p_t2, {0, 0, .1, 0, 0, .1})

		array.mul_add_constant_ex(p_t2, 1, #p_t2, v, 1, timestep, p_t2)
		assert.almost_equals(p_t2, {0, 0, .2, 0, 0, .2})
	end)

	it("can do mul add constant", function()
		local a = { 0, 0, 0, 0, 0, 0 }
		local b = { 0, 0, 0, 1, 1, 0 }
		local c = { .1, .2 }
		local d = array.mul_add_constant(a, b, c)
		assert.almost_equals(d, {0, 0, 0, .2, .1, 0})
	end)

	it("can do mul add", function()
		local p = { 0, 0, 0, 0, 0, 0 }
		local v = { 0, 0, 1, 0, 0, 1 }
		local a = { 0, 0, 1, 0, 1, 0 }
		local q = array.mul_add(p, v, a)
		assert.almost_equals(q, {0, 0, 1, 0, 0, 0})
	end)
end )

describe("array lerp", function()
	it ("can lerp", function()
		local a = { 1,2,3 }
		local b = { 4,5,6 }
		assert.are.same(array.lerp(a, b, 0), {1,2,3})
		assert.are.same(array.lerp(a, b, .5), {2.5,3.5,4.5})
		assert.are.same(array.lerp(a, b, 1), {4,5,6})
	end)
end )