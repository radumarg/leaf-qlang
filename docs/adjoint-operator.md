### Unitary Adjoint Operator

Technically these are higher-order operators that change the way functions with quantum operations behave.

```leaf
adjoint f(q1, q2, q3);

// SAME AS:
adjoint {
    f(q1, q2, q3);
}
```

Space has the highest precedence in this case:

```leaf

adjoint f(q1, q2, q3);

// SAME AS:
(adjoint f)(q1, q2, q3);
```

```leaf
adjoint CX(q1, q2)
adjoint H(q1);

// SAME AS:
adjoint {
    H(q1);
    CX(q1, q2)
}
```