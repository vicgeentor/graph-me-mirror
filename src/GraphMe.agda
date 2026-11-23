module GraphMe where

open import GraphMe.Base public

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.List using ([])
open import Agda.Builtin.String using (primStringAppend)
open import Agda.Builtin.Nat using (Nat; zero; suc)

mkGraphType : Type → TC Type
mkGraphType (pi a (abs s t)) = do
  t' ← mkGraphType t
  returnTC (pi a (abs s t'))
mkGraphType rest = returnTC (pi (arg' visible rest) (abs "_" (agda-sort (lit 0)))) -- we lock the result to Set₀ for now

-- We treat every leading argument of type `Set` in the function
-- as a paramater of the graph
countParams : Type → Nat
countParams (pi (arg _ (agda-sort _)) (abs _ t)) = suc (countParams t)
countParams _ = 0

graphName : Name → TC Name
graphName n = freshName (primStringAppend (primShowQName n) "#graph")

-- Function graph without constructors, but with the correct type
emptyGraph : Name → Name → TC ⊤
emptyGraph graph-name n = do
  ty ← getType n
  graphTy ← mkGraphType ty
  declareData graph-name (countParams ty) graphTy
  defineData graph-name []
