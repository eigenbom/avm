-- add build/ to package path
package.path = package.path .. ";build/?.lua"

local array = require("avm.array")
local format = require("avm.format")

local tests = {
	function()
		print("Test format.array")
		local data = array.range(10, 100, 10)
		print(format.array(data))
	end,

	function()
		print("Test format.slice")
		local data = array.range(1, 100, 0.1)
		print(format.slice(data, 42, 20))
	end,

	function()
		print("Test format.tabulated, basic function")
		local data = array.range(10, 100, 10) -- 10, 20, 30, ..., 100
		print(format.tabulated(nil, #data, {data=data}))
	end,

	function()
		print("Test format.matrix, basic function")

		local ident = { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
		print("\nidentity:")
		print(format.matrix(ident, 1, 3, 3))

		local mat3_indexes = { "[col 1, row 1]", "[col 1, row 2]", "[col 1, row 3]", "[col 2, row 1]", "[col 2, row 2]", "[col 2, row 3]", "[col 3, row 1]", "[col 3, row 2]", "[col 3, row 3]" }
		print("\nindexes:")
		print(format.matrix(mat3_indexes, 1, 3, 3, "\"%s\""))

		local mat3_indexes_row_major = { "[row 1, col 1]", "[row 1, col 2]", "[row 1, col 3]", "[row 2, col 1]", "[row 2, col 2]", "[row 2, col 3]", "[row 3, col 1]", "[row 3, col 2]", "[row 3, col 3]" }
		print("\nindexes (row major):")
		print(format.matrix(mat3_indexes_row_major, 1, 3, 3, "\"%s\"", {row_major_order=true}))
	end,

	function()
		print("Test format.mat, basic function")

		print("\nmat2 identity:")
		print(format.mat2({ 1, 0, 0, 1 }))

		print("\nmat3 identity:")
		print(format.mat3({ 1, 0, 0, 0, 1, 0, 0, 0, 1 }))

		print("\nmat4 identity:")
		print(format.mat4({ 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }))
	end,

	function()
		print("Test format.tabulated, multiple arrays, grouping and custom format")
		local position = {0,0,0,  1,0,0,  0,1,0,  1,1,0,  2,2,2 }
		local colour   = {1,1,0,  0,1,1} -- intentionally omit last colour
		print(format.tabulated(nil, 4, 
			-- NOTE: we're specifying a slice pos[group_2:group_4]
			-- index = 1 + group_size ( start group at 2 )
			-- count = 3 * group_size ( for 3 groups )
			{label="pos", data=position, group_size=3, index=4, count=9, format="%d,%d,%d"},
			-- NOTE: format is optional
			{label="col", data=colour, group_size=3}
		))
	end,
}

for _, test in ipairs(tests) do
	test()
	print()
end