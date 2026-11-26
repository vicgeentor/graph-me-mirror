module GraphMe.Utils where

open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit using (⊤)

-- This allows for do-notation
_>>=_ : ∀ {a b} {A : Set a} {B : Set b} → TC A → (A → TC B) → TC B
_>>=_ = bindTC

_>>_ : ∀ {a b} {A : Set a} {B : Set b} → TC A → TC B → TC B
_>>_ = λ p q → p >>= (λ _ → q)

-- Default argument generator.
-- For now we use arguments with a default relevance and quantity
arg' : {A : Set} → Visibility → A → Arg A
arg' v = arg (arg-info v (modality relevant quantity-ω))

_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

macro
  -- Useful macros for testing --

  typeOf : Name → Term → TC ⊤
  typeOf name' hole = do
    ty ← getType name'
    unify hole ty

  -- The following helpers let us inspect how a term is built up using
  -- constructors of `Agda.Builtin.Reflection.Term` or similar structures
  -- through type errors

  showTypeOf : Name → Term → TC ⊤
  showTypeOf name' _ = do
    ty ← getType name'
    typeError (strErr "Type: " ∷ termErr ty ∷ strErr "\n" ∷ [])

  showTermOf : Term → Term → TC ⊤
  showTermOf t _ = do
    t' ← quoteTC t
    typeError (strErr "Term: " ∷ termErr t' ∷ strErr "\n" ∷ [])

  showClausesOf : Name → Term → TC ⊤
  showClausesOf name' _ = do
    function cs ← getDefinition name'
      where _ → typeError (strErr "not a function" ∷ [])
    cs' ← quoteTC cs
    typeError (strErr "Clauses " ∷ termErr cs' ∷ strErr "\n" ∷ [])

  showConstructor : Name → Term → TC ⊤
  showConstructor name' _ = do
    ty ← getType name'
    ty' ← quoteTC ty
    typeError (strErr "Type: " ∷ termErr ty' ∷ strErr "\n" ∷ [])
