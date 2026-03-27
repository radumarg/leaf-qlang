
By and large Leaf is on purpose replicating the Rust basic syntax with minimal extensions adding support for quantum computing programming.

The lifecycle of Leaf code:

 - Frontend (Rust like)
 - Type Checker (Silq Inspired)
 - High IR Translator (1st Compiler Pass)
 - Lambda Calculus / Quantum Lambda Calculus based IR <=========> Formal Verification Support to be added here in the future.
 - DSL Translation (2nd Compiler Pass)
 - Idris2 DSL
 - Low IR Serializer (3rd Compiler Pass)
 - OpenQasm3/QIR