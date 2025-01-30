---@meta

-----------------------------------------------------------
-- Array type annotations
-----------------------------------------------------------

---Sequence: A generic object with elements of type `T` within a known index range of `i .. j`
---@class avm.seq<T>: {[integer]:T}

---Array: A generic object with elements of type `T` within an index range of `1 .. n` with `n` given by `#` or `array.length()`
---@class avm.array<T>: avm.seq<T>

---Fixed Array: A generic fixed-length array
---@class avm.fixed_array<T>: avm.seq<T>

---Sequence: An object containing numbers within a known index range of `i .. j`
---@class avm.seq_number: {[integer]:number}

---Fixed Sequence: A sequence with 1 numbers
---@class avm.seq_number1: {[integer]:number}

---Fixed Sequence: A sequence with 2 numbers
---@class avm.seq_number2: {[integer]:number}

---Fixed Sequence: A sequence with 3 numbers
---@class avm.seq_number3: {[integer]:number}

---Fixed Sequence: A sequence with 4 numbers
---@class avm.seq_number4: {[integer]:number}

---Fixed Sequence: A sequence with 5 numbers
---@class avm.seq_number5: {[integer]:number}

---Fixed Sequence: A sequence with 6 numbers
---@class avm.seq_number6: {[integer]:number}

---Fixed Sequence: A sequence with 7 numbers
---@class avm.seq_number7: {[integer]:number}

---Fixed Sequence: A sequence with 8 numbers
---@class avm.seq_number8: {[integer]:number}

---Fixed Sequence: A sequence with 9 numbers
---@class avm.seq_number9: {[integer]:number}

---Fixed Sequence: A sequence with 10 numbers
---@class avm.seq_number10: {[integer]:number}

---Fixed Sequence: A sequence with 11 numbers
---@class avm.seq_number11: {[integer]:number}

---Fixed Sequence: A sequence with 12 numbers
---@class avm.seq_number12: {[integer]:number}

---Fixed Sequence: A sequence with 13 numbers
---@class avm.seq_number13: {[integer]:number}

---Fixed Sequence: A sequence with 14 numbers
---@class avm.seq_number14: {[integer]:number}

---Fixed Sequence: A sequence with 15 numbers
---@class avm.seq_number15: {[integer]:number}

---Fixed Sequence: A sequence with 16 numbers
---@class avm.seq_number16: {[integer]:number}

---Fixed Array: A fixed-length array of 1 numbers
---@class avm.number1: [number]

---Fixed Array: A fixed-length array of 2 numbers
---@class avm.number2: [number, number]

---Fixed Array: A fixed-length array of 3 numbers
---@class avm.number3: [number, number, number]

---Fixed Array: A fixed-length array of 4 numbers
---@class avm.number4: [number, number, number, number]

---Fixed Array: A fixed-length array of 5 numbers
---@class avm.number5: [number, number, number, number, number]

---Fixed Array: A fixed-length array of 6 numbers
---@class avm.number6: [number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 7 numbers
---@class avm.number7: [number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 8 numbers
---@class avm.number8: [number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 9 numbers
---@class avm.number9: [number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 10 numbers
---@class avm.number10: [number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 11 numbers
---@class avm.number11: [number, number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 12 numbers
---@class avm.number12: [number, number, number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 13 numbers
---@class avm.number13: [number, number, number, number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 14 numbers
---@class avm.number14: [number, number, number, number, number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 15 numbers
---@class avm.number15: [number, number, number, number, number, number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A fixed-length array of 16 numbers
---@class avm.number16: [number, number, number, number, number, number, number, number, number, number, number, number, number, number, number, number]

---Fixed Array: A generic fixed-length array of 1 elements of type `T`
---@class avm.fixed_array1<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 2 elements of type `T`
---@class avm.fixed_array2<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 3 elements of type `T`
---@class avm.fixed_array3<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 4 elements of type `T`
---@class avm.fixed_array4<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 5 elements of type `T`
---@class avm.fixed_array5<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 6 elements of type `T`
---@class avm.fixed_array6<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 7 elements of type `T`
---@class avm.fixed_array7<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 8 elements of type `T`
---@class avm.fixed_array8<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 9 elements of type `T`
---@class avm.fixed_array9<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 10 elements of type `T`
---@class avm.fixed_array10<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 11 elements of type `T`
---@class avm.fixed_array11<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 12 elements of type `T`
---@class avm.fixed_array12<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 13 elements of type `T`
---@class avm.fixed_array13<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 14 elements of type `T`
---@class avm.fixed_array14<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 15 elements of type `T`
---@class avm.fixed_array15<T>: {[integer]:T}

---Fixed Array: A generic fixed-length array of 16 elements of type `T`
---@class avm.fixed_array16<T>: {[integer]:T}

-----------------------------------------------------------
-- Vector and matrix type annotations
-----------------------------------------------------------

---@alias avm.vec1 avm.number1 ---1d vector
---@alias avm.vec2 avm.number2 ---2d vector
---@alias avm.vec3 avm.number3 ---3d vector
---@alias avm.vec4 avm.number4 ---4d vector
---@alias avm.mat1x1 avm.number1  ---1x1 matrix in column-major order with 1 columns and 1 rows stored in a flat array of `1` elements
---@alias avm.mat1x2 avm.number2  ---1x2 matrix in column-major order with 1 columns and 2 rows stored in a flat array of `2` elements
---@alias avm.mat1x3 avm.number3  ---1x3 matrix in column-major order with 1 columns and 3 rows stored in a flat array of `3` elements
---@alias avm.mat1x4 avm.number4  ---1x4 matrix in column-major order with 1 columns and 4 rows stored in a flat array of `4` elements
---@alias avm.mat2x1 avm.number2  ---2x1 matrix in column-major order with 2 columns and 1 rows stored in a flat array of `2` elements
---@alias avm.mat2x2 avm.number4  ---2x2 matrix in column-major order with 2 columns and 2 rows stored in a flat array of `4` elements
---@alias avm.mat2x3 avm.number6  ---2x3 matrix in column-major order with 2 columns and 3 rows stored in a flat array of `6` elements
---@alias avm.mat2x4 avm.number8  ---2x4 matrix in column-major order with 2 columns and 4 rows stored in a flat array of `8` elements
---@alias avm.mat3x1 avm.number3  ---3x1 matrix in column-major order with 3 columns and 1 rows stored in a flat array of `3` elements
---@alias avm.mat3x2 avm.number6  ---3x2 matrix in column-major order with 3 columns and 2 rows stored in a flat array of `6` elements
---@alias avm.mat3x3 avm.number9  ---3x3 matrix in column-major order with 3 columns and 3 rows stored in a flat array of `9` elements
---@alias avm.mat3x4 avm.number12 ---3x4 matrix in column-major order with 3 columns and 4 rows stored in a flat array of `12` elements
---@alias avm.mat4x1 avm.number4  ---4x1 matrix in column-major order with 4 columns and 1 rows stored in a flat array of `4` elements
---@alias avm.mat4x2 avm.number8  ---4x2 matrix in column-major order with 4 columns and 2 rows stored in a flat array of `8` elements
---@alias avm.mat4x3 avm.number12 ---4x3 matrix in column-major order with 4 columns and 3 rows stored in a flat array of `12` elements
---@alias avm.mat4x4 avm.number16 ---4x4 matrix in column-major order with 4 columns and 4 rows stored in a flat array of `16` elements

---@alias avm.mat1 avm.number1 ---1x1 matrix in column-major order with 1 columns and rows stored in a flat array of `1` elements
---@alias avm.mat2 avm.number4 ---2x2 matrix in column-major order with 2 columns and rows stored in a flat array of `4` elements
---@alias avm.mat3 avm.number9 ---3x3 matrix in column-major order with 3 columns and rows stored in a flat array of `9` elements
---@alias avm.mat4 avm.number16 ---4x4 matrix in column-major order with 4 columns and rows stored in a flat array of `16` elements