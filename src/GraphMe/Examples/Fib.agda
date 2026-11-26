module GraphMe.Examples.Fib where

open import GraphMe
open import GraphMe.Utils

open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.Nat using (Nat; zero; suc)
open import Agda.Builtin.Reflection

_+_ : Nat → Nat → Nat
zero + n = n
(suc m) + n = suc (m + n)

fib : Nat → Nat
fib zero = 0
fib (suc zero) = 1
fib (suc (suc n)) = fib (suc n) + fib n

unquoteDecl data Fib constructor base-0 base-1 step =
  mkGraph Fib (quote fib) (base-0 ∷ base-1 ∷ step ∷ []) 0

_ : typeOf Fib ≡ (Nat → Nat → Set)
_ = refl

_ : typeOf base-0 ≡ Fib 0 0
_ = refl

_ : typeOf base-1 ≡ Fib 1 1
_ = refl

-- For now this is fine
_ : typeOf step ≡ ({n : Nat} → Fib (suc (suc n)) (fib (suc n) + fib n))
_ = refl

-- For this example, we can also call `mkGraph'`,
-- without specifying the number of arguments

unquoteDecl data Fib' constructor base-0' base-1' step' =
  mkGraph' Fib' (quote fib) (base-0' ∷ base-1' ∷ step' ∷ [])

_ : typeOf Fib' ≡ (Nat → Nat → Set)
_ = refl

_ : typeOf base-0' ≡ Fib' 0 0
_ = refl

_ : typeOf base-1' ≡ Fib' 1 1
_ = refl

-- For now this is fine
_ : typeOf step' ≡ ({n : Nat} → Fib' (suc (suc n)) (fib (suc n) + fib n))
_ = refl
