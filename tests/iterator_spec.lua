setup_busted_helpers(assert)

local array = require("avm.array")
local iterator = require("avm.iterator")

describe("iteration", function()
	it("can group as tuples", function()
		for i, a, b in iterator.group_2({1,2,3,4,5,6}) do
			if i==1 then
				assert.is_true(a==1 and b==2)
			elseif i==2 then
				assert.is_true(a==3 and b==4)
			elseif i==3 then
				assert.is_true(a==5 and b==6)
			end
		end

		local count = 0
		for _ in iterator.group_2({1,2,3,4,5,6}) do
			count = count + 1
		end
		assert.is_equal(count, 3)
	end )

	it("can group as tuples from slice", function()
		-- Slice into {2,3,4,5}
		local seq = {1,2,3,4,5,6}
		local count = 0
		for i, a, b in iterator.group_2_ex(seq, 2, 4) do
			if i==1 then
				assert.is_true(a==2 and b==3)
			elseif i==2 then
				assert.is_true(a==4 and b==5)
			else
				-- Shouldn't reach this
				assert.is_true(false)
			end

			count = count + 1
		end
		assert.is_equal(count, 2)
	end )

	--[[
	-- TODO support these
	it("can group as arrays", function()
		for i, a in iterator.group_array2({1,2,3,4,5,6}) do
			if i==1 then
				assert.is_same({a[1],a[2]}, {1,2})
			elseif i==2 then
				assert.is_same({a[1],a[2]}, {3,4})
			elseif i==3 then
				assert.is_same({a[1],a[2]}, {5,6})
			end
		end

		local count = 0
		for _ in iterator.group_array2({1,2,3,4,5,6}) do
			count = count + 1
		end
		assert.is_equal(count, 3)
	end )

	it("can group as vectors", function()
		for i, a in iterator.group_vec2({1,2,3,4,5,6}) do
			if i==1 then
				assert.is_same({a:get()}, {1,2})
			elseif i==2 then
				assert.is_same({a:get()}, {3,4})
			elseif i==3 then
				assert.is_same({a:get()}, {5,6})
			end
		end

		local count = 0
		for _ in iterator.group_vec2({1,2,3,4,5,6}) do
			count = count + 1
		end
		assert.is_equal(count, 3)
	end )
	]]

	it("has generic type annotations", function()
		-- empty test, check LLM inference interactively
		assert.is_true(true)

		---@param a boolean[]
		local function f(a)
			for i,x,y,z,w in iterator.group_4(a) do
				-- NB: x, y, z, w should all be inferred as type boolean
				assert.is_equal(type(x), "boolean")
			end
		end
	end)

	it("can zip across multiple arrays", function()
		-- Consider a and b is 2-dimensional point data, and we wish to compare each point
		local a = {1,-2,3,-4}
		local b = {-1,2,-3,4}

		local is_data_mirrored = true
		for i, ax, ay, bx, by in iterator.zip_2(a, b) do
			if ax ~= -bx or ay ~= -by then
				is_data_mirrored = false
				break
			end
		end
		assert.is_true(is_data_mirrored)
	end )
end)