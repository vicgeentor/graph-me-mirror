# call-me

The `call-me` Agda library aims to provide the tools to
automatically generate call graphs from function definitions in
Agda. It does so by utilizing the
[Reflection](https://agda.readthedocs.io/en/stable/language/reflection.html)
machinery that Agda provides.

Having the call graph of a function as an inductively defined
relation allows for further analyses of that function. It is
especially useful for time and memory complexity analyses (see
[Wouter Swierstra, 2026](https://zenodo.org/records/20506788)).

## Idea

To analyse the complexity of a function $f : A → B$, we can
encode a function definition by reifying its graph as an
inductively defined relation $R : A → B → Set$, such that
$∀ x ∈ A. \, R \: x \: (f \: x)$ holds
([Wouter Swierstra, 2026](https://zenodo.org/records/20506788)).
For simple function definitions, defining this relation is
relatively simple, but this can become quite tedious for more
complex functions. The idea of `call-me` is to relieve the
analyst of this burden, by automatically generating this
relation through Agda metaprogramming (reflection).

## Development

Development of this project takes place during an
[Experimentation Project](https://osiris-student.uu.nl/onderwijscatalogus/extern/cursus?cursuscode=INFOMEPCS1&collegejaar=2026)
at Utrecht University, under guidance of Wouter Swierstra.
