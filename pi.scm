;(define-syntax cons-stream
 ; (syntax-rules ()
  ;  ((cons-stream head tail)
   ;  (cons head (delay tail)))))
;;; file: pi_header.scm
;;;
;;; This should be included (textually) at the top of pi.scm.  All
;;; these definitions are from the textbook.

;;; cons-stream is already defined (by a macro, as a special form) in
;;; UMB Scheme

(define stream-car car)
(define (stream-cdr stream) (force (cdr stream)))
(define stream-null? null?)
(define the-empty-stream '())

(define (stream-foreach f x)
  (if (stream-null? x)
      'done
      (begin (f (stream-car x))
             (stream-foreach f (stream-cdr x)))))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define (divisible? x y) (= (remainder x y) 0))

(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
                 integers))

(define (display-stream s)
  (stream-foreach display-line s))

(define (display-line x)
  (newline)
  (display x))

(define (display-n stream n)
  (cond ((= n 0)
         (display "done")
         (newline))
        (else
         (display (car stream))
         (display " ")
         (display-n (stream-cdr stream) (- n 1)))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Takes in a list in the form (x y z...) where x,y,z are digits
;; and returns a power that is the smallest number with the same
;; number of digits as lst.
;; ==>(get-pow '(3 2 4))
;; 100
(define (get-pow lst)
  (expt 10 (- (length lst) 1)))

;;; Takes in a number and turn it into a list
; ==>(num->list 1234)
; (1 2 3 4)
(define (num->list num)
  (map (lambda (c) (- (char->integer c) (char->integer #\0)))
       (string->list
        (number->string num))))

;;; Takes a list as input and return the stream representation of that list
;; ==>(define test (list->stream '(2 3)))
;; ==>(display-stream test)
;; 2
;; 3
(define (list->stream lst)
  (cond ((null? lst) the-empty-stream)
        (else
         (cons-stream (car lst)
                      (list->stream (cdr lst))))))

;;; Takes a positive integer and a stream of digits as arguments
;; and multiply the stream of digits by the multiplier
;; ==>(define test (mult-stream 87 (list->stream '(9 8 7 4 3))))
;; ==>(display-stream test)
;; 8 5 9 6 4 1 done
(define (mult-stream m strm)
  (define (action a a-list pow instrm)
    (cond ((stream-null? instrm)
           (cond ((null? a-list) '())
                 (else
                  (cons-stream (car a-list)
                               (action a (cdr a-list) pow instrm)))))
          (else
           (cond ((and (not (null? a-list)) ;produce
                       (< (+ m (modulo a (get-pow a-list)))
                          (get-pow a-list)))
                   (cons-stream (car a-list)
                                (action (modulo a (get-pow a-list))
                                        (cdr a-list)
                                        pow
                                        instrm)))
                 (else
                   (action (+ (* a 10) (* m (stream-car instrm))) ;consume
                           (num->list (+ (* a 10) (* m (stream-car instrm))))
                           pow
                           (stream-cdr instrm))
                   )))))
  (action 0 '() 1 strm))

;(define ex-strm (list->stream '(9 8 7 4 3 6 9 1 7)))

;;;makes a 2x2 matrix
;;(a b)
;;(c d)
(define (make-mat a b c d)
  (cons a (cons b (cons c (cons d '())))))

;;select a of the 2x2 matrix
(define (sa x)
  (car x))
;;select b
(define (sb x)
  (cadr x))
;;select c
(define (sc x)
  (caddr x))
;;select d
(define (sd x)
  (cadddr x))

;;;takes two 2x2 matrices and multiply them, returning the a new
;;2x2 as result
;;(a b) (A B) = (aA+bC aB+bD) 
;;(c d) (C D)   (cA+dC cB+dD)
(define (compose m1 m2)
  (make-mat (+ (* (sa m1) (sa m2)) (* (sb m1) (sc m2)))
            (+ (* (sa m1) (sb m2)) (* (sb m1) (sd m2)))
            (+ (* (sc m1) (sa m2)) (* (sd m1) (sc m2)))
            (+ (* (sc m1) (sb m2)) (* (sd m1) (sd m2)))))

;;(a b) + (A B) = (a+A b+B)
;;(c d)   (C D)   (c+C d+D)
(define (add-m m1 m2)
  (make-mat (+ (sa m1) (sa m2))
            (+ (sb m1) (sb m2))
            (+ (sc m1) (sc m2))
            (+ (sd m1) (sd m2))))

;;;takes a 2x2 matrix and an integer as input and apply that integer to the
;; matrix
;; returning a new matrix
;; a = k(x) + (4k + 2) / 0(x) + (2k + 1)
;; ==>a
;; (2 40 0 15)
;; ==>(apply-inter a 2)
;; (4 40 0 15)
(define (apply-inter m inter)
  (make-mat (* (sa m) inter)
            (sb m)
            (* (sc m) inter)
            (sd m)))

;;==>(get-floor (apply-inter a 2))
;;2
(define (get-floor m)
  (quotient (+ (sa m) (sb m))
            (+ (sc m) (sd m))))

;;; For debugging purpose
;;Takes a 2x2 lft matrix and return the exact digit
;;a = (2 40 0 15)
;;==>(get-exact (apply-inter a 2))
;;2.933333333333333
(define (get-exact m)
  (exact->inexact (/ (+ (sa m) (sb m))
            (+ (sc m) (sd m)))))

;;;add this to each elements in the stream of lft to get the next one
;;m1 = (1 6 0 3)
;;==>(add-m m1 lft-incre)
;;(2 10 0 5)
(define lft-incre (make-mat 1 4 0 2))

;;;Takes the number to be discarded as argument and return a matrix that
;;has it's exact digits shifted to the left by 1 decimal.
;;Multiplying (10 -10*n) by a reflect the fact that we have taken away a number
;;            (0     1 )
;;a = (2 40 0 15)
;;==>(get-exact (apply-inter a 3))
;;3.066666666666667
;;==>(get-exact (apply-inter (compose (ashift 3) a) 3))
;;0.6666666666666666
(define (a-shift n)
  (make-mat 10 (* -10 n) 0 1))

;;infinite stream of (make-mat 1 4 0 2)
(define lft-incres (cons-stream lft-incre lft-incres))

;;for adding (make-mat 1 4 0 2) to matrices in inf-lft
(define (my-add-strms s1 s2)
  (stream-map add-m s1 s2))

;;;Infinite stream of linear fractional transformations, each one represented
;;as a matrix
(define inf-lft (cons-stream (make-mat 3 14 0 7)
                             (my-add-strms lft-incres inf-lft)))

;;;Creates an infinite stream of pi digits
;;==>(display-n (pi) 6)
;;3 1 4 1 5 9 done
(define (pi)
  (define (action a in-strm)
    (let ((floor1 (get-floor (apply-inter a 3)))
          (floor2 (get-floor (apply-inter a 4))))
      (cond ((= floor1 floor2) ;same floor
             (let ((shifted (compose (a-shift floor1) a))) ;produce
               (cons-stream floor1 (action shifted in-strm))))
            (else                                         ;else consume
             (action (compose a (stream-car in-strm))
                     (stream-cdr in-strm))))))
  (action (make-mat 2 40 0 15) inf-lft))

;(define m1 (make-mat 1 6 0 3))
;(define m2 (add-m m1 lft-incre))
;(define m3 (add-m m2 lft-incre))
;(define m4 (add-m m3 lft-incre))
;(define a (compose m1 m2))
;(define a01 (compose a m3))
;(define a02 (compose a01 m4))
