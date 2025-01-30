setup_busted_helpers(assert)

local array = require("avm.array")
local format = require("avm.format")

describe("array stringification", function()
	it("has tostring", function()
		assert.are.same(format.array({1,2,3,4,5}),"1, 2, 3, 4, 5")
		assert.are.same(format.array({1,2,3,4,5},nil,"%d"),"1, 2, 3, 4, 5")
		assert.are.same(format.array({1,2,3,4,5},nil,"%.2f"),"1.00, 2.00, 3.00, 4.00, 5.00")

		-- NB: calls tostring if no format string is given
		-- So for strings will be unquoted
		assert.are.same(format.array({"hello","world"}),"hello, world")
	end )
end )