module GraphMe where

open import GraphMe.Base public

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.List using ([])
open import Agda.Builtin.String using (primStringAppend)

mkGraphType : Type → TC Type
mkGraphType (pi a (abs s t)) = do
  t' ← mkGraphType t
  returnTC (pi a (abs s t'))
mkGraphType rest = returnTC (pi (arg' visible rest) (abs "_" (agda-sort (lit 0))))

graphName : Name → TC Name
graphName n = freshName (primStringAppend (primShowQName n) "#graph")

macro
  -- Function graph without constructors, but with the correct type
  -- Still deciding if this should be a macro or not
  emptyGraph : Name → Term → TC ⊤
  emptyGraph n hole = do
    ty ← getType n
    graphTy ← mkGraphType ty
    graph-name ← graphName n -- Currently this doesn't do much, since we can bind
                             -- definitions (e.g., `funcGraph = emptyGraph funcName`)
    declareData graph-name 0 graphTy -- we lock this at 0 arguments for now
    defineData graph-name []
    unify hole (def graph-name [])
