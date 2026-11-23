module GraphMe.Examples.Append where

open import GraphMe
open import Agda.Builtin.Reflection
open import Agda.Builtin.Nat using (Nat)
open import Agda.Builtin.Equality using (_≡_; refl)

data List (A : Set) : Set where
  []  : List A
  _∷_ : (x : A) (xs : List A) → List A

_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

unquoteDecl data AppendGraph = emptyGraph AppendGraph (quote _++_)

_ : typeOf AppendGraph ≡ ({A : Set} → List A → List A → List A → Set)
_ = refl
