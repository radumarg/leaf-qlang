//////////////////////////////////////
// Leaf Language Syntax Specification
//////////////////////////////////////

// Leaf is deliberately designed to replicate Rust’s basic syntax, with minimal extensions for quantum programming which are meant to look and feel like Rust.

////////////////////////////////////////////////////////////////////////////////
// (1) Comments syntax for the Leaf language follows the same syntax as Rust:
////////////////////////////////////////////////////////////////////////////////

  // single line comment

  /*
     multi-line comment
  */

///////////////////////////////////
// (2) Basic Leaf Language Syntax
///////////////////////////////////

// Statements are terminated by ';' like this is currently done in Rust except for function where return syntax which does not end with ';', again like is the convention in Rust.

// Parantheses, square brackets and curly braces follow the same rules from Rust.

//////////////////////////
// (3) Reserved Keywords: 
//////////////////////////

adjoint, affine, as, barrier, break, classical, ctrl, continue, discard, else, enum, ensures, false, fn, for, general, if, import, in, let, linear, loop, mod, measr, match, mut, minus, negctrl, one, plus, pub, qalloc, qif, qelse, qmatch, requires, reset, return, scratch, sif, selse, smatch, struct, true, unitary, uncompute, uncompsafe, use, weaken, while, zero, _

/////////////////////////////////////////////////
// (4) Operators Reserved Symbols and Keywords:
/////////////////////////////////////////////////

'(', ')', '[', ']', '{', '}', ',', ';', ':', '::', '.', '->', '?', '=', ':=', '+=', '-=', '*=', '/=', '%=', '+', '-', '*', '/', '%', '==', '!=', '>', '>=', '<', '<=', '=>', '>>', '>>=',  '<<', '<<=', '!', '&&', '||', '&', '|', '^', '..', '..=', '&=', '|=', '^='

/////////////////////////////////////
// (5) Reserved Keywords for Types:
/////////////////////////////////////

// quantum computing specific:
bit, qubit

// additional quantum types:
// - angle type is similar to OpenQasm3's angle type
// - symbolic compile-time parameters param type is similar to Qiskit's Parameter type
angle32, angle64, param

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
// (6) Syntax for Basic Types
////////////////////////////////

let f : f32 = 1.234567;
let d : f64 = -1.2345678901234567;

// inferred types for floating point literals
let d = -1000.0;

let i : i8 = -1;
let i : i16 = -1;
let i : i32 = 1;
let i : i64 = 1;
let i : i128 = -1;

// inferred types for integer literals
let i = -7;

// qubit declaration 
let q : qubit = qalloc();

// inferred type for qubit allocation
let q = qalloc();

let u : u8 = 1;
let u : u16 = 1;
let u : u32 = 1;
let u : u64 = 1;
let u : u128 = 1;

let unit : () = ();

// inferred type for unit literal
let unit = ();
let unit : () = ();

// syntax for declaring Parameters
let theta : param = Param("theta");

// var assignment syntax for basic types:
let mut x : i32 = 0;
x = 5;

// var assignment syntax for arrays and tuples:
let mut x : [i32; 2] = [0, 0];
x[0] = 10;

// assignment for tuple members:
let mut t : (i32, f64) = (0, 0.0);
t.0 = 3;

// shared reference
let x = 10;
let r: &i32 = &x;

// mutable reference
let mut x = 10;
let r: &mut i32 = &mut x;

///////////////////////////////////
// (7) Syntax for declaring arrays
///////////////////////////////////

// canonical array declarations
let bs: [bool; 4] = [true, false, true, false];
let is: [i32; 3] = [1, 2, 3];
let us: [u64; 2] = [10, 20];
let fs: [f64; 3] = [1.0, 2.0, 3.0];
let bits: [bit; 3] = [1, 0, 1];
let qubits: [qubit; 2] = qalloc(2);
let angles: [angle64; 2] = [3.14, 1.57];
let units: [(); 5] = [(), (), (), (), ()];
let params: [param; 2] = [Param("theta"), Param("phi")];

// array declarations with inferred type
let bools = [true, false, true, false];
let ints  = [1, 2, 3];
let zeros = [0; 3];
let fs = [1.0, 2.0, 3.0];
let qubits = qalloc(2);
let units = [(), (), (), (), ()];

////////////////////////////////////////
// (8) Array member access and length:
////////////////////////////////////////

let a = [1, 2, 3];
let first = a[0];
let n = a.len();

/////////////////////////////////////////////////////////////////
// (9) Syntax for allocating qubits and working with bits/qubits
/////////////////////////////////////////////////////////////////

// explicit type annotations for qubits and bits
let q : qubit = qalloc();
let qs : [qubit; 1] = qalloc(1);
let qs : [qubit; 3] = qalloc(3);
let b : bit = measr(q);
let b : bit = 0;
let bs : [bit; 3] = measr(qs);

// inferred types for qubits and bits
let q = qalloc();
let qs = qalloc(3);
let b = measr(q);

////////////////////////////////////
// (10) Declaring bit strings
////////////////////////////////////

let bs = bs"10110010";

//////////////////////////////////////////////
// (11) Syntax for type qualifiers for qubits
//////////////////////////////////////////////

// linear qubits: must be used exactly once, no copying or discarding allowed
// this is the default, so the 'linear' keyword is optional
let linear q: qubit = qalloc();
let linear qs: [qubit; 2] = qalloc(2);

// affine qubits: must be used at most once, no copying allowed, but discarding is allowed
let affine q: qubit = qalloc();
let affine qs: [qubit; 2] = qalloc(2);

// scratch qubits are automatically uncomputed at the end of their scope
let scratch q: qubit = qalloc();
let scratch qs: [qubit; 2] = qalloc(2);

// linear/affine type qualifiers can be combined with scratch
// both "scratch linear" and "linear scratch" are accepted syntax for linear scratch qubits, and the same applies for affine scratch qubits
let scratch linear q: qubit = qalloc();
let scratch linear qs: [qubit; 2] = qalloc(2);
let scratch affine q: qubit = qalloc();
let scratch affine qs: [qubit; 2] = qalloc(2);

/////////////////////////////////////////
// (12) Syntax for working with Quantum Gates
/////////////////////////////////////////

// canonical gate application syntax:
let q : qubit = H(q);
// gate application syntax with inferred types:
let q = H(q);
// borrowing qubit syntax if the qubit will be needed later:
H(&q);

// parameterized gates:
let q : qubit = U3(1, 2, 3, q);
let q = U3(1, 2, 3, q);
U3(1, 2, 3, &q);

// two-qubit gates:
let qs : [qubit; 2] = CX(q0, q1);
let qs = CX(q0, q1);

let (q0, q1) = CX(q0, q1);
CX(&q0, &q1);

////////////////////////////////////////////
// (13) All quantum Gates Reserved Keywords:
////////////////////////////////////////////

Id, X, Y, Z, H, S, SDG, T, TDG, SX, SXDG, RX, RY, RZ, U1, U2, U3, CNOT, CX, CY, CZ, CS, CSDG, CT, CTDG, CSX, CSXDG, CRX, CRY, CRZ, CU1, CU2, CU3, SWAP, RXX, RYY, RZZ, CCX, CSWAP, GPI, GPI2, MS, ZZ

// Single-Qubit Gates
Id(q);
X(q);
Y(q);
Z(q);
H(q);
S(q);
SDG(q);
T(q);
TDG(q);
SX(q);
SXDG(q);

// Parametric Single-Qubit Gates
RX(1, q);
RY(1, q);
RZ(1, q);
U1(1, q);
U2(1, 2, q);
U3(1, 2, 3, q);

// Controlled Gates
CNOT(q0, q1);
CX(q0, q1);
CY(q0, q1);
CZ(q0, q1);
CS(q0, q1);
CSDG(q0, q1);
CT(q0, q1);
CTDG(q0, q1);
CSX(q0, q1);
CSXDG(q0, q1);
CRX(1, q0, q1);
CRY(1, q0, q1);
CRZ(1, q0, q1);
CU1(1, q0, q1);
CU2(1, 2, q0, q1);
CU3(1, 2, 3, q0, q1);

// Two-Qubit Interaction Gates
SWAP(q0, q1);
RXX(1, q0, q1);
RYY(1, q0, q1);
RZZ(1, q0, q1);

// Three-Qubit Gates
CCX(q0, q1, q2);
CSWAP(q0, q1, q2);

// Ion-Native Gates
GPI(1, q);
GPI2(1, q);
MS(1, 2, q0, q1);
ZZ(1, q0, q1);

//////////////////////////////////////////////////////////////////
// (14) Apply higher-order control gate modifiers: ctrl & negctrl TODO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! SPACE OR DOT?
//////////////////////////////////////////////////////////////////

// canonical controlled gate
let (q0, q1, q2): (qubit, qubit, qubit) = ctrl(q0, q1).H(q2);
// controlled gate with inferred types:
let (q0, q1, q2) = ctrl(q0, q1).H(q2);
// controlled gate with borrowed qubits:
ctrl(&q0, &q1).H(&q2);

// can chain ctrl and negctrl modifiers:
ctrl(&q0).negctrl(&q1).H(&q2);
ctrl(&q0).ctrl(&q1).H(&q2);

// negctrl syntax for applying gates controlled on bits being 0 instead of 1, with the same syntax variations of 'ctrl':
negctrl(&q0, &q1).H(&q2);

// alternative syntax for declaring controlled gates using booleans arguments:
let (q0, q1, q2) = ctrl(q0 : one, q1 : zero).H(q2);
let (q0, q1, q2) = ctrl(q0 : plus, q1 : minus).H(q2);

ctrl(&q0).negctrl(&q1) {
  H(&q2);
  CX(&q3, &q4);
};

ctrl(&q0 : one, &q1 : one, &q2 : zero) {
  H(&q3);
  CX(&q4, &q5);
};

//////////////////////////
// (15) Adjoint Operator:
//////////////////////////

adjoint f(q1, q2, q3);

adjoint {
    f(q1, q2, q3);
}

adjoint {
  H(&q1);
  CX(&q1, &q2)
}

adjoint CX(&q1, &q2)
adjoint H(&q1);

//////////////////////////////
// (16) Arithmetic Operators:
//////////////////////////////

let add = 5 + 3;
let sub = 10 - 4;
let mul = 6 * 2;
let div = 12 / 3;
let rem = 10 % 3;

x += 5;
x -= 2;
x *= 2;
x /= 3;
x %= 4;

//////////////////////////////
// (17) Boolean Operators:
//////////////////////////////

let c = !a;
let d = a && b;
let e = a || b;


////////////////////////////
// (18) Bitwise operations:
////////////////////////////

let and_ : bit = a & b;
let or_  : bit = a | b;
let xor_ : bit = a ^ b;

x &= y;
x |= y;
x ^= y;

let x = a << 2;
let y = a >> 1;

x <<= 1;
x >>= 1;

//////////////////////////////////
// (19) Classical If/Else syntax:
//////////////////////////////////

// conditions must be boolean expressions or bits
if 7 > 5 {
  // do something
} else { // else branch is optional
  // do something else
}

//a bit may be used as a classical condition, where 0 means false and 1 means true.
if b { X(q); }        
// this is syntactic sugar for:
if b == 1 { X(q); }     

// if else syntax:
let sign = if x < 0 {
  f1();
} else if x == 0 {
  f2();
} else {
  f3();
};

// if else expression syntax:
if x < 0 {
  -1
} else if x == 0 {
  0
} else {
  1
};

////////////////////////////////////
// (20) Quantum conditionals syntax:
////////////////////////////////////

  // q is a qubit
  qif q {
    // some unitary operation(s)
    X(t);
  } qelse { // qelse branch is NOT optional in this case
    // some other unitary operation(s)
    H(t);
  }

  sif q {
    // some quantum state expression
  } selse { // selse branch is NOT optional in this case
    // some other quantum state expression
  }

////////////////////////////////
// (21) Classical match syntax:
////////////////////////////////

fn main() {
  let day = 4;

  match day {
    1 => { /* todo */ },
    2 => { /* todo */ },
    3 => { /* todo */ },
    4 => { /* todo */ },
    5 => { /* todo */ },
    6 => { /* todo */ },
    7 => { /* todo */ },
    _ => { /* todo */ },
  }
}

match b {
  true => { /* todo */ }
  false => { /* todo */ }
}

match x {
  n if n > 0 => { /* positive */ }
  _ => { /* other */ }
}

///////////////////////////////////
// (22) Quantum match expressions: TODO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! smatch
///////////////////////////////////

qmatch q {
  0 => {
      U0(data);
  }
  1 => {
      U1(data);
  }
}

qmatch qs {
  bs"00" => { U00(data); }
  bs"01" => { U01(data); }
  bs"10" => { U10(data); }
  bs"11" => { U11(data); }
}

qmatch qs {
  0 => { U00(data); }
  1 => { U01(data); }
  2 => { U10(data); }
  3 => { U11(data); }
}

////////////////////////////////
// (23) Rust block expressions:
////////////////////////////////

let x = {
  let a = 1;
  let b = 2;
  a + b
};

let unit = {
  let a = 1;
};

///////////////////////////////////
// (24) Syntax for declaring loops:
///////////////////////////////////

let mut count = 0;
loop {
    if count == 3 {
        break;
    }
    count += 1;
}

///////////////////////////////////////////////////////
// (25) Syntax for declaring loops that return a value:
///////////////////////////////////////////////////////

let mut count = 0;
let result = loop {

    if count == 3 {
        break count;
    }

    count += 1;
};

///////////////////////////
// (26) While loop syntax:
///////////////////////////

while count <= 5 {
  count += 1;
}

////////////////
// (27) Ranges:
///////////////

// exclusive range:
a..b

// inclusive range:
a..=b

// range from 1 onward
1..     

// range to: everything before 5
..5

// range to inclusive: everything up to and including 5
..=5

// full range
..      

/////////////////////////
// (28) For loop syntax:
/////////////////////////

// using a range in a for loop:

for i in 1..6 {
  // do something
}

/////////////////////////
// (29) Declaring tuples:
/////////////////////////

let t: (i32, f64, bool) = (1, 3.14, true);
let t = (1, 3.14, true);
  
////////////////////////////////////
// (30) Tuples positional indexing:
////////////////////////////////////

let x = t.0;
let y = t.1;
let z = t.2;

//////////////////////////////////////////
// (31) Extracting variables from tuples:
//////////////////////////////////////////

let (a, b, c) = (1, 2, 3);
let (x, _, z) = (1, 2, 3);
let (q0, q1, q2) = (H(q0), H(q1), H(q2));

///////////////////////
// (32) If expressions
////////////////////////

let boolflag = true;
let x : i32 = if boolflag { 1 } else { 2 };

///////////////////////
// (33) Type casting:
///////////////////////

let b : bit = 1;
let x = b as i32;

//////////////////////
// (34) Reset qubits:
//////////////////////

let q : qubit = qalloc();
reset(q);

let qs : [qubit; 3] = qalloc(3);
reset(qs);

//////////////////////
// (35) Discard qubits:
//////////////////////

let q : qubit = qalloc();
discard(q);

let qs : [qubit; 3] = qalloc(3);
discard(qs);

/////////////////////////////////////////////////////////////////////////////
// (36) uncompute qubits (return qubits to the |0> state without measuring):
/////////////////////////////////////////////////////////////////////////////

let q : qubit = qalloc();
uncompute(q);

let qs : [qubit; 3] = qalloc(3);
uncompute(qs);

////////////////////////////////////////////////////////////////////////////////////////////////////////
// (37) trigger automatic uncomputing on resulting qubits when new qubits are returned from a function:
////////////////////////////////////////////////////////////////////////////////////////////////////////

let q : qubit := fun(q);
let qs : [qubit; 3] := fun(qs);

//////////////////////////
// (38) Measuring qubits:
//////////////////////////

let q : qubit = qalloc();
let b : bit = measr(q);
let b : bit = measr(&q);

let qs : [qubit; 3] = qalloc(3);
let bs : [bit; 3] = measr(qs);
let bs : [bit; 3] = measr(&qs);

///////////////////////////
// (39) Barrier statement:
///////////////////////////

barrier();
barrier(q0, q1, q2);

////////////////////////////////////////////////////////////////////
// (40) declaring and using modules and imports follows Rust syntax:
////////////////////////////////////////////////////////////////////

mod my_module {
    pub fn helper() -> qubit {
        let q = qalloc(); // some code
        q
    }
}

mod "my_library.lf";

use my_library::helper;

fn main() {
    helper();
}

////////////////////////////////////////////////////////////////////////////
// (41) scratch qubit, gets uncomputed automatically when goes out of scope. 
////////////////////////////////////////////////////////////////////////////

let scratch q: qubit = qalloc();
let scratch q = qalloc();
let scratch qs: [qubit; 8] = qalloc(8);
let scratch qs = qalloc(8);

//////////////////////////
// (42) Functions syntax:
//////////////////////////

fn function_name() {
  // code to be executed
}

///////////////////////////////////////
// (43) Function with typed arguments:
///////////////////////////////////////

fn add(x: i32, y: i32) -> i32 {
  x + y
}

//////////////////////////////////////////
// (44) Function returning some variable:
//////////////////////////////////////////

fn f(x: f32) -> f32 {
  let y = 2.0;
  x + y
}

///////////////////////////////////////////////////////////
// (45) Alternative syntax for function returning a value:
///////////////////////////////////////////////////////////
fn f() -> f64 {
    let x = 2.0;
    return x;
}

//////////////////////////////////////////////////////
// (46) Variable declared in the scope of a function:
//////////////////////////////////////////////////////
fn my_function() {
  let message = "Hello!";
}

///////////////////////////////////////////////////////////
// (47) Functions using references and mutable references:
///////////////////////////////////////////////////////////

struct Person {
    name: String,
    age: u32,
}

fn my_function(person: &Person) {
    // some code
}

fn my_function(person: &mut Person) {
    // some code
}

///////////////////////////////////////////////////////////////////////////////////////
// (48) mutable variable declared in the scope of a function or outside of a function:
///////////////////////////////////////////////////////////////////////////////////////

let mut x = 0;
x = x + 1;

fn f(mut x: i32) -> i32 {
  x += 1;
  x
}

//////////////////////////////////////////////////////////////////////////////
// (49) Function effect annotations: classical, uncompsafe, unitary, general
//////////////////////////////////////////////////////////////////////////////

// no quantum operations allowed
classical fn f(x: i32) -> i32 {
  x + 1
}

// marks some qubits that can be uncomputed safely
uncompsafe fn f(q: qubit) -> qubit {
  let q = X(q);
  let q = H(q);
  q
}

// only unitary quantum operations allowed
unitary fn f(q: qubit) -> qubit {
  let q = X(q);
  let q = H(q);
  q
}

// may include measurements, reset, discard quantum operations
general fn sample(q: qubit) -> (bit, qubit) {
  measr(q)
}

/////////////////////////
// (50) Integer literals
/////////////////////////

let x = 1000;
let x = 1_000;
let x = 1_000_000;

let h = 0xff;
let h = 0xFF;
let h = 0xff_u8;

let o = 0o77;
let o = 0o70_i16;

let b = 0b1010;
let b = 0b1111_0000;
let b = 0b1111_1111_1001_0000i64;

let z = 10u32;
let z = 10_u32;
let z = 123i32;
let z = 123_i32;

////////////////////////////////
// (51) Floating point literals
////////////////////////////////

let x = 1.0;
let x = 1.;
let x = 0.1;
let x = 1.0e-3;
let x = 12E+99;
let x = 12E+99_f64;

let f = 1.0f64;
let f = 1.0_f64;
let f = 0.1f32;
let f = 5f32; 

///////////////////////////////////////
// (52) Byte and bytes string literals
///////////////////////////////////////

let b = b'a';
let b = b'\n';
let b = b'\x41';

let bs = b"hello";
let bs = b"ABC\x41";


/////////////////////////
// (53) Rust style enums
/////////////////////////

enum ResultBit {
  Zero,
  One,
}

let r = ResultBit::Zero;

///////////////////////////
// (54) Rust style structs
///////////////////////////

struct Point {
  x: f64,
  y: f64,
}

let p = Point { x: 1.0, y: 2.0 };
let x = p.x;

////////////////////////////////////
// (55) Functions Effect Qualifiers
////////////////////////////////////

// function effects are optional Rust style function qualifiers used by the Lean type checker to verify Leaf code.
// Thse are: "classical", "uncompsafe", "unitary", "general"
// Function qualifiers appear before fn keyword and cannot be combined with each other


classical fn parity (x : u32) -> bool { 
  // some code here
}

uncompsafe fn oracle (ancillas : [qubit; 3]) -> [qubit; 3] { 
  // some code here
}

unitary fn grover (qubits : [qubit; 7]) -> [qubit; 7] { 
  // some code here
}

general fn sample (qs : [qubit; 7]) -> [bit; 7] { 
  // some code here
}

///////////////////////////////////////////
// (56) Quantum Contracts Function Clauses 
///////////////////////////////////////////

// These are optional code annotations for functions that specify pre- & post-conditions that the quantum data should satisfy:
// "requires" + "clean", "basis", "pminus", "pure"
// "ensures" + "clean", "basis", "pminus", "pure
// they may be used as: requires, ensures or both requires and ensures clauses, and they may be used in any combination with the function effect qualifiers from (55) as well as with each other. They must be placed after the function signature and before the function body.

fn oracle(x: qubit, scratch: [qubit; 3])
  requires clean(scratch)
  ensures clean(scratch) {
    // some code here
}

fn oracle(q1: qubit, q2: qubit)
  requires clean(q1)
  ensures pminus(q2) {
    // some code here
}