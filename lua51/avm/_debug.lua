---@diagnostic disable: redefined-local
---@class debug_module
local M = {}

--- Include the array module
local path = (...):match("(.-)[^%.]+$")
---@module 'avm.array'
local array -- lazy evaluation


local function __bad_arg_nil_param(name)
	return string.format("bad argument '%s' (value expected, got nil)", name)
end

local function __bad_arg_param(name, expected_type, actual_type)
	return string.format("bad argument '%s' (%s expected, got type %s)", name, expected_type, actual_type)
end

local function bad_arg_invalid_array(name, actual_type)
	return string.format("bad argument '%s' (array expected, got type %s)", name, actual_type)
end

---@param name string
---@param value any
---@param expected_type? string
function M.check(name, value, expected_type)
	if expected_type then
		local value_type = type(value)
		if value_type ~= expected_type then
			error(__bad_arg_param(name, expected_type, value_type), 2)
		end
	elseif value == nil then
		error(__bad_arg_nil_param(name), 2)
	end
end


---@param name string
---@param src SEQ
function M.check_array(name, src, _, _, level)
	if src == nil then
		error(string.format("bad argument \'%s\' (array expected, got nil)", name), (2 + (level or 0)))
	end
end


---Check the array is valid and all elements are valid
-- Disable CHECK_PARAMS to remove this check
---@generic T
---@param name string
---@param src avm.seq<T>
function M.check_array_and_size(name, src)
	---@module 'avm.array'
	array = array or require(path .. "array")
	if src == nil or not array.is_array(src) then
		error(bad_arg_invalid_array(name, type(src)), 2)
	end
	local n = array.length(src)
	if not n then
		error(string.format("bad argument '%s' (array length is nil)", name), 2)
	elseif n > 0 then
		M.check_array(name, src, 1, n, 1)
	end
end

return M