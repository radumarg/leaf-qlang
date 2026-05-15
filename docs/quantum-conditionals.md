
### Quantum Conditional Statement

A quantum conditional on qubit q means applying two quantum operations on some other set of qubits depending on the state of `q` [coherently](defining-terms.md#what-are-quantum-conditionals) without measuring it:

```leaf
qif q1 {
  f1(q2, q3);
} qelse {
  f2(q2, q3);
}
```

It is required of f1 and f2 to be unitary functions (no discarding on input qubits, no measurements or resets), to operate on the same number of qubits, and not act on the control qubit. Any ancilla qubits created inside the two functions must be returned in a clean pure zero state and in the end safely discarded.

### Quantum Match Statements

A generalization of quantum conditional for multiple branches implies coherent control over qubits `qs` without performing measurements:

```leaf
  qmatch qs {
    b"00" => f00(q1, q2, q3);
    b"01" => f01(q1, q2, q3);
    b"10" => f10(q1, q2, q3);
    b"11" => f11(q1, q2, q3);
  }

  qmatch qs {
    0 => f00(q1, q2, q3);
    1 => f01(q1, q2, q3);
    2 => f10(q1, q2, q3);
    3 => f11(q1, q2, q3);
  }
```

Similar conditions that apply to quantum conditionals apply here as well for functions in `qmatch` branches.
