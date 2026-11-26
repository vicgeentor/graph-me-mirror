# Notes (mainly for myself during development)

## Project outline

1. 03-12-2026: Allow for graph generation of `append`
   - Also show soundness and completeness
2. 03-12-2026: Generalize so we can also generate graph of
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
6. 07-1-2026: Generalize to sets with arbitrary levels
7. 14-1-2027: Add support for mutual recursion
8. 28-1-2027: Add support for higher-order functions
9. Next steps (like cost function generation, soundness and
   completeness proof generation, etc.)

## TODO

- [x] Make nArgs a argument provided by the user, and a
  heuristic option
- [ ] Generate graph for append
- [ ] Prove soundness and completeness of append graph
- [ ] Add sanity check for generated graph: there should be no
  function calls in the type of the constructors

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
