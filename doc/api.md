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

## add

```lua
function array.add(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<number>
```

Apply the addition operator to two arrays

`{a[i]+b[i]}` for all `i` in `[1, #a]`

## add_constant

```lua
function array.add_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<number>
```

Apply the addition operator to each element of an array with a constant

`{a[i]+c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## add_constant_ex

```lua
function array.add_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element of a slice with a constant and store the result in a destination

## add_constant_ex

```lua
function array.add_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<number>
```

Apply the addition operator to each element of a slice with a constant

## add_ex

```lua
function array.add_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<number>
```

Apply the addition operator to two slices and return the result

## add_ex

```lua
function array.add_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to two slices and store the result in a destination

## all_almost_equals

```lua
function array.all_almost_equals(a: avm.array<number>, b: avm.array<number>, epsilon?: number)
  -> boolean
```

true if the arrays are almost equal (differ by epsilon or less)

## all_almost_equals_constant

```lua
function array.all_almost_equals_constant(a: avm.array<number>, constant: number, epsilon?: number)
  -> boolean
```

 true if all the elements are almost equal to the constant (differ by epsilon or less)

## all_almost_equals_constant_ex

```lua
function array.all_almost_equals_constant_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, a_count: integer, constant: number, epsilon?: number)
  -> boolean
```

 true if all the elements are almost equal to the constant (differ by epsilon or less)

## all_almost_equals_ex

```lua
function array.all_almost_equals_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, a_count: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if a[1,#a] and b[1,#a] are almost equal (differ by epsilon or less)

## all_almost_equals_with_nan

```lua
function array.all_almost_equals_with_nan(a: avm.array<number>, b: avm.array<number>, epsilon?: number)
  -> boolean
```

true if a[1,#a] and b[1,#a] are almost equal (differ by epsilon or less)

nan is considered equal to itself

## all_equals

```lua
function array.all_equals(a: avm.array<T>, b: avm.array<T>)
  -> boolean
```

true if the arrays are equal and #a==#b

## all_equals_constant

```lua
function array.all_equals_constant(a: avm.array<T>, constant: <T>)
  -> boolean
```

 true if all the elements are equal to the constant

## all_equals_constant_ex

```lua
function array.all_equals_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, constant: <T>)
  -> boolean
```

 true if all the elements are equal to the constant

## all_equals_ex

```lua
function array.all_equals_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean
```

true if the slices are equal

## almost_equal

```lua
function array.almost_equal(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the almost equal operator to two arrays

`{|a[i]-b[i]| < eps}` for all `i` in `[1, #a]`

## almost_equal_constant

```lua
function array.almost_equal_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## almost_equal_constant_ex

```lua
function array.almost_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the almost equal operator to each element of a slice with a constant and store the result in a destination

## almost_equal_constant_ex

```lua
function array.almost_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the almost equal operator to each element of a slice with a constant

## almost_equal_ex

```lua
function array.almost_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the almost equal operator to two slices and return the result

## almost_equal_ex

```lua
function array.almost_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the almost equal operator to two slices and store the result in a destination

## almost_equal_with_nan

```lua
function array.almost_equal_with_nan(a: avm.array<T>, b: avm.seq<T>)
  -> avm.seq<boolean>
```

Apply the almost equal (but NaN==NaN) operator to two arrays

`{|a[i]-b[i]| < eps}` for all `i` in `[1, #a]`

## almost_equal_with_nan_ex

```lua
function array.almost_equal_with_nan_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.seq<boolean>
```

Apply the almost equal (but NaN==NaN) operator to two slices and return the result

## almost_equal_with_nan_ex

```lua
function array.almost_equal_with_nan_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: boolean[], dest_index?: integer)
  -> nil
```

Apply the almost equal (but NaN==NaN) operator to two slices and store the result in a destination

## append

```lua
function array.append(src: avm.array<T>, dest: avm.array<T>)
```

Append an array `src` onto the end of an array `dest`

Equivalent to `copy_into(src, dest, length(dest))`

## copy

```lua
function array.copy(src: avm.array<T>)
  -> avm.array<T>
```

Copy an array elements into a new array

## copy_array

```lua
function array.copy_array(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> avm.array<T>
```

Copy an array

Defaults to copying each element within a for loop

Optionally redefine this to support custom platform and userdata

## copy_array_into

```lua
function array.copy_array_into(src: avm.seq<T>, src_index: integer, src_count: integer, dest: avm.seq<T>, dest_index: integer)
```

Copy an array

Defaults to copying each element within a for loop

Optionally redefine this to support custom platform and userdata

## copy_ex

```lua
function array.copy_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> avm.array<T>
```

Copy a slice

## copy_ex

```lua
function array.copy_ex(src: avm.seq<T>, src_index: integer, src_count: integer, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Copy a slice to a destination

## div

```lua
function array.div(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<number>
```

Apply the division operator to two arrays

`{a[i]/b[i]}` for all `i` in `[1, #a]`

## div_constant

```lua
function array.div_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<number>
```

Apply the division operator to each element of an array with a constant

`{a[i]/c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## div_constant_ex

```lua
function array.div_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<number>
```

Apply the division operator to each element of a slice with a constant

## div_constant_ex

```lua
function array.div_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element of a slice with a constant and store the result in a destination

## div_ex

```lua
function array.div_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<number>
```

Apply the division operator to two slices and return the result

## div_ex

```lua
function array.div_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to two slices and store the result in a destination

## equal

```lua
function array.equal(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the equal operator to two arrays

`{a[i]==b[i]}` for all `i` in `[1, #a]`

## equal_constant

```lua
function array.equal_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## equal_constant_ex

```lua
function array.equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the equal operator to each element of a slice with a constant

## equal_constant_ex

```lua
function array.equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the equal operator to each element of a slice with a constant and store the result in a destination

## equal_ex

```lua
function array.equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the equal operator to two slices and store the result in a destination

## equal_ex

```lua
function array.equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the equal operator to two slices and return the result

## extend

```lua
function array.extend(dest: avm.array<T>, src: avm.array<T>)
```

Extend an array `dest` with `src`

Equivalent to `copy_into(src, dest, length(dest))`

## fill

```lua
function array.fill(constant: <T>, count: integer)
  -> avm.array<T>
```

create an array filled with a constant value

## fill_into

```lua
function array.fill_into(constant: <T>, count: integer, dest: avm.seq<T>, dest_index?: integer)
```

fill a sequence with a constant

## flatten

```lua
function array.flatten(src: any)
  -> any[]
```

Flatten a table of data

Example:
* `flatten({{1,2,3},{4,5,6}}})` -> `{1,2,3,4,5,6}`

## flatten_into

```lua
function array.flatten_into(src: any, dest: any, dest_index?: integer)
```

Flatten a table of data into a destination

Example:
* `flatten({{1,2,3},{4,5,6}}})` -> `{1,2,3,4,5,6}`

## generate

```lua
function array.generate(count: integer, f: fun(index: integer):<T>)
  -> avm.array<T>
```

Return a new an array with elements
`f(i)` for `i` in `[1,count]`

## generate_into

```lua
function array.generate_into(count: integer, f: fun(index: integer):<T>, dest: avm.seq<T>, dest_index?: integer)
```

Fill a destination with elements
`f(i)` for `i` in `[1,count]`

## get_2

```lua
function array.get_2(src: avm.seq<T>, src_index: integer)
  -> <T>, <T>
```

Get 2 values from a slice

## get_3

```lua
function array.get_3(src: avm.seq<T>, src_index: integer)
  -> <T>, <T>, <T>
```

Get 3 values from a slice

## get_4

```lua
function array.get_4(src: avm.seq<T>, src_index: integer)
  -> <T> * 4
```

Get 4 values from a slice

## get_5

```lua
function array.get_5(src: avm.seq<T>, src_index: integer)
  -> <T> * 5
```

Get 5 values from a slice

## get_6

```lua
function array.get_6(src: avm.seq<T>, src_index: integer)
  -> <T> * 6
```

Get 6 values from a slice

## get_7

```lua
function array.get_7(src: avm.seq<T>, src_index: integer)
  -> <T> * 7
```

Get 7 values from a slice

## get_8

```lua
function array.get_8(src: avm.seq<T>, src_index: integer)
  -> <T> * 8
```

Get 8 values from a slice

## get_9

```lua
function array.get_9(src: avm.seq<T>, src_index: integer)
  -> <T> * 9
```

Get 9 values from a slice

## get_10

```lua
function array.get_10(src: avm.seq<T>, src_index: integer)
  -> <T> * 10
```

Get 10 values from a slice

## get_11

```lua
function array.get_11(src: avm.seq<T>, src_index: integer)
  -> <T> * 11
```

Get 11 values from a slice

## get_12

```lua
function array.get_12(src: avm.seq<T>, src_index: integer)
  -> <T> * 12
```

Get 12 values from a slice

## get_13

```lua
function array.get_13(src: avm.seq<T>, src_index: integer)
  -> <T> * 13
```

Get 13 values from a slice

## get_14

```lua
function array.get_14(src: avm.seq<T>, src_index: integer)
  -> <T> * 14
```

Get 14 values from a slice

## get_15

```lua
function array.get_15(src: avm.seq<T>, src_index: integer)
  -> <T> * 15
```

Get 15 values from a slice

## get_16

```lua
function array.get_16(src: avm.seq<T>, src_index: integer)
  -> <T> * 16
```

Get 16 values from a slice

## greater_than

```lua
function array.greater_than(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the greater than operator to two arrays

`{a[i]>b[i]}` for all `i` in `[1, #a]`

## greater_than_constant

```lua
function array.greater_than_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## greater_than_constant_ex

```lua
function array.greater_than_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than operator to each element of a slice with a constant and store the result in a destination

## greater_than_constant_ex

```lua
function array.greater_than_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the greater than operator to each element of a slice with a constant

## greater_than_ex

```lua
function array.greater_than_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the greater than operator to two slices and return the result

## greater_than_ex

```lua
function array.greater_than_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than operator to two slices and store the result in a destination

## greater_than_or_equal

```lua
function array.greater_than_or_equal(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the greater than or equal to operator to two arrays

`{a[i]>=b[i]}` for all `i` in `[1, #a]`

## greater_than_or_equal_constant

```lua
function array.greater_than_or_equal_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## greater_than_or_equal_constant_ex

```lua
function array.greater_than_or_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the greater than or equal to operator to each element of a slice with a constant

## greater_than_or_equal_constant_ex

```lua
function array.greater_than_or_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than or equal to operator to each element of a slice with a constant and store the result in a destination

## greater_than_or_equal_ex

```lua
function array.greater_than_or_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the greater than or equal to operator to two slices and return the result

## greater_than_or_equal_ex

```lua
function array.greater_than_or_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the greater than or equal to operator to two slices and store the result in a destination

## grow_array

```lua
function array.grow_array(dest: avm.seq<T>, dest_index: integer, dest_count: integer)
```

Grow an array or sequence to span the range [index, index + count - 1]

Optionally redefine this to support custom platform and userdata

## is_array

```lua
function array.is_array(src: any)
  -> boolean
```

Determines if src is an array

Optionally redefine this to support custom platform and userdata

## join

```lua
function array.join(a: avm.array<T>, b: avm.array<T>)
  -> avm.array<T>
```

Create an array with elements `[a_1, ..., a_n, b_1, ..., b_n]`

## join_ex

```lua
function array.join_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, b_count: integer)
  -> avm.array<T>
```

Return an array with elements `[a_i, ..., a_(i+count), b_i, ..., b_(i+count)]`

## length

```lua
function array.length(src: any)
  -> integer
```

Returns the length of an array

Optionally redefine this to support custom platform and userdata

## lerp

```lua
function array.lerp(a: avm.array<T>, b: avm.seq<T>, t: number)
  -> avm.array<T>
```

Linearly interpolate between arrays and return an array

`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`

## lerp_ex

```lua
function array.lerp_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, t: number, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Linearly interpolate between slices into a destination

`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`

## lerp_ex

```lua
function array.lerp_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, t: number)
  -> avm.array<T>
```

Linearly interpolate between slices and return an array

`{a[i]*(1-t)+b[i]*t}` for all `i` in `[1, #a]`

## less_than

```lua
function array.less_than(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the less than operator to two arrays

`{a[i]<b[i]}` for all `i` in `[1, #a]`

## less_than_constant

```lua
function array.less_than_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## less_than_constant_ex

```lua
function array.less_than_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the less than operator to each element of a slice with a constant

## less_than_constant_ex

```lua
function array.less_than_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than operator to each element of a slice with a constant and store the result in a destination

## less_than_ex

```lua
function array.less_than_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the less than operator to two slices and return the result

## less_than_ex

```lua
function array.less_than_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than operator to two slices and store the result in a destination

## less_than_or_equal

```lua
function array.less_than_or_equal(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the less than or equal to operator to two arrays

`{a[i]<=b[i]}` for all `i` in `[1, #a]`

## less_than_or_equal_constant

```lua
function array.less_than_or_equal_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## less_than_or_equal_constant_ex

```lua
function array.less_than_or_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the less than or equal to operator to each element of a slice with a constant

## less_than_or_equal_constant_ex

```lua
function array.less_than_or_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than or equal to operator to each element of a slice with a constant and store the result in a destination

## less_than_or_equal_ex

```lua
function array.less_than_or_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the less than or equal to operator to two slices and return the result

## less_than_or_equal_ex

```lua
function array.less_than_or_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the less than or equal to operator to two slices and store the result in a destination

## map

```lua
function array.map(f: fun(v1: <T1>):<U>, a1: avm.array<T1>)
  -> avm.array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i])` for each `i` over the range `[1, #a1]`

## map_2

```lua
function array.map_2(f: fun(v1: <T1>, v2: <T2>):<U>, a1: avm.array<T1>, a2: avm.array<T2>)
  -> avm.array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i], a2[i])` for each `i` over the range `[1, #a1]`

## map_2_ex

```lua
function array.map_2_ex(f: fun(v1: <T1>, v2: <T2>):<U>, a1: avm.seq<T1>, a1_index: any, a1_count: any, a2: avm.seq<T2>, a2_index: integer)
  -> avm.array<U>
```

Apply a function to each element of the sequences and return an array

## map_2_ex

```lua
function array.map_2_ex(f: fun(v1: <T1>, v2: <T2>):<U>, a1: avm.seq<T1>, a1_index: any, a1_count: any, a2: avm.seq<T2>, a2_index: integer, dest: avm.seq<U>, dest_index?: integer)
  -> avm.seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## map_3

```lua
function array.map_3(f: fun(v1: <T1>, v2: <T2>, v3: <T3>):<U>, a1: avm.array<T1>, a2: avm.array<T2>, a3: avm.array<T3>)
  -> avm.array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i], a2[i], a3[i])` for each `i` over the range `[1, #a1]`

## map_3_ex

```lua
function array.map_3_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>):<U>, a1: avm.seq<T1>, a1_index: any, a1_count: any, a2: avm.seq<T2>, a2_index: any, a3: avm.seq<T3>, a3_index: integer)
  -> avm.array<U>
```

Apply a function to each element of the sequences and return an array

## map_3_ex

```lua
function array.map_3_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>):<U>, a1: avm.seq<T1>, a1_index: any, a1_count: any, a2: avm.seq<T2>, a2_index: any, a3: avm.seq<T3>, a3_index: integer, dest: avm.seq<U>, dest_index?: integer)
  -> avm.seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## map_4

```lua
function array.map_4(f: fun(v1: <T1>, v2: <T2>, v3: <T3>, v4: <T4>):<U>, a1: avm.array<T1>, a2: avm.array<T2>, a3: avm.array<T3>, a4: avm.array<T4>)
  -> avm.array<U>
```

Apply a function to each element of the arrays and return an array
`f(a1[i], a2[i], a3[i], a4[i])` for each `i` over the range `[1, #a1]`

## map_4_ex

```lua
function array.map_4_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>, v4: <T4>):<U>, a1: avm.seq<T1>, a1_index: any, a1_count: any, a2: avm.seq<T2>, a2_index: any, a3: avm.seq<T3>, a3_index: any, a4: avm.seq<T4>, a4_index: integer)
  -> avm.array<U>
```

Apply a function to each element of the sequences and return an array

## map_4_ex

```lua
function array.map_4_ex(f: fun(v1: <T1>, v2: <T2>, v3: <T3>, v4: <T4>):<U>, a1: avm.seq<T1>, a1_index: any, a1_count: any, a2: avm.seq<T2>, a2_index: any, a3: avm.seq<T3>, a3_index: any, a4: avm.seq<T4>, a4_index: integer, dest: avm.seq<U>, dest_index?: integer)
  -> avm.seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## map_ex

```lua
function array.map_ex(f: fun(v1: <T1>):<U>, a1: avm.seq<T1>, a1_index: integer, a1_count: integer)
  -> avm.array<U>
```

Apply a function to each element of the sequences and return an array

## map_ex

```lua
function array.map_ex(f: fun(v1: <T1>):<U>, a1: avm.seq<T1>, a1_index: integer, a1_count: integer, dest: avm.seq<U>, dest_index?: integer)
  -> avm.seq<U>
```

Apply a function to each element of the sequences and fill a target a destination

## max

```lua
function array.max(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<T>
```

Apply the maximum operator to two arrays

`{max(a[i],b[i])}` for all `i` in `[1, #a]`

## max_constant

```lua
function array.max_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<T>
```

Apply the maximum operator to each element of an array with a constant

`{max(a[i],c)}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## max_constant_ex

```lua
function array.max_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<T>
```

Apply the maximum operator to each element of a slice with a constant

## max_constant_ex

```lua
function array.max_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Apply the maximum operator to each element of a slice with a constant and store the result in a destination

## max_ex

```lua
function array.max_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<T>
```

Apply the maximum operator to two slices and return the result

## max_ex

```lua
function array.max_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Apply the maximum operator to two slices and store the result in a destination

## min

```lua
function array.min(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<T>
```

Apply the minimum operator to two arrays

`{min(a[i],b[i])}` for all `i` in `[1, #a]`

## min_constant

```lua
function array.min_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<T>
```

Apply the minimum operator to each element of an array with a constant

`{min(a[i],c)}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## min_constant_ex

```lua
function array.min_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<T>
```

Apply the minimum operator to each element of a slice with a constant

## min_constant_ex

```lua
function array.min_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Apply the minimum operator to each element of a slice with a constant and store the result in a destination

## min_ex

```lua
function array.min_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<T>
```

Apply the minimum operator to two slices and return the result

## min_ex

```lua
function array.min_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Apply the minimum operator to two slices and store the result in a destination

## mod

```lua
function array.mod(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<number>
```

Apply the modulus operator to two arrays

`{a[i]%b[i]}` for all `i` in `[1, #a]`

## mod_constant

```lua
function array.mod_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<number>
```

Apply the modulus operator to each element of an array with a constant

`{a[i]%c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## mod_constant_ex

```lua
function array.mod_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the modulus operator to each element of a slice with a constant and store the result in a destination

## mod_constant_ex

```lua
function array.mod_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<number>
```

Apply the modulus operator to each element of a slice with a constant

## mod_ex

```lua
function array.mod_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<number>
```

Apply the modulus operator to two slices and return the result

## mod_ex

```lua
function array.mod_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the modulus operator to two slices and store the result in a destination

## mul

```lua
function array.mul(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<number>
```

Apply the multiplication operator to two arrays

`{a[i]*b[i]}` for all `i` in `[1, #a]`

## mul_add

```lua
function array.mul_add(a: avm.array<T>, b: avm.seq<T>, c: avm.seq<T>)
  -> avm.array<T>
```

Perform the multiply-add operation on three arrays and return an array

`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`

## mul_add_constant

```lua
function array.mul_add_constant(a: avm.array<T>, b: avm.seq<T>, c: <T>|avm.array<T>)
  -> avm.array<T>
```

Perform the multiply-add operation on two arrays and a constant and return an array

`{a[i]+b[i]*c}` for all `i` in `[1, #a]`

## mul_add_constant_ex

```lua
function array.mul_add_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, c: <T>|avm.array<T>)
  -> avm.array<T>
```

Perform the multiply-add operation on two slices and a constant and return an array

`{a[i]+b[i]*c}` for all `i` in `[1, #a]`

## mul_add_constant_ex

```lua
function array.mul_add_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, c: <T>|avm.array<T>, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Perform the multiply-add operation on two slices and a constant into a destination

`{a[i]+b[i]*c}` for all `i` in `[1, #a]`

## mul_add_ex

```lua
function array.mul_add_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, c: avm.seq<T>, c_index: integer)
```

Perform the multiply-add operation on three slices and return an array

`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`

## mul_add_ex

```lua
function array.mul_add_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, c: avm.seq<T>, c_index: integer, dest: avm.seq<T>, dest_index?: integer)
  -> avm.seq<T>
```

Perform the multiply-add operation on three slices into a destination

`{a[i]+b[i]*c[i]}` for all `i` in `[1, #a]`

## mul_constant

```lua
function array.mul_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<number>
```

Apply the multiplication operator to each element of an array with a constant

`{a[i]*c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## mul_constant_ex

```lua
function array.mul_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<number>
```

Apply the multiplication operator to each element of a slice with a constant

## mul_constant_ex

```lua
function array.mul_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element of a slice with a constant and store the result in a destination

## mul_ex

```lua
function array.mul_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<number>
```

Apply the multiplication operator to two slices and return the result

## mul_ex

```lua
function array.mul_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two slices and store the result in a destination

## new_array

```lua
function array.new_array(type: <T>, length: integer)
  -> avm.array<T>
```

Create a new an array with an initial length

Optionally redefine this to support custom platform and userdata

## not_equal

```lua
function array.not_equal(a: avm.array<T>, b: avm.seq<T>)
  -> boolean[]
```

Apply the not equal operator to two arrays

`{a[i]~=b[i]}` for all `i` in `[1, #a]`

## not_equal_constant

```lua
function array.not_equal_constant(a: avm.array<T>, c: <T>|avm.array<T>)
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

## not_equal_constant_ex

```lua
function array.not_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> boolean[]
```

Apply the not equal operator to each element of a slice with a constant

## not_equal_constant_ex

```lua
function array.not_equal_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the not equal operator to each element of a slice with a constant and store the result in a destination

## not_equal_ex

```lua
function array.not_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> boolean[]
```

Apply the not equal operator to two slices and return the result

## not_equal_ex

```lua
function array.not_equal_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq<boolean>, dest_index?: integer)
  -> nil
```

Apply the not equal operator to two slices and store the result in a destination

## pop

```lua
function array.pop(src: avm.array<T>)
  -> <T>
```

Pop a value off the end of an array and return it
See:
  * [array.pop_1](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#1461#9)
  * [array.pop_2](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#1474#9)
  * [array.pop_3](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#1489#9)

## pop_1

```lua
function array.pop_1(src: avm.array<T>)
  -> <T>
```

Pop 1 value(s) off the end of an array and return them

## pop_2

```lua
function array.pop_2(src: avm.array<T>)
  -> <T>, <T>
```

Pop 2 value(s) off the end of an array and return them

## pop_3

```lua
function array.pop_3(src: avm.array<T>)
  -> <T>, <T>, <T>
```

Pop 3 value(s) off the end of an array and return them

## pop_4

```lua
function array.pop_4(src: avm.array<T>)
  -> <T> * 4
```

Pop 4 value(s) off the end of an array and return them

## pop_5

```lua
function array.pop_5(src: avm.array<T>)
  -> <T> * 5
```

Pop 5 value(s) off the end of an array and return them

## pop_6

```lua
function array.pop_6(src: avm.array<T>)
  -> <T> * 6
```

Pop 6 value(s) off the end of an array and return them

## pop_7

```lua
function array.pop_7(src: avm.array<T>)
  -> <T> * 7
```

Pop 7 value(s) off the end of an array and return them

## pop_8

```lua
function array.pop_8(src: avm.array<T>)
  -> <T> * 8
```

Pop 8 value(s) off the end of an array and return them

## pop_9

```lua
function array.pop_9(src: avm.array<T>)
  -> <T> * 9
```

Pop 9 value(s) off the end of an array and return them

## pop_10

```lua
function array.pop_10(src: avm.array<T>)
  -> <T> * 10
```

Pop 10 value(s) off the end of an array and return them

## pop_11

```lua
function array.pop_11(src: avm.array<T>)
  -> <T> * 11
```

Pop 11 value(s) off the end of an array and return them

## pop_12

```lua
function array.pop_12(src: avm.array<T>)
  -> <T> * 12
```

Pop 12 value(s) off the end of an array and return them

## pop_13

```lua
function array.pop_13(src: avm.array<T>)
  -> <T> * 13
```

Pop 13 value(s) off the end of an array and return them

## pop_14

```lua
function array.pop_14(src: avm.array<T>)
  -> <T> * 14
```

Pop 14 value(s) off the end of an array and return them

## pop_15

```lua
function array.pop_15(src: avm.array<T>)
  -> <T> * 15
```

Pop 15 value(s) off the end of an array and return them

## pop_16

```lua
function array.pop_16(src: avm.array<T>)
  -> <T> * 16
```

Pop 16 value(s) off the end of an array and return them

## pow

```lua
function array.pow(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<number>
```

Apply the exponentiation operator to two arrays

`{a[i]^b[i]}` for all `i` in `[1, #a]`

## pow_constant

```lua
function array.pow_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<number>
```

Apply the exponentiation operator to each element of an array with a constant

`{a[i]^c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## pow_constant_ex

```lua
function array.pow_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<number>
```

Apply the exponentiation operator to each element of a slice with a constant

## pow_constant_ex

```lua
function array.pow_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element of a slice with a constant and store the result in a destination

## pow_ex

```lua
function array.pow_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<number>
```

Apply the exponentiation operator to two slices and return the result

## pow_ex

```lua
function array.pow_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two slices and store the result in a destination

## push

```lua
function array.push(dest: avm.array<T>, ...<T>)
```

Push values onto an array

also see `push_1()`, `push_2()`, `push_3()`, etc.

## push_1

```lua
function array.push_1(dest: avm.array<T>, v1: <T>)
```

Push 1 value(s) onto an array

## push_2

```lua
function array.push_2(dest: avm.array<T>, v1: <T>, v2: <T>)
```

Push 2 value(s) onto an array

## push_3

```lua
function array.push_3(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>)
```

Push 3 value(s) onto an array

## push_4

```lua
function array.push_4(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>)
```

Push 4 value(s) onto an array

## push_5

```lua
function array.push_5(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>)
```

Push 5 value(s) onto an array

## push_6

```lua
function array.push_6(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>)
```

Push 6 value(s) onto an array

## push_7

```lua
function array.push_7(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>)
```

Push 7 value(s) onto an array

## push_8

```lua
function array.push_8(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>)
```

Push 8 value(s) onto an array

## push_9

```lua
function array.push_9(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>)
```

Push 9 value(s) onto an array

## push_10

```lua
function array.push_10(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>)
```

Push 10 value(s) onto an array

## push_11

```lua
function array.push_11(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>)
```

Push 11 value(s) onto an array

## push_12

```lua
function array.push_12(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>)
```

Push 12 value(s) onto an array

## push_13

```lua
function array.push_13(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>)
```

Push 13 value(s) onto an array

## push_14

```lua
function array.push_14(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>, v14: <T>)
```

Push 14 value(s) onto an array

## push_15

```lua
function array.push_15(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>, v14: <T>, v15: <T>)
```

Push 15 value(s) onto an array

## push_16

```lua
function array.push_16(dest: avm.array<T>, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>, v14: <T>, v15: <T>, v16: <T>)
```

Push 16 value(s) onto an array

## range

```lua
function array.range(from: <T>, to: <T>, step_size?: <T>)
  -> avm.array<T>
```

create an array with sequential values in `from .. to` in `step_size` increments

@*param* `step_size` — default = 1

## range_into

```lua
function array.range_into(from: number, to: number, step_size: number, dest: avm.seq<T>, dest_index?: integer)
```

fill a destination with sequential values in `from .. to` in `step_size` increments

## reshape

```lua
function array.reshape(src: any, dest_size: integer[])
  -> table
```

Reshape a table or an array from nested arrays to a flat array or vice versa

Examples:
* `reshape({1,2,3,4,5,6}, {3,2})` -> `{{1,2},{3,4},{5,6}}`
* `reshape({{1,2,3},{4,5,6}}}, {6})` -> `{1,2,3,4,5,6}`

## reshape_into

```lua
function array.reshape_into(src: any, dest_size: integer[], dest: any, dest_index?: integer)
  -> unknown
```

Reshape a table or an array into a destination
See:
  * [array.reshape](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#318#9)
  * [array.flatten](file:///c%3A/dev/geo/lib/avm/build/lua52/avm/array.lua#408#9)

## reverse

```lua
function array.reverse(src: avm.array<T>)
  -> avm.array<T>
```

Reverse an array

## reverse_ex

```lua
function array.reverse_ex(src: avm.seq<T>, src_index: integer, src_count: integer, dest: avm.seq<T>, dest_index?: integer)
  -> nil
```

Reverse a slice into a destination

## reverse_ex

```lua
function array.reverse_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> avm.array<T>
```

Reverse a slice

## set

```lua
function array.set(dest: avm.seq<T>, dest_index: integer, ...<T>)
```

Set values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_1

```lua
function array.set_1(dest: avm.seq<T>, dest_index: integer, v1: <T>)
```

Set 1 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_2

```lua
function array.set_2(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>)
```

Set 2 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_3

```lua
function array.set_3(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>)
```

Set 3 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_4

```lua
function array.set_4(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>)
```

Set 4 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_5

```lua
function array.set_5(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>)
```

Set 5 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_6

```lua
function array.set_6(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>)
```

Set 6 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_7

```lua
function array.set_7(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>)
```

Set 7 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_8

```lua
function array.set_8(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>)
```

Set 8 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_9

```lua
function array.set_9(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>)
```

Set 9 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_10

```lua
function array.set_10(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>)
```

Set 10 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_11

```lua
function array.set_11(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>)
```

Set 11 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_12

```lua
function array.set_12(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>)
```

Set 12 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_13

```lua
function array.set_13(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>)
```

Set 13 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_14

```lua
function array.set_14(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>, v14: <T>)
```

Set 14 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_15

```lua
function array.set_15(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>, v14: <T>, v15: <T>)
```

Set 15 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## set_16

```lua
function array.set_16(dest: avm.seq<T>, dest_index: integer, v1: <T>, v2: <T>, v3: <T>, v4: <T>, v5: <T>, v6: <T>, v7: <T>, v8: <T>, v9: <T>, v10: <T>, v11: <T>, v12: <T>, v13: <T>, v14: <T>, v15: <T>, v16: <T>)
```

Set 16 values in a slice
```
dest[dest_index] = v1
...
dest[dest_index + n] = vn
```

## sub

```lua
function array.sub(a: avm.array<T>, b: avm.seq<T>)
  -> avm.array<number>
```

Apply the subtraction operator to two arrays

`{a[i]-b[i]}` for all `i` in `[1, #a]`

## sub_constant

```lua
function array.sub_constant(a: avm.array<T>, c: <T>|avm.array<T>)
  -> avm.array<number>
```

Apply the subtraction operator to each element of an array with a constant

`{a[i]-c}` for all `i` in `[1, #a]`

If `c` is an array its values are used in sequence across `a`

Example:
```lua
--Add a vector (x,y) to 2d-positions stored in a flat array
add_constant({1,2,3,4,...}, {x,y}) -- {1+x, 2+y, 3+x, 4+y}
```

## sub_constant_ex

```lua
function array.sub_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element of a slice with a constant and store the result in a destination

## sub_constant_ex

```lua
function array.sub_constant_ex(a: avm.seq<T>, a_index: integer, a_count: integer, c: <T>)
  -> avm.array<number>
```

Apply the subtraction operator to each element of a slice with a constant

## sub_ex

```lua
function array.sub_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> avm.array<number>
```

Apply the subtraction operator to two slices and return the result

## sub_ex

```lua
function array.sub_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two slices and store the result in a destination

## unpack_2

```lua
function array.unpack_2(src: avm.array<T>)
  -> <T>, <T>
```

Unpack 2 values from an array

## unpack_3

```lua
function array.unpack_3(src: avm.array<T>)
  -> <T>, <T>, <T>
```

Unpack 3 values from an array

## unpack_4

```lua
function array.unpack_4(src: avm.array<T>)
  -> <T> * 4
```

Unpack 4 values from an array

## unpack_5

```lua
function array.unpack_5(src: avm.array<T>)
  -> <T> * 5
```

Unpack 5 values from an array

## unpack_6

```lua
function array.unpack_6(src: avm.array<T>)
  -> <T> * 6
```

Unpack 6 values from an array

## unpack_7

```lua
function array.unpack_7(src: avm.array<T>)
  -> <T> * 7
```

Unpack 7 values from an array

## unpack_8

```lua
function array.unpack_8(src: avm.array<T>)
  -> <T> * 8
```

Unpack 8 values from an array

## unpack_9

```lua
function array.unpack_9(src: avm.array<T>)
  -> <T> * 9
```

Unpack 9 values from an array

## unpack_10

```lua
function array.unpack_10(src: avm.array<T>)
  -> <T> * 10
```

Unpack 10 values from an array

## unpack_11

```lua
function array.unpack_11(src: avm.array<T>)
  -> <T> * 11
```

Unpack 11 values from an array

## unpack_12

```lua
function array.unpack_12(src: avm.array<T>)
  -> <T> * 12
```

Unpack 12 values from an array

## unpack_13

```lua
function array.unpack_13(src: avm.array<T>)
  -> <T> * 13
```

Unpack 13 values from an array

## unpack_14

```lua
function array.unpack_14(src: avm.array<T>)
  -> <T> * 14
```

Unpack 14 values from an array

## unpack_15

```lua
function array.unpack_15(src: avm.array<T>)
  -> <T> * 15
```

Unpack 15 values from an array

## unpack_16

```lua
function array.unpack_16(src: avm.array<T>)
  -> <T> * 16
```

Unpack 16 values from an array

## zeros

```lua
function array.zeros(count: integer)
  -> avm.array<number>
```

create an array of zeros


---

# avm.matrix_2
2x2 matrix in column-major order constructed from a tuple

## __index

```lua
avm.matrix_2
```

2x2 matrix in column-major order constructed from a tuple


## __len

```lua
function avm.matrix_2.__len()
  -> integer
```

## __tostring

```lua
(method) avm.matrix_2:__tostring()
  -> string
```

## __unm

```lua
function avm.matrix_2.__unm(m: any)
```

## add

```lua
(method) avm.matrix_2:add(m: number|avm.number4)
  -> avm.matrix_2
```

Apply addition element-wise and return a new matrix_2

Parameter `m` can be a number or array

## add_into

```lua
(method) avm.matrix_2:add_into(m: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply addition element-wise and store the result in a destination

Parameter `m` can be a number or array

## copy

```lua
(method) avm.matrix_2:copy()
  -> avm.matrix_2
```

## copy_into

```lua
(method) avm.matrix_2:copy_into(dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

## div

```lua
(method) avm.matrix_2:div(m: number|avm.number4)
  -> avm.matrix_2
```

Apply division element-wise and return a new matrix_2

Parameter `m` can be a number or array

## div_into

```lua
(method) avm.matrix_2:div_into(m: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply division element-wise and store the result in a destination

Parameter `m` can be a number or array

## get

```lua
(method) avm.matrix_2:get()
  -> number * 4
```

Get values as a tuple

## matmul

```lua
(method) avm.matrix_2:matmul(m: avm.number4)
  -> avm.matrix_2
```

Multiply with a matrix and return the result

## matmul_into

```lua
(method) avm.matrix_2:matmul_into(m: avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Multiply with a matrix and store the result in a destination

## mul

```lua
(method) avm.matrix_2:mul(m: number|avm.number4)
  -> avm.matrix_2
```

Apply multiplication element-wise and return a new matrix_2

Parameter `m` can be a number or array

## mul_into

```lua
(method) avm.matrix_2:mul_into(m: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply multiplication element-wise and store the result in a destination

Parameter `m` can be a number or array

## set

```lua
(method) avm.matrix_2:set(e_11: number, e_12: number, e_21: number, e_22: number)
```

Set values from a tuple

Parameter `e_ij` determines the value of `i'th` column `j'th` row

## sub

```lua
(method) avm.matrix_2:sub(m: number|avm.number4)
  -> avm.matrix_2
```

Apply subtraction element-wise and return a new matrix_2

Parameter `m` can be a number or array

## sub_into

```lua
(method) avm.matrix_2:sub_into(m: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply subtraction element-wise and store the result in a destination

Parameter `m` can be a number or array


---

# avm.matrix_2_slice
A 2x2 matrix in column-major order that views into an array or slice


---

# avm.matrix_3
3x3 matrix in column-major order constructed from a tuple

## __index

```lua
avm.matrix_3
```

3x3 matrix in column-major order constructed from a tuple


## __len

```lua
function avm.matrix_3.__len()
  -> integer
```

## __tostring

```lua
(method) avm.matrix_3:__tostring()
  -> string
```

## __unm

```lua
function avm.matrix_3.__unm(m: any)
```

## add

```lua
(method) avm.matrix_3:add(m: number|avm.number9)
  -> avm.matrix_3
```

Apply addition element-wise and return a new matrix_3

Parameter `m` can be a number or array

## add_into

```lua
(method) avm.matrix_3:add_into(m: number|avm.number9, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
```

Apply addition element-wise and store the result in a destination

Parameter `m` can be a number or array

## copy

```lua
(method) avm.matrix_3:copy()
  -> avm.matrix_3
```

## copy_into

```lua
(method) avm.matrix_3:copy_into(dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
```

## div

```lua
(method) avm.matrix_3:div(m: number|avm.number9)
  -> avm.matrix_3
```

Apply division element-wise and return a new matrix_3

Parameter `m` can be a number or array

## div_into

```lua
(method) avm.matrix_3:div_into(m: number|avm.number9, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
```

Apply division element-wise and store the result in a destination

Parameter `m` can be a number or array

## get

```lua
(method) avm.matrix_3:get()
  -> number * 9
```

Get values as a tuple

## matmul

```lua
(method) avm.matrix_3:matmul(m: avm.number9)
  -> avm.matrix_3
```

Multiply with a matrix and return the result

## matmul_into

```lua
(method) avm.matrix_3:matmul_into(m: avm.number9, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
```

Multiply with a matrix and store the result in a destination

## mul

```lua
(method) avm.matrix_3:mul(m: number|avm.number9)
  -> avm.matrix_3
```

Apply multiplication element-wise and return a new matrix_3

Parameter `m` can be a number or array

## mul_into

```lua
(method) avm.matrix_3:mul_into(m: number|avm.number9, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
```

Apply multiplication element-wise and store the result in a destination

Parameter `m` can be a number or array

## set

```lua
(method) avm.matrix_3:set(e_11: number, e_12: number, e_13: number, e_21: number, e_22: number, e_23: number, e_31: number, e_32: number, e_33: number)
```

Set values from a tuple

Parameter `e_ij` determines the value of `i'th` column `j'th` row

## sub

```lua
(method) avm.matrix_3:sub(m: number|avm.number9)
  -> avm.matrix_3
```

Apply subtraction element-wise and return a new matrix_3

Parameter `m` can be a number or array

## sub_into

```lua
(method) avm.matrix_3:sub_into(m: number|avm.number9, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
```

Apply subtraction element-wise and store the result in a destination

Parameter `m` can be a number or array


---

# avm.matrix_3_slice
A 3x3 matrix in column-major order that views into an array or slice


---

# avm.matrix_4
4x4 matrix in column-major order constructed from a tuple

## __index

```lua
avm.matrix_4
```

4x4 matrix in column-major order constructed from a tuple


## __len

```lua
function avm.matrix_4.__len()
  -> integer
```

## __tostring

```lua
(method) avm.matrix_4:__tostring()
  -> string
```

## __unm

```lua
function avm.matrix_4.__unm(m: any)
```

## add

```lua
(method) avm.matrix_4:add(m: number|avm.number16)
  -> avm.matrix_4
```

Apply addition element-wise and return a new matrix_4

Parameter `m` can be a number or array

## add_into

```lua
(method) avm.matrix_4:add_into(m: number|avm.number16, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
```

Apply addition element-wise and store the result in a destination

Parameter `m` can be a number or array

## copy

```lua
(method) avm.matrix_4:copy()
  -> avm.matrix_4
```

## copy_into

```lua
(method) avm.matrix_4:copy_into(dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
```

## div

```lua
(method) avm.matrix_4:div(m: number|avm.number16)
  -> avm.matrix_4
```

Apply division element-wise and return a new matrix_4

Parameter `m` can be a number or array

## div_into

```lua
(method) avm.matrix_4:div_into(m: number|avm.number16, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
```

Apply division element-wise and store the result in a destination

Parameter `m` can be a number or array

## get

```lua
(method) avm.matrix_4:get()
  -> number * 16
```

Get values as a tuple

## matmul

```lua
(method) avm.matrix_4:matmul(m: avm.number16)
  -> avm.matrix_4
```

Multiply with a matrix and return the result

## matmul_into

```lua
(method) avm.matrix_4:matmul_into(m: avm.number16, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
```

Multiply with a matrix and store the result in a destination

## mul

```lua
(method) avm.matrix_4:mul(m: number|avm.number16)
  -> avm.matrix_4
```

Apply multiplication element-wise and return a new matrix_4

Parameter `m` can be a number or array

## mul_into

```lua
(method) avm.matrix_4:mul_into(m: number|avm.number16, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
```

Apply multiplication element-wise and store the result in a destination

Parameter `m` can be a number or array

## set

```lua
(method) avm.matrix_4:set(e_11: number, e_12: number, e_13: number, e_14: number, e_21: number, e_22: number, e_23: number, e_24: number, e_31: number, e_32: number, e_33: number, e_34: number, e_41: number, e_42: number, e_43: number, e_44: number)
```

Set values from a tuple

Parameter `e_ij` determines the value of `i'th` column `j'th` row

## sub

```lua
(method) avm.matrix_4:sub(m: number|avm.number16)
  -> avm.matrix_4
```

Apply subtraction element-wise and return a new matrix_4

Parameter `m` can be a number or array

## sub_into

```lua
(method) avm.matrix_4:sub_into(m: number|avm.number16, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
```

Apply subtraction element-wise and store the result in a destination

Parameter `m` can be a number or array


---

# avm.matrix_4_slice
A 4x4 matrix in column-major order that views into an array or slice


---

# avm.vector_2
2D vector constructed from a tuple

## __index

```lua
avm.vector_2
```

2D vector constructed from a tuple


## __len

```lua
function avm.vector_2.__len()
  -> integer
```

## __tostring

```lua
(method) avm.vector_2:__tostring()
  -> string
```

## __unm

```lua
function avm.vector_2.__unm(v: any)
```

## add

```lua
(method) avm.vector_2:add(v: number|avm.number2)
  -> avm.vector_2
```

Apply add element-wise and return a new vector_2

Parameter `v` can be a number or array

## add_into

```lua
(method) avm.vector_2:add_into(v: number|avm.number2, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
```

Apply add element-wise and store the result in dest

Parameter `v` can be a number or array

## copy

```lua
(method) avm.vector_2:copy()
  -> avm.vector_2
```

## copy_into

```lua
(method) avm.vector_2:copy_into(dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
```

## div

```lua
(method) avm.vector_2:div(v: number|avm.number2)
  -> avm.vector_2
```

Apply div element-wise and return a new vector_2

Parameter `v` can be a number or array

## div_into

```lua
(method) avm.vector_2:div_into(v: number|avm.number2, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
```

Apply div element-wise and store the result in dest

Parameter `v` can be a number or array

## get

```lua
(method) avm.vector_2:get()
  -> number, number
```

Get values as a tuple

## mul

```lua
(method) avm.vector_2:mul(v: number|avm.number2)
  -> avm.vector_2
```

Apply mul element-wise and return a new vector_2

Parameter `v` can be a number or array

## mul_into

```lua
(method) avm.vector_2:mul_into(v: number|avm.number2, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
```

Apply mul element-wise and store the result in dest

Parameter `v` can be a number or array

## set

```lua
(method) avm.vector_2:set(v1: number, v2: number)
```

Set values from a tuple

## set_x

```lua
(method) avm.vector_2:set_x(v1: number)
```

Set elements of the vector

## set_xy

```lua
(method) avm.vector_2:set_xy(v1: number, v2: number)
```

Set elements of the vector

## set_y

```lua
(method) avm.vector_2:set_y(v1: number)
```

Set elements of the vector

## set_yx

```lua
(method) avm.vector_2:set_yx(v1: number, v2: number)
```

Set elements of the vector

## sub

```lua
(method) avm.vector_2:sub(v: number|avm.number2)
  -> avm.vector_2
```

Apply sub element-wise and return a new vector_2

Parameter `v` can be a number or array

## sub_into

```lua
(method) avm.vector_2:sub_into(v: number|avm.number2, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
```

Apply sub element-wise and store the result in dest

Parameter `v` can be a number or array

## x

```lua
(method) avm.vector_2:x()
  -> number
```

Get elements of the vector

## xx

```lua
(method) avm.vector_2:xx()
  -> number, number
```

Get elements of the vector

## xy

```lua
(method) avm.vector_2:xy()
  -> number, number
```

Get elements of the vector

## y

```lua
(method) avm.vector_2:y()
  -> number
```

Get elements of the vector

## yx

```lua
(method) avm.vector_2:yx()
  -> number, number
```

Get elements of the vector

## yy

```lua
(method) avm.vector_2:yy()
  -> number, number
```

Get elements of the vector


---

# avm.vector_3
3D vector constructed from a tuple

## __index

```lua
avm.vector_3
```

3D vector constructed from a tuple


## __len

```lua
function avm.vector_3.__len()
  -> integer
```

## __tostring

```lua
(method) avm.vector_3:__tostring()
  -> string
```

## __unm

```lua
function avm.vector_3.__unm(v: any)
```

## add

```lua
(method) avm.vector_3:add(v: number|avm.number3)
  -> avm.vector_3
```

Apply add element-wise and return a new vector_3

Parameter `v` can be a number or array

## add_into

```lua
(method) avm.vector_3:add_into(v: number|avm.number3, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
```

Apply add element-wise and store the result in dest

Parameter `v` can be a number or array

## copy

```lua
(method) avm.vector_3:copy()
  -> avm.vector_3
```

## copy_into

```lua
(method) avm.vector_3:copy_into(dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
```

## div

```lua
(method) avm.vector_3:div(v: number|avm.number3)
  -> avm.vector_3
```

Apply div element-wise and return a new vector_3

Parameter `v` can be a number or array

## div_into

```lua
(method) avm.vector_3:div_into(v: number|avm.number3, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
```

Apply div element-wise and store the result in dest

Parameter `v` can be a number or array

## get

```lua
(method) avm.vector_3:get()
  -> number, number, number
```

Get values as a tuple

## mul

```lua
(method) avm.vector_3:mul(v: number|avm.number3)
  -> avm.vector_3
```

Apply mul element-wise and return a new vector_3

Parameter `v` can be a number or array

## mul_into

```lua
(method) avm.vector_3:mul_into(v: number|avm.number3, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
```

Apply mul element-wise and store the result in dest

Parameter `v` can be a number or array

## set

```lua
(method) avm.vector_3:set(v1: number, v2: number, v3: number)
```

Set values from a tuple

## set_x

```lua
(method) avm.vector_3:set_x(v1: number)
```

Set elements of the vector

## set_xy

```lua
(method) avm.vector_3:set_xy(v1: number, v2: number)
```

Set elements of the vector

## set_xyz

```lua
(method) avm.vector_3:set_xyz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xz

```lua
(method) avm.vector_3:set_xz(v1: number, v2: number)
```

Set elements of the vector

## set_xzy

```lua
(method) avm.vector_3:set_xzy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_y

```lua
(method) avm.vector_3:set_y(v1: number)
```

Set elements of the vector

## set_yx

```lua
(method) avm.vector_3:set_yx(v1: number, v2: number)
```

Set elements of the vector

## set_yxz

```lua
(method) avm.vector_3:set_yxz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_yz

```lua
(method) avm.vector_3:set_yz(v1: number, v2: number)
```

Set elements of the vector

## set_yzx

```lua
(method) avm.vector_3:set_yzx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_z

```lua
(method) avm.vector_3:set_z(v1: number)
```

Set elements of the vector

## set_zx

```lua
(method) avm.vector_3:set_zx(v1: number, v2: number)
```

Set elements of the vector

## set_zxy

```lua
(method) avm.vector_3:set_zxy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zy

```lua
(method) avm.vector_3:set_zy(v1: number, v2: number)
```

Set elements of the vector

## set_zyx

```lua
(method) avm.vector_3:set_zyx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## sub

```lua
(method) avm.vector_3:sub(v: number|avm.number3)
  -> avm.vector_3
```

Apply sub element-wise and return a new vector_3

Parameter `v` can be a number or array

## sub_into

```lua
(method) avm.vector_3:sub_into(v: number|avm.number3, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
```

Apply sub element-wise and store the result in dest

Parameter `v` can be a number or array

## x

```lua
(method) avm.vector_3:x()
  -> number
```

Get elements of the vector

## xx

```lua
(method) avm.vector_3:xx()
  -> number, number
```

Get elements of the vector

## xxx

```lua
(method) avm.vector_3:xxx()
  -> number, number, number
```

Get elements of the vector

## xxy

```lua
(method) avm.vector_3:xxy()
  -> number, number, number
```

Get elements of the vector

## xxz

```lua
(method) avm.vector_3:xxz()
  -> number, number, number
```

Get elements of the vector

## xy

```lua
(method) avm.vector_3:xy()
  -> number, number
```

Get elements of the vector

## xyx

```lua
(method) avm.vector_3:xyx()
  -> number, number, number
```

Get elements of the vector

## xyy

```lua
(method) avm.vector_3:xyy()
  -> number, number, number
```

Get elements of the vector

## xyz

```lua
(method) avm.vector_3:xyz()
  -> number, number, number
```

Get elements of the vector

## xz

```lua
(method) avm.vector_3:xz()
  -> number, number
```

Get elements of the vector

## xzx

```lua
(method) avm.vector_3:xzx()
  -> number, number, number
```

Get elements of the vector

## xzy

```lua
(method) avm.vector_3:xzy()
  -> number, number, number
```

Get elements of the vector

## xzz

```lua
(method) avm.vector_3:xzz()
  -> number, number, number
```

Get elements of the vector

## y

```lua
(method) avm.vector_3:y()
  -> number
```

Get elements of the vector

## yx

```lua
(method) avm.vector_3:yx()
  -> number, number
```

Get elements of the vector

## yxx

```lua
(method) avm.vector_3:yxx()
  -> number, number, number
```

Get elements of the vector

## yxy

```lua
(method) avm.vector_3:yxy()
  -> number, number, number
```

Get elements of the vector

## yxz

```lua
(method) avm.vector_3:yxz()
  -> number, number, number
```

Get elements of the vector

## yy

```lua
(method) avm.vector_3:yy()
  -> number, number
```

Get elements of the vector

## yyx

```lua
(method) avm.vector_3:yyx()
  -> number, number, number
```

Get elements of the vector

## yyy

```lua
(method) avm.vector_3:yyy()
  -> number, number, number
```

Get elements of the vector

## yyz

```lua
(method) avm.vector_3:yyz()
  -> number, number, number
```

Get elements of the vector

## yz

```lua
(method) avm.vector_3:yz()
  -> number, number
```

Get elements of the vector

## yzx

```lua
(method) avm.vector_3:yzx()
  -> number, number, number
```

Get elements of the vector

## yzy

```lua
(method) avm.vector_3:yzy()
  -> number, number, number
```

Get elements of the vector

## yzz

```lua
(method) avm.vector_3:yzz()
  -> number, number, number
```

Get elements of the vector

## z

```lua
(method) avm.vector_3:z()
  -> number
```

Get elements of the vector

## zx

```lua
(method) avm.vector_3:zx()
  -> number, number
```

Get elements of the vector

## zxx

```lua
(method) avm.vector_3:zxx()
  -> number, number, number
```

Get elements of the vector

## zxy

```lua
(method) avm.vector_3:zxy()
  -> number, number, number
```

Get elements of the vector

## zxz

```lua
(method) avm.vector_3:zxz()
  -> number, number, number
```

Get elements of the vector

## zy

```lua
(method) avm.vector_3:zy()
  -> number, number
```

Get elements of the vector

## zyx

```lua
(method) avm.vector_3:zyx()
  -> number, number, number
```

Get elements of the vector

## zyy

```lua
(method) avm.vector_3:zyy()
  -> number, number, number
```

Get elements of the vector

## zyz

```lua
(method) avm.vector_3:zyz()
  -> number, number, number
```

Get elements of the vector

## zz

```lua
(method) avm.vector_3:zz()
  -> number, number
```

Get elements of the vector

## zzx

```lua
(method) avm.vector_3:zzx()
  -> number, number, number
```

Get elements of the vector

## zzy

```lua
(method) avm.vector_3:zzy()
  -> number, number, number
```

Get elements of the vector

## zzz

```lua
(method) avm.vector_3:zzz()
  -> number, number, number
```

Get elements of the vector


---

# avm.vector_4
4D vector constructed from a tuple

## __index

```lua
avm.vector_4
```

4D vector constructed from a tuple


## __len

```lua
function avm.vector_4.__len()
  -> integer
```

## __tostring

```lua
(method) avm.vector_4:__tostring()
  -> string
```

## __unm

```lua
function avm.vector_4.__unm(v: any)
```

## add

```lua
(method) avm.vector_4:add(v: number|avm.number4)
  -> avm.vector_4
```

Apply add element-wise and return a new vector_4

Parameter `v` can be a number or array

## add_into

```lua
(method) avm.vector_4:add_into(v: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply add element-wise and store the result in dest

Parameter `v` can be a number or array

## copy

```lua
(method) avm.vector_4:copy()
  -> avm.vector_4
```

## copy_into

```lua
(method) avm.vector_4:copy_into(dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

## div

```lua
(method) avm.vector_4:div(v: number|avm.number4)
  -> avm.vector_4
```

Apply div element-wise and return a new vector_4

Parameter `v` can be a number or array

## div_into

```lua
(method) avm.vector_4:div_into(v: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply div element-wise and store the result in dest

Parameter `v` can be a number or array

## get

```lua
(method) avm.vector_4:get()
  -> number * 4
```

Get values as a tuple

## mul

```lua
(method) avm.vector_4:mul(v: number|avm.number4)
  -> avm.vector_4
```

Apply mul element-wise and return a new vector_4

Parameter `v` can be a number or array

## mul_into

```lua
(method) avm.vector_4:mul_into(v: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply mul element-wise and store the result in dest

Parameter `v` can be a number or array

## set

```lua
(method) avm.vector_4:set(v1: number, v2: number, v3: number, v4: number)
```

Set values from a tuple

## set_w

```lua
(method) avm.vector_4:set_w(v1: number)
```

Set elements of the vector

## set_wx

```lua
(method) avm.vector_4:set_wx(v1: number, v2: number)
```

Set elements of the vector

## set_wxy

```lua
(method) avm.vector_4:set_wxy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_wxyz

```lua
(method) avm.vector_4:set_wxyz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_wxz

```lua
(method) avm.vector_4:set_wxz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_wxzy

```lua
(method) avm.vector_4:set_wxzy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_wy

```lua
(method) avm.vector_4:set_wy(v1: number, v2: number)
```

Set elements of the vector

## set_wyx

```lua
(method) avm.vector_4:set_wyx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_wyxz

```lua
(method) avm.vector_4:set_wyxz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_wyz

```lua
(method) avm.vector_4:set_wyz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_wyzx

```lua
(method) avm.vector_4:set_wyzx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_wz

```lua
(method) avm.vector_4:set_wz(v1: number, v2: number)
```

Set elements of the vector

## set_wzx

```lua
(method) avm.vector_4:set_wzx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_wzxy

```lua
(method) avm.vector_4:set_wzxy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_wzy

```lua
(method) avm.vector_4:set_wzy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_wzyx

```lua
(method) avm.vector_4:set_wzyx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_x

```lua
(method) avm.vector_4:set_x(v1: number)
```

Set elements of the vector

## set_xw

```lua
(method) avm.vector_4:set_xw(v1: number, v2: number)
```

Set elements of the vector

## set_xwy

```lua
(method) avm.vector_4:set_xwy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xwyz

```lua
(method) avm.vector_4:set_xwyz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_xwz

```lua
(method) avm.vector_4:set_xwz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xwzy

```lua
(method) avm.vector_4:set_xwzy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_xy

```lua
(method) avm.vector_4:set_xy(v1: number, v2: number)
```

Set elements of the vector

## set_xyw

```lua
(method) avm.vector_4:set_xyw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xywz

```lua
(method) avm.vector_4:set_xywz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_xyz

```lua
(method) avm.vector_4:set_xyz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xyzw

```lua
(method) avm.vector_4:set_xyzw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_xz

```lua
(method) avm.vector_4:set_xz(v1: number, v2: number)
```

Set elements of the vector

## set_xzw

```lua
(method) avm.vector_4:set_xzw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xzwy

```lua
(method) avm.vector_4:set_xzwy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_xzy

```lua
(method) avm.vector_4:set_xzy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_xzyw

```lua
(method) avm.vector_4:set_xzyw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_y

```lua
(method) avm.vector_4:set_y(v1: number)
```

Set elements of the vector

## set_yw

```lua
(method) avm.vector_4:set_yw(v1: number, v2: number)
```

Set elements of the vector

## set_ywx

```lua
(method) avm.vector_4:set_ywx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_ywxz

```lua
(method) avm.vector_4:set_ywxz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_ywz

```lua
(method) avm.vector_4:set_ywz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_ywzx

```lua
(method) avm.vector_4:set_ywzx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_yx

```lua
(method) avm.vector_4:set_yx(v1: number, v2: number)
```

Set elements of the vector

## set_yxw

```lua
(method) avm.vector_4:set_yxw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_yxwz

```lua
(method) avm.vector_4:set_yxwz(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_yxz

```lua
(method) avm.vector_4:set_yxz(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_yxzw

```lua
(method) avm.vector_4:set_yxzw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_yz

```lua
(method) avm.vector_4:set_yz(v1: number, v2: number)
```

Set elements of the vector

## set_yzw

```lua
(method) avm.vector_4:set_yzw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_yzwx

```lua
(method) avm.vector_4:set_yzwx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_yzx

```lua
(method) avm.vector_4:set_yzx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_yzxw

```lua
(method) avm.vector_4:set_yzxw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_z

```lua
(method) avm.vector_4:set_z(v1: number)
```

Set elements of the vector

## set_zw

```lua
(method) avm.vector_4:set_zw(v1: number, v2: number)
```

Set elements of the vector

## set_zwx

```lua
(method) avm.vector_4:set_zwx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zwxy

```lua
(method) avm.vector_4:set_zwxy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_zwy

```lua
(method) avm.vector_4:set_zwy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zwyx

```lua
(method) avm.vector_4:set_zwyx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_zx

```lua
(method) avm.vector_4:set_zx(v1: number, v2: number)
```

Set elements of the vector

## set_zxw

```lua
(method) avm.vector_4:set_zxw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zxwy

```lua
(method) avm.vector_4:set_zxwy(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_zxy

```lua
(method) avm.vector_4:set_zxy(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zxyw

```lua
(method) avm.vector_4:set_zxyw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_zy

```lua
(method) avm.vector_4:set_zy(v1: number, v2: number)
```

Set elements of the vector

## set_zyw

```lua
(method) avm.vector_4:set_zyw(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zywx

```lua
(method) avm.vector_4:set_zywx(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## set_zyx

```lua
(method) avm.vector_4:set_zyx(v1: number, v2: number, v3: number)
```

Set elements of the vector

## set_zyxw

```lua
(method) avm.vector_4:set_zyxw(v1: number, v2: number, v3: number, v4: number)
```

Set elements of the vector

## sub

```lua
(method) avm.vector_4:sub(v: number|avm.number4)
  -> avm.vector_4
```

Apply sub element-wise and return a new vector_4

Parameter `v` can be a number or array

## sub_into

```lua
(method) avm.vector_4:sub_into(v: number|avm.number4, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
```

Apply sub element-wise and store the result in dest

Parameter `v` can be a number or array

## w

```lua
(method) avm.vector_4:w()
  -> number
```

Get elements of the vector

## ww

```lua
(method) avm.vector_4:ww()
  -> number, number
```

Get elements of the vector

## www

```lua
(method) avm.vector_4:www()
  -> number, number, number
```

Get elements of the vector

## wwww

```lua
(method) avm.vector_4:wwww()
  -> number * 4
```

Get elements of the vector

## wwwx

```lua
(method) avm.vector_4:wwwx()
  -> number * 4
```

Get elements of the vector

## wwwy

```lua
(method) avm.vector_4:wwwy()
  -> number * 4
```

Get elements of the vector

## wwwz

```lua
(method) avm.vector_4:wwwz()
  -> number * 4
```

Get elements of the vector

## wwx

```lua
(method) avm.vector_4:wwx()
  -> number, number, number
```

Get elements of the vector

## wwxw

```lua
(method) avm.vector_4:wwxw()
  -> number * 4
```

Get elements of the vector

## wwxx

```lua
(method) avm.vector_4:wwxx()
  -> number * 4
```

Get elements of the vector

## wwxy

```lua
(method) avm.vector_4:wwxy()
  -> number * 4
```

Get elements of the vector

## wwxz

```lua
(method) avm.vector_4:wwxz()
  -> number * 4
```

Get elements of the vector

## wwy

```lua
(method) avm.vector_4:wwy()
  -> number, number, number
```

Get elements of the vector

## wwyw

```lua
(method) avm.vector_4:wwyw()
  -> number * 4
```

Get elements of the vector

## wwyx

```lua
(method) avm.vector_4:wwyx()
  -> number * 4
```

Get elements of the vector

## wwyy

```lua
(method) avm.vector_4:wwyy()
  -> number * 4
```

Get elements of the vector

## wwyz

```lua
(method) avm.vector_4:wwyz()
  -> number * 4
```

Get elements of the vector

## wwz

```lua
(method) avm.vector_4:wwz()
  -> number, number, number
```

Get elements of the vector

## wwzw

```lua
(method) avm.vector_4:wwzw()
  -> number * 4
```

Get elements of the vector

## wwzx

```lua
(method) avm.vector_4:wwzx()
  -> number * 4
```

Get elements of the vector

## wwzy

```lua
(method) avm.vector_4:wwzy()
  -> number * 4
```

Get elements of the vector

## wwzz

```lua
(method) avm.vector_4:wwzz()
  -> number * 4
```

Get elements of the vector

## wx

```lua
(method) avm.vector_4:wx()
  -> number, number
```

Get elements of the vector

## wxw

```lua
(method) avm.vector_4:wxw()
  -> number, number, number
```

Get elements of the vector

## wxww

```lua
(method) avm.vector_4:wxww()
  -> number * 4
```

Get elements of the vector

## wxwx

```lua
(method) avm.vector_4:wxwx()
  -> number * 4
```

Get elements of the vector

## wxwy

```lua
(method) avm.vector_4:wxwy()
  -> number * 4
```

Get elements of the vector

## wxwz

```lua
(method) avm.vector_4:wxwz()
  -> number * 4
```

Get elements of the vector

## wxx

```lua
(method) avm.vector_4:wxx()
  -> number, number, number
```

Get elements of the vector

## wxxw

```lua
(method) avm.vector_4:wxxw()
  -> number * 4
```

Get elements of the vector

## wxxx

```lua
(method) avm.vector_4:wxxx()
  -> number * 4
```

Get elements of the vector

## wxxy

```lua
(method) avm.vector_4:wxxy()
  -> number * 4
```

Get elements of the vector

## wxxz

```lua
(method) avm.vector_4:wxxz()
  -> number * 4
```

Get elements of the vector

## wxy

```lua
(method) avm.vector_4:wxy()
  -> number, number, number
```

Get elements of the vector

## wxyw

```lua
(method) avm.vector_4:wxyw()
  -> number * 4
```

Get elements of the vector

## wxyx

```lua
(method) avm.vector_4:wxyx()
  -> number * 4
```

Get elements of the vector

## wxyy

```lua
(method) avm.vector_4:wxyy()
  -> number * 4
```

Get elements of the vector

## wxyz

```lua
(method) avm.vector_4:wxyz()
  -> number * 4
```

Get elements of the vector

## wxz

```lua
(method) avm.vector_4:wxz()
  -> number, number, number
```

Get elements of the vector

## wxzw

```lua
(method) avm.vector_4:wxzw()
  -> number * 4
```

Get elements of the vector

## wxzx

```lua
(method) avm.vector_4:wxzx()
  -> number * 4
```

Get elements of the vector

## wxzy

```lua
(method) avm.vector_4:wxzy()
  -> number * 4
```

Get elements of the vector

## wxzz

```lua
(method) avm.vector_4:wxzz()
  -> number * 4
```

Get elements of the vector

## wy

```lua
(method) avm.vector_4:wy()
  -> number, number
```

Get elements of the vector

## wyw

```lua
(method) avm.vector_4:wyw()
  -> number, number, number
```

Get elements of the vector

## wyww

```lua
(method) avm.vector_4:wyww()
  -> number * 4
```

Get elements of the vector

## wywx

```lua
(method) avm.vector_4:wywx()
  -> number * 4
```

Get elements of the vector

## wywy

```lua
(method) avm.vector_4:wywy()
  -> number * 4
```

Get elements of the vector

## wywz

```lua
(method) avm.vector_4:wywz()
  -> number * 4
```

Get elements of the vector

## wyx

```lua
(method) avm.vector_4:wyx()
  -> number, number, number
```

Get elements of the vector

## wyxw

```lua
(method) avm.vector_4:wyxw()
  -> number * 4
```

Get elements of the vector

## wyxx

```lua
(method) avm.vector_4:wyxx()
  -> number * 4
```

Get elements of the vector

## wyxy

```lua
(method) avm.vector_4:wyxy()
  -> number * 4
```

Get elements of the vector

## wyxz

```lua
(method) avm.vector_4:wyxz()
  -> number * 4
```

Get elements of the vector

## wyy

```lua
(method) avm.vector_4:wyy()
  -> number, number, number
```

Get elements of the vector

## wyyw

```lua
(method) avm.vector_4:wyyw()
  -> number * 4
```

Get elements of the vector

## wyyx

```lua
(method) avm.vector_4:wyyx()
  -> number * 4
```

Get elements of the vector

## wyyy

```lua
(method) avm.vector_4:wyyy()
  -> number * 4
```

Get elements of the vector

## wyyz

```lua
(method) avm.vector_4:wyyz()
  -> number * 4
```

Get elements of the vector

## wyz

```lua
(method) avm.vector_4:wyz()
  -> number, number, number
```

Get elements of the vector

## wyzw

```lua
(method) avm.vector_4:wyzw()
  -> number * 4
```

Get elements of the vector

## wyzx

```lua
(method) avm.vector_4:wyzx()
  -> number * 4
```

Get elements of the vector

## wyzy

```lua
(method) avm.vector_4:wyzy()
  -> number * 4
```

Get elements of the vector

## wyzz

```lua
(method) avm.vector_4:wyzz()
  -> number * 4
```

Get elements of the vector

## wz

```lua
(method) avm.vector_4:wz()
  -> number, number
```

Get elements of the vector

## wzw

```lua
(method) avm.vector_4:wzw()
  -> number, number, number
```

Get elements of the vector

## wzww

```lua
(method) avm.vector_4:wzww()
  -> number * 4
```

Get elements of the vector

## wzwx

```lua
(method) avm.vector_4:wzwx()
  -> number * 4
```

Get elements of the vector

## wzwy

```lua
(method) avm.vector_4:wzwy()
  -> number * 4
```

Get elements of the vector

## wzwz

```lua
(method) avm.vector_4:wzwz()
  -> number * 4
```

Get elements of the vector

## wzx

```lua
(method) avm.vector_4:wzx()
  -> number, number, number
```

Get elements of the vector

## wzxw

```lua
(method) avm.vector_4:wzxw()
  -> number * 4
```

Get elements of the vector

## wzxx

```lua
(method) avm.vector_4:wzxx()
  -> number * 4
```

Get elements of the vector

## wzxy

```lua
(method) avm.vector_4:wzxy()
  -> number * 4
```

Get elements of the vector

## wzxz

```lua
(method) avm.vector_4:wzxz()
  -> number * 4
```

Get elements of the vector

## wzy

```lua
(method) avm.vector_4:wzy()
  -> number, number, number
```

Get elements of the vector

## wzyw

```lua
(method) avm.vector_4:wzyw()
  -> number * 4
```

Get elements of the vector

## wzyx

```lua
(method) avm.vector_4:wzyx()
  -> number * 4
```

Get elements of the vector

## wzyy

```lua
(method) avm.vector_4:wzyy()
  -> number * 4
```

Get elements of the vector

## wzyz

```lua
(method) avm.vector_4:wzyz()
  -> number * 4
```

Get elements of the vector

## wzz

```lua
(method) avm.vector_4:wzz()
  -> number, number, number
```

Get elements of the vector

## wzzw

```lua
(method) avm.vector_4:wzzw()
  -> number * 4
```

Get elements of the vector

## wzzx

```lua
(method) avm.vector_4:wzzx()
  -> number * 4
```

Get elements of the vector

## wzzy

```lua
(method) avm.vector_4:wzzy()
  -> number * 4
```

Get elements of the vector

## wzzz

```lua
(method) avm.vector_4:wzzz()
  -> number * 4
```

Get elements of the vector

## x

```lua
(method) avm.vector_4:x()
  -> number
```

Get elements of the vector

## xw

```lua
(method) avm.vector_4:xw()
  -> number, number
```

Get elements of the vector

## xww

```lua
(method) avm.vector_4:xww()
  -> number, number, number
```

Get elements of the vector

## xwww

```lua
(method) avm.vector_4:xwww()
  -> number * 4
```

Get elements of the vector

## xwwx

```lua
(method) avm.vector_4:xwwx()
  -> number * 4
```

Get elements of the vector

## xwwy

```lua
(method) avm.vector_4:xwwy()
  -> number * 4
```

Get elements of the vector

## xwwz

```lua
(method) avm.vector_4:xwwz()
  -> number * 4
```

Get elements of the vector

## xwx

```lua
(method) avm.vector_4:xwx()
  -> number, number, number
```

Get elements of the vector

## xwxw

```lua
(method) avm.vector_4:xwxw()
  -> number * 4
```

Get elements of the vector

## xwxx

```lua
(method) avm.vector_4:xwxx()
  -> number * 4
```

Get elements of the vector

## xwxy

```lua
(method) avm.vector_4:xwxy()
  -> number * 4
```

Get elements of the vector

## xwxz

```lua
(method) avm.vector_4:xwxz()
  -> number * 4
```

Get elements of the vector

## xwy

```lua
(method) avm.vector_4:xwy()
  -> number, number, number
```

Get elements of the vector

## xwyw

```lua
(method) avm.vector_4:xwyw()
  -> number * 4
```

Get elements of the vector

## xwyx

```lua
(method) avm.vector_4:xwyx()
  -> number * 4
```

Get elements of the vector

## xwyy

```lua
(method) avm.vector_4:xwyy()
  -> number * 4
```

Get elements of the vector

## xwyz

```lua
(method) avm.vector_4:xwyz()
  -> number * 4
```

Get elements of the vector

## xwz

```lua
(method) avm.vector_4:xwz()
  -> number, number, number
```

Get elements of the vector

## xwzw

```lua
(method) avm.vector_4:xwzw()
  -> number * 4
```

Get elements of the vector

## xwzx

```lua
(method) avm.vector_4:xwzx()
  -> number * 4
```

Get elements of the vector

## xwzy

```lua
(method) avm.vector_4:xwzy()
  -> number * 4
```

Get elements of the vector

## xwzz

```lua
(method) avm.vector_4:xwzz()
  -> number * 4
```

Get elements of the vector

## xx

```lua
(method) avm.vector_4:xx()
  -> number, number
```

Get elements of the vector

## xxw

```lua
(method) avm.vector_4:xxw()
  -> number, number, number
```

Get elements of the vector

## xxww

```lua
(method) avm.vector_4:xxww()
  -> number * 4
```

Get elements of the vector

## xxwx

```lua
(method) avm.vector_4:xxwx()
  -> number * 4
```

Get elements of the vector

## xxwy

```lua
(method) avm.vector_4:xxwy()
  -> number * 4
```

Get elements of the vector

## xxwz

```lua
(method) avm.vector_4:xxwz()
  -> number * 4
```

Get elements of the vector

## xxx

```lua
(method) avm.vector_4:xxx()
  -> number, number, number
```

Get elements of the vector

## xxxw

```lua
(method) avm.vector_4:xxxw()
  -> number * 4
```

Get elements of the vector

## xxxx

```lua
(method) avm.vector_4:xxxx()
  -> number * 4
```

Get elements of the vector

## xxxy

```lua
(method) avm.vector_4:xxxy()
  -> number * 4
```

Get elements of the vector

## xxxz

```lua
(method) avm.vector_4:xxxz()
  -> number * 4
```

Get elements of the vector

## xxy

```lua
(method) avm.vector_4:xxy()
  -> number, number, number
```

Get elements of the vector

## xxyw

```lua
(method) avm.vector_4:xxyw()
  -> number * 4
```

Get elements of the vector

## xxyx

```lua
(method) avm.vector_4:xxyx()
  -> number * 4
```

Get elements of the vector

## xxyy

```lua
(method) avm.vector_4:xxyy()
  -> number * 4
```

Get elements of the vector

## xxyz

```lua
(method) avm.vector_4:xxyz()
  -> number * 4
```

Get elements of the vector

## xxz

```lua
(method) avm.vector_4:xxz()
  -> number, number, number
```

Get elements of the vector

## xxzw

```lua
(method) avm.vector_4:xxzw()
  -> number * 4
```

Get elements of the vector

## xxzx

```lua
(method) avm.vector_4:xxzx()
  -> number * 4
```

Get elements of the vector

## xxzy

```lua
(method) avm.vector_4:xxzy()
  -> number * 4
```

Get elements of the vector

## xxzz

```lua
(method) avm.vector_4:xxzz()
  -> number * 4
```

Get elements of the vector

## xy

```lua
(method) avm.vector_4:xy()
  -> number, number
```

Get elements of the vector

## xyw

```lua
(method) avm.vector_4:xyw()
  -> number, number, number
```

Get elements of the vector

## xyww

```lua
(method) avm.vector_4:xyww()
  -> number * 4
```

Get elements of the vector

## xywx

```lua
(method) avm.vector_4:xywx()
  -> number * 4
```

Get elements of the vector

## xywy

```lua
(method) avm.vector_4:xywy()
  -> number * 4
```

Get elements of the vector

## xywz

```lua
(method) avm.vector_4:xywz()
  -> number * 4
```

Get elements of the vector

## xyx

```lua
(method) avm.vector_4:xyx()
  -> number, number, number
```

Get elements of the vector

## xyxw

```lua
(method) avm.vector_4:xyxw()
  -> number * 4
```

Get elements of the vector

## xyxx

```lua
(method) avm.vector_4:xyxx()
  -> number * 4
```

Get elements of the vector

## xyxy

```lua
(method) avm.vector_4:xyxy()
  -> number * 4
```

Get elements of the vector

## xyxz

```lua
(method) avm.vector_4:xyxz()
  -> number * 4
```

Get elements of the vector

## xyy

```lua
(method) avm.vector_4:xyy()
  -> number, number, number
```

Get elements of the vector

## xyyw

```lua
(method) avm.vector_4:xyyw()
  -> number * 4
```

Get elements of the vector

## xyyx

```lua
(method) avm.vector_4:xyyx()
  -> number * 4
```

Get elements of the vector

## xyyy

```lua
(method) avm.vector_4:xyyy()
  -> number * 4
```

Get elements of the vector

## xyyz

```lua
(method) avm.vector_4:xyyz()
  -> number * 4
```

Get elements of the vector

## xyz

```lua
(method) avm.vector_4:xyz()
  -> number, number, number
```

Get elements of the vector

## xyzw

```lua
(method) avm.vector_4:xyzw()
  -> number * 4
```

Get elements of the vector

## xyzx

```lua
(method) avm.vector_4:xyzx()
  -> number * 4
```

Get elements of the vector

## xyzy

```lua
(method) avm.vector_4:xyzy()
  -> number * 4
```

Get elements of the vector

## xyzz

```lua
(method) avm.vector_4:xyzz()
  -> number * 4
```

Get elements of the vector

## xz

```lua
(method) avm.vector_4:xz()
  -> number, number
```

Get elements of the vector

## xzw

```lua
(method) avm.vector_4:xzw()
  -> number, number, number
```

Get elements of the vector

## xzww

```lua
(method) avm.vector_4:xzww()
  -> number * 4
```

Get elements of the vector

## xzwx

```lua
(method) avm.vector_4:xzwx()
  -> number * 4
```

Get elements of the vector

## xzwy

```lua
(method) avm.vector_4:xzwy()
  -> number * 4
```

Get elements of the vector

## xzwz

```lua
(method) avm.vector_4:xzwz()
  -> number * 4
```

Get elements of the vector

## xzx

```lua
(method) avm.vector_4:xzx()
  -> number, number, number
```

Get elements of the vector

## xzxw

```lua
(method) avm.vector_4:xzxw()
  -> number * 4
```

Get elements of the vector

## xzxx

```lua
(method) avm.vector_4:xzxx()
  -> number * 4
```

Get elements of the vector

## xzxy

```lua
(method) avm.vector_4:xzxy()
  -> number * 4
```

Get elements of the vector

## xzxz

```lua
(method) avm.vector_4:xzxz()
  -> number * 4
```

Get elements of the vector

## xzy

```lua
(method) avm.vector_4:xzy()
  -> number, number, number
```

Get elements of the vector

## xzyw

```lua
(method) avm.vector_4:xzyw()
  -> number * 4
```

Get elements of the vector

## xzyx

```lua
(method) avm.vector_4:xzyx()
  -> number * 4
```

Get elements of the vector

## xzyy

```lua
(method) avm.vector_4:xzyy()
  -> number * 4
```

Get elements of the vector

## xzyz

```lua
(method) avm.vector_4:xzyz()
  -> number * 4
```

Get elements of the vector

## xzz

```lua
(method) avm.vector_4:xzz()
  -> number, number, number
```

Get elements of the vector

## xzzw

```lua
(method) avm.vector_4:xzzw()
  -> number * 4
```

Get elements of the vector

## xzzx

```lua
(method) avm.vector_4:xzzx()
  -> number * 4
```

Get elements of the vector

## xzzy

```lua
(method) avm.vector_4:xzzy()
  -> number * 4
```

Get elements of the vector

## xzzz

```lua
(method) avm.vector_4:xzzz()
  -> number * 4
```

Get elements of the vector

## y

```lua
(method) avm.vector_4:y()
  -> number
```

Get elements of the vector

## yw

```lua
(method) avm.vector_4:yw()
  -> number, number
```

Get elements of the vector

## yww

```lua
(method) avm.vector_4:yww()
  -> number, number, number
```

Get elements of the vector

## ywww

```lua
(method) avm.vector_4:ywww()
  -> number * 4
```

Get elements of the vector

## ywwx

```lua
(method) avm.vector_4:ywwx()
  -> number * 4
```

Get elements of the vector

## ywwy

```lua
(method) avm.vector_4:ywwy()
  -> number * 4
```

Get elements of the vector

## ywwz

```lua
(method) avm.vector_4:ywwz()
  -> number * 4
```

Get elements of the vector

## ywx

```lua
(method) avm.vector_4:ywx()
  -> number, number, number
```

Get elements of the vector

## ywxw

```lua
(method) avm.vector_4:ywxw()
  -> number * 4
```

Get elements of the vector

## ywxx

```lua
(method) avm.vector_4:ywxx()
  -> number * 4
```

Get elements of the vector

## ywxy

```lua
(method) avm.vector_4:ywxy()
  -> number * 4
```

Get elements of the vector

## ywxz

```lua
(method) avm.vector_4:ywxz()
  -> number * 4
```

Get elements of the vector

## ywy

```lua
(method) avm.vector_4:ywy()
  -> number, number, number
```

Get elements of the vector

## ywyw

```lua
(method) avm.vector_4:ywyw()
  -> number * 4
```

Get elements of the vector

## ywyx

```lua
(method) avm.vector_4:ywyx()
  -> number * 4
```

Get elements of the vector

## ywyy

```lua
(method) avm.vector_4:ywyy()
  -> number * 4
```

Get elements of the vector

## ywyz

```lua
(method) avm.vector_4:ywyz()
  -> number * 4
```

Get elements of the vector

## ywz

```lua
(method) avm.vector_4:ywz()
  -> number, number, number
```

Get elements of the vector

## ywzw

```lua
(method) avm.vector_4:ywzw()
  -> number * 4
```

Get elements of the vector

## ywzx

```lua
(method) avm.vector_4:ywzx()
  -> number * 4
```

Get elements of the vector

## ywzy

```lua
(method) avm.vector_4:ywzy()
  -> number * 4
```

Get elements of the vector

## ywzz

```lua
(method) avm.vector_4:ywzz()
  -> number * 4
```

Get elements of the vector

## yx

```lua
(method) avm.vector_4:yx()
  -> number, number
```

Get elements of the vector

## yxw

```lua
(method) avm.vector_4:yxw()
  -> number, number, number
```

Get elements of the vector

## yxww

```lua
(method) avm.vector_4:yxww()
  -> number * 4
```

Get elements of the vector

## yxwx

```lua
(method) avm.vector_4:yxwx()
  -> number * 4
```

Get elements of the vector

## yxwy

```lua
(method) avm.vector_4:yxwy()
  -> number * 4
```

Get elements of the vector

## yxwz

```lua
(method) avm.vector_4:yxwz()
  -> number * 4
```

Get elements of the vector

## yxx

```lua
(method) avm.vector_4:yxx()
  -> number, number, number
```

Get elements of the vector

## yxxw

```lua
(method) avm.vector_4:yxxw()
  -> number * 4
```

Get elements of the vector

## yxxx

```lua
(method) avm.vector_4:yxxx()
  -> number * 4
```

Get elements of the vector

## yxxy

```lua
(method) avm.vector_4:yxxy()
  -> number * 4
```

Get elements of the vector

## yxxz

```lua
(method) avm.vector_4:yxxz()
  -> number * 4
```

Get elements of the vector

## yxy

```lua
(method) avm.vector_4:yxy()
  -> number, number, number
```

Get elements of the vector

## yxyw

```lua
(method) avm.vector_4:yxyw()
  -> number * 4
```

Get elements of the vector

## yxyx

```lua
(method) avm.vector_4:yxyx()
  -> number * 4
```

Get elements of the vector

## yxyy

```lua
(method) avm.vector_4:yxyy()
  -> number * 4
```

Get elements of the vector

## yxyz

```lua
(method) avm.vector_4:yxyz()
  -> number * 4
```

Get elements of the vector

## yxz

```lua
(method) avm.vector_4:yxz()
  -> number, number, number
```

Get elements of the vector

## yxzw

```lua
(method) avm.vector_4:yxzw()
  -> number * 4
```

Get elements of the vector

## yxzx

```lua
(method) avm.vector_4:yxzx()
  -> number * 4
```

Get elements of the vector

## yxzy

```lua
(method) avm.vector_4:yxzy()
  -> number * 4
```

Get elements of the vector

## yxzz

```lua
(method) avm.vector_4:yxzz()
  -> number * 4
```

Get elements of the vector

## yy

```lua
(method) avm.vector_4:yy()
  -> number, number
```

Get elements of the vector

## yyw

```lua
(method) avm.vector_4:yyw()
  -> number, number, number
```

Get elements of the vector

## yyww

```lua
(method) avm.vector_4:yyww()
  -> number * 4
```

Get elements of the vector

## yywx

```lua
(method) avm.vector_4:yywx()
  -> number * 4
```

Get elements of the vector

## yywy

```lua
(method) avm.vector_4:yywy()
  -> number * 4
```

Get elements of the vector

## yywz

```lua
(method) avm.vector_4:yywz()
  -> number * 4
```

Get elements of the vector

## yyx

```lua
(method) avm.vector_4:yyx()
  -> number, number, number
```

Get elements of the vector

## yyxw

```lua
(method) avm.vector_4:yyxw()
  -> number * 4
```

Get elements of the vector

## yyxx

```lua
(method) avm.vector_4:yyxx()
  -> number * 4
```

Get elements of the vector

## yyxy

```lua
(method) avm.vector_4:yyxy()
  -> number * 4
```

Get elements of the vector

## yyxz

```lua
(method) avm.vector_4:yyxz()
  -> number * 4
```

Get elements of the vector

## yyy

```lua
(method) avm.vector_4:yyy()
  -> number, number, number
```

Get elements of the vector

## yyyw

```lua
(method) avm.vector_4:yyyw()
  -> number * 4
```

Get elements of the vector

## yyyx

```lua
(method) avm.vector_4:yyyx()
  -> number * 4
```

Get elements of the vector

## yyyy

```lua
(method) avm.vector_4:yyyy()
  -> number * 4
```

Get elements of the vector

## yyyz

```lua
(method) avm.vector_4:yyyz()
  -> number * 4
```

Get elements of the vector

## yyz

```lua
(method) avm.vector_4:yyz()
  -> number, number, number
```

Get elements of the vector

## yyzw

```lua
(method) avm.vector_4:yyzw()
  -> number * 4
```

Get elements of the vector

## yyzx

```lua
(method) avm.vector_4:yyzx()
  -> number * 4
```

Get elements of the vector

## yyzy

```lua
(method) avm.vector_4:yyzy()
  -> number * 4
```

Get elements of the vector

## yyzz

```lua
(method) avm.vector_4:yyzz()
  -> number * 4
```

Get elements of the vector

## yz

```lua
(method) avm.vector_4:yz()
  -> number, number
```

Get elements of the vector

## yzw

```lua
(method) avm.vector_4:yzw()
  -> number, number, number
```

Get elements of the vector

## yzww

```lua
(method) avm.vector_4:yzww()
  -> number * 4
```

Get elements of the vector

## yzwx

```lua
(method) avm.vector_4:yzwx()
  -> number * 4
```

Get elements of the vector

## yzwy

```lua
(method) avm.vector_4:yzwy()
  -> number * 4
```

Get elements of the vector

## yzwz

```lua
(method) avm.vector_4:yzwz()
  -> number * 4
```

Get elements of the vector

## yzx

```lua
(method) avm.vector_4:yzx()
  -> number, number, number
```

Get elements of the vector

## yzxw

```lua
(method) avm.vector_4:yzxw()
  -> number * 4
```

Get elements of the vector

## yzxx

```lua
(method) avm.vector_4:yzxx()
  -> number * 4
```

Get elements of the vector

## yzxy

```lua
(method) avm.vector_4:yzxy()
  -> number * 4
```

Get elements of the vector

## yzxz

```lua
(method) avm.vector_4:yzxz()
  -> number * 4
```

Get elements of the vector

## yzy

```lua
(method) avm.vector_4:yzy()
  -> number, number, number
```

Get elements of the vector

## yzyw

```lua
(method) avm.vector_4:yzyw()
  -> number * 4
```

Get elements of the vector

## yzyx

```lua
(method) avm.vector_4:yzyx()
  -> number * 4
```

Get elements of the vector

## yzyy

```lua
(method) avm.vector_4:yzyy()
  -> number * 4
```

Get elements of the vector

## yzyz

```lua
(method) avm.vector_4:yzyz()
  -> number * 4
```

Get elements of the vector

## yzz

```lua
(method) avm.vector_4:yzz()
  -> number, number, number
```

Get elements of the vector

## yzzw

```lua
(method) avm.vector_4:yzzw()
  -> number * 4
```

Get elements of the vector

## yzzx

```lua
(method) avm.vector_4:yzzx()
  -> number * 4
```

Get elements of the vector

## yzzy

```lua
(method) avm.vector_4:yzzy()
  -> number * 4
```

Get elements of the vector

## yzzz

```lua
(method) avm.vector_4:yzzz()
  -> number * 4
```

Get elements of the vector

## z

```lua
(method) avm.vector_4:z()
  -> number
```

Get elements of the vector

## zw

```lua
(method) avm.vector_4:zw()
  -> number, number
```

Get elements of the vector

## zww

```lua
(method) avm.vector_4:zww()
  -> number, number, number
```

Get elements of the vector

## zwww

```lua
(method) avm.vector_4:zwww()
  -> number * 4
```

Get elements of the vector

## zwwx

```lua
(method) avm.vector_4:zwwx()
  -> number * 4
```

Get elements of the vector

## zwwy

```lua
(method) avm.vector_4:zwwy()
  -> number * 4
```

Get elements of the vector

## zwwz

```lua
(method) avm.vector_4:zwwz()
  -> number * 4
```

Get elements of the vector

## zwx

```lua
(method) avm.vector_4:zwx()
  -> number, number, number
```

Get elements of the vector

## zwxw

```lua
(method) avm.vector_4:zwxw()
  -> number * 4
```

Get elements of the vector

## zwxx

```lua
(method) avm.vector_4:zwxx()
  -> number * 4
```

Get elements of the vector

## zwxy

```lua
(method) avm.vector_4:zwxy()
  -> number * 4
```

Get elements of the vector

## zwxz

```lua
(method) avm.vector_4:zwxz()
  -> number * 4
```

Get elements of the vector

## zwy

```lua
(method) avm.vector_4:zwy()
  -> number, number, number
```

Get elements of the vector

## zwyw

```lua
(method) avm.vector_4:zwyw()
  -> number * 4
```

Get elements of the vector

## zwyx

```lua
(method) avm.vector_4:zwyx()
  -> number * 4
```

Get elements of the vector

## zwyy

```lua
(method) avm.vector_4:zwyy()
  -> number * 4
```

Get elements of the vector

## zwyz

```lua
(method) avm.vector_4:zwyz()
  -> number * 4
```

Get elements of the vector

## zwz

```lua
(method) avm.vector_4:zwz()
  -> number, number, number
```

Get elements of the vector

## zwzw

```lua
(method) avm.vector_4:zwzw()
  -> number * 4
```

Get elements of the vector

## zwzx

```lua
(method) avm.vector_4:zwzx()
  -> number * 4
```

Get elements of the vector

## zwzy

```lua
(method) avm.vector_4:zwzy()
  -> number * 4
```

Get elements of the vector

## zwzz

```lua
(method) avm.vector_4:zwzz()
  -> number * 4
```

Get elements of the vector

## zx

```lua
(method) avm.vector_4:zx()
  -> number, number
```

Get elements of the vector

## zxw

```lua
(method) avm.vector_4:zxw()
  -> number, number, number
```

Get elements of the vector

## zxww

```lua
(method) avm.vector_4:zxww()
  -> number * 4
```

Get elements of the vector

## zxwx

```lua
(method) avm.vector_4:zxwx()
  -> number * 4
```

Get elements of the vector

## zxwy

```lua
(method) avm.vector_4:zxwy()
  -> number * 4
```

Get elements of the vector

## zxwz

```lua
(method) avm.vector_4:zxwz()
  -> number * 4
```

Get elements of the vector

## zxx

```lua
(method) avm.vector_4:zxx()
  -> number, number, number
```

Get elements of the vector

## zxxw

```lua
(method) avm.vector_4:zxxw()
  -> number * 4
```

Get elements of the vector

## zxxx

```lua
(method) avm.vector_4:zxxx()
  -> number * 4
```

Get elements of the vector

## zxxy

```lua
(method) avm.vector_4:zxxy()
  -> number * 4
```

Get elements of the vector

## zxxz

```lua
(method) avm.vector_4:zxxz()
  -> number * 4
```

Get elements of the vector

## zxy

```lua
(method) avm.vector_4:zxy()
  -> number, number, number
```

Get elements of the vector

## zxyw

```lua
(method) avm.vector_4:zxyw()
  -> number * 4
```

Get elements of the vector

## zxyx

```lua
(method) avm.vector_4:zxyx()
  -> number * 4
```

Get elements of the vector

## zxyy

```lua
(method) avm.vector_4:zxyy()
  -> number * 4
```

Get elements of the vector

## zxyz

```lua
(method) avm.vector_4:zxyz()
  -> number * 4
```

Get elements of the vector

## zxz

```lua
(method) avm.vector_4:zxz()
  -> number, number, number
```

Get elements of the vector

## zxzw

```lua
(method) avm.vector_4:zxzw()
  -> number * 4
```

Get elements of the vector

## zxzx

```lua
(method) avm.vector_4:zxzx()
  -> number * 4
```

Get elements of the vector

## zxzy

```lua
(method) avm.vector_4:zxzy()
  -> number * 4
```

Get elements of the vector

## zxzz

```lua
(method) avm.vector_4:zxzz()
  -> number * 4
```

Get elements of the vector

## zy

```lua
(method) avm.vector_4:zy()
  -> number, number
```

Get elements of the vector

## zyw

```lua
(method) avm.vector_4:zyw()
  -> number, number, number
```

Get elements of the vector

## zyww

```lua
(method) avm.vector_4:zyww()
  -> number * 4
```

Get elements of the vector

## zywx

```lua
(method) avm.vector_4:zywx()
  -> number * 4
```

Get elements of the vector

## zywy

```lua
(method) avm.vector_4:zywy()
  -> number * 4
```

Get elements of the vector

## zywz

```lua
(method) avm.vector_4:zywz()
  -> number * 4
```

Get elements of the vector

## zyx

```lua
(method) avm.vector_4:zyx()
  -> number, number, number
```

Get elements of the vector

## zyxw

```lua
(method) avm.vector_4:zyxw()
  -> number * 4
```

Get elements of the vector

## zyxx

```lua
(method) avm.vector_4:zyxx()
  -> number * 4
```

Get elements of the vector

## zyxy

```lua
(method) avm.vector_4:zyxy()
  -> number * 4
```

Get elements of the vector

## zyxz

```lua
(method) avm.vector_4:zyxz()
  -> number * 4
```

Get elements of the vector

## zyy

```lua
(method) avm.vector_4:zyy()
  -> number, number, number
```

Get elements of the vector

## zyyw

```lua
(method) avm.vector_4:zyyw()
  -> number * 4
```

Get elements of the vector

## zyyx

```lua
(method) avm.vector_4:zyyx()
  -> number * 4
```

Get elements of the vector

## zyyy

```lua
(method) avm.vector_4:zyyy()
  -> number * 4
```

Get elements of the vector

## zyyz

```lua
(method) avm.vector_4:zyyz()
  -> number * 4
```

Get elements of the vector

## zyz

```lua
(method) avm.vector_4:zyz()
  -> number, number, number
```

Get elements of the vector

## zyzw

```lua
(method) avm.vector_4:zyzw()
  -> number * 4
```

Get elements of the vector

## zyzx

```lua
(method) avm.vector_4:zyzx()
  -> number * 4
```

Get elements of the vector

## zyzy

```lua
(method) avm.vector_4:zyzy()
  -> number * 4
```

Get elements of the vector

## zyzz

```lua
(method) avm.vector_4:zyzz()
  -> number * 4
```

Get elements of the vector

## zz

```lua
(method) avm.vector_4:zz()
  -> number, number
```

Get elements of the vector

## zzw

```lua
(method) avm.vector_4:zzw()
  -> number, number, number
```

Get elements of the vector

## zzww

```lua
(method) avm.vector_4:zzww()
  -> number * 4
```

Get elements of the vector

## zzwx

```lua
(method) avm.vector_4:zzwx()
  -> number * 4
```

Get elements of the vector

## zzwy

```lua
(method) avm.vector_4:zzwy()
  -> number * 4
```

Get elements of the vector

## zzwz

```lua
(method) avm.vector_4:zzwz()
  -> number * 4
```

Get elements of the vector

## zzx

```lua
(method) avm.vector_4:zzx()
  -> number, number, number
```

Get elements of the vector

## zzxw

```lua
(method) avm.vector_4:zzxw()
  -> number * 4
```

Get elements of the vector

## zzxx

```lua
(method) avm.vector_4:zzxx()
  -> number * 4
```

Get elements of the vector

## zzxy

```lua
(method) avm.vector_4:zzxy()
  -> number * 4
```

Get elements of the vector

## zzxz

```lua
(method) avm.vector_4:zzxz()
  -> number * 4
```

Get elements of the vector

## zzy

```lua
(method) avm.vector_4:zzy()
  -> number, number, number
```

Get elements of the vector

## zzyw

```lua
(method) avm.vector_4:zzyw()
  -> number * 4
```

Get elements of the vector

## zzyx

```lua
(method) avm.vector_4:zzyx()
  -> number * 4
```

Get elements of the vector

## zzyy

```lua
(method) avm.vector_4:zzyy()
  -> number * 4
```

Get elements of the vector

## zzyz

```lua
(method) avm.vector_4:zzyz()
  -> number * 4
```

Get elements of the vector

## zzz

```lua
(method) avm.vector_4:zzz()
  -> number, number, number
```

Get elements of the vector

## zzzw

```lua
(method) avm.vector_4:zzzw()
  -> number * 4
```

Get elements of the vector

## zzzx

```lua
(method) avm.vector_4:zzzx()
  -> number * 4
```

Get elements of the vector

## zzzy

```lua
(method) avm.vector_4:zzzy()
  -> number * 4
```

Get elements of the vector

## zzzz

```lua
(method) avm.vector_4:zzzz()
  -> number * 4
```

Get elements of the vector


---

# format
Format  

Functions for converting arrays into readable strings  

## array

```lua
function format.array(src: avm.array<T>, separator?: string, format?: string)
  -> string
```

Format an array as a string of comma-separated values
Example:
```
format.array({1,2,3}) --> "1, 2, 3"
```

@*param* `separator` — default ", "

@*param* `format` — format string for each element

## mat1

```lua
function format.mat1(src: avm.number1, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat1x1

```lua
function format.mat1x1(src: avm.number1, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat1x2

```lua
function format.mat1x2(src: avm.number2, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat1x3

```lua
function format.mat1x3(src: avm.number3, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat1x4

```lua
function format.mat1x4(src: avm.number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat2

```lua
function format.mat2(src: avm.number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat2x1

```lua
function format.mat2x1(src: avm.number2, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat2x2

```lua
function format.mat2x2(src: avm.number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat2x3

```lua
function format.mat2x3(src: avm.number6, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat2x4

```lua
function format.mat2x4(src: avm.number8, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat3

```lua
function format.mat3(src: avm.number9, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat3x1

```lua
function format.mat3x1(src: avm.number3, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat3x2

```lua
function format.mat3x2(src: avm.number6, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat3x3

```lua
function format.mat3x3(src: avm.number9, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat3x4

```lua
function format.mat3x4(src: avm.number12, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat4

```lua
function format.mat4(src: avm.number16, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat4x1

```lua
function format.mat4x1(src: avm.number4, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat4x2

```lua
function format.mat4x2(src: avm.number8, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat4x3

```lua
function format.mat4x3(src: avm.number12, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## mat4x4

```lua
function format.mat4x4(src: avm.number16, format?: string)
  -> string
```

Format matrix

@*param* `format` — optional format to apply to each element

## matrix

```lua
function format.matrix(src: avm.seq_number|{ [integer]: number }, src_index: integer, num_cols: any, num_rows: any, format?: string, options?: { row_major_order: boolean })
  -> string
```

Format a slice as a 2d matrix

By default will assume the data is in column-major order, but this can be changed with the option `row_major_order = true`

## slice

```lua
function format.slice(src: avm.seq<T>, src_index: integer, src_count: integer, separator?: string, format?: string)
  -> string
```

Format a slice as a string of comma-separated values
Example:
```
format.slice({1,2,3,4}, 1, 3) --> "1, 2, 3"
```

@*param* `separator` — default ", "

@*param* `format` — format string for each element

## tabulated

```lua
function format.tabulated(table_format: any, num_rows: integer, column_1: { data: avm.seq<any>, index: integer, count: integer, group_size: integer, label: string, format: string }, ...{ data: avm.seq<any>, index: integer, count: integer, group_size: integer, label: string, format: string })
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

## group_2

```lua
function iterator.group_2(src: avm.array<T>)
  -> fun():integer, <T>, <T>
```

Create an iterator over an array that returns consecutive tuples of 2 elements

NOTE: the returned index is the index of *the group*

## group_3

```lua
function iterator.group_3(src: avm.array<T>)
  -> fun():integer, <T>, <T>, <T>
```

Create an iterator over an array that returns consecutive tuples of 3 elements

NOTE: the returned index is the index of *the group*

## group_4

```lua
function iterator.group_4(src: avm.array<T>)
  -> fun():integer, <T> * 4
```

Create an iterator over an array that returns consecutive tuples of 4 elements

NOTE: the returned index is the index of *the group*

## group_5

```lua
function iterator.group_5(src: avm.array<T>)
  -> fun():integer, <T> * 5
```

Create an iterator over an array that returns consecutive tuples of 5 elements

NOTE: the returned index is the index of *the group*

## group_6

```lua
function iterator.group_6(src: avm.array<T>)
  -> fun():integer, <T> * 6
```

Create an iterator over an array that returns consecutive tuples of 6 elements

NOTE: the returned index is the index of *the group*

## group_7

```lua
function iterator.group_7(src: avm.array<T>)
  -> fun():integer, <T> * 7
```

Create an iterator over an array that returns consecutive tuples of 7 elements

NOTE: the returned index is the index of *the group*

## group_8

```lua
function iterator.group_8(src: avm.array<T>)
  -> fun():integer, <T> * 8
```

Create an iterator over an array that returns consecutive tuples of 8 elements

NOTE: the returned index is the index of *the group*

## group_9

```lua
function iterator.group_9(src: avm.array<T>)
  -> fun():integer, <T> * 9
```

Create an iterator over an array that returns consecutive tuples of 9 elements

NOTE: the returned index is the index of *the group*

## group_10

```lua
function iterator.group_10(src: avm.array<T>)
  -> fun():integer, <T> * 10
```

Create an iterator over an array that returns consecutive tuples of 10 elements

NOTE: the returned index is the index of *the group*

## group_10_ex

```lua
function iterator.group_10_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 10
```

Create an iterator over a slice that returns consecutive tuples of 10 elements

NOTE: the returned index is the index of *the group*

## group_11

```lua
function iterator.group_11(src: avm.array<T>)
  -> fun():integer, <T> * 11
```

Create an iterator over an array that returns consecutive tuples of 11 elements

NOTE: the returned index is the index of *the group*

## group_11_ex

```lua
function iterator.group_11_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 11
```

Create an iterator over a slice that returns consecutive tuples of 11 elements

NOTE: the returned index is the index of *the group*

## group_12

```lua
function iterator.group_12(src: avm.array<T>)
  -> fun():integer, <T> * 12
```

Create an iterator over an array that returns consecutive tuples of 12 elements

NOTE: the returned index is the index of *the group*

## group_12_ex

```lua
function iterator.group_12_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 12
```

Create an iterator over a slice that returns consecutive tuples of 12 elements

NOTE: the returned index is the index of *the group*

## group_13

```lua
function iterator.group_13(src: avm.array<T>)
  -> fun():integer, <T> * 13
```

Create an iterator over an array that returns consecutive tuples of 13 elements

NOTE: the returned index is the index of *the group*

## group_13_ex

```lua
function iterator.group_13_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 13
```

Create an iterator over a slice that returns consecutive tuples of 13 elements

NOTE: the returned index is the index of *the group*

## group_14

```lua
function iterator.group_14(src: avm.array<T>)
  -> fun():integer, <T> * 14
```

Create an iterator over an array that returns consecutive tuples of 14 elements

NOTE: the returned index is the index of *the group*

## group_14_ex

```lua
function iterator.group_14_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 14
```

Create an iterator over a slice that returns consecutive tuples of 14 elements

NOTE: the returned index is the index of *the group*

## group_15

```lua
function iterator.group_15(src: avm.array<T>)
  -> fun():integer, <T> * 15
```

Create an iterator over an array that returns consecutive tuples of 15 elements

NOTE: the returned index is the index of *the group*

## group_15_ex

```lua
function iterator.group_15_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 15
```

Create an iterator over a slice that returns consecutive tuples of 15 elements

NOTE: the returned index is the index of *the group*

## group_16

```lua
function iterator.group_16(src: avm.array<T>)
  -> fun():integer, <T> * 16
```

Create an iterator over an array that returns consecutive tuples of 16 elements

NOTE: the returned index is the index of *the group*

## group_16_ex

```lua
function iterator.group_16_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 16
```

Create an iterator over a slice that returns consecutive tuples of 16 elements

NOTE: the returned index is the index of *the group*

## group_2_ex

```lua
function iterator.group_2_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T>, <T>
```

Create an iterator over a slice that returns consecutive tuples of 2 elements

NOTE: the returned index is the index of *the group*

## group_3_ex

```lua
function iterator.group_3_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T>, <T>, <T>
```

Create an iterator over a slice that returns consecutive tuples of 3 elements

NOTE: the returned index is the index of *the group*

## group_4_ex

```lua
function iterator.group_4_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 4
```

Create an iterator over a slice that returns consecutive tuples of 4 elements

NOTE: the returned index is the index of *the group*

## group_5_ex

```lua
function iterator.group_5_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 5
```

Create an iterator over a slice that returns consecutive tuples of 5 elements

NOTE: the returned index is the index of *the group*

## group_6_ex

```lua
function iterator.group_6_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 6
```

Create an iterator over a slice that returns consecutive tuples of 6 elements

NOTE: the returned index is the index of *the group*

## group_7_ex

```lua
function iterator.group_7_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 7
```

Create an iterator over a slice that returns consecutive tuples of 7 elements

NOTE: the returned index is the index of *the group*

## group_8_ex

```lua
function iterator.group_8_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 8
```

Create an iterator over a slice that returns consecutive tuples of 8 elements

NOTE: the returned index is the index of *the group*

## group_9_ex

```lua
function iterator.group_9_ex(src: avm.seq<T>, src_index: integer, src_count: integer)
  -> fun():integer, <T> * 9
```

Create an iterator over a slice that returns consecutive tuples of 9 elements

NOTE: the returned index is the index of *the group*

## zip_1

```lua
function iterator.zip_1(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T>, <T>
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_2

```lua
function iterator.zip_2(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 4
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_3

```lua
function iterator.zip_3(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 6
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_4

```lua
function iterator.zip_4(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 8
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_5

```lua
function iterator.zip_5(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 10
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_6

```lua
function iterator.zip_6(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 12
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_7

```lua
function iterator.zip_7(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 14
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_8

```lua
function iterator.zip_8(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 16
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_9

```lua
function iterator.zip_9(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 18
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_10

```lua
function iterator.zip_10(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 20
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_10_ex

```lua
function iterator.zip_10_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 20
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_11

```lua
function iterator.zip_11(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 22
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_11_ex

```lua
function iterator.zip_11_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 22
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_12

```lua
function iterator.zip_12(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 24
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_12_ex

```lua
function iterator.zip_12_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 24
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_13

```lua
function iterator.zip_13(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 26
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_13_ex

```lua
function iterator.zip_13_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 26
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_14

```lua
function iterator.zip_14(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 28
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_14_ex

```lua
function iterator.zip_14_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 28
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_15

```lua
function iterator.zip_15(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 30
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_15_ex

```lua
function iterator.zip_15_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 30
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_16

```lua
function iterator.zip_16(a: avm.array<T>, b: avm.array<T>)
  -> fun():integer, <T> * 32
```

Create an iterator over two arrays that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_16_ex

```lua
function iterator.zip_16_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 32
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_1_ex

```lua
function iterator.zip_1_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T>, <T>
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_2_ex

```lua
function iterator.zip_2_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 4
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_3_ex

```lua
function iterator.zip_3_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 6
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_4_ex

```lua
function iterator.zip_4_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 8
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_5_ex

```lua
function iterator.zip_5_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 10
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_6_ex

```lua
function iterator.zip_6_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 12
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_7_ex

```lua
function iterator.zip_7_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 14
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_8_ex

```lua
function iterator.zip_8_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 16
```

Create an iterator over two slices that returns
```
i, a_i_1, ..., a_i_n, b_i_1, ..., b_i_n
```
where `i` is the index of the group,
`a_i_j` is the `j`'th element of group `i` of `a` and
`b_i_j` is the `j`'th element of group `i` of `b`

## zip_9_ex

```lua
function iterator.zip_9_ex(a: avm.seq<T>, a_index: integer, a_count: integer, b: avm.seq<T>, b_index: integer)
  -> fun():integer, <T> * 18
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

## add_2

```lua
function linalg.add_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the addition operator to two 2-tuples

## add_3

```lua
function linalg.add_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the addition operator to two 3-tuples

## add_4

```lua
function linalg.add_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the addition operator to two 4-tuples

## add_mat2

```lua
function linalg.add_mat2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the addition operator to each element in two 2x2 matrices

## add_mat2_constant

```lua
function linalg.add_mat2_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the addition operator to each element in a 2x2 matrix and a constant

## add_mat2_constant_ex

```lua
function linalg.add_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## add_mat2_constant_ex

```lua
function linalg.add_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the addition operator to each element in a 2x2 matrix in a slice and a constant

## add_mat2_ex

```lua
function linalg.add_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in two 2d-vectors in a slice and store the result in a destination

## add_mat2_ex

```lua
function linalg.add_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the addition operator to each element in two 2x2 matrices in a slice

## add_mat3

```lua
function linalg.add_mat3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Apply the addition operator to each element in two 3x3 matrices

## add_mat3_constant

```lua
function linalg.add_mat3_constant(a: avm.number9, c: number)
  -> number * 9
```

Apply the addition operator to each element in a 3x3 matrix and a constant

## add_mat3_constant_ex

```lua
function linalg.add_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number)
  -> number * 9
```

Apply the addition operator to each element in a 3x3 matrix in a slice and a constant

## add_mat3_constant_ex

```lua
function linalg.add_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## add_mat3_ex

```lua
function linalg.add_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Apply the addition operator to each element in two 3x3 matrices in a slice

## add_mat3_ex

```lua
function linalg.add_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number9|{ [integer]: number }, b_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in two 3d-vectors in a slice and store the result in a destination

## add_mat4

```lua
function linalg.add_mat4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Apply the addition operator to each element in two 4x4 matrices

## add_mat4_constant

```lua
function linalg.add_mat4_constant(a: avm.number16, c: number)
  -> number * 16
```

Apply the addition operator to each element in a 4x4 matrix and a constant

## add_mat4_constant_ex

```lua
function linalg.add_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number)
  -> number * 16
```

Apply the addition operator to each element in a 4x4 matrix in a slice and a constant

## add_mat4_constant_ex

```lua
function linalg.add_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## add_mat4_ex

```lua
function linalg.add_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Apply the addition operator to each element in two 4x4 matrices in a slice

## add_mat4_ex

```lua
function linalg.add_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number16|{ [integer]: number }, b_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to each element in two 4d-vectors in a slice and store the result in a destination

## add_vec2

```lua
function linalg.add_vec2(a: avm.number2, b: avm.number2)
  -> number, number
```

Apply the addition operator to two 2d-vectors

## add_vec2_constant

```lua
function linalg.add_vec2_constant(a: avm.number2, c: number)
  -> number, number
```

Apply the addition operator to a 2d-vector and a constant

## add_vec2_constant_ex

```lua
function linalg.add_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to a 2d-vector in a slice and a constant and store in a destination

## add_vec2_constant_ex

```lua
function linalg.add_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number)
  -> number, number
```

Apply the addition operator to a 2d-vector in a slice and a constant

## add_vec2_ex

```lua
function linalg.add_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to two 2d-vectors in a slice and store the result in a destination

## add_vec2_ex

```lua
function linalg.add_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number, number
```

Apply the addition operator to two 2d-vectors in a slice

## add_vec3

```lua
function linalg.add_vec3(a: avm.number3, b: avm.number3)
  -> number, number, number
```

Apply the addition operator to two 3d-vectors

## add_vec3_constant

```lua
function linalg.add_vec3_constant(a: avm.number3, c: number)
  -> number, number, number
```

Apply the addition operator to a 3d-vector and a constant

## add_vec3_constant_ex

```lua
function linalg.add_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number)
  -> number, number, number
```

Apply the addition operator to a 3d-vector in a slice and a constant

## add_vec3_constant_ex

```lua
function linalg.add_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to a 3d-vector in a slice and a constant and store in a destination

## add_vec3_ex

```lua
function linalg.add_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Apply the addition operator to two 3d-vectors in a slice

## add_vec3_ex

```lua
function linalg.add_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to two 3d-vectors in a slice and store the result in a destination

## add_vec4

```lua
function linalg.add_vec4(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the addition operator to two 4d-vectors

## add_vec4_constant

```lua
function linalg.add_vec4_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the addition operator to a 4d-vector and a constant

## add_vec4_constant_ex

```lua
function linalg.add_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the addition operator to a 4d-vector in a slice and a constant

## add_vec4_constant_ex

```lua
function linalg.add_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to a 4d-vector in a slice and a constant and store in a destination

## add_vec4_ex

```lua
function linalg.add_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the addition operator to two 4d-vectors in a slice

## add_vec4_ex

```lua
function linalg.add_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the addition operator to two 4d-vectors in a slice and store the result in a destination

## cross_product_tuple3

```lua
function linalg.cross_product_tuple3(ax: number, ay: number, az: number, bx: number, by: number, bz: number)
  -> number, number, number
```

Cross product of 3d vector

## cross_product_vec3

```lua
function linalg.cross_product_vec3(a: avm.number3, b: avm.number3)
  -> number, number, number
```

Cross product of 3d vector

## cross_product_vec3_ex

```lua
function linalg.cross_product_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Cross product of 3d vector in a slice

## cross_product_vec3_ex

```lua
function linalg.cross_product_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Cross product of 3d vector in a slice into a destination

## div_2

```lua
function linalg.div_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the division operator to two 2-tuples

## div_3

```lua
function linalg.div_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the division operator to two 3-tuples

## div_4

```lua
function linalg.div_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the division operator to two 4-tuples

## div_mat2

```lua
function linalg.div_mat2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the division operator to each element in two 2x2 matrices

## div_mat2_constant

```lua
function linalg.div_mat2_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the division operator to each element in a 2x2 matrix and a constant

## div_mat2_constant_ex

```lua
function linalg.div_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## div_mat2_constant_ex

```lua
function linalg.div_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the division operator to each element in a 2x2 matrix in a slice and a constant

## div_mat2_ex

```lua
function linalg.div_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the division operator to each element in two 2x2 matrices in a slice

## div_mat2_ex

```lua
function linalg.div_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in two 2d-vectors in a slice and store the result in a destination

## div_mat3

```lua
function linalg.div_mat3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Apply the division operator to each element in two 3x3 matrices

## div_mat3_constant

```lua
function linalg.div_mat3_constant(a: avm.number9, c: number)
  -> number * 9
```

Apply the division operator to each element in a 3x3 matrix and a constant

## div_mat3_constant_ex

```lua
function linalg.div_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## div_mat3_constant_ex

```lua
function linalg.div_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number)
  -> number * 9
```

Apply the division operator to each element in a 3x3 matrix in a slice and a constant

## div_mat3_ex

```lua
function linalg.div_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number9|{ [integer]: number }, b_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in two 3d-vectors in a slice and store the result in a destination

## div_mat3_ex

```lua
function linalg.div_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Apply the division operator to each element in two 3x3 matrices in a slice

## div_mat4

```lua
function linalg.div_mat4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Apply the division operator to each element in two 4x4 matrices

## div_mat4_constant

```lua
function linalg.div_mat4_constant(a: avm.number16, c: number)
  -> number * 16
```

Apply the division operator to each element in a 4x4 matrix and a constant

## div_mat4_constant_ex

```lua
function linalg.div_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## div_mat4_constant_ex

```lua
function linalg.div_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number)
  -> number * 16
```

Apply the division operator to each element in a 4x4 matrix in a slice and a constant

## div_mat4_ex

```lua
function linalg.div_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Apply the division operator to each element in two 4x4 matrices in a slice

## div_mat4_ex

```lua
function linalg.div_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number16|{ [integer]: number }, b_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to each element in two 4d-vectors in a slice and store the result in a destination

## div_vec2

```lua
function linalg.div_vec2(a: avm.number2, b: avm.number2)
  -> number, number
```

Apply the division operator to two 2d-vectors

## div_vec2_constant

```lua
function linalg.div_vec2_constant(a: avm.number2, c: number)
  -> number, number
```

Apply the division operator to a 2d-vector and a constant

## div_vec2_constant_ex

```lua
function linalg.div_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number)
  -> number, number
```

Apply the division operator to a 2d-vector in a slice and a constant

## div_vec2_constant_ex

```lua
function linalg.div_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to a 2d-vector in a slice and a constant and store in a destination

## div_vec2_ex

```lua
function linalg.div_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to two 2d-vectors in a slice and store the result in a destination

## div_vec2_ex

```lua
function linalg.div_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number, number
```

Apply the division operator to two 2d-vectors in a slice

## div_vec3

```lua
function linalg.div_vec3(a: avm.number3, b: avm.number3)
  -> number, number, number
```

Apply the division operator to two 3d-vectors

## div_vec3_constant

```lua
function linalg.div_vec3_constant(a: avm.number3, c: number)
  -> number, number, number
```

Apply the division operator to a 3d-vector and a constant

## div_vec3_constant_ex

```lua
function linalg.div_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number)
  -> number, number, number
```

Apply the division operator to a 3d-vector in a slice and a constant

## div_vec3_constant_ex

```lua
function linalg.div_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to a 3d-vector in a slice and a constant and store in a destination

## div_vec3_ex

```lua
function linalg.div_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Apply the division operator to two 3d-vectors in a slice

## div_vec3_ex

```lua
function linalg.div_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to two 3d-vectors in a slice and store the result in a destination

## div_vec4

```lua
function linalg.div_vec4(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the division operator to two 4d-vectors

## div_vec4_constant

```lua
function linalg.div_vec4_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the division operator to a 4d-vector and a constant

## div_vec4_constant_ex

```lua
function linalg.div_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the division operator to a 4d-vector in a slice and a constant

## div_vec4_constant_ex

```lua
function linalg.div_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to a 4d-vector in a slice and a constant and store in a destination

## div_vec4_ex

```lua
function linalg.div_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the division operator to two 4d-vectors in a slice

## div_vec4_ex

```lua
function linalg.div_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the division operator to two 4d-vectors in a slice and store the result in a destination

## equals_mat2

```lua
function linalg.equals_mat2(a: avm.number4, b: avm.number4, epsilon?: number)
  -> boolean
```

true if the matrices are equal (differ by epsilon or less)

## equals_mat2_ex

```lua
function linalg.equals_mat2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if the matrices in a slice are equal (differ by epsilon or less)

## equals_mat3

```lua
function linalg.equals_mat3(a: avm.number9, b: avm.number9, epsilon?: number)
  -> boolean
```

true if the matrices are equal (differ by epsilon or less)

## equals_mat3_ex

```lua
function linalg.equals_mat3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if the matrices in a slice are equal (differ by epsilon or less)

## equals_mat4

```lua
function linalg.equals_mat4(a: avm.number16, b: avm.number16, epsilon?: number)
  -> boolean
```

true if the matrices are equal (differ by epsilon or less)

## equals_mat4_ex

```lua
function linalg.equals_mat4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if the matrices in a slice are equal (differ by epsilon or less)

## equals_vec2

```lua
function linalg.equals_vec2(a: avm.number2, b: avm.number2, epsilon?: number)
  -> boolean
```

true if the vectors are equal (differ by epsilon or less)

## equals_vec2_ex

```lua
function linalg.equals_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if the vectors in a slice are equal (differ by epsilon or less)

## equals_vec3

```lua
function linalg.equals_vec3(a: avm.number3, b: avm.number3, epsilon?: number)
  -> boolean
```

true if the vectors are equal (differ by epsilon or less)

## equals_vec3_ex

```lua
function linalg.equals_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if the vectors in a slice are equal (differ by epsilon or less)

## equals_vec4

```lua
function linalg.equals_vec4(a: avm.number4, b: avm.number4, epsilon?: number)
  -> boolean
```

true if the vectors are equal (differ by epsilon or less)

## equals_vec4_ex

```lua
function linalg.equals_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, epsilon?: number)
  -> boolean
```

true if the vectors in a slice are equal (differ by epsilon or less)

## inner_product_2

```lua
function linalg.inner_product_2(a1: number, a2: number, b1: number, b2: number)
  -> number
```

Inner product of 2d vectors

## inner_product_3

```lua
function linalg.inner_product_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number
```

Inner product of 3d vectors

## inner_product_vec2

```lua
function linalg.inner_product_vec2(a: avm.number2, b: avm.number2)
  -> number
```

Inner product of 2d vector

## inner_product_vec2_slice

```lua
function linalg.inner_product_vec2_slice(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number
```

Inner product of 2d vector in a slice

## inner_product_vec3

```lua
function linalg.inner_product_vec3(a: avm.number3, b: avm.number3)
  -> number
```

Inner product of 3d vector

## inner_product_vec3_slice

```lua
function linalg.inner_product_vec3_slice(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number
```

Inner product of 3d vector in a slice

## inner_product_vec4

```lua
function linalg.inner_product_vec4(a: avm.number4, b: avm.number4)
  -> number
```

Inner product of 4d vector

## inner_product_vec4_slice

```lua
function linalg.inner_product_vec4_slice(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number
```

Inner product of 4d vector in a slice

## length_2

```lua
function linalg.length_2(a1: number, a2: number)
  -> number
```

2d vector length (magnitude)

## length_3

```lua
function linalg.length_3(a1: number, a2: number, a3: number)
  -> number
```

3d vector length (magnitude)

## length_4

```lua
function linalg.length_4(a1: number, a2: number, a3: number, a4: number)
  -> number
```

4d vector length (magnitude)

## length_squared_2

```lua
function linalg.length_squared_2(a1: number, a2: number)
  -> number
```

2d vector length (magnitude) squared

## length_squared_3

```lua
function linalg.length_squared_3(a1: number, a2: number, a3: number)
  -> number
```

3d vector length (magnitude) squared

## length_squared_4

```lua
function linalg.length_squared_4(a1: number, a2: number, a3: number, a4: number)
  -> number
```

4d vector length (magnitude) squared

## length_squared_vec2

```lua
function linalg.length_squared_vec2(v: avm.number2)
  -> number
```

2d vector length (magnitude) squared

## length_squared_vec2_slice

```lua
function linalg.length_squared_vec2_slice(v: avm.seq_number2|{ [integer]: number }, v_index: integer)
  -> number
```

2d vector length (magnitude) squared in a slice

## length_squared_vec3

```lua
function linalg.length_squared_vec3(v: avm.number3)
  -> number
```

3d vector length (magnitude) squared

## length_squared_vec3_slice

```lua
function linalg.length_squared_vec3_slice(v: avm.seq_number3|{ [integer]: number }, v_index: integer)
  -> number
```

3d vector length (magnitude) squared in a slice

## length_squared_vec4

```lua
function linalg.length_squared_vec4(v: avm.number4)
  -> number
```

4d vector length (magnitude) squared

## length_squared_vec4_slice

```lua
function linalg.length_squared_vec4_slice(v: avm.seq_number4|{ [integer]: number }, v_index: integer)
  -> number
```

4d vector length (magnitude) squared in a slice

## length_vec2

```lua
function linalg.length_vec2(v: avm.number2)
  -> number
```

2d vector length (magnitude)

## length_vec2_slice

```lua
function linalg.length_vec2_slice(v: avm.seq_number2|{ [integer]: number }, v_index: integer)
  -> number
```

2d vector length (magnitude) in a slice

## length_vec3

```lua
function linalg.length_vec3(v: avm.number3)
  -> number
```

3d vector length (magnitude)

## length_vec3_slice

```lua
function linalg.length_vec3_slice(v: avm.seq_number3|{ [integer]: number }, v_index: integer)
  -> number
```

3d vector length (magnitude) in a slice

## length_vec4

```lua
function linalg.length_vec4(v: avm.number4)
  -> number
```

4d vector length (magnitude)

## length_vec4_slice

```lua
function linalg.length_vec4_slice(v: avm.seq_number4|{ [integer]: number }, v_index: integer)
  -> number
```

4d vector length (magnitude) in a slice

## mat2_identity

```lua
function linalg.mat2_identity()
  -> number * 4
```

2x2 identity matrix

## mat2_zero

```lua
function linalg.mat2_zero()
  -> number * 4
```

2x2 matrix of zeros

## mat3_identity

```lua
function linalg.mat3_identity()
  -> number * 9
```

3x3 identity matrix

## mat3_rotate_around_axis

```lua
function linalg.mat3_rotate_around_axis(radians: number, axis_x: number, axis_y: number, axis_z: number)
  -> number * 9
```

3x3 rotation matrix

## mat3_scale

```lua
function linalg.mat3_scale(x: number, y: number, z: number)
  -> number * 9
```

3x3 scaling matrix

## mat3_translate

```lua
function linalg.mat3_translate(x: number, y: number)
  -> number * 9
```

3x3 translation matrix

## mat3_zero

```lua
function linalg.mat3_zero()
  -> number * 9
```

3x3 matrix of zeros

## mat4_identity

```lua
function linalg.mat4_identity()
  -> number * 16
```

4x4 identity matrix

## mat4_rotate_around_axis

```lua
function linalg.mat4_rotate_around_axis(radians: number, axis_x: number, axis_y: number, axis_z: number)
  -> number * 16
```

4x4 rotation matrix

## mat4_scale

```lua
function linalg.mat4_scale(x: number, y: number, z: number)
  -> number * 16
```

4x4 scaling matrix

## mat4_translate

```lua
function linalg.mat4_translate(x: number, y: number, z: number)
  -> number * 16
```

4x4 translation matrix

## mat4_zero

```lua
function linalg.mat4_zero()
  -> number * 16
```

4x4 matrix of zeros

## matmul_mat1_mat1

```lua
function linalg.matmul_mat1_mat1(a: avm.number1, b: avm.number1)
  -> number
```

Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix

## matmul_mat1_mat1_ex

```lua
function linalg.matmul_mat1_mat1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix

## matmul_mat1_mat1_ex

```lua
function linalg.matmul_mat1_mat1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x1_mat1x1

```lua
function linalg.matmul_mat1x1_mat1x1(a: avm.number1, b: avm.number1)
  -> number
```

Multiply a 1x1 matrix with a 1x1 matrix and return a 1x1 matrix

## matmul_mat1x1_mat1x1_ex

```lua
function linalg.matmul_mat1x1_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x1_mat1x1_ex

```lua
function linalg.matmul_mat1x1_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number
```

Multiply a 1x1 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x1 matrix

## matmul_mat1x1_mat2x1

```lua
function linalg.matmul_mat1x1_mat2x1(a: avm.number1, b: avm.number2)
  -> number, number
```

Multiply a 1x1 matrix with a 2x1 matrix and return a 2x1 matrix

## matmul_mat1x1_mat2x1_ex

```lua
function linalg.matmul_mat1x1_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix

## matmul_mat1x1_mat2x1_ex

```lua
function linalg.matmul_mat1x1_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x1_mat3x1

```lua
function linalg.matmul_mat1x1_mat3x1(a: avm.number1, b: avm.number3)
  -> number, number, number
```

Multiply a 1x1 matrix with a 3x1 matrix and return a 3x1 matrix

## matmul_mat1x1_mat3x1_ex

```lua
function linalg.matmul_mat1x1_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix

## matmul_mat1x1_mat3x1_ex

```lua
function linalg.matmul_mat1x1_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x1_mat4x1

```lua
function linalg.matmul_mat1x1_mat4x1(a: avm.number1, b: avm.number4)
  -> number * 4
```

Multiply a 1x1 matrix with a 4x1 matrix and return a 4x1 matrix

## matmul_mat1x1_mat4x1_ex

```lua
function linalg.matmul_mat1x1_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix

## matmul_mat1x1_mat4x1_ex

```lua
function linalg.matmul_mat1x1_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x1 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x2_mat1x1

```lua
function linalg.matmul_mat1x2_mat1x1(a: avm.number2, b: avm.number1)
  -> number, number
```

Multiply a 1x2 matrix with a 1x1 matrix and return a 1x2 matrix

## matmul_mat1x2_mat1x1_ex

```lua
function linalg.matmul_mat1x2_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix

## matmul_mat1x2_mat1x1_ex

```lua
function linalg.matmul_mat1x2_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x2_mat2x1

```lua
function linalg.matmul_mat1x2_mat2x1(a: avm.number2, b: avm.number2)
  -> number * 4
```

Multiply a 1x2 matrix with a 2x1 matrix and return a 2x2 matrix

## matmul_mat1x2_mat2x1_ex

```lua
function linalg.matmul_mat1x2_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix

## matmul_mat1x2_mat2x1_ex

```lua
function linalg.matmul_mat1x2_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x2_mat3x1

```lua
function linalg.matmul_mat1x2_mat3x1(a: avm.number2, b: avm.number3)
  -> number * 6
```

Multiply a 1x2 matrix with a 3x1 matrix and return a 3x2 matrix

## matmul_mat1x2_mat3x1_ex

```lua
function linalg.matmul_mat1x2_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x2_mat3x1_ex

```lua
function linalg.matmul_mat1x2_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 1x2 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x2 matrix

## matmul_mat1x2_mat4x1

```lua
function linalg.matmul_mat1x2_mat4x1(a: avm.number2, b: avm.number4)
  -> number * 8
```

Multiply a 1x2 matrix with a 4x1 matrix and return a 4x2 matrix

## matmul_mat1x2_mat4x1_ex

```lua
function linalg.matmul_mat1x2_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix

## matmul_mat1x2_mat4x1_ex

```lua
function linalg.matmul_mat1x2_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x2 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x3_mat1x1

```lua
function linalg.matmul_mat1x3_mat1x1(a: avm.number3, b: avm.number1)
  -> number, number, number
```

Multiply a 1x3 matrix with a 1x1 matrix and return a 1x3 matrix

## matmul_mat1x3_mat1x1_ex

```lua
function linalg.matmul_mat1x3_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix

## matmul_mat1x3_mat1x1_ex

```lua
function linalg.matmul_mat1x3_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x3_mat2x1

```lua
function linalg.matmul_mat1x3_mat2x1(a: avm.number3, b: avm.number2)
  -> number * 6
```

Multiply a 1x3 matrix with a 2x1 matrix and return a 2x3 matrix

## matmul_mat1x3_mat2x1_ex

```lua
function linalg.matmul_mat1x3_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x3_mat2x1_ex

```lua
function linalg.matmul_mat1x3_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 1x3 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x3 matrix

## matmul_mat1x3_mat3x1

```lua
function linalg.matmul_mat1x3_mat3x1(a: avm.number3, b: avm.number3)
  -> number * 9
```

Multiply a 1x3 matrix with a 3x1 matrix and return a 3x3 matrix

## matmul_mat1x3_mat3x1_ex

```lua
function linalg.matmul_mat1x3_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix

## matmul_mat1x3_mat3x1_ex

```lua
function linalg.matmul_mat1x3_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x3_mat4x1

```lua
function linalg.matmul_mat1x3_mat4x1(a: avm.number3, b: avm.number4)
  -> number * 12
```

Multiply a 1x3 matrix with a 4x1 matrix and return a 4x3 matrix

## matmul_mat1x3_mat4x1_ex

```lua
function linalg.matmul_mat1x3_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix

## matmul_mat1x3_mat4x1_ex

```lua
function linalg.matmul_mat1x3_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x3 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x4_mat1x1

```lua
function linalg.matmul_mat1x4_mat1x1(a: avm.number4, b: avm.number1)
  -> number * 4
```

Multiply a 1x4 matrix with a 1x1 matrix and return a 1x4 matrix

## matmul_mat1x4_mat1x1_ex

```lua
function linalg.matmul_mat1x4_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix

## matmul_mat1x4_mat1x1_ex

```lua
function linalg.matmul_mat1x4_mat1x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 1x1 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x4_mat2x1

```lua
function linalg.matmul_mat1x4_mat2x1(a: avm.number4, b: avm.number2)
  -> number * 8
```

Multiply a 1x4 matrix with a 2x1 matrix and return a 2x4 matrix

## matmul_mat1x4_mat2x1_ex

```lua
function linalg.matmul_mat1x4_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x4_mat2x1_ex

```lua
function linalg.matmul_mat1x4_mat2x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 1x4 matrix in an array or slice with a 2x1 matrix in an array or slice into a 2x4 matrix

## matmul_mat1x4_mat3x1

```lua
function linalg.matmul_mat1x4_mat3x1(a: avm.number4, b: avm.number3)
  -> number * 12
```

Multiply a 1x4 matrix with a 3x1 matrix and return a 3x4 matrix

## matmul_mat1x4_mat3x1_ex

```lua
function linalg.matmul_mat1x4_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix

## matmul_mat1x4_mat3x1_ex

```lua
function linalg.matmul_mat1x4_mat3x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 3x1 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat1x4_mat4x1

```lua
function linalg.matmul_mat1x4_mat4x1(a: avm.number4, b: avm.number4)
  -> number * 16
```

Multiply a 1x4 matrix with a 4x1 matrix and return a 4x4 matrix

## matmul_mat1x4_mat4x1_ex

```lua
function linalg.matmul_mat1x4_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix

## matmul_mat1x4_mat4x1_ex

```lua
function linalg.matmul_mat1x4_mat4x1_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 1x4 matrix in an array or slice with a 4x1 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2_mat2

```lua
function linalg.matmul_mat2_mat2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix

## matmul_mat2_mat2_ex

```lua
function linalg.matmul_mat2_mat2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix

## matmul_mat2_mat2_ex

```lua
function linalg.matmul_mat2_mat2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2_vec2

```lua
function linalg.matmul_mat2_vec2(a: avm.number4, v: avm.number2)
  -> number, number
```

Multiply a 2x2 matrix and a 2d vector and return a 2d vector

## matmul_mat2_vec2_ex

```lua
function linalg.matmul_mat2_vec2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer)
  -> number, number
```

Multiply a 2x2 matrix in a slice and a 2d vector in a slice and return a 2d vector

## matmul_mat2_vec2_ex

```lua
function linalg.matmul_mat2_vec2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> number, number
```

Multiply a 2x2 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination

## matmul_mat2x1_mat1x2

```lua
function linalg.matmul_mat2x1_mat1x2(a: avm.number2, b: avm.number2)
  -> number
```

Multiply a 2x1 matrix with a 1x2 matrix and return a 1x1 matrix

## matmul_mat2x1_mat1x2_ex

```lua
function linalg.matmul_mat2x1_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number
```

Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix

## matmul_mat2x1_mat1x2_ex

```lua
function linalg.matmul_mat2x1_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x1_mat2x2

```lua
function linalg.matmul_mat2x1_mat2x2(a: avm.number2, b: avm.number4)
  -> number, number
```

Multiply a 2x1 matrix with a 2x2 matrix and return a 2x1 matrix

## matmul_mat2x1_mat2x2_ex

```lua
function linalg.matmul_mat2x1_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix

## matmul_mat2x1_mat2x2_ex

```lua
function linalg.matmul_mat2x1_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x1_mat3x2

```lua
function linalg.matmul_mat2x1_mat3x2(a: avm.number2, b: avm.number6)
  -> number, number, number
```

Multiply a 2x1 matrix with a 3x2 matrix and return a 3x1 matrix

## matmul_mat2x1_mat3x2_ex

```lua
function linalg.matmul_mat2x1_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix

## matmul_mat2x1_mat3x2_ex

```lua
function linalg.matmul_mat2x1_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x1_mat4x2

```lua
function linalg.matmul_mat2x1_mat4x2(a: avm.number2, b: avm.number8)
  -> number * 4
```

Multiply a 2x1 matrix with a 4x2 matrix and return a 4x1 matrix

## matmul_mat2x1_mat4x2_ex

```lua
function linalg.matmul_mat2x1_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix

## matmul_mat2x1_mat4x2_ex

```lua
function linalg.matmul_mat2x1_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x1 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x2_mat1x2

```lua
function linalg.matmul_mat2x2_mat1x2(a: avm.number4, b: avm.number2)
  -> number, number
```

Multiply a 2x2 matrix with a 1x2 matrix and return a 1x2 matrix

## matmul_mat2x2_mat1x2_ex

```lua
function linalg.matmul_mat2x2_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix

## matmul_mat2x2_mat1x2_ex

```lua
function linalg.matmul_mat2x2_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x2_mat2x2

```lua
function linalg.matmul_mat2x2_mat2x2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Multiply a 2x2 matrix with a 2x2 matrix and return a 2x2 matrix

## matmul_mat2x2_mat2x2_ex

```lua
function linalg.matmul_mat2x2_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x2_mat2x2_ex

```lua
function linalg.matmul_mat2x2_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 2x2 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x2 matrix

## matmul_mat2x2_mat3x2

```lua
function linalg.matmul_mat2x2_mat3x2(a: avm.number4, b: avm.number6)
  -> number * 6
```

Multiply a 2x2 matrix with a 3x2 matrix and return a 3x2 matrix

## matmul_mat2x2_mat3x2_ex

```lua
function linalg.matmul_mat2x2_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix

## matmul_mat2x2_mat3x2_ex

```lua
function linalg.matmul_mat2x2_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x2_mat4x2

```lua
function linalg.matmul_mat2x2_mat4x2(a: avm.number4, b: avm.number8)
  -> number * 8
```

Multiply a 2x2 matrix with a 4x2 matrix and return a 4x2 matrix

## matmul_mat2x2_mat4x2_ex

```lua
function linalg.matmul_mat2x2_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix

## matmul_mat2x2_mat4x2_ex

```lua
function linalg.matmul_mat2x2_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x2 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x3_mat1x2

```lua
function linalg.matmul_mat2x3_mat1x2(a: avm.number6, b: avm.number2)
  -> number, number, number
```

Multiply a 2x3 matrix with a 1x2 matrix and return a 1x3 matrix

## matmul_mat2x3_mat1x2_ex

```lua
function linalg.matmul_mat2x3_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x3_mat1x2_ex

```lua
function linalg.matmul_mat2x3_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 2x3 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x3 matrix

## matmul_mat2x3_mat2x2

```lua
function linalg.matmul_mat2x3_mat2x2(a: avm.number6, b: avm.number4)
  -> number * 6
```

Multiply a 2x3 matrix with a 2x2 matrix and return a 2x3 matrix

## matmul_mat2x3_mat2x2_ex

```lua
function linalg.matmul_mat2x3_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix

## matmul_mat2x3_mat2x2_ex

```lua
function linalg.matmul_mat2x3_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x3_mat3x2

```lua
function linalg.matmul_mat2x3_mat3x2(a: avm.number6, b: avm.number6)
  -> number * 9
```

Multiply a 2x3 matrix with a 3x2 matrix and return a 3x3 matrix

## matmul_mat2x3_mat3x2_ex

```lua
function linalg.matmul_mat2x3_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix

## matmul_mat2x3_mat3x2_ex

```lua
function linalg.matmul_mat2x3_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x3_mat4x2

```lua
function linalg.matmul_mat2x3_mat4x2(a: avm.number6, b: avm.number8)
  -> number * 12
```

Multiply a 2x3 matrix with a 4x2 matrix and return a 4x3 matrix

## matmul_mat2x3_mat4x2_ex

```lua
function linalg.matmul_mat2x3_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix

## matmul_mat2x3_mat4x2_ex

```lua
function linalg.matmul_mat2x3_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x3 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x4_mat1x2

```lua
function linalg.matmul_mat2x4_mat1x2(a: avm.number8, b: avm.number2)
  -> number * 4
```

Multiply a 2x4 matrix with a 1x2 matrix and return a 1x4 matrix

## matmul_mat2x4_mat1x2_ex

```lua
function linalg.matmul_mat2x4_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x4_mat1x2_ex

```lua
function linalg.matmul_mat2x4_mat1x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 2x4 matrix in an array or slice with a 1x2 matrix in an array or slice into a 1x4 matrix

## matmul_mat2x4_mat2x2

```lua
function linalg.matmul_mat2x4_mat2x2(a: avm.number8, b: avm.number4)
  -> number * 8
```

Multiply a 2x4 matrix with a 2x2 matrix and return a 2x4 matrix

## matmul_mat2x4_mat2x2_ex

```lua
function linalg.matmul_mat2x4_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix

## matmul_mat2x4_mat2x2_ex

```lua
function linalg.matmul_mat2x4_mat2x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 2x2 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x4_mat3x2

```lua
function linalg.matmul_mat2x4_mat3x2(a: avm.number8, b: avm.number6)
  -> number * 12
```

Multiply a 2x4 matrix with a 3x2 matrix and return a 3x4 matrix

## matmul_mat2x4_mat3x2_ex

```lua
function linalg.matmul_mat2x4_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix

## matmul_mat2x4_mat3x2_ex

```lua
function linalg.matmul_mat2x4_mat3x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 3x2 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat2x4_mat4x2

```lua
function linalg.matmul_mat2x4_mat4x2(a: avm.number8, b: avm.number8)
  -> number * 16
```

Multiply a 2x4 matrix with a 4x2 matrix and return a 4x4 matrix

## matmul_mat2x4_mat4x2_ex

```lua
function linalg.matmul_mat2x4_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix

## matmul_mat2x4_mat4x2_ex

```lua
function linalg.matmul_mat2x4_mat4x2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 2x4 matrix in an array or slice with a 4x2 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3_mat3

```lua
function linalg.matmul_mat3_mat3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Multiply a 3x3 matrix with a 3x3 matrix and return a 3x3 matrix

## matmul_mat3_mat3_ex

```lua
function linalg.matmul_mat3_mat3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix

## matmul_mat3_mat3_ex

```lua
function linalg.matmul_mat3_mat3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3_vec2

```lua
function linalg.matmul_mat3_vec2(a: avm.number9, v: avm.number2)
  -> number, number
```

Multiply a 3x3 matrix and a 2d vector and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat3_vec2_ex

```lua
function linalg.matmul_mat3_vec2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer)
  -> number, number
```

Multiply a 3x3 matrix in a slice and a 2d vector in a slice and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat3_vec2_ex

```lua
function linalg.matmul_mat3_vec2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> number, number
```

Multiply a 3x3 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat3_vec3

```lua
function linalg.matmul_mat3_vec3(a: avm.number9, v: avm.number3)
  -> number, number, number
```

Multiply a 3x3 matrix and a 3d vector and return a 3d vector

## matmul_mat3_vec3_ex

```lua
function linalg.matmul_mat3_vec3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer)
  -> number, number, number
```

Multiply a 3x3 matrix in a slice and a 3d vector in a slice and return a 3d vector

## matmul_mat3_vec3_ex

```lua
function linalg.matmul_mat3_vec3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> number, number, number
```

Multiply a 3x3 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination

## matmul_mat3x1_mat1x3

```lua
function linalg.matmul_mat3x1_mat1x3(a: avm.number3, b: avm.number3)
  -> number
```

Multiply a 3x1 matrix with a 1x3 matrix and return a 1x1 matrix

## matmul_mat3x1_mat1x3_ex

```lua
function linalg.matmul_mat3x1_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number
```

Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix

## matmul_mat3x1_mat1x3_ex

```lua
function linalg.matmul_mat3x1_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x1_mat2x3

```lua
function linalg.matmul_mat3x1_mat2x3(a: avm.number3, b: avm.number6)
  -> number, number
```

Multiply a 3x1 matrix with a 2x3 matrix and return a 2x1 matrix

## matmul_mat3x1_mat2x3_ex

```lua
function linalg.matmul_mat3x1_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix

## matmul_mat3x1_mat2x3_ex

```lua
function linalg.matmul_mat3x1_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x1_mat3x3

```lua
function linalg.matmul_mat3x1_mat3x3(a: avm.number3, b: avm.number9)
  -> number, number, number
```

Multiply a 3x1 matrix with a 3x3 matrix and return a 3x1 matrix

## matmul_mat3x1_mat3x3_ex

```lua
function linalg.matmul_mat3x1_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix

## matmul_mat3x1_mat3x3_ex

```lua
function linalg.matmul_mat3x1_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x1_mat4x3

```lua
function linalg.matmul_mat3x1_mat4x3(a: avm.number3, b: avm.number12)
  -> number * 4
```

Multiply a 3x1 matrix with a 4x3 matrix and return a 4x1 matrix

## matmul_mat3x1_mat4x3_ex

```lua
function linalg.matmul_mat3x1_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x1_mat4x3_ex

```lua
function linalg.matmul_mat3x1_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 3x1 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x1 matrix

## matmul_mat3x2_mat1x3

```lua
function linalg.matmul_mat3x2_mat1x3(a: avm.number6, b: avm.number3)
  -> number, number
```

Multiply a 3x2 matrix with a 1x3 matrix and return a 1x2 matrix

## matmul_mat3x2_mat1x3_ex

```lua
function linalg.matmul_mat3x2_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix

## matmul_mat3x2_mat1x3_ex

```lua
function linalg.matmul_mat3x2_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x2_mat2x3

```lua
function linalg.matmul_mat3x2_mat2x3(a: avm.number6, b: avm.number6)
  -> number * 4
```

Multiply a 3x2 matrix with a 2x3 matrix and return a 2x2 matrix

## matmul_mat3x2_mat2x3_ex

```lua
function linalg.matmul_mat3x2_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix

## matmul_mat3x2_mat2x3_ex

```lua
function linalg.matmul_mat3x2_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x2_mat3x3

```lua
function linalg.matmul_mat3x2_mat3x3(a: avm.number6, b: avm.number9)
  -> number * 6
```

Multiply a 3x2 matrix with a 3x3 matrix and return a 3x2 matrix

## matmul_mat3x2_mat3x3_ex

```lua
function linalg.matmul_mat3x2_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x2_mat3x3_ex

```lua
function linalg.matmul_mat3x2_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 3x2 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x2 matrix

## matmul_mat3x2_mat4x3

```lua
function linalg.matmul_mat3x2_mat4x3(a: avm.number6, b: avm.number12)
  -> number * 8
```

Multiply a 3x2 matrix with a 4x3 matrix and return a 4x2 matrix

## matmul_mat3x2_mat4x3_ex

```lua
function linalg.matmul_mat3x2_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix

## matmul_mat3x2_mat4x3_ex

```lua
function linalg.matmul_mat3x2_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x2 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x3_mat1x3

```lua
function linalg.matmul_mat3x3_mat1x3(a: avm.number9, b: avm.number3)
  -> number, number, number
```

Multiply a 3x3 matrix with a 1x3 matrix and return a 1x3 matrix

## matmul_mat3x3_mat1x3_ex

```lua
function linalg.matmul_mat3x3_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix

## matmul_mat3x3_mat1x3_ex

```lua
function linalg.matmul_mat3x3_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x3_mat2x3

```lua
function linalg.matmul_mat3x3_mat2x3(a: avm.number9, b: avm.number6)
  -> number * 6
```

Multiply a 3x3 matrix with a 2x3 matrix and return a 2x3 matrix

## matmul_mat3x3_mat2x3_ex

```lua
function linalg.matmul_mat3x3_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix

## matmul_mat3x3_mat2x3_ex

```lua
function linalg.matmul_mat3x3_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x3_mat3x3

```lua
function linalg.matmul_mat3x3_mat3x3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Multiply a 3x3 matrix with a 3x3 matrix and return a 3x3 matrix

## matmul_mat3x3_mat3x3_ex

```lua
function linalg.matmul_mat3x3_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x3_mat3x3_ex

```lua
function linalg.matmul_mat3x3_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Multiply a 3x3 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x3 matrix

## matmul_mat3x3_mat4x3

```lua
function linalg.matmul_mat3x3_mat4x3(a: avm.number9, b: avm.number12)
  -> number * 12
```

Multiply a 3x3 matrix with a 4x3 matrix and return a 4x3 matrix

## matmul_mat3x3_mat4x3_ex

```lua
function linalg.matmul_mat3x3_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix

## matmul_mat3x3_mat4x3_ex

```lua
function linalg.matmul_mat3x3_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x3 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x4_mat1x3

```lua
function linalg.matmul_mat3x4_mat1x3(a: avm.number12, b: avm.number3)
  -> number * 4
```

Multiply a 3x4 matrix with a 1x3 matrix and return a 1x4 matrix

## matmul_mat3x4_mat1x3_ex

```lua
function linalg.matmul_mat3x4_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix

## matmul_mat3x4_mat1x3_ex

```lua
function linalg.matmul_mat3x4_mat1x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 1x3 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x4_mat2x3

```lua
function linalg.matmul_mat3x4_mat2x3(a: avm.number12, b: avm.number6)
  -> number * 8
```

Multiply a 3x4 matrix with a 2x3 matrix and return a 2x4 matrix

## matmul_mat3x4_mat2x3_ex

```lua
function linalg.matmul_mat3x4_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix

## matmul_mat3x4_mat2x3_ex

```lua
function linalg.matmul_mat3x4_mat2x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 2x3 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x4_mat3x3

```lua
function linalg.matmul_mat3x4_mat3x3(a: avm.number12, b: avm.number9)
  -> number * 12
```

Multiply a 3x4 matrix with a 3x3 matrix and return a 3x4 matrix

## matmul_mat3x4_mat3x3_ex

```lua
function linalg.matmul_mat3x4_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix

## matmul_mat3x4_mat3x3_ex

```lua
function linalg.matmul_mat3x4_mat3x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 3x3 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat3x4_mat4x3

```lua
function linalg.matmul_mat3x4_mat4x3(a: avm.number12, b: avm.number12)
  -> number * 16
```

Multiply a 3x4 matrix with a 4x3 matrix and return a 4x4 matrix

## matmul_mat3x4_mat4x3_ex

```lua
function linalg.matmul_mat3x4_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix

## matmul_mat3x4_mat4x3_ex

```lua
function linalg.matmul_mat3x4_mat4x3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 3x4 matrix in an array or slice with a 4x3 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4_mat4

```lua
function linalg.matmul_mat4_mat4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Multiply a 4x4 matrix with a 4x4 matrix and return a 4x4 matrix

## matmul_mat4_mat4_ex

```lua
function linalg.matmul_mat4_mat4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix

## matmul_mat4_mat4_ex

```lua
function linalg.matmul_mat4_mat4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4_vec2

```lua
function linalg.matmul_mat4_vec2(a: avm.number16, v: avm.number2)
  -> number, number
```

Multiply a 4x4 matrix and a 2d vector and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat4_vec2_ex

```lua
function linalg.matmul_mat4_vec2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer)
  -> number, number
```

Multiply a 4x4 matrix in a slice and a 2d vector in a slice and return a 2d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat4_vec2_ex

```lua
function linalg.matmul_mat4_vec2_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> number, number
```

Multiply a 4x4 matrix in a slice and a 2d vector in an array or slice into a 2d vector in a destination

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat4_vec3

```lua
function linalg.matmul_mat4_vec3(a: avm.number16, v: avm.number3)
  -> number, number, number
```

Multiply a 4x4 matrix and a 3d vector and return a 3d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat4_vec3_ex

```lua
function linalg.matmul_mat4_vec3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer)
  -> number, number, number
```

Multiply a 4x4 matrix in a slice and a 3d vector in a slice and return a 3d vector

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat4_vec3_ex

```lua
function linalg.matmul_mat4_vec3_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> number, number, number
```

Multiply a 4x4 matrix in a slice and a 3d vector in an array or slice into a 3d vector in a destination

Note: Vector is assumed to be in homogeneous coordinates with unspecified elements set to 1

## matmul_mat4_vec4

```lua
function linalg.matmul_mat4_vec4(a: avm.number16, v: avm.number4)
  -> number * 4
```

Multiply a 4x4 matrix and a 4d vector and return a 4d vector

## matmul_mat4_vec4_ex

```lua
function linalg.matmul_mat4_vec4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer)
  -> number * 4
```

Multiply a 4x4 matrix in a slice and a 4d vector in a slice and return a 4d vector

## matmul_mat4_vec4_ex

```lua
function linalg.matmul_mat4_vec4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, v: avm.seq_number|{ [integer]: number }, v_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> number * 4
```

Multiply a 4x4 matrix in a slice and a 4d vector in an array or slice into a 4d vector in a destination

## matmul_mat4x1_mat1x4

```lua
function linalg.matmul_mat4x1_mat1x4(a: avm.number4, b: avm.number4)
  -> number
```

Multiply a 4x1 matrix with a 1x4 matrix and return a 1x1 matrix

## matmul_mat4x1_mat1x4_ex

```lua
function linalg.matmul_mat4x1_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x1_mat1x4_ex

```lua
function linalg.matmul_mat4x1_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number
```

Multiply a 4x1 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x1 matrix

## matmul_mat4x1_mat2x4

```lua
function linalg.matmul_mat4x1_mat2x4(a: avm.number4, b: avm.number8)
  -> number, number
```

Multiply a 4x1 matrix with a 2x4 matrix and return a 2x1 matrix

## matmul_mat4x1_mat2x4_ex

```lua
function linalg.matmul_mat4x1_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix

## matmul_mat4x1_mat2x4_ex

```lua
function linalg.matmul_mat4x1_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x1_mat3x4

```lua
function linalg.matmul_mat4x1_mat3x4(a: avm.number4, b: avm.number12)
  -> number, number, number
```

Multiply a 4x1 matrix with a 3x4 matrix and return a 3x1 matrix

## matmul_mat4x1_mat3x4_ex

```lua
function linalg.matmul_mat4x1_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix

## matmul_mat4x1_mat3x4_ex

```lua
function linalg.matmul_mat4x1_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x1_mat4x4

```lua
function linalg.matmul_mat4x1_mat4x4(a: avm.number4, b: avm.number16)
  -> number * 4
```

Multiply a 4x1 matrix with a 4x4 matrix and return a 4x1 matrix

## matmul_mat4x1_mat4x4_ex

```lua
function linalg.matmul_mat4x1_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x1_mat4x4_ex

```lua
function linalg.matmul_mat4x1_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 4x1 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x1 matrix

## matmul_mat4x2_mat1x4

```lua
function linalg.matmul_mat4x2_mat1x4(a: avm.number8, b: avm.number4)
  -> number, number
```

Multiply a 4x2 matrix with a 1x4 matrix and return a 1x2 matrix

## matmul_mat4x2_mat1x4_ex

```lua
function linalg.matmul_mat4x2_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number
```

Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix

## matmul_mat4x2_mat1x4_ex

```lua
function linalg.matmul_mat4x2_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x2_mat2x4

```lua
function linalg.matmul_mat4x2_mat2x4(a: avm.number8, b: avm.number8)
  -> number * 4
```

Multiply a 4x2 matrix with a 2x4 matrix and return a 2x2 matrix

## matmul_mat4x2_mat2x4_ex

```lua
function linalg.matmul_mat4x2_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix

## matmul_mat4x2_mat2x4_ex

```lua
function linalg.matmul_mat4x2_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x2_mat3x4

```lua
function linalg.matmul_mat4x2_mat3x4(a: avm.number8, b: avm.number12)
  -> number * 6
```

Multiply a 4x2 matrix with a 3x4 matrix and return a 3x2 matrix

## matmul_mat4x2_mat3x4_ex

```lua
function linalg.matmul_mat4x2_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix

## matmul_mat4x2_mat3x4_ex

```lua
function linalg.matmul_mat4x2_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x2_mat4x4

```lua
function linalg.matmul_mat4x2_mat4x4(a: avm.number8, b: avm.number16)
  -> number * 8
```

Multiply a 4x2 matrix with a 4x4 matrix and return a 4x2 matrix

## matmul_mat4x2_mat4x4_ex

```lua
function linalg.matmul_mat4x2_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x2_mat4x4_ex

```lua
function linalg.matmul_mat4x2_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 4x2 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x2 matrix

## matmul_mat4x3_mat1x4

```lua
function linalg.matmul_mat4x3_mat1x4(a: avm.number12, b: avm.number4)
  -> number, number, number
```

Multiply a 4x3 matrix with a 1x4 matrix and return a 1x3 matrix

## matmul_mat4x3_mat1x4_ex

```lua
function linalg.matmul_mat4x3_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix

## matmul_mat4x3_mat1x4_ex

```lua
function linalg.matmul_mat4x3_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x3_mat2x4

```lua
function linalg.matmul_mat4x3_mat2x4(a: avm.number12, b: avm.number8)
  -> number * 6
```

Multiply a 4x3 matrix with a 2x4 matrix and return a 2x3 matrix

## matmul_mat4x3_mat2x4_ex

```lua
function linalg.matmul_mat4x3_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 6
```

Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix

## matmul_mat4x3_mat2x4_ex

```lua
function linalg.matmul_mat4x3_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x3_mat3x4

```lua
function linalg.matmul_mat4x3_mat3x4(a: avm.number12, b: avm.number12)
  -> number * 9
```

Multiply a 4x3 matrix with a 3x4 matrix and return a 3x3 matrix

## matmul_mat4x3_mat3x4_ex

```lua
function linalg.matmul_mat4x3_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix

## matmul_mat4x3_mat3x4_ex

```lua
function linalg.matmul_mat4x3_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x3_mat4x4

```lua
function linalg.matmul_mat4x3_mat4x4(a: avm.number12, b: avm.number16)
  -> number * 12
```

Multiply a 4x3 matrix with a 4x4 matrix and return a 4x3 matrix

## matmul_mat4x3_mat4x4_ex

```lua
function linalg.matmul_mat4x3_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix

## matmul_mat4x3_mat4x4_ex

```lua
function linalg.matmul_mat4x3_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x3 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x3 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x4_mat1x4

```lua
function linalg.matmul_mat4x4_mat1x4(a: avm.number16, b: avm.number4)
  -> number * 4
```

Multiply a 4x4 matrix with a 1x4 matrix and return a 1x4 matrix

## matmul_mat4x4_mat1x4_ex

```lua
function linalg.matmul_mat4x4_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix

## matmul_mat4x4_mat1x4_ex

```lua
function linalg.matmul_mat4x4_mat1x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 1x4 matrix in an array or slice into a 1x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x4_mat2x4

```lua
function linalg.matmul_mat4x4_mat2x4(a: avm.number16, b: avm.number8)
  -> number * 8
```

Multiply a 4x4 matrix with a 2x4 matrix and return a 2x4 matrix

## matmul_mat4x4_mat2x4_ex

```lua
function linalg.matmul_mat4x4_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 8
```

Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix

## matmul_mat4x4_mat2x4_ex

```lua
function linalg.matmul_mat4x4_mat2x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 2x4 matrix in an array or slice into a 2x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x4_mat3x4

```lua
function linalg.matmul_mat4x4_mat3x4(a: avm.number16, b: avm.number12)
  -> number * 12
```

Multiply a 4x4 matrix with a 3x4 matrix and return a 3x4 matrix

## matmul_mat4x4_mat3x4_ex

```lua
function linalg.matmul_mat4x4_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## matmul_mat4x4_mat3x4_ex

```lua
function linalg.matmul_mat4x4_mat3x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 12
```

Multiply a 4x4 matrix in an array or slice with a 3x4 matrix in an array or slice into a 3x4 matrix

## matmul_mat4x4_mat4x4

```lua
function linalg.matmul_mat4x4_mat4x4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Multiply a 4x4 matrix with a 4x4 matrix and return a 4x4 matrix

## matmul_mat4x4_mat4x4_ex

```lua
function linalg.matmul_mat4x4_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix

## matmul_mat4x4_mat4x4_ex

```lua
function linalg.matmul_mat4x4_mat4x4_ex(a: avm.seq_number|{ [integer]: number }, a_index: integer, b: avm.seq_number|{ [integer]: number }, b_index: integer, dest: avm.seq_number|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Multiply a 4x4 matrix in an array or slice with a 4x4 matrix in an array or slice into a 4x4 matrix in a destination

NOTE: `dest` cannot overlap `a` or `b` or results will be undefined

## mul_2

```lua
function linalg.mul_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the multiplication operator to two 2-tuples

## mul_3

```lua
function linalg.mul_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the multiplication operator to two 3-tuples

## mul_4

```lua
function linalg.mul_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the multiplication operator to two 4-tuples

## mul_mat2

```lua
function linalg.mul_mat2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the multiplication operator to each element in two 2x2 matrices

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat2_constant

```lua
function linalg.mul_mat2_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the multiplication operator to each element in a 2x2 matrix and a constant

## mul_mat2_constant_ex

```lua
function linalg.mul_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant

## mul_mat2_constant_ex

```lua
function linalg.mul_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## mul_mat2_ex

```lua
function linalg.mul_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the multiplication operator to each element in two 2x2 matrices in a slice

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat2_ex

```lua
function linalg.mul_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in two 2d-vectors in a slice and store the result in a destination

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat3

```lua
function linalg.mul_mat3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Apply the multiplication operator to each element in two 3x3 matrices

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat3_constant

```lua
function linalg.mul_mat3_constant(a: avm.number9, c: number)
  -> number * 9
```

Apply the multiplication operator to each element in a 3x3 matrix and a constant

## mul_mat3_constant_ex

```lua
function linalg.mul_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number)
  -> number * 9
```

Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant

## mul_mat3_constant_ex

```lua
function linalg.mul_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## mul_mat3_ex

```lua
function linalg.mul_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Apply the multiplication operator to each element in two 3x3 matrices in a slice

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat3_ex

```lua
function linalg.mul_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number9|{ [integer]: number }, b_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in two 3d-vectors in a slice and store the result in a destination

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat4

```lua
function linalg.mul_mat4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Apply the multiplication operator to each element in two 4x4 matrices

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat4_constant

```lua
function linalg.mul_mat4_constant(a: avm.number16, c: number)
  -> number * 16
```

Apply the multiplication operator to each element in a 4x4 matrix and a constant

## mul_mat4_constant_ex

```lua
function linalg.mul_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number)
  -> number * 16
```

Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant

## mul_mat4_constant_ex

```lua
function linalg.mul_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## mul_mat4_ex

```lua
function linalg.mul_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Apply the multiplication operator to each element in two 4x4 matrices in a slice

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_mat4_ex

```lua
function linalg.mul_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number16|{ [integer]: number }, b_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to each element in two 4d-vectors in a slice and store the result in a destination

Note: This is element-wise multiplication, for standard matrix multiplication see `linalg.matmul`

## mul_vec2

```lua
function linalg.mul_vec2(a: avm.number2, b: avm.number2)
  -> number, number
```

Apply the multiplication operator to two 2d-vectors

## mul_vec2_constant

```lua
function linalg.mul_vec2_constant(a: avm.number2, c: number)
  -> number, number
```

Apply the multiplication operator to a 2d-vector and a constant

## mul_vec2_constant_ex

```lua
function linalg.mul_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to a 2d-vector in a slice and a constant and store in a destination

## mul_vec2_constant_ex

```lua
function linalg.mul_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number)
  -> number, number
```

Apply the multiplication operator to a 2d-vector in a slice and a constant

## mul_vec2_ex

```lua
function linalg.mul_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two 2d-vectors in a slice and store the result in a destination

## mul_vec2_ex

```lua
function linalg.mul_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number, number
```

Apply the multiplication operator to two 2d-vectors in a slice

## mul_vec3

```lua
function linalg.mul_vec3(a: avm.number3, b: avm.number3)
  -> number, number, number
```

Apply the multiplication operator to two 3d-vectors

## mul_vec3_constant

```lua
function linalg.mul_vec3_constant(a: avm.number3, c: number)
  -> number, number, number
```

Apply the multiplication operator to a 3d-vector and a constant

## mul_vec3_constant_ex

```lua
function linalg.mul_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to a 3d-vector in a slice and a constant and store in a destination

## mul_vec3_constant_ex

```lua
function linalg.mul_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number)
  -> number, number, number
```

Apply the multiplication operator to a 3d-vector in a slice and a constant

## mul_vec3_ex

```lua
function linalg.mul_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Apply the multiplication operator to two 3d-vectors in a slice

## mul_vec3_ex

```lua
function linalg.mul_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two 3d-vectors in a slice and store the result in a destination

## mul_vec4

```lua
function linalg.mul_vec4(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the multiplication operator to two 4d-vectors

## mul_vec4_constant

```lua
function linalg.mul_vec4_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the multiplication operator to a 4d-vector and a constant

## mul_vec4_constant_ex

```lua
function linalg.mul_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the multiplication operator to a 4d-vector in a slice and a constant

## mul_vec4_constant_ex

```lua
function linalg.mul_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to a 4d-vector in a slice and a constant and store in a destination

## mul_vec4_ex

```lua
function linalg.mul_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the multiplication operator to two 4d-vectors in a slice

## mul_vec4_ex

```lua
function linalg.mul_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the multiplication operator to two 4d-vectors in a slice and store the result in a destination

## negate_mat2

```lua
function linalg.negate_mat2(a: avm.number4)
  -> number * 4
```

Negate a 2x2 matrix

## negate_mat2_ex

```lua
function linalg.negate_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer)
  -> number * 4
```

Negate a 2x2 matrix in a slice

## negate_mat2_ex

```lua
function linalg.negate_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Negate a 2x2 matrix in a slice and store the result in a destination

## negate_mat3

```lua
function linalg.negate_mat3(a: avm.number9)
  -> number * 9
```

Negate a 3x3 matrix

## negate_mat3_ex

```lua
function linalg.negate_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer)
  -> number * 9
```

Negate a 3x3 matrix in a slice

## negate_mat3_ex

```lua
function linalg.negate_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Negate a 3x3 matrix in a slice and store the result in a destination

## negate_mat4

```lua
function linalg.negate_mat4(a: avm.number16)
  -> number * 16
```

Negate a 4x4 matrix

## negate_mat4_ex

```lua
function linalg.negate_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer)
  -> number * 16
```

Negate a 4x4 matrix in a slice

## negate_mat4_ex

```lua
function linalg.negate_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Negate a 4x4 matrix in a slice and store the result in a destination

## negate_vec2

```lua
function linalg.negate_vec2(a: avm.number2)
  -> number, number
```

Negate a 2d-vector

## negate_vec2_ex

```lua
function linalg.negate_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer)
  -> number, number
```

Negate a 2d-vector in a slice

## negate_vec2_ex

```lua
function linalg.negate_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Negate a 2d-vector in a slice and store the result in a destination

## negate_vec3

```lua
function linalg.negate_vec3(a: avm.number3)
  -> number, number, number
```

Negate a 3d-vector

## negate_vec3_ex

```lua
function linalg.negate_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer)
  -> number, number, number
```

Negate a 3d-vector in a slice

## negate_vec3_ex

```lua
function linalg.negate_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Negate a 3d-vector in a slice and store the result in a destination

## negate_vec4

```lua
function linalg.negate_vec4(a: avm.number4)
  -> number * 4
```

Negate a 4d-vector

## negate_vec4_ex

```lua
function linalg.negate_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer)
  -> number * 4
```

Negate a 4d-vector in a slice

## negate_vec4_ex

```lua
function linalg.negate_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Negate a 4d-vector in a slice and store the result in a destination

## normalise_2

```lua
function linalg.normalise_2(v1: number, v2: number)
  -> number, number
```

Normalise 2d vector

## normalise_3

```lua
function linalg.normalise_3(v1: number, v2: number, v3: number)
  -> number, number, number
```

Normalise 3d vector

## normalise_4

```lua
function linalg.normalise_4(v1: number, v2: number, v3: number, v4: number)
  -> number * 4
```

Normalise 4d vector

## normalise_vec2

```lua
function linalg.normalise_vec2(v: avm.number2)
  -> number, number
```

Normalise 2d vector

## normalise_vec2_ex

```lua
function linalg.normalise_vec2_ex(v: avm.seq_number2|{ [integer]: number }, v_index: integer)
  -> number, number
```

Normalise 2d vector in a slice

## normalise_vec2_ex

```lua
function linalg.normalise_vec2_ex(v: avm.seq_number2|{ [integer]: number }, v_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Normalise 2d vector in a slice into a destination

## normalise_vec3

```lua
function linalg.normalise_vec3(v: avm.number3)
  -> number, number, number
```

Normalise 3d vector

## normalise_vec3_ex

```lua
function linalg.normalise_vec3_ex(v: avm.seq_number3|{ [integer]: number }, v_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Normalise 3d vector in a slice into a destination

## normalise_vec3_ex

```lua
function linalg.normalise_vec3_ex(v: avm.seq_number3|{ [integer]: number }, v_index: integer)
  -> number, number, number
```

Normalise 3d vector in a slice

## normalise_vec4

```lua
function linalg.normalise_vec4(v: avm.number4)
  -> number * 4
```

Normalise 4d vector

## normalise_vec4_ex

```lua
function linalg.normalise_vec4_ex(v: avm.seq_number4|{ [integer]: number }, v_index: integer)
  -> number * 4
```

Normalise 4d vector in a slice

## normalise_vec4_ex

```lua
function linalg.normalise_vec4_ex(v: avm.seq_number4|{ [integer]: number }, v_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Normalise 4d vector in a slice into a destination

## pow_2

```lua
function linalg.pow_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the exponentiation operator to two 2-tuples

## pow_3

```lua
function linalg.pow_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the exponentiation operator to two 3-tuples

## pow_4

```lua
function linalg.pow_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the exponentiation operator to two 4-tuples

## pow_mat2

```lua
function linalg.pow_mat2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the exponentiation operator to each element in two 2x2 matrices

## pow_mat2_constant

```lua
function linalg.pow_mat2_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the exponentiation operator to each element in a 2x2 matrix and a constant

## pow_mat2_constant_ex

```lua
function linalg.pow_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant

## pow_mat2_constant_ex

```lua
function linalg.pow_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## pow_mat2_ex

```lua
function linalg.pow_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the exponentiation operator to each element in two 2x2 matrices in a slice

## pow_mat2_ex

```lua
function linalg.pow_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in two 2d-vectors in a slice and store the result in a destination

## pow_mat3

```lua
function linalg.pow_mat3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Apply the exponentiation operator to each element in two 3x3 matrices

## pow_mat3_constant

```lua
function linalg.pow_mat3_constant(a: avm.number9, c: number)
  -> number * 9
```

Apply the exponentiation operator to each element in a 3x3 matrix and a constant

## pow_mat3_constant_ex

```lua
function linalg.pow_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## pow_mat3_constant_ex

```lua
function linalg.pow_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number)
  -> number * 9
```

Apply the exponentiation operator to each element in a 3x3 matrix in a slice and a constant

## pow_mat3_ex

```lua
function linalg.pow_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number9|{ [integer]: number }, b_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in two 3d-vectors in a slice and store the result in a destination

## pow_mat3_ex

```lua
function linalg.pow_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Apply the exponentiation operator to each element in two 3x3 matrices in a slice

## pow_mat4

```lua
function linalg.pow_mat4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Apply the exponentiation operator to each element in two 4x4 matrices

## pow_mat4_constant

```lua
function linalg.pow_mat4_constant(a: avm.number16, c: number)
  -> number * 16
```

Apply the exponentiation operator to each element in a 4x4 matrix and a constant

## pow_mat4_constant_ex

```lua
function linalg.pow_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number)
  -> number * 16
```

Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant

## pow_mat4_constant_ex

```lua
function linalg.pow_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## pow_mat4_ex

```lua
function linalg.pow_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Apply the exponentiation operator to each element in two 4x4 matrices in a slice

## pow_mat4_ex

```lua
function linalg.pow_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number16|{ [integer]: number }, b_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to each element in two 4d-vectors in a slice and store the result in a destination

## pow_vec2

```lua
function linalg.pow_vec2(a: avm.number2, b: avm.number2)
  -> number, number
```

Apply the exponentiation operator to two 2d-vectors

## pow_vec2_constant

```lua
function linalg.pow_vec2_constant(a: avm.number2, c: number)
  -> number, number
```

Apply the exponentiation operator to a 2d-vector and a constant

## pow_vec2_constant_ex

```lua
function linalg.pow_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number)
  -> number, number
```

Apply the exponentiation operator to a 2d-vector in a slice and a constant

## pow_vec2_constant_ex

```lua
function linalg.pow_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to a 2d-vector in a slice and a constant and store in a destination

## pow_vec2_ex

```lua
function linalg.pow_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number, number
```

Apply the exponentiation operator to two 2d-vectors in a slice

## pow_vec2_ex

```lua
function linalg.pow_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two 2d-vectors in a slice and store the result in a destination

## pow_vec3

```lua
function linalg.pow_vec3(a: avm.number3, b: avm.number3)
  -> number, number, number
```

Apply the exponentiation operator to two 3d-vectors

## pow_vec3_constant

```lua
function linalg.pow_vec3_constant(a: avm.number3, c: number)
  -> number, number, number
```

Apply the exponentiation operator to a 3d-vector and a constant

## pow_vec3_constant_ex

```lua
function linalg.pow_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number)
  -> number, number, number
```

Apply the exponentiation operator to a 3d-vector in a slice and a constant

## pow_vec3_constant_ex

```lua
function linalg.pow_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to a 3d-vector in a slice and a constant and store in a destination

## pow_vec3_ex

```lua
function linalg.pow_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Apply the exponentiation operator to two 3d-vectors in a slice

## pow_vec3_ex

```lua
function linalg.pow_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two 3d-vectors in a slice and store the result in a destination

## pow_vec4

```lua
function linalg.pow_vec4(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the exponentiation operator to two 4d-vectors

## pow_vec4_constant

```lua
function linalg.pow_vec4_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the exponentiation operator to a 4d-vector and a constant

## pow_vec4_constant_ex

```lua
function linalg.pow_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the exponentiation operator to a 4d-vector in a slice and a constant

## pow_vec4_constant_ex

```lua
function linalg.pow_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to a 4d-vector in a slice and a constant and store in a destination

## pow_vec4_ex

```lua
function linalg.pow_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the exponentiation operator to two 4d-vectors in a slice

## pow_vec4_ex

```lua
function linalg.pow_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the exponentiation operator to two 4d-vectors in a slice and store the result in a destination

## sub_2

```lua
function linalg.sub_2(a1: number, a2: number, b1: number, b2: number)
  -> number, number
```

Apply the subtraction operator to two 2-tuples

## sub_3

```lua
function linalg.sub_3(a1: number, a2: number, a3: number, b1: number, b2: number, b3: number)
  -> number, number, number
```

Apply the subtraction operator to two 3-tuples

## sub_4

```lua
function linalg.sub_4(a1: number, a2: number, a3: number, a4: number, b1: number, b2: number, b3: number, b4: number)
  -> number * 4
```

Apply the subtraction operator to two 4-tuples

## sub_mat2

```lua
function linalg.sub_mat2(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the subtraction operator to each element in two 2x2 matrices

## sub_mat2_constant

```lua
function linalg.sub_mat2_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the subtraction operator to each element in a 2x2 matrix and a constant

## sub_mat2_constant_ex

```lua
function linalg.sub_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant

## sub_mat2_constant_ex

```lua
function linalg.sub_mat2_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in a 2x2 matrix in a slice and a constant and store in a destination

## sub_mat2_ex

```lua
function linalg.sub_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the subtraction operator to each element in two 2x2 matrices in a slice

## sub_mat2_ex

```lua
function linalg.sub_mat2_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in two 2d-vectors in a slice and store the result in a destination

## sub_mat3

```lua
function linalg.sub_mat3(a: avm.number9, b: avm.number9)
  -> number * 9
```

Apply the subtraction operator to each element in two 3x3 matrices

## sub_mat3_constant

```lua
function linalg.sub_mat3_constant(a: avm.number9, c: number)
  -> number * 9
```

Apply the subtraction operator to each element in a 3x3 matrix and a constant

## sub_mat3_constant_ex

```lua
function linalg.sub_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant and store in a destination

## sub_mat3_constant_ex

```lua
function linalg.sub_mat3_constant_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, c: number)
  -> number * 9
```

Apply the subtraction operator to each element in a 3x3 matrix in a slice and a constant

## sub_mat3_ex

```lua
function linalg.sub_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number9|{ [integer]: number }, b_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in two 3d-vectors in a slice and store the result in a destination

## sub_mat3_ex

```lua
function linalg.sub_mat3_ex(a: avm.seq_number9|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number * 9
```

Apply the subtraction operator to each element in two 3x3 matrices in a slice

## sub_mat4

```lua
function linalg.sub_mat4(a: avm.number16, b: avm.number16)
  -> number * 16
```

Apply the subtraction operator to each element in two 4x4 matrices

## sub_mat4_constant

```lua
function linalg.sub_mat4_constant(a: avm.number16, c: number)
  -> number * 16
```

Apply the subtraction operator to each element in a 4x4 matrix and a constant

## sub_mat4_constant_ex

```lua
function linalg.sub_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant and store in a destination

## sub_mat4_constant_ex

```lua
function linalg.sub_mat4_constant_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, c: number)
  -> number * 16
```

Apply the subtraction operator to each element in a 4x4 matrix in a slice and a constant

## sub_mat4_ex

```lua
function linalg.sub_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 16
```

Apply the subtraction operator to each element in two 4x4 matrices in a slice

## sub_mat4_ex

```lua
function linalg.sub_mat4_ex(a: avm.seq_number16|{ [integer]: number }, a_index: integer, b: avm.seq_number16|{ [integer]: number }, b_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to each element in two 4d-vectors in a slice and store the result in a destination

## sub_vec2

```lua
function linalg.sub_vec2(a: avm.number2, b: avm.number2)
  -> number, number
```

Apply the subtraction operator to two 2d-vectors

## sub_vec2_constant

```lua
function linalg.sub_vec2_constant(a: avm.number2, c: number)
  -> number, number
```

Apply the subtraction operator to a 2d-vector and a constant

## sub_vec2_constant_ex

```lua
function linalg.sub_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number)
  -> number, number
```

Apply the subtraction operator to a 2d-vector in a slice and a constant

## sub_vec2_constant_ex

```lua
function linalg.sub_vec2_constant_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to a 2d-vector in a slice and a constant and store in a destination

## sub_vec2_ex

```lua
function linalg.sub_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer)
  -> number, number
```

Apply the subtraction operator to two 2d-vectors in a slice

## sub_vec2_ex

```lua
function linalg.sub_vec2_ex(a: avm.seq_number2|{ [integer]: number }, a_index: integer, b: avm.seq_number2|{ [integer]: number }, b_index: integer, dest: avm.seq_number2|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two 2d-vectors in a slice and store the result in a destination

## sub_vec3

```lua
function linalg.sub_vec3(a: avm.number3, b: avm.number3)
  -> number, number, number
```

Apply the subtraction operator to two 3d-vectors

## sub_vec3_constant

```lua
function linalg.sub_vec3_constant(a: avm.number3, c: number)
  -> number, number, number
```

Apply the subtraction operator to a 3d-vector and a constant

## sub_vec3_constant_ex

```lua
function linalg.sub_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to a 3d-vector in a slice and a constant and store in a destination

## sub_vec3_constant_ex

```lua
function linalg.sub_vec3_constant_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, c: number)
  -> number, number, number
```

Apply the subtraction operator to a 3d-vector in a slice and a constant

## sub_vec3_ex

```lua
function linalg.sub_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer, dest: avm.seq_number3|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two 3d-vectors in a slice and store the result in a destination

## sub_vec3_ex

```lua
function linalg.sub_vec3_ex(a: avm.seq_number3|{ [integer]: number }, a_index: integer, b: avm.seq_number3|{ [integer]: number }, b_index: integer)
  -> number, number, number
```

Apply the subtraction operator to two 3d-vectors in a slice

## sub_vec4

```lua
function linalg.sub_vec4(a: avm.number4, b: avm.number4)
  -> number * 4
```

Apply the subtraction operator to two 4d-vectors

## sub_vec4_constant

```lua
function linalg.sub_vec4_constant(a: avm.number4, c: number)
  -> number * 4
```

Apply the subtraction operator to a 4d-vector and a constant

## sub_vec4_constant_ex

```lua
function linalg.sub_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to a 4d-vector in a slice and a constant and store in a destination

## sub_vec4_constant_ex

```lua
function linalg.sub_vec4_constant_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, c: number)
  -> number * 4
```

Apply the subtraction operator to a 4d-vector in a slice and a constant

## sub_vec4_ex

```lua
function linalg.sub_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer)
  -> number * 4
```

Apply the subtraction operator to two 4d-vectors in a slice

## sub_vec4_ex

```lua
function linalg.sub_vec4_ex(a: avm.seq_number4|{ [integer]: number }, a_index: integer, b: avm.seq_number4|{ [integer]: number }, b_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Apply the subtraction operator to two 4d-vectors in a slice and store the result in a destination

## transpose_mat1

```lua
function linalg.transpose_mat1(src: avm.number1)
  -> number
```

Transpose a 1x1 matrix and return a 1x1 matrix

@*return* — (mat1)

## transpose_mat1x1

```lua
function linalg.transpose_mat1x1(src: avm.number1)
  -> number
```

Transpose a 1x1 matrix and return a 1x1 matrix

@*return* — (mat1x1)

## transpose_mat1x2

```lua
function linalg.transpose_mat1x2(src: avm.number2)
  -> number, number
```

Transpose a 1x2 matrix and return a 2x1 matrix

@*return* — (mat2x1)

## transpose_mat1x3

```lua
function linalg.transpose_mat1x3(src: avm.number3)
  -> number, number, number
```

Transpose a 1x3 matrix and return a 3x1 matrix

@*return* — (mat3x1)

## transpose_mat1x4

```lua
function linalg.transpose_mat1x4(src: avm.number4)
  -> number * 4
```

Transpose a 1x4 matrix and return a 4x1 matrix

@*return* — (mat4x1)

## transpose_mat2

```lua
function linalg.transpose_mat2(src: avm.number4)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2)

## transpose_mat2_ex

```lua
function linalg.transpose_mat2_ex(src: avm.seq_number4|{ [integer]: number }, src_index: integer)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2)

## transpose_mat2_ex

```lua
function linalg.transpose_mat2_ex(src: avm.seq_number4|{ [integer]: number }, src_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 2x2 matrix into a 2x2 matrix in a destination

## transpose_mat2x1

```lua
function linalg.transpose_mat2x1(src: avm.number2)
  -> number, number
```

Transpose a 2x1 matrix and return a 1x2 matrix

@*return* — (mat1x2)

## transpose_mat2x2

```lua
function linalg.transpose_mat2x2(src: avm.number4)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2x2)

## transpose_mat2x2_ex

```lua
function linalg.transpose_mat2x2_ex(src: avm.seq_number4|{ [integer]: number }, src_index: integer)
  -> number * 4
```

Transpose a 2x2 matrix and return a 2x2 matrix

@*return* — (mat2x2)

## transpose_mat2x2_ex

```lua
function linalg.transpose_mat2x2_ex(src: avm.seq_number4|{ [integer]: number }, src_index: integer, dest: avm.seq_number4|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 2x2 matrix into a 2x2 matrix in a destination

## transpose_mat2x3

```lua
function linalg.transpose_mat2x3(src: avm.number6)
  -> number * 6
```

Transpose a 2x3 matrix and return a 3x2 matrix

@*return* — (mat3x2)

## transpose_mat2x3_ex

```lua
function linalg.transpose_mat2x3_ex(src: avm.seq_number6|{ [integer]: number }, src_index: integer, dest: avm.seq_number6|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 2x3 matrix into a 3x2 matrix in a destination

## transpose_mat2x3_ex

```lua
function linalg.transpose_mat2x3_ex(src: avm.seq_number6|{ [integer]: number }, src_index: integer)
  -> number * 6
```

Transpose a 2x3 matrix and return a 3x2 matrix

@*return* — (mat3x2)

## transpose_mat2x4

```lua
function linalg.transpose_mat2x4(src: avm.number8)
  -> number * 8
```

Transpose a 2x4 matrix and return a 4x2 matrix

@*return* — (mat4x2)

## transpose_mat2x4_ex

```lua
function linalg.transpose_mat2x4_ex(src: avm.seq_number8|{ [integer]: number }, src_index: integer)
  -> number * 8
```

Transpose a 2x4 matrix and return a 4x2 matrix

@*return* — (mat4x2)

## transpose_mat2x4_ex

```lua
function linalg.transpose_mat2x4_ex(src: avm.seq_number8|{ [integer]: number }, src_index: integer, dest: avm.seq_number8|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 2x4 matrix into a 4x2 matrix in a destination

## transpose_mat3

```lua
function linalg.transpose_mat3(src: avm.number9)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3)

## transpose_mat3_ex

```lua
function linalg.transpose_mat3_ex(src: avm.seq_number9|{ [integer]: number }, src_index: integer)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3)

## transpose_mat3_ex

```lua
function linalg.transpose_mat3_ex(src: avm.seq_number9|{ [integer]: number }, src_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 3x3 matrix into a 3x3 matrix in a destination

## transpose_mat3x1

```lua
function linalg.transpose_mat3x1(src: avm.number3)
  -> number, number, number
```

Transpose a 3x1 matrix and return a 1x3 matrix

@*return* — (mat1x3)

## transpose_mat3x2

```lua
function linalg.transpose_mat3x2(src: avm.number6)
  -> number * 6
```

Transpose a 3x2 matrix and return a 2x3 matrix

@*return* — (mat2x3)

## transpose_mat3x2_ex

```lua
function linalg.transpose_mat3x2_ex(src: avm.seq_number6|{ [integer]: number }, src_index: integer)
  -> number * 6
```

Transpose a 3x2 matrix and return a 2x3 matrix

@*return* — (mat2x3)

## transpose_mat3x2_ex

```lua
function linalg.transpose_mat3x2_ex(src: avm.seq_number6|{ [integer]: number }, src_index: integer, dest: avm.seq_number6|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 3x2 matrix into a 2x3 matrix in a destination

## transpose_mat3x3

```lua
function linalg.transpose_mat3x3(src: avm.number9)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3x3)

## transpose_mat3x3_ex

```lua
function linalg.transpose_mat3x3_ex(src: avm.seq_number9|{ [integer]: number }, src_index: integer, dest: avm.seq_number9|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 3x3 matrix into a 3x3 matrix in a destination

## transpose_mat3x3_ex

```lua
function linalg.transpose_mat3x3_ex(src: avm.seq_number9|{ [integer]: number }, src_index: integer)
  -> number * 9
```

Transpose a 3x3 matrix and return a 3x3 matrix

@*return* — (mat3x3)

## transpose_mat3x4

```lua
function linalg.transpose_mat3x4(src: avm.number12)
  -> number * 12
```

Transpose a 3x4 matrix and return a 4x3 matrix

@*return* — (mat4x3)

## transpose_mat3x4_ex

```lua
function linalg.transpose_mat3x4_ex(src: avm.seq_number12|{ [integer]: number }, src_index: integer)
  -> number * 12
```

Transpose a 3x4 matrix and return a 4x3 matrix

@*return* — (mat4x3)

## transpose_mat3x4_ex

```lua
function linalg.transpose_mat3x4_ex(src: avm.seq_number12|{ [integer]: number }, src_index: integer, dest: avm.seq_number12|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 3x4 matrix into a 4x3 matrix in a destination

## transpose_mat4

```lua
function linalg.transpose_mat4(src: avm.number16)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4)

## transpose_mat4_ex

```lua
function linalg.transpose_mat4_ex(src: avm.seq_number16|{ [integer]: number }, src_index: integer)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4)

## transpose_mat4_ex

```lua
function linalg.transpose_mat4_ex(src: avm.seq_number16|{ [integer]: number }, src_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 4x4 matrix into a 4x4 matrix in a destination

## transpose_mat4x1

```lua
function linalg.transpose_mat4x1(src: avm.number4)
  -> number * 4
```

Transpose a 4x1 matrix and return a 1x4 matrix

@*return* — (mat1x4)

## transpose_mat4x2

```lua
function linalg.transpose_mat4x2(src: avm.number8)
  -> number * 8
```

Transpose a 4x2 matrix and return a 2x4 matrix

@*return* — (mat2x4)

## transpose_mat4x2_ex

```lua
function linalg.transpose_mat4x2_ex(src: avm.seq_number8|{ [integer]: number }, src_index: integer)
  -> number * 8
```

Transpose a 4x2 matrix and return a 2x4 matrix

@*return* — (mat2x4)

## transpose_mat4x2_ex

```lua
function linalg.transpose_mat4x2_ex(src: avm.seq_number8|{ [integer]: number }, src_index: integer, dest: avm.seq_number8|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 4x2 matrix into a 2x4 matrix in a destination

## transpose_mat4x3

```lua
function linalg.transpose_mat4x3(src: avm.number12)
  -> number * 12
```

Transpose a 4x3 matrix and return a 3x4 matrix

@*return* — (mat3x4)

## transpose_mat4x3_ex

```lua
function linalg.transpose_mat4x3_ex(src: avm.seq_number12|{ [integer]: number }, src_index: integer)
  -> number * 12
```

Transpose a 4x3 matrix and return a 3x4 matrix

@*return* — (mat3x4)

## transpose_mat4x3_ex

```lua
function linalg.transpose_mat4x3_ex(src: avm.seq_number12|{ [integer]: number }, src_index: integer, dest: avm.seq_number12|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 4x3 matrix into a 3x4 matrix in a destination

## transpose_mat4x4

```lua
function linalg.transpose_mat4x4(src: avm.number16)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4x4)

## transpose_mat4x4_ex

```lua
function linalg.transpose_mat4x4_ex(src: avm.seq_number16|{ [integer]: number }, src_index: integer, dest: avm.seq_number16|{ [integer]: number }, dest_index?: integer)
  -> nil
```

Transpose a 4x4 matrix into a 4x4 matrix in a destination

## transpose_mat4x4_ex

```lua
function linalg.transpose_mat4x4_ex(src: avm.seq_number16|{ [integer]: number }, src_index: integer)
  -> number * 16
```

Transpose a 4x4 matrix and return a 4x4 matrix

@*return* — (mat4x4)

## vec2_zero

```lua
function linalg.vec2_zero()
  -> number, number
```

2d-vector of zeros

## vec3_zero

```lua
function linalg.vec3_zero()
  -> number, number, number
```

3d-vector of zeros

## vec4_zero

```lua
function linalg.vec4_zero()
  -> number * 4
```

4d-vector of zeros


---

# matrix_2
Matrix operations and types  

Classes and functions for working with matrices  


## new

```lua
function matrix_2.new(e_11: number, e_12: number, e_21: number, e_22: number)
  -> avm.matrix_2
```

Create a new matrix_2
Parameter `e_ij` determines the value of `i'th` column `j'th` row


---

# matrix_3
Matrix operations and types  

Classes and functions for working with matrices  


## new

```lua
function matrix_3.new(e_11: number, e_12: number, e_13: number, e_21: number, e_22: number, e_23: number, e_31: number, e_32: number, e_33: number)
  -> avm.matrix_3
```

Create a new matrix_3
Parameter `e_ij` determines the value of `i'th` column `j'th` row


---

# matrix_4
Matrix operations and types  

Classes and functions for working with matrices  


## new

```lua
function matrix_4.new(e_11: number, e_12: number, e_13: number, e_14: number, e_21: number, e_22: number, e_23: number, e_24: number, e_31: number, e_32: number, e_33: number, e_34: number, e_41: number, e_42: number, e_43: number, e_44: number)
  -> avm.matrix_4
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


## new

```lua
function vector_2.new(v1: number, v2: number)
  -> avm.vector_2
```

Create a new vector_2 with given values


---

# vector_3
Vector operations and types  

Classes and functions for working with 3-d vectors  


## new

```lua
function vector_3.new(v1: number, v2: number, v3: number)
  -> avm.vector_3
```

Create a new vector_3 with given values


---

# vector_4
Vector operations and types  

Classes and functions for working with 4-d vectors  


## new

```lua
function vector_4.new(v1: number, v2: number, v3: number, v4: number)
  -> avm.vector_4
```

Create a new vector_4 with given values


---

# view
Views  

A view is a special array or sequence that maps into a subset of another array or sequence.  

The views in this module can be used to:  
* Pass subsets of arrays to AVM functions, such as interleaved data or reversed values  
* Provide array wrappers for objects, e.g., `M.slice(cdata, 0, 10)` will make an array wrapper for the first 10 elements of a cdata array  


## interleave

```lua
function view.interleave(src: avm.seq<T>, index: integer, group_size: integer, stride: integer, count: integer)
  -> avm.fixed_array<T>
```

Create a view over interleaved data, collecting `group_size` elements starting at `index` and skipping `stride` elements

Example:
```
local a = {1,2, x,x, 5,6, x,x, 9,10}
local b = view.interleaved(a, 1, 2, 2, 3)
print(b[1], b[2], b[3], b[4], b[5], b[6]) --> 1 2 5 6 9 10
```

## reverse

```lua
function view.reverse(src: avm.array<T>|avm.seq<T>, index?: integer, count?: integer)
  -> avm.fixed_array<T>
```

Create a view into `src` that reverses the elements
 Can optionally start at `index` and reverse for `count` elements

Example:
```lua
local a = {1,2,3,4,5,6,7,8,9,10}
local b = view.reverse(a)
print(b[1], b[2], b[3]) --> 10 9 8
```

## slice

```lua
function view.slice(src: avm.seq<T>, index: integer, count: integer)
  -> avm.fixed_array<T>
```

Create a view into `src` that starts at `index` and has `count` elements

Example:
```lua
local a = {1,2,3,4,5,6,7,8,9,10}
local b = view.slice(a, 2, 3)
print(b[1], b[2], b[3]) --> 2 3 4
```

Note: Most array functions have `_ex` forms so this object is a convenience only

## slice_1

```lua
function view.slice_1(src: avm.seq<T>, index: integer)
  -> avm.fixed_array1<T>
```

Create a view of size `1` that maps into `src` starting from `index`

## slice_2

```lua
function view.slice_2(src: avm.seq<T>, index: integer)
  -> avm.fixed_array2<T>
```

Create a view of size `2` that maps into `src` starting from `index`

## slice_3

```lua
function view.slice_3(src: avm.seq<T>, index: integer)
  -> avm.fixed_array3<T>
```

Create a view of size `3` that maps into `src` starting from `index`

## slice_4

```lua
function view.slice_4(src: avm.seq<T>, index: integer)
  -> avm.fixed_array4<T>
```

Create a view of size `4` that maps into `src` starting from `index`

## slice_5

```lua
function view.slice_5(src: avm.seq<T>, index: integer)
  -> avm.fixed_array5<T>
```

Create a view of size `5` that maps into `src` starting from `index`

## slice_6

```lua
function view.slice_6(src: avm.seq<T>, index: integer)
  -> avm.fixed_array6<T>
```

Create a view of size `6` that maps into `src` starting from `index`

## slice_7

```lua
function view.slice_7(src: avm.seq<T>, index: integer)
  -> avm.fixed_array7<T>
```

Create a view of size `7` that maps into `src` starting from `index`

## slice_8

```lua
function view.slice_8(src: avm.seq<T>, index: integer)
  -> avm.fixed_array8<T>
```

Create a view of size `8` that maps into `src` starting from `index`

## slice_9

```lua
function view.slice_9(src: avm.seq<T>, index: integer)
  -> avm.fixed_array9<T>
```

Create a view of size `9` that maps into `src` starting from `index`

## slice_10

```lua
function view.slice_10(src: avm.seq<T>, index: integer)
  -> avm.fixed_array10<T>
```

Create a view of size `10` that maps into `src` starting from `index`

## slice_11

```lua
function view.slice_11(src: avm.seq<T>, index: integer)
  -> avm.fixed_array11<T>
```

Create a view of size `11` that maps into `src` starting from `index`

## slice_12

```lua
function view.slice_12(src: avm.seq<T>, index: integer)
  -> avm.fixed_array12<T>
```

Create a view of size `12` that maps into `src` starting from `index`

## slice_13

```lua
function view.slice_13(src: avm.seq<T>, index: integer)
  -> avm.fixed_array13<T>
```

Create a view of size `13` that maps into `src` starting from `index`

## slice_14

```lua
function view.slice_14(src: avm.seq<T>, index: integer)
  -> avm.fixed_array14<T>
```

Create a view of size `14` that maps into `src` starting from `index`

## slice_15

```lua
function view.slice_15(src: avm.seq<T>, index: integer)
  -> avm.fixed_array15<T>
```

Create a view of size `15` that maps into `src` starting from `index`

## slice_16

```lua
function view.slice_16(src: avm.seq<T>, index: integer)
  -> avm.fixed_array16<T>
```

Create a view of size `16` that maps into `src` starting from `index`

## stride

```lua
function view.stride(src: avm.seq<T>, index: integer, stride: integer, count: integer)
  -> avm.fixed_array<T>
```

Create a view into `src` that starts at `index` and skips `stride` elements

Example:
```lua
local a = {1,2,3,4,5,6}
local index, stride, count = 1, 2, 3
local b = view.stride(a, index, stride, count)
print(b[1], b[2], b[3]) --> 1 3 5
```