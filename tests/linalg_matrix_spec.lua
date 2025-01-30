setup_busted_helpers(assert)

local array = require("avm.array")
local linalg = require("avm.linalg")

describe("matrix equality", function()
	it("works", function()
		assert.is_true(linalg.equals_mat2({1,2,1,2}, {1,2,1,2}))
		assert.is_false(linalg.equals_mat2({1,2,1,2}, {2,1,2,1}))
		assert.is_true(linalg.equals_mat2({1,2,1,2}, {1,2,1,2}, .2)) -- bigger tolerance

		assert.is_true(linalg.equals_mat3_ex({1,2,3,4,5,6,7,8,9}, 1, {1,2,3,4,5,6,7,8,9}, 1))
		assert.is_false(linalg.equals_mat3_ex({1,2,3,4,5,6,7,8,9,10}, 2, {1,2,3,4,5,6,7,8,9}, 1))
	end)
end)

describe("matrix element-wise operators", function()
	it("can add", function()
		local res = { linalg.add_mat2({1,2,3,4}, {5,6,7,8}) }
		assert.is.same(res, {6, 8, 10, 12})

		res = { linalg.add_mat2_constant_ex({1,2,3,4}, 1, 2) }
		assert.is.same(res, {3, 4, 5, 6})
	end)

	it("can mul into", function()
		local x = {1, 2, 3, 4}
		local y = {1, 2, 3, 4}
		local result = {0, 0, 0, 0}
		linalg.mul_mat2_ex(x, 1, y, 1, result)
		assert.is.same(result, {1, 4, 9, 16})
	end)

	it("can negate", function()
		local a, b, c, d = linalg.negate_mat2({1,2,3,4})
		assert.is.same({a, b, c, d}, {-1,-2,-3,-4})
	end)
end)

describe("matrix 2x2 operations", function()
	local ident = { 1, 0, 0, 1 }

	it("can multiply with identity", function()
		local result = { linalg.matmul_mat2_mat2(ident, ident) }
		assert.almost_equals(ident, result)

		local numbers = { 1, 2, 3, 4 }
		result = { linalg.matmul_mat2_mat2(ident, numbers) }
		assert.almost_equals(numbers, result)
	end)

	it("can multiply", function()
		local a = {2, 4, 3, 1}
		local b = {5, 1, 2, 6}
		local expected = { 13, 21, 22, 14 }
		local result = { linalg.matmul_mat2_mat2(a, b) }
		assert.almost_equals(expected, result)
	end)
end)

describe("matrix 4x4 operations", function()
	local ident = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	
	it("can multiply with identity", function()
		local result = { linalg.matmul_mat4_mat4(ident, ident) }
		assert.almost_equals(ident, result)
		
		local numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
		result = { linalg.matmul_mat4_mat4(ident, numbers) }
		assert.almost_equals(numbers, result)

		numbers = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
		linalg.matmul_mat4_mat4_ex(ident, 1, numbers, 1, result)
		assert.almost_equals(numbers, result)
	end)

	it("can multiply rotate and unrotate", function()
		local rotate = {0,1,0,0, -1,0,0,0, 0,0,1,0, 0,0,0,1}
		local anti_rotate = {0,-1,0,0, 1,0,0,0, 0,0,1,0, 0,0,0,1}
		local no_rotate = { linalg.matmul_mat4_mat4(rotate, anti_rotate) }
		assert.almost_equals(no_rotate, ident)
	end)

	it("can multiply matrices", function()
		local a = {1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16}
		local b = {16, 12, 8, 4, 15, 11, 7, 3, 14, 10, 6, 2, 13, 9, 5, 1}
		local expected_result = array.new_array('number', 16)
		linalg.transpose_mat4_ex({80, 70, 60, 50, 240, 214, 188, 162, 400, 358, 316, 274, 560, 502, 444, 386}, 1, expected_result)
		local result = { linalg.matmul_mat4_mat4(a, b) }
		assert.almost_equals(result, expected_result)
	end)
end)

describe("matrix nxm operations", function()
	it("can multiply a 1x2 and 2x1 matrix", function()
		--[[
			[1] * [2] = [2]
			[2]         [4]
		]]
		local a = { 1, 2 } -- 1x2
		local b = { 2 } -- 1x1
		local result = { linalg.matmul_mat1x2_mat1x1( a, b ) }
		assert.almost_equals( result, { 2, 4 })
	end )

	
	it("can multiply a 2x1 and 1x2 matrix", function()
		--[[
		[1 2] * [2] = [8]
		        [3]
		]]
		local a = { 1, 2 } -- 2x1
		local b = { 2, 3 } -- 1x2
		local result = { linalg.matmul_mat2x1_mat1x2( a, b ) }
		assert.almost_equals( result, { 8 })
	end )
	
	it("can multiply a 3x4 and 4x3 matrix", function()
		local a = {1, 5, 9, 13,   2, 6, 10, 14,   3, 7, 11, 15 } -- 3x4
		local b = {16, 12, 8,   15, 11, 7,   14, 10, 6,   13, 9, 5} -- 4x3
		local expected_result = { linalg.transpose_mat4({64, 58, 52, 46,   208, 190, 172, 154,   352, 322, 292, 262,   496, 454, 412, 370}) }
		local result = { linalg.matmul_mat3x4_mat4x3(a, b) }
		assert.almost_equals(result, expected_result)

		local dest = array.new_array('number', 16)
		linalg.matmul_mat3x4_mat4x3_ex(a, 1, b, 1, dest, 1)
		assert.almost_equals(dest, expected_result)
	end)
end)

describe("matrix range operations", function()
	it("can multiply a 2x1 and 1x2 matrix in a range", function()
			--[[
			[1 2] * [2] = [8]
			        [3]
			]]
			local x = -1 -- ignore

			-- data arrays storing sequence of 2x1 and 1x2 matrices
			local a = { x, x, 1, 2, x, x, x, x } -- array of 2x1 matrices
			local b = { x, x, x, x, x, x, 2, 3 } -- array of 1x2 matrices

			local result = { linalg.matmul_mat2x1_mat1x2_ex( a, 3, b, 7 ) }
			assert.almost_equals( result, { 8 })
	end )
end)

describe("matrix and vector operations", function()
	local ident_2 = { linalg.mat2_identity() }
	local ident_3 = { linalg.mat3_identity() }
	local ident_4 = { linalg.mat4_identity() }

	local zero_2 = { linalg.mat2_zero() }
	local zero_3 = { linalg.mat3_zero() }
	local zero_4 = { linalg.mat4_zero() }

	it("can multiply with zero", function()
		local result = { linalg.matmul_mat2_vec2(zero_2, {1,2} ) }
		assert.almost_equals(result, {0, 0})

		result = { linalg.matmul_mat3_vec3(zero_3, {1,2,3} ) }
		assert.almost_equals(result, {0, 0, 0})

		result = { linalg.matmul_mat4_vec4(zero_4, {1,2,3,4} ) }
		assert.almost_equals(result, {0, 0, 0, 0})
	end)
	
	it("can multiply with identity", function()
		local result = { linalg.matmul_mat2_vec2(ident_2, {1,2} ) }
		assert.almost_equals(result, {1,2})

		result = { linalg.matmul_mat3_vec3(ident_3, {1,2,3} ) }
		assert.almost_equals(result, {1,2,3})

		result = { linalg.matmul_mat4_vec4(ident_4, {1,2,3,4} ) }
		assert.almost_equals(result, {1,2,3,4})
	end)

	it("can multiply mat4 and vec4", function()
		local a = {1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16}
		local v = {1, 2, 3, 1}
		local expected_result = {18, 46, 74, 102}
		local result = { linalg.matmul_mat4_vec4(a, v) }
		assert.almost_equals(result, expected_result)
	end)

	it("can multiply mat3 and vec2 as homogeneous transform", function()
		local a = {1, 2, 3, 4, 5, 6, 7, 8, 9}
		local v = {1, 2}
		local expected_result = {16, 20}
		local result = { linalg.matmul_mat3_vec2(a, v) }
		assert.almost_equals(result, expected_result)
	end)

	it("can multiply mat4 and vec3 as homogeneous transform", function()
		local a = {1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16}
		local v = {1, 2, 3} -- considered below as vector with w = 1
		local expected_result = {18, 46, 74}
		local result = { linalg.matmul_mat4_vec3(a, v) }
		assert.almost_equals(result, expected_result)
	end)
end )

describe("matrix transformations", function()

	it("can do mat3 transforms", function()
		local I = { linalg.mat3_identity() }
		-- shorthand
		local T = linalg.mat3_translate
		local R = linalg.mat3_rotate_around_axis
		local S = linalg.mat3_scale

		local vmul = linalg.matmul_mat3_vec2
		local matmul = linalg.matmul_mat3_mat3

		assert.almost_equals({vmul({T(1,0)},{0,0})},{1,0})
		assert.almost_equals({matmul({T(1,0)},{T(-1,0)})},I)
		assert.almost_equals({R(math.pi/2, 0,0,1)}, {0,1,0, -1,0,0, 0,0,1})
		assert.almost_equals({vmul({S(2,0,1)},{1,2})},{2,0})
		assert.almost_equals({vmul({S(2,3,1)},{1,2})},{2,6})

		local scale_zero = {matmul({S(1,0,1)},{S(0,1,1)})}
		assert.almost_equals(scale_zero, {0,0,0, 0,0,0, 0,0,1})
	end)

	it("can do mat4 transforms", function()
		local I = { linalg.mat4_identity() }
		-- shorthand
		local T = linalg.mat4_translate
		local R = linalg.mat4_rotate_around_axis
		local S = linalg.mat4_scale

		local vmul = linalg.matmul_mat4_vec3
		local matmul = linalg.matmul_mat4_mat4

		assert.almost_equals({vmul({T(1,0,0)},{0,0,0})},{1,0,0})
		assert.almost_equals({matmul({T(1,0,0)},{T(-1,0,0)})},I)
		assert.almost_equals({R(math.pi/2,0,0,1)}, {0,1,0,0, -1,0,0,0, 0,0,1,0, 0,0,0,1})
		assert.almost_equals({vmul({S(2,0,0)},{1,2,3})},{2,0,0})
		assert.almost_equals({vmul({S(2,3,4)},{1,2,3})},{2,6,12})
		local scale_zero = {matmul({S(1,0,0)},{S(0,1,0)})}
		assert.almost_equals(scale_zero, {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1})
	end)
end)