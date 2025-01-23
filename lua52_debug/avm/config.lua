--[[
Configuration flags  

This file defines the configuration flags this library was built with  
]]
local M = {}

-------------------------------------------------------------------
-- Module feature flags
--
-- these determine what global features this library was built with
-------------------------------------------------------------------
--- Checks the type of each parameter for compatibility
--- Can be used during development for clearer type checking
M.CHECK_PARAMS = true

--- The `__len` metamethod is unsupported in Lua51
--- If built with this flag, the library will determine array size with a field `n` and fall back to `#` if `n` is undefined
M.NO_LEN_METAMETHOD = false


return M