# Notes (mainly for myself during development)

## TODO

- [ ] Understand reflection in Agda better (look at
  https://github.com/alhassy/gentle-intro-to-reflection)
- [ ] Generate graph for simplified append
- [ ] Generate graph for regular append
- [ ] prove soundness and completeness for generated graphs
  of append

## Approach

- We start from simple examples and keep generalizing the
  program to support more examples. The hope is to end up with
  something that supports every type of function
- When encountering a function call on the rhs of a function
  definition, we need to differentiate between recursive calls
  and calls to other functions. In case of the latter, we also
  require call graph generation for function being called.

## Useful papers

- Bove & Capretta 2005: Modelling general recursion in type
  theory (doi:10.1017/S0960129505004822)
- Bove et al. 2012: Partiality and Recursion in Interactive
  Theorem Provers — An Overview
  (https://inria.hal.science/hal-00691459/document)
- Barthe et al. 2006: Defining and Reasoning About Recursive
  Functions: A Practical Tool for the Coq Proof Assistant
  (https://davidpichardie.github.io/papers/flops06.pdf)
- Sozeau & Mangin 2019: Equations reloaded: high-level
  dependently-typed functional programming and proving in Coq
  (https://dl.acm.org/doi/10.1145/3341690)
- Krauss 2009: Partial and Nested Recursive Function Definitions
  in Higher-order Logic
