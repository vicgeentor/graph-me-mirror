module GraphMe where

open import GraphMe.Base public
open import GraphMe.Utils

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.List using (List; [])
open import Agda.Builtin.Sigma using (_,_)

-- Function graph without constructors, but with the correct type
mkEmptyGraph : Name → Name → TC ⊤
mkEmptyGraph graph-name func-name = do
  ty ← getType func-name
  d ← getDefinition func-name
  let graphTy , nArgs = mkGraphType ty
  declareData graph-name nArgs graphTy
  defineData graph-name []

-- Full function graph
mkGraph : Name → Name → List Name → TC ⊤
mkGraph graph-name func-name constructors = do
  ty ← getType func-name
  d ← getDefinition func-name
  let graphTy , nArgs = mkGraphType ty
  cons ← mkConstructors nArgs graph-name constructors d
  declareData graph-name nArgs graphTy
  defineData graph-name cons
