(peg:into-package "TEST-GRAMMAR")

(peg:multiple-rules

  test-grammar::Sexpr5 "LPAR5 NotRpar5* RPAR5"
  (:destructure (a b c)
   (format *standard-output* "found sexp5 ~S ~S ~S~%" a b c) ;; message during successful parse
   (esrap:text b))  ;; return value collapses the list b into a single string

  test-grammar::LPAR5 "'(' Spacing" (:lambda (x) (declare (ignore x)) (values))
  test-grammar::RPAR5 "Spacing ')' Spacing" (:lambda (x) (declare (ignore x)) (values))

  test-grammar::NotRpar5 "! RPAR5 ! EndOfLine ."
  (:destructure (nothing nothing2 x)
   (declare (ignore nothing nothing2)) ;; "! <something>" returns NIL
   x)

  test-grammar::Spacing "(pSpace / Comment)*"
  (:lambda (list) (declare (ignore list))
    (values))

  test-grammar::Comment "'#' (!EndOfLine char1)* (EndOfLine)"
  (:lambda (list) (declare (ignore list))
    (values))

  test-grammar::char1 "."
  (:lambda (c)
    c)

  test-grammar::pSpace "' ' / '\\t' / EndOfLine"
  (:lambda (list) (declare (ignore list))
    (values))

  test-grammar::EndOfLine "'\\r\\n' / '\\n' / '\\r'"
  (:lambda (list) (declare (ignore list))
    (values)))