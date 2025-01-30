setup_busted_helpers(assert)

local array = require("avm.array")
local linalg = require("avm.linalg")

describe("vector equality", function()
	it("works", function()
		assert.is_true(linalg.equals_vec2({1,2}, {1,2}))
		assert.is_false(linalg.equals_vec2({1,2}, {1,3}))
		assert.is_true(linalg.equals_vec2({1,2}, {1,2.1}, .2)) -- bigger tolerance


		assert.is_true(linalg.equals_vec3_ex({1,2,3}, 1, {1,2,3}, 1))
		assert.is_true(linalg.equals_vec3_ex({1,2,3,4,5}, 2, {1,2,3,4,5}, 2))
		assert.is_false(linalg.equals_vec3_ex({1,2,3,4,5}, 1, {1,2,3,4,5}, 2))
	end)
end)

describe("vector element-wise operators", function()
	it("can add", function()
		local x, y, z = linalg.add_3(1,2,3, 4,5,6)
		assert.is.same({x, y, z}, {5, 7, 9})

		x, y, z = linalg.add_vec3({1,2,3}, {4,5,6})
		assert.is.same({x, y, z}, {5, 7, 9})

		x, y, z = linalg.add_vec3_constant_ex({1,2,3}, 1, 2)
		assert.is.same({x, y, z}, {3, 4, 5})
	end)

	it("can mul into", function()
		local x = {1, 2, 3, 4}
		local y = {1, 2, 3, 4}
		local result = {0, 0, 0, 0}
		linalg.mul_vec4_ex(x, 1, y, 1, result)
		assert.is.same(result, {1, 4, 9, 16})
	end)

	it("can negate", function()
		local x, y, z, w = linalg.negate_vec4({1,2,3,4})
		assert.is.same({x, y, z, w}, {-1,-2,-3,-4})
	end)
end)

describe("vector length and normalise", function()
	it("works on 2d vector", function()
		assert.equal(linalg.length_vec2({0,0}), 0)
		assert.equal(linalg.length_vec2({1,0}), 1)
		assert.equal(linalg.length_vec2({0,1}), 1)
		assert.equal(linalg.length_vec2({1,1}), math.sqrt(2))

		assert.equal(linalg.length_squared_vec2({0,0}), 0)
		assert.equal(linalg.length_squared_vec2({1,0}), 1)
		assert.equal(linalg.length_squared_vec2({0,1}), 1)
		assert.equal(linalg.length_squared_vec2({1,1}), 2)
	end)

	it("works on 2d vector", function()
		assert.is_same({linalg.normalise_vec2({1,0})}, {1,0})
		assert.is_same({linalg.normalise_vec2({0,1})}, {0,1})
		local x, y = linalg.normalise_vec2_ex({-1,1}, 1)
		assert.almost_equals({x, y}, {-1/math.sqrt(2),1/math.sqrt(2)})

		local data = { 0, 1, 0, 1 }
		assert.is_same({linalg.normalise_vec2_ex(data, 3)}, {0,1})

		local dest = array.new_array('number', 3)
		linalg.normalise_vec2_ex(data, 3, dest, 2)
		assert.is_same(array.copy_ex(dest, 2, 2), {0, 1})
	end)
end)

describe("vector inner product", function()
	it("works on 2-tuple", function()
		local test_cases = {
			-- x1,y1, x2,y2
			{ 0, 0, 0, 0, 0 },
			{ 1, 2, 3, 4, 1*3 + 2*4, },
			{ -1, -2, -3, -4, 1*3 + 2*4, }, -- negatives cancel
		}
		assert.equals(linalg.inner_product_2(table.unpack(test_cases[1])), test_cases[1][5])
		assert.equals(linalg.inner_product_2(table.unpack(test_cases[2])), test_cases[2][5])
		assert.equals(linalg.inner_product_2(table.unpack(test_cases[3])), test_cases[3][5])
	end)

	it("works on 3-tuple", function()
		local test_cases = {
			-- x1,y1,z1 x2,y2,z2
			{ 0, 0, 0, 0, 0, 0, 0 },
			{ 1, 2, 3, 4, 5, 6, 1*4 + 2*5 + 3*6 },
			{ -1, -2, -3, -4, -5, -6, 1*4 + 2*5 + 3*6 }, -- negatives cancel
		}
		assert.equals(linalg.inner_product_3(table.unpack(test_cases[1])), test_cases[1][7])
		assert.equals(linalg.inner_product_3(table.unpack(test_cases[2])), test_cases[2][7])
		assert.equals(linalg.inner_product_3(table.unpack(test_cases[3])), test_cases[3][7])
	end)
end)

describe("norms, inner products and cross products", function()
	it("can calculate vector length", function()
		-- Norms
		local x_axis = {1, 0, 0}
		local y_axis = {0, 1, 0}
		assert(linalg.length_vec3(x_axis)==1)
		assert.almost_equals(x_axis, {linalg.normalise_vec3(x_axis)})
		assert.equals(linalg.length_squared_vec3(array.add(x_axis,y_axis)),2)
	end)
	it("can do inner product as vec3", function()
		local a = {1, 2, 3}
		local b = {4, 5, 6}
		local expected_result = 32
		local result = linalg.inner_product_vec3(a, b)
		assert.equals(result, expected_result)
	end)

	it("can do cross product on vec3", function()
		local a = {1, 2, 3}
		local b = {4, 5, 6}
		local expected_result = {-3, 6, -3}
		local result = { linalg.cross_product_vec3(a, b) }
		assert.almost_equals(result, expected_result)

		local x, y, z = linalg.cross_product_vec3_ex(a, 1, b, 1)
		assert.almost_equals({x, y, z}, expected_result)

		local dest = array.new_array('number', 3)
		linalg.cross_product_vec3_ex(a, 1, b, 1, dest)
		assert.almost_equals(dest, expected_result)
	end)
end)
