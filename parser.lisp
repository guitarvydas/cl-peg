(cl-peg:into-package "TEST-GRAMMAR")

(cl-peg:rule
    test-grammar::Top 
  "Three-x Abc Three-y"
  (:destructure (a b c)
   (format *standard-output* "found Top ~S ~S ~S~%" a b c)))

(cl-peg:rule
    test-grammar::Abc
    "'abc'"
    (:lambda (s)
     (format *standard-output* "found Abc~%")
     s))

(cl-peg:rule
    test-grammar::Three-x
    "X X X"
    (:destructure (a b c) 
     (format *standard-output* "found Three~%")
     (list a b c)))

(cl-peg:rule
    test-grammar::X
    "'x'"
    (:lambda (s)
     (format *standard-output* "found X~%")
     s))

(cl-peg:rule 
    test-grammar::Three-y
    "Y Y Y"
  (:destructure (a b c)
   (format *standard-output* "found Three-y~%")
   (list a b c)))

(cl-peg:rule 
    test-grammar::Y
    "'y'"
  (:lambda (s)
   (format *standard-output* "found Y~%")
   s))

