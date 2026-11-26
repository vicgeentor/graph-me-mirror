module GraphMe where

open import GraphMe.Base public
open import GraphMe.Utils

open import Agda.Builtin.List using (List; [])
open import Agda.Builtin.Nat using (Nat)
open import Agda.Builtin.Reflection
open import Agda.Builtin.Sigma using (_,_)
open import Agda.Builtin.Unit using (⊤)

mkGraph : Name → Name → List Name → Nat → TC ⊤
mkGraph graph-name func-name constructors nArgs = do
  ty ← getType func-name
  d  ← getDefinition func-name
  let graphTy = mkGraphType ty
  cons ← mkConstructors nArgs graph-name constructors d
  declareData graph-name nArgs graphTy
  defineData graph-name cons

mkGraph' : Name → Name → List Name → TC ⊤
mkGraph' graph-name func-name constructors = do
  ty ← getType func-name
  d  ← getDefinition func-name
  let nArgs   = countArgumentsHeuristic ty
      graphTy = mkGraphType ty
  cons ← mkConstructors nArgs graph-name constructors d
  declareData graph-name nArgs graphTy
  defineData graph-name cons
