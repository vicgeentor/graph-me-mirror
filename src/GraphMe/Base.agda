module GraphMe.Base where

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)

-- this allows for do-notation
_>>=_ : ∀ {a b} {A : Set a} {B : Set b} → TC A → (A → TC B) → TC B
_>>=_ = bindTC

_>>_ : ∀ {a b} {A : Set a} {B : Set b} → TC A → TC B → TC B
_>>_ = λ p q → p >>= (λ _ → q)

-- Default argument generator.
-- For now we use arguments with a default relevance and quantity
arg' : {A : Set} → Visibility → A → Arg A
arg' v = arg (arg-info v (modality relevant quantity-ω))

macro
  -- Useful for testing
  typeOf : Name → Term → TC ⊤
  typeOf n hole = do
    ty ← getType n
    unify hole ty
