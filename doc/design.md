# Design of Arrays, Vectors and Matrices

This document explains some of the ideas and concepts underlying the AVM library.

## Why AVM?

I designed AVM to simplify working with arrays of numerical data in Lua (a "[numpy](https://numpy.org/) lite").

Lua has a concise syntax for operating on arrays, and so you should consider whether adding a new dependency is worth it. Take the summing of two arrays, for example:

```lua
local a = {1, 2, 3}
local b = {3, 4, 5}
-- (1) Lua
local c = {}
for i=1,#a do
	c[i] = a[i]+b[i]
end
-- (2) AVM
local c = array.add(a, b)
```

If all you needed to do was a few basic array operations then AVM is overkill and I recommend pure Lua; however, if you're regularly operating on numerical array data then AVM may save some time. Also if efficiency is critical and your environment allows it then I'd recommended using native implementations instead of AVM.

## Arrays, Sequences, Slices, and Tuples

In AVM an *Array* is any Lua object (table or userdata) with a length `n` that can be indexed from `1 .. n` and has elements all of the same type. Some other core structures used in AVM are:

* *Sequence*: A sequence is an object that can be indexed within some known range `i .. j` and has elements all of the same type.
* *Slice*: A slice refers to a portion of a sequence or array. It is modelled as three variables: `seq, index, count?`. The _ex functions in AVM typically operate on slices.
* *Tuple*: A tuple is a finite number of elements of the same type, and refers to multiple result values or multiple parameters.

Some examples of these concepts are shown below.

```lua
local arr = {x, y, z} -- An array with indices 1-3 and size 3
local arr_copy = array.copy(arr) -- Copy the array
local seq = { [6]=x, [7]=y, [8]=z } -- A table can be a sequence (the valid range is 6-8)
local copy = array.copy_ex(seq, 6, 3) -- Copy a slice of seq (elements at indices 6, 7, 8)
local a, b, c = array.get_3(seq, 6) -- Get a tuple of values (seq[6],seq[7],seq[8])
```

For examples and further definitions see the [Glossary](#glossary).

## Types

The two fundamental types used in the type annotations are:
* `array<T>`: An object with elements of type `T` within an index range of `1 .. n`
* `seq<T>`: An object with elements of type `T` within a known index range of `i .. j`

Some examples of other types include:
* `fixed_array4<number>`: A fixed-size array of 4 elements of type `number`
* `seq3<T>`: A sequence with 3 elements of type `T`
* `vec4`: An alias for `fixed_array4<number>`
* `mat4x3`: An alias for `fixed_array12<number>` representing a 4x3 matrix of numbers stored in column-major order (with 4 columns and 3 rows)
* `mat4`: Shorthand for `mat4x4`
* `vector_2`: A 2-d vector object
* `matrix_3`: A 3x3 matrix object

## Function Design

AVM encourages using types through type annotations and run-time checks. Functions in the library are annotated in [Lua Language Server (LLS)](https://github.com/LuaLS/lua-language-server) format (see [Types](#types)). To enable run-time validation of parameters and array ranges you can use the debug distribution.

Most functions also have a extended version (e.g., `array.copy` and `array.copy_ex`). The extended versions typically operate on slices rather than arrays and allow storing results in a destination array.

Functions will return multiple return values (tuples) when possible, rather than creating new objects. As an example `linalg.transpose_mat4x2` will transpose a 4x2 matrix and return the resulting 2x4 matrix as 8 values (an 8-tuple). In Lua it's straightforward to then create a table from these values: `local res = { linalg.transpose_mat4x2(...) }`. The extended version of this function `linalg.transpose_mat4x2_ex` can be used to write the result directly into an existing array instead of returning it.

Functions may store the parameter or return arity in the name (e.g., `array.set_3` and `array.set_4`) as a minor optimisation or to assist LLS with tracking types. These functions are provided up to `n=16`.

## Extensibility

AVM can work with custom objects such as [cdata](https://luajit.org/ext_ffi_api.html). There are function hooks such as `array.new_array(type, length)` which can be redefined to return custom objects, this function will then be called whenever AVM creates a new array (in `array.copy` for instance.) Furthermore a metatable can be set on an object to overload `__index`, `__newindex` and `__len` (or `n` field in Lua 5.1). View objects are a further extension mechanism that provide wrappers around objects (e.g., `array.copy(view.reverse(a))` will make a reversed copy of `a`).

Many AVM functions support specifying slices/ranges so you can operate on 0-based cdata without wrappers, for example:
```lua
local data = ffi.new("int[?]", N)
array.fill_into(3, N, data, 0) -- Fill data with 3's starting from index 0
```

## Minimal Dependencies

AVM requires the lua standard math, table and string modules. These dependencies are documented at the start of each module, and can be manually changed if necessary. Some distributions will adapt these dependencies to become compatible.

## Flattened Arrays

AVM works with flattened arrays only. Multi-dimensional data (e.g., a table of tables) will have to be flattened before using AVM functions. The array module provides some `reshape` helper functions to convert between these formats.

## Vectors And Matrix Objects

The `vector_N` and `matrix_N` modules provide objects that simplify vector and matrix operations. The objects are Lua tables extended with shorthand methods and metamethods for using `array` and `linalg` functions.

Note that for critical paths some methods should be avoided as they create new Lua objects (such as `add`/`+`). To avoid this you can use the `_into` method variants, use `linalg` directly, use system-provided vectors (e.g., (Lovr vectors)[https://lovr.org/docs/Vectors]), or pooled vector types (e.g., (Batteries)[https://github.com/1bardesign/batteries]).

For more comprehensive Matrix operations see e.g., (https://github.com/davidm/lua-matrix)[https://github.com/davidm/lua-matrix].

# Glossary

## Array

An array is an object of length `n` that can be indexed from `1 .. n` and has elements all of the same type.

Notes:
* The length of an array is defined by the `#` operator, `n` field or `length()` function
* The type `array<T>` is used in the type annotations to refer to an array of elements of type `T`

Examples:
* `a = {1, 2, 3}` is an array of numbers
* `zeros(99)` will create a new array with 99 zeros indexed from `1 .. 99`
* `array<number>` is the type describing an array of `number` elements

## Sequence

A sequence is an object that can be indexed within some range `i .. j` and has elements all of the same type. Unlike an array a sequence doesn't need to start from `1` or have a length `n`.

Notes:
* The type `seq<T>` is used in the type annotations to refer to a sequence of elements of type `T`

Examples:
* `b = {[4]=1.0, [5]=2.0, [6]=3.0}` is a sequence with three numbers
* `a = {1, 2, 3}` is a sequence (and an array)
* `seq<number>` is the type describing a sequence of `number` elements

## Slice

A slice defines a range or subset within a sequence or array, and is implemented as two or three values `seq, index, count?`.

Examples:
* `copy_ex(b, 4, 3)` will copy the valid range in sequence `b` into a new array
* `copy_ex(a, 1, #a, b, 4)` will copy array `a` into the sequence `b` starting at index `[4]`

## View

A view is a special array that maps into a subset of an array or sequence.

Examples:
* `array.copy(view.reverse(a))` will create a copy of `a` with the elements reversed

## Fixed Length Arrays

Fixed length arrays are arrays or sequences that have an immutable and known length.

Notes:
* Some functions operate on sequences or arrays with a fixed length
* Some views return fixed length arrays

Examples:
* The functions `length_vec2` and `matmul_mat3x3_mat3x3` accept an array of 2 values and two arrays of 9 values respectively
* The type aliases `array4<T>`, `seq3<T>`, `vec3`, `mat4x4`
* `view.interleaved()` provides an interleaved view into an array, but has a fixed size and cannot be appended to (for instance)

## Tuple

This library uses the word *tuple* to refer to either multiple related parameters in a function and Lua's multiple return values.

Examples:
* The statement `local x, y, z = normalise_3(v1, v2, v3)` calls a function that takes a tuple of 3 numbers and assigns the result into a tuple of 3 values
* `normalise_vec3(v)` takes a 3d vector as an array and returns a normalised vector as a tuple of 3 values
