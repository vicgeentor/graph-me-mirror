# Notes (mainly for myself during development)

## TODO

- [ ] Understand reflection in Agda better (look at
  https://github.com/alhassy/gentle-intro-to-reflection)
- [ ] Construct call graph for simplified append
- [ ] Construct call graph for regular append
- [ ] prove soundness and completeness for generated call graphs
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
