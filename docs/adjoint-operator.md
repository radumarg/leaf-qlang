### Unitary Adjoint Operator

Technically these are higher-order operators that change the way functions with quantum operations behave. Adjoint is can be only applied to unitary code, in particular if applied to a function the function must be qualified with the `unitary` effect.

```leaf
adjoint f(q1, q2, q3);

// SAME AS:

adjoint {
    f(q1, q2, q3);
}
```

```leaf
adjoint {
    H(&q1);
    CX(&q1, &q2)
}

// SAME AS:

adjoint CX(&q1, &q2)
adjoint H(&q1);
```
