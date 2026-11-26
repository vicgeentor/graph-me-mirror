module GraphMe.Base where

open import GraphMe.Utils

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.String using (String; primStringAppend)
open import Agda.Builtin.Nat using (Nat; zero; suc)
open import Agda.Builtin.Sigma using (Σ; _,_)
open import Agda.Builtin.Int using (pos; primShowInteger)

-- Graph type and name --

-- Also returns the number of arguments to the graph data type:
-- we treat every leading argument of type `Set ℓ` in the function
-- as a paramater of the graph
mkGraphType : Type → Σ Type (λ _ → Nat)
mkGraphType t = go t 0
  where
    mkRest : Type → Type
    mkRest (pi a (abs s t)) = pi a (abs s (mkRest t))
    mkRest rest = pi (arg' visible rest) (abs "_" (agda-sort (lit 0)))

    go : Type → Nat → Σ Type (λ _ → Nat)
    go (pi (arg i (agda-sort s)) (abs x t)) n = let t' , n' = go t (suc n) in
     pi (arg i (agda-sort s)) (abs x t') , n'
    go rest n = mkRest rest , n -- We stop counting once we reach something not of type `Set ℓ`

-- Graph constructors --

-- Approach:
-- 1. We make a constructor for each clause of the function (`mkConstructor(s)`)
-- 2. Each item in the telescope maps to a hidden binder in the pi abstraction
--    of the constructor type, excluding the ones that correspond to
--    parameters to the graph type (`telToPi`)
-- 3. Each pattern in the LHS maps to a constructor argument (`patArgsToTerms`)
-- 4. The RHS (result) maps to the final constructor argument (inside `mkConstructor`)

Constructor : Set
Constructor = (Σ Name (λ _ → Σ Quantity (λ _ → Type)))

mutual
  patToTerm : Pattern → TC Term
  patToTerm (con c as) = do
    as' ← patArgsToTerms as
    returnTC (con c as')
  patToTerm (dot t) = returnTC t
  patToTerm (var i) = returnTC (var i []) -- It seems we can use the same De Bruijn index here
  patToTerm (lit l) = returnTC (lit l)
  patToTerm (proj _) = typeError (strErr "patToTerm: `proj` is not supported" ∷ [])
  patToTerm (absurd _) = typeError (strErr "patToTerm: `absurd` is not supported" ∷ [])

  patArgsToTerms : List (Arg Pattern) → TC (List (Arg Term))
  patArgsToTerms [] = returnTC []
  patArgsToTerms (arg i p ∷ as) = do
    p' ← patToTerm p
    as' ← patArgsToTerms as
    returnTC (arg i p' ∷ as')

-- This turns all items in the telescope to hidden, and converts them
-- to abstractions. We exclude the arguments to the graph by assuming that
-- the first n items in the telescope correspond to the n parameters of the
-- graph type.
-- We assume that `rest` is `def graph-name args` at the call site
telToPi : Nat → Telescope → Type → Type
telToPi (suc n) (_ ∷ tel) rest = telToPi n tel rest
telToPi zero ((s , arg (arg-info _ m) t) ∷ tel) rest =
  pi (arg (arg-info hidden m) t) (abs s (telToPi zero tel rest))
telToPi _ [] rest = rest

mkConstructor : Nat → Name → Name → Clause → TC Constructor
mkConstructor nArgs graph-name cons-name (clause tel ps t) = do
  args ← patArgsToTerms ps
  returnTC ( cons-name
           , quantity-ω
             -- We pass the arguments we got from the patterns plus
             -- simply the RHS for now
           , telToPi nArgs tel (def graph-name (args ++ (arg' visible t ∷ [])))
           )
mkConstructor _ _ _ (absurd-clause _ _) =
  typeError (strErr "mkConstructor: absurd clauses are not supported" ∷ [])

mkConstructors : Nat → Name → List Name → Definition → TC (List Constructor)
mkConstructors nArgs graph-name (name' ∷ names) (function (c ∷ cs)) = do
  con1 ← mkConstructor nArgs graph-name name' c
  rest ← mkConstructors nArgs graph-name names (function cs)
  returnTC (con1 ∷ rest)
mkConstructors _ _ [] (function []) = returnTC []
mkConstructors _ _ _ (function _) =
  typeError (strErr "mkConstructors: number of constructor names ≠ number of clauses" ∷ [])
mkConstructors _ _ _ _ =
  typeError (strErr "mkConstructors: input is not a function" ∷ [])
