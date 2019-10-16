(defpackage :test-grammar
  (:use :cl))

(peg:into-package "TEST-GRAMMAR")

(in-package :test-grammar)

(defun test ()
  (let ((parsed (peg:fullpeg
                 "
Expr <- Sum
Sum <- Product (('+' / '-') Product)*
Product <- Value (('*' / '/') Value)*
Value <- [0-9]+ / '(' Expr ')'
")))
    (eval parsed)    
    (esrap:parse 'test-grammar::Expr "((1+2)*3)/4")))