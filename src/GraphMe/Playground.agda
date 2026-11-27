module GraphMe.Playground where

open import GraphMe.Base
open import GraphMe.Utils

open import Agda.Builtin.Bool using (Bool; false; true)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)
open import Agda.Builtin.Nat using (Nat; zero; suc; _+_)
open import Agda.Builtin.Reflection
open import Agda.Builtin.Sigma using (_,_)
open import Agda.Builtin.Unit using (⊤)

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

-- Clause counter --

-- Counts the number of clauses a function has
mkCount : (count-name : Name) → TC ⊤
mkCount count-name = do
  ty ← quoteTC (Name → Nat)
  declareDef (arg' visible count-name) ty
  defineFun count-name
    ( clause ( ("n" , arg' visible (def (quote Name) []))
             ∷ [])
             ( arg' visible (var 0)
             ∷ [])
             (lit (nat 42)) -- What to put here???
      ∷ [] )

-- `count : Name → Nat`
unquoteDecl count = mkCount count

-- tests

enumBool : Bool → Nat
enumBool false = 0
enumBool true  = 1

_ : count (quote enumBool) ≡ 42
_ = refl

-- Not what we want... let's try a macro that we can use in a term position

length : {A : Set} (xs : List A) → Nat
length []       = 0
length (x ∷ xs) = suc (length xs)

countClauses : Definition → Nat
countClauses (function cs) = length cs -- We only care about functions
countClauses _             = 0

macro
  -- You can treat this macro as a function with type `Name → Nat`
  count' : Name → Term → TC ⊤
  count' n hole = do
    d ← getDefinition n
    unify hole (lit (nat (countClauses d)))

-- tests

-- macro arguments of types `Term` and `Name` are apparently automatically
-- quoted before being passed to the macro. Very clean!
_ : count' enumBool ≡ 2
_ = refl

suc12345 : Nat → Nat
suc12345 1 = suc 1
suc12345 2 = suc 2
suc12345 3 = suc 3
suc12345 4 = suc 4
suc12345 5 = suc 5
suc12345 _ = 0

_ : count' suc12345 ≡ 6
_ = refl

-- Simple size of terms --

-- We only count constructors, but we need to search for constructors inside
-- the constructor arguments as well
countConstructors : Term → Nat
countArgs : List (Arg Term) → Nat

countConstructors (con c args) = suc (countArgs args)
countConstructors _ = 0

countArgs [] = 0
countArgs (arg i x ∷ xs) = countConstructors x + countArgs xs

macro
  size : Term → Term → TC ⊤
  size t hole = unify hole (lit (nat (countConstructors t)))

-- tests

_ : size (suc (suc (suc zero))) ≡ 4 -- Funny, but correct since we see 4 constructors
_ = refl

_ : size (1 ∷ 2 ∷ 3 ∷ 4 ∷ []) ≡ 5
_ = refl

-- _ : showTermOf ({A : Set} → List A → List A → List A → Set) ≡ Nat
-- _ = refl
