(peg:into-package "TEST-GRAMMAR")

(peg:multiple-rules

  test-grammar::Sexpr "'(' NotRpar* ')'"
  (:destructure (a b c)
   (format *standard-output* "found sexp ~S ~S ~S~%" a b c) ;; message during successful parse
   (esrap:text b))  ;; return value collapses the list b into a single string

  test-grammar::NotRpar "! ')' ."
  (:destructure (nothing x)
   (declare (ignore nothing)) ;; "! <something>" returns NIL
   x))
