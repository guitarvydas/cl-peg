(peg:into-package "TEST-GRAMMAR")

(peg:multiple-rules

  test-grammar::Sexpr4 "LPAR NotRpar4* RPAR"
  (:destructure (a b c)
   (format *standard-output* "found sexp4 ~S ~S ~S~%" a b c) ;; message during successful parse
   (esrap:text b))  ;; return value collapses the list b into a single string

  test-grammar::LPAR "'('" (:lambda (lp) lp)
  test-grammar::RPAR "')'" (:lambda (rp) rp)

  test-grammar::NotRpar4 "! RPAR ."
  (:destructure (nothing x)
   (declare (ignore nothing)) ;; "! <something>" returns NIL
   x))
