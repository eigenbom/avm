# array
Functions for working with numerical arrays  

Examples:  
```lua  
-- Create a new array `a` with values {1,2,3,4,5,6,7,8,9,10}  
-- Create a new array `b` with values {10,9,8,7,6,5,4,3,2,1}  
local a = array.range(1, 10)  
local b = array.range(10, 1, -1)  

-- Add them together  
local c = array.add(a, b)  

-- Check every element is equal to 11  
assert(array.all_equals_constant(c, 11))  
```  

## array.add

```lua
function array.add(a: array<T>, b: seq<T>)
  -> array<number>
```

Apply the addition operator to two arrays

`{a[i]+b[i]}` for all `i` in `[1, #a]`

## array.add_constant

```lua
function array.add_constant(a: array<T>, c: T|array<T>)
  -> array<number>
```

Apply the addition operator to each element of an array with a constant

`{a[i]+c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.add_constant_ex

```lua
function array.add_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element of a slice with a constant and store the result in a destination

## array.add_constant_ex

```lua
function array.add_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<number>
```

Apply the addition operator to each element of a slice with a constant

## array.add_ex

```lua
function array.add_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<number>
```

Apply the addition operator to two slices and return the result

## array.add_ex

```lua
function array.add_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the addition operator to two slices and store the result in a destination

## array.all_almost_equals

```lua
function array.all_almost_equals(a: array<number>, b: array<number>, epsilon?: number)
  -> boolean
```

true if the arrays are almost equal (differ by epsilon or less)

## array.all_almost_equals_constant

```lua
function array.all_almost_equals_constant(a: array<number>, constant: number, epsilon?: number)
  -> boolean
```

 true if all the elements are almost equal to the constant (differ by epsilon or less)

## array.all_almost_equals_constant_ex

```lua
function array.all_almost_equals_constant_ex(a: seq_number, a_index: integer, a_count: integer, constant: number, epsilon?: number)
  -> boolean
```

 true if all the elements are almost equal to the constant (differ by epsilon or less)

## array.all_almost_equals_ex

```lua
function array.all_almost_equals_ex(a: seq_number, a_index: integer, a_count: integer, b: seq_number, b_index: integer, epsilon?: number)
  -> boolean
```

true if a[1,#a] and b[1,#a] are almost equal (differ by epsilon or less)

## array.all_almost_equals_with_nan

```lua
function array.all_almost_equals_with_nan(a: array<number>, b: array<number>, epsilon?: number)
  -> boolean
```

true if a[1,#a] and b[1,#a] are almost equal (differ by epsilon or less)

nan is considered equal to itself

## array.all_equals

```lua
function array.all_equals(a: array<T>, b: array<T>)
  -> boolean
```

true if the arrays are equal and #a==#b

## array.all_equals_constant

```lua
function array.all_equals_constant(a: array<T>, constant: T)
  -> boolean
```

 true if all the elements are equal to the constant

## array.all_equals_constant_ex

```lua
function array.all_equals_constant_ex(a: seq<T>, a_index: integer, a_count: integer, constant: T)
  -> boolean
```

 true if all the elements are equal to the constant

## array.all_equals_ex

```lua
function array.all_equals_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean
```

true if the slices are equal

## array.almost_equal

```lua
function array.almost_equal(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the almost equal operator to two arrays

`{|a[i]-b[i]| < eps}` for all `i` in `[1, #a]`

## array.almost_equal_constant

```lua
function array.almost_equal_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the almost equal operator to each element of an array with a constant

`{|a[i]-c| < eps}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.almost_equal_constant_ex

```lua
function array.almost_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the almost equal operator to each element of a slice with a constant and store the result in a destination

## array.almost_equal_constant_ex

```lua
function array.almost_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the almost equal operator to each element of a slice with a constant

## array.almost_equal_ex

```lua
function array.almost_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the almost equal operator to two slices and return the result

## array.almost_equal_ex

```lua
function array.almost_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the almost equal operator to two slices and store the result in a destination

## array.almost_equal_with_nan

```lua
function array.almost_equal_with_nan(a: array<T>, b: seq<T>)
  -> seq<boolean>
```

Apply the almost equal (but NaN==NaN) operator to two arrays

`{|a[i]-b[i]| < eps}` for all `i` in `[1, #a]`

## array.almost_equal_with_nan_ex

```lua
function array.almost_equal_with_nan_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> seq<boolean>
```

Apply the almost equal (but NaN==NaN) operator to two slices and return the result

## array.almost_equal_with_nan_ex

```lua
function array.almost_equal_with_nan_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: boolean[], dest_index?: integer)
  -> nil
```

Apply the almost equal (but NaN==NaN) operator to two slices and store the result in a destination

## array.append

```lua
function array.append(src: array<T>, dest: array<T>)
```

Append an array `src` onto the end of an array `dest`

Equivalent to `copy_into(src, dest, length(dest))`

## array.copy

```lua
function array.copy(src: array<T>)
  -> array<T>
```

Copy an array elements into a new array

## array.copy_array

```lua
function array.copy_array(src: seq<T>, src_index: integer, src_count: integer)
  -> array<T>
```

Copy an array

Defaults to copying each element within a for loop

Optionally redefine this to support custom platform and userdata

## array.copy_array_into

```lua
function array.copy_array_into(src: seq<T>, src_index: integer, src_count: integer, dest: seq<T>, dest_index: integer)
```

Copy an array

Defaults to copying each element within a for loop

Optionally redefine this to support custom platform and userdata

## array.copy_ex

```lua
function array.copy_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> array<T>
```

Copy a slice

## array.copy_ex

```lua
function array.copy_ex(src: seq<T>, src_index: integer, src_count: integer, dest: seq<T>, dest_index?: integer)
  -> nil
```

Copy a slice to a destination

## array.div

```lua
function array.div(a: array<T>, b: seq<T>)
  -> array<number>
```

Apply the division operator to two arrays

`{a[i]/b[i]}` for all `i` in `[1, #a]`

## array.div_constant

```lua
function array.div_constant(a: array<T>, c: T|array<T>)
  -> array<number>
```

Apply the division operator to each element of an array with a constant

`{a[i]/c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.div_constant_ex

```lua
function array.div_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<number>
```

Apply the division operator to each element of a slice with a constant

## array.div_constant_ex

```lua
function array.div_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the division operator to each element of a slice with a constant and store the result in a destination

## array.div_ex

```lua
function array.div_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<number>
```

Apply the division operator to two slices and return the result

## array.div_ex

```lua
function array.div_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the division operator to two slices and store the result in a destination

## array.equal

```lua
function array.equal(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the equal operator to two arrays

`{a[i]==b[i]}` for all `i` in `[1, #a]`

## array.equal_constant

```lua
function array.equal_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the equal operator to each element of an array with a constant

`{a[i]==c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.equal_constant_ex

```lua
function array.equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the equal operator to each element of a slice with a constant

## array.equal_constant_ex

```lua
function array.equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the equal operator to each element of a slice with a constant and store the result in a destination

## array.equal_ex

```lua
function array.equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the equal operator to two slices and store the result in a destination

## array.equal_ex

```lua
function array.equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the equal operator to two slices and return the result

## array.extend

```lua
function array.extend(dest: array<T>, src: array<T>)
```

Extend an array `dest` with `src`

Equivalent to `copy_into(src, dest, length(dest))`

## array.fill

```lua
function array.fill(constant: T, count: integer)
  -> array<T>
```

create an array filled with a constant value

## array.fill_into

```lua
function array.fill_into(constant: T, count: integer, dest: seq<T>, dest_index?: integer)
```

fill a sequence with a constant

## array.flatten

```lua
function array.flatten(src: any)
  -> any[]
```

Flatten a table of data

Example:
* `flatten({{1,2,3},{4,5,6}}})` -> `{1,2,3,4,5,6}`

## array.flatten_into

```lua
function array.flatten_into(src: any, dest: any, dest_index?: integer)
```

Flatten a table of data into a destination

Example:
* `flatten({{1,2,3},{4,5,6}}})` -> `{1,2,3,4,5,6}`

## array.generate

```lua
function array.generate(count: integer, f: fun(index: integer):<T>)
  -> array<T>
```

Return a new an array with elements
`f(i)` for `i` in `[1,count]`

## array.generate_into

```lua
function array.generate_into(count: integer, f: fun(index: integer):<T>, dest: seq<T>, dest_index?: integer)
```

Fill a destination with elements
`f(i)` for `i` in `[1,count]`

## array.get_2

```lua
function array.get_2(src: seq<T>, src_index: integer)
  -> T, T
```

Get 2 values from a slice

## array.get_3

```lua
function array.get_3(src: seq<T>, src_index: integer)
  -> T, T, T
```

Get 3 values from a slice

## array.get_4

```lua
function array.get_4(src: seq<T>, src_index: integer)
  -> T * 4
```

Get 4 values from a slice

## array.get_5

```lua
function array.get_5(src: seq<T>, src_index: integer)
  -> T * 5
```

Get 5 values from a slice

## array.get_6

```lua
function array.get_6(src: seq<T>, src_index: integer)
  -> T * 6
```

Get 6 values from a slice

## array.get_7

```lua
function array.get_7(src: seq<T>, src_index: integer)
  -> T * 7
```

Get 7 values from a slice

## array.get_8

```lua
function array.get_8(src: seq<T>, src_index: integer)
  -> T * 8
```

Get 8 values from a slice

## array.get_9

```lua
function array.get_9(src: seq<T>, src_index: integer)
  -> T * 9
```

Get 9 values from a slice

## array.get_10

```lua
function array.get_10(src: seq<T>, src_index: integer)
  -> T * 10
```

Get 10 values from a slice

## array.get_11

```lua
function array.get_11(src: seq<T>, src_index: integer)
  -> T * 11
```

Get 11 values from a slice

## array.get_12

```lua
function array.get_12(src: seq<T>, src_index: integer)
  -> T * 12
```

Get 12 values from a slice

## array.get_13

```lua
function array.get_13(src: seq<T>, src_index: integer)
  -> T * 13
```

Get 13 values from a slice

## array.get_14

```lua
function array.get_14(src: seq<T>, src_index: integer)
  -> T * 14
```

Get 14 values from a slice

## array.get_15

```lua
function array.get_15(src: seq<T>, src_index: integer)
  -> T * 15
```

Get 15 values from a slice

## array.get_16

```lua
function array.get_16(src: seq<T>, src_index: integer)
  -> T * 16
```

Get 16 values from a slice

## array.greater_than

```lua
function array.greater_than(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the greater than operator to two arrays

`{a[i]>b[i]}` for all `i` in `[1, #a]`

## array.greater_than_constant

```lua
function array.greater_than_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the greater than operator to each element of an array with a constant

`{a[i]>c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.greater_than_constant_ex

```lua
function array.greater_than_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than operator to each element of a slice with a constant and store the result in a destination

## array.greater_than_constant_ex

```lua
function array.greater_than_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the greater than operator to each element of a slice with a constant

## array.greater_than_ex

```lua
function array.greater_than_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the greater than operator to two slices and return the result

## array.greater_than_ex

```lua
function array.greater_than_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than operator to two slices and store the result in a destination

## array.greater_than_or_equal

```lua
function array.greater_than_or_equal(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the greater than or equal to operator to two arrays

`{a[i]>=b[i]}` for all `i` in `[1, #a]`

## array.greater_than_or_equal_constant

```lua
function array.greater_than_or_equal_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the greater than or equal to operator to each element of an array with a constant

`{a[i]>=c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.greater_than_or_equal_constant_ex

```lua
function array.greater_than_or_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the greater than or equal to operator to each element of a slice with a constant

## array.greater_than_or_equal_constant_ex

```lua
function array.greater_than_or_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than or equal to operator to each element of a slice with a constant and store the result in a destination

## array.greater_than_or_equal_ex

```lua
function array.greater_than_or_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than or equal to operator to two slices and store the result in a destination

## array.greater_than_or_equal_ex

```lua
function array.greater_than_or_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the greater than or equal to operator to two slices and return the result

## array.grow_array

```lua
function array.grow_array(dest: seq<T>, dest_index: integer, dest_count: integer)
```

Grow an array or sequence to span the range [index, index + count - 1]

Optionally redefine this to support custom platform and userdata

## array.is_array

```lua
function array.is_array(src: any)
  -> boolean
```

Determines if src is an array

Optionally redefine this to support custom platform and userdata

## array.is_seq

```lua
function array.is_seq(src: any)
  -> boolean
```

Determines if src is a seq

Optionally redefine this to support custom platform and userdata

## array.join

```lua
function array.join(a: array<T>, b: array<T>)
  -> array<T>
```

Create an array with elements `[a_1, ..., a_n, b_1, ..., b_n]`

## array.join_ex

```lua
function array.join_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, b_count: integer)
  -> array<T>
```

Return an array with elements `[a_i, ..., a_(i+count), b_i, ..., b_(i+count)]`

## array.length

```lua
function array.length(src: any)
  -> integer
```

Returns the length of an array

Optionally redefine this to support custom platform and userdata

## array.lerp

```lua
function array.lerp(a: array<T>, b: seq<T>, t: number)
  -> array<T>
```

Linearly interpolate between arrays and return an array

`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`

## array.lerp_ex

```lua
function array.lerp_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, t: number)
  -> array<T>
```

Linearly interpolate between slices and return an array

`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`

## array.lerp_ex

```lua
function array.lerp_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, t: number, dest: seq<T>, dest_index?: integer)
  -> nil
```

Linearly interpolate between slices into a destination

`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`

## array.less_than

```lua
function array.less_than(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the less than operator to two arrays

`{a[i]<b[i]}` for all `i` in `[1, #a]`

## array.less_than_constant

```lua
function array.less_than_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the less than operator to each element of an array with a constant

`{a[i]<c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.less_than_constant_ex

```lua
function array.less_than_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the less than operator to each element of a slice with a constant

## array.less_than_constant_ex

```lua
function array.less_than_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than operator to each element of a slice with a constant and store the result in a destination

## array.less_than_ex

```lua
function array.less_than_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the less than operator to two slices and return the result

## array.less_than_ex

```lua
function array.less_than_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than operator to two slices and store the result in a destination

## array.less_than_or_equal

```lua
function array.less_than_or_equal(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the less than or equal to operator to two arrays

`{a[i]<=b[i]}` for all `i` in `[1, #a]`

## array.less_than_or_equal_constant

```lua
function array.less_than_or_equal_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the less than or equal to operator to each element of an array with a constant

`{a[i]<=c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.less_than_or_equal_constant_ex

```lua
function array.less_than_or_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the less than or equal to operator to each element of a slice with a constant

## array.less_than_or_equal_constant_ex

```lua
function array.less_than_or_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than or equal to operator to each element of a slice with a constant and store the result in a destination

## array.less_than_or_equal_ex

```lua
function array.less_than_or_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the less than or equal to operator to two slices and return the result

## array.less_than_or_equal_ex

```lua
function array.less_than_or_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than or equal to operator to two slices and store the result in a destination

## array.map

```lua
function array.map(f: fun(v1: <T1>):<U>, a1: array<T1>)
  -> array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i])` for each `i` over the range `[1, #a1]`

## array.map_2

```lua
function array.map_2(f: fun(v1: <T1>, v2: <T2>):<U>, a1: array<T1>, a2: array<T2>)
  -> array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i], a2[i])` for each `i` over the range `[1, #a1]`

## array.map_2_ex

```lua
function array.map_2_ex(f: fun(v1: <T1>, v2: <T2>):<U>, a1: seq<T1>, a1_index: any, a1_count: any, a2: seq<T2>, a2_index: integer)
  -> array<U>
```

Apply a function to each element of the sequences and return an array

## array.map_2_ex

```lua
function array.map_2_ex(f: fun(v1: <T1>, v2: <T2>):<U>, a1: seq<T1>, a1_index: any, a1_count: any, a2: seq<T2>, a2_index: integer, dest: seq<U>, dest_index?: integer)
  -> seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## array.map_3

```lua
function array.map_3(f: fun(v1: <T1>, v2: <T2>, v3: <T3>):<U>, a1: array<T1>, a2: array<T2>, a3: array<T3>)
  -> array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i], a2[i], a3[i])` for each `i` over the range `[1, #a1]`

## array.map_3_ex

```lua
function array.map_3_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>):<U>, a1: seq<T1>, a1_index: any, a1_count: any, a2: seq<T2>, a2_index: any, a3: seq<T3>, a3_index: integer, dest: seq<U>, dest_index?: integer)
  -> seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## array.map_3_ex

```lua
function array.map_3_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>):<U>, a1: seq<T1>, a1_index: any, a1_count: any, a2: seq<T2>, a2_index: any, a3: seq<T3>, a3_index: integer)
  -> array<U>
```

Apply a function to each element of the sequences and return an array

## array.map_4

```lua
function array.map_4(f: fun(v1: <T1>, v2: <T2>, v3: <T3>, v4: <T4>):<U>, a1: array<T1>, a2: array<T2>, a3: array<T3>, a4: array<T4>)
  -> array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i], a2[i], a3[i], a4[i])` for each `i` over the range `[1, #a1]`

## array.map_4_ex

```lua
function array.map_4_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>, v4: <T4>):<U>, a1: seq<T1>, a1_index: any, a1_count: any, a2: seq<T2>, a2_index: any, a3: seq<T3>, a3_index: any, a4: seq<T4>, a4_index: integer)
  -> array<U>
```

Apply a function to each element of the sequences and return an array

## array.map_4_ex

```lua
function array.map_4_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>, v4: <T4>):<U>, a1: seq<T1>, a1_index: any, a1_count: any, a2: seq<T2>, a2_index: any, a3: seq<T3>, a3_index: any, a4: seq<T4>, a4_index: integer, dest: seq<U>, dest_index?: integer)
  -> seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## array.map_ex

```lua
function array.map_ex(f: fun(v1: <T1>):<U>, a1: seq<T1>, a1_index: integer, a1_count: integer)
  -> array<U>
```

Apply a function to each element of the sequences and return an array

## array.map_ex

```lua
function array.map_ex(f: fun(v1: <T1>):<U>, a1: seq<T1>, a1_index: integer, a1_count: integer, dest: seq<U>, dest_index?: integer)
  -> seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## array.max

```lua
function array.max(a: array<T>, b: seq<T>)
  -> array<T>
```

Apply the maximum operator to two arrays

`{max(a[i],b[i])}` for all `i` in `[1, #a]`

## array.max_constant

```lua
function array.max_constant(a: array<T>, c: T|array<T>)
  -> array<T>
```

Apply the maximum operator to each element of an array with a constant

`{max(a[i],c)}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.max_constant_ex

```lua
function array.max_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<T>
```

Apply the maximum operator to each element of a slice with a constant

## array.max_constant_ex

```lua
function array.max_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<T>, dest_index?: integer)
  -> nil
```

Apply the maximum operator to each element of a slice with a constant and store the result in a destination

## array.max_ex

```lua
function array.max_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<T>
```

Apply the maximum operator to two slices and return the result

## array.max_ex

```lua
function array.max_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<T>, dest_index?: integer)
  -> nil
```

Apply the maximum operator to two slices and store the result in a destination

## array.min

```lua
function array.min(a: array<T>, b: seq<T>)
  -> array<T>
```

Apply the minimum operator to two arrays

`{min(a[i],b[i])}` for all `i` in `[1, #a]`

## array.min_constant

```lua
function array.min_constant(a: array<T>, c: T|array<T>)
  -> array<T>
```

Apply the minimum operator to each element of an array with a constant

`{min(a[i],c)}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.min_constant_ex

```lua
function array.min_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<T>, dest_index?: integer)
  -> nil
```

Apply the minimum operator to each element of a slice with a constant and store the result in a destination

## array.min_constant_ex

```lua
function array.min_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<T>
```

Apply the minimum operator to each element of a slice with a constant

## array.min_ex

```lua
function array.min_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<T>
```

Apply the minimum operator to two slices and return the result

## array.min_ex

```lua
function array.min_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<T>, dest_index?: integer)
  -> nil
```

Apply the minimum operator to two slices and store the result in a destination

## array.mod

```lua
function array.mod(a: array<T>, b: seq<T>)
  -> array<number>
```

Apply the modulus operator to two arrays

`{a[i]%b[i]}` for all `i` in `[1, #a]`

## array.mod_constant

```lua
function array.mod_constant(a: array<T>, c: T|array<T>)
  -> array<number>
```

Apply the modulus operator to each element of an array with a constant

`{a[i]%c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.mod_constant_ex

```lua
function array.mod_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the modulus operator to each element of a slice with a constant and store the result in a destination

## array.mod_constant_ex

```lua
function array.mod_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<number>
```

Apply the modulus operator to each element of a slice with a constant

## array.mod_ex

```lua
function array.mod_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the modulus operator to two slices and store the result in a destination

## array.mod_ex

```lua
function array.mod_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<number>
```

Apply the modulus operator to two slices and return the result

## array.mul

```lua
function array.mul(a: array<T>, b: seq<T>)
  -> array<number>
```

Apply the multiplication operator to two arrays

`{a[i]*b[i]}` for all `i` in `[1, #a]`

## array.mul_add

```lua
function array.mul_add(a: array<T>, b: seq<T>, c: seq<T>)
  -> array<T>
```

Perform the multiply-add operation on three arrays and return an array

`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`

## array.mul_add_constant

```lua
function array.mul_add_constant(a: array<T>, b: seq<T>, c: T|array<T>)
  -> array<T>
```

Perform the multiply-add operation on two arrays and a constant and return an array

`{a[i]+b[i]*c}` for all `i` in `[1, #a]`

## array.mul_add_constant_ex

```lua
function array.mul_add_constant_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, c: T|array<T>)
  -> array<T>
```

Perform the multiply-add operation on two slices and a constant and return an array

`{a[i]+b[i]*c}` for all `i` in `[1, #a]`

## array.mul_add_constant_ex

```lua
function array.mul_add_constant_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, c: T|array<T>, dest: seq<T>, dest_index?: integer)
  -> nil
```

Perform the multiply-add operation on two slices and a constant into a destination

`{a[i]+b[i]*c}` for all `i` in `[1, #a]`

## array.mul_add_ex

```lua
function array.mul_add_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, c: seq<T>, c_index: integer)
```

Perform the multiply-add operation on three slices and return an array

`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`

## array.mul_add_ex

```lua
function array.mul_add_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, c: seq<T>, c_index: integer, dest: seq<T>, dest_index?: integer)
  -> seq<T>
```

Perform the multiply-add operation on three slices into a destination

`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`

## array.mul_constant

```lua
function array.mul_constant(a: array<T>, c: T|array<T>)
  -> array<number>
```

Apply the multiplication operator to each element of an array with a constant

`{a[i]*c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.mul_constant_ex

```lua
function array.mul_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element of a slice with a constant and store the result in a destination

## array.mul_constant_ex

```lua
function array.mul_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<number>
```

Apply the multiplication operator to each element of a slice with a constant

## array.mul_ex

```lua
function array.mul_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<number>
```

Apply the multiplication operator to two slices and return the result

## array.mul_ex

```lua
function array.mul_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two slices and store the result in a destination

## array.new_array

```lua
function array.new_array(type: T, length: integer)
  -> array<T>
```

Create a new an array with an initial length

Optionally redefine this to support custom platform and userdata

## array.not_equal

```lua
function array.not_equal(a: array<T>, b: seq<T>)
  -> boolean[]
```

Apply the not equal operator to two arrays

`{a[i]~=b[i]}` for all `i` in `[1, #a]`

## array.not_equal_constant

```lua
function array.not_equal_constant(a: array<T>, c: T|array<T>)
  -> boolean[]
```

Apply the not equal operator to each element of an array with a constant

`{a[i]~=c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.not_equal_constant_ex

```lua
function array.not_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> boolean[]
```

Apply the not equal operator to each element of a slice with a constant

## array.not_equal_constant_ex

```lua
function array.not_equal_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the not equal operator to each element of a slice with a constant and store the result in a destination

## array.not_equal_ex

```lua
function array.not_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> boolean[]
```

Apply the not equal operator to two slices and return the result

## array.not_equal_ex

```lua
function array.not_equal_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the not equal operator to two slices and store the result in a destination

## array.pop

```lua
function array.pop(src: array<T>)
  -> T
```

Pop a value off the end of an array and return it
See:
  * [array.pop_1](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#1487#9)
  * [array.pop_2](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#1500#9)
  * [array.pop_3](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#1515#9)

## array.pop_1

```lua
function array.pop_1(src: array<T>)
  -> T
```

Pop 1 value(s) off the end of an array and return them

## array.pop_2

```lua
function array.pop_2(src: array<T>)
  -> T, T
```

Pop 2 value(s) off the end of an array and return them

## array.pop_3

```lua
function array.pop_3(src: array<T>)
  -> T, T, T
```

Pop 3 value(s) off the end of an array and return them

## array.pop_4

```lua
function array.pop_4(src: array<T>)
  -> T * 4
```

Pop 4 value(s) off the end of an array and return them

## array.pop_5

```lua
function array.pop_5(src: array<T>)
  -> T * 5
```

Pop 5 value(s) off the end of an array and return them

## array.pop_6

```lua
function array.pop_6(src: array<T>)
  -> T * 6
```

Pop 6 value(s) off the end of an array and return them

## array.pop_7

```lua
function array.pop_7(src: array<T>)
  -> T * 7
```

Pop 7 value(s) off the end of an array and return them

## array.pop_8

```lua
function array.pop_8(src: array<T>)
  -> T * 8
```

Pop 8 value(s) off the end of an array and return them

## array.pop_9

```lua
function array.pop_9(src: array<T>)
  -> T * 9
```

Pop 9 value(s) off the end of an array and return them

## array.pop_10

```lua
function array.pop_10(src: array<T>)
  -> T * 10
```

Pop 10 value(s) off the end of an array and return them

## array.pop_11

```lua
function array.pop_11(src: array<T>)
  -> T * 11
```

Pop 11 value(s) off the end of an array and return them

## array.pop_12

```lua
function array.pop_12(src: array<T>)
  -> T * 12
```

Pop 12 value(s) off the end of an array and return them

## array.pop_13

```lua
function array.pop_13(src: array<T>)
  -> T * 13
```

Pop 13 value(s) off the end of an array and return them

## array.pop_14

```lua
function array.pop_14(src: array<T>)
  -> T * 14
```

Pop 14 value(s) off the end of an array and return them

## array.pop_15

```lua
function array.pop_15(src: array<T>)
  -> T * 15
```

Pop 15 value(s) off the end of an array and return them

## array.pop_16

```lua
function array.pop_16(src: array<T>)
  -> T * 16
```

Pop 16 value(s) off the end of an array and return them

## array.pow

```lua
function array.pow(a: array<T>, b: seq<T>)
  -> array<number>
```

Apply the exponentiation operator to two arrays

`{a[i]^b[i]}` for all `i` in `[1, #a]`

## array.pow_constant

```lua
function array.pow_constant(a: array<T>, c: T|array<T>)
  -> array<number>
```

Apply the exponentiation operator to each element of an array with a constant

`{a[i]^c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.pow_constant_ex

```lua
function array.pow_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element of a slice with a constant and store the result in a destination

## array.pow_constant_ex

```lua
function array.pow_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<number>
```

Apply the exponentiation operator to each element of a slice with a constant

## array.pow_ex

```lua
function array.pow_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<number>
```

Apply the exponentiation operator to two slices and return the result

## array.pow_ex

```lua
function array.pow_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two slices and store the result in a destination

## array.push

```lua
function array.push(dest: array<T>, ...<T>)
```

Push values onto an array

also see `push_1()`, `push_2()`, `push_3()`, etc.

## array.push_1

```lua
function array.push_1(dest: array<T>, v1: T)
```

Push 1 value(s) onto an array

## array.push_2

```lua
function array.push_2(dest: array<T>, v1: T, v2: T)
```

Push 2 value(s) onto an array

## array.push_3

```lua
function array.push_3(dest: array<T>, v1: T, v2: T, v3: T)
```

Push 3 value(s) onto an array

## array.push_4

```lua
function array.push_4(dest: array<T>, v1: T, v2: T, v3: T, v4: T)
```

Push 4 value(s) onto an array

## array.push_5

```lua
function array.push_5(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T)
```

Push 5 value(s) onto an array

## array.push_6

```lua
function array.push_6(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T)
```

Push 6 value(s) onto an array

## array.push_7

```lua
function array.push_7(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T)
```

Push 7 value(s) onto an array

## array.push_8

```lua
function array.push_8(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T)
```

Push 8 value(s) onto an array

## array.push_9

```lua
function array.push_9(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T)
```

Push 9 value(s) onto an array

## array.push_10

```lua
function array.push_10(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T)
```

Push 10 value(s) onto an array

## array.push_11

```lua
function array.push_11(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T)
```

Push 11 value(s) onto an array

## array.push_12

```lua
function array.push_12(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T)
```

Push 12 value(s) onto an array

## array.push_13

```lua
function array.push_13(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T)
```

Push 13 value(s) onto an array

## array.push_14

```lua
function array.push_14(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T, v14: T)
```

Push 14 value(s) onto an array

## array.push_15

```lua
function array.push_15(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T, v14: T, v15: T)
```

Push 15 value(s) onto an array

## array.push_16

```lua
function array.push_16(dest: array<T>, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T, v14: T, v15: T, v16: T)
```

Push 16 value(s) onto an array

## array.range

```lua
function array.range(from: T, to: T, step_size?: T)
  -> array<T>
```

create an array with sequential values in `from .. to` in `step_size` increments

@*param* `step_size` — default = 1

## array.range_into

```lua
function array.range_into(from: number, to: number, step_size: number, dest: seq<T>, dest_index?: integer)
```

fill a destination with sequential values in `from .. to` in `step_size` increments

## array.reshape

```lua
function array.reshape(src: any, dest_size: integer[])
  -> table
```

Reshape a table or an array from nested arrays to a flat array or vice versa

Examples:
* `reshape({1,2,3,4,5,6}, {3,2})` -> `{{1,2},{3,4},{5,6}}`
* `reshape({{1,2,3},{4,5,6}}}, {6})` -> `{1,2,3,4,5,6}`

## array.reshape_into

```lua
function array.reshape_into(src: any, dest_size: integer[], dest: any, dest_index?: integer)
  -> unknown
```

Reshape a table or an array into a destination
See:
  * [array.reshape](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#344#9)
  * [array.flatten](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#434#9)

## array.reverse

```lua
function array.reverse(src: array<T>)
  -> array<T>
```

Reverse an array

## array.reverse_ex

```lua
function array.reverse_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> array<T>
```

Reverse a slice

## array.reverse_ex

```lua
function array.reverse_ex(src: seq<T>, src_index: integer, src_count: integer, dest: seq<T>, dest_index?: integer)
  -> nil
```

Reverse a slice into a destination

## array.set

```lua
function array.set(dest: seq<T>, dest_index: integer, ...<T>)
```

Set values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_1

```lua
function array.set_1(dest: seq<T>, dest_index: integer, v1: T)
```

Set 1 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_2

```lua
function array.set_2(dest: seq<T>, dest_index: integer, v1: T, v2: T)
```

Set 2 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_3

```lua
function array.set_3(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T)
```

Set 3 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_4

```lua
function array.set_4(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T)
```

Set 4 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_5

```lua
function array.set_5(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T)
```

Set 5 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_6

```lua
function array.set_6(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T)
```

Set 6 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_7

```lua
function array.set_7(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T)
```

Set 7 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_8

```lua
function array.set_8(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T)
```

Set 8 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_9

```lua
function array.set_9(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T)
```

Set 9 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_10

```lua
function array.set_10(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T)
```

Set 10 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_11

```lua
function array.set_11(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T)
```

Set 11 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_12

```lua
function array.set_12(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T)
```

Set 12 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_13

```lua
function array.set_13(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T)
```

Set 13 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_14

```lua
function array.set_14(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T, v14: T)
```

Set 14 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_15

```lua
function array.set_15(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T, v14: T, v15: T)
```

Set 15 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.set_16

```lua
function array.set_16(dest: seq<T>, dest_index: integer, v1: T, v2: T, v3: T, v4: T, v5: T, v6: T, v7: T, v8: T, v9: T, v10: T, v11: T, v12: T, v13: T, v14: T, v15: T, v16: T)
```

Set 16 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## array.sub

```lua
function array.sub(a: array<T>, b: seq<T>)
  -> array<number>
```

Apply the subtraction operator to two arrays

`{a[i]-b[i]}` for all `i` in `[1, #a]`

## array.sub_constant

```lua
function array.sub_constant(a: array<T>, c: T|array<T>)
  -> array<number>
```

Apply the subtraction operator to each element of an array with a constant

`{a[i]-c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## array.sub_constant_ex

```lua
function array.sub_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T)
  -> array<number>
```

Apply the subtraction operator to each element of a slice with a constant

## array.sub_constant_ex

```lua
function array.sub_constant_ex(a: seq<T>, a_index: integer, a_count: integer, c: T, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element of a slice with a constant and store the result in a destination

## array.sub_ex

```lua
function array.sub_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> array<number>
```

Apply the subtraction operator to two slices and return the result

## array.sub_ex

```lua
function array.sub_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two slices and store the result in a destination

## array.unpack_2

```lua
function array.unpack_2(src: array<T>)
  -> T, T
```

Unpack 2 values from an array

## array.unpack_3

```lua
function array.unpack_3(src: array<T>)
  -> T, T, T
```

Unpack 3 values from an array

## array.unpack_4

```lua
function array.unpack_4(src: array<T>)
  -> T * 4
```

Unpack 4 values from an array

## array.unpack_5

```lua
function array.unpack_5(src: array<T>)
  -> T * 5
```

Unpack 5 values from an array

## array.unpack_6

```lua
function array.unpack_6(src: array<T>)
  -> T * 6
```

Unpack 6 values from an array

## array.unpack_7

```lua
function array.unpack_7(src: array<T>)
  -> T * 7
```

Unpack 7 values from an array

## array.unpack_8

```lua
function array.unpack_8(src: array<T>)
  -> T * 8
```

Unpack 8 values from an array

## array.unpack_9

```lua
function array.unpack_9(src: array<T>)
  -> T * 9
```

Unpack 9 values from an array

## array.unpack_10

```lua
function array.unpack_10(src: array<T>)
  -> T * 10
```

Unpack 10 values from an array

## array.unpack_11

```lua
function array.unpack_11(src: array<T>)
  -> T * 11
```

Unpack 11 values from an array

## array.unpack_12

```lua
function array.unpack_12(src: array<T>)
  -> T * 12
```

Unpack 12 values from an array

## array.unpack_13

```lua
function array.unpack_13(src: array<T>)
  -> T * 13
```

Unpack 13 values from an array

## array.unpack_14

```lua
function array.unpack_14(src: array<T>)
  -> T * 14
```

Unpack 14 values from an array

## array.unpack_15

```lua
function array.unpack_15(src: array<T>)
  -> T * 15
```

Unpack 15 values from an array

## array.unpack_16

```lua
function array.unpack_16(src: array<T>)
  -> T * 16
```

Unpack 16 values from an array

## array.zeros

```lua
function array.zeros(count: integer)
  -> array<number>
```

create an array of zeros


---

# matrix_2
2x2 matrix in column-major order constructed from a tuple

## matrix_2.__index

```lua
matrix_2
```

2x2 matrix in column-major order constructed from a tuple


## matrix_2.__len

```lua
function matrix_2.__len()
  -> integer
```

## matrix_2.__tostring

```lua
function matrix_2:__tostring()
  -> string
```

## matrix_2.__unm

```lua
function matrix_2.__unm(m: any)
```

## matrix_2.add

```lua
function matrix_2:add(m: number|number4)
  -> matrix_2
```

Apply addition element-wise and return a new matrix_2

Parameter `m` can be a number or array

## matrix_2.add_into

```lua
function matrix_2:add_into(m: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply addition element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_2.copy

```lua
function matrix_2:copy()
  -> matrix_2
```

## matrix_2.copy_into

```lua
function matrix_2:copy_into(dest: seq_number4, dest_index?: integer)
```

## matrix_2.div

```lua
function matrix_2:div(m: number|number4)
  -> matrix_2
```

Apply division element-wise and return a new matrix_2

Parameter `m` can be a number or array

## matrix_2.div_into

```lua
function matrix_2:div_into(m: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply division element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_2.get

```lua
function matrix_2:get()
  -> number * 4
```

Get values as a tuple

## matrix_2.matmul

```lua
function matrix_2:matmul(m: number4)
  -> matrix_2
```

Multiply with a matrix and return the result

## matrix_2.matmul_into

```lua
function matrix_2:matmul_into(m: number4, dest: seq_number4, dest_index?: integer)
```

Multiply with a matrix and store the result in a destination

## matrix_2.mul

```lua
function matrix_2:mul(m: number|number4)
  -> matrix_2
```

Apply multiplication element-wise and return a new matrix_2

Parameter `m` can be a number or array

## matrix_2.mul_into

```lua
function matrix_2:mul_into(m: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply multiplication element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_2.set

```lua
function matrix_2:set(e_11: number, e_12: number, e_21: number, e_22: number)
```

Set values from a tuple

Parameter `e_ij` determines the value of `i'th` column `j'th` row

## matrix_2.sub

```lua
function matrix_2:sub(m: number|number4)
  -> matrix_2
```

Apply subtraction element-wise and return a new matrix_2

Parameter `m` can be a number or array

## matrix_2.sub_into

```lua
function matrix_2:sub_into(m: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply subtraction element-wise and store the result in a destination

Parameter `m` can be a number or array


---

# matrix_2_slice
A 2x2 matrix in column-major order that views into an array or slice


---

# matrix_3
3x3 matrix in column-major order constructed from a tuple

## matrix_3.__index

```lua
matrix_3
```

3x3 matrix in column-major order constructed from a tuple


## matrix_3.__len

```lua
function matrix_3.__len()
  -> integer
```

## matrix_3.__tostring

```lua
function matrix_3:__tostring()
  -> string
```

## matrix_3.__unm

```lua
function matrix_3.__unm(m: any)
```

## matrix_3.add

```lua
function matrix_3:add(m: number|number9)
  -> matrix_3
```

Apply addition element-wise and return a new matrix_3

Parameter `m` can be a number or array

## matrix_3.add_into

```lua
function matrix_3:add_into(m: number|number9, dest: seq_number9, dest_index?: integer)
```

Apply addition element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_3.copy

```lua
function matrix_3:copy()
  -> matrix_3
```

## matrix_3.copy_into

```lua
function matrix_3:copy_into(dest: seq_number9, dest_index?: integer)
```

## matrix_3.div

```lua
function matrix_3:div(m: number|number9)
  -> matrix_3
```

Apply division element-wise and return a new matrix_3

Parameter `m` can be a number or array

## matrix_3.div_into

```lua
function matrix_3:div_into(m: number|number9, dest: seq_number9, dest_index?: integer)
```

Apply division element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_3.get

```lua
function matrix_3:get()
  -> number * 9
```

Get values as a tuple

## matrix_3.matmul

```lua
function matrix_3:matmul(m: number9)
  -> matrix_3
```

Multiply with a matrix and return the result

## matrix_3.matmul_into

```lua
function matrix_3:matmul_into(m: number9, dest: seq_number9, dest_index?: integer)
```

Multiply with a matrix and store the result in a destination

## matrix_3.mul

```lua
function matrix_3:mul(m: number|number9)
  -> matrix_3
```

Apply multiplication element-wise and return a new matrix_3

Parameter `m` can be a number or array

## matrix_3.mul_into

```lua
function matrix_3:mul_into(m: number|number9, dest: seq_number9, dest_index?: integer)
```

Apply multiplication element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_3.set

```lua
function matrix_3:set(e_11: number, e_12: number, e_13: number, e_21: number, e_22: number, e_23: number, e_31: number, e_32: number, e_33: number)
```

Set values from a tuple

Parameter `e_ij` determines the value of `i'th` column `j'th` row

## matrix_3.sub

```lua
function matrix_3:sub(m: number|number9)
  -> matrix_3
```

Apply subtraction element-wise and return a new matrix_3

Parameter `m` can be a number or array

## matrix_3.sub_into

```lua
function matrix_3:sub_into(m: number|number9, dest: seq_number9, dest_index?: integer)
```

Apply subtraction element-wise and store the result in a destination

Parameter `m` can be a number or array


---

# matrix_3_slice
A 3x3 matrix in column-major order that views into an array or slice


---

# matrix_4
4x4 matrix in column-major order constructed from a tuple

## matrix_4.__index

```lua
matrix_4
```

4x4 matrix in column-major order constructed from a tuple


## matrix_4.__len

```lua
function matrix_4.__len()
  -> integer
```

## matrix_4.__tostring

```lua
function matrix_4:__tostring()
  -> string
```

## matrix_4.__unm

```lua
function matrix_4.__unm(m: any)
```

## matrix_4.add

```lua
function matrix_4:add(m: number|number16)
  -> matrix_4
```

Apply addition element-wise and return a new matrix_4

Parameter `m` can be a number or array

## matrix_4.add_into

```lua
function matrix_4:add_into(m: number|number16, dest: seq_number16, dest_index?: integer)
```

Apply addition element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_4.copy

```lua
function matrix_4:copy()
  -> matrix_4
```

## matrix_4.copy_into

```lua
function matrix_4:copy_into(dest: seq_number16, dest_index?: integer)
```

## matrix_4.div

```lua
function matrix_4:div(m: number|number16)
  -> matrix_4
```

Apply division element-wise and return a new matrix_4

Parameter `m` can be a number or array

## matrix_4.div_into

```lua
function matrix_4:div_into(m: number|number16, dest: seq_number16, dest_index?: integer)
```

Apply division element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_4.get

```lua
function matrix_4:get()
  -> number * 16
```

Get values as a tuple

## matrix_4.matmul

```lua
function matrix_4:matmul(m: number16)
  -> matrix_4
```

Multiply with a matrix and return the result

## matrix_4.matmul_into

```lua
function matrix_4:matmul_into(m: number16, dest: seq_number16, dest_index?: integer)
```

Multiply with a matrix and store the result in a destination

## matrix_4.mul

```lua
function matrix_4:mul(m: number|number16)
  -> matrix_4
```

Apply multiplication element-wise and return a new matrix_4

Parameter `m` can be a number or array

## matrix_4.mul_into

```lua
function matrix_4:mul_into(m: number|number16, dest: seq_number16, dest_index?: integer)
```

Apply multiplication element-wise and store the result in a destination

Parameter `m` can be a number or array

## matrix_4.set

```lua
function matrix_4:set(e_11: number, e_12: number, e_13: number, e_14: number, e_21: number, e_22: number, e_23: number, e_24: number, e_31: number, e_32: number, e_33: number, e_34: number, e_41: number, e_42: number, e_43: number, e_44: number)
```

Set values from a tuple

Parameter `e_ij` determines the value of `i'th` column `j'th` row

## matrix_4.sub

```lua
function matrix_4:sub(m: number|number16)
  -> matrix_4
```

Apply subtraction element-wise and return a new matrix_4

Parameter `m` can be a number or array

## matrix_4.sub_into

```lua
function matrix_4:sub_into(m: number|number16, dest: seq_number16, dest_index?: integer)
```

Apply subtraction element-wise and store the result in a destination

Parameter `m` can be a number or array


---

# matrix_4_slice
A 4x4 matrix in column-major order that views into an array or slice


---

# vector_2
2D vector constructed from a tuple

## vector_2.__index

```lua
vector_2
```

2D vector constructed from a tuple


## vector_2.__len

```lua
function vector_2.__len()
  -> integer
```

## vector_2.__tostring

```lua
function vector_2:__tostring()
  -> string
```

## vector_2.__unm

```lua
function vector_2.__unm(v: any)
```

## vector_2.add

```lua
function vector_2:add(v: number|number2)
  -> vector_2
```

Apply add element-wise and return a new vector_2

Parameter `v` can be a number or array

## vector_2.add_into

```lua
function vector_2:add_into(v: number|number2, dest: seq_number2, dest_index?: integer)
```

Apply add element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_2.copy

```lua
function vector_2:copy()
  -> vector_2
```

## vector_2.copy_into

```lua
function vector_2:copy_into(dest: seq_number2, dest_index?: integer)
```

## vector_2.div

```lua
function vector_2:div(v: number|number2)
  -> vector_2
```

Apply div element-wise and return a new vector_2

Parameter `v` can be a number or array

## vector_2.div_into

```lua
function vector_2:div_into(v: number|number2, dest: seq_number2, dest_index?: integer)
```

Apply div element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_2.get

```lua
function vector_2:get()
  -> number, number
```

Get values as a tuple

## vector_2.mul

```lua
function vector_2:mul(v: number|number2)
  -> vector_2
```

Apply mul element-wise and return a new vector_2

Parameter `v` can be a number or array

## vector_2.mul_into

```lua
function vector_2:mul_into(v: number|number2, dest: seq_number2, dest_index?: integer)
```

Apply mul element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_2.set

```lua
function vector_2:set(v1: number, v2: number)
```

Set values from a tuple

## vector_2.set_x

```lua
function vector_2:set_x(v1: number)
```

Set elements of the vector

## vector_2.set_xy

```lua
function vector_2:set_xy(v1: number, v2: number)
```

Set elements of the vector

## vector_2.set_y

```lua
function vector_2:set_y(v1: number)
```

Set elements of the vector

## vector_2.set_yx

```lua
function vector_2:set_yx(v1: number, v2: number)
```

Set elements of the vector

## vector_2.sub

```lua
function vector_2:sub(v: number|number2)
  -> vector_2
```

Apply sub element-wise and return a new vector_2

Parameter `v` can be a number or array

## vector_2.sub_into

```lua
function vector_2:sub_into(v: number|number2, dest: seq_number2, dest_index?: integer)
```

Apply sub element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_2.x

```lua
function vector_2:x()
  -> number
```

Get elements of the vector

## vector_2.xx

```lua
function vector_2:xx()
  -> number, number
```

Get elements of the vector

## vector_2.xy

```lua
function vector_2:xy()
  -> number, number
```

Get elements of the vector

## vector_2.y

```lua
function vector_2:y()
  -> number
```

Get elements of the vector

## vector_2.yx

```lua
function vector_2:yx()
  -> number, number
```

Get elements of the vector

## vector_2.yy

```lua
function vector_2:yy()
  -> number, number
```

Get elements of the vector


---

# vector_3
3D vector constructed from a tuple

## vector_3.__index

```lua
vector_3
```

3D vector constructed from a tuple


## vector_3.__len

```lua
function vector_3.__len()
  -> integer
```

## vector_3.__tostring

```lua
function vector_3:__tostring()
  -> string
```

## vector_3.__unm

```lua
function vector_3.__unm(v: any)
```

## vector_3.add

```lua
function vector_3:add(v: number|number3)
  -> vector_3
```

Apply add element-wise and return a new vector_3

Parameter `v` can be a number or array

## vector_3.add_into

```lua
function vector_3:add_into(v: number|number3, dest: seq_number3, dest_index?: integer)
```

Apply add element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_3.copy

```lua
function vector_3:copy()
  -> vector_3
```

## vector_3.copy_into

```lua
function vector_3:copy_into(dest: seq_number3, dest_index?: integer)
```

## vector_3.div

```lua
function vector_3:div(v: number|number3)
  -> vector_3
```

Apply div element-wise and return a new vector_3

Parameter `v` can be a number or array

## vector_3.div_into

```lua
function vector_3:div_into(v: number|number3, dest: seq_number3, dest_index?: integer)
```

Apply div element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_3.get

```lua
function vector_3:get()
  -> number, number, number
```

Get values as a tuple

## vector_3.mul

```lua
function vector_3:mul(v: number|number3)
  -> vector_3
```

Apply mul element-wise and return a new vector_3

Parameter `v` can be a number or array

## vector_3.mul_into

```lua
function vector_3:mul_into(v: number|number3, dest: seq_number3, dest_index?: integer)
```

Apply mul element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_3.set

```lua
function vector_3:set(v1: number, v2: number, v3: number)
```

Set values from a tuple

## vector_3.set_x

```lua
function vector_3:set_x(v1: number)
```

Set elements of the vector

## vector_3.set_xy

```lua
function vector_3:set_xy(v1: number, v2: number)
```

Set elements of the vector

## vector_3.set_xyz

```lua
function vector_3:set_xyz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_3.set_xz

```lua
function vector_3:set_xz(v1: number, v2: number)
```

Set elements of the vector

## vector_3.set_xzy

```lua
function vector_3:set_xzy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_3.set_y

```lua
function vector_3:set_y(v1: number)
```

Set elements of the vector

## vector_3.set_yx

```lua
function vector_3:set_yx(v1: number, v2: number)
```

Set elements of the vector

## vector_3.set_yxz

```lua
function vector_3:set_yxz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_3.set_yz

```lua
function vector_3:set_yz(v1: number, v2: number)
```

Set elements of the vector

## vector_3.set_yzx

```lua
function vector_3:set_yzx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_3.set_z

```lua
function vector_3:set_z(v1: number)
```

Set elements of the vector

## vector_3.set_zx

```lua
function vector_3:set_zx(v1: number, v2: number)
```

Set elements of the vector

## vector_3.set_zxy

```lua
function vector_3:set_zxy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_3.set_zy

```lua
function vector_3:set_zy(v1: number, v2: number)
```

Set elements of the vector

## vector_3.set_zyx

```lua
function vector_3:set_zyx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_3.sub

```lua
function vector_3:sub(v: number|number3)
  -> vector_3
```

Apply sub element-wise and return a new vector_3

Parameter `v` can be a number or array

## vector_3.sub_into

```lua
function vector_3:sub_into(v: number|number3, dest: seq_number3, dest_index?: integer)
```

Apply sub element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_3.x

```lua
function vector_3:x()
  -> number
```

Get elements of the vector

## vector_3.xx

```lua
function vector_3:xx()
  -> number, number
```

Get elements of the vector

## vector_3.xxx

```lua
function vector_3:xxx()
  -> number, number, number
```

Get elements of the vector

## vector_3.xxy

```lua
function vector_3:xxy()
  -> number, number, number
```

Get elements of the vector

## vector_3.xxz

```lua
function vector_3:xxz()
  -> number, number, number
```

Get elements of the vector

## vector_3.xy

```lua
function vector_3:xy()
  -> number, number
```

Get elements of the vector

## vector_3.xyx

```lua
function vector_3:xyx()
  -> number, number, number
```

Get elements of the vector

## vector_3.xyy

```lua
function vector_3:xyy()
  -> number, number, number
```

Get elements of the vector

## vector_3.xyz

```lua
function vector_3:xyz()
  -> number, number, number
```

Get elements of the vector

## vector_3.xz

```lua
function vector_3:xz()
  -> number, number
```

Get elements of the vector

## vector_3.xzx

```lua
function vector_3:xzx()
  -> number, number, number
```

Get elements of the vector

## vector_3.xzy

```lua
function vector_3:xzy()
  -> number, number, number
```

Get elements of the vector

## vector_3.xzz

```lua
function vector_3:xzz()
  -> number, number, number
```

Get elements of the vector

## vector_3.y

```lua
function vector_3:y()
  -> number
```

Get elements of the vector

## vector_3.yx

```lua
function vector_3:yx()
  -> number, number
```

Get elements of the vector

## vector_3.yxx

```lua
function vector_3:yxx()
  -> number, number, number
```

Get elements of the vector

## vector_3.yxy

```lua
function vector_3:yxy()
  -> number, number, number
```

Get elements of the vector

## vector_3.yxz

```lua
function vector_3:yxz()
  -> number, number, number
```

Get elements of the vector

## vector_3.yy

```lua
function vector_3:yy()
  -> number, number
```

Get elements of the vector

## vector_3.yyx

```lua
function vector_3:yyx()
  -> number, number, number
```

Get elements of the vector

## vector_3.yyy

```lua
function vector_3:yyy()
  -> number, number, number
```

Get elements of the vector

## vector_3.yyz

```lua
function vector_3:yyz()
  -> number, number, number
```

Get elements of the vector

## vector_3.yz

```lua
function vector_3:yz()
  -> number, number
```

Get elements of the vector

## vector_3.yzx

```lua
function vector_3:yzx()
  -> number, number, number
```

Get elements of the vector

## vector_3.yzy

```lua
function vector_3:yzy()
  -> number, number, number
```

Get elements of the vector

## vector_3.yzz

```lua
function vector_3:yzz()
  -> number, number, number
```

Get elements of the vector

## vector_3.z

```lua
function vector_3:z()
  -> number
```

Get elements of the vector

## vector_3.zx

```lua
function vector_3:zx()
  -> number, number
```

Get elements of the vector

## vector_3.zxx

```lua
function vector_3:zxx()
  -> number, number, number
```

Get elements of the vector

## vector_3.zxy

```lua
function vector_3:zxy()
  -> number, number, number
```

Get elements of the vector

## vector_3.zxz

```lua
function vector_3:zxz()
  -> number, number, number
```

Get elements of the vector

## vector_3.zy

```lua
function vector_3:zy()
  -> number, number
```

Get elements of the vector

## vector_3.zyx

```lua
function vector_3:zyx()
  -> number, number, number
```

Get elements of the vector

## vector_3.zyy

```lua
function vector_3:zyy()
  -> number, number, number
```

Get elements of the vector

## vector_3.zyz

```lua
function vector_3:zyz()
  -> number, number, number
```

Get elements of the vector

## vector_3.zz

```lua
function vector_3:zz()
  -> number, number
```

Get elements of the vector

## vector_3.zzx

```lua
function vector_3:zzx()
  -> number, number, number
```

Get elements of the vector

## vector_3.zzy

```lua
function vector_3:zzy()
  -> number, number, number
```

Get elements of the vector

## vector_3.zzz

```lua
function vector_3:zzz()
  -> number, number, number
```

Get elements of the vector


---

# vector_4
4D vector constructed from a tuple

## vector_4.__index

```lua
vector_4
```

4D vector constructed from a tuple


## vector_4.__len

```lua
function vector_4.__len()
  -> integer
```

## vector_4.__tostring

```lua
function vector_4:__tostring()
  -> string
```

## vector_4.__unm

```lua
function vector_4.__unm(v: any)
```

## vector_4.add

```lua
function vector_4:add(v: number|number4)
  -> vector_4
```

Apply add element-wise and return a new vector_4

Parameter `v` can be a number or array

## vector_4.add_into

```lua
function vector_4:add_into(v: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply add element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_4.copy

```lua
function vector_4:copy()
  -> vector_4
```

## vector_4.copy_into

```lua
function vector_4:copy_into(dest: seq_number4, dest_index?: integer)
```

## vector_4.div

```lua
function vector_4:div(v: number|number4)
  -> vector_4
```

Apply div element-wise and return a new vector_4

Parameter `v` can be a number or array

## vector_4.div_into

```lua
function vector_4:div_into(v: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply div element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_4.get

```lua
function vector_4:get()
  -> number * 4
```

Get values as a tuple

## vector_4.mul

```lua
function vector_4:mul(v: number|number4)
  -> vector_4
```

Apply mul element-wise and return a new vector_4

Parameter `v` can be a number or array

## vector_4.mul_into

```lua
function vector_4:mul_into(v: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply mul element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_4.set

```lua
function vector_4:set(v1: number, v2: number, v3: number, v4: number)
```

Set values from a tuple

## vector_4.set_w

```lua
function vector_4:set_w(v1: number)
```

Set elements of the vector

## vector_4.set_wx

```lua
function vector_4:set_wx(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_wxy

```lua
function vector_4:set_wxy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_wxyz

```lua
function vector_4:set_wxyz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_wxz

```lua
function vector_4:set_wxz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_wxzy

```lua
function vector_4:set_wxzy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_wy

```lua
function vector_4:set_wy(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_wyx

```lua
function vector_4:set_wyx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_wyxz

```lua
function vector_4:set_wyxz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_wyz

```lua
function vector_4:set_wyz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_wyzx

```lua
function vector_4:set_wyzx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_wz

```lua
function vector_4:set_wz(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_wzx

```lua
function vector_4:set_wzx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_wzxy

```lua
function vector_4:set_wzxy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_wzy

```lua
function vector_4:set_wzy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_wzyx

```lua
function vector_4:set_wzyx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_x

```lua
function vector_4:set_x(v1: number)
```

Set elements of the vector

## vector_4.set_xw

```lua
function vector_4:set_xw(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_xwy

```lua
function vector_4:set_xwy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_xwyz

```lua
function vector_4:set_xwyz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_xwz

```lua
function vector_4:set_xwz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_xwzy

```lua
function vector_4:set_xwzy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_xy

```lua
function vector_4:set_xy(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_xyw

```lua
function vector_4:set_xyw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_xywz

```lua
function vector_4:set_xywz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_xyz

```lua
function vector_4:set_xyz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_xyzw

```lua
function vector_4:set_xyzw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_xz

```lua
function vector_4:set_xz(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_xzw

```lua
function vector_4:set_xzw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_xzwy

```lua
function vector_4:set_xzwy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_xzy

```lua
function vector_4:set_xzy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_xzyw

```lua
function vector_4:set_xzyw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_y

```lua
function vector_4:set_y(v1: number)
```

Set elements of the vector

## vector_4.set_yw

```lua
function vector_4:set_yw(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_ywx

```lua
function vector_4:set_ywx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_ywxz

```lua
function vector_4:set_ywxz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_ywz

```lua
function vector_4:set_ywz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_ywzx

```lua
function vector_4:set_ywzx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_yx

```lua
function vector_4:set_yx(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_yxw

```lua
function vector_4:set_yxw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_yxwz

```lua
function vector_4:set_yxwz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_yxz

```lua
function vector_4:set_yxz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_yxzw

```lua
function vector_4:set_yxzw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_yz

```lua
function vector_4:set_yz(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_yzw

```lua
function vector_4:set_yzw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_yzwx

```lua
function vector_4:set_yzwx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_yzx

```lua
function vector_4:set_yzx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_yzxw

```lua
function vector_4:set_yzxw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_z

```lua
function vector_4:set_z(v1: number)
```

Set elements of the vector

## vector_4.set_zw

```lua
function vector_4:set_zw(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_zwx

```lua
function vector_4:set_zwx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_zwxy

```lua
function vector_4:set_zwxy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_zwy

```lua
function vector_4:set_zwy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_zwyx

```lua
function vector_4:set_zwyx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_zx

```lua
function vector_4:set_zx(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_zxw

```lua
function vector_4:set_zxw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_zxwy

```lua
function vector_4:set_zxwy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_zxy

```lua
function vector_4:set_zxy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_zxyw

```lua
function vector_4:set_zxyw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_zy

```lua
function vector_4:set_zy(v1: number, v2: number)
```

Set elements of the vector

## vector_4.set_zyw

```lua
function vector_4:set_zyw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_zywx

```lua
function vector_4:set_zywx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.set_zyx

```lua
function vector_4:set_zyx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## vector_4.set_zyxw

```lua
function vector_4:set_zyxw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## vector_4.sub

```lua
function vector_4:sub(v: number|number4)
  -> vector_4
```

Apply sub element-wise and return a new vector_4

Parameter `v` can be a number or array

## vector_4.sub_into

```lua
function vector_4:sub_into(v: number|number4, dest: seq_number4, dest_index?: integer)
```

Apply sub element-wise and store the result in dest

Parameter `v` can be a number or array

## vector_4.w

```lua
function vector_4:w()
  -> number
```

Get elements of the vector

## vector_4.ww

```lua
function vector_4:ww()
  -> number, number
```

Get elements of the vector

## vector_4.www

```lua
function vector_4:www()
  -> number, number, number
```

Get elements of the vector

## vector_4.wwww

```lua
function vector_4:wwww()
  -> number * 4
```

Get elements of the vector

## vector_4.wwwx

```lua
function vector_4:wwwx()
  -> number * 4
```

Get elements of the vector

## vector_4.wwwy

```lua
function vector_4:wwwy()
  -> number * 4
```

Get elements of the vector

## vector_4.wwwz

```lua
function vector_4:wwwz()
  -> number * 4
```

Get elements of the vector

## vector_4.wwx

```lua
function vector_4:wwx()
  -> number, number, number
```

Get elements of the vector

## vector_4.wwxw

```lua
function vector_4:wwxw()
  -> number * 4
```

Get elements of the vector

## vector_4.wwxx

```lua
function vector_4:wwxx()
  -> number * 4
```

Get elements of the vector

## vector_4.wwxy

```lua
function vector_4:wwxy()
  -> number * 4
```

Get elements of the vector

## vector_4.wwxz

```lua
function vector_4:wwxz()
  -> number * 4
```

Get elements of the vector

## vector_4.wwy

```lua
function vector_4:wwy()
  -> number, number, number
```

Get elements of the vector

## vector_4.wwyw

```lua
function vector_4:wwyw()
  -> number * 4
```

Get elements of the vector

## vector_4.wwyx

```lua
function vector_4:wwyx()
  -> number * 4
```

Get elements of the vector

## vector_4.wwyy

```lua
function vector_4:wwyy()
  -> number * 4
```

Get elements of the vector

## vector_4.wwyz

```lua
function vector_4:wwyz()
  -> number * 4
```

Get elements of the vector

## vector_4.wwz

```lua
function vector_4:wwz()
  -> number, number, number
```

Get elements of the vector

## vector_4.wwzw

```lua
function vector_4:wwzw()
  -> number * 4
```

Get elements of the vector

## vector_4.wwzx

```lua
function vector_4:wwzx()
  -> number * 4
```

Get elements of the vector

## vector_4.wwzy

```lua
function vector_4:wwzy()
  -> number * 4
```

Get elements of the vector

## vector_4.wwzz

```lua
function vector_4:wwzz()
  -> number * 4
```

Get elements of the vector

## vector_4.wx

```lua
function vector_4:wx()
  -> number, number
```

Get elements of the vector

## vector_4.wxw

```lua
function vector_4:wxw()
  -> number, number, number
```

Get elements of the vector

## vector_4.wxww

```lua
function vector_4:wxww()
  -> number * 4
```

Get elements of the vector

## vector_4.wxwx

```lua
function vector_4:wxwx()
  -> number * 4
```

Get elements of the vector

## vector_4.wxwy

```lua
function vector_4:wxwy()
  -> number * 4
```

Get elements of the vector

## vector_4.wxwz

```lua
function vector_4:wxwz()
  -> number * 4
```

Get elements of the vector

## vector_4.wxx

```lua
function vector_4:wxx()
  -> number, number, number
```

Get elements of the vector

## vector_4.wxxw

```lua
function vector_4:wxxw()
  -> number * 4
```

Get elements of the vector

## vector_4.wxxx

```lua
function vector_4:wxxx()
  -> number * 4
```

Get elements of the vector

## vector_4.wxxy

```lua
function vector_4:wxxy()
  -> number * 4
```

Get elements of the vector

## vector_4.wxxz

```lua
function vector_4:wxxz()
  -> number * 4
```

Get elements of the vector

## vector_4.wxy

```lua
function vector_4:wxy()
  -> number, number, number
```

Get elements of the vector

## vector_4.wxyw

```lua
function vector_4:wxyw()
  -> number * 4
```

Get elements of the vector

## vector_4.wxyx

```lua
function vector_4:wxyx()
  -> number * 4
```

Get elements of the vector

## vector_4.wxyy

```lua
function vector_4:wxyy()
  -> number * 4
```

Get elements of the vector

## vector_4.wxyz

```lua
function vector_4:wxyz()
  -> number * 4
```

Get elements of the vector

## vector_4.wxz

```lua
function vector_4:wxz()
  -> number, number, number
```

Get elements of the vector

## vector_4.wxzw

```lua
function vector_4:wxzw()
  -> number * 4
```

Get elements of the vector

## vector_4.wxzx

```lua
function vector_4:wxzx()
  -> number * 4
```

Get elements of the vector

## vector_4.wxzy

```lua
function vector_4:wxzy()
  -> number * 4
```

Get elements of the vector

## vector_4.wxzz

```lua
function vector_4:wxzz()
  -> number * 4
```

Get elements of the vector

## vector_4.wy

```lua
function vector_4:wy()
  -> number, number
```

Get elements of the vector

## vector_4.wyw

```lua
function vector_4:wyw()
  -> number, number, number
```

Get elements of the vector

## vector_4.wyww

```lua
function vector_4:wyww()
  -> number * 4
```

Get elements of the vector

## vector_4.wywx

```lua
function vector_4:wywx()
  -> number * 4
```

Get elements of the vector

## vector_4.wywy

```lua
function vector_4:wywy()
  -> number * 4
```

Get elements of the vector

## vector_4.wywz

```lua
function vector_4:wywz()
  -> number * 4
```

Get elements of the vector

## vector_4.wyx

```lua
function vector_4:wyx()
  -> number, number, number
```

Get elements of the vector

## vector_4.wyxw

```lua
function vector_4:wyxw()
  -> number * 4
```

Get elements of the vector

## vector_4.wyxx

```lua
function vector_4:wyxx()
  -> number * 4
```

Get elements of the vector

## vector_4.wyxy

```lua
function vector_4:wyxy()
  -> number * 4
```

Get elements of the vector

## vector_4.wyxz

```lua
function vector_4:wyxz()
  -> number * 4
```

Get elements of the vector

## vector_4.wyy

```lua
function vector_4:wyy()
  -> number, number, number
```

Get elements of the vector

## vector_4.wyyw

```lua
function vector_4:wyyw()
  -> number * 4
```

Get elements of the vector

## vector_4.wyyx

```lua
function vector_4:wyyx()
  -> number * 4
```

Get elements of the vector

## vector_4.wyyy

```lua
function vector_4:wyyy()
  -> number * 4
```

Get elements of the vector

## vector_4.wyyz

```lua
function vector_4:wyyz()
  -> number * 4
```

Get elements of the vector

## vector_4.wyz

```lua
function vector_4:wyz()
  -> number, number, number
```

Get elements of the vector

## vector_4.wyzw

```lua
function vector_4:wyzw()
  -> number * 4
```

Get elements of the vector

## vector_4.wyzx

```lua
function vector_4:wyzx()
  -> number * 4
```

Get elements of the vector

## vector_4.wyzy

```lua
function vector_4:wyzy()
  -> number * 4
```

Get elements of the vector

## vector_4.wyzz

```lua
function vector_4:wyzz()
  -> number * 4
```

Get elements of the vector

## vector_4.wz

```lua
function vector_4:wz()
  -> number, number
```

Get elements of the vector

## vector_4.wzw

```lua
function vector_4:wzw()
  -> number, number, number
```

Get elements of the vector

## vector_4.wzww

```lua
function vector_4:wzww()
  -> number * 4
```

Get elements of the vector

## vector_4.wzwx

```lua
function vector_4:wzwx()
  -> number * 4
```

Get elements of the vector

## vector_4.wzwy

```lua
function vector_4:wzwy()
  -> number * 4
```

Get elements of the vector

## vector_4.wzwz

```lua
function vector_4:wzwz()
  -> number * 4
```

Get elements of the vector

## vector_4.wzx

```lua
function vector_4:wzx()
  -> number, number, number
```

Get elements of the vector

## vector_4.wzxw

```lua
function vector_4:wzxw()
  -> number * 4
```

Get elements of the vector

## vector_4.wzxx

```lua
function vector_4:wzxx()
  -> number * 4
```

Get elements of the vector

## vector_4.wzxy

```lua
function vector_4:wzxy()
  -> number * 4
```

Get elements of the vector

## vector_4.wzxz

```lua
function vector_4:wzxz()
  -> number * 4
```

Get elements of the vector

## vector_4.wzy

```lua
function vector_4:wzy()
  -> number, number, number
```

Get elements of the vector

## vector_4.wzyw

```lua
function vector_4:wzyw()
  -> number * 4
```

Get elements of the vector

## vector_4.wzyx

```lua
function vector_4:wzyx()
  -> number * 4
```

Get elements of the vector

## vector_4.wzyy

```lua
function vector_4:wzyy()
  -> number * 4
```

Get elements of the vector

## vector_4.wzyz

```lua
function vector_4:wzyz()
  -> number * 4
```

Get elements of the vector

## vector_4.wzz

```lua
function vector_4:wzz()
  -> number, number, number
```

Get elements of the vector

## vector_4.wzzw

```lua
function vector_4:wzzw()
  -> number * 4
```

Get elements of the vector

## vector_4.wzzx

```lua
function vector_4:wzzx()
  -> number * 4
```

Get elements of the vector

## vector_4.wzzy

```lua
function vector_4:wzzy()
  -> number * 4
```

Get elements of the vector

## vector_4.wzzz

```lua
function vector_4:wzzz()
  -> number * 4
```

Get elements of the vector

## vector_4.x

```lua
function vector_4:x()
  -> number
```

Get elements of the vector

## vector_4.xw

```lua
function vector_4:xw()
  -> number, number
```

Get elements of the vector

## vector_4.xww

```lua
function vector_4:xww()
  -> number, number, number
```

Get elements of the vector

## vector_4.xwww

```lua
function vector_4:xwww()
  -> number * 4
```

Get elements of the vector

## vector_4.xwwx

```lua
function vector_4:xwwx()
  -> number * 4
```

Get elements of the vector

## vector_4.xwwy

```lua
function vector_4:xwwy()
  -> number * 4
```

Get elements of the vector

## vector_4.xwwz

```lua
function vector_4:xwwz()
  -> number * 4
```

Get elements of the vector

## vector_4.xwx

```lua
function vector_4:xwx()
  -> number, number, number
```

Get elements of the vector

## vector_4.xwxw

```lua
function vector_4:xwxw()
  -> number * 4
```

Get elements of the vector

## vector_4.xwxx

```lua
function vector_4:xwxx()
  -> number * 4
```

Get elements of the vector

## vector_4.xwxy

```lua
function vector_4:xwxy()
  -> number * 4
```

Get elements of the vector

## vector_4.xwxz

```lua
function vector_4:xwxz()
  -> number * 4
```

Get elements of the vector

## vector_4.xwy

```lua
function vector_4:xwy()
  -> number, number, number
```

Get elements of the vector

## vector_4.xwyw

```lua
function vector_4:xwyw()
  -> number * 4
```

Get elements of the vector

## vector_4.xwyx

```lua
function vector_4:xwyx()
  -> number * 4
```

Get elements of the vector

## vector_4.xwyy

```lua
function vector_4:xwyy()
  -> number * 4
```

Get elements of the vector

## vector_4.xwyz

```lua
function vector_4:xwyz()
  -> number * 4
```

Get elements of the vector

## vector_4.xwz

```lua
function vector_4:xwz()
  -> number, number, number
```

Get elements of the vector

## vector_4.xwzw

```lua
function vector_4:xwzw()
  -> number * 4
```

Get elements of the vector

## vector_4.xwzx

```lua
function vector_4:xwzx()
  -> number * 4
```

Get elements of the vector

## vector_4.xwzy

```lua
function vector_4:xwzy()
  -> number * 4
```

Get elements of the vector

## vector_4.xwzz

```lua
function vector_4:xwzz()
  -> number * 4
```

Get elements of the vector

## vector_4.xx

```lua
function vector_4:xx()
  -> number, number
```

Get elements of the vector

## vector_4.xxw

```lua
function vector_4:xxw()
  -> number, number, number
```

Get elements of the vector

## vector_4.xxww

```lua
function vector_4:xxww()
  -> number * 4
```

Get elements of the vector

## vector_4.xxwx

```lua
function vector_4:xxwx()
  -> number * 4
```

Get elements of the vector

## vector_4.xxwy

```lua
function vector_4:xxwy()
  -> number * 4
```

Get elements of the vector

## vector_4.xxwz

```lua
function vector_4:xxwz()
  -> number * 4
```

Get elements of the vector

## vector_4.xxx

```lua
function vector_4:xxx()
  -> number, number, number
```

Get elements of the vector

## vector_4.xxxw

```lua
function vector_4:xxxw()
  -> number * 4
```

Get elements of the vector

## vector_4.xxxx

```lua
function vector_4:xxxx()
  -> number * 4
```

Get elements of the vector

## vector_4.xxxy

```lua
function vector_4:xxxy()
  -> number * 4
```

Get elements of the vector

## vector_4.xxxz

```lua
function vector_4:xxxz()
  -> number * 4
```

Get elements of the vector

## vector_4.xxy

```lua
function vector_4:xxy()
  -> number, number, number
```

Get elements of the vector

## vector_4.xxyw

```lua
function vector_4:xxyw()
  -> number * 4
```

Get elements of the vector

## vector_4.xxyx

```lua
function vector_4:xxyx()
  -> number * 4
```

Get elements of the vector

## vector_4.xxyy

```lua
function vector_4:xxyy()
  -> number * 4
```

Get elements of the vector

## vector_4.xxyz

```lua
function vector_4:xxyz()
  -> number * 4
```

Get elements of the vector

## vector_4.xxz

```lua
function vector_4:xxz()
  -> number, number, number
```

Get elements of the vector

## vector_4.xxzw

```lua
function vector_4:xxzw()
  -> number * 4
```

Get elements of the vector

## vector_4.xxzx

```lua
function vector_4:xxzx()
  -> number * 4
```

Get elements of the vector

## vector_4.xxzy

```lua
function vector_4:xxzy()
  -> number * 4
```

Get elements of the vector

## vector_4.xxzz

```lua
function vector_4:xxzz()
  -> number * 4
```

Get elements of the vector

## vector_4.xy

```lua
function vector_4:xy()
  -> number, number
```

Get elements of the vector

## vector_4.xyw

```lua
function vector_4:xyw()
  -> number, number, number
```

Get elements of the vector

## vector_4.xyww

```lua
function vector_4:xyww()
  -> number * 4
```

Get elements of the vector

## vector_4.xywx

```lua
function vector_4:xywx()
  -> number * 4
```

Get elements of the vector

## vector_4.xywy

```lua
function vector_4:xywy()
  -> number * 4
```

Get elements of the vector

## vector_4.xywz

```lua
function vector_4:xywz()
  -> number * 4
```

Get elements of the vector

## vector_4.xyx

```lua
function vector_4:xyx()
  -> number, number, number
```

Get elements of the vector

## vector_4.xyxw

```lua
function vector_4:xyxw()
  -> number * 4
```

Get elements of the vector

## vector_4.xyxx

```lua
function vector_4:xyxx()
  -> number * 4
```

Get elements of the vector

## vector_4.xyxy

```lua
function vector_4:xyxy()
  -> number * 4
```

Get elements of the vector

## vector_4.xyxz

```lua
function vector_4:xyxz()
  -> number * 4
```

Get elements of the vector

## vector_4.xyy

```lua
function vector_4:xyy()
  -> number, number, number
```

Get elements of the vector

## vector_4.xyyw

```lua
function vector_4:xyyw()
  -> number * 4
```

Get elements of the vector

## vector_4.xyyx

```lua
function vector_4:xyyx()
  -> number * 4
```

Get elements of the vector

## vector_4.xyyy

```lua
function vector_4:xyyy()
  -> number * 4
```

Get elements of the vector

## vector_4.xyyz

```lua
function vector_4:xyyz()
  -> number * 4
```

Get elements of the vector

## vector_4.xyz

```lua
function vector_4:xyz()
  -> number, number, number
```

Get elements of the vector

## vector_4.xyzw

```lua
function vector_4:xyzw()
  -> number * 4
```

Get elements of the vector

## vector_4.xyzx

```lua
function vector_4:xyzx()
  -> number * 4
```

Get elements of the vector

## vector_4.xyzy

```lua
function vector_4:xyzy()
  -> number * 4
```

Get elements of the vector

## vector_4.xyzz

```lua
function vector_4:xyzz()
  -> number * 4
```

Get elements of the vector

## vector_4.xz

```lua
function vector_4:xz()
  -> number, number
```

Get elements of the vector

## vector_4.xzw

```lua
function vector_4:xzw()
  -> number, number, number
```

Get elements of the vector

## vector_4.xzww

```lua
function vector_4:xzww()
  -> number * 4
```

Get elements of the vector

## vector_4.xzwx

```lua
function vector_4:xzwx()
  -> number * 4
```

Get elements of the vector

## vector_4.xzwy

```lua
function vector_4:xzwy()
  -> number * 4
```

Get elements of the vector

## vector_4.xzwz

```lua
function vector_4:xzwz()
  -> number * 4
```

Get elements of the vector

## vector_4.xzx

```lua
function vector_4:xzx()
  -> number, number, number
```

Get elements of the vector

## vector_4.xzxw

```lua
function vector_4:xzxw()
  -> number * 4
```

Get elements of the vector

## vector_4.xzxx

```lua
function vector_4:xzxx()
  -> number * 4
```

Get elements of the vector

## vector_4.xzxy

```lua
function vector_4:xzxy()
  -> number * 4
```

Get elements of the vector

## vector_4.xzxz

```lua
function vector_4:xzxz()
  -> number * 4
```

Get elements of the vector

## vector_4.xzy

```lua
function vector_4:xzy()
  -> number, number, number
```

Get elements of the vector

## vector_4.xzyw

```lua
function vector_4:xzyw()
  -> number * 4
```

Get elements of the vector

## vector_4.xzyx

```lua
function vector_4:xzyx()
  -> number * 4
```

Get elements of the vector

## vector_4.xzyy

```lua
function vector_4:xzyy()
  -> number * 4
```

Get elements of the vector

## vector_4.xzyz

```lua
function vector_4:xzyz()
  -> number * 4
```

Get elements of the vector

## vector_4.xzz

```lua
function vector_4:xzz()
  -> number, number, number
```

Get elements of the vector

## vector_4.xzzw

```lua
function vector_4:xzzw()
  -> number * 4
```

Get elements of the vector

## vector_4.xzzx

```lua
function vector_4:xzzx()
  -> number * 4
```

Get elements of the vector

## vector_4.xzzy

```lua
function vector_4:xzzy()
  -> number * 4
```

Get elements of the vector

## vector_4.xzzz

```lua
function vector_4:xzzz()
  -> number * 4
```

Get elements of the vector

## vector_4.y

```lua
function vector_4:y()
  -> number
```

Get elements of the vector

## vector_4.yw

```lua
function vector_4:yw()
  -> number, number
```

Get elements of the vector

## vector_4.yww

```lua
function vector_4:yww()
  -> number, number, number
```

Get elements of the vector

## vector_4.ywww

```lua
function vector_4:ywww()
  -> number * 4
```

Get elements of the vector

## vector_4.ywwx

```lua
function vector_4:ywwx()
  -> number * 4
```

Get elements of the vector

## vector_4.ywwy

```lua
function vector_4:ywwy()
  -> number * 4
```

Get elements of the vector

## vector_4.ywwz

```lua
function vector_4:ywwz()
  -> number * 4
```

Get elements of the vector

## vector_4.ywx

```lua
function vector_4:ywx()
  -> number, number, number
```

Get elements of the vector

## vector_4.ywxw

```lua
function vector_4:ywxw()
  -> number * 4
```

Get elements of the vector

## vector_4.ywxx

```lua
function vector_4:ywxx()
  -> number * 4
```

Get elements of the vector

## vector_4.ywxy

```lua
function vector_4:ywxy()
  -> number * 4
```

Get elements of the vector

## vector_4.ywxz

```lua
function vector_4:ywxz()
  -> number * 4
```

Get elements of the vector

## vector_4.ywy

```lua
function vector_4:ywy()
  -> number, number, number
```

Get elements of the vector

## vector_4.ywyw

```lua
function vector_4:ywyw()
  -> number * 4
```

Get elements of the vector

## vector_4.ywyx

```lua
function vector_4:ywyx()
  -> number * 4
```

Get elements of the vector

## vector_4.ywyy

```lua
function vector_4:ywyy()
  -> number * 4
```

Get elements of the vector

## vector_4.ywyz

```lua
function vector_4:ywyz()
  -> number * 4
```

Get elements of the vector

## vector_4.ywz

```lua
function vector_4:ywz()
  -> number, number, number
```

Get elements of the vector

## vector_4.ywzw

```lua
function vector_4:ywzw()
  -> number * 4
```

Get elements of the vector

## vector_4.ywzx

```lua
function vector_4:ywzx()
  -> number * 4
```

Get elements of the vector

## vector_4.ywzy

```lua
function vector_4:ywzy()
  -> number * 4
```

Get elements of the vector

## vector_4.ywzz

```lua
function vector_4:ywzz()
  -> number * 4
```

Get elements of the vector

## vector_4.yx

```lua
function vector_4:yx()
  -> number, number
```

Get elements of the vector

## vector_4.yxw

```lua
function vector_4:yxw()
  -> number, number, number
```

Get elements of the vector

## vector_4.yxww

```lua
function vector_4:yxww()
  -> number * 4
```

Get elements of the vector

## vector_4.yxwx

```lua
function vector_4:yxwx()
  -> number * 4
```

Get elements of the vector

## vector_4.yxwy

```lua
function vector_4:yxwy()
  -> number * 4
```

Get elements of the vector

## vector_4.yxwz

```lua
function vector_4:yxwz()
  -> number * 4
```

Get elements of the vector

## vector_4.yxx

```lua
function vector_4:yxx()
  -> number, number, number
```

Get elements of the vector

## vector_4.yxxw

```lua
function vector_4:yxxw()
  -> number * 4
```

Get elements of the vector

## vector_4.yxxx

```lua
function vector_4:yxxx()
  -> number * 4
```

Get elements of the vector

## vector_4.yxxy

```lua
function vector_4:yxxy()
  -> number * 4
```

Get elements of the vector

## vector_4.yxxz

```lua
function vector_4:yxxz()
  -> number * 4
```

Get elements of the vector

## vector_4.yxy

```lua
function vector_4:yxy()
  -> number, number, number
```

Get elements of the vector

## vector_4.yxyw

```lua
function vector_4:yxyw()
  -> number * 4
```

Get elements of the vector

## vector_4.yxyx

```lua
function vector_4:yxyx()
  -> number * 4
```

Get elements of the vector

## vector_4.yxyy

```lua
function vector_4:yxyy()
  -> number * 4
```

Get elements of the vector

## vector_4.yxyz

```lua
function vector_4:yxyz()
  -> number * 4
```

Get elements of the vector

## vector_4.yxz

```lua
function vector_4:yxz()
  -> number, number, number
```

Get elements of the vector

## vector_4.yxzw

```lua
function vector_4:yxzw()
  -> number * 4
```

Get elements of the vector

## vector_4.yxzx

```lua
function vector_4:yxzx()
  -> number * 4
```

Get elements of the vector

## vector_4.yxzy

```lua
function vector_4:yxzy()
  -> number * 4
```

Get elements of the vector

## vector_4.yxzz

```lua
function vector_4:yxzz()
  -> number * 4
```

Get elements of the vector

## vector_4.yy

```lua
function vector_4:yy()
  -> number, number
```

Get elements of the vector

## vector_4.yyw

```lua
function vector_4:yyw()
  -> number, number, number
```

Get elements of the vector

## vector_4.yyww

```lua
function vector_4:yyww()
  -> number * 4
```

Get elements of the vector

## vector_4.yywx

```lua
function vector_4:yywx()
  -> number * 4
```

Get elements of the vector

## vector_4.yywy

```lua
function vector_4:yywy()
  -> number * 4
```

Get elements of the vector

## vector_4.yywz

```lua
function vector_4:yywz()
  -> number * 4
```

Get elements of the vector

## vector_4.yyx

```lua
function vector_4:yyx()
  -> number, number, number
```

Get elements of the vector

## vector_4.yyxw

```lua
function vector_4:yyxw()
  -> number * 4
```

Get elements of the vector

## vector_4.yyxx

```lua
function vector_4:yyxx()
  -> number * 4
```

Get elements of the vector

## vector_4.yyxy

```lua
function vector_4:yyxy()
  -> number * 4
```

Get elements of the vector

## vector_4.yyxz

```lua
function vector_4:yyxz()
  -> number * 4
```

Get elements of the vector

## vector_4.yyy

```lua
function vector_4:yyy()
  -> number, number, number
```

Get elements of the vector

## vector_4.yyyw

```lua
function vector_4:yyyw()
  -> number * 4
```

Get elements of the vector

## vector_4.yyyx

```lua
function vector_4:yyyx()
  -> number * 4
```

Get elements of the vector

## vector_4.yyyy

```lua
function vector_4:yyyy()
  -> number * 4
```

Get elements of the vector

## vector_4.yyyz

```lua
function vector_4:yyyz()
  -> number * 4
```

Get elements of the vector

## vector_4.yyz

```lua
function vector_4:yyz()
  -> number, number, number
```

Get elements of the vector

## vector_4.yyzw

```lua
function vector_4:yyzw()
  -> number * 4
```

Get elements of the vector

## vector_4.yyzx

```lua
function vector_4:yyzx()
  -> number * 4
```

Get elements of the vector

## vector_4.yyzy

```lua
function vector_4:yyzy()
  -> number * 4
```

Get elements of the vector

## vector_4.yyzz

```lua
function vector_4:yyzz()
  -> number * 4
```

Get elements of the vector

## vector_4.yz

```lua
function vector_4:yz()
  -> number, number
```

Get elements of the vector

## vector_4.yzw

```lua
function vector_4:yzw()
  -> number, number, number
```

Get elements of the vector

## vector_4.yzww

```lua
function vector_4:yzww()
  -> number * 4
```

Get elements of the vector

## vector_4.yzwx

```lua
function vector_4:yzwx()
  -> number * 4
```

Get elements of the vector

## vector_4.yzwy

```lua
function vector_4:yzwy()
  -> number * 4
```

Get elements of the vector

## vector_4.yzwz

```lua
function vector_4:yzwz()
  -> number * 4
```

Get elements of the vector

## vector_4.yzx

```lua
function vector_4:yzx()
  -> number, number, number
```

Get elements of the vector

## vector_4.yzxw

```lua
function vector_4:yzxw()
  -> number * 4
```

Get elements of the vector

## vector_4.yzxx

```lua
function vector_4:yzxx()
  -> number * 4
```

Get elements of the vector

## vector_4.yzxy

```lua
function vector_4:yzxy()
  -> number * 4
```

Get elements of the vector

## vector_4.yzxz

```lua
function vector_4:yzxz()
  -> number * 4
```

Get elements of the vector

## vector_4.yzy

```lua
function vector_4:yzy()
  -> number, number, number
```

Get elements of the vector

## vector_4.yzyw

```lua
function vector_4:yzyw()
  -> number * 4
```

Get elements of the vector

## vector_4.yzyx

```lua
function vector_4:yzyx()
  -> number * 4
```

Get elements of the vector

## vector_4.yzyy

```lua
function vector_4:yzyy()
  -> number * 4
```

Get elements of the vector

## vector_4.yzyz

```lua
function vector_4:yzyz()
  -> number * 4
```

Get elements of the vector

## vector_4.yzz

```lua
function vector_4:yzz()
  -> number, number, number
```

Get elements of the vector

## vector_4.yzzw

```lua
function vector_4:yzzw()
  -> number * 4
```

Get elements of the vector

## vector_4.yzzx

```lua
function vector_4:yzzx()
  -> number * 4
```

Get elements of the vector

## vector_4.yzzy

```lua
function vector_4:yzzy()
  -> number * 4
```

Get elements of the vector

## vector_4.yzzz

```lua
function vector_4:yzzz()
  -> number * 4
```

Get elements of the vector

## vector_4.z

```lua
function vector_4:z()
  -> number
```

Get elements of the vector

## vector_4.zw

```lua
function vector_4:zw()
  -> number, number
```

Get elements of the vector

## vector_4.zww

```lua
function vector_4:zww()
  -> number, number, number
```

Get elements of the vector

## vector_4.zwww

```lua
function vector_4:zwww()
  -> number * 4
```

Get elements of the vector

## vector_4.zwwx

```lua
function vector_4:zwwx()
  -> number * 4
```

Get elements of the vector

## vector_4.zwwy

```lua
function vector_4:zwwy()
  -> number * 4
```

Get elements of the vector

## vector_4.zwwz

```lua
function vector_4:zwwz()
  -> number * 4
```

Get elements of the vector

## vector_4.zwx

```lua
function vector_4:zwx()
  -> number, number, number
```

Get elements of the vector

## vector_4.zwxw

```lua
function vector_4:zwxw()
  -> number * 4
```

Get elements of the vector

## vector_4.zwxx

```lua
function vector_4:zwxx()
  -> number * 4
```

Get elements of the vector

## vector_4.zwxy

```lua
function vector_4:zwxy()
  -> number * 4
```

Get elements of the vector

## vector_4.zwxz

```lua
function vector_4:zwxz()
  -> number * 4
```

Get elements of the vector

## vector_4.zwy

```lua
function vector_4:zwy()
  -> number, number, number
```

Get elements of the vector

## vector_4.zwyw

```lua
function vector_4:zwyw()
  -> number * 4
```

Get elements of the vector

## vector_4.zwyx

```lua
function vector_4:zwyx()
  -> number * 4
```

Get elements of the vector

## vector_4.zwyy

```lua
function vector_4:zwyy()
  -> number * 4
```

Get elements of the vector

## vector_4.zwyz

```lua
function vector_4:zwyz()
  -> number * 4
```

Get elements of the vector

## vector_4.zwz

```lua
function vector_4:zwz()
  -> number, number, number
```

Get elements of the vector

## vector_4.zwzw

```lua
function vector_4:zwzw()
  -> number * 4
```

Get elements of the vector

## vector_4.zwzx

```lua
function vector_4:zwzx()
  -> number * 4
```

Get elements of the vector

## vector_4.zwzy

```lua
function vector_4:zwzy()
  -> number * 4
```

Get elements of the vector

## vector_4.zwzz

```lua
function vector_4:zwzz()
  -> number * 4
```

Get elements of the vector

## vector_4.zx

```lua
function vector_4:zx()
  -> number, number
```

Get elements of the vector

## vector_4.zxw

```lua
function vector_4:zxw()
  -> number, number, number
```

Get elements of the vector

## vector_4.zxww

```lua
function vector_4:zxww()
  -> number * 4
```

Get elements of the vector

## vector_4.zxwx

```lua
function vector_4:zxwx()
  -> number * 4
```

Get elements of the vector

## vector_4.zxwy

```lua
function vector_4:zxwy()
  -> number * 4
```

Get elements of the vector

## vector_4.zxwz

```lua
function vector_4:zxwz()
  -> number * 4
```

Get elements of the vector

## vector_4.zxx

```lua
function vector_4:zxx()
  -> number, number, number
```

Get elements of the vector

## vector_4.zxxw

```lua
function vector_4:zxxw()
  -> number * 4
```

Get elements of the vector

## vector_4.zxxx

```lua
function vector_4:zxxx()
  -> number * 4
```

Get elements of the vector

## vector_4.zxxy

```lua
function vector_4:zxxy()
  -> number * 4
```

Get elements of the vector

## vector_4.zxxz

```lua
function vector_4:zxxz()
  -> number * 4
```

Get elements of the vector

## vector_4.zxy

```lua
function vector_4:zxy()
  -> number, number, number
```

Get elements of the vector

## vector_4.zxyw

```lua
function vector_4:zxyw()
  -> number * 4
```

Get elements of the vector

## vector_4.zxyx

```lua
function vector_4:zxyx()
  -> number * 4
```

Get elements of the vector

## vector_4.zxyy

```lua
function vector_4:zxyy()
  -> number * 4
```

Get elements of the vector

## vector_4.zxyz

```lua
function vector_4:zxyz()
  -> number * 4
```

Get elements of the vector

## vector_4.zxz

```lua
function vector_4:zxz()
  -> number, number, number
```

Get elements of the vector

## vector_4.zxzw

```lua
function vector_4:zxzw()
  -> number * 4
```

Get elements of the vector

## vector_4.zxzx

```lua
function vector_4:zxzx()
  -> number * 4
```

Get elements of the vector

## vector_4.zxzy

```lua
function vector_4:zxzy()
  -> number * 4
```

Get elements of the vector

## vector_4.zxzz

```lua
function vector_4:zxzz()
  -> number * 4
```

Get elements of the vector

## vector_4.zy

```lua
function vector_4:zy()
  -> number, number
```

Get elements of the vector

## vector_4.zyw

```lua
function vector_4:zyw()
  -> number, number, number
```

Get elements of the vector

## vector_4.zyww

```lua
function vector_4:zyww()
  -> number * 4
```

Get elements of the vector

## vector_4.zywx

```lua
function vector_4:zywx()
  -> number * 4
```

Get elements of the vector

## vector_4.zywy

```lua
function vector_4:zywy()
  -> number * 4
```

Get elements of the vector

## vector_4.zywz

```lua
function vector_4:zywz()
  -> number * 4
```

Get elements of the vector

## vector_4.zyx

```lua
function vector_4:zyx()
  -> number, number, number
```

Get elements of the vector

## vector_4.zyxw

```lua
function vector_4:zyxw()
  -> number * 4
```

Get elements of the vector

## vector_4.zyxx

```lua
function vector_4:zyxx()
  -> number * 4
```

Get elements of the vector

## vector_4.zyxy

```lua
function vector_4:zyxy()
  -> number * 4
```

Get elements of the vector

## vector_4.zyxz

```lua
function vector_4:zyxz()
  -> number * 4
```

Get elements of the vector

## vector_4.zyy

```lua
function vector_4:zyy()
  -> number, number, number
```

Get elements of the vector

## vector_4.zyyw

```lua
function vector_4:zyyw()
  -> number * 4
```

Get elements of the vector

## vector_4.zyyx

```lua
function vector_4:zyyx()
  -> number * 4
```

Get elements of the vector

## vector_4.zyyy

```lua
function vector_4:zyyy()
  -> number * 4
```

Get elements of the vector

## vector_4.zyyz

```lua
function vector_4:zyyz()
  -> number * 4
```

Get elements of the vector

## vector_4.zyz

```lua
function vector_4:zyz()
  -> number, number, number
```

Get elements of the vector

## vector_4.zyzw

```lua
function vector_4:zyzw()
  -> number * 4
```

Get elements of the vector

## vector_4.zyzx

```lua
function vector_4:zyzx()
  -> number * 4
```

Get elements of the vector

## vector_4.zyzy

```lua
function vector_4:zyzy()
  -> number * 4
```

Get elements of the vector

## vector_4.zyzz

```lua
function vector_4:zyzz()
  -> number * 4
```

Get elements of the vector

## vector_4.zz

```lua
function vector_4:zz()
  -> number, number
```

Get elements of the vector

## vector_4.zzw

```lua
function vector_4:zzw()
  -> number, number, number
```

Get elements of the vector

## vector_4.zzww

```lua
function vector_4:zzww()
  -> number * 4
```

Get elements of the vector

## vector_4.zzwx

```lua
function vector_4:zzwx()
  -> number * 4
```

Get elements of the vector

## vector_4.zzwy

```lua
function vector_4:zzwy()
  -> number * 4
```

Get elements of the vector

## vector_4.zzwz

```lua
function vector_4:zzwz()
  -> number * 4
```

Get elements of the vector

## vector_4.zzx

```lua
function vector_4:zzx()
  -> number, number, number
```

Get elements of the vector

## vector_4.zzxw

```lua
function vector_4:zzxw()
  -> number * 4
```

Get elements of the vector

## vector_4.zzxx

```lua
function vector_4:zzxx()
  -> number * 4
```

Get elements of the vector

## vector_4.zzxy

```lua
function vector_4:zzxy()
  -> number * 4
```

Get elements of the vector

## vector_4.zzxz

```lua
function vector_4:zzxz()
  -> number * 4
```

Get elements of the vector

## vector_4.zzy

```lua
function vector_4:zzy()
  -> number, number, number
```

Get elements of the vector

## vector_4.zzyw

```lua
function vector_4:zzyw()
  -> number * 4
```

Get elements of the vector

## vector_4.zzyx

```lua
function vector_4:zzyx()
  -> number * 4
```

Get elements of the vector

## vector_4.zzyy

```lua
function vector_4:zzyy()
  -> number * 4
```

Get elements of the vector

## vector_4.zzyz

```lua
function vector_4:zzyz()
  -> number * 4
```

Get elements of the vector

## vector_4.zzz

```lua
function vector_4:zzz()
  -> number, number, number
```

Get elements of the vector

## vector_4.zzzw

```lua
function vector_4:zzzw()
  -> number * 4
```

Get elements of the vector

## vector_4.zzzx

```lua
function vector_4:zzzx()
  -> number * 4
```

Get elements of the vector

## vector_4.zzzy

```lua
function vector_4:zzzy()
  -> number * 4
```

Get elements of the vector

## vector_4.zzzz

```lua
function vector_4:zzzz()
  -> number * 4
```

Get elements of the vector


---

# format
Format  

Functions for converting arrays into readable strings  

## format.array

```lua
function format.array(src: array<T>, separator?: string, format?: string)
  -> string
```

Format an array as a string of comma-separated values
Example:
```
format.array({1,2,3}) --> "1, 2, 3"
```

@*param* `separator` — default ", "

@*param* `format` — format string for each element

## format.mat1

```lua
function format.mat1(src: number1, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat1x1

```lua
function format.mat1x1(src: number1, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat1x2

```lua
function format.mat1x2(src: number2, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat1x3

```lua
function format.mat1x3(src: number3, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat1x4

```lua
function format.mat1x4(src: number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat2

```lua
function format.mat2(src: number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat2x1

```lua
function format.mat2x1(src: number2, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat2x2

```lua
function format.mat2x2(src: number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat2x3

```lua
function format.mat2x3(src: number6, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat2x4

```lua
function format.mat2x4(src: number8, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat3

```lua
function format.mat3(src: number9, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat3x1

```lua
function format.mat3x1(src: number3, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat3x2

```lua
function format.mat3x2(src: number6, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat3x3

```lua
function format.mat3x3(src: number9, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat3x4

```lua
function format.mat3x4(src: number12, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat4

```lua
function format.mat4(src: number16, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat4x1

```lua
function format.mat4x1(src: number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat4x2

```lua
function format.mat4x2(src: number8, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat4x3

```lua
function format.mat4x3(src: number12, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.mat4x4

```lua
function format.mat4x4(src: number16, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## format.matrix

```lua
function format.matrix(src: seq_number, src_index: integer, num_cols: any, num_rows: any, format?: string, options?: { row_major_order: boolean })
  -> string
```

Format a slice as a 2d matrix

By default will assume the data is in column-major order, but this can be changed with the option `row_major_order = true`

## format.slice

```lua
function format.slice(src: seq<T>, src_index: integer, src_count: integer, separator?: string, format?: string)
  -> string
```

Format a slice as a string of comma-separated values
Example:
```
format.slice({1,2,3,4}, 1, 3) --> "1, 2, 3"
```

@*param* `separator` — default ", "

@*param* `format` — format string for each element

## format.tabulated

```lua
function format.tabulated(table_format: any, num_rows: integer, column_1: { data: seq<any>, index: integer, count: integer, group_size: integer, label: string, format: string }, ...{ data: seq<any>, index: integer, count: integer, group_size: integer, label: string, format: string })
  -> string
```

Tabulate multiple arrays of data

Each column is a table with some or all of the following fields:
* `data` - the sequence or array of data
* `index?` - the index of the first element in the sequence (default = 1)
* `count?` - the number of elements in the sequence (default = #data)
* `group_size?` - the number of elements in each group (default = 1)
* `label?` - the column label (default = "")
* `format?` - the format string for each element (default = "%s")

Example output for 3 arrays storing position, index and mass:
```
    pos     idx   mass
1 | 0,0,0 | 0   | 1
2 | 0,1,0 | 1   | 1 
3 | 2,0,1 | 2   | 1.5
```


---

# iterator
Iterator  

Special purpose iterators  

## iterator.group_2

```lua
function iterator.group_2(src: array<T>)
  -> fun():integer, T, T
```

Create an iterator over an array that returns consecutive tuples of 2 elements

NOTE: the returned index is the index of *the group*

## iterator.group_3

```lua
function iterator.group_3(src: array<T>)
  -> fun():integer, T, T, T
```

Create an iterator over an array that returns consecutive tuples of 3 elements

NOTE: the returned index is the index of *the group*

## iterator.group_4

```lua
function iterator.group_4(src: array<T>)
  -> fun():integer, T * 4
```

Create an iterator over an array that returns consecutive tuples of 4 elements

NOTE: the returned index is the index of *the group*

## iterator.group_5

```lua
function iterator.group_5(src: array<T>)
  -> fun():integer, T * 5
```

Create an iterator over an array that returns consecutive tuples of 5 elements

NOTE: the returned index is the index of *the group*

## iterator.group_6

```lua
function iterator.group_6(src: array<T>)
  -> fun():integer, T * 6
```

Create an iterator over an array that returns consecutive tuples of 6 elements

NOTE: the returned index is the index of *the group*

## iterator.group_7

```lua
function iterator.group_7(src: array<T>)
  -> fun():integer, T * 7
```

Create an iterator over an array that returns consecutive tuples of 7 elements

NOTE: the returned index is the index of *the group*

## iterator.group_8

```lua
function iterator.group_8(src: array<T>)
  -> fun():integer, T * 8
```

Create an iterator over an array that returns consecutive tuples of 8 elements

NOTE: the returned index is the index of *the group*

## iterator.group_9

```lua
function iterator.group_9(src: array<T>)
  -> fun():integer, T * 9
```

Create an iterator over an array that returns consecutive tuples of 9 elements

NOTE: the returned index is the index of *the group*

## iterator.group_10

```lua
function iterator.group_10(src: array<T>)
  -> fun():integer, T * 10
```

Create an iterator over an array that returns consecutive tuples of 10 elements

NOTE: the returned index is the index of *the group*

## iterator.group_10_ex

```lua
function iterator.group_10_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 10
```

Create an iterator over a slice that returns consecutive tuples of 10 elements

NOTE: the returned index is the index of *the group*

## iterator.group_11

```lua
function iterator.group_11(src: array<T>)
  -> fun():integer, T * 11
```

Create an iterator over an array that returns consecutive tuples of 11 elements

NOTE: the returned index is the index of *the group*

## iterator.group_11_ex

```lua
function iterator.group_11_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 11
```

Create an iterator over a slice that returns consecutive tuples of 11 elements

NOTE: the returned index is the index of *the group*

## iterator.group_12

```lua
function iterator.group_12(src: array<T>)
  -> fun():integer, T * 12
```

Create an iterator over an array that returns consecutive tuples of 12 elements

NOTE: the returned index is the index of *the group*

## iterator.group_12_ex

```lua
function iterator.group_12_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 12
```

Create an iterator over a slice that returns consecutive tuples of 12 elements

NOTE: the returned index is the index of *the group*

## iterator.group_13

```lua
function iterator.group_13(src: array<T>)
  -> fun():integer, T * 13
```

Create an iterator over an array that returns consecutive tuples of 13 elements

NOTE: the returned index is the index of *the group*

## iterator.group_13_ex

```lua
function iterator.group_13_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 13
```

Create an iterator over a slice that returns consecutive tuples of 13 elements

NOTE: the returned index is the index of *the group*

## iterator.group_14

```lua
function iterator.group_14(src: array<T>)
  -> fun():integer, T * 14
```

Create an iterator over an array that returns consecutive tuples of 14 elements

NOTE: the returned index is the index of *the group*

## iterator.group_14_ex

```lua
function iterator.group_14_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 14
```

Create an iterator over a slice that returns consecutive tuples of 14 elements

NOTE: the returned index is the index of *the group*

## iterator.group_15

```lua
function iterator.group_15(src: array<T>)
  -> fun():integer, T * 15
```

Create an iterator over an array that returns consecutive tuples of 15 elements

NOTE: the returned index is the index of *the group*

## iterator.group_15_ex

```lua
function iterator.group_15_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 15
```

Create an iterator over a slice that returns consecutive tuples of 15 elements

NOTE: the returned index is the index of *the group*

## iterator.group_16

```lua
function iterator.group_16(src: array<T>)
  -> fun():integer, T * 16
```

Create an iterator over an array that returns consecutive tuples of 16 elements

NOTE: the returned index is the index of *the group*

## iterator.group_16_ex

```lua
function iterator.group_16_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 16
```

Create an iterator over a slice that returns consecutive tuples of 16 elements

NOTE: the returned index is the index of *the group*

## iterator.group_2_ex

```lua
function iterator.group_2_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T, T
```

Create an iterator over a slice that returns consecutive tuples of 2 elements

NOTE: the returned index is the index of *the group*

## iterator.group_3_ex

```lua
function iterator.group_3_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T, T, T
```

Create an iterator over a slice that returns consecutive tuples of 3 elements

NOTE: the returned index is the index of *the group*

## iterator.group_4_ex

```lua
function iterator.group_4_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 4
```

Create an iterator over a slice that returns consecutive tuples of 4 elements

NOTE: the returned index is the index of *the group*

## iterator.group_5_ex

```lua
function iterator.group_5_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 5
```

Create an iterator over a slice that returns consecutive tuples of 5 elements

NOTE: the returned index is the index of *the group*

## iterator.group_6_ex

```lua
function iterator.group_6_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 6
```

Create an iterator over a slice that returns consecutive tuples of 6 elements

NOTE: the returned index is the index of *the group*

## iterator.group_7_ex

```lua
function iterator.group_7_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 7
```

Create an iterator over a slice that returns consecutive tuples of 7 elements

NOTE: the returned index is the index of *the group*

## iterator.group_8_ex

```lua
function iterator.group_8_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 8
```

Create an iterator over a slice that returns consecutive tuples of 8 elements

NOTE: the returned index is the index of *the group*

## iterator.group_9_ex

```lua
function iterator.group_9_ex(src: seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, T * 9
```

Create an iterator over a slice that returns consecutive tuples of 9 elements

NOTE: the returned index is the index of *the group*

## iterator.zip_1

```lua
function iterator.zip_1(a: array<T>, b: array<T>)
  -> fun():integer, T, T
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_2

```lua
function iterator.zip_2(a: array<T>, b: array<T>)
  -> fun():integer, T * 4
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_3

```lua
function iterator.zip_3(a: array<T>, b: array<T>)
  -> fun():integer, T * 6
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_4

```lua
function iterator.zip_4(a: array<T>, b: array<T>)
  -> fun():integer, T * 8
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_5

```lua
function iterator.zip_5(a: array<T>, b: array<T>)
  -> fun():integer, T * 10
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_6

```lua
function iterator.zip_6(a: array<T>, b: array<T>)
  -> fun():integer, T * 12
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_7

```lua
function iterator.zip_7(a: array<T>, b: array<T>)
  -> fun():integer, T * 14
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_8

```lua
function iterator.zip_8(a: array<T>, b: array<T>)
  -> fun():integer, T * 16
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_9

```lua
function iterator.zip_9(a: array<T>, b: array<T>)
  -> fun():integer, T * 18
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_10

```lua
function iterator.zip_10(a: array<T>, b: array<T>)
  -> fun():integer, T * 20
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_10_ex

```lua
function iterator.zip_10_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 20
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_11

```lua
function iterator.zip_11(a: array<T>, b: array<T>)
  -> fun():integer, T * 22
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_11_ex

```lua
function iterator.zip_11_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 22
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_12

```lua
function iterator.zip_12(a: array<T>, b: array<T>)
  -> fun():integer, T * 24
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_12_ex

```lua
function iterator.zip_12_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 24
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_13

```lua
function iterator.zip_13(a: array<T>, b: array<T>)
  -> fun():integer, T * 26
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_13_ex

```lua
function iterator.zip_13_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 26
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_14

```lua
function iterator.zip_14(a: array<T>, b: array<T>)
  -> fun():integer, T * 28
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_14_ex

```lua
function iterator.zip_14_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 28
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_15

```lua
function iterator.zip_15(a: array<T>, b: array<T>)
  -> fun():integer, T * 30
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_15_ex

```lua
function iterator.zip_15_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 30
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_16

```lua
function iterator.zip_16(a: array<T>, b: array<T>)
  -> fun():integer, T * 32
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_16_ex

```lua
function iterator.zip_16_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 32
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_1_ex

```lua
function iterator.zip_1_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T, T
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_2_ex

```lua
function iterator.zip_2_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 4
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_3_ex

```lua
function iterator.zip_3_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 6
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_4_ex

```lua
function iterator.zip_4_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 8
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_5_ex

```lua
function iterator.zip_5_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 10
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_6_ex

```lua
function iterator.zip_6_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 12
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_7_ex

```lua
function iterator.zip_7_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 14
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_8_ex

```lua
function iterator.zip_8_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 16
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## iterator.zip_9_ex

```lua
function iterator.zip_9_ex(a: seq<T>, a_index: integer, a_count: integer, b: seq<T>, b_index: integer)
  -> fun():integer, T * 18
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`


---

# linalg
Linear algebra routines  

Functions for operating on numerical vectors and matrices up to 4 dimensions  

## linalg.add_2

```lua
function linalg.add_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the addition operator to two 2-tuples

## linalg.add_3

```lua
function linalg.add_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the addition operator to two 3-tuples

## linalg.add_4

```lua
function linalg.add_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the addition operator to two 4-tuples

## linalg.add_mat2

```lua
function linalg.add_mat2(a: number4, b: number4)
  -> number * 4
```

Apply the addition operator to each element in two 2x2 matrices

## linalg.add_mat2_constant

```lua
function linalg.add_mat2_constant(a: number4, c: number)
  -> number * 4
```

Apply the addition operator to each element in a 2x2 matrix and a constant

## linalg.add_mat2_constant_ex

```lua
function linalg.add_mat2_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## linalg.add_mat2_constant_ex

```lua
function linalg.add_mat2_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the addition operator to each element in a 2x2 matrix in a slice and a constant

## linalg.add_mat2_ex

```lua
function linalg.add_mat2_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in two 2d-vectors in a slice and store the result in a destination

## linalg.add_mat2_ex

```lua
function linalg.add_mat2_ex(a: seq_number4, a_index: integer, b: seq_number2, b_index: integer)
  -> number * 4
```

Apply the addition operator to each element in two 2x2 matrices in a slice

## linalg.add_mat3

```lua
function linalg.add_mat3(a: number9, b: number9)
  -> number * 9
```

Apply the addition operator to each element in two 3x3 matrices

## linalg.add_mat3_constant

```lua
function linalg.add_mat3_constant(a: number9, c: number)
  -> number * 9
```

Apply the addition operator to each element in a 3x3 matrix and a constant

## linalg.add_mat3_constant_ex

```lua
function linalg.add_mat3_constant_ex(a: seq_number9, a_index: integer, c: number)
  -> number * 9
```

Apply the addition operator to each element in a 3x3 matrix in a slice and a constant

## linalg.add_mat3_constant_ex

```lua
function linalg.add_mat3_constant_ex(a: seq_number9, a_index: integer, c: number, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## linalg.add_mat3_ex

```lua
function linalg.add_mat3_ex(a: seq_number9, a_index: integer, b: seq_number3, b_index: integer)
  -> number * 9
```

Apply the addition operator to each element in two 3x3 matrices in a slice

## linalg.add_mat3_ex

```lua
function linalg.add_mat3_ex(a: seq_number9, a_index: integer, b: seq_number9, b_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in two 3d-vectors in a slice and store the result in a destination

## linalg.add_mat4

```lua
function linalg.add_mat4(a: number16, b: number16)
  -> number * 16
```

Apply the addition operator to each element in two 4x4 matrices

## linalg.add_mat4_constant

```lua
function linalg.add_mat4_constant(a: number16, c: number)
  -> number * 16
```

Apply the addition operator to each element in a 4x4 matrix and a constant

## linalg.add_mat4_constant_ex

```lua
function linalg.add_mat4_constant_ex(a: seq_number16, a_index: integer, c: number)
  -> number * 16
```

Apply the addition operator to each element in a 4x4 matrix in a slice and a constant

## linalg.add_mat4_constant_ex

```lua
function linalg.add_mat4_constant_ex(a: seq_number16, a_index: integer, c: number, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## linalg.add_mat4_ex

```lua
function linalg.add_mat4_ex(a: seq_number16, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 16
```

Apply the addition operator to each element in two 4x4 matrices in a slice

## linalg.add_mat4_ex

```lua
function linalg.add_mat4_ex(a: seq_number16, a_index: integer, b: seq_number16, b_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in two 4d-vectors in a slice and store the result in a destination

## linalg.add_vec2

```lua
function linalg.add_vec2(a: number2, b: number2)
  -> number, number
```

Apply the addition operator to two 2d-vectors

## linalg.add_vec2_constant

```lua
function linalg.add_vec2_constant(a: number2, c: number)
  -> number, number
```

Apply the addition operator to a 2d-vector and a constant

## linalg.add_vec2_constant_ex

```lua
function linalg.add_vec2_constant_ex(a: seq_number2, a_index: integer, c: number, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the addition operator to a 2d-vector in a slice and a constant and store in a destination

## linalg.add_vec2_constant_ex

```lua
function linalg.add_vec2_constant_ex(a: seq_number2, a_index: integer, c: number)
  -> number, number
```

Apply the addition operator to a 2d-vector in a slice and a constant

## linalg.add_vec2_ex

```lua
function linalg.add_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the addition operator to two 2d-vectors in a slice and store the result in a destination

## linalg.add_vec2_ex

```lua
function linalg.add_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer)
  -> number, number
```

Apply the addition operator to two 2d-vectors in a slice

## linalg.add_vec3

```lua
function linalg.add_vec3(a: number3, b: number3)
  -> number, number, number
```

Apply the addition operator to two 3d-vectors

## linalg.add_vec3_constant

```lua
function linalg.add_vec3_constant(a: number3, c: number)
  -> number, number, number
```

Apply the addition operator to a 3d-vector and a constant

## linalg.add_vec3_constant_ex

```lua
function linalg.add_vec3_constant_ex(a: seq_number3, a_index: integer, c: number)
  -> number, number, number
```

Apply the addition operator to a 3d-vector in a slice and a constant

## linalg.add_vec3_constant_ex

```lua
function linalg.add_vec3_constant_ex(a: seq_number3, a_index: integer, c: number, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the addition operator to a 3d-vector in a slice and a constant and store in a destination

## linalg.add_vec3_ex

```lua
function linalg.add_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number, number, number
```

Apply the addition operator to two 3d-vectors in a slice

## linalg.add_vec3_ex

```lua
function linalg.add_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the addition operator to two 3d-vectors in a slice and store the result in a destination

## linalg.add_vec4

```lua
function linalg.add_vec4(a: number4, b: number4)
  -> number * 4
```

Apply the addition operator to two 4d-vectors

## linalg.add_vec4_constant

```lua
function linalg.add_vec4_constant(a: number4, c: number)
  -> number * 4
```

Apply the addition operator to a 4d-vector and a constant

## linalg.add_vec4_constant_ex

```lua
function linalg.add_vec4_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the addition operator to a 4d-vector in a slice and a constant

## linalg.add_vec4_constant_ex

```lua
function linalg.add_vec4_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the addition operator to a 4d-vector in a slice and a constant and store in a destination

## linalg.add_vec4_ex

```lua
function linalg.add_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 4
```

Apply the addition operator to two 4d-vectors in a slice

## linalg.add_vec4_ex

```lua
function linalg.add_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the addition operator to two 4d-vectors in a slice and store the result in a destination

## linalg.cross_product_tuple3

```lua
function linalg.cross_product_tuple3(ax: number, ay: number, az: number, bx: number, by: number, bz: number)
  -> number, number, number
```

Cross product of 3d vector

## linalg.cross_product_vec3

```lua
function linalg.cross_product_vec3(a: number3, b: number3)
  -> number, number, number
```

Cross product of 3d vector

## linalg.cross_product_vec3_ex

```lua
function linalg.cross_product_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number, number, number
```

Cross product of 3d vector in a slice

## linalg.cross_product_vec3_ex

```lua
function linalg.cross_product_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Cross product of 3d vector in a slice into a destination

## linalg.div_2

```lua
function linalg.div_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the division operator to two 2-tuples

## linalg.div_3

```lua
function linalg.div_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the division operator to two 3-tuples

## linalg.div_4

```lua
function linalg.div_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the division operator to two 4-tuples

## linalg.div_mat2

```lua
function linalg.div_mat2(a: number4, b: number4)
  -> number * 4
```

Apply the division operator to each element in two 2x2 matrices

## linalg.div_mat2_constant

```lua
function linalg.div_mat2_constant(a: number4, c: number)
  -> number * 4
```

Apply the division operator to each element in a 2x2 matrix and a constant

## linalg.div_mat2_constant_ex

```lua
function linalg.div_mat2_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## linalg.div_mat2_constant_ex

```lua
function linalg.div_mat2_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the division operator to each element in a 2x2 matrix in a slice and a constant

## linalg.div_mat2_ex

```lua
function linalg.div_mat2_ex(a: seq_number4, a_index: integer, b: seq_number2, b_index: integer)
  -> number * 4
```

Apply the division operator to each element in two 2x2 matrices in a slice

## linalg.div_mat2_ex

```lua
function linalg.div_mat2_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in two 2d-vectors in a slice and store the result in a destination

## linalg.div_mat3

```lua
function linalg.div_mat3(a: number9, b: number9)
  -> number * 9
```

Apply the division operator to each element in two 3x3 matrices

## linalg.div_mat3_constant

```lua
function linalg.div_mat3_constant(a: number9, c: number)
  -> number * 9
```

Apply the division operator to each element in a 3x3 matrix and a constant

## linalg.div_mat3_constant_ex

```lua
function linalg.div_mat3_constant_ex(a: seq_number9, a_index: integer, c: number, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## linalg.div_mat3_constant_ex

```lua
function linalg.div_mat3_constant_ex(a: seq_number9, a_index: integer, c: number)
  -> number * 9
```

Apply the division operator to each element in a 3x3 matrix in a slice and a constant

## linalg.div_mat3_ex

```lua
function linalg.div_mat3_ex(a: seq_number9, a_index: integer, b: seq_number9, b_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in two 3d-vectors in a slice and store the result in a destination

## linalg.div_mat3_ex

```lua
function linalg.div_mat3_ex(a: seq_number9, a_index: integer, b: seq_number3, b_index: integer)
  -> number * 9
```

Apply the division operator to each element in two 3x3 matrices in a slice

## linalg.div_mat4

```lua
function linalg.div_mat4(a: number16, b: number16)
  -> number * 16
```

Apply the division operator to each element in two 4x4 matrices

## linalg.div_mat4_constant

```lua
function linalg.div_mat4_constant(a: number16, c: number)
  -> number * 16
```

Apply the division operator to each element in a 4x4 matrix and a constant

## linalg.div_mat4_constant_ex

```lua
function linalg.div_mat4_constant_ex(a: seq_number16, a_index: integer, c: number, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## linalg.div_mat4_constant_ex

```lua
function linalg.div_mat4_constant_ex(a: seq_number16, a_index: integer, c: number)
  -> number * 16
```

Apply the division operator to each element in a 4x4 matrix in a slice and a constant

## linalg.div_mat4_ex

```lua
function linalg.div_mat4_ex(a: seq_number16, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 16
```

Apply the division operator to each element in two 4x4 matrices in a slice

## linalg.div_mat4_ex

```lua
function linalg.div_mat4_ex(a: seq_number16, a_index: integer, b: seq_number16, b_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in two 4d-vectors in a slice and store the result in a destination

## linalg.div_vec2

```lua
function linalg.div_vec2(a: number2, b: number2)
  -> number, number
```

Apply the division operator to two 2d-vectors

## linalg.div_vec2_constant

```lua
function linalg.div_vec2_constant(a: number2, c: number)
  -> number, number
```

Apply the division operator to a 2d-vector and a constant

## linalg.div_vec2_constant_ex

```lua
function linalg.div_vec2_constant_ex(a: seq_number2, a_index: integer, c: number)
  -> number, number
```

Apply the division operator to a 2d-vector in a slice and a constant

## linalg.div_vec2_constant_ex

```lua
function linalg.div_vec2_constant_ex(a: seq_number2, a_index: integer, c: number, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the division operator to a 2d-vector in a slice and a constant and store in a destination

## linalg.div_vec2_ex

```lua
function linalg.div_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the division operator to two 2d-vectors in a slice and store the result in a destination

## linalg.div_vec2_ex

```lua
function linalg.div_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer)
  -> number, number
```

Apply the division operator to two 2d-vectors in a slice

## linalg.div_vec3

```lua
function linalg.div_vec3(a: number3, b: number3)
  -> number, number, number
```

Apply the division operator to two 3d-vectors

## linalg.div_vec3_constant

```lua
function linalg.div_vec3_constant(a: number3, c: number)
  -> number, number, number
```

Apply the division operator to a 3d-vector and a constant

## linalg.div_vec3_constant_ex

```lua
function linalg.div_vec3_constant_ex(a: seq_number3, a_index: integer, c: number)
  -> number, number, number
```

Apply the division operator to a 3d-vector in a slice and a constant

## linalg.div_vec3_constant_ex

```lua
function linalg.div_vec3_constant_ex(a: seq_number3, a_index: integer, c: number, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the division operator to a 3d-vector in a slice and a constant and store in a destination

## linalg.div_vec3_ex

```lua
function linalg.div_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number, number, number
```

Apply the division operator to two 3d-vectors in a slice

## linalg.div_vec3_ex

```lua
function linalg.div_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the division operator to two 3d-vectors in a slice and store the result in a destination

## linalg.div_vec4

```lua
function linalg.div_vec4(a: number4, b: number4)
  -> number * 4
```

Apply the division operator to two 4d-vectors

## linalg.div_vec4_constant

```lua
function linalg.div_vec4_constant(a: number4, c: number)
  -> number * 4
```

Apply the division operator to a 4d-vector and a constant

## linalg.div_vec4_constant_ex

```lua
function linalg.div_vec4_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the division operator to a 4d-vector in a slice and a constant

## linalg.div_vec4_constant_ex

```lua
function linalg.div_vec4_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the division operator to a 4d-vector in a slice and a constant and store in a destination

## linalg.div_vec4_ex

```lua
function linalg.div_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 4
```

Apply the division operator to two 4d-vectors in a slice

## linalg.div_vec4_ex

```lua
function linalg.div_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the division operator to two 4d-vectors in a slice and store the result in a destination

## linalg.equals_mat2

```lua
function linalg.equals_mat2(a: number4, b: number4, epsilon?: number)
  -> boolean
```

true if the matrices are equal (differ by epsilon or less)

## linalg.equals_mat2_ex

```lua
function linalg.equals_mat2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, epsilon?: number)
  -> boolean
```

true if the matrices in a slice are equal (differ by epsilon or less)

## linalg.equals_mat3

```lua
function linalg.equals_mat3(a: number9, b: number9, epsilon?: number)
  -> boolean
```

true if the matrices are equal (differ by epsilon or less)

## linalg.equals_mat3_ex

```lua
function linalg.equals_mat3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, epsilon?: number)
  -> boolean
```

true if the matrices in a slice are equal (differ by epsilon or less)

## linalg.equals_mat4

```lua
function linalg.equals_mat4(a: number16, b: number16, epsilon?: number)
  -> boolean
```

true if the matrices are equal (differ by epsilon or less)

## linalg.equals_mat4_ex

```lua
function linalg.equals_mat4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, epsilon?: number)
  -> boolean
```

true if the matrices in a slice are equal (differ by epsilon or less)

## linalg.equals_vec2

```lua
function linalg.equals_vec2(a: number2, b: number2, epsilon?: number)
  -> boolean
```

true if the vectors are equal (differ by epsilon or less)

## linalg.equals_vec2_ex

```lua
function linalg.equals_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, epsilon?: number)
  -> boolean
```

true if the vectors in a slice are equal (differ by epsilon or less)

## linalg.equals_vec3

```lua
function linalg.equals_vec3(a: number3, b: number3, epsilon?: number)
  -> boolean
```

true if the vectors are equal (differ by epsilon or less)

## linalg.equals_vec3_ex

```lua
function linalg.equals_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, epsilon?: number)
  -> boolean
```

true if the vectors in a slice are equal (differ by epsilon or less)

## linalg.equals_vec4

```lua
function linalg.equals_vec4(a: number4, b: number4, epsilon?: number)
  -> boolean
```

true if the vectors are equal (differ by epsilon or less)

## linalg.equals_vec4_ex

```lua
function linalg.equals_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, epsilon?: number)
  -> boolean
```

true if the vectors in a slice are equal (differ by epsilon or less)

## linalg.inner_product_2

```lua
function linalg.inner_product_2(a1: number, a2: number, b1: number, b2: number)
  -> number
```

Inner product of 2d vectors

## linalg.inner_product_3

```lua
function linalg.inner_product_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number
```

Inner product of 3d vectors

## linalg.inner_product_vec2

```lua
function linalg.inner_product_vec2(a: number2, b: number2)
  -> number
```

Inner product of 2d vector

## linalg.inner_product_vec2_slice

```lua
function linalg.inner_product_vec2_slice(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer)
  -> number
```

Inner product of 2d vector in a slice

## linalg.inner_product_vec3

```lua
function linalg.inner_product_vec3(a: number3, b: number3)
  -> number
```

Inner product of 3d vector

## linalg.inner_product_vec3_slice

```lua
function linalg.inner_product_vec3_slice(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number
```

Inner product of 3d vector in a slice

## linalg.inner_product_vec4

```lua
function linalg.inner_product_vec4(a: number4, b: number4)
  -> number
```

Inner product of 4d vector

## linalg.inner_product_vec4_slice

```lua
function linalg.inner_product_vec4_slice(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer)
  -> number
```

Inner product of 4d vector in a slice

## linalg.length_2

```lua
function linalg.length_2(a1: number, a2: number)
  -> number
```

2d vector length (magnitude)

## linalg.length_3

```lua
function linalg.length_3(a1: number, a2: number, a3: number)
  -> number
```

3d vector length (magnitude)

## linalg.length_4

```lua
function linalg.length_4(a1: number, a2: number, a3: number, a4: number)
  -> number
```

4d vector length (magnitude)

## linalg.length_squared_2

```lua
function linalg.length_squared_2(a1: number, a2: number)
  -> number
```

2d vector length (magnitude) squared

## linalg.length_squared_3

```lua
function linalg.length_squared_3(a1: number, a2: number, a3: number)
  -> number
```

3d vector length (magnitude) squared

## linalg.length_squared_4

```lua
function linalg.length_squared_4(a1: number, a2: number, a3: number, a4: number)
  -> number
```

4d vector length (magnitude) squared

## linalg.length_squared_vec2

```lua
function linalg.length_squared_vec2(v: number2)
  -> number
```

2d vector length (magnitude) squared

## linalg.length_squared_vec2_slice

```lua
function linalg.length_squared_vec2_slice(v: seq_number2, v_index: integer)
  -> number
```

2d vector length (magnitude) squared in a slice

## linalg.length_squared_vec3

```lua
function linalg.length_squared_vec3(v: number3)
  -> number
```

3d vector length (magnitude) squared

## linalg.length_squared_vec3_slice

```lua
function linalg.length_squared_vec3_slice(v: seq_number3, v_index: integer)
  -> number
```

3d vector length (magnitude) squared in a slice

## linalg.length_squared_vec4

```lua
function linalg.length_squared_vec4(v: number4)
  -> number
```

4d vector length (magnitude) squared

## linalg.length_squared_vec4_slice

```lua
function linalg.length_squared_vec4_slice(v: seq_number4, v_index: integer)
  -> number
```

4d vector length (magnitude) squared in a slice

## linalg.length_vec2

```lua
function linalg.length_vec2(v: number2)
  -> number
```

2d vector length (magnitude)

## linalg.length_vec2_slice

```lua
function linalg.length_vec2_slice(v: seq_number2, v_index: integer)
  -> number
```

2d vector length (magnitude) in a slice

## linalg.length_vec3

```lua
function linalg.length_vec3(v: number3)
  -> number
```

3d vector length (magnitude)

## linalg.length_vec3_slice

```lua
function linalg.length_vec3_slice(v: seq_number3, v_index: integer)
  -> number
```

3d vector length (magnitude) in a slice

## linalg.length_vec4

```lua
function linalg.length_vec4(v: number4)
  -> number
```

4d vector length (magnitude)

## linalg.length_vec4_slice

```lua
function linalg.length_vec4_slice(v: seq_number4, v_index: integer)
  -> number
```

4d vector length (magnitude) in a slice

## linalg.mat2_identity

```lua
function linalg.mat2_identity()
  -> number * 4
```

2x2 identity matrix

## linalg.mat2_zero

```lua
function linalg.mat2_zero()
  -> number * 4
```

2x2 matrix of zeros

## linalg.mat3_identity

```lua
function linalg.mat3_identity()
  -> number * 9
```

3x3 identity matrix

## linalg.mat3_rotate_around_axis

```lua
function linalg.mat3_rotate_around_axis(radians: number, axis_x: number, axis_y: number, axis_z: number)
  -> number * 9
```

3x3 rotation matrix

## linalg.mat3_scale

```lua
function linalg.mat3_scale(x: number, y: number, z: number)
  -> number * 9
```

3x3 scaling matrix

## linalg.mat3_translate

```lua
function linalg.mat3_translate(x: number, y: number)
  -> number * 9
```

3x3 translation matrix

## linalg.mat3_zero

```lua
function linalg.mat3_zero()
  -> number * 9
```

3x3 matrix of zeros

## linalg.mat4_identity

```lua
function linalg.mat4_identity()
  -> number * 16
```

4x4 identity matrix

## linalg.mat4_rotate_around_axis

```lua
function linalg.mat4_rotate_around_axis(radians: number, axis_x: number, axis_y: number, axis_z: number)
  -> number * 16
```

4x4 rotation matrix

## linalg.mat4_scale

```lua
function linalg.mat4_scale(x: number, y: number, z: number)
  -> number * 16
```

4x4 scaling matrix

## linalg.mat4_translate

```lua
function linalg.mat4_translate(x: number, y: number, z: number)
  -> number * 16
```

4x4 translation matrix

## linalg.mat4_zero

```lua
function linalg.mat4_zero()
  -> number * 16
```

4x4 matrix of zeros

## linalg.matmul_mat1_mat1

```lua
function linalg.matmul_mat1_mat1(a: number1, b: number1)
  -> number
```

Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix

## linalg.matmul_mat1_mat1_ex

```lua
function linalg.matmul_mat1_mat1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix

## linalg.matmul_mat1_mat1_ex

```lua
function linalg.matmul_mat1_mat1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x1_mat1x1

```lua
function linalg.matmul_mat1x1_mat1x1(a: number1, b: number1)
  -> number
```

Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix

## linalg.matmul_mat1x1_mat1x1_ex

```lua
function linalg.matmul_mat1x1_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x1_mat1x1_ex

```lua
function linalg.matmul_mat1x1_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix

## linalg.matmul_mat1x1_mat2x1

```lua
function linalg.matmul_mat1x1_mat2x1(a: number1, b: number2)
  -> number, number
```

Multiply a 1x1 matrix with a 2x1 matrix and return a 2x1 matrix

## linalg.matmul_mat1x1_mat2x1_ex

```lua
function linalg.matmul_mat1x1_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix

## linalg.matmul_mat1x1_mat2x1_ex

```lua
function linalg.matmul_mat1x1_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x1_mat3x1

```lua
function linalg.matmul_mat1x1_mat3x1(a: number1, b: number3)
  -> number, number, number
```

Multiply a 1x1 matrix with a 3x1 matrix and return a 3x1 matrix

## linalg.matmul_mat1x1_mat3x1_ex

```lua
function linalg.matmul_mat1x1_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix

## linalg.matmul_mat1x1_mat3x1_ex

```lua
function linalg.matmul_mat1x1_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x1_mat4x1

```lua
function linalg.matmul_mat1x1_mat4x1(a: number1, b: number4)
  -> number * 4
```

Multiply a 1x1 matrix with a 4x1 matrix and return a 4x1 matrix

## linalg.matmul_mat1x1_mat4x1_ex

```lua
function linalg.matmul_mat1x1_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix

## linalg.matmul_mat1x1_mat4x1_ex

```lua
function linalg.matmul_mat1x1_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x2_mat1x1

```lua
function linalg.matmul_mat1x2_mat1x1(a: number2, b: number1)
  -> number, number
```

Multiply a 1x2 matrix with a 1x1 matrix and return a 1x2 matrix

## linalg.matmul_mat1x2_mat1x1_ex

```lua
function linalg.matmul_mat1x2_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix

## linalg.matmul_mat1x2_mat1x1_ex

```lua
function linalg.matmul_mat1x2_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x2_mat2x1

```lua
function linalg.matmul_mat1x2_mat2x1(a: number2, b: number2)
  -> number * 4
```

Multiply a 1x2 matrix with a 2x1 matrix and return a 2x2 matrix

## linalg.matmul_mat1x2_mat2x1_ex

```lua
function linalg.matmul_mat1x2_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix

## linalg.matmul_mat1x2_mat2x1_ex

```lua
function linalg.matmul_mat1x2_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x2_mat3x1

```lua
function linalg.matmul_mat1x2_mat3x1(a: number2, b: number3)
  -> number * 6
```

Multiply a 1x2 matrix with a 3x1 matrix and return a 3x2 matrix

## linalg.matmul_mat1x2_mat3x1_ex

```lua
function linalg.matmul_mat1x2_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x2_mat3x1_ex

```lua
function linalg.matmul_mat1x2_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix

## linalg.matmul_mat1x2_mat4x1

```lua
function linalg.matmul_mat1x2_mat4x1(a: number2, b: number4)
  -> number * 8
```

Multiply a 1x2 matrix with a 4x1 matrix and return a 4x2 matrix

## linalg.matmul_mat1x2_mat4x1_ex

```lua
function linalg.matmul_mat1x2_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix

## linalg.matmul_mat1x2_mat4x1_ex

```lua
function linalg.matmul_mat1x2_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x3_mat1x1

```lua
function linalg.matmul_mat1x3_mat1x1(a: number3, b: number1)
  -> number, number, number
```

Multiply a 1x3 matrix with a 1x1 matrix and return a 1x3 matrix

## linalg.matmul_mat1x3_mat1x1_ex

```lua
function linalg.matmul_mat1x3_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix

## linalg.matmul_mat1x3_mat1x1_ex

```lua
function linalg.matmul_mat1x3_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x3_mat2x1

```lua
function linalg.matmul_mat1x3_mat2x1(a: number3, b: number2)
  -> number * 6
```

Multiply a 1x3 matrix with a 2x1 matrix and return a 2x3 matrix

## linalg.matmul_mat1x3_mat2x1_ex

```lua
function linalg.matmul_mat1x3_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x3_mat2x1_ex

```lua
function linalg.matmul_mat1x3_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix

## linalg.matmul_mat1x3_mat3x1

```lua
function linalg.matmul_mat1x3_mat3x1(a: number3, b: number3)
  -> number * 9
```

Multiply a 1x3 matrix with a 3x1 matrix and return a 3x3 matrix

## linalg.matmul_mat1x3_mat3x1_ex

```lua
function linalg.matmul_mat1x3_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 9
```

Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix

## linalg.matmul_mat1x3_mat3x1_ex

```lua
function linalg.matmul_mat1x3_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x3_mat4x1

```lua
function linalg.matmul_mat1x3_mat4x1(a: number3, b: number4)
  -> number * 12
```

Multiply a 1x3 matrix with a 4x1 matrix and return a 4x3 matrix

## linalg.matmul_mat1x3_mat4x1_ex

```lua
function linalg.matmul_mat1x3_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix

## linalg.matmul_mat1x3_mat4x1_ex

```lua
function linalg.matmul_mat1x3_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x4_mat1x1

```lua
function linalg.matmul_mat1x4_mat1x1(a: number4, b: number1)
  -> number * 4
```

Multiply a 1x4 matrix with a 1x1 matrix and return a 1x4 matrix

## linalg.matmul_mat1x4_mat1x1_ex

```lua
function linalg.matmul_mat1x4_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix

## linalg.matmul_mat1x4_mat1x1_ex

```lua
function linalg.matmul_mat1x4_mat1x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x4_mat2x1

```lua
function linalg.matmul_mat1x4_mat2x1(a: number4, b: number2)
  -> number * 8
```

Multiply a 1x4 matrix with a 2x1 matrix and return a 2x4 matrix

## linalg.matmul_mat1x4_mat2x1_ex

```lua
function linalg.matmul_mat1x4_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x4_mat2x1_ex

```lua
function linalg.matmul_mat1x4_mat2x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix

## linalg.matmul_mat1x4_mat3x1

```lua
function linalg.matmul_mat1x4_mat3x1(a: number4, b: number3)
  -> number * 12
```

Multiply a 1x4 matrix with a 3x1 matrix and return a 3x4 matrix

## linalg.matmul_mat1x4_mat3x1_ex

```lua
function linalg.matmul_mat1x4_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix

## linalg.matmul_mat1x4_mat3x1_ex

```lua
function linalg.matmul_mat1x4_mat3x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat1x4_mat4x1

```lua
function linalg.matmul_mat1x4_mat4x1(a: number4, b: number4)
  -> number * 16
```

Multiply a 1x4 matrix with a 4x1 matrix and return a 4x4 matrix

## linalg.matmul_mat1x4_mat4x1_ex

```lua
function linalg.matmul_mat1x4_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 16
```

Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix

## linalg.matmul_mat1x4_mat4x1_ex

```lua
function linalg.matmul_mat1x4_mat4x1_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2_mat2

```lua
function linalg.matmul_mat2_mat2(a: number4, b: number4)
  -> number * 4
```

Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix

## linalg.matmul_mat2_mat2_ex

```lua
function linalg.matmul_mat2_mat2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix

## linalg.matmul_mat2_mat2_ex

```lua
function linalg.matmul_mat2_mat2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2_vec2

```lua
function linalg.matmul_mat2_vec2(a: number4, v: number2)
  -> number, number
```

Multiply a 2x2 matrix and a 2d vector and return a 2d vector

## linalg.matmul_mat2_vec2_ex

```lua
function linalg.matmul_mat2_vec2_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer)
  -> number, number
```

Multiply a 2x2 matrix in a slice and a 2d vector in a slice and return a 2d vector

## linalg.matmul_mat2_vec2_ex

```lua
function linalg.matmul_mat2_vec2_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer, dest: seq_number, dest_index?: integer)
  -> number, number
```

Multiply a 2x2 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination

## linalg.matmul_mat2x1_mat1x2

```lua
function linalg.matmul_mat2x1_mat1x2(a: number2, b: number2)
  -> number
```

Multiply a 2x1 matrix with a 1x2 matrix and return a 1x1 matrix

## linalg.matmul_mat2x1_mat1x2_ex

```lua
function linalg.matmul_mat2x1_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number
```

Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix

## linalg.matmul_mat2x1_mat1x2_ex

```lua
function linalg.matmul_mat2x1_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x1_mat2x2

```lua
function linalg.matmul_mat2x1_mat2x2(a: number2, b: number4)
  -> number, number
```

Multiply a 2x1 matrix with a 2x2 matrix and return a 2x1 matrix

## linalg.matmul_mat2x1_mat2x2_ex

```lua
function linalg.matmul_mat2x1_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix

## linalg.matmul_mat2x1_mat2x2_ex

```lua
function linalg.matmul_mat2x1_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x1_mat3x2

```lua
function linalg.matmul_mat2x1_mat3x2(a: number2, b: number6)
  -> number, number, number
```

Multiply a 2x1 matrix with a 3x2 matrix and return a 3x1 matrix

## linalg.matmul_mat2x1_mat3x2_ex

```lua
function linalg.matmul_mat2x1_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix

## linalg.matmul_mat2x1_mat3x2_ex

```lua
function linalg.matmul_mat2x1_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x1_mat4x2

```lua
function linalg.matmul_mat2x1_mat4x2(a: number2, b: number8)
  -> number * 4
```

Multiply a 2x1 matrix with a 4x2 matrix and return a 4x1 matrix

## linalg.matmul_mat2x1_mat4x2_ex

```lua
function linalg.matmul_mat2x1_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix

## linalg.matmul_mat2x1_mat4x2_ex

```lua
function linalg.matmul_mat2x1_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x2_mat1x2

```lua
function linalg.matmul_mat2x2_mat1x2(a: number4, b: number2)
  -> number, number
```

Multiply a 2x2 matrix with a 1x2 matrix and return a 1x2 matrix

## linalg.matmul_mat2x2_mat1x2_ex

```lua
function linalg.matmul_mat2x2_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix

## linalg.matmul_mat2x2_mat1x2_ex

```lua
function linalg.matmul_mat2x2_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x2_mat2x2

```lua
function linalg.matmul_mat2x2_mat2x2(a: number4, b: number4)
  -> number * 4
```

Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix

## linalg.matmul_mat2x2_mat2x2_ex

```lua
function linalg.matmul_mat2x2_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x2_mat2x2_ex

```lua
function linalg.matmul_mat2x2_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix

## linalg.matmul_mat2x2_mat3x2

```lua
function linalg.matmul_mat2x2_mat3x2(a: number4, b: number6)
  -> number * 6
```

Multiply a 2x2 matrix with a 3x2 matrix and return a 3x2 matrix

## linalg.matmul_mat2x2_mat3x2_ex

```lua
function linalg.matmul_mat2x2_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix

## linalg.matmul_mat2x2_mat3x2_ex

```lua
function linalg.matmul_mat2x2_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x2_mat4x2

```lua
function linalg.matmul_mat2x2_mat4x2(a: number4, b: number8)
  -> number * 8
```

Multiply a 2x2 matrix with a 4x2 matrix and return a 4x2 matrix

## linalg.matmul_mat2x2_mat4x2_ex

```lua
function linalg.matmul_mat2x2_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix

## linalg.matmul_mat2x2_mat4x2_ex

```lua
function linalg.matmul_mat2x2_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x3_mat1x2

```lua
function linalg.matmul_mat2x3_mat1x2(a: number6, b: number2)
  -> number, number, number
```

Multiply a 2x3 matrix with a 1x2 matrix and return a 1x3 matrix

## linalg.matmul_mat2x3_mat1x2_ex

```lua
function linalg.matmul_mat2x3_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x3_mat1x2_ex

```lua
function linalg.matmul_mat2x3_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix

## linalg.matmul_mat2x3_mat2x2

```lua
function linalg.matmul_mat2x3_mat2x2(a: number6, b: number4)
  -> number * 6
```

Multiply a 2x3 matrix with a 2x2 matrix and return a 2x3 matrix

## linalg.matmul_mat2x3_mat2x2_ex

```lua
function linalg.matmul_mat2x3_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix

## linalg.matmul_mat2x3_mat2x2_ex

```lua
function linalg.matmul_mat2x3_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x3_mat3x2

```lua
function linalg.matmul_mat2x3_mat3x2(a: number6, b: number6)
  -> number * 9
```

Multiply a 2x3 matrix with a 3x2 matrix and return a 3x3 matrix

## linalg.matmul_mat2x3_mat3x2_ex

```lua
function linalg.matmul_mat2x3_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 9
```

Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix

## linalg.matmul_mat2x3_mat3x2_ex

```lua
function linalg.matmul_mat2x3_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x3_mat4x2

```lua
function linalg.matmul_mat2x3_mat4x2(a: number6, b: number8)
  -> number * 12
```

Multiply a 2x3 matrix with a 4x2 matrix and return a 4x3 matrix

## linalg.matmul_mat2x3_mat4x2_ex

```lua
function linalg.matmul_mat2x3_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix

## linalg.matmul_mat2x3_mat4x2_ex

```lua
function linalg.matmul_mat2x3_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x4_mat1x2

```lua
function linalg.matmul_mat2x4_mat1x2(a: number8, b: number2)
  -> number * 4
```

Multiply a 2x4 matrix with a 1x2 matrix and return a 1x4 matrix

## linalg.matmul_mat2x4_mat1x2_ex

```lua
function linalg.matmul_mat2x4_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x4_mat1x2_ex

```lua
function linalg.matmul_mat2x4_mat1x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix

## linalg.matmul_mat2x4_mat2x2

```lua
function linalg.matmul_mat2x4_mat2x2(a: number8, b: number4)
  -> number * 8
```

Multiply a 2x4 matrix with a 2x2 matrix and return a 2x4 matrix

## linalg.matmul_mat2x4_mat2x2_ex

```lua
function linalg.matmul_mat2x4_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix

## linalg.matmul_mat2x4_mat2x2_ex

```lua
function linalg.matmul_mat2x4_mat2x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x4_mat3x2

```lua
function linalg.matmul_mat2x4_mat3x2(a: number8, b: number6)
  -> number * 12
```

Multiply a 2x4 matrix with a 3x2 matrix and return a 3x4 matrix

## linalg.matmul_mat2x4_mat3x2_ex

```lua
function linalg.matmul_mat2x4_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix

## linalg.matmul_mat2x4_mat3x2_ex

```lua
function linalg.matmul_mat2x4_mat3x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat2x4_mat4x2

```lua
function linalg.matmul_mat2x4_mat4x2(a: number8, b: number8)
  -> number * 16
```

Multiply a 2x4 matrix with a 4x2 matrix and return a 4x4 matrix

## linalg.matmul_mat2x4_mat4x2_ex

```lua
function linalg.matmul_mat2x4_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 16
```

Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix

## linalg.matmul_mat2x4_mat4x2_ex

```lua
function linalg.matmul_mat2x4_mat4x2_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3_mat3

```lua
function linalg.matmul_mat3_mat3(a: number9, b: number9)
  -> number * 9
```

Multiply a 3x3 matrix with a 3x3 matrix and return a 3x3 matrix

## linalg.matmul_mat3_mat3_ex

```lua
function linalg.matmul_mat3_mat3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 9
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix

## linalg.matmul_mat3_mat3_ex

```lua
function linalg.matmul_mat3_mat3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3_vec2

```lua
function linalg.matmul_mat3_vec2(a: number9, v: number2)
  -> number, number
```

Multiply a 3x3 matrix and a 2d vector and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat3_vec2_ex

```lua
function linalg.matmul_mat3_vec2_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer)
  -> number, number
```

Multiply a 3x3 matrix in a slice and a 2d vector in a slice and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat3_vec2_ex

```lua
function linalg.matmul_mat3_vec2_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer, dest: seq_number, dest_index?: integer)
  -> number, number
```

Multiply a 3x3 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat3_vec3

```lua
function linalg.matmul_mat3_vec3(a: number9, v: number3)
  -> number, number, number
```

Multiply a 3x3 matrix and a 3d vector and return a 3d vector

## linalg.matmul_mat3_vec3_ex

```lua
function linalg.matmul_mat3_vec3_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer)
  -> number, number, number
```

Multiply a 3x3 matrix in a slice and a 3d vector in a slice and return a 3d vector

## linalg.matmul_mat3_vec3_ex

```lua
function linalg.matmul_mat3_vec3_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer, dest: seq_number, dest_index?: integer)
  -> number, number, number
```

Multiply a 3x3 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination

## linalg.matmul_mat3x1_mat1x3

```lua
function linalg.matmul_mat3x1_mat1x3(a: number3, b: number3)
  -> number
```

Multiply a 3x1 matrix with a 1x3 matrix and return a 1x1 matrix

## linalg.matmul_mat3x1_mat1x3_ex

```lua
function linalg.matmul_mat3x1_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number
```

Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix

## linalg.matmul_mat3x1_mat1x3_ex

```lua
function linalg.matmul_mat3x1_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x1_mat2x3

```lua
function linalg.matmul_mat3x1_mat2x3(a: number3, b: number6)
  -> number, number
```

Multiply a 3x1 matrix with a 2x3 matrix and return a 2x1 matrix

## linalg.matmul_mat3x1_mat2x3_ex

```lua
function linalg.matmul_mat3x1_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix

## linalg.matmul_mat3x1_mat2x3_ex

```lua
function linalg.matmul_mat3x1_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x1_mat3x3

```lua
function linalg.matmul_mat3x1_mat3x3(a: number3, b: number9)
  -> number, number, number
```

Multiply a 3x1 matrix with a 3x3 matrix and return a 3x1 matrix

## linalg.matmul_mat3x1_mat3x3_ex

```lua
function linalg.matmul_mat3x1_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix

## linalg.matmul_mat3x1_mat3x3_ex

```lua
function linalg.matmul_mat3x1_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x1_mat4x3

```lua
function linalg.matmul_mat3x1_mat4x3(a: number3, b: number12)
  -> number * 4
```

Multiply a 3x1 matrix with a 4x3 matrix and return a 4x1 matrix

## linalg.matmul_mat3x1_mat4x3_ex

```lua
function linalg.matmul_mat3x1_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x1_mat4x3_ex

```lua
function linalg.matmul_mat3x1_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix

## linalg.matmul_mat3x2_mat1x3

```lua
function linalg.matmul_mat3x2_mat1x3(a: number6, b: number3)
  -> number, number
```

Multiply a 3x2 matrix with a 1x3 matrix and return a 1x2 matrix

## linalg.matmul_mat3x2_mat1x3_ex

```lua
function linalg.matmul_mat3x2_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix

## linalg.matmul_mat3x2_mat1x3_ex

```lua
function linalg.matmul_mat3x2_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x2_mat2x3

```lua
function linalg.matmul_mat3x2_mat2x3(a: number6, b: number6)
  -> number * 4
```

Multiply a 3x2 matrix with a 2x3 matrix and return a 2x2 matrix

## linalg.matmul_mat3x2_mat2x3_ex

```lua
function linalg.matmul_mat3x2_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix

## linalg.matmul_mat3x2_mat2x3_ex

```lua
function linalg.matmul_mat3x2_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x2_mat3x3

```lua
function linalg.matmul_mat3x2_mat3x3(a: number6, b: number9)
  -> number * 6
```

Multiply a 3x2 matrix with a 3x3 matrix and return a 3x2 matrix

## linalg.matmul_mat3x2_mat3x3_ex

```lua
function linalg.matmul_mat3x2_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x2_mat3x3_ex

```lua
function linalg.matmul_mat3x2_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix

## linalg.matmul_mat3x2_mat4x3

```lua
function linalg.matmul_mat3x2_mat4x3(a: number6, b: number12)
  -> number * 8
```

Multiply a 3x2 matrix with a 4x3 matrix and return a 4x2 matrix

## linalg.matmul_mat3x2_mat4x3_ex

```lua
function linalg.matmul_mat3x2_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix

## linalg.matmul_mat3x2_mat4x3_ex

```lua
function linalg.matmul_mat3x2_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x3_mat1x3

```lua
function linalg.matmul_mat3x3_mat1x3(a: number9, b: number3)
  -> number, number, number
```

Multiply a 3x3 matrix with a 1x3 matrix and return a 1x3 matrix

## linalg.matmul_mat3x3_mat1x3_ex

```lua
function linalg.matmul_mat3x3_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix

## linalg.matmul_mat3x3_mat1x3_ex

```lua
function linalg.matmul_mat3x3_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x3_mat2x3

```lua
function linalg.matmul_mat3x3_mat2x3(a: number9, b: number6)
  -> number * 6
```

Multiply a 3x3 matrix with a 2x3 matrix and return a 2x3 matrix

## linalg.matmul_mat3x3_mat2x3_ex

```lua
function linalg.matmul_mat3x3_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix

## linalg.matmul_mat3x3_mat2x3_ex

```lua
function linalg.matmul_mat3x3_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x3_mat3x3

```lua
function linalg.matmul_mat3x3_mat3x3(a: number9, b: number9)
  -> number * 9
```

Multiply a 3x3 matrix with a 3x3 matrix and return a 3x3 matrix

## linalg.matmul_mat3x3_mat3x3_ex

```lua
function linalg.matmul_mat3x3_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x3_mat3x3_ex

```lua
function linalg.matmul_mat3x3_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 9
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix

## linalg.matmul_mat3x3_mat4x3

```lua
function linalg.matmul_mat3x3_mat4x3(a: number9, b: number12)
  -> number * 12
```

Multiply a 3x3 matrix with a 4x3 matrix and return a 4x3 matrix

## linalg.matmul_mat3x3_mat4x3_ex

```lua
function linalg.matmul_mat3x3_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix

## linalg.matmul_mat3x3_mat4x3_ex

```lua
function linalg.matmul_mat3x3_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x4_mat1x3

```lua
function linalg.matmul_mat3x4_mat1x3(a: number12, b: number3)
  -> number * 4
```

Multiply a 3x4 matrix with a 1x3 matrix and return a 1x4 matrix

## linalg.matmul_mat3x4_mat1x3_ex

```lua
function linalg.matmul_mat3x4_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix

## linalg.matmul_mat3x4_mat1x3_ex

```lua
function linalg.matmul_mat3x4_mat1x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x4_mat2x3

```lua
function linalg.matmul_mat3x4_mat2x3(a: number12, b: number6)
  -> number * 8
```

Multiply a 3x4 matrix with a 2x3 matrix and return a 2x4 matrix

## linalg.matmul_mat3x4_mat2x3_ex

```lua
function linalg.matmul_mat3x4_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix

## linalg.matmul_mat3x4_mat2x3_ex

```lua
function linalg.matmul_mat3x4_mat2x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x4_mat3x3

```lua
function linalg.matmul_mat3x4_mat3x3(a: number12, b: number9)
  -> number * 12
```

Multiply a 3x4 matrix with a 3x3 matrix and return a 3x4 matrix

## linalg.matmul_mat3x4_mat3x3_ex

```lua
function linalg.matmul_mat3x4_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix

## linalg.matmul_mat3x4_mat3x3_ex

```lua
function linalg.matmul_mat3x4_mat3x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat3x4_mat4x3

```lua
function linalg.matmul_mat3x4_mat4x3(a: number12, b: number12)
  -> number * 16
```

Multiply a 3x4 matrix with a 4x3 matrix and return a 4x4 matrix

## linalg.matmul_mat3x4_mat4x3_ex

```lua
function linalg.matmul_mat3x4_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 16
```

Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix

## linalg.matmul_mat3x4_mat4x3_ex

```lua
function linalg.matmul_mat3x4_mat4x3_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4_mat4

```lua
function linalg.matmul_mat4_mat4(a: number16, b: number16)
  -> number * 16
```

Multiply a 4x4 matrix with a 4x4 matrix and return a 4x4 matrix

## linalg.matmul_mat4_mat4_ex

```lua
function linalg.matmul_mat4_mat4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 16
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix

## linalg.matmul_mat4_mat4_ex

```lua
function linalg.matmul_mat4_mat4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4_vec2

```lua
function linalg.matmul_mat4_vec2(a: number16, v: number2)
  -> number, number
```

Multiply a 4x4 matrix and a 2d vector and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat4_vec2_ex

```lua
function linalg.matmul_mat4_vec2_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer)
  -> number, number
```

Multiply a 4x4 matrix in a slice and a 2d vector in a slice and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat4_vec2_ex

```lua
function linalg.matmul_mat4_vec2_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer, dest: seq_number, dest_index?: integer)
  -> number, number
```

Multiply a 4x4 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat4_vec3

```lua
function linalg.matmul_mat4_vec3(a: number16, v: number3)
  -> number, number, number
```

Multiply a 4x4 matrix and a 3d vector and return a 3d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat4_vec3_ex

```lua
function linalg.matmul_mat4_vec3_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer)
  -> number, number, number
```

Multiply a 4x4 matrix in a slice and a 3d vector in a slice and return a 3d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat4_vec3_ex

```lua
function linalg.matmul_mat4_vec3_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer, dest: seq_number, dest_index?: integer)
  -> number, number, number
```

Multiply a 4x4 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## linalg.matmul_mat4_vec4

```lua
function linalg.matmul_mat4_vec4(a: number16, v: number4)
  -> number * 4
```

Multiply a 4x4 matrix and a 4d vector and return a 4d vector

## linalg.matmul_mat4_vec4_ex

```lua
function linalg.matmul_mat4_vec4_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer)
  -> number * 4
```

Multiply a 4x4 matrix in a slice and a 4d vector in a slice and return a 4d vector

## linalg.matmul_mat4_vec4_ex

```lua
function linalg.matmul_mat4_vec4_ex(a: seq_number, a_index: integer, v: seq_number, v_index: integer, dest: seq_number, dest_index?: integer)
  -> number * 4
```

Multiply a 4x4 matrix in a slice and a 4d vector in an array or slice into a 4d vector in a destination

## linalg.matmul_mat4x1_mat1x4

```lua
function linalg.matmul_mat4x1_mat1x4(a: number4, b: number4)
  -> number
```

Multiply a 4x1 matrix with a 1x4 matrix and return a 1x1 matrix

## linalg.matmul_mat4x1_mat1x4_ex

```lua
function linalg.matmul_mat4x1_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x1_mat1x4_ex

```lua
function linalg.matmul_mat4x1_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number
```

Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix

## linalg.matmul_mat4x1_mat2x4

```lua
function linalg.matmul_mat4x1_mat2x4(a: number4, b: number8)
  -> number, number
```

Multiply a 4x1 matrix with a 2x4 matrix and return a 2x1 matrix

## linalg.matmul_mat4x1_mat2x4_ex

```lua
function linalg.matmul_mat4x1_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix

## linalg.matmul_mat4x1_mat2x4_ex

```lua
function linalg.matmul_mat4x1_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x1_mat3x4

```lua
function linalg.matmul_mat4x1_mat3x4(a: number4, b: number12)
  -> number, number, number
```

Multiply a 4x1 matrix with a 3x4 matrix and return a 3x1 matrix

## linalg.matmul_mat4x1_mat3x4_ex

```lua
function linalg.matmul_mat4x1_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix

## linalg.matmul_mat4x1_mat3x4_ex

```lua
function linalg.matmul_mat4x1_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x1_mat4x4

```lua
function linalg.matmul_mat4x1_mat4x4(a: number4, b: number16)
  -> number * 4
```

Multiply a 4x1 matrix with a 4x4 matrix and return a 4x1 matrix

## linalg.matmul_mat4x1_mat4x4_ex

```lua
function linalg.matmul_mat4x1_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x1_mat4x4_ex

```lua
function linalg.matmul_mat4x1_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix

## linalg.matmul_mat4x2_mat1x4

```lua
function linalg.matmul_mat4x2_mat1x4(a: number8, b: number4)
  -> number, number
```

Multiply a 4x2 matrix with a 1x4 matrix and return a 1x2 matrix

## linalg.matmul_mat4x2_mat1x4_ex

```lua
function linalg.matmul_mat4x2_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number
```

Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix

## linalg.matmul_mat4x2_mat1x4_ex

```lua
function linalg.matmul_mat4x2_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x2_mat2x4

```lua
function linalg.matmul_mat4x2_mat2x4(a: number8, b: number8)
  -> number * 4
```

Multiply a 4x2 matrix with a 2x4 matrix and return a 2x2 matrix

## linalg.matmul_mat4x2_mat2x4_ex

```lua
function linalg.matmul_mat4x2_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix

## linalg.matmul_mat4x2_mat2x4_ex

```lua
function linalg.matmul_mat4x2_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x2_mat3x4

```lua
function linalg.matmul_mat4x2_mat3x4(a: number8, b: number12)
  -> number * 6
```

Multiply a 4x2 matrix with a 3x4 matrix and return a 3x2 matrix

## linalg.matmul_mat4x2_mat3x4_ex

```lua
function linalg.matmul_mat4x2_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix

## linalg.matmul_mat4x2_mat3x4_ex

```lua
function linalg.matmul_mat4x2_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x2_mat4x4

```lua
function linalg.matmul_mat4x2_mat4x4(a: number8, b: number16)
  -> number * 8
```

Multiply a 4x2 matrix with a 4x4 matrix and return a 4x2 matrix

## linalg.matmul_mat4x2_mat4x4_ex

```lua
function linalg.matmul_mat4x2_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x2_mat4x4_ex

```lua
function linalg.matmul_mat4x2_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix

## linalg.matmul_mat4x3_mat1x4

```lua
function linalg.matmul_mat4x3_mat1x4(a: number12, b: number4)
  -> number, number, number
```

Multiply a 4x3 matrix with a 1x4 matrix and return a 1x3 matrix

## linalg.matmul_mat4x3_mat1x4_ex

```lua
function linalg.matmul_mat4x3_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number, number, number
```

Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix

## linalg.matmul_mat4x3_mat1x4_ex

```lua
function linalg.matmul_mat4x3_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x3_mat2x4

```lua
function linalg.matmul_mat4x3_mat2x4(a: number12, b: number8)
  -> number * 6
```

Multiply a 4x3 matrix with a 2x4 matrix and return a 2x3 matrix

## linalg.matmul_mat4x3_mat2x4_ex

```lua
function linalg.matmul_mat4x3_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 6
```

Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix

## linalg.matmul_mat4x3_mat2x4_ex

```lua
function linalg.matmul_mat4x3_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x3_mat3x4

```lua
function linalg.matmul_mat4x3_mat3x4(a: number12, b: number12)
  -> number * 9
```

Multiply a 4x3 matrix with a 3x4 matrix and return a 3x3 matrix

## linalg.matmul_mat4x3_mat3x4_ex

```lua
function linalg.matmul_mat4x3_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 9
```

Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix

## linalg.matmul_mat4x3_mat3x4_ex

```lua
function linalg.matmul_mat4x3_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x3_mat4x4

```lua
function linalg.matmul_mat4x3_mat4x4(a: number12, b: number16)
  -> number * 12
```

Multiply a 4x3 matrix with a 4x4 matrix and return a 4x3 matrix

## linalg.matmul_mat4x3_mat4x4_ex

```lua
function linalg.matmul_mat4x3_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix

## linalg.matmul_mat4x3_mat4x4_ex

```lua
function linalg.matmul_mat4x3_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x4_mat1x4

```lua
function linalg.matmul_mat4x4_mat1x4(a: number16, b: number4)
  -> number * 4
```

Multiply a 4x4 matrix with a 1x4 matrix and return a 1x4 matrix

## linalg.matmul_mat4x4_mat1x4_ex

```lua
function linalg.matmul_mat4x4_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 4
```

Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix

## linalg.matmul_mat4x4_mat1x4_ex

```lua
function linalg.matmul_mat4x4_mat1x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x4_mat2x4

```lua
function linalg.matmul_mat4x4_mat2x4(a: number16, b: number8)
  -> number * 8
```

Multiply a 4x4 matrix with a 2x4 matrix and return a 2x4 matrix

## linalg.matmul_mat4x4_mat2x4_ex

```lua
function linalg.matmul_mat4x4_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 8
```

Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix

## linalg.matmul_mat4x4_mat2x4_ex

```lua
function linalg.matmul_mat4x4_mat2x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x4_mat3x4

```lua
function linalg.matmul_mat4x4_mat3x4(a: number16, b: number12)
  -> number * 12
```

Multiply a 4x4 matrix with a 3x4 matrix and return a 3x4 matrix

## linalg.matmul_mat4x4_mat3x4_ex

```lua
function linalg.matmul_mat4x4_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.matmul_mat4x4_mat3x4_ex

```lua
function linalg.matmul_mat4x4_mat3x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 12
```

Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix

## linalg.matmul_mat4x4_mat4x4

```lua
function linalg.matmul_mat4x4_mat4x4(a: number16, b: number16)
  -> number * 16
```

Multiply a 4x4 matrix with a 4x4 matrix and return a 4x4 matrix

## linalg.matmul_mat4x4_mat4x4_ex

```lua
function linalg.matmul_mat4x4_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer)
  -> number * 16
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix

## linalg.matmul_mat4x4_mat4x4_ex

```lua
function linalg.matmul_mat4x4_mat4x4_ex(a: seq_number, a_index: integer, b: seq_number, b_index: integer, dest: seq_number, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## linalg.mul_2

```lua
function linalg.mul_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the multiplication operator to two 2-tuples

## linalg.mul_3

```lua
function linalg.mul_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the multiplication operator to two 3-tuples

## linalg.mul_4

```lua
function linalg.mul_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the multiplication operator to two 4-tuples

## linalg.mul_mat2

```lua
function linalg.mul_mat2(a: number4, b: number4)
  -> number * 4
```

Apply the multiplication operator to each element in two 2x2 matrices

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat2_constant

```lua
function linalg.mul_mat2_constant(a: number4, c: number)
  -> number * 4
```

Apply the multiplication operator to each element in a 2x2 matrix and a constant

## linalg.mul_mat2_constant_ex

```lua
function linalg.mul_mat2_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant

## linalg.mul_mat2_constant_ex

```lua
function linalg.mul_mat2_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## linalg.mul_mat2_ex

```lua
function linalg.mul_mat2_ex(a: seq_number4, a_index: integer, b: seq_number2, b_index: integer)
  -> number * 4
```

Apply the multiplication operator to each element in two 2x2 matrices in a slice

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat2_ex

```lua
function linalg.mul_mat2_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in two 2d-vectors in a slice and store the result in a destination

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat3

```lua
function linalg.mul_mat3(a: number9, b: number9)
  -> number * 9
```

Apply the multiplication operator to each element in two 3x3 matrices

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat3_constant

```lua
function linalg.mul_mat3_constant(a: number9, c: number)
  -> number * 9
```

Apply the multiplication operator to each element in a 3x3 matrix and a constant

## linalg.mul_mat3_constant_ex

```lua
function linalg.mul_mat3_constant_ex(a: seq_number9, a_index: integer, c: number)
  -> number * 9
```

Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant

## linalg.mul_mat3_constant_ex

```lua
function linalg.mul_mat3_constant_ex(a: seq_number9, a_index: integer, c: number, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## linalg.mul_mat3_ex

```lua
function linalg.mul_mat3_ex(a: seq_number9, a_index: integer, b: seq_number3, b_index: integer)
  -> number * 9
```

Apply the multiplication operator to each element in two 3x3 matrices in a slice

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat3_ex

```lua
function linalg.mul_mat3_ex(a: seq_number9, a_index: integer, b: seq_number9, b_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in two 3d-vectors in a slice and store the result in a destination

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat4

```lua
function linalg.mul_mat4(a: number16, b: number16)
  -> number * 16
```

Apply the multiplication operator to each element in two 4x4 matrices

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat4_constant

```lua
function linalg.mul_mat4_constant(a: number16, c: number)
  -> number * 16
```

Apply the multiplication operator to each element in a 4x4 matrix and a constant

## linalg.mul_mat4_constant_ex

```lua
function linalg.mul_mat4_constant_ex(a: seq_number16, a_index: integer, c: number)
  -> number * 16
```

Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant

## linalg.mul_mat4_constant_ex

```lua
function linalg.mul_mat4_constant_ex(a: seq_number16, a_index: integer, c: number, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## linalg.mul_mat4_ex

```lua
function linalg.mul_mat4_ex(a: seq_number16, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 16
```

Apply the multiplication operator to each element in two 4x4 matrices in a slice

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_mat4_ex

```lua
function linalg.mul_mat4_ex(a: seq_number16, a_index: integer, b: seq_number16, b_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in two 4d-vectors in a slice and store the result in a destination

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## linalg.mul_vec2

```lua
function linalg.mul_vec2(a: number2, b: number2)
  -> number, number
```

Apply the multiplication operator to two 2d-vectors

## linalg.mul_vec2_constant

```lua
function linalg.mul_vec2_constant(a: number2, c: number)
  -> number, number
```

Apply the multiplication operator to a 2d-vector and a constant

## linalg.mul_vec2_constant_ex

```lua
function linalg.mul_vec2_constant_ex(a: seq_number2, a_index: integer, c: number, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to a 2d-vector in a slice and a constant and store in a destination

## linalg.mul_vec2_constant_ex

```lua
function linalg.mul_vec2_constant_ex(a: seq_number2, a_index: integer, c: number)
  -> number, number
```

Apply the multiplication operator to a 2d-vector in a slice and a constant

## linalg.mul_vec2_ex

```lua
function linalg.mul_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two 2d-vectors in a slice and store the result in a destination

## linalg.mul_vec2_ex

```lua
function linalg.mul_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer)
  -> number, number
```

Apply the multiplication operator to two 2d-vectors in a slice

## linalg.mul_vec3

```lua
function linalg.mul_vec3(a: number3, b: number3)
  -> number, number, number
```

Apply the multiplication operator to two 3d-vectors

## linalg.mul_vec3_constant

```lua
function linalg.mul_vec3_constant(a: number3, c: number)
  -> number, number, number
```

Apply the multiplication operator to a 3d-vector and a constant

## linalg.mul_vec3_constant_ex

```lua
function linalg.mul_vec3_constant_ex(a: seq_number3, a_index: integer, c: number, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to a 3d-vector in a slice and a constant and store in a destination

## linalg.mul_vec3_constant_ex

```lua
function linalg.mul_vec3_constant_ex(a: seq_number3, a_index: integer, c: number)
  -> number, number, number
```

Apply the multiplication operator to a 3d-vector in a slice and a constant

## linalg.mul_vec3_ex

```lua
function linalg.mul_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number, number, number
```

Apply the multiplication operator to two 3d-vectors in a slice

## linalg.mul_vec3_ex

```lua
function linalg.mul_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two 3d-vectors in a slice and store the result in a destination

## linalg.mul_vec4

```lua
function linalg.mul_vec4(a: number4, b: number4)
  -> number * 4
```

Apply the multiplication operator to two 4d-vectors

## linalg.mul_vec4_constant

```lua
function linalg.mul_vec4_constant(a: number4, c: number)
  -> number * 4
```

Apply the multiplication operator to a 4d-vector and a constant

## linalg.mul_vec4_constant_ex

```lua
function linalg.mul_vec4_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the multiplication operator to a 4d-vector in a slice and a constant

## linalg.mul_vec4_constant_ex

```lua
function linalg.mul_vec4_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to a 4d-vector in a slice and a constant and store in a destination

## linalg.mul_vec4_ex

```lua
function linalg.mul_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 4
```

Apply the multiplication operator to two 4d-vectors in a slice

## linalg.mul_vec4_ex

```lua
function linalg.mul_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two 4d-vectors in a slice and store the result in a destination

## linalg.negate_mat2

```lua
function linalg.negate_mat2(a: number4)
  -> number * 4
```

Negate a 2x2 matrix

## linalg.negate_mat2_ex

```lua
function linalg.negate_mat2_ex(a: seq_number4, a_index: integer)
  -> number * 4
```

Negate a 2x2 matrix in a slice

## linalg.negate_mat2_ex

```lua
function linalg.negate_mat2_ex(a: seq_number4, a_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Negate a 2x2 matrix in a slice and store the result in a destination

## linalg.negate_mat3

```lua
function linalg.negate_mat3(a: number9)
  -> number * 9
```

Negate a 3x3 matrix

## linalg.negate_mat3_ex

```lua
function linalg.negate_mat3_ex(a: seq_number9, a_index: integer)
  -> number * 9
```

Negate a 3x3 matrix in a slice

## linalg.negate_mat3_ex

```lua
function linalg.negate_mat3_ex(a: seq_number9, a_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Negate a 3x3 matrix in a slice and store the result in a destination

## linalg.negate_mat4

```lua
function linalg.negate_mat4(a: number16)
  -> number * 16
```

Negate a 4x4 matrix

## linalg.negate_mat4_ex

```lua
function linalg.negate_mat4_ex(a: seq_number16, a_index: integer)
  -> number * 16
```

Negate a 4x4 matrix in a slice

## linalg.negate_mat4_ex

```lua
function linalg.negate_mat4_ex(a: seq_number16, a_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Negate a 4x4 matrix in a slice and store the result in a destination

## linalg.negate_vec2

```lua
function linalg.negate_vec2(a: number2)
  -> number, number
```

Negate a 2d-vector

## linalg.negate_vec2_ex

```lua
function linalg.negate_vec2_ex(a: seq_number2, a_index: integer)
  -> number, number
```

Negate a 2d-vector in a slice

## linalg.negate_vec2_ex

```lua
function linalg.negate_vec2_ex(a: seq_number2, a_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Negate a 2d-vector in a slice and store the result in a destination

## linalg.negate_vec3

```lua
function linalg.negate_vec3(a: number3)
  -> number, number, number
```

Negate a 3d-vector

## linalg.negate_vec3_ex

```lua
function linalg.negate_vec3_ex(a: seq_number3, a_index: integer)
  -> number, number, number
```

Negate a 3d-vector in a slice

## linalg.negate_vec3_ex

```lua
function linalg.negate_vec3_ex(a: seq_number3, a_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Negate a 3d-vector in a slice and store the result in a destination

## linalg.negate_vec4

```lua
function linalg.negate_vec4(a: number4)
  -> number * 4
```

Negate a 4d-vector

## linalg.negate_vec4_ex

```lua
function linalg.negate_vec4_ex(a: seq_number4, a_index: integer)
  -> number * 4
```

Negate a 4d-vector in a slice

## linalg.negate_vec4_ex

```lua
function linalg.negate_vec4_ex(a: seq_number4, a_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Negate a 4d-vector in a slice and store the result in a destination

## linalg.normalise_2

```lua
function linalg.normalise_2(v1: number, v2: number)
  -> number, number
```

Normalise 2d vector

## linalg.normalise_3

```lua
function linalg.normalise_3(v1: number, v2: number, v3: number)
  -> number, number, number
```

Normalise 3d vector

## linalg.normalise_4

```lua
function linalg.normalise_4(v1: number, v2: number, v3: number, v4: number)
  -> number * 4
```

Normalise 4d vector

## linalg.normalise_vec2

```lua
function linalg.normalise_vec2(v: number2)
  -> number, number
```

Normalise 2d vector

## linalg.normalise_vec2_ex

```lua
function linalg.normalise_vec2_ex(v: seq_number2, v_index: integer)
  -> number, number
```

Normalise 2d vector in a slice

## linalg.normalise_vec2_ex

```lua
function linalg.normalise_vec2_ex(v: seq_number2, v_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Normalise 2d vector in a slice into a destination

## linalg.normalise_vec3

```lua
function linalg.normalise_vec3(v: number3)
  -> number, number, number
```

Normalise 3d vector

## linalg.normalise_vec3_ex

```lua
function linalg.normalise_vec3_ex(v: seq_number3, v_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Normalise 3d vector in a slice into a destination

## linalg.normalise_vec3_ex

```lua
function linalg.normalise_vec3_ex(v: seq_number3, v_index: integer)
  -> number, number, number
```

Normalise 3d vector in a slice

## linalg.normalise_vec4

```lua
function linalg.normalise_vec4(v: number4)
  -> number * 4
```

Normalise 4d vector

## linalg.normalise_vec4_ex

```lua
function linalg.normalise_vec4_ex(v: seq_number4, v_index: integer)
  -> number * 4
```

Normalise 4d vector in a slice

## linalg.normalise_vec4_ex

```lua
function linalg.normalise_vec4_ex(v: seq_number4, v_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Normalise 4d vector in a slice into a destination

## linalg.pow_2

```lua
function linalg.pow_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the exponentiation operator to two 2-tuples

## linalg.pow_3

```lua
function linalg.pow_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the exponentiation operator to two 3-tuples

## linalg.pow_4

```lua
function linalg.pow_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the exponentiation operator to two 4-tuples

## linalg.pow_mat2

```lua
function linalg.pow_mat2(a: number4, b: number4)
  -> number * 4
```

Apply the exponentiation operator to each element in two 2x2 matrices

## linalg.pow_mat2_constant

```lua
function linalg.pow_mat2_constant(a: number4, c: number)
  -> number * 4
```

Apply the exponentiation operator to each element in a 2x2 matrix and a constant

## linalg.pow_mat2_constant_ex

```lua
function linalg.pow_mat2_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant

## linalg.pow_mat2_constant_ex

```lua
function linalg.pow_mat2_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## linalg.pow_mat2_ex

```lua
function linalg.pow_mat2_ex(a: seq_number4, a_index: integer, b: seq_number2, b_index: integer)
  -> number * 4
```

Apply the exponentiation operator to each element in two 2x2 matrices in a slice

## linalg.pow_mat2_ex

```lua
function linalg.pow_mat2_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in two 2d-vectors in a slice and store the result in a destination

## linalg.pow_mat3

```lua
function linalg.pow_mat3(a: number9, b: number9)
  -> number * 9
```

Apply the exponentiation operator to each element in two 3x3 matrices

## linalg.pow_mat3_constant

```lua
function linalg.pow_mat3_constant(a: number9, c: number)
  -> number * 9
```

Apply the exponentiation operator to each element in a 3x3 matrix and a constant

## linalg.pow_mat3_constant_ex

```lua
function linalg.pow_mat3_constant_ex(a: seq_number9, a_index: integer, c: number, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## linalg.pow_mat3_constant_ex

```lua
function linalg.pow_mat3_constant_ex(a: seq_number9, a_index: integer, c: number)
  -> number * 9
```

Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant

## linalg.pow_mat3_ex

```lua
function linalg.pow_mat3_ex(a: seq_number9, a_index: integer, b: seq_number9, b_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in two 3d-vectors in a slice and store the result in a destination

## linalg.pow_mat3_ex

```lua
function linalg.pow_mat3_ex(a: seq_number9, a_index: integer, b: seq_number3, b_index: integer)
  -> number * 9
```

Apply the exponentiation operator to each element in two 3x3 matrices in a slice

## linalg.pow_mat4

```lua
function linalg.pow_mat4(a: number16, b: number16)
  -> number * 16
```

Apply the exponentiation operator to each element in two 4x4 matrices

## linalg.pow_mat4_constant

```lua
function linalg.pow_mat4_constant(a: number16, c: number)
  -> number * 16
```

Apply the exponentiation operator to each element in a 4x4 matrix and a constant

## linalg.pow_mat4_constant_ex

```lua
function linalg.pow_mat4_constant_ex(a: seq_number16, a_index: integer, c: number)
  -> number * 16
```

Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant

## linalg.pow_mat4_constant_ex

```lua
function linalg.pow_mat4_constant_ex(a: seq_number16, a_index: integer, c: number, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## linalg.pow_mat4_ex

```lua
function linalg.pow_mat4_ex(a: seq_number16, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 16
```

Apply the exponentiation operator to each element in two 4x4 matrices in a slice

## linalg.pow_mat4_ex

```lua
function linalg.pow_mat4_ex(a: seq_number16, a_index: integer, b: seq_number16, b_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in two 4d-vectors in a slice and store the result in a destination

## linalg.pow_vec2

```lua
function linalg.pow_vec2(a: number2, b: number2)
  -> number, number
```

Apply the exponentiation operator to two 2d-vectors

## linalg.pow_vec2_constant

```lua
function linalg.pow_vec2_constant(a: number2, c: number)
  -> number, number
```

Apply the exponentiation operator to a 2d-vector and a constant

## linalg.pow_vec2_constant_ex

```lua
function linalg.pow_vec2_constant_ex(a: seq_number2, a_index: integer, c: number)
  -> number, number
```

Apply the exponentiation operator to a 2d-vector in a slice and a constant

## linalg.pow_vec2_constant_ex

```lua
function linalg.pow_vec2_constant_ex(a: seq_number2, a_index: integer, c: number, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to a 2d-vector in a slice and a constant and store in a destination

## linalg.pow_vec2_ex

```lua
function linalg.pow_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer)
  -> number, number
```

Apply the exponentiation operator to two 2d-vectors in a slice

## linalg.pow_vec2_ex

```lua
function linalg.pow_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two 2d-vectors in a slice and store the result in a destination

## linalg.pow_vec3

```lua
function linalg.pow_vec3(a: number3, b: number3)
  -> number, number, number
```

Apply the exponentiation operator to two 3d-vectors

## linalg.pow_vec3_constant

```lua
function linalg.pow_vec3_constant(a: number3, c: number)
  -> number, number, number
```

Apply the exponentiation operator to a 3d-vector and a constant

## linalg.pow_vec3_constant_ex

```lua
function linalg.pow_vec3_constant_ex(a: seq_number3, a_index: integer, c: number)
  -> number, number, number
```

Apply the exponentiation operator to a 3d-vector in a slice and a constant

## linalg.pow_vec3_constant_ex

```lua
function linalg.pow_vec3_constant_ex(a: seq_number3, a_index: integer, c: number, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to a 3d-vector in a slice and a constant and store in a destination

## linalg.pow_vec3_ex

```lua
function linalg.pow_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number, number, number
```

Apply the exponentiation operator to two 3d-vectors in a slice

## linalg.pow_vec3_ex

```lua
function linalg.pow_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two 3d-vectors in a slice and store the result in a destination

## linalg.pow_vec4

```lua
function linalg.pow_vec4(a: number4, b: number4)
  -> number * 4
```

Apply the exponentiation operator to two 4d-vectors

## linalg.pow_vec4_constant

```lua
function linalg.pow_vec4_constant(a: number4, c: number)
  -> number * 4
```

Apply the exponentiation operator to a 4d-vector and a constant

## linalg.pow_vec4_constant_ex

```lua
function linalg.pow_vec4_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the exponentiation operator to a 4d-vector in a slice and a constant

## linalg.pow_vec4_constant_ex

```lua
function linalg.pow_vec4_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to a 4d-vector in a slice and a constant and store in a destination

## linalg.pow_vec4_ex

```lua
function linalg.pow_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 4
```

Apply the exponentiation operator to two 4d-vectors in a slice

## linalg.pow_vec4_ex

```lua
function linalg.pow_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two 4d-vectors in a slice and store the result in a destination

## linalg.sub_2

```lua
function linalg.sub_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the subtraction operator to two 2-tuples

## linalg.sub_3

```lua
function linalg.sub_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the subtraction operator to two 3-tuples

## linalg.sub_4

```lua
function linalg.sub_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the subtraction operator to two 4-tuples

## linalg.sub_mat2

```lua
function linalg.sub_mat2(a: number4, b: number4)
  -> number * 4
```

Apply the subtraction operator to each element in two 2x2 matrices

## linalg.sub_mat2_constant

```lua
function linalg.sub_mat2_constant(a: number4, c: number)
  -> number * 4
```

Apply the subtraction operator to each element in a 2x2 matrix and a constant

## linalg.sub_mat2_constant_ex

```lua
function linalg.sub_mat2_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant

## linalg.sub_mat2_constant_ex

```lua
function linalg.sub_mat2_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## linalg.sub_mat2_ex

```lua
function linalg.sub_mat2_ex(a: seq_number4, a_index: integer, b: seq_number2, b_index: integer)
  -> number * 4
```

Apply the subtraction operator to each element in two 2x2 matrices in a slice

## linalg.sub_mat2_ex

```lua
function linalg.sub_mat2_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in two 2d-vectors in a slice and store the result in a destination

## linalg.sub_mat3

```lua
function linalg.sub_mat3(a: number9, b: number9)
  -> number * 9
```

Apply the subtraction operator to each element in two 3x3 matrices

## linalg.sub_mat3_constant

```lua
function linalg.sub_mat3_constant(a: number9, c: number)
  -> number * 9
```

Apply the subtraction operator to each element in a 3x3 matrix and a constant

## linalg.sub_mat3_constant_ex

```lua
function linalg.sub_mat3_constant_ex(a: seq_number9, a_index: integer, c: number, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## linalg.sub_mat3_constant_ex

```lua
function linalg.sub_mat3_constant_ex(a: seq_number9, a_index: integer, c: number)
  -> number * 9
```

Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant

## linalg.sub_mat3_ex

```lua
function linalg.sub_mat3_ex(a: seq_number9, a_index: integer, b: seq_number9, b_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in two 3d-vectors in a slice and store the result in a destination

## linalg.sub_mat3_ex

```lua
function linalg.sub_mat3_ex(a: seq_number9, a_index: integer, b: seq_number3, b_index: integer)
  -> number * 9
```

Apply the subtraction operator to each element in two 3x3 matrices in a slice

## linalg.sub_mat4

```lua
function linalg.sub_mat4(a: number16, b: number16)
  -> number * 16
```

Apply the subtraction operator to each element in two 4x4 matrices

## linalg.sub_mat4_constant

```lua
function linalg.sub_mat4_constant(a: number16, c: number)
  -> number * 16
```

Apply the subtraction operator to each element in a 4x4 matrix and a constant

## linalg.sub_mat4_constant_ex

```lua
function linalg.sub_mat4_constant_ex(a: seq_number16, a_index: integer, c: number, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## linalg.sub_mat4_constant_ex

```lua
function linalg.sub_mat4_constant_ex(a: seq_number16, a_index: integer, c: number)
  -> number * 16
```

Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant

## linalg.sub_mat4_ex

```lua
function linalg.sub_mat4_ex(a: seq_number16, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 16
```

Apply the subtraction operator to each element in two 4x4 matrices in a slice

## linalg.sub_mat4_ex

```lua
function linalg.sub_mat4_ex(a: seq_number16, a_index: integer, b: seq_number16, b_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in two 4d-vectors in a slice and store the result in a destination

## linalg.sub_vec2

```lua
function linalg.sub_vec2(a: number2, b: number2)
  -> number, number
```

Apply the subtraction operator to two 2d-vectors

## linalg.sub_vec2_constant

```lua
function linalg.sub_vec2_constant(a: number2, c: number)
  -> number, number
```

Apply the subtraction operator to a 2d-vector and a constant

## linalg.sub_vec2_constant_ex

```lua
function linalg.sub_vec2_constant_ex(a: seq_number2, a_index: integer, c: number)
  -> number, number
```

Apply the subtraction operator to a 2d-vector in a slice and a constant

## linalg.sub_vec2_constant_ex

```lua
function linalg.sub_vec2_constant_ex(a: seq_number2, a_index: integer, c: number, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to a 2d-vector in a slice and a constant and store in a destination

## linalg.sub_vec2_ex

```lua
function linalg.sub_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer)
  -> number, number
```

Apply the subtraction operator to two 2d-vectors in a slice

## linalg.sub_vec2_ex

```lua
function linalg.sub_vec2_ex(a: seq_number2, a_index: integer, b: seq_number2, b_index: integer, dest: seq_number2, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two 2d-vectors in a slice and store the result in a destination

## linalg.sub_vec3

```lua
function linalg.sub_vec3(a: number3, b: number3)
  -> number, number, number
```

Apply the subtraction operator to two 3d-vectors

## linalg.sub_vec3_constant

```lua
function linalg.sub_vec3_constant(a: number3, c: number)
  -> number, number, number
```

Apply the subtraction operator to a 3d-vector and a constant

## linalg.sub_vec3_constant_ex

```lua
function linalg.sub_vec3_constant_ex(a: seq_number3, a_index: integer, c: number, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to a 3d-vector in a slice and a constant and store in a destination

## linalg.sub_vec3_constant_ex

```lua
function linalg.sub_vec3_constant_ex(a: seq_number3, a_index: integer, c: number)
  -> number, number, number
```

Apply the subtraction operator to a 3d-vector in a slice and a constant

## linalg.sub_vec3_ex

```lua
function linalg.sub_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer, dest: seq_number3, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two 3d-vectors in a slice and store the result in a destination

## linalg.sub_vec3_ex

```lua
function linalg.sub_vec3_ex(a: seq_number3, a_index: integer, b: seq_number3, b_index: integer)
  -> number, number, number
```

Apply the subtraction operator to two 3d-vectors in a slice

## linalg.sub_vec4

```lua
function linalg.sub_vec4(a: number4, b: number4)
  -> number * 4
```

Apply the subtraction operator to two 4d-vectors

## linalg.sub_vec4_constant

```lua
function linalg.sub_vec4_constant(a: number4, c: number)
  -> number * 4
```

Apply the subtraction operator to a 4d-vector and a constant

## linalg.sub_vec4_constant_ex

```lua
function linalg.sub_vec4_constant_ex(a: seq_number4, a_index: integer, c: number, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to a 4d-vector in a slice and a constant and store in a destination

## linalg.sub_vec4_constant_ex

```lua
function linalg.sub_vec4_constant_ex(a: seq_number4, a_index: integer, c: number)
  -> number * 4
```

Apply the subtraction operator to a 4d-vector in a slice and a constant

## linalg.sub_vec4_ex

```lua
function linalg.sub_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer)
  -> number * 4
```

Apply the subtraction operator to two 4d-vectors in a slice

## linalg.sub_vec4_ex

```lua
function linalg.sub_vec4_ex(a: seq_number4, a_index: integer, b: seq_number4, b_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two 4d-vectors in a slice and store the result in a destination

## linalg.transpose_mat1

```lua
function linalg.transpose_mat1(src: number1)
  -> number
```

Transpose a 1x1 matrix and return a 1x1 matrix

@*return* — (mat1)

## linalg.transpose_mat1x1

```lua
function linalg.transpose_mat1x1(src: number1)
  -> number
```

Transpose a 1x1 matrix and return a 1x1 matrix

@*return* — (mat1x1)

## linalg.transpose_mat1x2

```lua
function linalg.transpose_mat1x2(src: number2)
  -> number, number
```

Transpose a 1x2 matrix and return a 2x1 matrix

@*return* — (mat2x1)

## linalg.transpose_mat1x3

```lua
function linalg.transpose_mat1x3(src: number3)
  -> number, number, number
```

Transpose a 1x3 matrix and return a 3x1 matrix

@*return* — (mat3x1)

## linalg.transpose_mat1x4

```lua
function linalg.transpose_mat1x4(src: number4)
  -> number * 4
```

Transpose a 1x4 matrix and return a 4x1 matrix

@*return* — (mat4x1)

## linalg.transpose_mat2

```lua
function linalg.transpose_mat2(src: number4)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2)

## linalg.transpose_mat2_ex

```lua
function linalg.transpose_mat2_ex(src: seq_number4, src_index: integer)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2)

## linalg.transpose_mat2_ex

```lua
function linalg.transpose_mat2_ex(src: seq_number4, src_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Transpose a 2x2 matrix into a 2x2 matrix in a destination

## linalg.transpose_mat2x1

```lua
function linalg.transpose_mat2x1(src: number2)
  -> number, number
```

Transpose a 2x1 matrix and return a 1x2 matrix

@*return* — (mat1x2)

## linalg.transpose_mat2x2

```lua
function linalg.transpose_mat2x2(src: number4)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2x2)

## linalg.transpose_mat2x2_ex

```lua
function linalg.transpose_mat2x2_ex(src: seq_number4, src_index: integer)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2x2)

## linalg.transpose_mat2x2_ex

```lua
function linalg.transpose_mat2x2_ex(src: seq_number4, src_index: integer, dest: seq_number4, dest_index?: integer)
  -> nil
```

Transpose a 2x2 matrix into a 2x2 matrix in a destination

## linalg.transpose_mat2x3

```lua
function linalg.transpose_mat2x3(src: number6)
  -> number * 6
```

Transpose a 2x3 matrix and return a 3x2 matrix

@*return* — (mat3x2)

## linalg.transpose_mat2x3_ex

```lua
function linalg.transpose_mat2x3_ex(src: seq_number6, src_index: integer, dest: seq_number6, dest_index?: integer)
  -> nil
```

Transpose a 2x3 matrix into a 3x2 matrix in a destination

## linalg.transpose_mat2x3_ex

```lua
function linalg.transpose_mat2x3_ex(src: seq_number6, src_index: integer)
  -> number * 6
```

Transpose a 2x3 matrix and return a 3x2 matrix

@*return* — (mat3x2)

## linalg.transpose_mat2x4

```lua
function linalg.transpose_mat2x4(src: number8)
  -> number * 8
```

Transpose a 2x4 matrix and return a 4x2 matrix

@*return* — (mat4x2)

## linalg.transpose_mat2x4_ex

```lua
function linalg.transpose_mat2x4_ex(src: seq_number8, src_index: integer)
  -> number * 8
```

Transpose a 2x4 matrix and return a 4x2 matrix

@*return* — (mat4x2)

## linalg.transpose_mat2x4_ex

```lua
function linalg.transpose_mat2x4_ex(src: seq_number8, src_index: integer, dest: seq_number8, dest_index?: integer)
  -> nil
```

Transpose a 2x4 matrix into a 4x2 matrix in a destination

## linalg.transpose_mat3

```lua
function linalg.transpose_mat3(src: number9)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3)

## linalg.transpose_mat3_ex

```lua
function linalg.transpose_mat3_ex(src: seq_number9, src_index: integer)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3)

## linalg.transpose_mat3_ex

```lua
function linalg.transpose_mat3_ex(src: seq_number9, src_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Transpose a 3x3 matrix into a 3x3 matrix in a destination

## linalg.transpose_mat3x1

```lua
function linalg.transpose_mat3x1(src: number3)
  -> number, number, number
```

Transpose a 3x1 matrix and return a 1x3 matrix

@*return* — (mat1x3)

## linalg.transpose_mat3x2

```lua
function linalg.transpose_mat3x2(src: number6)
  -> number * 6
```

Transpose a 3x2 matrix and return a 2x3 matrix

@*return* — (mat2x3)

## linalg.transpose_mat3x2_ex

```lua
function linalg.transpose_mat3x2_ex(src: seq_number6, src_index: integer)
  -> number * 6
```

Transpose a 3x2 matrix and return a 2x3 matrix

@*return* — (mat2x3)

## linalg.transpose_mat3x2_ex

```lua
function linalg.transpose_mat3x2_ex(src: seq_number6, src_index: integer, dest: seq_number6, dest_index?: integer)
  -> nil
```

Transpose a 3x2 matrix into a 2x3 matrix in a destination

## linalg.transpose_mat3x3

```lua
function linalg.transpose_mat3x3(src: number9)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3x3)

## linalg.transpose_mat3x3_ex

```lua
function linalg.transpose_mat3x3_ex(src: seq_number9, src_index: integer, dest: seq_number9, dest_index?: integer)
  -> nil
```

Transpose a 3x3 matrix into a 3x3 matrix in a destination

## linalg.transpose_mat3x3_ex

```lua
function linalg.transpose_mat3x3_ex(src: seq_number9, src_index: integer)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3x3)

## linalg.transpose_mat3x4

```lua
function linalg.transpose_mat3x4(src: number12)
  -> number * 12
```

Transpose a 3x4 matrix and return a 4x3 matrix

@*return* — (mat4x3)

## linalg.transpose_mat3x4_ex

```lua
function linalg.transpose_mat3x4_ex(src: seq_number12, src_index: integer)
  -> number * 12
```

Transpose a 3x4 matrix and return a 4x3 matrix

@*return* — (mat4x3)

## linalg.transpose_mat3x4_ex

```lua
function linalg.transpose_mat3x4_ex(src: seq_number12, src_index: integer, dest: seq_number12, dest_index?: integer)
  -> nil
```

Transpose a 3x4 matrix into a 4x3 matrix in a destination

## linalg.transpose_mat4

```lua
function linalg.transpose_mat4(src: number16)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4)

## linalg.transpose_mat4_ex

```lua
function linalg.transpose_mat4_ex(src: seq_number16, src_index: integer)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4)

## linalg.transpose_mat4_ex

```lua
function linalg.transpose_mat4_ex(src: seq_number16, src_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Transpose a 4x4 matrix into a 4x4 matrix in a destination

## linalg.transpose_mat4x1

```lua
function linalg.transpose_mat4x1(src: number4)
  -> number * 4
```

Transpose a 4x1 matrix and return a 1x4 matrix

@*return* — (mat1x4)

## linalg.transpose_mat4x2

```lua
function linalg.transpose_mat4x2(src: number8)
  -> number * 8
```

Transpose a 4x2 matrix and return a 2x4 matrix

@*return* — (mat2x4)

## linalg.transpose_mat4x2_ex

```lua
function linalg.transpose_mat4x2_ex(src: seq_number8, src_index: integer)
  -> number * 8
```

Transpose a 4x2 matrix and return a 2x4 matrix

@*return* — (mat2x4)

## linalg.transpose_mat4x2_ex

```lua
function linalg.transpose_mat4x2_ex(src: seq_number8, src_index: integer, dest: seq_number8, dest_index?: integer)
  -> nil
```

Transpose a 4x2 matrix into a 2x4 matrix in a destination

## linalg.transpose_mat4x3

```lua
function linalg.transpose_mat4x3(src: number12)
  -> number * 12
```

Transpose a 4x3 matrix and return a 3x4 matrix

@*return* — (mat3x4)

## linalg.transpose_mat4x3_ex

```lua
function linalg.transpose_mat4x3_ex(src: seq_number12, src_index: integer)
  -> number * 12
```

Transpose a 4x3 matrix and return a 3x4 matrix

@*return* — (mat3x4)

## linalg.transpose_mat4x3_ex

```lua
function linalg.transpose_mat4x3_ex(src: seq_number12, src_index: integer, dest: seq_number12, dest_index?: integer)
  -> nil
```

Transpose a 4x3 matrix into a 3x4 matrix in a destination

## linalg.transpose_mat4x4

```lua
function linalg.transpose_mat4x4(src: number16)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4x4)

## linalg.transpose_mat4x4_ex

```lua
function linalg.transpose_mat4x4_ex(src: seq_number16, src_index: integer, dest: seq_number16, dest_index?: integer)
  -> nil
```

Transpose a 4x4 matrix into a 4x4 matrix in a destination

## linalg.transpose_mat4x4_ex

```lua
function linalg.transpose_mat4x4_ex(src: seq_number16, src_index: integer)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4x4)

## linalg.vec2_zero

```lua
function linalg.vec2_zero()
  -> number, number
```

2d-vector of zeros

## linalg.vec3_zero

```lua
function linalg.vec3_zero()
  -> number, number, number
```

3d-vector of zeros

## linalg.vec4_zero

```lua
function linalg.vec4_zero()
  -> number * 4
```

4d-vector of zeros


---

# matrix_2
Matrix operations and types  

Classes and functions for working with matrices  


## matrix_2.new

```lua
function matrix_2.new(e_11: number, e_12: number, e_21: number, e_22: number)
  -> matrix_2
```

Create a new matrix_2
Parameter `e_ij` determines the value of `i'th` column `j'th` row


---

# matrix_3
Matrix operations and types  

Classes and functions for working with matrices  


## matrix_3.new

```lua
function matrix_3.new(e_11: number, e_12: number, e_13: number, e_21: number, e_22: number, e_23: number, e_31: number, e_32: number, e_33: number)
  -> matrix_3
```

Create a new matrix_3
Parameter `e_ij` determines the value of `i'th` column `j'th` row


---

# matrix_4
Matrix operations and types  

Classes and functions for working with matrices  


## matrix_4.new

```lua
function matrix_4.new(e_11: number, e_12: number, e_13: number, e_14: number, e_21: number, e_22: number, e_23: number, e_24: number, e_31: number, e_32: number, e_33: number, e_34: number, e_41: number, e_42: number, e_43: number, e_44: number)
  -> matrix_4
```

Create a new matrix_4
Parameter `e_ij` determines the value of `i'th` column `j'th` row


---

# vector_2
Vector operations and types  

Classes and functions for working with 2-d vectors  

Usage:  
```lua  
	-- Create a new vector  
	local v1 = vector_2.new(1, 3)  

	-- Get elements via indices, x(), y(), or xy()  
	print(v1[1], v1[2]) --> "1 3"  
	print(v1:x(), v1:y()) --> "1 3"  
	print(v:xy()) --> "1 3"  

	-- Set an element  
	v1:set_y(2)  
	print(v1:xy()) --> "1 2"  

	-- Sum vectors using add() or + operator  
	local v2 = vector_2.new(3, 4)  
	local v3 = v1 + v2 -- or v1:add(v2)  
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


## vector_2.new

```lua
function vector_2.new(v1: number, v2: number)
  -> vector_2
```

Create a new vector_2 with given values


---

# vector_3
Vector operations and types  

Classes and functions for working with 3-d vectors  


## vector_3.new

```lua
function vector_3.new(v1: number, v2: number, v3: number)
  -> vector_3
```

Create a new vector_3 with given values


---

# vector_4
Vector operations and types  

Classes and functions for working with 4-d vectors  


## vector_4.new

```lua
function vector_4.new(v1: number, v2: number, v3: number, v4: number)
  -> vector_4
```

Create a new vector_4 with given values


---

# view
Views  

A view is a special array or sequence that maps into a subset of another array or sequence.  

The views in this module can be used to:  
* Pass subsets of arrays to AVM functions, such as interleaved data or reversed values  
* Provide array wrappers for objects, e.g., `M.slice(cdata, 0, 10)` will make an array wrapper for the first 10 elements of a cdata array  


## view.interleave

```lua
function view.interleave(src: seq<T>, index: integer, group_size: integer, stride: integer, count: integer)
  -> fixed_array<T>
```

Create a view over interleaved data, collecting `group_size` elements starting at `index` and skipping `stride` elements

Example:
```
local a = {1,2, x,x, 5,6, x,x, 9,10}
local b = view.interleaved(a, 1, 2, 2, 3)
print(b[1], b[2], b[3], b[4], b[5], b[6]) --> 1 2 5 6 9 10
```

## view.reverse

```lua
function view.reverse(src: array<T>|seq<T>, index?: integer, count?: integer)
  -> fixed_array<T>
```

Create a view into `src` that reverses the elements
 Can optionally start at `index` and reverse for `count` elements

Example:
```lua
local a = {1,2,3,4,5,6,7,8,9,10}
local b = view.reverse(a)
print(b[1], b[2], b[3]) --> 10 9 8
```

## view.slice

```lua
function view.slice(src: seq<T>, index: integer, count: integer)
  -> fixed_array<T>
```

Create a view into `src` that starts at `index` and has `count` elements

Example:
```lua
local a = {1,2,3,4,5,6,7,8,9,10}
local b = view.slice(a, 2, 3)
print(b[1], b[2], b[3]) --> 2 3 4
```

Note: Most array functions have `_ex` forms so this object is a convenience only

## view.slice_1

```lua
function view.slice_1(src: seq<T>, index: integer)
  -> fixed_array1<T>
```

Create a view of size `1` that maps into `src` starting from `index`

## view.slice_2

```lua
function view.slice_2(src: seq<T>, index: integer)
  -> fixed_array2<T>
```

Create a view of size `2` that maps into `src` starting from `index`

## view.slice_3

```lua
function view.slice_3(src: seq<T>, index: integer)
  -> fixed_array3<T>
```

Create a view of size `3` that maps into `src` starting from `index`

## view.slice_4

```lua
function view.slice_4(src: seq<T>, index: integer)
  -> fixed_array4<T>
```

Create a view of size `4` that maps into `src` starting from `index`

## view.slice_5

```lua
function view.slice_5(src: seq<T>, index: integer)
  -> fixed_array5<T>
```

Create a view of size `5` that maps into `src` starting from `index`

## view.slice_6

```lua
function view.slice_6(src: seq<T>, index: integer)
  -> fixed_array6<T>
```

Create a view of size `6` that maps into `src` starting from `index`

## view.slice_7

```lua
function view.slice_7(src: seq<T>, index: integer)
  -> fixed_array7<T>
```

Create a view of size `7` that maps into `src` starting from `index`

## view.slice_8

```lua
function view.slice_8(src: seq<T>, index: integer)
  -> fixed_array8<T>
```

Create a view of size `8` that maps into `src` starting from `index`

## view.slice_9

```lua
function view.slice_9(src: seq<T>, index: integer)
  -> fixed_array9<T>
```

Create a view of size `9` that maps into `src` starting from `index`

## view.slice_10

```lua
function view.slice_10(src: seq<T>, index: integer)
  -> fixed_array10<T>
```

Create a view of size `10` that maps into `src` starting from `index`

## view.slice_11

```lua
function view.slice_11(src: seq<T>, index: integer)
  -> fixed_array11<T>
```

Create a view of size `11` that maps into `src` starting from `index`

## view.slice_12

```lua
function view.slice_12(src: seq<T>, index: integer)
  -> fixed_array12<T>
```

Create a view of size `12` that maps into `src` starting from `index`

## view.slice_13

```lua
function view.slice_13(src: seq<T>, index: integer)
  -> fixed_array13<T>
```

Create a view of size `13` that maps into `src` starting from `index`

## view.slice_14

```lua
function view.slice_14(src: seq<T>, index: integer)
  -> fixed_array14<T>
```

Create a view of size `14` that maps into `src` starting from `index`

## view.slice_15

```lua
function view.slice_15(src: seq<T>, index: integer)
  -> fixed_array15<T>
```

Create a view of size `15` that maps into `src` starting from `index`

## view.slice_16

```lua
function view.slice_16(src: seq<T>, index: integer)
  -> fixed_array16<T>
```

Create a view of size `16` that maps into `src` starting from `index`

## view.stride

```lua
function view.stride(src: seq<T>, index: integer, stride: integer, count: integer)
  -> fixed_array<T>
```

Create a view into `src` that starts at `index` and skips `stride` elements

Example:
```lua
local a = {1,2,3,4,5,6}
local index, stride, count = 1, 2, 3
local b = view.stride(a, index, stride, count)
print(b[1], b[2], b[3]) --> 1 3 5
```