# Clauses of `_++_`

## Definition of `_++_`

```agda
_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)
```

## Clause one

```agda
clause
-- tel:
  (("A" ,
    arg (arg-info hidden (modality relevant quantity-ω))
    (agda-sort (lit 0)))
   ∷
   ("ys" ,
    arg (arg-info visible (modality relevant quantity-ω))
    (def (quote List)
     (arg (arg-info hidden (modality relevant quantity-ω))
      (def (quote Agda.Primitive.lzero) [])
      ∷
      arg (arg-info visible (modality relevant quantity-ω)) (var 0 []) ∷
      [])))
   ∷ [])
-- ps:
  (arg (arg-info hidden (modality relevant quantity-ω)) (var 1) ∷
   arg (arg-info visible (modality relevant quantity-ω))
   (con (quote []) [])
   ∷
   arg (arg-info visible (modality relevant quantity-ω)) (var 0) ∷ [])
-- t:
(var 0 [])
```

## Clause two

```agda
clause
-- tel
  (("A" ,
    arg (arg-info hidden (modality relevant quantity-ω))
    (agda-sort (lit 0)))
   ∷
   ("x" ,
    arg (arg-info visible (modality relevant quantity-ω)) (var 0 []))
   ∷
   ("xs" ,
    arg (arg-info visible (modality relevant quantity-ω))
    (def (quote List)
     (arg (arg-info hidden (modality relevant quantity-ω))
      (def (quote Agda.Primitive.lzero) [])
      ∷
      arg (arg-info visible (modality relevant quantity-ω)) (var 1 []) ∷
      [])))
   ∷
   ("ys" ,
    arg (arg-info visible (modality relevant quantity-ω))
    (def (quote List)
     (arg (arg-info hidden (modality relevant quantity-ω))
      (def (quote Agda.Primitive.lzero) [])
      ∷
      arg (arg-info visible (modality relevant quantity-ω)) (var 2 []) ∷
      [])))
   ∷ [])
-- ps:
  (arg (arg-info hidden (modality relevant quantity-ω)) (var 3) ∷
   arg (arg-info visible (modality relevant quantity-ω))
   (con (quote _∷_)
    (arg (arg-info visible (modality relevant quantity-ω)) (var 2) ∷
     arg (arg-info visible (modality relevant quantity-ω)) (var 1) ∷
     []))
   ∷
   arg (arg-info visible (modality relevant quantity-ω)) (var 0) ∷ [])
-- t:
(con (quote _∷_)
 (arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
  arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
  arg (arg-info visible (modality relevant quantity-ω)) (var 2 []) ∷
  arg (arg-info visible (modality relevant quantity-ω))
  (def (quote _++_)
   (arg (arg-info hidden (modality relevant quantity-ω)) (var 3 []) ∷
    arg (arg-info visible (modality relevant quantity-ω)) (var 1 []) ∷
    arg (arg-info visible (modality relevant quantity-ω)) (var 0 []) ∷
    []))
  ∷ []))
```
