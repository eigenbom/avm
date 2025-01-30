# Arrays, Vectors and Matrices for Lua

AVM is a pure Lua library for working with arrays, vectors and matrices. It operates on flat arrays of numerical data and provides linear algebra operations for vectors and matrices. An array is typically a Lua table, but can be any [compatible object](doc/design.md).

This README covers installation and basic examples. To dive deeper you can read the full API documentation at [doc/api.md](doc/api.md) and read about the design principles at [doc/design.md](doc/design.md). Reference tests are provided in [tests](tests).

## Installation

The library is available in different "distributions" provided in this repository (e.g, for [lua 5.1](dist/lua51)). Most of these have a `debug` variant that performs additional data validation at run-time.

To install this library first choose a distribution and copy into your local project directory. You can then require each [module](#modules) as needed. For example:

```lua
local array = require 'avm.array'

-- Create a new array a with values {1,2,3,4,5,6,7,8,9,10}
local a = array.range(1, 10)

-- Create a new array b with values {10,9,8,7,6,5,4,3,2,1}
local b = array.range(10, 1, -1)

-- Add them together and return a new array
local c = array.add(a, b)

-- Check every element of c is equal to 11
assert(array.all_equals_constant(c, 11))
```

Some distributions like [picotron](dist/picotron) come as a single `avm.lua` file that wraps all functions in an `avm` global. This file can be placed into your project and, in the case of picotron, included using the system `include` function:

```lua
include 'avm.lua'
local one_to_ten = avm.array.range(1, 10)
```

## Modules

The two most useful modules in AVM are:

* `array`: Functions for working with numerical arrays
* `linalg`: Linear algebra functions for vectors and matrices

In addition there are some helper modules:

* `vector_2`, `vector_3`, and `vector_4`: Vector objects
* `matrix_2`, `matrix_3`, and `matrix_4`: Matrix objects
* `iterator`: Special purpose iterators
* `format`: Support for printing arrays
* `view`: Special view objects

## Examples

Here are some introdutory examples. Refer to the source files or [tests][Tests] for further examples.

### Basic Usage

```lua
local zeros = array.zeros(3) -- {0,0,0}
local ones = array.fill(1, 3) -- {1,1,1}
local copy = array.copy(ones) -- create copy
assert(array.equal(ones, copy)) -- true
local first_ten = array.range(1,10) -- {1,2,...,9,10}
local thirds = array.range(0, .9, 1/3) -- {0, 1/3, 2/3}
```

```lua
local a = {1, 2, 3}
local b = {4, 5, 6}
local c = array.join(a, b) -- {1,2,3,4,5,6}
-- NOTE: Join creates a new array. Instead we can append to an existing array:
array.append(b, a)
-- a = {1,2,3,4,5,6}
```

```lua
local a = {1, 2, 3}
array.reverse(a) -- {3,2,1}
```

### Operators

Mathematical functions are provided that either operate element-wise on pairs of arrays, or operate on an array and a constant.

```lua
local ones = array.fill(1, 3) -- {1,1,1}
local first_three = array.range(1,3) -- {1,2,3}
array.add(ones, first_three) -- {2,3,4}
array.add_constant(first_three, 2) -- {3,4,5}
array.mul(first_three, first_three) -- {1,4,9}
array.pow_constant(first_three, 2) -- {1,4,9}
array.min({1,2,3},{3,2,1}) -- {1,2,1}
```

### Functional

Basic functional programming is supported with generators and maps. For more comprehensive functional programming see a library like [Batteries](https://github.com/1bardesign/batteries).

```lua
local a = {0,0,0,0,0}
array.generate_into(5, function(i) return i*0.1 end, a)
-- a = {.1,.2,.3,.4,.5}
```

```lua
local f = function(x, y) return 1+x^y; end
array.map(f, {4,3,2}, {1,2,3}) -- {5,10,9}
```

### Linear Algebra

```lua
local x = {1, 2, 3, 4}
local y = {1, 2, 3, 4}
local result = { linalg.mul_vec4(x, y) }
-- result = {1, 4, 9, 16}
```

```lua
local length = linalg.length_2(3, 4)
-- length = 5

local p = {-1, 1}
local x, y = linalg.normalise_vec2(p)
-- x, y = -1/√2, 1/√2
```

```lua
local x1, y1 = 1, 2
local x2, y2 = 3, 4
local dot = linalg.inner_product_2(x1, y1, x2, y2)
-- dot = 11
```

```lua
local a = {1, 2, 3}
local b = {4, 5, 6}
local expected_result = {-3, 6, -3}
local result = { linalg.cross_product_vec3(a, b) }
assert(array.almost_equal(result, expected_result))
```

NOTE: Matrix operations assume matrices are flat arrays stored in column-major order. Here we multiply two 2x2 matrices:

```lua
-- | 2 3 |
-- | 4 1 |
local a = {2, 4, 3, 1}

-- | 5 2 |
-- | 1 6 |
local b = {5, 1, 2, 6}

-- | 13 22 |
-- | 21 14 |
local expected = {13, 21, 22, 14}

local result = { linalg.matmul_mat2_mat2(a, b) }
assert(array.almost_equals(expected, result))
```

Multiplying a 4x4 matrix with a homogenous 3-D vector:

```lua
-- |  1  2  3  4 |
-- |  5  6  7  8 |
-- |  9 10 11 12 |
-- | 13 14 15 16 |
local a = {1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16}
local v = {1, 2, 3}
local expected_result = {18, 46, 74}
local result = { linalg.matmul_mat4_vec3(a, v) }
```

### Vector Object

Here's a brief example of using the `vector_2` module to simplify using 2D vectors:

```lua
-- Create two 2D vectors and sum them
local v1 = vector_2.new(1, 2)
local v2 = vector_2.new(3, 4)
local v3 = v1 + v2 -- or v1:add(v2)
print(v:xy()) --> "1 2"
print(v3:xy()) --> "4 6"

-- Multiply v3 by a constant `-1` and store result directly in v3
v3:mul_into(-1, v3)
print(v3:xy()) --> "-4 -6"

-- Vectors are arrays so can use array functions
local arr = array.copy(v3)
assert(arr[1] == -4 and arr[2] == -6)

-- Use linear algebra functions
local dot = linalg.inner_product_vec2(v1, v2)
assert(dot == 11)
```

### Iterator

Iterate over an array and group elements in pairs using `group`:

```lua
local arr = {1,2,3,4,5,6}
for i, a, b in iterator.group_2(arr) do
	if i==1 then
		-- a = 1, b = 2
	elseif i==2 then
		-- a = 3, b = 4
	elseif i==3 then
		-- a = 5, b = 6
	end
end
```

Iterate over two arrays with `zip`:

```lua
local as = { 1,-2, 3,-4}
local bs = {-1, 2,-3, 4}
for i, a, b in iterator.zip_1(as, bs) do
	assert(a == -b)
end
```

### View

Create a view of an array:

```lua
local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local odds_view = view.stride(data, 1 --[[start index]], 2 --[[stride]], 5 --[[count]])
assert(#odds_view == 5)
odds_view[1] = 42
assert(data[1] == 42)
local copy = array.copy(odds_view)
-- copy = {42, 3, 5, 7, 9}
```

### Userdata

(Picotron) Generate 100 random numbers and store in a userdata:

```lua
local N = 100
local ud = userdata("f64", N)
local random = function() return rnd() end
array.generate_into(N, random, ud, 0)
```

(LuaJIT) Create a cdata array with values 1 to 100:

```lua
local N = 100
local cdata = ffi.new("int[?]", N)
array.range_into(1, N, 1, cdata, 0)
```
