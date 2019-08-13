(defpackage :peg
  (:use :cl)
  (:export
   #:into-package
   #:rules
   #:parser))

(defpackage :PEG-GRAMMAR
  (:use :cl)
  (:nicknames "PG")
  (:export
   #:peg))

(defpackage :new-grammar
  (:use :cl))

