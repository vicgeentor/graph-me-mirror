module GraphMe.Examples.Append where

open import GraphMe
open import Agda.Builtin.Reflection

data List (A : Set) : Set where
  []  : List A
  _∷_ : (x : A) (xs : List A) → List A

_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)
