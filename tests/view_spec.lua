setup_busted_helpers(assert)

local view = require("avm.view")
local array = require("avm.array")
local config = require("avm.config")

describe("array views", function()
	it("can create strided views", function()
		local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
		local odds = view.stride(data, 1 --[[start index]], 2 --[[stride]], 5 --[[count]])
		odds[1] = 42
		local odds_copy = array.copy(odds)
		assert.are.same(array.length(odds), 5)
		if config.NO_LEN_METAMETHOD then
			assert.are.same(odds.n, 5)
		else
			assert.are.same(#odds, 5)
		end
		assert.are.same(odds_copy, {42, 3, 5, 7, 9})
	end)

	it("can create reversed views", function()
		local data = {1, 2, 3, 4, 5}
		local rev = view.reverse(data, 5)
		assert.are.same({rev[1],rev[2],rev[3],rev[4],rev[5]}, {5, 4, 3, 2, 1})
	end)

	it("can create interleaved views", function()
		local x = 42 -- ignored data
		local data = { 1, 2, x, x, x, 5, 6, x, x, x, 9, 10, x, x, x }
		-- create view over the non-x data
		local index = 1
		local group_size = 2
		local stride = 5
		local count = 6
		local int = view.interleave(data, index, group_size, stride, count)
		assert.are.same({int[1], int[2], int[3], int[4], int[5], int[6]}, {1, 2, 5, 6, 9, 10})
	end)
end)

local has_ffi, ffi = pcall(require, "ffi")
if has_ffi then
	describe("array views on cdata", function()
		it("add a 1-based offset", function ()
			local length = 12
			local cdata_arr = ffi.new("int[?]", length)
			--NB: Create view that fixes the 0-based offset
			local cdata_off_1 = view.slice(cdata_arr, 0, length)
			array.fill_into(3, length, cdata_off_1)
			assert.are.same(array.copy(cdata_off_1), {3,3,3,3,3,3,3,3,3,3,3,3})
		end)
	end)
end
