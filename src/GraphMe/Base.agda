module GraphMe.Base where

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)
open import Agda.Builtin.List using ([]; _∷_)

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
  -- Useful macros for testing

  typeOf : Name → Term → TC ⊤
  typeOf n hole = do
    ty ← getType n
    unify hole ty

  showTypeOf : Name → Term → TC ⊤
  showTypeOf n _ = do
    ty ← getType n
    typeError (strErr "Type: " ∷ termErr ty ∷ strErr "\n" ∷ [])

  -- This lets us inspect how a term is built up using constructors
  -- of `Agda.Builtin.Reflection.Term` through a type error
  inspectWithError : Term → Term → TC ⊤
  inspectWithError t hole = do
    t' ← quoteTC t
    typeError (strErr "Term: " ∷ termErr t' ∷ strErr "\n" ∷ [])
