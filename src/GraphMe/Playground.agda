module GraphMe.Playground where

open import Agda.Builtin.Reflection
open import Agda.Builtin.Unit
open import Agda.Builtin.List using ([]; _∷_)
open import Agda.Builtin.Sigma using (_,_)
open import Agda.Builtin.Nat using (Nat; zero; suc)
open import Agda.Builtin.Equality using (_≡_; refl)

-- this allows for do-notation
_>>=_ : ∀ {a b} {A : Set a} {B : Set b} → TC A → (A → TC B) → TC B
_>>=_ = bindTC

_>>_ : ∀ {a b} {A : Set a} {B : Set b} → TC A → TC B → TC B
_>>_ = λ p q → p >>= (λ _ → q)

-- We can use this to define arguments with sensible defaults for now,
-- such as that they are relevant and have a non-zero quantity
arg' : {A : Set} → Visibility → A → Arg A
arg' v = arg (arg-info v (modality relevant quantity-ω))

-- identity --

-- For Nats only
defIdNat : (id-name : Name) → TC ⊤
defIdNat id-name = do
  defineFun id-name
    (
      ( clause 
          (("x" , arg' 
                    visible 
                    (def (quote Nat) []) -- This doesn't work as expected
           )
            ∷ []
          )
          (arg' visible (var 0) ∷ [])
          (var 0 []))
      ∷ []
    )

-- Why does this work? It doesn't force us to use Nats...
-- Furthermore, we can even add an implicit argument to `idNat`,
-- which doesn't cause any problems
idNat : {A : Set} (x : A) → A
unquoteDef idNat = defIdNat idNat

-- tests
_ : idNat 3 ≡ 3
_ = refl

_ : ∀ {A : Set} {x : A} → idNat x ≡ x
_ = refl

-- Let's try again, but with `unquoteDecl`

mkIdNat : (id-name : Name) → TC ⊤
mkIdNat id-name = do
  ty ← quoteTC (Nat → Nat)
  declareDef (arg' visible id-name) ty
  defineFun id-name
    ( clause (("x" , arg' visible (def (quote Nat) [])) ∷ [])
             (arg' visible (var 0) ∷ [])
             (var 0 [])
      ∷ [] )

unquoteDecl idNat' = mkIdNat idNat'

-- tests
_ : idNat' 3 ≡ 3
_ = refl

-- This is now ill-typed:
-- _ : ∀ {A : Set} {x : A} → idNat' x ≡ x
-- _ = refl

_ : ∀ {x : Nat} → idNat' x ≡ x
_ = refl

-- Let's also make a cleaner general id function, even with any Level
mkId : (id-name : Name) → TC ⊤
mkId id-name = do
  ty ← quoteTC ({A : Set} (x : A) → A)
  declareDef (arg' visible id-name) ty
  defineFun id-name
    ( clause ( ("A" , arg' hidden (agda-sort (lit 0))) -- Set₀
             ∷ ("x" , arg' visible (var 0 []))
             ∷ [])
             ( arg' hidden (var 1) 
             ∷ arg' visible (var 0) 
             ∷ [])
             (var 0 [])
      ∷ [] )

unquoteDecl id = mkId id

-- tests
_ : {A : Set} {x : A} → id x ≡ x
_ = refl
