module GraphMe.Examples.Append where

open import GraphMe
open import Agda.Builtin.Reflection
open import Agda.Builtin.Nat using (Nat)
open import Agda.Builtin.Equality using (_≡_; refl)

data NatList : Set where
  []  : NatList
  _∷_ : (x : Nat) (xs : NatList) → NatList

_++_ : NatList → NatList → NatList
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

appendGraph = emptyGraph _++_

_ : typeOf appendGraph ≡ (NatList → NatList → NatList → Set)
_ = refl
