# Notes for `mkConstructor`

## Approach outline

- everything in the telescope become hidden arguments, except
  for the graph arguments
- for each recursive call, we do multiple things:
  - add another hidden argument
  - add another constructor index (premise) that represents the
    recursive call. The inputs to that recursive call become the
    arguments to that constructor, and the final argument is the
    newly bound hidden variable:
    - A recursive call looks like `def func-name funcArgs`
    - Making the index then looks something like
      `def graph-name (funcArgs ++ (arg' visible (var i []))`,
      for some `i`
- The final index of the constructor takes the patterns (LHS of
  clause) as arguments, plus the RHS as final argument, with
  recursive calls replaced by the newly bound arguments

## Pipeline

Idea:

- grab all information and construct pieces of the final `pi`,
  shifting DeBruijn indices seperately in each piece, as if they
  are in the final context
- In the end, glue all the pieces together in one big `pi`,
  without needing to shift indices
- information we need:
  - telescope: this defines the initial hidden args
  - number of recursive calls: this defines the number of extra
    hidden args, plus the number of premises
  - the result type of the function: this defines the type of
    the extra hidden args
  - the pattern of the clause: this defines the arguments to the
    final constructor index, excluding the output argument
  - the RHS of the clause: this defines the structure of the
    output argument of the final constructor index, as well as
    the arguments to the premises, excluding the final argument
    of each premise

## Type of new binders for recursive calls

For the new binders for recursive calls, I need to find a way to
consistently get the correct DeBruijn indices of the arguments
of the type of that binder, if it has arguments.

For example, if I add `zs : List A`, `A` is represented by
`var i []`, where i is the DeBruijn index pointing to where `A`
is bound.

We know that the type of the hidden binder should be exactly the
same as the second-to-last index of the graph type. For example
in the graph type of append,
`Append {A : Set} : List A -> List A -> List A -> Set`, the
final mention of `List A` is the type that the binder should
have. I need to find a correspondence between the DeBruijn index
that the second-to-last graph type index and the DeBruijn index
of the freshly bound variable.
