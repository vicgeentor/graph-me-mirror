module GraphMe.NewBase where

open import GraphMe.Utils

open import Agda.Builtin.Bool using (true; false)
open import Agda.Builtin.Int using (pos; primShowInteger)
open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.Nat using (Nat; zero; suc; _+_)
open import Agda.Builtin.Reflection
open import Agda.Builtin.Sigma using (Σ; _,_)
open import Agda.Builtin.String using (String; primStringAppend)
open import Agda.Builtin.Unit using (⊤)

-- Graph type --

-- Approach:
-- * We simply add `→ Set` to the type of the function
-- * When we call `declareData` in `GraphMe.mkGraph`, we state how many
--   indices in the generated type correspond to arguments of the graph type

mkGraphType : Type → Type
mkGraphType (pi a (abs s t)) = pi a (abs s (mkGraphType t))
mkGraphType rest = pi (arg' visible rest) (abs "_" (agda-sort (lit 0)))

-- Instead of providing the number of arguments to `mkGraph`,
-- a user can also generate the number of arguments of the graph type.
-- This function does precisely that, with the following heuristic:
-- we treat every leading argument of type `Set ℓ` in the function
-- definition as a paramater of the graph
countArgumentsHeuristic : Type → Nat
countArgumentsHeuristic (pi (arg i (agda-sort s)) (abs x t)) =
  suc (countArgumentsHeuristic t)
countArgumentsHeuristic _ = 0

-- Graph constructors --

-- Approach (TODO: update this outdated outline):
-- * We make a constructor for each clause of the function (`mkConstructor(s)`)
-- * Each item in the telescope maps to a hidden binder in the pi abstraction
--   of the constructor type, excluding the ones that correspond to
--   parameters to the graph type (`telToPi`)
-- * Each pattern in the LHS maps to a constructor argument (`patArgsToTermArgs`)
-- * The RHS (result) maps to the final constructor argument (inside `mkConstructor`)

Constructor : Set
Constructor = (Σ Name (λ _ → Σ Quantity (λ _ → Type)))

mutual
  patToTerm : Pattern → TC Term
  patToTerm (con c as) = do
    as' ← patArgsToTermArgs as
    returnTC (con c as')
  patToTerm (dot t) = returnTC t
  patToTerm (var i) = returnTC (var i []) -- It seems we can use the same De Bruijn index here
  patToTerm (lit l) = returnTC (lit l)
  patToTerm (proj _) = typeError (strErr "patToTerm: `proj` is not supported" ∷ [])
  patToTerm (absurd _) = typeError (strErr "patToTerm: `absurd` is not supported" ∷ [])

  -- The resulting term arguments represent all arguments to the final index
  -- of a constructor, except for the final argument, which is computed in `mkPi`
  patArgsToTermArgs : List (Arg Pattern) → TC (List (Arg Term))
  patArgsToTermArgs [] = returnTC []
  patArgsToTermArgs (arg i p ∷ as) = do
    p' ← patToTerm p
    as' ← patArgsToTermArgs as
    returnTC (arg i p' ∷ as')

-- This turns all items in the telescope to hidden, and converts them
-- to abstractions. We exclude the arguments to the graph by assuming that
-- the first n items in the telescope correspond to the n parameters of the
-- graph type. This should be correct, since we already made sure that we
-- have exactly n graph parameters in `mkGraphType`.
-- We assume that `rest` is `def graph-name args` at the call site
telToPi : Nat → Telescope → Type → Type
telToPi (suc n) (_ ∷ tel) rest = telToPi n tel rest
telToPi zero ((s , arg (arg-info _ m) t) ∷ tel) rest =
  pi (arg (arg-info hidden m) t) (abs s (telToPi zero tel rest))
telToPi _ [] rest = rest

mutual
  -- Makes only the final argument of a constructor
  -- TODO: improve function name
  rhsToConstructorResultArg : Name → Name → Term → TC Term
  rhsToConstructorResultArg gName fName (var x args) = returnTC (var x args)
  rhsToConstructorResultArg gName fName (con c []) =  returnTC (con c [])
  rhsToConstructorResultArg gName fName (con c (arg i t ∷ args)) =  do
      t' ← rhsToConstructorResultArg gName fName t
      args' ← convertTermArgsInResultArg gName fName args
      returnTC (con c (arg i t' ∷ args'))
  rhsToConstructorResultArg gName fName (def f args) with primQNameEquality fName f
  ...                                        | false =
    typeError (strErr "rhsToPi: calls to other functions are not supported" ∷ [])
  ...                                        | true  =
    returnTC (var 1 []) -- TODO: fix this
  rhsToConstructorResultArg _ _ _ =
    typeError (strErr "rhsToConstructorResultArg: only `var`, `con`, and `def` in the RHS are supported" ∷ [])

  convertTermArgsInResultArg : Name → Name → List (Arg Term) → TC (List (Arg Term))
  convertTermArgsInResultArg gName fName [] = returnTC []
  convertTermArgsInResultArg gName fName (arg i t ∷ args) = do
    t' ← rhsToConstructorResultArg gName fName t
    args' ← convertTermArgsInResultArg gName fName args
    returnTC (arg i t' ∷ args')

mutual
  countRecursiveCalls : Name → Term → TC Nat
  countRecursiveCalls fName (var x args) = returnTC zero
  countRecursiveCalls fName (con c args) =
    countRecursiveCallsInArgs fName args
  countRecursiveCalls fName (def f args) with primQNameEquality fName f
  ...                                        | false =
    countRecursiveCallsInArgs fName args
  ...                                        | true  = do
    zero ← countRecursiveCallsInArgs fName args
      where _ → typeError (strErr "countRecursiveCalls: nested recursion is not supported" ∷ [])
    returnTC 1
  countRecursiveCalls _ _ =
    typeError (strErr "countRecursiveCalls: only `var`, `con`, and `def` in the RHS are supported" ∷ [])

  countRecursiveCallsInArgs : Name → List (Arg Term) → TC Nat
  countRecursiveCallsInArgs fName [] = returnTC zero
  countRecursiveCallsInArgs fName (arg i t ∷ as) =  do
    nInT ← countRecursiveCalls fName t
    nInArgs ← countRecursiveCallsInArgs fName as
    returnTC (nInT + nInArgs)

-- When all these pieces are collected, wherein De Bruijn indices are already
-- shifted with the final context in mind, a constructor can be made with the
-- `assemble` function
record Pieces : Set where
  constructor ⟨_~_~_~_~_⟩
  field
    cons         : Name
    tele         : Telescope       -- These are converted to hidden args
    resultTypes  : List Type       -- Types of the fresh binders, one for each resursive call
    premiseTypes : List Type       -- Also one for each recursive call
    finalArgs    : List (Arg Term) -- Args taken from LSH pattern
                                   -- ++ RHS with recursive calls replaced with
                                   -- variables

open Pieces

assemble : Pieces → TC Constructor
assemble ⟨ cons ~ tele ~ resultTypes ~ premiseTypes ~ finalArgs ⟩ = {!!}

mkConstructor : Nat → Name → Name → Name → Clause → TC Constructor
mkConstructor nArgs graph-name func-name cons-name (clause tel ps t) = do
  resultTypes ← {!!}
  premiseTypes ← {!!}
  finalArgs ← {!!}
  let pieces = ⟨ cons-name ~ tel ~ resultTypes ~ premiseTypes ~ finalArgs ⟩
  assemble pieces
mkConstructor _ _ _ _ (absurd-clause _ _) =
  typeError (strErr "mkConstructor: absurd clauses are not supported" ∷ [])

mkConstructors : Nat → Name → Name → List Name → Definition → TC (List Constructor)
mkConstructors nArgs graph-name func-name (name' ∷ names) (function (c ∷ cs)) = do
  con1 ← mkConstructor nArgs graph-name func-name name' c
  rest ← mkConstructors nArgs graph-name func-name names (function cs)
  returnTC (con1 ∷ rest)
mkConstructors _ _ _ [] (function []) = returnTC []
mkConstructors _ _ _ _ (function _) =
  typeError (strErr "mkConstructors: number of constructor names ≠ number of clauses" ∷ [])
mkConstructors _ _ _ _ _ =
  typeError (strErr "mkConstructors: input is not a function" ∷ [])
