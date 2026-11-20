# Notes (mainly for myself during development)

## TODO

- [ ] Understand reflection in Agda better (look at
  https://github.com/alhassy/gentle-intro-to-reflection)
- [ ] Generate graph for simplified append
- [ ] Generate graph for regular append
- [ ] prove soundness and completeness for generated graphs of
  append
- [x] Do the exercises below
- [x] Make an empty data type without constructors, but with the
  correct type based on a function type
- [ ] Add constructors one by one, either by
  - doing it Bove-Capratta style without the result type (only
    induction on the arguments), or
  - use a default value (given by user or choose one, for
    example `[]`) for use inside of the result type of
    constructors

## Exercises

- [x] Write a macro that counts the cases/clauses of a function
  (`count : Name -> Nat`)
- [x] Write `unquoteDecl id`, and inspect it later with
  normalization (C-c C-n), in a hole, or inspect type error of
  `_ : id 3 ≡ 4`
- [x] Write a `size` function that counts the constructors of an
  instance of a data type. This is an approximation of the cost
  function in
  [Wouter Swierstra, 2026](https://zenodo.org/records/20506788))

## Random notes

- We need the argument patterns of a clause to define the RHS of
  generated constructors
- First only look at `con` and `var` in `Pattern`s and `Term`s

## Approach

- We start from simple examples and keep generalizing the
  program to support more examples. The hope is to end up with
  something that supports every type of function
- When encountering a function call on the rhs of a function
  definition, we need to differentiate between recursive calls
  and calls to other functions. In case of the latter, we also
  require graph generation for the function being called.

Steps:

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
  (https://link.springer.com/article/10.1007/s10817-009-9157-2)
