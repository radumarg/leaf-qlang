## Quantum Gates


Example gate applications:
```leaf
H(q);
U3(1.0, 2.0, 3.0, q);
CX(q1, q2);
```

These are built-in operations, but conceptually they borrow their qubit(s) argument(s) in order to avoid needing to write code like this: 
```leaf
let q = H(q);                   // INCORRECT SYNTAX
let q = U3(1.0, 2.0, 3.0, q);   // INCORRECT SYNTAX
let (q1, q2) = CX(q1, q2);      // INCORRECT SYNTAX
```

### Identity

```leaf
Id
```

### Single-Qubit Gates

```leaf
X
Y
Z
H
S
SDG
SX
SXDG
T
TDG
```

### Parametric Single-Qubit Gates

```leaf
RX
RY
RZ
U1
U2
U3
```

### Controlled Gates

```leaf
CX/CNOT
CY
CZ
CS
CSDG
CSX
CSXDG
CT
CTDG
CRX
CRY
CRZ
CU1
CU2
CU3
```

### Two-Qubit Interaction Gates

```leaf
SWAP
RXX
RYY
RZZ
```

### Three-Qubit Gates

```leaf
CCX
CSWAP
```

### Ion-Native Gates

```leaf
GPI
GPI2
MS
ZZ
```