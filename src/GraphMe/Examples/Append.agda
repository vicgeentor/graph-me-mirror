module GraphMe.Examples.Append where

open import GraphMe
open import GraphMe.Utils hiding (_++_)

open import Agda.Builtin.Reflection
open import Agda.Builtin.Nat using (Nat)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)

_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

unquoteDecl data Append constructor base step =
  mkGraph Append (quote _++_) (base ∷ step ∷ []) 1

_ : typeOf Append ≡ ({A : Set} → List A → List A → List A → Set)
_ = refl

_ : typeOf base ≡ ({A : Set} {ys : List A} → Append [] ys ys)
_ = refl

-- For now this is fine
_ : typeOf step ≡ ( {A : Set} {x : A} {xs ys : List A}
                  → Append (x ∷ xs) ys (x ∷ (xs ++ ys)))
_ = refl

-- For this example, we can also call `mkGraph'`,
-- without specifying the number of arguments

unquoteDecl data Append' constructor base' step' =
  mkGraph' Append' (quote _++_) (base' ∷ step' ∷ [])

_ : typeOf Append' ≡ ({A : Set} → List A → List A → List A → Set)
_ = refl

_ : typeOf base' ≡ ({A : Set} {ys : List A} → Append' [] ys ys)
_ = refl

-- For now this is fine
_ : typeOf step' ≡ ( {A : Set} {x : A} {xs ys : List A}
                  → Append' (x ∷ xs) ys (x ∷ (xs ++ ys)))
_ = refl
