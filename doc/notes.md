# Notes (mainly for myself during development)

## Project outline

1. 3-12-2026: Allow for graph generation of `append`
   - Also show soundness and completeness
2. 3-12-2026: Generalize so we can also generate graph of
   `reverse-acc`
   - Also show soundness and completeness
3. 10-12-2026: Be able to generate graph of `slow-reverse`, this
   graph also has a constructor that has the graph of `append`
   as index
   - Also show soundness and completeness
4. 17-12-2026: Be able to generate graph of `insert`, with three
   constructors
   - Also show soundness and completeness
5. 17-12-2026: Be able to generate graph of slow `fib`, which
   has two recursive calls in the RHS
   - Also show soundness and completeness
6. 14-1-2027: Add support for mutual recursion
7. 28-1-2027: Add support for higher-order functions

## TODO

- [x] Understand reflection in Agda better (look at
  https://github.com/alhassy/gentle-intro-to-reflection)
- [ ] Generate graph for simplified append
- [ ] Generate graph for regular append
- [ ] prove soundness and completeness for generated graphs of
  append
- [x] Do the exercises below
- [x] Make an empty data type without constructors, but with the
  correct type based on a function type
- [x] Add constructors one by one, either by
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
