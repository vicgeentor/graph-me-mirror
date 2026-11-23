module GraphMe.Examples.Fib where

open import GraphMe
open import Agda.Builtin.Reflection
open import Agda.Builtin.Nat using (Nat; zero; suc)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)

_+_ : Nat → Nat → Nat
zero + n = n
(suc m) + n = suc (m + n)

fib : Nat → Nat
fib zero = 0
fib (suc zero) = 1
fib (suc (suc n)) = fib (suc n) + fib n

unquoteDecl data FibGraph = emptyGraph FibGraph (quote fib)

_ : typeOf FibGraph ≡ (Nat → Nat → Set)
_ = refl
