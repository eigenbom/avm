--[[
Format  

Functions for converting arrays into readable strings  
]]
local M = {}

------------------------------------------------------------------------
-- AVM Dependencies
------------------------------------------------------------------------
local avm_path = (...):match("(.-)[^%.]+$")

local array = require(avm_path .. "array")

---Disable warnings for _ex type overloaded functions

-----------------------------------------------------------
-- Dependencies
-----------------------------------------------------------

-- Table library
local table = require("table")
local table_concat = assert(table.concat)
local table_unpack = assert(unpack)

-- Math library
local math = require("math")
local math_max = assert(math.max)

-- String library
local string = require("string")
local string_format = assert(string.format)
local string_rep = assert(string.rep)

-----------------------------------------------------------
-- Basic stringification
-----------------------------------------------------------

---Format an array as a string of comma-separated values
---Example:
---```
---format.array({1,2,3}) --> "1, 2, 3"
---```
function M.array(src, separator, format)
	return M.slice(src, 1, array.length(src), separator, format)
end

---Format a slice as a string of comma-separated values
---Example:
---```
---format.slice({1,2,3,4}, 1, 3) --> "1, 2, 3"
---```
function M.slice(src, src_index, src_count, separator, format)
	local max_index = src_index + src_count - 1
	local strings = {}
	if format then
		for i=src_index,max_index do
			strings[#strings+1] = string_format(format, src[i])
		end
	else
		for i=src_index,max_index do
			strings[#strings+1] = tostring(src[i])
		end
	end
	return table_concat(strings, separator or ", ")
end

-----------------------------------------------------------
-- Matrix stringification
-----------------------------------------------------------

---Format a slice as a 2d matrix
---
---By default will assume the data is in column-major order, but this can be changed with the option `row_major_order = true`
---
function M.matrix(src, src_index, num_cols, num_rows, format, options)
	local row_major_order = options and options.row_major_order
	local result = {}
	for row=1,num_rows do
		local row_str = {}
		for col=1,num_cols do
			local index = row_major_order and (src_index - 1 + col+(row-1)*num_cols) or (src_index - 1 + row+(col-1)*num_rows)
			if format then
				row_str[#row_str+1] = string_format(format, src[index])
			else
				row_str[#row_str+1] = tostring(src[index])
			end
		end
		result[#result+1] = table_concat(row_str, ", ")
	end
	return table_concat(result, "\n")
end

---Format matrix
function M.mat1x1(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 1, 1, format)
end

---Format matrix
function M.mat1x2(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 1, 2, format)
end

---Format matrix
function M.mat1x3(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 1, 3, format)
end

---Format matrix
function M.mat1x4(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 1, 4, format)
end

---Format matrix
function M.mat2x1(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 2, 1, format)
end

---Format matrix
function M.mat2x2(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 2, 2, format)
end

---Format matrix
function M.mat2x3(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 2, 3, format)
end

---Format matrix
function M.mat2x4(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 2, 4, format)
end

---Format matrix
function M.mat3x1(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 3, 1, format)
end

---Format matrix
function M.mat3x2(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 3, 2, format)
end

---Format matrix
function M.mat3x3(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 3, 3, format)
end

---Format matrix
function M.mat3x4(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 3, 4, format)
end

---Format matrix
function M.mat4x1(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 4, 1, format)
end

---Format matrix
function M.mat4x2(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 4, 2, format)
end

---Format matrix
function M.mat4x3(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 4, 3, format)
end

---Format matrix
function M.mat4x4(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 4, 4, format)
end

---Format matrix
function M.mat1(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 1, 1, format)
end

---Format matrix
function M.mat2(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 2, 2, format)
end

---Format matrix
function M.mat3(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 3, 3, format)
end

---Format matrix
function M.mat4(src, format)
	assert(src, "bad argument 'src' (expected array, got nil)")
	return M.matrix(src, 1, 4, 4, format)
end

-----------------------------------------------------------
-- Readable tables of data
-----------------------------------------------------------

---Tabulate multiple arrays of data
---
---Each column is a table with some or all of the following fields:
---* `data` - the sequence or array of data
---* `index?` - the index of the first element in the sequence (default = 1)
---* `count?` - the number of elements in the sequence (default = #data)
---* `group_size?` - the number of elements in each group (default = 1)
---* `label?` - the column label (default = "")
---* `format?` - the format string for each element (default = "%s")
---
---Example output for 3 arrays storing position, index and mass:
---```
---    pos     idx   mass
---1 | 0,0,0 | 0   | 1
---2 | 0,1,0 | 1   | 1 
---3 | 2,0,1 | 2   | 1.5
---```
function M.tabulated(table_format, num_rows, column_1, ...)
	-- TODO: Auto-fit column widths etc
	local num_cols = select("#", ...)
	local result = {}
	local max_line_length = 5
	local max_row_label_width = #tostring(num_rows)
	local column_padding = 4
	local column_padding_string = string_rep(" ", column_padding)

	for i=0,num_cols do
		local column = i==0 and column_1 or select(i, ...)
		assert(column.data, "bad argument 'column.data' (expected value, got nil)")
	end

	for row_index=-1,num_rows do
		if row_index == 0 then
			-- Separator (placeholder)
			assert(#result+1==2)
			result[#result+1] = "PLACEHOLDER"
		else
			local row = row_index > 0 and {string_format("%" .. max_row_label_width .. "d", row_index)} or {""}
			for column_index=0,num_cols do
				local column = column_index==0 and column_1 or select(column_index, ...)

				if row_index == -1 then
					-- print label
					row[#row+1] = string_rep(" ", max_row_label_width) .. (column.label or "-")
				elseif row_index == 0 then
					-- print space
				else
					local group_size = column.group_size or 1
					local start_index = column.index or 1
					local index = start_index + (row_index-1)*group_size
					local max_index = column.count and (start_index-1+column.count) or array.length(column.data)
					if index > max_index then
						row[#row+1] = "-"
					else
						if column.format then
							row[#row+1] = string_format(column.format, table_unpack(column.data, index, index+group_size-1))
						else
							local entry = {}
							for i=index,index+group_size-1 do
								local value = column.data[i]
								entry[#entry+1] = tostring(value)
							end
							row[#row+1] = table_concat(entry, " ")
						end
					end
				end
			end
			local row_as_string = table_concat(row, column_padding_string)
			result[#result+1] = row_as_string
			max_line_length = math_max(max_line_length, #row_as_string)
		end
	end
	-- Adjust header separator width
	result[2] = string_rep("-", max_line_length)
	return table_concat(result, "\n")
end

return M