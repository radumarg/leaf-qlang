////////////////////////////////
// Basic Leaf Language Syntax
////////////////////////////////

// Code lines are terminated by ';' like this is currently done in Rust except for function return syntax which does not end with ';', again like is the convention in Rust.

// Paranthesis, square brakets and curly braces follow the same rules from Rust.

///////////////////////////////////
// Reserved Keywords for Types:
///////////////////////////////////

// quantum computing specific:
bit, qubit

// additional quantum types (OpenQASM3 inspired):
angle32, angle64, Param

// signed integer types:  
i8, i16, i32, i64, i128

// unsigned integer types:
u8, u16, u32, u64, u128

// floating-point types:
f32, f64

// boolean type:
bool

// unit type:
()

////////////////////////////////
// Syntax for Basic Types
////////////////////////////////
let f:f32 = 1.234567;
let d:f64 = -1.2345678901234567;

// inferred types for floating point literals
let d = -1000.0;

let i:i8 = -1;
let i:i16 = -1;
let i:i32 = 1;
let i:i64 = 1;
let i:i128 = -1;

// inferred types for integer literals
let i = -7;

let q:qubit = qalloc();

// inferred type for qubit literals
let q = qalloc();

let u:u8 = 1;
let u:u16 = 1;
let u:u32 = 1;
let u:u64 = 1;
let u:u128 = 1;

let unit:() = ();

// inferred type for unit literal
let () = ();

////////////////////////////////
// Syntax for Parameters
////////////////////////////////
let theta : param = Param("theta")


////////////////////////////////
// Syntax for declaring arrays
////////////////////////////////

// explicit type annotations arrays
let bs: [bool; 4] = [true, false, true, false];
let is: [i32; 3] = [1, 2, 3];
let us: [u64; 2] = [10, 20];
let fs: [f64; 3] = [1.0, 2.0, 3.0];
let bits: [bit; 3] = [1, 0, 1];
let qubits: [qubit; 2] = qalloc(2);
let angles: [angle64; 2] = [3.14, 1.57];
let units: [(); 5] = [(), (), (), (), ()];
let params: [param; 2] = [Param("theta"), Param("phi")];

// inferred types for arrays
let bools = [true, false, true, false];
let ints = [1, 2, 3];
let zeros = [0; 3];
let fs = [1.0, 2.0, 3.0];
let units = [(), (), ()];

// // (30) Array access and length:

// let a = [1, 2, 3];
// let first = a[0];
// let n = a.len();

// Bitstrings: b"10110010" (See OpenQasm3 for reference)
//b"0101"

////////////////////////////////
// Syntax for allocating qubits
// and working with bits
////////////////////////////////

// explicit type annotations for qubits and bits
let q : qubit = qalloc();
let q : qubit = qalloc(1);
let qs : [qubit; 3] = qalloc(3);
let b : bit = measr(q);
let b : bit = 0;
let bs : [bit; 3] = measr(qs);

// inferred types for qubits and bits
let q = qalloc();
let qs = qalloc(3);
let b = measr(q);