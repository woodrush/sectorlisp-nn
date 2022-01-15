((LAMBDA (u0 umax fracbitsize 1 digitlist
          _ addhalf _ addfull _ uaddnofc _ uaddnof _ umultnof
          _ take _ drop _ ufixmult _ negate _ + _ - _ * _ isnegative _ < _ >
          _ << _ vdot _ vecmatmulVAT _ matmulABT _ ReLUscal _ ReLUvec
          _ vecadd _ vecargmax _ nth _ nn _ PRINT
          _ img2vec _ A_1_T _ B_1 _ A_2_T _ B_2 _ printimg _ input)
   ((LAMBDA (_ _ _ _ _ _) (nn input))
      (PRINT (QUOTE (Input:)))(PRINT)
      (printimg input)(PRINT)
      (PRINT (QUOTE (Your digit is:)))(PRINT)))
 (QUOTE (0  0 0 0 0  0 0 0 0  0 0 0 0    0 0 0 0 0))
 (QUOTE (1  1 1 1 1  1 1 1 1  1 1 1 1    1 1 1 1 1))
 (QUOTE (1  1 1 1 1  1 1 1 1  1 1 1 1))
 (QUOTE (0  0 0 0 0  0 0 0 0  0 0 0 0    1 0 0 0 0))
 (QUOTE (0 1 2 3 4 5 6 7 8 9))
 (QUOTE
   ;; addhalf : Half adder
   ;;           Output binary is in reverse order (the msb is at the end)
   ;;           The same applies to the entire system
 )
 (QUOTE (LAMBDA (X Y)
   (COND
     ((EQ X (QUOTE 1))
      (COND
        ((EQ Y (QUOTE 1)) (CONS (QUOTE 0) (QUOTE 1)))
        ((QUOTE T) (CONS (QUOTE 1) (QUOTE 0)))))
     ((QUOTE T)
      (CONS Y (QUOTE 0))))))
 (QUOTE
   ;; addfull : Full adder
 )
 (QUOTE (LAMBDA (X Y C)
   ((LAMBDA (XY)
    (COND
      ((EQ (QUOTE 1) (CAR XY))
       (COND
         ((EQ (QUOTE 1) C) (CONS (QUOTE 0) (QUOTE 1)))
         ((QUOTE T) (CONS (QUOTE 1) (QUOTE 0)))))
      ((QUOTE T) (CONS C (CDR XY)))))
    (addhalf X Y))))
 (QUOTE
   ;; uaddnofc : Unsigned N-bit add with carry
 )
 (QUOTE (LAMBDA (X Y C)
   (COND
     ((EQ NIL X) Y)
     ((EQ NIL Y) X)
     ((QUOTE T)
      ((LAMBDA (XYC)
         (CONS (CAR XYC) (uaddnofc (CDR X) (CDR Y) (CDR XYC))))
       (addfull (CAR X) (CAR Y) C))))))
 (QUOTE
   ;; uaddnof : Unsigned N-bit add
 )
 (QUOTE (LAMBDA (X Y)
   (uaddnofc X Y (QUOTE 0))))
 (QUOTE
   ;; umultnof : Unsigned N-bit mult
 )
 (QUOTE (LAMBDA (X Y)
   (COND
     ((EQ NIL Y) u0)
     ((QUOTE T)
      (uaddnof (COND
               ((EQ (QUOTE 0) (CAR Y)) u0)
               ((QUOTE T) X))
             (umultnof (CONS (QUOTE 0) X) (CDR Y)))))))
 (QUOTE
   ;; take : Take a list of (len L) atoms from X
 )
 (QUOTE (LAMBDA (L X)
   (COND
     ((EQ NIL L) NIL)
     ((QUOTE T) (CONS (CAR X) (take (CDR L) (CDR X)))))))
 (QUOTE
   ;; drop : Drop the first (len L) atoms from X
 )
 (QUOTE (LAMBDA (L X)
   (COND
     ((EQ NIL X) NIL)
     ((EQ NIL L) X)
     ((QUOTE T) (drop (CDR L) (CDR X))))))
 (QUOTE
   ;; ufixmult : Unsigned fixed point multiplication
 )
 (QUOTE (LAMBDA (X Y)
   (take u0 (drop fracbitsize (umultnof X Y)))))
 (QUOTE
   ;; negate : Two's complement of int
 )
 (QUOTE (LAMBDA (N)
   (take u0 (umultnof N umax))))
 (QUOTE
   ;; +
 )
 (QUOTE (LAMBDA (X Y)
   (take u0 (uaddnof X Y (QUOTE 0)))))
 (QUOTE
   ;; -
 )
 (QUOTE (LAMBDA (X Y)
   (take u0 (uaddnof X (negate Y) (QUOTE 0)))))
 (QUOTE
   ;; *
 )
 (QUOTE (LAMBDA (X Y)
   (COND
     ((< X u0)
      (COND
        ((< Y u0)
         (ufixmult (negate X) (negate Y)))
        ((QUOTE T)
         (negate (ufixmult (negate X) Y)))))
     ((< Y u0)
      (negate (ufixmult X (negate Y))))
     ((QUOTE T)
      (ufixmult X Y)))))
 (QUOTE
   ;; isnegative
 )
 (QUOTE (LAMBDA (X)
   (EQ (QUOTE 1) (CAR (drop (CDR u0) X)))))
 (QUOTE
   ;; <
 )
 (QUOTE (LAMBDA (X Y)
   (COND
     ((isnegative X) (COND
                       ((isnegative Y) (isnegative (- (negate Y) (negate X))))
                       ((QUOTE T) (QUOTE T))))
     ((QUOTE T) (COND
                  ((isnegative Y) NIL)
                  ((QUOTE T) (isnegative (- X Y))))))))
 (QUOTE
   ;; >
 )
 (QUOTE (LAMBDA (X Y)
   (< Y X)))
 (QUOTE
   ;; << : Shift X by Y_u bits, where Y_u is in unary.
   ;;      Note that since the bits are written in reverse order,
   ;;      this works as division and makes the input number smaller.
 )
 (QUOTE (LAMBDA (X Y_u)
   (+ (drop Y_u X) u0)))
 (QUOTE
   ;; ================================================================
   ;; vdot : Vector dot product
 )
 (QUOTE (LAMBDA (X Y)
   (COND
     (X (+ (* (CAR X) (CAR Y)) (vdot (CDR X) (CDR Y))))
     ((QUOTE T) u0))))
 (QUOTE
   ;; vecmatmulVAT : vec, mat -> vec : Vector V times transposed matrix A
 )
 (QUOTE (LAMBDA (V AT)
   ((LAMBDA (vecmatmulVAThelper)
      (vecmatmulVAThelper AT))
    (QUOTE (LAMBDA (AT)
      (COND
        (AT (CONS (vdot V (CAR AT)) (vecmatmulVAThelper (CDR AT))))
        ((QUOTE T) NIL)))))))
 (QUOTE
   ;; matmulABT : mat, mat -> mat : Matrix A times transposed matrix B
 )
 (QUOTE (LAMBDA (A BT)
   ((LAMBDA (matmulABThelper)
      (matmulABThelper A))
    (QUOTE (LAMBDA (A)
      (COND
        (A (CONS (vecmatmulVAT (CAR A) BT) (matmulABThelper (CDR A))))
        ((QUOTE T) NIL)))))))
 (QUOTE
   ;; ReLUscal
 )
 (QUOTE (LAMBDA (X)
   (COND
     ((isnegative X) u0)
     ((QUOTE T) X))))
 (QUOTE
   ;; ReLUvec
 )
 (QUOTE (LAMBDA (V)
   (COND
     (V (CONS (ReLUscal (CAR V)) (ReLUvec (CDR V))))
     ((QUOTE T) NIL))))
 (QUOTE
   ;; vecadd
 )
 (QUOTE (LAMBDA (X Y)
   (COND
     (X (CONS (+ (CAR X) (CAR Y)) (vecadd (CDR X) (CDR Y))))
     ((QUOTE T) NIL))))
 (QUOTE
   ;; vecargmax
 )
 (QUOTE (LAMBDA (X)
   ((LAMBDA (vecargmaxhelper)
     (vecargmaxhelper (CDR X) (CAR X) () (QUOTE (*))))
    (QUOTE (LAMBDA (X curmax maxind curind)
      (COND
        (X (COND
             ((< curmax (CAR X)) (vecargmaxhelper
                                   (CDR X)
                                   (CAR X)
                                   curind
                                   (CONS (QUOTE *) curind)))
             ((QUOTE T) (vecargmaxhelper
                                   (CDR X)
                                   curmax
                                   maxind
                                   (CONS (QUOTE *) curind)))))
        ((QUOTE T) maxind)))))))
 (QUOTE
   ;; nth
 )
 (QUOTE (LAMBDA (N L)
   (COND
     (N (nth (CDR N) (CDR L)))
     ((QUOTE T) (CAR L)))))
 (QUOTE
   ;; nn
 )
 (QUOTE (LAMBDA ()
   (nth
     (vecargmax
       (vecadd
         B_2
         (vecmatmulVAT (ReLUvec (vecadd B_1
                                        (vecmatmulVAT (img2vec input)
                                                      A_1_T)))
                       A_2_T)))
     digitlist)
 ))
 (QUOTE
   ;; PRINT - Backwards compatibility
 )
 (QUOTE (LAMBDA () ()))
 (QUOTE
   ;; img2vec
 )
 (QUOTE (LAMBDA (img)
   (COND
     (img (CONS (COND
                  ((EQ (CAR img) (QUOTE *)) 1)
                  ((QUOTE T) u0))
                (img2vec (CDR img))))
     ((QUOTE T) NIL))))
 (QUOTE
   ;; A_1_T
 )
 (QUOTE
(
((1 0 1 1 0 1 0 0 1 1 1 1 1 0 0 0 0 0)(0 0 1 0 1 1 0 1 1 1 0 0 1 1 1 1 1 1)(1 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1)(0 1 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0 0)(0 0 1 0 0 1 0 0 1 0 1 1 0 1 1 1 1 1)(1 1 0 1 1 0 0 0 0 0 1 1 1 1 1 1 1 1)(0 1 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0)(0 0 0 1 0 1 0 1 0 0 1 1 1 0 0 0 0 0)(0 1 0 1 0 0 0 1 0 1 1 0 0 0 0 0 0 0)(0 1 1 0 0 1 0 1 1 1 1 0 1 0 1 1 1 1)(0 1 0 0 1 0 1 0 0 0 0 1 1 1 1 1 1 1)(0 1 0 0 0 0 1 0 0 1 0 1 0 0 0 0 0 0)(1 0 1 1 0 0 0 0 1 0 1 0 1 1 1 1 1 1)(1 1 0 1 1 1 0 0 0 0 1 1 0 0 0 0 0 0)(1 0 1 1 1 1 0 0 1 0 1 0 1 1 1 1 1 1))
((1 1 0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0)(1 1 0 0 1 0 1 1 0 0 0 1 0 0 0 0 0 0)(1 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1)(0 1 0 0 0 1 1 0 1 0 1 1 0 0 0 0 0 0)(1 1 0 1 1 0 1 0 0 0 1 0 1 0 0 0 0 0)(0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 1 1 1)(1 1 1 1 0 1 1 1 1 0 1 0 0 0 0 0 0 0)(1 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 1 1)(1 1 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0 0)(1 0 0 1 1 0 0 1 0 0 0 1 1 1 1 1 1 1)(0 0 1 0 0 0 1 0 1 0 0 0 0 1 0 0 0 0)(0 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1)(0 1 1 0 1 1 0 1 1 1 1 1 0 0 0 0 0 0)(0 0 1 0 1 0 0 1 1 0 1 1 0 0 0 0 0 0)(0 0 0 0 1 1 0 0 1 0 1 1 0 1 1 1 1 1))
((0 1 0 1 0 1 1 1 0 1 1 0 1 1 1 1 1 1)(0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 1 1)(0 0 1 1 1 1 0 0 0 1 1 0 1 1 1 1 1 1)(0 0 1 0 1 0 1 0 1 1 0 1 1 1 1 1 1 1)(1 0 0 1 1 0 1 1 0 1 0 0 1 1 1 1 1 1)(0 0 1 1 0 1 0 1 0 1 0 0 1 1 1 1 1 1)(1 0 0 1 0 0 0 1 0 1 1 1 0 0 0 0 0 0)(1 1 0 1 1 1 1 0 1 0 1 1 1 1 1 1 1 1)(1 1 0 1 1 0 0 0 1 1 0 0 1 1 1 1 1 1)(1 0 0 0 0 0 0 1 1 1 0 0 1 1 1 1 1 1)(0 1 1 1 1 0 0 0 0 1 0 0 1 1 1 1 1 1)(0 0 1 1 1 0 1 0 0 1 1 1 1 1 1 1 1 1)(0 0 0 0 0 0 0 1 1 0 0 1 1 1 1 1 1 1)(1 1 0 0 1 1 1 1 0 1 0 0 0 0 0 0 0 0)(0 0 0 0 1 1 1 1 0 1 0 1 1 1 1 1 1 1))
((0 0 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0)(0 1 0 1 0 1 1 0 0 1 0 0 0 1 1 1 1 1)(0 0 1 0 0 1 0 1 1 1 1 1 0 1 1 1 1 1)(1 1 0 1 1 0 0 0 1 0 1 0 0 1 0 0 0 0)(1 0 1 0 1 1 0 0 0 1 0 0 1 1 1 1 1 1)(0 1 1 0 0 0 1 1 1 1 0 0 1 0 0 0 0 0)(1 0 1 1 1 1 0 1 1 0 0 0 1 0 0 0 0 0)(1 1 1 1 0 1 1 0 0 1 1 0 0 0 0 0 0 0)(1 0 1 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0)(0 0 0 1 1 1 0 1 0 1 0 1 1 1 1 1 1 1)(1 0 0 1 0 1 1 0 0 1 1 1 1 1 1 1 1 1)(1 1 1 1 0 1 1 0 0 0 1 1 0 0 0 0 0 0)(0 1 0 1 0 1 1 1 1 0 0 0 0 0 0 0 0 0)(0 0 0 1 1 1 0 1 0 1 1 0 1 1 1 1 1 1)(0 0 1 1 0 1 1 0 1 0 1 1 1 1 1 1 1 1))
((0 1 1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0)(0 0 0 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1)(0 1 0 0 0 0 0 1 0 0 1 1 0 0 0 0 0 0)(0 0 0 1 0 0 1 0 0 0 1 0 0 0 0 0 0 0)(1 1 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1 1)(0 1 0 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1)(1 1 1 0 0 0 1 1 0 1 0 1 0 0 0 0 0 0)(0 0 1 0 1 0 0 0 1 1 1 1 0 0 0 0 0 0)(1 0 0 1 0 0 1 0 0 1 1 0 1 1 1 1 1 1)(0 1 1 1 1 1 1 1 0 1 0 0 1 1 1 1 1 1)(1 0 1 1 1 0 1 0 0 1 0 0 1 1 1 1 1 1)(0 1 1 0 1 0 0 0 0 1 0 1 1 0 0 0 0 0)(0 0 1 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0)(0 0 1 0 1 0 1 0 0 1 0 1 1 0 0 0 0 0)(1 1 0 1 1 1 0 0 1 1 1 0 1 1 1 1 1 1))
((0 1 0 1 1 1 1 0 1 0 1 1 0 0 0 0 0 0)(0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)(0 0 1 1 0 0 0 0 1 1 0 0 1 1 1 1 1 1)(0 1 1 0 0 0 1 0 1 1 1 0 1 1 1 1 1 1)(0 1 1 0 0 0 0 1 0 1 1 0 1 1 1 1 1 1)(0 0 0 1 0 1 0 1 0 0 1 1 1 1 1 1 1 1)(0 0 0 1 0 1 1 1 0 1 0 0 0 0 0 0 0 0)(1 1 0 0 0 1 0 0 1 1 0 0 0 0 0 0 0 0)(1 0 0 0 0 0 1 1 0 1 1 0 1 1 1 1 1 1)(1 1 1 1 0 0 1 1 1 1 0 1 1 1 1 1 1 1)(1 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1)(1 1 0 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0)(1 0 0 0 1 1 1 0 0 0 0 0 1 1 1 1 1 1)(1 1 0 1 0 0 0 0 1 0 1 1 0 0 0 0 0 0)(1 0 0 1 0 1 1 0 0 0 1 1 1 1 1 1 1 1))
((0 0 1 1 0 1 1 1 0 1 0 1 1 1 1 1 1 1)(0 1 1 0 1 0 1 1 1 0 0 0 1 0 0 0 0 0)(0 0 0 0 1 0 0 1 1 0 0 0 0 0 0 0 0 0)(0 0 0 0 1 1 1 0 1 0 0 1 1 0 0 0 0 0)(0 0 1 1 0 0 0 1 0 0 0 1 1 1 1 1 1 1)(0 1 1 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0)(1 0 0 1 0 1 1 1 1 0 1 1 0 1 1 1 1 1)(1 1 0 1 1 1 0 1 1 1 0 1 0 1 1 1 1 1)(0 1 1 0 1 1 0 0 0 0 0 1 0 0 0 0 0 0)(1 1 0 0 0 0 1 1 1 0 1 1 1 1 1 1 1 1)(1 0 0 0 0 1 1 0 0 0 1 0 1 1 1 1 1 1)(0 0 1 1 0 0 1 1 0 1 1 0 0 0 0 0 0 0)(1 0 0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0)(0 1 1 1 1 0 1 1 1 0 0 0 0 1 0 0 0 0)(1 1 1 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0))
((0 1 1 1 1 0 1 0 0 1 0 0 1 1 1 1 1 1)(0 0 1 1 0 0 1 1 1 0 1 1 0 1 1 1 1 1)(0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0)(1 1 1 1 1 0 1 1 0 0 0 0 1 0 0 0 0 0)(0 0 1 1 1 1 1 1 1 0 1 1 0 0 0 0 0 0)(0 0 1 1 1 0 0 0 1 1 0 1 1 0 0 0 0 0)(0 0 1 0 0 0 0 1 1 0 0 1 0 0 0 0 0 0)(0 1 1 0 0 0 0 0 0 0 1 0 1 1 1 1 1 1)(0 0 1 0 0 0 1 0 1 0 1 1 0 0 0 0 0 0)(1 1 0 1 0 1 1 1 1 1 0 0 0 1 1 1 1 1)(0 0 1 1 0 1 1 1 0 0 1 0 1 1 1 1 1 1)(0 0 0 0 0 1 0 1 1 1 1 0 1 0 0 0 0 0)(1 1 0 1 0 1 0 0 0 1 0 1 0 1 1 1 1 1)(1 0 0 1 0 1 0 0 0 0 0 0 0 1 1 1 1 1)(0 1 1 1 1 1 0 0 0 0 0 0 1 0 0 0 0 0))
((1 1 1 1 0 0 0 1 1 0 1 1 1 0 0 0 0 0)(1 0 1 1 1 0 1 0 1 0 0 1 1 0 0 0 0 0)(0 0 1 1 1 1 0 0 0 1 1 0 1 0 0 0 0 0)(1 0 1 0 0 0 1 1 1 1 0 1 0 1 1 1 1 1)(0 1 0 0 0 1 1 0 1 1 0 0 0 1 1 1 1 1)(1 1 0 1 1 1 0 0 1 1 0 1 0 0 0 0 0 0)(0 1 1 0 1 0 0 0 1 1 0 1 0 1 1 1 1 1)(0 0 0 1 0 0 0 1 1 0 1 1 0 1 1 1 1 1)(0 1 1 1 1 0 0 0 1 1 1 0 1 1 1 1 1 1)(1 1 0 0 1 1 1 1 0 1 0 1 0 0 0 0 0 0)(1 0 0 0 1 1 0 1 1 0 1 0 1 0 0 0 0 0)(1 0 1 0 0 1 0 1 0 1 0 1 1 1 1 1 1 1)(1 1 0 1 0 0 1 1 1 0 1 1 1 1 1 1 1 1)(0 1 1 1 1 0 1 0 1 1 0 0 1 1 1 1 1 1)(1 1 1 1 1 1 0 1 1 1 0 0 1 1 1 1 1 1))
((1 1 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0)(1 0 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0)(0 1 0 1 1 0 0 1 1 1 1 0 1 1 1 1 1 1)(0 0 1 0 1 1 0 0 1 1 0 1 1 1 1 1 1 1)(1 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 1 1)(0 0 0 1 0 1 1 1 0 1 0 0 1 1 1 1 1 1)(0 0 0 1 0 1 1 1 1 0 0 1 0 0 0 0 0 0)(1 0 1 0 1 0 0 0 0 0 1 0 1 1 1 1 1 1)(0 1 0 0 1 1 0 1 1 0 1 1 1 1 1 1 1 1)(0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 1 1)(0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0)(0 1 0 1 0 0 1 0 1 1 0 1 1 1 1 1 1 1)(0 1 0 0 0 1 0 1 1 1 1 0 0 0 0 0 0 0)(1 1 0 0 0 1 1 1 0 0 1 0 1 1 1 1 1 1)(1 0 0 1 1 0 0 1 1 1 0 1 1 1 1 1 1 1))
)
)
 (QUOTE
   ;; B_1
 )
 (QUOTE
((1 0 0 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1)(1 1 1 0 0 1 1 1 1 0 1 1 0 0 0 0 0 0)(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)(0 0 1 1 0 0 1 1 1 0 0 0 0 0 0 0 0 0)(1 0 1 1 0 0 1 0 0 0 0 1 1 1 1 1 1 1)(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)(1 0 1 1 0 0 0 1 1 1 0 0 1 1 1 1 1 1)(0 1 0 1 0 0 1 0 1 1 0 1 0 0 0 0 0 0)(0 1 1 0 1 0 1 0 0 0 1 1 0 0 0 0 0 0)(0 0 0 1 0 1 1 1 0 0 1 1 1 1 1 1 1 1))
 )
 (QUOTE
   ;; A_2_T
 )
 (QUOTE
(
((1 1 0 1 1 0 0 1 0 0 1 1 1 0 1 1 1 1)(0 0 1 1 1 1 1 1 0 1 1 0 0 0 0 0 0 0)(1 0 1 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0)(1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)(1 0 1 1 1 1 1 1 0 1 1 0 1 1 1 1 1 1)(1 1 0 1 1 1 1 1 0 1 1 0 0 0 0 0 0 0)(0 1 1 1 0 0 1 0 0 0 0 1 1 0 0 0 0 0)(1 0 0 1 1 1 0 0 0 0 1 0 1 1 1 1 1 1)(1 0 1 1 1 0 1 1 1 0 0 1 1 1 1 1 1 1)(1 0 0 1 0 0 1 0 1 0 1 1 0 0 0 0 0 0))
((0 1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1)(1 1 1 0 0 0 0 1 0 0 1 1 1 0 0 0 0 0)(0 0 1 0 1 0 0 1 0 0 0 0 1 0 0 0 0 0)(0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0)(1 0 1 0 1 1 1 0 1 0 1 0 0 1 1 1 1 1)(1 0 1 0 0 0 1 1 0 0 0 1 0 0 0 0 0 0)(1 1 1 0 0 1 1 0 1 1 1 0 0 1 1 1 1 1)(0 1 0 0 1 1 0 0 0 0 0 0 1 0 0 0 0 0)(1 0 0 1 0 0 0 1 1 1 0 0 1 1 1 1 1 1)(0 1 0 0 0 1 1 0 0 1 1 0 1 1 1 1 1 1))
((0 1 1 0 1 0 0 1 0 0 0 0 1 1 1 1 1 1)(0 1 0 0 1 0 1 1 1 1 0 0 1 0 1 1 1 1)(0 0 1 0 0 1 0 0 0 0 0 0 1 1 1 1 1 1)(0 0 1 1 0 0 1 0 1 0 0 1 1 0 1 1 1 1)(1 1 0 1 0 1 0 0 1 0 1 0 1 1 1 1 1 1)(0 1 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0)(0 0 1 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0)(0 1 0 0 1 0 1 0 1 1 0 1 1 0 1 1 1 1)(0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0)(1 0 0 0 0 1 1 1 1 0 1 0 1 1 1 1 1 1))
((0 0 0 1 1 0 0 1 1 1 0 0 1 0 0 0 0 0)(0 1 1 0 0 0 0 0 1 1 0 0 1 0 1 1 1 1)(0 1 1 1 1 1 1 0 1 0 1 1 0 0 0 0 0 0)(1 0 1 1 1 0 1 1 1 0 0 0 0 1 1 1 1 1)(0 1 1 0 1 0 1 0 0 0 1 0 0 0 0 0 0 0)(1 0 0 1 0 1 0 1 0 0 0 0 1 0 0 0 0 0)(0 0 1 0 1 0 0 0 1 1 0 1 0 0 0 0 0 0)(0 0 1 1 0 1 0 1 1 0 0 0 0 1 1 1 1 1)(0 1 0 1 1 0 1 1 0 1 0 0 0 0 0 0 0 0)(1 0 0 1 1 0 1 0 0 0 1 1 1 1 1 1 1 1))
((0 0 1 1 0 0 1 1 0 0 0 1 1 0 0 0 0 0)(1 1 1 1 1 1 0 1 1 1 1 0 0 1 1 1 1 1)(1 1 1 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0)(0 0 0 0 0 1 0 1 1 0 0 0 1 0 0 0 0 0)(1 0 0 1 1 1 1 1 0 0 1 0 1 1 1 1 1 1)(0 1 1 1 0 1 1 0 0 1 1 0 0 0 0 0 0 0)(1 1 1 0 0 1 0 0 0 1 0 1 0 1 1 1 1 1)(1 0 1 1 0 0 1 1 1 0 1 1 0 0 0 0 0 0)(0 0 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 1)(0 0 1 0 1 0 0 1 1 1 1 1 0 1 1 1 1 1))
((0 0 1 0 1 0 0 1 1 1 0 0 1 0 0 0 0 0)(1 0 1 1 0 0 1 0 0 1 1 1 0 0 0 0 0 0)(1 1 0 1 0 1 1 0 1 1 1 0 1 1 1 1 1 1)(1 1 0 0 1 1 1 0 0 0 1 1 1 1 1 1 1 1)(0 1 1 1 1 0 1 1 0 0 0 1 0 0 0 0 0 0)(1 0 1 0 0 1 1 0 1 1 0 1 1 1 1 1 1 1)(1 1 1 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0)(1 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 1 1)(1 1 0 0 1 0 1 1 0 0 0 1 1 0 1 1 1 1)(1 0 1 1 1 0 0 0 1 0 1 1 0 0 0 0 0 0))
((1 0 0 0 0 1 0 0 1 1 0 1 1 1 1 1 1 1)(0 0 0 0 1 1 1 0 1 0 1 1 1 1 1 1 1 1)(1 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0)(0 0 1 0 0 0 1 1 0 1 1 0 1 1 1 1 1 1)(0 1 0 1 1 0 1 1 0 1 0 0 1 0 0 0 0 0)(0 0 1 0 0 1 1 0 0 0 0 0 1 1 1 1 1 1)(0 1 0 0 1 0 0 0 1 1 1 0 0 0 0 0 0 0)(1 1 1 1 1 0 0 0 0 1 1 1 1 0 1 1 1 1)(1 1 0 0 0 0 0 1 1 1 1 0 1 0 1 1 1 1)(1 1 0 1 0 1 0 1 1 0 0 0 0 0 0 0 0 0))
((1 1 1 1 0 0 1 1 0 1 0 1 1 1 1 1 1 1)(0 1 0 1 0 1 0 1 0 0 1 1 0 0 0 0 0 0)(1 1 1 0 0 0 0 0 1 1 0 1 1 1 1 1 1 1)(0 0 1 1 1 0 0 1 1 0 0 1 1 0 1 1 1 1)(1 0 1 0 1 1 1 0 0 0 1 1 1 0 1 1 1 1)(1 0 0 1 1 0 1 1 0 1 1 1 0 0 0 0 0 0)(1 1 1 0 0 0 1 0 1 0 1 0 1 1 1 1 1 1)(0 1 1 1 0 1 0 1 0 0 1 0 0 0 0 0 0 0)(0 1 1 0 1 1 1 0 0 0 0 0 0 1 0 0 0 0)(1 1 0 0 1 1 0 0 0 1 1 0 1 1 1 1 1 1))
((1 0 1 0 0 0 1 0 1 1 0 1 1 1 1 1 1 1)(0 0 0 1 0 0 1 1 1 0 0 0 1 0 1 1 1 1)(0 0 1 0 0 1 0 1 0 1 1 0 0 0 0 0 0 0)(0 0 1 1 1 0 1 1 0 1 0 1 0 0 0 0 0 0)(1 1 0 0 1 1 1 0 0 1 1 0 0 0 0 0 0 0)(0 0 1 0 1 1 0 0 1 1 0 0 1 1 1 1 1 1)(1 0 1 0 0 1 1 1 0 0 1 1 0 0 0 0 0 0)(1 1 1 1 0 1 0 0 0 0 0 1 1 0 1 1 1 1)(0 0 0 0 0 1 0 1 0 1 1 0 0 1 1 1 1 1)(0 0 0 1 1 0 1 0 0 1 1 0 1 1 1 1 1 1))
((1 1 0 1 1 0 1 1 0 1 0 1 0 0 0 0 0 0)(0 1 0 1 1 1 0 0 0 1 1 1 1 0 1 1 1 1)(0 0 0 1 1 0 1 0 0 1 1 1 1 1 1 1 1 1)(0 1 1 0 1 1 1 1 0 0 0 1 0 0 0 0 0 0)(1 0 1 1 0 0 1 1 1 1 0 1 0 0 0 0 0 0)(1 0 1 0 1 1 0 0 1 1 1 0 0 0 0 0 0 0)(0 0 1 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0)(1 1 1 0 1 0 1 1 0 1 1 1 1 1 1 1 1 1)(1 0 1 1 1 0 1 1 1 0 1 0 1 0 1 1 1 1)(0 1 0 0 0 1 0 1 0 0 0 1 1 1 1 1 1 1))
)
)
 (QUOTE
   ;; B_2
 )
 (QUOTE
((0 1 0 0 0 0 0 0 0 0 1 1 0 1 1 1 1 1)(1 1 1 1 0 0 1 0 1 0 1 0 1 0 0 0 0 0)(1 1 1 1 1 1 1 0 1 1 1 1 1 0 0 0 0 0)(0 1 1 1 1 0 0 1 1 0 1 0 1 1 1 1 1 1)(1 0 0 0 0 0 0 1 0 1 1 0 0 1 1 1 1 1)(0 1 0 0 1 1 0 0 1 0 1 0 0 1 1 1 1 1)(0 0 1 0 1 0 1 0 1 1 1 0 1 1 1 1 1 1)(1 1 1 0 1 1 0 1 1 0 0 0 0 0 0 0 0 0)(0 1 0 1 1 0 1 1 0 0 0 1 1 1 1 1 1 1)(1 1 1 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1))
 )
 (QUOTE
   ;; printimg
 )
 (QUOTE (LAMBDA (img)
   (COND
     (img ((LAMBDA () ())
           (PRINT (take (QUOTE (* * *)) img))
           (PRINT)
           (printimg (drop (QUOTE (* * *)) img))))
     ((QUOTE T) NIL))))
 (QUOTE
   ;; input
 )
 (QUOTE (. * .
         . * .
         . * .
         . * .
         . * .)))
