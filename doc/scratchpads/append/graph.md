# Graph of append: `Append`

## Definition of `Append`

```agda
data Append {A : Set} : List A → List A → List A → Set where
  base : {ys : List A} → Append [] ys ys
  step : {x : A} {xs ys zs : List A}
       → Append xs ys zs
       → Append (x ∷ xs) ys (x ∷ zs)
```

## `base` constructor of `Append`

```agda
pi
(arg (arg-info hidden (modality relevant quantity-ω))
 (agda-sort (lit 0)))
(abs "A"
 (pi
  (arg (arg-info hidden (modality relevant quantity-ω))
   (def (quote List)
    (arg (arg-info hidden (modality relevant quantity-ω))
     (def (quote Agda.Primitive.lzero) [])
     ∷
     arg (arg-info visible (modality relevant quantity-ω)) (var 0 []) ∷
     [])))
  (abs "ys"
   (def (quote Append)
    (arg (arg-info hidden (modality relevant quantity-ω)) (var 1 []) ∷
     arg (arg-info visible (modality relevant quantity-ω))
     (con (quote [])
      (arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
       arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷ []))
     ∷
     arg (arg-info visible (modality relevant quantity-ω)) (var 0 []) ∷
     arg (arg-info visible (modality relevant quantity-ω)) (var 0 []) ∷
     [])))))
```

## `step` constructor of `Append`

```agda
pi
(arg (arg-info hidden (modality relevant quantity-ω))
 (agda-sort (lit 0)))
(abs "A"
 (pi
  (arg (arg-info hidden (modality relevant quantity-ω)) (var 0 []))
  (abs "x"
   (pi
    (arg (arg-info hidden (modality relevant quantity-ω))
     (def (quote List)
      (arg (arg-info hidden (modality relevant quantity-ω))
       (def (quote Agda.Primitive.lzero) [])
       ∷
       arg (arg-info visible (modality relevant quantity-ω)) (var 1 []) ∷
       [])))
    (abs "xs"
     (pi
      (arg (arg-info hidden (modality relevant quantity-ω))
       (def (quote List)
        (arg (arg-info hidden (modality relevant quantity-ω))
         (def (quote Agda.Primitive.lzero) [])
         ∷
         arg (arg-info visible (modality relevant quantity-ω)) (var 2 []) ∷
         [])))
      (abs "ys"
       (pi
        (arg (arg-info hidden (modality relevant quantity-ω))
         (def (quote List)
          (arg (arg-info hidden (modality relevant quantity-ω))
           (def (quote Agda.Primitive.lzero) [])
           ∷
           arg (arg-info visible (modality relevant quantity-ω)) (var 3 []) ∷
           [])))
        (abs "zs"
         (pi
          (arg (arg-info visible (modality relevant quantity-ω))
           (def (quote Append)
            (arg (arg-info hidden (modality relevant quantity-ω)) (var 4 []) ∷
             arg (arg-info visible (modality relevant quantity-ω)) (var 2 []) ∷
             arg (arg-info visible (modality relevant quantity-ω)) (var 1 []) ∷
             arg (arg-info visible (modality relevant quantity-ω)) (var 0 []) ∷
             [])))
          (abs "_"
           (def (quote Append)
            (arg (arg-info hidden (modality relevant quantity-ω)) (var 5 []) ∷
             arg (arg-info visible (modality relevant quantity-ω))
             (con (quote _∷_)
              (arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
               arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
               arg (arg-info visible (modality relevant quantity-ω)) (var 4 []) ∷
               arg (arg-info visible (modality relevant quantity-ω)) (var 3 []) ∷
               []))
             ∷
             arg (arg-info visible (modality relevant quantity-ω)) (var 2 []) ∷
             arg (arg-info visible (modality relevant quantity-ω))
             (con (quote _∷_)
              (arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
               arg (arg-info hidden (modality relevant quantity-ω)) unknown ∷
               arg (arg-info visible (modality relevant quantity-ω)) (var 4 []) ∷
               arg (arg-info visible (modality relevant quantity-ω)) (var 1 []) ∷
               []))
             ∷ [])))))))))))))
```
