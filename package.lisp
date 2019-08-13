(defpackage :peg
  (:use :cl)
  (:export
   #:into-package
   #:rules
   #:parser
   #:peg-package))

(defpackage :PEG-GRAMMAR
  (:use :cl)
  (:nicknames "PG")
  (:export
   #:peg))

(defpackage :test-grammar
  (:use :cl))

