(peg:into-package :grammar-test)

(peg:rules
    new-grammar::Top 
  "Three-x Abc Three-y"
  (:destructure (a b c)
   (format *standard-output* "found Top ~S ~S ~S~%" a b c)))

(peg:rules
    new-grammar::Abc
    "'abc'"
    (:lambda (s)
     (format *standard-output* "found Abc~%")
     s))

(peg:rules
    new-grammar::Three-x
    "X X X"
    (:destructure (a b c) 
     (format *standard-output* "found Three~%")
     (list a b c)))

(peg:rules
    new-grammar::X
    "'x'"
    (:lambda (s)
     (format *standard-output* "found X~%")
     s))

(peg:rules 
    new-grammar::Three-y
    "Y Y Y"
  (:destructure (a b c)
   (format *standard-output* "found Three-y~%")
   (list a b c)))

(peg:rules 
    new-grammar::Y
    "'y'"
  (:lambda (s)
   (format *standard-output* "found Y~%")
   s))

