setup_busted_helpers(assert)

local array = require("avm.array")
local matrix_2 = require("avm.matrix_2")
local linalg = require("avm.linalg")
local vector_2 = require("avm.vector_2")

-- shorthand
local mat2 = matrix_2.new
local vec2 = vector_2.new

describe("matrix_2 basics", function()
	it("matrix_2.new", function()
		local m = mat2(1, 0, 0, 1)
		assert.is_same(array.length(m), 4)
		assert.is_same({m:get()}, {1,0,0,1})
		m:set(2,3,4,5)
		assert.is_same({m:get()}, {2,3,4,5})
	end)

	it("matrix_2 errors", function()
		---@diagnostic disable-next-line: missing-parameter
		assert.has_error(function() mat2(1,2,3) end) -- Needs correct number of args
	end)
end)

describe("matrix_2 algebra", function()
	it("adds and subtracts", function()
		local m1 = mat2(1, 2, 3, 4)
		local m2 = mat2(-1, -2, -3, -4)
		assert.is_same({(m1+m2):get()}, {0,0,0,0})
		assert.is_same({(m1-m2):get()}, {2,4,6,8})

		-- m2 = m1 + m1
		m1:add_into(m1, m2)
		assert.is_same({m2:get()}, {2,4,6,8})
	end)

	it("multiplies and divides", function()
		local m1 = mat2(1, 2, 3, 4)
		local m2 = mat2(-1, -2, -3, -4)
		assert.is_same({(m1 * m2):get()}, {-1,-4,-9,-16})
		assert.is_same({(m1 / m2):get()}, {-1,-1,-1,-1})
	end)

	it("also accepts constant", function()
		local m1 = mat2(1, 2, 3, 4)
		assert.is_same(array.length(m1 * 2), 4)
		assert.is_same({(m1 * 2):get()}, {2,4,6,8})
		assert.is_same({(m1 + 1):get()}, {2,3,4,5})
	end)

	it("negates", function()
		local m1 = mat2(1, 2, 3, 4)
		local m2 = -m1
		assert.is_same({m2:get()}, {-1,-2,-3,-4})
	end)

	it("has matrix multiplication", function()
		local ident = mat2(1, 0, 0, 1)
		local m2 = mat2(1, 2, 3, 4)
		assert.is_same({m2:matmul(m2):get()}, {7,10,15,22})

		assert.is_same({(ident:matmul(m2)):get()}, {m2:get()})
	end)
end)

describe("linear algebra", function()
	it("works with matrices", function()
		local ident = mat2(1, 0, 0, 1)
		local v = vec2(3, 4)
		local res = vec2(linalg.matmul_mat2_vec2(ident, v))
		assert.is_same({res:get()}, {3,4})
	end)
end)