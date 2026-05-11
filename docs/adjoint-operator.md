### Unitary Adjoint Operator

Technically these are higher-order operators that change the way functions with quantum operations behave.

```leaf
adjoint f(q1, q2, q3);

// SAME AS:

adjoint {
    f(q1, q2, q3);
}
```

```leaf
adjoint {
    H(&mut q1);
    CX(&mut q1, &mut q2)
}

// SAME AS:

adjoint CX(&mut q1, &mut q2)
adjoint H(&mut q1);
```
